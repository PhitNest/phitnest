import { respond } from "@/common/respond";
import { register } from "@/repositories/auth";
import { APIGatewayEvent } from "aws-lambda";
import { z } from "zod";

const validator = z.object({
  email: z.string().trim(),
  password: z.string().min(8),
  firstName: z.string().trim(),
  lastName: z.string().trim(),
});

export function invoke(event: APIGatewayEvent): Promise<{
  statusCode: number;
  body: string;
}> {
  const body = validator.parse(JSON.parse(event.body ?? ""));
  return respond(
    async () =>
      await register(body.email, body.password, body.firstName, body.lastName)
  );
}
