import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import {
  validateRequest,
  dynamo,
  Success,
  getAdminClaims,
  RequestError,
} from "common/utils";
import { Address, Location, gymToDynamo } from "common/entities";
import * as uuid from "uuid";

import axios from "axios";

export class CoordinatesNotFound extends RequestError {
  constructor() {
    super("CoordinatesNotFound", "No coordinates found for this address.");
  }
}

/**
 * Gets the longitude and latitude of an address.
 *
 * @param address The address to get the location of.
 * @returns The longitude and latitude of the address, or an OpenStreetMapError if the address could not be found.
 */
async function getLocation(
  address: Address
): Promise<Location | CoordinatesNotFound> {
  const response = await axios.get(
    "https://nominatim.openstreetmap.org/search",
    {
      params: {
        q: `${address.street}, ${address.city}, ${address.state} ${address.zipCode}`.replace(
          /%20/g,
          "+"
        ),
        format: "json",
        polygon: 1,
        addressdetails: 1,
      },
    }
  );
  if (response.data && response.data.length > 0) {
    const { lon, lat } = response.data[0];
    return {
      longitude: parseFloat(lon),
      latitude: parseFloat(lat),
    };
  }
  return new CoordinatesNotFound();
}

const validator = z.object({
  name: z.string(),
  street: z.string(),
  city: z.string(),
  state: z.string(),
  zipCode: z.string(),
});

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: JSON.parse(event.body ?? "{}"),
    validator: validator,
    controller: async (data) => {
      const adminClaims = getAdminClaims(event);
      const location = await getLocation(data);
      if (location instanceof CoordinatesNotFound) {
        return location;
      } else {
        const client = dynamo();
        const gymId = uuid.v4();
        await client.put({
          pk: "GYMS",
          sk: `GYM#${gymId}`,
          data: gymToDynamo({
            id: gymId,
            createdAt: new Date(),
            adminEmail: adminClaims.email,
            gymName: data.name,
            address: {
              street: data.street,
              city: data.city,
              state: data.state,
              zipCode: data.zipCode,
            },
            gymLocation: location,
          }),
        });
        return new Success({
          gymId: gymId,
          location: location,
        });
      }
    },
  });
}
