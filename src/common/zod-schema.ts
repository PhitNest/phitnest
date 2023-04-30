import { z } from "zod";

export const MAX_PAGE_LENGTH = 50;

export const paginator = z.object({
  limit: z.coerce
    .number()
    .int()
    .positive()
    .max(MAX_PAGE_LENGTH)
    .optional()
    .default(MAX_PAGE_LENGTH),
  page: z.coerce.number().int().nonnegative().optional().default(0),
});
