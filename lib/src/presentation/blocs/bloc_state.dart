import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class BlocState extends Equatable {
  const BlocState() : super();

  @mustCallSuper
  Future<void> dispose() async {}

  @override
  List<Object> get props => [];
}
