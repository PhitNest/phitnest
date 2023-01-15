import dataSources from "../../data/data-sources/injection";

class FriendshipRepository {
  create(userCognitoIds: [string, string]) {
    return dataSources().friendshipDatabase.create(userCognitoIds);
  }

  deleteAll() {
    return dataSources().friendshipDatabase.deleteAll();
  }

  get(cognitoId: string) {
    return dataSources().friendshipDatabase.get(cognitoId);
  }

  getByUsers(userCognitoIds: [string, string]) {
    return dataSources().friendshipDatabase.getByUsers(userCognitoIds);
  }

  delete(userCognitoIds: [string, string]) {
    return dataSources().friendshipDatabase.delete(userCognitoIds);
  }
}

export const friendshipRepo = new FriendshipRepository();
