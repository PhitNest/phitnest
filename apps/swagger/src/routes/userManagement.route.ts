import {createRoute, z} from "@hono/zod-openapi";

export const deleteUserRoute = createRoute({
    method: 'delete',
    path: '/user',
    tags: ['User Management'],
    description: "Deletes the user's account along with all associated friend requests, messages, and other related data. This operation is irreversible.",
    summary: "Delete user account",
    responses: {
        200: {
            content: {
                'application/json': {
                    schema: z.object({
                        message: z.string().openapi({
                            default: "User account and all associated data successfully deleted."
                        })
                    })
                },
            },
            description: "User account and all associated data successfully deleted."
        },
        401: {
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
        404: {
            content: {
                'application/json': {
                    schema: z.object({
                        message: z.string().openapi({
                            default: "User not found or already deleted."
                        }),
                    })
                },
            },
            description: "User not found or already deleted."
        },
    },
})

export const exploreUsersRoute = createRoute({
    method: 'get',
    path: '/explore',
    tags: ['User Management'],
    description: "Provides a list of users for exploration, potentially to find new friends or connections.",
    summary: "Explore Users",
    responses: {
        200: {
            content: {
                'application/json': {
                    schema: z.array(z.object({
                        userId: z.string(),
                        username: z.string(),
                        email: z.string(),
                        createdAt: z.string().openapi({
                            default: new Date().toISOString(),
                        }),
                    }))
                },
            },
            description: "Successfully retrieved a list of users to explore."
        },
        400: {
            content: {
                'application/json': {
                    schema: z.object({
                        error: z.string(),
                        message: z.string(),
                    }),
                },
            },
            description: "Bad request, such as issues with query parameters or request formatting."
        },
        404: {
            content: {
                'application/json': {
                    schema: z.object({
                        message: z.string().openapi({
                            default: "No users found"
                        }),
                    }),
                },
            },
            description: "No users found for exploration."
        },
    },
})