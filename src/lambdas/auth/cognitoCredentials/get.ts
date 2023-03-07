import { respond } from "@/common/respond";
import { kCognitoCredentials } from "@/data/auth";

export async function invoke(): Promise<{
  statusCode: number;
  body: string;
}> {
  return await respond({
    controller: async () => kCognitoCredentials,
  });
}
