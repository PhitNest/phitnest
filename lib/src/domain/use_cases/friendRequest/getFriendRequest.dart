

// FEither<Either<FriendRequestEntity, FriendshipEntity>, Failure>
//     getFriendRequest(
//   String recipientCognitoId,
// ) =>
//         httpAdapter
//             .request(
//               kSendFriendRequestRoute,
//               SendFriendRequest(
//                 recipientCognitoId: recipientCognitoId,
//               ),
//             )
//             .then(
//               (res) => res.fold(
//                 (left) => left.fold((l) => l, (r) => r),
//                 (failure) => failure,
//               ),
//             );
