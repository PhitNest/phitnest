import {createRoute, z} from "@hono/zod-openapi";

export const getReportRoute = createRoute({
    method: 'get',
    path: '/private/report',
    tags: ['Reporting'],
    description: "Retrieves a list of reports made by users, including details such as the reporter, the reported user, the reason for the report, and the date the report was created.",
    summary: "Fetch user reports",
    responses: {
        200: {
            content: {
                'application/json': {
                    schema: z.array(z.object({
                        senderId: z.string(),
                        receiverId: z.string(),
                        reason: z.string(),
                        createdAt: z.string().openapi({
                            default: new Date().toISOString(),
                        }),
                    }))
                },
            },
            description: "Successfully retrieved user reports."
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
                            default: "No reports found."
                        }),
                    })
                },
            },
            description: "No reports found."
        },
    },
})

export const postReportRoute = createRoute({
    method: 'post',
    path: '/private/report',
    tags: ['Reporting'],
    description: "Allows authenticated users to submit reports about other users, specifying the reported user and the reason for the report.",
    request: {
        body: {
            content: {
                'application/json': {
                    schema: z.object({
                        receiverId: z.string(),
                        reason: z.string(),
                    }),
                }
            },
            required: true,
        },
    },
    responses: {
        200: {
            content: {
                'application/json': {
                    schema: z.object({
                        message: z.string().openapi({
                            default: "Report submitted successfully."
                        })
                    })
                },
            },
            description: "Report submitted successfully."
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
            description: "Bad request, such as missing required fields or invalid data."
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
    },
})