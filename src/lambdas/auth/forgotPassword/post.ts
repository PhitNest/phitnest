import { respond } from "@/common/respond";
import { login } from "@/repositories/auth";
import { APIGatewayEvent } from "aws-lambda";
import { z } from "zod";

const validator = z.object({
  email: z.string().trim(),
  password: z.string().min(8),
});

export function invoke(event: APIGatewayEvent): Promise<{
  statusCode: number;
  body: string;
}> {
  return respond({
    controller: async (response: z.infer<typeof validator>) =>
      await login(response.email, response.password),
    body: event.body,
    validator: validator,
  });
}
