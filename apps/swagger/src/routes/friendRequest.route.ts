import {createRoute, z} from "@hono/zod-openapi";

export const sendFriendRequestRoute = createRoute({
    method: 'post',
    path: '/private/friend-request',
    tags: ['Friend Requests'],
    description: "Sends a new friend request to the specified user or accepts an existing one if found. If an outgoing friend request already exists, an error is returned.",
    summary: "Send or accept friend request",
    request: {
        body: {
            content: {
                'application/json': {
                    schema: z.object({
                        receiverId: z.string()
                    })
                }
            },
            required: true,
        }
    },
    responses: {
        200: {
            content: {
                'application/json': {
                    schema: z.object({
                        sender: z.object({
                            id: z.string(),
                        }),
                        receiver: z.object({
                            id: z.string(),
                        }),
                        createdAt: z.string().openapi({
                            default: new Date().toISOString(),
                        }),
                        accepted: z.boolean().openapi({
                            default: true,
                        }),
                    })
                },
            },
            description: "Friend request successfully sent or accepted."
        },
        400: {
            content: {
                'application/json': {
                    schema: z.object({
                        error: z.string(),
                        message: z.string(),
                    })
                },
            },
            description: "Unauthorized request, such as missing or invalid authentication credentials."
        },
    },
})

export const deleteFriendRequestRoute = createRoute({
    method: 'delete',
    path: '/private/friend-request',
    tags: ['Friend Requests'],
    description: "Deletes an existing friend request, either sent by the user or received from the specified friend.",
    summary: "Delete friend request",
    request: {
        query: z.object({
            friendId: z.string().openapi({
                description: "The unique identifier of the friend from whom the friend request is being deleted.",
                type: "string",
                param: {
                    in: "query",
                    required: true,
                    description: "The unique identifier of the friend from whom the friend request is being deleted."
                }
            })
        })
    },
    responses: {
        200: {
            content: {
                'application/json': {
                    schema: z.object({
                        message: z.string().openapi({
                            default: "Friend request successfully deleted."
                        }),
                    })
                },
            },
            description: "Friend request successfully deleted."
        },
        400: {
            content: {
                'application/json': {
                    schema: z.object({
                        error: z.string(),
                        message: z.string(),
                    })
                },
            },
            description: "Bad request, such as missing friendId in the query parameters."
        },
    },
})