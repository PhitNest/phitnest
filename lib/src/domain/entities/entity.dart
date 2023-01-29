import 'package:equatable/equatable.dart';

import '../../common/utils/utils.dart';

abstract class Entity<EntityType> extends Equatable
    with Serializable<EntityType> {
  const Entity();
}
