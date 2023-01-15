import {
  CognitoAuthDatabase,
  MongoDirectMessageDatabase,
  MongoFriendRequestDatabase,
  MongoFriendshipDatabase,
  MongoGymDatabase,
  MongoUserDatabase,
  OSMLocationDatabase,
  S3ProfilePictureDatabase,
} from "./databases/implementations";
import {
  IAuthDatabase,
  IFriendRequestDatabase,
  IGymDatabase,
  ILocationDatabase,
  IUserDatabase,
  IFriendshipDatabase,
  IDirectMessageDatabase,
  IProfilePictureDatabase,
} from "./databases/interfaces";

type Databases = {
  authDatabase: IAuthDatabase;
  gymDatabase: IGymDatabase;
  userDatabase: IUserDatabase;
  friendRequestDatabase: IFriendRequestDatabase;
  locationDatabase: ILocationDatabase;
  friendshipDatabase: IFriendshipDatabase;
  directMessageDatabase: IDirectMessageDatabase;
  profilePictureDatabase: IProfilePictureDatabase;
};

type Caches = {};

const kDefaultDatabases: Databases = {
  authDatabase: new CognitoAuthDatabase(),
  gymDatabase: new MongoGymDatabase(),
  userDatabase: new MongoUserDatabase(),
  friendRequestDatabase: new MongoFriendRequestDatabase(),
  locationDatabase: new OSMLocationDatabase(),
  friendshipDatabase: new MongoFriendshipDatabase(),
  directMessageDatabase: new MongoDirectMessageDatabase(),
  profilePictureDatabase: new S3ProfilePictureDatabase(),
};

const kDefaultCaches: Caches = {};

let dataMap: Databases;
let cacheMap: Caches;

export default function databases() {
  return dataMap;
}

export function caches() {
  return cacheMap;
}

export function rebindDatabases(inject: Partial<Databases>) {
  dataMap = {
    ...databases(),
    ...inject,
  };
}

export function rebindCaches(inject: Partial<Caches>) {
  cacheMap = {
    ...caches(),
    ...inject,
  };
}

export function injectDatabases() {
  dataMap = {
    ...kDefaultDatabases,
  };
}

export function injectCaches() {
  cacheMap = {
    ...kDefaultCaches,
  };
}
