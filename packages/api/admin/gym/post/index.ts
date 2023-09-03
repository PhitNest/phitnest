import { z } from "zod";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  validateRequest,
  dynamo,
  Success,
  getAdminClaims,
  RequestError,
} from "typescript-core/src/utils";
import { createGym } from "typescript-core/src/repositories";
import { Address, Location } from "typescript-core/src/entities";
import axios from "axios";

export async function getLocation(
  address: Address,
): Promise<Location | RequestError> {
  const response = await axios.get(
    "https://nominatim.openstreetmap.org/search",
    {
      params: {
        q: `${address.street}, ${address.city}, ${address.state} ${address.zipCode}`.replace(
          /%20/g,
          "+",
        ),
        format: "json",
        polygon: 1,
        addressdetails: 1,
      },
    },
  );
  if (response.data && response.data.length > 0) {
    const { lon, lat } = response.data[0];
    return {
      longitude: parseFloat(lon),
      latitude: parseFloat(lat),
    };
  }
  return new RequestError(
    "CoordinatesNotFound",
    "No coordinates found for this address.",
  );
}

const validator = z.object({
  name: z.string(),
  street: z.string(),
  city: z.string(),
  state: z.string(),
  zipCode: z.string(),
});

export async function invoke(
  event: APIGatewayEvent,
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: JSON.parse(event.body ?? "{}"),
    validator: validator,
    controller: async (data) => {
      const adminClaims = getAdminClaims(event);
      const location = await getLocation(data);
      if (location instanceof RequestError) {
        return location;
      }
      const client = dynamo();
      const gym = await createGym(client, {
        adminEmail: adminClaims.email,
        name: data.name,
        address: data,
        location: location,
      });
      if (gym instanceof RequestError) {
        return gym;
      }
      return new Success({
        gymId: gym.id,
        location: gym.gymLocation,
      });
    },
  });
}
