import '../../../services/authentication_service.dart';
import '../../../locator.dart';
import '../base_model.dart';
import 'redirected_view.dart';

/// This is a view that will redirect if the user is authenticated.
abstract class PreAuthenticationView<T extends BaseModel>
    extends RedirectedView<T> {
  /// Redirected authenticated users to the home root.
  @override
  String get redirectRoute => '/home';

  /// Redirect the user to the home route if they are authenticated.
  @override
  Future<bool> get shouldRedirect =>
      locator<AuthenticationService>().isAuthenticated();
}
