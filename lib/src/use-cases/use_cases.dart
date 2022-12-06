import 'package:get_it/get_it.dart';

import 'implementations/implementations.dart';
import 'interfaces/interfaces.dart';

export 'interfaces/interfaces.dart';

final useCases = GetIt.instance;

void injectUseCases() {
  useCases.registerSingleton<ISkipOnBoardingUseCase>(SkipOnBoardingUseCase());
  useCases.registerSingleton<IGetAuthTokenUseCase>(GetAuthTokenUseCase());
}

ISkipOnBoardingUseCase get skipOnBoardingUseCase => useCases();
IGetAuthTokenUseCase get getAuthTokenUseCase => useCases();
