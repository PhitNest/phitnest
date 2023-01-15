import { IDirectMessageEntity } from "../entities";
import dataSources from "../../data/data-sources/injection";

class DirectMessageRepository {
  create(message: Omit<IDirectMessageEntity, "_id" | "createdAt">) {
    return dataSources().directMessageDatabase.create(message);
  }

  deleteAll() {
    return dataSources().directMessageDatabase.deleteAll();
  }

  get(friendshipId: string, amount?: number) {
    return dataSources().directMessageDatabase.get(friendshipId, amount);
  }
}

export const directMessageRepo = new DirectMessageRepository();
