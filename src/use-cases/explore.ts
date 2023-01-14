import repositories from "../repositories/injection";

export async function explore(cognitoId: string, gymId: string) {
  const { userRepo, friendshipRepo, friendRequestRepo } = repositories();
  const [others, friends, sentRequests, receivedRequests] = await Promise.all([
    userRepo.getByGym(gymId),
    friendshipRepo.get(cognitoId),
    friendRequestRepo.getByFromCognitoId(cognitoId),
    friendRequestRepo.getByToCognitoId(cognitoId),
  ]);
  return {
    users: others.filter(
      (user) =>
        !(
          user.cognitoId === cognitoId ||
          !user.confirmed ||
          friends.find((friendship) =>
            friendship.userCognitoIds.includes(user.cognitoId)
          ) ||
          sentRequests.find(
            (request) => request.toCognitoId === user.cognitoId
          ) ||
          receivedRequests.find(
            (request) =>
              request.fromCognitoId === user.cognitoId && request.denied
          )
        )
    ),
    requests: receivedRequests.filter((request) => !request.denied),
  };
}
