import { Failure } from '@/common/failure';
import { login } from '@/repositories/auth';
import { Context, APIGatewayEvent } from 'aws-lambda';
import { z } from 'zod';

const validator = z.object({
    email: z.string().trim(),
    password: z.string().min(8),
  });

export async function loginHandler(event: APIGatewayEvent, context: Context): Promise<{
  statusCode: number
  body: string
}> {
    const body = validator.parse(event.body);
    const loginResponse = await login(body.email, body.password);
    if (loginResponse instanceof Failure) {
        return loginResponse;
    } else {
        return {
            statusCode: 200,
            body: JSON.stringify(loginResponse)
        }
    }
}