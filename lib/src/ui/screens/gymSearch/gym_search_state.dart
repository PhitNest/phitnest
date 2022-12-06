import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../state.dart';

class GymSearchState extends ScreenState {
  final searchController = TextEditingController();
  late final FocusNode searchFocus = FocusNode()
    ..addListener(
      () => showConfirmButton = !searchFocus.hasFocus,
    );

  void editSearch() => rebuildView();

  bool _showConfirmButton = true;

  bool get showConfirmButton => _showConfirmButton;

  set showConfirmButton(bool showConfirmButton) {
    _showConfirmButton = showConfirmButton;
    rebuildView();
  }

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? errorMessage) {
    _errorMessage = errorMessage;
    rebuildView();
  }

  GymEntity _currentlySelectedGym = new GymEntity(
    id: "1",
    name: "Planet Fitness",
    address: new AddressEntity(
      street: "123 Street st",
      city: "Virginia Beach",
      state: "VA",
      zipCode: "23456",
    ),
    location: new LocationEntity(
      longitude: 52,
      latitude: -20,
    ),
  );

  GymEntity get currentlySelectedGym => _currentlySelectedGym;

  set currentlySelectedGym(GymEntity currentlySelectedGym) {
    _currentlySelectedGym = currentlySelectedGym;
    rebuildView();
  }

  List<Tuple2<GymEntity, double>> _gymsAndDistances = [
    new Tuple2(
      new GymEntity(
        id: "1",
        name: "Planet Fitness",
        address: new AddressEntity(
          street: "123 Street st",
          city: "Virginia Beach",
          state: "VA",
          zipCode: "23456",
        ),
        location: new LocationEntity(
          longitude: 52,
          latitude: -20,
        ),
      ),
      13,
    ),
    new Tuple2(
      new GymEntity(
        id: "2",
        name: "Anytime Fitness",
        address: new AddressEntity(
          street: "245 Street St",
          city: "Houston",
          state: "TX",
          zipCode: "53145",
        ),
        location: new LocationEntity(
          longitude: 52,
          latitude: -20,
        ),
      ),
      52,
    ),
    new Tuple2(
      new GymEntity(
        id: "3",
        name: "Gold's Gym",
        address: new AddressEntity(
          street: "432 West St",
          city: "New York City",
          state: "NY",
          zipCode: "12345",
        ),
        location: new LocationEntity(
          longitude: 52,
          latitude: -20,
        ),
      ),
      90,
    ),
    new Tuple2(
      new GymEntity(
        id: "4",
        name: "24 hour fitness",
        address: new AddressEntity(
          street: "123 fake st",
          city: "Fake",
          state: "NB",
          zipCode: "12364",
        ),
        location: new LocationEntity(
          longitude: 52,
          latitude: -20,
        ),
      ),
      100.7,
    ),
    new Tuple2(
      new GymEntity(
        id: "5",
        name: "PhitNest Gym",
        address: new AddressEntity(
          street: "789 Street St",
          city: "Fake City",
          state: "PA",
          zipCode: "23456",
        ),
        location: new LocationEntity(
          longitude: 52,
          latitude: -20,
        ),
      ),
      150.4,
    ),
    new Tuple2(
      new GymEntity(
        id: "6",
        name: "Northwest Gy",
        address: new AddressEntity(
          street: "12 North St",
          city: "Kansas City",
          state: "KA",
          zipCode: "12345",
        ),
        location: new LocationEntity(
          longitude: 52,
          latitude: -20,
        ),
      ),
      200.12,
    ),
    new Tuple2(
      new GymEntity(
        id: "7",
        name: "Another Gym",
        address: new AddressEntity(
          street: "123 Street",
          city: "Another City",
          state: "VA",
          zipCode: "54332",
        ),
        location: new LocationEntity(
          longitude: 52,
          latitude: -20,
        ),
      ),
      220.3,
    ),
    new Tuple2(
      new GymEntity(
        id: "8",
        name: "Gold's Gym",
        address: new AddressEntity(
          street: "123 Fake Way",
          city: "Jupiter",
          state: "WA",
          zipCode: "92145",
        ),
        location: new LocationEntity(
          longitude: 52,
          latitude: -20,
        ),
      ),
      270.3,
    ),
    new Tuple2(
      new GymEntity(
        id: "9",
        name: "Last Gym",
        address: new AddressEntity(
          street: "1244 Parks Ave",
          city: "New York City",
          state: "NY",
          zipCode: "12345",
        ),
        location: new LocationEntity(
          longitude: 52,
          latitude: -20,
        ),
      ),
      340.7,
    ),
  ];

  List<Tuple2<GymEntity, double>> get gymsAndDistances => _gymsAndDistances;

  set gymsAndDistances(List<Tuple2<GymEntity, double>> gymsAndDistances) {
    _gymsAndDistances = gymsAndDistances;
    rebuildView();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
