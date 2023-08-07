// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:phitnest_core/core.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:test/test.dart';

// const testObj1 = TestJson2(
//   [
//     {
//       'mapKey1': TestJson1(1),
//       'mapKey2': TestJson1(2),
//     },
//     {
//       'mapKey2': TestJson1(2),
//       'mapKey3': TestJson1(3),
//     }
//   ],
//   1,
//   true,
// );

// const testObj2 = TestJson2(
//   [
//     {
//       'mapKey2': TestJson1(-2),
//       'mapKey3': TestJson1(-3),
//     },
//     {
//       'mapKey4': TestJson1(-4),
//       'mapKey5': TestJson1(-5),
//     }
//   ],
//   5,
//   false,
// );

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences.setMockInitialValues({});
//   FlutterSecureStorage.setMockInitialValues({});

//   setUp(
//     () async {
//       await initializeCache();
//     },
//   );

//   group(
//     'Cache',
//     () {
//       test(
//         'basic caching',
//         () async {
//           final key = 'key';
//           final str = 'value';
//           await cacheString(key, str);
//           expect(getCachedString(key), equals(str));
//           await cacheString(key, null);
//           expect(getCachedString(key), isNull);
//           final num = 5;
//           await cacheInt(key, num);
//           expect(getCachedInt(key), equals(num));
//         },
//       );

//       test(
//         'caching serializable object',
//         () async {
//           final key = 'key';
//           await cacheObject(key, testObj1);
//           expect(getCachedObject(key, TestJson2.fromJson), equals(testObj1));
//         },
//       );

//       test(
//         'overwriting regular cache',
//         () async {
//           final key = 'key';
//           final str = 'value';
//           await cacheString(key, str);
//           expect(getCachedString(key), equals(str));
//           final str2 = 'value2';
//           await cacheString(key, str2);
//           expect(getCachedString(key), equals(str2));
//           final num = 5;
//           await cacheInt(key, num);
//           expect(getCachedInt(key), equals(num));
//         },
//       );

//       test(
//         'basic secure cache',
//         () async {
//           final key = 'key';
//           final str = 'value';
//           await cacheSecureString(key, str);
//           expect(getSecureCachedString(key), equals(str));
//           await cacheSecureString(key, null);
//           expect(getSecureCachedString(key), isNull);
//           final num = 5;
//           await cacheSecureInt(key, num);
//           expect(getSecureCachedInt(key), equals(num));
//         },
//       );

//       test(
//         'caching serializable object',
//         () async {
//           final key = 'key';
//           await cacheSecureObject(key, testObj1);
//           expect(
//               getSecureCachedObject(key, TestJson2.fromJson), equals(testObj1));
//         },
//       );
//     },
//   );
// }
