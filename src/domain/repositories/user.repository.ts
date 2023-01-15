import { ICognitoUser } from "../entities";
import dataSources from "../../data/data-sources/injection";

class UserRepository {
  create(user: ICognitoUser) {
    return dataSources().userDatabase.create(user);
  }

  delete(cognitoId: string) {
    return dataSources().userDatabase.delete(cognitoId);
  }

  setConfirmed(cognitoId: string) {
    return dataSources().userDatabase.setConfirmed(cognitoId);
  }

  getByEmail(email: string) {
    return dataSources().userDatabase.getByEmail(email);
  }

  get(cognitoId: string) {
    return dataSources().userDatabase.get(cognitoId);
  }

  getByGym(gymId: string) {
    return dataSources().userDatabase.getByGym(gymId);
  }

  haveSameGym(cognitoId1: string, cognitoId2: string) {
    return dataSources().userDatabase.haveSameGym(cognitoId1, cognitoId2);
  }

  deleteAll() {
    return dataSources().userDatabase.deleteAll();
  }
}

export const userRepo = new UserRepository();
