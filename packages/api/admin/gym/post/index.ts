import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import {
  RequestError,
  Success,
  dynamo,
  getAdminClaims,
  validateRequest,
} from "typescript-core/src/utils";
import { gymKey } from "typescript-core/src/repositories";
import { Address, Location, gymToDynamo } from "typescript-core/src/entities";
import axios from "axios";

async function getLocation(address: Address): Promise<Location | RequestError> {
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
  street: z.string(),
  city: z.string(),
  state: z.string(),
  zipCode: z.string(),
  gymName: z.string(),
  adminFirstName: z.string(),
  adminLastName: z.string(),
});

export async function invoke(
  event: APIGatewayEvent,
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: JSON.parse(event.body ?? "{}"),
    validator: validator,
    controller: async (data) => {
      const adminClaims = getAdminClaims(event);
      const address = {
        street: data.street,
        city: data.city,
        state: data.state,
        zipCode: data.zipCode,
      };
      const location = await getLocation(address);
      if (location instanceof RequestError) {
        return location;
      }
      const client = dynamo();
      const gym = {
        address: address,
        gymLocation: location,
        id: adminClaims.sub,
        adminEmail: adminClaims.email,
        adminFirstName: data.adminFirstName,
        adminLastName: data.adminLastName,
        gymName: data.gymName,
        createdAt: new Date(),
      };
      await client.put({
        ...gymKey(gym.id),
        data: gymToDynamo(gym),
      });
      return new Success();
    },
  });
}
