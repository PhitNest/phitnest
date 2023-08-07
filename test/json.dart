// import 'package:phitnest_core/serializable.dart';

// final class TestJson1 extends JsonSerializable {
//   final int val;

//   const TestJson1(this.val) : super();

//   factory TestJson1.fromJson(Map<String, dynamic> json) => switch (json) {
//         ({
//           'val': final int val,
//         }) =>
//           TestJson1(val),
//         _ => throw FormatException(
//             'Invalid JSON for root of TestJson1',
//             json,
//           ),
//       };

//   @override
//   Map<String, Serializable> json() => {
//         'val': SerializableInt(val),
//       };

//   @override
//   List<Object?> get props => [val];
// }

// final class TestJson2 extends JsonSerializable {
//   final List<Map<String, TestJson1>> key1;
//   final int key2;
//   final bool key3;

//   const TestJson2(
//     this.key1,
//     this.key2,
//     this.key3,
//   ) : super();

//   factory TestJson2.fromJson(Map<String, dynamic> json) => switch (json) {
//         ({
//           'key1': final List<dynamic> key1,
//           'key2': final int key2,
//           'key3': final bool key3
//         }) =>
//           TestJson2(
//             key1
//                 .map(
//                   (e) => switch (e) {
//                     Map<String, dynamic>() => e.map(
//                         (key, value) => MapEntry(
//                           key,
//                           switch (value) {
//                             Map<String, dynamic>() => TestJson1.fromJson(value),
//                             _ => throw FormatException(
//                                 'Invalid JSON for key1 of TestJson2',
//                                 json,
//                               ),
//                           },
//                         ),
//                       ),
//                     _ => throw FormatException(
//                         'Invalid JSON for key1 of TestJson2',
//                         json,
//                       ),
//                   },
//                 )
//                 .toList(),
//             key2,
//             key3,
//           ),
//         _ => throw FormatException(
//             'Invalid JSON for root of TestJson2',
//             json,
//           ),
//       };

//   @override
//   Map<String, Serializable> json() => {
//         'key1': SerializableList(
//           key1.map((e) => SerializableMap(e)).toList(),
//         ),
//         'key2': SerializableInt(key2),
//         'key3': SerializableBool(key3),
//       };

//   @override
//   List<Object?> get props => [key1, key2, key3];
// }
