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

  late GymEntity _currentlySelectedGym;

  GymEntity get currentlySelectedGym => _currentlySelectedGym;

  set currentlySelectedGym(GymEntity currentlySelectedGym) {
    _currentlySelectedGym = currentlySelectedGym;
    rebuildView();
  }

  List<Tuple2<GymEntity, double>>? _gymsAndDistances;

  List<Tuple2<GymEntity, double>>? get gymsAndDistances => _gymsAndDistances;

  set gymsAndDistances(List<Tuple2<GymEntity, double>>? gymsAndDistances) {
    _gymsAndDistances = gymsAndDistances;
    rebuildView();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
