import {
  CognitoAuthDatabase,
  MongoDirectMessageDatabase,
  MongoFriendRequestDatabase,
  MongoFriendshipDatabase,
  MongoGymDatabase,
  MongoUserDatabase,
  OSMLocationDatabase,
  S3ProfilePictureDatabase,
} from "./implementations";
import {
  IAuthDatabase,
  IFriendRequestDatabase,
  IGymDatabase,
  ILocationDatabase,
  IUserDatabase,
  IFriendshipDatabase,
  IDirectMessageDatabase,
  IProfilePictureDatabase,
} from "./interfaces";

type DataSources = {
  authDatabase: IAuthDatabase;
  gymDatabase: IGymDatabase;
  userDatabase: IUserDatabase;
  friendRequestDatabase: IFriendRequestDatabase;
  locationDatabase: ILocationDatabase;
  friendshipDatabase: IFriendshipDatabase;
  directMessageDatabase: IDirectMessageDatabase;
  profilePictureDatabase: IProfilePictureDatabase;
};

const kDefaultDataSources: DataSources = {
  authDatabase: new CognitoAuthDatabase(),
  gymDatabase: new MongoGymDatabase(),
  userDatabase: new MongoUserDatabase(),
  friendRequestDatabase: new MongoFriendRequestDatabase(),
  locationDatabase: new OSMLocationDatabase(),
  friendshipDatabase: new MongoFriendshipDatabase(),
  directMessageDatabase: new MongoDirectMessageDatabase(),
  profilePictureDatabase: new S3ProfilePictureDatabase(),
};

let sources: DataSources;

export default function dataSources() {
  return sources;
}

export function rebindDataSources(inject: Partial<DataSources>) {
  sources = {
    ...dataSources(),
    ...inject,
  };
}

export function injectDataSources() {
  sources = {
    ...kDefaultDataSources,
  };
}
