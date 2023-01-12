import {
  CognitoAuthRepository,
  MongoDirectMessageRepository,
  MongoFriendRequestRepository,
  MongoFriendshipRepository,
  MongoGymRepository,
  MongoUserRepository,
  OSMLocationRepository,
} from "./implementations";
import {
  IAuthRepository,
  IFriendRequestRepository,
  IGymRepository,
  ILocationRepository,
  IUserRepository,
  IFriendshipRepository,
  IDirectMessageRepository,
} from "./interfaces";

type Repositories = {
  authRepo: IAuthRepository;
  gymRepo: IGymRepository;
  userRepo: IUserRepository;
  friendRequestRepo: IFriendRequestRepository;
  locationRepo: ILocationRepository;
  friendshipRepo: IFriendshipRepository;
  directMessageRepo: IDirectMessageRepository;
};

const kDefaultRepositories: Repositories = {
  authRepo: new CognitoAuthRepository(),
  gymRepo: new MongoGymRepository(),
  userRepo: new MongoUserRepository(),
  friendRequestRepo: new MongoFriendRequestRepository(),
  locationRepo: new OSMLocationRepository(),
  friendshipRepo: new MongoFriendshipRepository(),
  directMessageRepo: new MongoDirectMessageRepository(),
};

let repos: Repositories;

export default function repositories() {
  return repos;
}

export function rebindRepositories(repositories: Partial<Repositories>) {
  repos = {
    ...repos,
    ...repositories,
  };
}

export function injectRepositories() {
  repos = {
    ...kDefaultRepositories,
  };
}
