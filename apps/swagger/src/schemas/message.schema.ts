import {z} from "@hono/zod-openapi";

export const MessageSchema = z.object({
    messageId: z.number().openapi({
        description: "The unique identifier for the message."
    }),
    senderId: z.string().openapi({
        description: "The unique identifier for the sender of the message.",
    }),
    receiverId: z.string().openapi({
        description: "The unique identifier for the receiver of the message.",
    }),
    content: z.string().openapi({
        description: "The content of the message.",
    }),
}).openapi('Message')