import { respond } from "@/common/respond";
import { confirmRegister } from "@/repositories/auth";
import { APIGatewayEvent } from "aws-lambda";
import { z } from "zod";

const validator = z.object({
  email: z.string().trim(),
  code: z.string().length(6),
});

export function invoke(event: APIGatewayEvent): Promise<{
  statusCode: number;
  body: string;
}> {
  return respond({
    controller: async (response: z.infer<typeof validator>) =>
      await confirmRegister(response.email, response.code),
    body: event.body,
    validator: validator,
  });
}
