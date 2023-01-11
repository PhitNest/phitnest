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

let authRepo: IAuthRepository;
let gymRepo: IGymRepository;
let userRepo: IUserRepository;
let friendRequestRepo: IFriendRequestRepository;
let locationRepo: ILocationRepository;
let friendshipRepo: IFriendshipRepository;
let directMessageRepo: IDirectMessageRepository;

export function authRepository() {
  return authRepo;
}

export function gymRepository() {
  return gymRepo;
}

export function userRepository() {
  return userRepo;
}

export function friendRequestRepository() {
  return friendRequestRepo;
}

export function locationRepository() {
  return locationRepo;
}

export function friendshipRepository() {
  return friendshipRepo;
}

export function directMessageRepository() {
  return directMessageRepo;
}

export function injectRepositories() {
  authRepo = new CognitoAuthRepository();
  gymRepo = new MongoGymRepository();
  userRepo = new MongoUserRepository();
  friendRequestRepo = new MongoFriendRequestRepository();
  locationRepo = new OSMLocationRepository();
  friendshipRepo = new MongoFriendshipRepository();
  directMessageRepo = new MongoDirectMessageRepository();
}
