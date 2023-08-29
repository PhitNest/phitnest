part of 'instructions.dart';

typedef ChoosePhotoBloc
    = LoaderBloc<Future<CroppedFile?> Function(), CroppedFile?>;
typedef ChoosePhotoConsumer
    = LoaderConsumer<Future<CroppedFile?> Function(), CroppedFile?>;

extension on BuildContext {
  ChoosePhotoBloc get choosePhotoBloc => loader();
}
