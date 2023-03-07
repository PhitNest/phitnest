import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String name;
  final String message;

  const Failure(this.name, this.message) : super();

  factory Failure.fromJson(Map<String, dynamic> json) => Failure(
        json['name'],
        json['message'],
      );

  @override
  List<Object?> get props => [name, message];
}
