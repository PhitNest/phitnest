import 'package:phitnest_core/serializable.dart';
import 'package:test/test.dart';

final class Collar extends JsonSerializable {
  final addressesJson = Json.stringList('addresses');

  List<String> get addresses => addressesJson.value;

  Collar() : super();

  @override
  List<JsonMember<dynamic>> get members => [addressesJson];
}

final class Dog extends JsonSerializable {
  final nameJson = Json.string('name');
  final ageJson = Json.int('age');
  final collarJson = Json.object('collar', Collar());

  String get name => nameJson.value;
  int get age => ageJson.value;
  Collar get collar => collarJson.value;

  Dog() : super();

  @override
  List<JsonMember<dynamic>> get members => [nameJson, ageJson, collarJson];
}

void main() {
  group(
    'JSON Serialization',
    () {
      test(
        'object roundtrip',
        () {
          final dog = Dog();
          final name = 'Fido';
          final age = 3;
          final addresses = ['123 Main St', '456 Maple Ave'];
          final json = {
            'name': name,
            'age': age,
            'collar': {
              'addresses': addresses,
            }
          };
          dog.parseJson(json);
          expect(dog.name, name);
          expect(dog.age, age);
          expect(dog.collar.addresses, addresses);
          expect(dog.toJson(), json);
        },
      );
    },
  );
}
