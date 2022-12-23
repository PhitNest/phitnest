import 'package:dartz/dartz.dart';

import '../screen_state.dart';
import '../../../entities/entities.dart';

abstract class GymSearchState extends ScreenState {
  const GymSearchState() : super();
}

class LoadingState extends GymSearchState {
  const LoadingState() : super();
}

class LoadedState extends GymSearchState {
  final List<Tuple2<GymEntity, double>> gymsAndDistances;
  final GymEntity currentlySelectedGym;
  final String searchQuery;

  const LoadedState({
    required this.gymsAndDistances,
    required this.currentlySelectedGym,
    required this.searchQuery,
  }) : super();

  @override
  List<Object> get props =>
      [gymsAndDistances, currentlySelectedGym, searchQuery];
}

class TypingState extends GymSearchState {
  final List<Tuple2<GymEntity, double>> gymsAndDistances;
  final GymEntity currentlySelectedGym;
  final String searchQuery;

  const TypingState({
    required this.gymsAndDistances,
    required this.currentlySelectedGym,
    required this.searchQuery,
  }) : super();

  @override
  List<Object> get props =>
      [gymsAndDistances, currentlySelectedGym, searchQuery];
}

class ErrorState extends GymSearchState {
  final String message;

  const ErrorState({required this.message}) : super();

  @override
  List<Object> get props => [message];
}

class GymSearchCubit extends ScreenCubit<GymSearchState> {
  GymSearchCubit() : super(const LoadingState());

  void transitionToLoading() => setState(const LoadingState());

  void transitionToLoaded(
    List<Tuple2<GymEntity, double>> gymsAndDistances,
    GymEntity currentlySelectedGym,
    String searchQuery,
  ) =>
      setState(
        LoadedState(
          gymsAndDistances: gymsAndDistances,
          currentlySelectedGym: currentlySelectedGym,
          searchQuery: searchQuery,
        ),
      );

  void transitionTypingToLoaded() {
    final typingState = state as TypingState;
    setState(
      LoadedState(
        gymsAndDistances: typingState.gymsAndDistances,
        currentlySelectedGym: typingState.currentlySelectedGym,
        searchQuery: typingState.searchQuery,
      ),
    );
  }

  void transitionToTyping() {
    final loadedState = state as LoadedState;
    setState(
      TypingState(
        gymsAndDistances: loadedState.gymsAndDistances,
        currentlySelectedGym: loadedState.currentlySelectedGym,
        searchQuery: loadedState.searchQuery,
      ),
    );
  }

  void transitionToError(String message) =>
      setState(ErrorState(message: message));

  void setSearchQuery(String query) {
    setState(
      TypingState(
        gymsAndDistances: (state as TypingState).gymsAndDistances,
        currentlySelectedGym: (state as TypingState).currentlySelectedGym,
        searchQuery: query,
      ),
    );
  }

  void setCurrentlySelectedGym(GymEntity gym) {
    if (state is LoadedState) {
      setState(
        LoadedState(
          gymsAndDistances: (state as LoadedState).gymsAndDistances,
          currentlySelectedGym: gym,
          searchQuery: (state as LoadedState).searchQuery,
        ),
      );
    } else if (state is TypingState) {
      setState(
        TypingState(
          gymsAndDistances: (state as TypingState).gymsAndDistances,
          currentlySelectedGym: gym,
          searchQuery: (state as TypingState).searchQuery,
        ),
      );
    } else {
      throw Exception('Cannot set currently selected gym to state: $state');
    }
  }
}
