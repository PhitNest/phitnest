import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phitnest_core/auth/auth.dart';

/// [authProvider] holds the [Auth] instance used for accessing authentication routes.
final Provider<Auth> authProvider =
    Provider<Auth>((ref) => Auth.fromServerStatus('sandbox'));
