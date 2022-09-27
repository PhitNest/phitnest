import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../state.dart';

class GymSearchState extends ScreenState {
  final TextEditingController searchController = TextEditingController();

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? errorMessage) {
    _errorMessage = errorMessage;
    rebuildView();
  }

  late Gym _currentlySelectedGym;

  Gym get currentlySelectedGym => _currentlySelectedGym;

  set currentlySelectedGym(Gym currentlySelectedGym) {
    _currentlySelectedGym = currentlySelectedGym;
    rebuildView();
  }

  List<Tuple2<Gym, double>> _gymsAndDistances = [];

  List<Tuple2<Gym, double>> get gymsAndDistances => _gymsAndDistances;

  set gymsAndDistances(List<Tuple2<Gym, double>> gymsAndDistances) {
    _gymsAndDistances = gymsAndDistances;
    rebuildView();
  }
}
