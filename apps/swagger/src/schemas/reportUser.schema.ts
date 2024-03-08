import {z} from "@hono/zod-openapi";

export const ReportUserSchema = z.object({
    senderId: z.string().openapi({
        description: "The unique identifier of the user who is reporting.route.ts another user."
    }),
    receiverId: z.string().openapi({
        description: "The unique identifier for the user who is being reported."
    }),
    reason: z.string().openapi({
        description: "The reason for reporting.route.ts the user."
    }),
    createdAt: z.string().openapi({
        format: 'date-time',
        description: "The date and time when the user was reported."
    }),
}).openapi('ReportUser')