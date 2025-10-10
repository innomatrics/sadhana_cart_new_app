import 'dart:developer';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:typed_data';
import 'dart:io';

class CustomCacheManager {
  static final CacheManager cacheManager = CacheManager(
    Config(
      'customCache',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 1000,
      repo: JsonCacheInfoRepository(databaseName: 'customCacheRepo'),
      fileService: HttpFileService(),
    ),
  );

  Future<File> getFile(String url) async {
    return cacheManager.getSingleFile(url);
  }

  // Storing a file in cache
  Future<void> putFile(
    String url,
    Uint8List fileBytes, {
    String? key,
    Duration maxAge = const Duration(days: 30),
    String fileExtension = 'jpg',
  }) async {
    final file = await cacheManager.putFile(
      url,
      fileBytes,
      key: key,
      maxAge: maxAge,
      fileExtension: fileExtension,
    );
    log("File saved: $file");
  }

  // Remove a file from cache
  Future<void> removeFile(String url) async {
    await cacheManager.removeFile(url);
  }

  // Empty the cache
  Future<void> emptyCache() async {
    await cacheManager.emptyCache();
  }

  // Dispose of the cache manager
  Future<void> dispose() async {
    await cacheManager.dispose();
  }
}
