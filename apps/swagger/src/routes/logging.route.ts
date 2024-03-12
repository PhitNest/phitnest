import {createRoute, z} from "@hono/zod-openapi";

export const loggingRoute = createRoute({
    method: 'post',
    path: '/log',
    tags: ['Logging'],
    description: "Allows public submission of a log event, structured according to the LogEvent schema. This endpoint is accessible without authentication.",
    summary: "Submit a public log event ",
    request: {
        body: {
            required: true,
            content: {
                "application/json": {
                    schema: z.object({
                        logId: z.string(),
                        timestamp: z.string().openapi({
                            default: new Date().toISOString(),
                        }),
                        action: z.string(),
                        details: z.string(),
                    })
                }
            }
        }
    },
    responses: {
        200: {
            content: {
                'application/json': {
                    schema: z.array(z.object({
                        message: z.string().openapi({
                            default: "Public log event submitted successfully."
                        })
                    }))
                },
            },
            description: "Public log event submitted successfully."
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
            description: "Bad request, such as invalid log event data."
        },
    },
})