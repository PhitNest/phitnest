import {createRoute, z} from "@hono/zod-openapi";
import {MessageSchema} from "schemas/message.schema";
import {UserSchema} from "schemas/user.schema";
import {FriendRequestSchema} from "schemas/friendRequest.schema";

export const getHomeDataRoute = createRoute({
    method: 'get',
    path: '/home',
    tags: ['Home Data'],
    description: "Retrieves data for the user's home screen, including personal information, recent messages, and pending friend requests.",
    summary: "Fetch home screen data",
    responses: {
        200: {
            content: {
                'application/json': {
                    schema: z.array(z.object({
                        userInfo: z.object(UserSchema.shape),
                        recentMessages: z.array(z.object(MessageSchema.shape)),
                        pendingFriendRequests: z.array(z.object(FriendRequestSchema.shape)),
                    }))
                },
            },
            description: "Successfully retrieved home screen data."
        },
    },
})