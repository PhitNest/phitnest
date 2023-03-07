import { respond } from "@/common/respond";
import Auth from "@/data/auth";
import { APIGatewayEvent } from "aws-lambda";
import { z } from "zod";

const validator = z.object({
  email: z.string().trim(),
  password: z.string().min(8),
  firstName: z.string().trim(),
  lastName: z.string().trim(),
});

export async function invoke(event: APIGatewayEvent): Promise<{
  statusCode: number;
  body: string;
}> {
  return await respond({
    controller: async (response: z.infer<typeof validator>) =>
      await Auth.register(
        response.email,
        response.password,
        response.firstName,
        response.lastName
      ),
    body: event.body,
    validator,
  });
}
