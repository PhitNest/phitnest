import {z} from "@hono/zod-openapi";

export const UserDataSchema = z.object({
    id: z.string().openapi({
        description: 'The unique identifier for the user.',
    }),
    firstName: z.string().openapi({
        description: 'The first name of the user.',
    }),
    lastName: z.string().openapi({
        description: 'The last name of the user.',
    }),
    createdAt: z.string().openapi({
        format: 'date-time',
        description: 'The date and time when the user was created.',
    }),
}).openapi('UserData')