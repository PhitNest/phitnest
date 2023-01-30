import '../../../../domain/entities/entities.dart';
import '../requests/requests.dart';
import 'routes.dart';

const kGetNearestGymsRoute = Route<GetNearestGymsRequest, GymEntity>(
  "/gym/nearest",
  HttpMethod.get,
  GymParser(),
);
