part of '../auth.dart';

const kSandboxEmailJsonKey = 'email';
const kSandboxPasswordJsonKey = 'password';
const kSandboxConfirmedJsonKey = 'confirmed';
const kSandboxUserIdJsonKey = 'userId';
const kUserAttributesJsonKey = 'userAttributes';
const kAttributeNameJsonKey = 'name';
const kAttributeValueJsonKey = 'value';

class SerializableAttribute extends JsonSerializable {
  final AttributeArg attributes;

  const SerializableAttribute(this.attributes) : super();

  @override
  Map<String, Serializable> toJson() => {
        kAttributeNameJsonKey:
            SerializablePrimitive.string(attributes.name ?? ''),
        kAttributeValueJsonKey:
            SerializablePrimitive.string(attributes.value ?? ''),
      };
}

class SandboxUserData extends JsonSerializable with EquatableMixin {
  final String email;
  final String userId;
  final String password;
  final bool confirmed;
  final List<AttributeArg> userAttributes;

  const SandboxUserData({
    required this.email,
    required this.userId,
    required this.password,
    required this.confirmed,
    required this.userAttributes,
  }) : super();

  @override
  List<Object?> get props => [
        email,
        userId,
        password,
        confirmed,
        userAttributes,
      ];

  factory SandboxUserData.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          kSandboxEmailJsonKey: final String email,
          kSandboxPasswordJsonKey: final String password,
          kSandboxConfirmedJsonKey: final bool confirmed,
          kSandboxUserIdJsonKey: final String userId,
          kUserAttributesJsonKey: final List<Map<String, String>> attributes
        } =>
          SandboxUserData(
            email: email,
            password: password,
            confirmed: confirmed,
            userId: userId,
            userAttributes: attributes
                .map((att) => switch (att) {
                      {
                        kAttributeNameJsonKey: final String name,
                        kAttributeValueJsonKey: final String value
                      } =>
                        AttributeArg(name: name, value: value),
                      _ => throw FormatException('Invalid attribute: $att'),
                    })
                .toList(),
          ),
        _ => throw FormatException('Invalid json: $json'),
      };

  @override
  Map<String, Serializable> toJson() => {
        kSandboxEmailJsonKey: SerializablePrimitive.string(email),
        kSandboxPasswordJsonKey: SerializablePrimitive.string(password),
        kSandboxConfirmedJsonKey: SerializablePrimitive.bool(confirmed),
        kSandboxUserIdJsonKey: SerializablePrimitive.string(userId),
        kUserAttributesJsonKey: SerializableList(
            userAttributes.map((att) => SerializableAttribute(att)).toList()),
      };
}
