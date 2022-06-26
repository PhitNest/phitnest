import '../base_model.dart';

abstract class ScreenModel extends BaseModel {
  ScreenModel({bool initiallyLoading = true})
      : super(initiallyLoading: initiallyLoading);
}
