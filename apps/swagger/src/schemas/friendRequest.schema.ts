import {z} from "@hono/zod-openapi";
import {UserSchema} from "./user.schema";

export const FriendRequestSchema = z.object({
    sender: z.object(UserSchema.shape).openapi({
        description: "The user who sent the friend request."
    }),
    receiver: z.object(UserSchema.shape).openapi({
        description: "The user who received the friend request."
    }),
    accepted: z.boolean().openapi({
        description: "Whether the friend request has been accepted."
    }),
    createdAt: z.string().openapi({
        format: 'date-time',
        description: "The date and time when the friend request was created."
    }),
}).openapi('FriendRequest')