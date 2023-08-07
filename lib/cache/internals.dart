// part of 'cache.dart';

// final class _CacheInternals {
//   final bool firstRun;

//   final SharedPreferences sharedPreferences;
//   final FlutterSecureStorage secureStorage;
//   final secureCacheLock = Lock();

//   // secure cache variables
//   final Map<String, String> stringifiedSecureCache;
//   final Map<String, dynamic> lazyLoadedSecureCache;

//   _CacheInternals(
//     this.firstRun,
//     this.sharedPreferences,
//     this.secureStorage,
//     this.stringifiedSecureCache,
//     this.lazyLoadedSecureCache,
//   );

//   /// Function to initialize cache
//   static Future<_CacheInternals> initializeCache() async {
//     final stringifiedSecureCache = <String, String>{};
//     final lazyLoadedSecureCache = <String, dynamic>{};
//     final sharedPreferences = await SharedPreferences.getInstance();
//     final secureStorage = FlutterSecureStorage(
//       aOptions: AndroidOptions(encryptedSharedPreferences: true),
//       iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
//     );
//     final firstRun = sharedPreferences.getBool('first_run') ?? true;

//     // Clear secure storage on first run
//     if (firstRun) {
//       debug('First run. Clearing secure storage.');
//       await secureStorage.deleteAll();
//       await sharedPreferences.setBool('first_run', false);
//     }

//     // Read all secure storage values into cache
//     stringifiedSecureCache.addAll(await secureStorage.readAll());
//     return _CacheInternals(
//       firstRun,
//       sharedPreferences,
//       secureStorage,
//       stringifiedSecureCache,
//       lazyLoadedSecureCache,
//     );
//   }
// }

// /// This is set when the cache is initialized
// _CacheInternals? _cacheInternals;

// /// Get the cache and throw an error if it is not initialized
// _CacheInternals get _cache =>
//     _cacheInternals ??
//     (throw Exception('Cache not initialized. Call initializeCache() first.'));

// Future<void> initializeCache() async =>
//     _cacheInternals = await _CacheInternals.initializeCache();
