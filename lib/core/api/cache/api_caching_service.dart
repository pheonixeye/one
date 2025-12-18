// import 'package:one/core/api/_api_result.dart';

// typedef ParametrizedQueryName = String;

// //todo: Needs to be simplified - way more that this
// class _CacheDataStore<T> {
//   _CacheDataStore();

//   final Map<ParametrizedQueryName, ApiDataResult<T>?> _dataCache = {};

//   Map<ParametrizedQueryName, ApiDataResult<T>?> get dataCache => _dataCache;
// }

// class ApiCachingService<T> {
//   ApiCachingService();

//   final _cache = _CacheDataStore<T>().dataCache;

//   Map<ParametrizedQueryName, ApiDataResult?> get cache => _cache;

//   void addToCache(ParametrizedQueryName key, ApiDataResult<T> cachable) {
//     _cache[key] = cachable;
//   }

//   void invalidateCache(ParametrizedQueryName key) {
//     _cache[key] = null;
//   }

//   bool operationIsCached(
//     ParametrizedQueryName key,
//   ) {
//     final _classIsCached = _cache[key] != null;
//     if (_classIsCached) {
//       return true;
//     }
//     return false;
//   }

//   ApiDataResult<T>? getDataByKeys(
//     ParametrizedQueryName key,
//   ) {
//     final _classIsCached = _cache[key] != null;

//     if (_classIsCached) {
//       return _cache[key]!;
//     }
//     return null;
//   }
// }
