import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../state.dart';

class FriendsState extends ScreenState {
  final TextEditingController searchController = TextEditingController();

  List<PublicUserEntity> requests = [
    PublicUserEntity(
      id: '1',
      cognitoId: '1',
      firstName: 'Json',
      lastName: 'M.',
      gymId: '1',
    ),
    PublicUserEntity(
      id: '2',
      cognitoId: '2',
      firstName: 'James',
      lastName: 'B.',
      gymId: '1',
    ),
    PublicUserEntity(
      id: '3',
      cognitoId: '3',
      firstName: 'Zane',
      lastName: 'M.',
      gymId: '1',
    ),
    PublicUserEntity(
      id: '4',
      cognitoId: '4',
      firstName: 'Rahul',
      lastName: 'P.',
      gymId: '1',
    ),
    PublicUserEntity(
      id: '5',
      cognitoId: '5',
      firstName: 'Erin-Michelle',
      lastName: 'J.',
      gymId: '1',
    ),
  ];

  List<PublicUserEntity> friends = [
    PublicUserEntity(
      id: '6',
      cognitoId: '6',
      firstName: 'Umaar',
      lastName: 'E.',
      gymId: '1',
    ),
    PublicUserEntity(
      id: '7',
      cognitoId: '7',
      firstName: 'Turner',
      lastName: 'W.',
      gymId: '1',
    ),
    PublicUserEntity(
      id: '8',
      cognitoId: '8',
      firstName: 'Turner',
      lastName: 'W.',
      gymId: '1',
    ),
    PublicUserEntity(
      id: '9',
      cognitoId: '9',
      firstName: 'Turner',
      lastName: 'W.',
      gymId: '1',
    ),
    PublicUserEntity(
      id: '10',
      cognitoId: '10',
      firstName: 'Turner',
      lastName: 'W.',
      gymId: '1',
    ),
  ];
}
