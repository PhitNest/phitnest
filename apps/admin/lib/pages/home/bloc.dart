part of 'home.dart';

typedef GetGymBloc = AuthLoaderBloc<void, HttpResponse<void>>;
typedef GetGymConsumer = AuthLoaderConsumer<void, HttpResponse<void>>;

extension GetGymBlocGetter on BuildContext {
  GetGymBloc get getGymBloc => authLoader();
}
