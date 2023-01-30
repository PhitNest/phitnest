import '../../../../../domain/entities/entities.dart';
import '../requests.dart';

class GetNearestGymsRequest extends Request {
  final LocationEntity location;
  final double meters;
  final int? amount;

  const GetNearestGymsRequest({
    required this.location,
    required this.meters,
    this.amount,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'location': location,
        'meters': meters,
        ...(amount != null ? {'amount': amount} : {})
      };

  @override
  List<Object?> get props => [location, meters, amount];
}
