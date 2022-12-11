import 'package:get_it/get_it.dart';

import 'implementations/implementations.dart';
import 'interfaces/interfaces.dart';

export 'interfaces/interfaces.dart';

final useCases = GetIt.instance;

void injectUseCases() {
  useCases.registerSingleton<ISkipOnBoardingUseCase>(SkipOnBoardingUseCase());
  useCases.registerSingleton<IGetAuthTokenUseCase>(GetAuthTokenUseCase());
  useCases.registerSingleton<IGetNearestGymsUseCase>(GetNearestGymsUseCase());
  useCases.registerSingleton<IGetLocationUseCase>(GetLocationUseCase());
  useCases.registerSingleton<IExploreUseCase>(ExploreUseCase());
  useCases.registerSingleton<ILoginUseCase>(LoginUseCase());
  useCases.registerSingleton<IRegisterUseCase>(RegisterUseCase());
}

ISkipOnBoardingUseCase get skipOnBoardingUseCase => useCases();
IGetAuthTokenUseCase get getAuthTokenUseCase => useCases();
IGetNearestGymsUseCase get getNearestGymsUseCase => useCases();
IGetLocationUseCase get getLocationUseCase => useCases();
IExploreUseCase get exploreUseCase => useCases();
ILoginUseCase get loginUseCase => useCases();
IRegisterUseCase get registerUseCase => useCases();
