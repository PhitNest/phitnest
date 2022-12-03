import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../state.dart';

import 'gym_search_provider.dart';
import 'gym_search_view.dart';

/// Holds the dynamic content of [GymSearchProvider]. Calls to [rebuildView] will rebuild
/// the [GymSearchView].
class GymSearchState extends ScreenState {
  final TextEditingController searchController = TextEditingController();

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? errorMessage) {
    _errorMessage = errorMessage;
    rebuildView();
  }

  late GymEntity _currentlySelectedGym;

  GymEntity get currentlySelectedGym => _currentlySelectedGym;

  set currentlySelectedGym(GymEntity currentlySelectedGym) {
    _currentlySelectedGym = currentlySelectedGym;
    rebuildView();
  }

  List<Tuple2<GymEntity, double>> _gymsAndDistances = [];

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
