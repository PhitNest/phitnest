import { SerializedDynamo, DynamoParser } from "./dynamo";

export type Admin = {
  id: string;
  email: string;
  createdAt: Date;
};

export const kAdminParser: DynamoParser<Admin> = {
  id: "S",
  email: "S",
  createdAt: "D",
};

export function adminToDynamo(admin: Admin): SerializedDynamo<Admin> {
  return {
    id: { S: admin.id },
    email: { S: admin.email },
    createdAt: { N: admin.createdAt.getTime().toString() },
  };
}
