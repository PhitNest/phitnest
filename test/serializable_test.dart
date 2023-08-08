import 'package:phitnest_core/serializable.dart';
import 'package:test/test.dart';

final class Contact extends Json {
  final addressJson = Json.string('address');
  final phoneJson = Json.string('phone');

  String get address => addressJson.value;
  String get phone => phoneJson.value;

  Contact() : super();

  Contact.parse(super.json) : super.parse();

  Contact.populated({
    required String address,
    required String phone,
  }) : super() {
    addressJson.value = address;
    phoneJson.value = phone;
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [addressJson, phoneJson];
}

final class Collar extends Json {
  final colorJson = Json.string('color');
  final contactsJson = Json.objectList('contacts', Contact.new);

  String get color => colorJson.value;
  List<Contact> get contacts => contactsJson.value;

  Collar() : super();

  Collar.parse(super.json) : super.parse();

  Collar.populated({
    required String color,
    required List<Contact> contacts,
  }) : super() {
    colorJson.value = color;
    contactsJson.value = contacts;
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [colorJson, contactsJson];
}

final class DogInfo extends Json {
  final ageJson = Json.int('age');
  final friendlyJson = Json.bool('friendly');
  final collarJson = Json.object('collar', Collar.new);

  int get age => ageJson.value;
  bool get friendly => friendlyJson.value;
  Collar get collar => collarJson.value;

  DogInfo() : super();

  DogInfo.parse(super.json) : super.parse();

  DogInfo.populated({
    required int age,
    required bool friendly,
    required Collar collar,
  }) : super() {
    ageJson.value = age;
    friendlyJson.value = friendly;
    collarJson.value = collar;
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys =>
      [ageJson, friendlyJson, collarJson];
}

final class Pets extends Json {
  final petsJson = Json.objectMap('pets', DogInfo.new);

  Map<String, DogInfo> get dogs => petsJson.value;

  Pets() : super();

  Pets.parse(super.json) : super.parse();

  Pets.populated({
    required Map<String, DogInfo> pets,
  }) : super() {
    petsJson.value = pets;
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [petsJson];
}

void main() {
  final json = {
    'pets': {
      'Fido': {
        'age': 5,
        'friendly': true,
        'collar': {
          'color': 'Red',
          'contacts': [
            {'address': '123 Main St.', 'phone': '555-555-5555'},
            {'address': '456 Main St.', 'phone': '444-444-4444'},
          ],
        },
      },
      'Blue': {
        'age': 3,
        'friendly': false,
        'collar': {
          'color': 'Blue',
          'contacts': [
            {'address': '789 Main St.', 'phone': '333-333-3333'},
            {'address': '012 Main St.', 'phone': '222-222-2222'},
          ],
        },
      },
    }
  };

  test(
    'JSON serialization',
    () {
      final populated = Pets.populated(
        pets: {
          'Fido': DogInfo.populated(
            age: 5,
            friendly: true,
            collar: Collar.populated(
              color: 'Red',
              contacts: [
                Contact.populated(
                  address: '123 Main St.',
                  phone: '555-555-5555',
                ),
                Contact.populated(
                  address: '456 Main St.',
                  phone: '444-444-4444',
                ),
              ],
            ),
          ),
          'Blue': DogInfo.populated(
            age: 3,
            friendly: false,
            collar: Collar.populated(
              color: 'Blue',
              contacts: [
                Contact.populated(
                  address: '789 Main St.',
                  phone: '333-333-3333',
                ),
                Contact.populated(
                  address: '012 Main St.',
                  phone: '222-222-2222',
                ),
              ],
            ),
          ),
        },
      );
      final parsed = Pets.parse(json);
      expect(parsed, populated);
      expect(parsed.toJson(), json);
      expect(populated.toJson(), json);

      void check(Pets pets) {
        expect(pets.dogs.length, 2);
        expect(pets.dogs['Fido'], isNotNull);
        expect(pets.dogs['Fido']!.age, 5);
        expect(pets.dogs['Fido']!.friendly, true);
        expect(pets.dogs['Fido']!.collar.color, 'Red');
        expect(pets.dogs['Fido']!.collar.contacts.length, 2);
        expect(pets.dogs['Fido']!.collar.contacts[0].address, '123 Main St.');
        expect(pets.dogs['Fido']!.collar.contacts[0].phone, '555-555-5555');
        expect(pets.dogs['Fido']!.collar.contacts[1].address, '456 Main St.');
        expect(pets.dogs['Fido']!.collar.contacts[1].phone, '444-444-4444');
        expect(pets.dogs['Blue'], isNotNull);
        expect(pets.dogs['Blue']!.age, 3);
        expect(pets.dogs['Blue']!.friendly, false);
        expect(pets.dogs['Blue']!.collar.color, 'Blue');
        expect(pets.dogs['Blue']!.collar.contacts.length, 2);
        expect(pets.dogs['Blue']!.collar.contacts[0].address, '789 Main St.');
        expect(pets.dogs['Blue']!.collar.contacts[0].phone, '333-333-3333');
        expect(pets.dogs['Blue']!.collar.contacts[1].address, '012 Main St.');
        expect(pets.dogs['Blue']!.collar.contacts[1].phone, '222-222-2222');
      }

      check(parsed);
      check(populated);
    },
  );
}
