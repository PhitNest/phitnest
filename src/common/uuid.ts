import crypto from "crypto";

export function createUuid(): string {
  return crypto.randomUUID();
}
