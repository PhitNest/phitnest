import 'package:phitnest_core/json.dart';
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
  final dogsJson = Json.objectMap('dogs', DogInfo.new);

  Map<String, DogInfo> get dogs => dogsJson.value;

  Pets() : super();

  Pets.parse(super.json) : super.parse();

  Pets.populated({
    required Map<String, DogInfo> dogs,
  }) : super() {
    dogsJson.value = dogs;
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [dogsJson];
}

void main() {
  test(
    'JSON serialization',
    () {
      final fidoAge = 5;
      final fidoFriendly = true;
      final fidoCollarColor = 'Red';
      final fidoCollarAddress1 = '123 Main St.';
      final fidoCollarPhone1 = '555-555-5555';
      final fidoCollarAddress2 = '456 Main St.';
      final fidoCollarPhone2 = '444-444-4444';
      final fidoContacts = [
        {
          'address': fidoCollarAddress1,
          'phone': fidoCollarPhone1,
        },
        {
          'address': fidoCollarAddress2,
          'phone': fidoCollarPhone2,
        },
      ];
      final fidoCollar = {
        'color': fidoCollarColor,
        'contacts': fidoContacts,
      };
      final blueAge = 3;
      final blueFriendly = false;
      final blueCollarColor = 'Blue';
      final blueCollarAddress1 = '789 Main St.';
      final blueCollarPhone1 = '333-333-3333';
      final blueCollarAddress2 = '012 Main St.';
      final blueCollarPhone2 = '222-222-2222';
      final blueContacts = [
        {
          'address': blueCollarAddress1,
          'phone': blueCollarPhone1,
        },
        {
          'address': blueCollarAddress2,
          'phone': blueCollarPhone2,
        },
      ];
      final blueCollar = {
        'color': blueCollarColor,
        'contacts': blueContacts,
      };
      final fido = {
        'age': fidoAge,
        'friendly': fidoFriendly,
        'collar': fidoCollar,
      };
      final blue = {
        'age': blueAge,
        'friendly': blueFriendly,
        'collar': blueCollar,
      };
      final dogs = {
        'Fido': fido,
        'Blue': blue,
      };
      final json = {
        'dogs': dogs,
      };
      final populated = Pets.populated(
        dogs: {
          'Fido': DogInfo.populated(
            age: fidoAge,
            friendly: fidoFriendly,
            collar: Collar.populated(
              color: fidoCollarColor,
              contacts: [
                Contact.populated(
                  address: fidoCollarAddress1,
                  phone: fidoCollarPhone1,
                ),
                Contact.populated(
                  address: fidoCollarAddress2,
                  phone: fidoCollarPhone2,
                ),
              ],
            ),
          ),
          'Blue': DogInfo.populated(
            age: blueAge,
            friendly: blueFriendly,
            collar: Collar.populated(
              color: blueCollarColor,
              contacts: [
                Contact.populated(
                  address: blueCollarAddress1,
                  phone: blueCollarPhone1,
                ),
                Contact.populated(
                  address: blueCollarAddress2,
                  phone: blueCollarPhone2,
                ),
              ],
            ),
          ),
        },
      );
      final parsed = Pets.parse(json);
      expect(parsed, populated, reason: 'Parsed JSON should match populated.');
      expect(parsed.toJson(), json,
          reason: 'toJson() should match JSON used for parsing.');
      expect(populated.toJson(), json,
          reason: 'toJson() should match reference JSON.');

      void check(Pets pets) {
        expect(pets.dogs.length, 2, reason: 'Should have two dogs.');
        expect(pets.dogsJson.serialized, dogs,
            reason: 'Serialized object map should match reference JSON.');
        expect(JsonObjectMap.populated('dogs', pets.dogs), pets.dogsJson,
            reason:
                'JsonObjectMap.populated() should match populated object map.');

        void checkDog(
          DogInfo dog,
          Map<String, Object> dogJson,
          int dogAge,
          bool dogFriendly,
          Map<String, Object> dogCollar,
          String dogCollarColor,
          List<Map<String, String>> dogCollarContacts,
          String dogCollarAddress1,
          String dogCollarPhone1,
          String dogCollarAddress2,
          String dogCollarPhone2,
        ) {
          expect(dog.toJson(), dogJson, reason: 'Dog JSON should match.');
          expect(dog.age, dogAge, reason: 'Dog age should match.');
          expect(dog.ageJson.serialized, dogAge,
              reason: 'Dog age JSON should match the int.');
          expect(JsonInt.populated('age', dogAge), dog.ageJson,
              reason: 'JsonInt.populated() should match populated int.');
          expect(dog.friendly, dogFriendly,
              reason: 'Dog friendly should match.');
          expect(dog.friendlyJson.serialized, dogFriendly,
              reason: 'Dog friendly JSON should match the bool.');
          expect(JsonBool.populated('friendly', dogFriendly), dog.friendlyJson,
              reason: 'JsonBool.populated() should match populated bool.');
          expect(dog.collarJson.serialized, dogCollar,
              reason: 'Dog collar JSON should match.');
          expect(JsonObject.populated('collar', dog.collar), dog.collarJson,
              reason: 'JsonObject.populated() should match populated object.');
          expect(dog.collar.color, dogCollarColor,
              reason: 'Dog collar color should match.');
          expect(dog.collar.colorJson.serialized, dogCollarColor,
              reason: 'Dog collar color JSON should match the string.');
          expect(JsonString.populated('color', dogCollarColor),
              dog.collar.colorJson,
              reason: 'JsonString.populated() should match populated string.');
          expect(dog.collar.contacts.length, 2,
              reason: 'Should have two contacts.');
          expect(dog.collar.contactsJson.serialized, dogCollarContacts,
              reason: 'Dog collar contacts JSON should match.');
          expect(JsonObjectList.populated('contacts', dog.collar.contacts),
              dog.collar.contactsJson,
              reason:
                  'JsonObjectList.populated() should match populated list.');
          expect(dog.collar.contacts[0].address, dogCollarAddress1,
              reason: 'Dog collar contact address should match.');
          expect(
              dog.collar.contacts[0].addressJson.serialized, dogCollarAddress1,
              reason:
                  'Dog collar contact address JSON should match the string.');
          expect(dog.collar.contacts[0].phone, dogCollarPhone1,
              reason: 'Dog collar contact phone should match.');
          expect(dog.collar.contacts[0].phoneJson.serialized, dogCollarPhone1,
              reason: 'Dog collar contact phone JSON should match the string.');
          expect(dog.collar.contacts[1].address, dogCollarAddress2,
              reason: 'Dog collar contact address should match.');
          expect(
              dog.collar.contacts[1].addressJson.serialized, dogCollarAddress2,
              reason:
                  'Dog collar contact address JSON should match the string.');
          expect(dog.collar.contacts[1].phone, dogCollarPhone2,
              reason: 'Dog collar contact phone should match.');
          expect(dog.collar.contacts[1].phoneJson.serialized, dogCollarPhone2,
              reason: 'Dog collar contact phone JSON should match the string.');
        }

        expect(pets.dogs['Fido'], isNotNull, reason: 'Fido should be present.');
        checkDog(
          pets.dogs['Fido']!,
          fido,
          fidoAge,
          fidoFriendly,
          fidoCollar,
          fidoCollarColor,
          fidoContacts,
          fidoCollarAddress1,
          fidoCollarPhone1,
          fidoCollarAddress2,
          fidoCollarPhone2,
        );
        expect(pets.dogs['Blue'], isNotNull, reason: 'Blue should be present.');
        checkDog(
          pets.dogs['Blue']!,
          blue,
          blueAge,
          blueFriendly,
          blueCollar,
          blueCollarColor,
          blueContacts,
          blueCollarAddress1,
          blueCollarPhone1,
          blueCollarAddress2,
          blueCollarPhone2,
        );
      }

      check(parsed);
      check(populated);
    },
  );
}
