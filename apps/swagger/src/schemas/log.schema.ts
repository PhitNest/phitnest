import {z} from "@hono/zod-openapi";

export const LogEventSchema = z.object({
    logId: z.string().openapi({
        description: "The unique identifier for the log event."
    }),
    timestamp: z.string().openapi({
        format: 'date-time',
        description: "The date and time when the log event occurred."
    }),
    action: z.string().openapi({
        description: "The action that triggered the log event."
    }),
    details: z.string().openapi({
        description: "Detailed information about the log event."
    }),
}).openapi('LogEvent')