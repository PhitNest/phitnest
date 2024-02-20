import {z} from "@hono/zod-openapi";

export const UserSchema = z.object({
    id: z.string().openapi({
        description: 'The unique identifier for the user.'
    }),
}).openapi('User')