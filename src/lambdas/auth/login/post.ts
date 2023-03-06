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
  const body = validator.parse(JSON.parse(event.body ?? ""));
  return respond(async () => await login(body.email, body.password));
}
