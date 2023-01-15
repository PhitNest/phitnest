import dataSources from "../../data/data-sources/injection";

class FriendRequestRepository {
  create(fromCognitoId: string, toCognitoId: string) {
    return dataSources().friendRequestDatabase.create(
      fromCognitoId,
      toCognitoId
    );
  }

  getByFromCognitoId(fromCognitoId: string) {
    return dataSources().friendRequestDatabase.getByFromCognitoId(
      fromCognitoId
    );
  }

  getByToCognitoId(toCognitoId: string) {
    return dataSources().friendRequestDatabase.getByToCognitoId(toCognitoId);
  }

  getByCognitoIds(fromCognitoId: string, toCognitoId: string) {
    return dataSources().friendRequestDatabase.getByCognitoIds(
      fromCognitoId,
      toCognitoId
    );
  }

  deny(fromCognitoId: string, toCognitoId: string) {
    return dataSources().friendRequestDatabase.deny(fromCognitoId, toCognitoId);
  }

  delete(fromCognitoId: string, toCognitoId: string) {
    return dataSources().friendRequestDatabase.delete(
      fromCognitoId,
      toCognitoId
    );
  }

  deleteAll() {
    return dataSources().friendRequestDatabase.deleteAll();
  }
}

export const friendRequestRepo = new FriendRequestRepository();
