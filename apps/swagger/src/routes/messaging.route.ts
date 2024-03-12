import {createRoute, z} from "@hono/zod-openapi";

export const conversationRoute = createRoute({
    method: 'get',
    path: '/conversation',
    tags: ['Messaging'],
    description: "Fetches conversation messages between the authenticated user and the specified friend, using the friend's user ID (`friendId`) to identify the conversation.",
    summary: "Retrieve conversation messages",
    request: {
        query: z.object({
            friendId: z.string().openapi({
                description: "The unique identifier (user ID) of the friend with whom the conversation is being retrieved.",
                type: "string",
                param: {
                    in: "query",
                    required: true,
                    description: "The unique identifier (user ID) of the friend with whom the conversation is being retrieved."
                }
            })
        })
    },
    responses: {
        200: {
            content: {
                'application/json': {
                    schema: z.array(z.object({
                        messageId: z.number(),
                        senderId: z.string(),
                        receiverId: z.string(),
                        content: z.string(),
                    }))
                },
            },
            description: "Successfully retrieved conversation messages."
        },
    },
})