import 'dart:typed_data';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

/// A cache for storing buffers.
class BufferCache {
  /// Create an instance.
  BufferCache({
    required this.synthizer,
    required this.maxSize,
  })  : size = 0,
        bufferPaths = [],
        buffers = {};

  /// The synthizer instance to use.
  final Synthizer synthizer;

  /// The maximum size of the cache.
  final int maxSize;

  /// The loaded buffers.
  final Map<String, Buffer> buffers;

  /// The paths of the loaded [buffers].
  final List<String> bufferPaths;

  /// The size of the loaded [buffers].
  int size;

  /// Get a buffer from [assetPath].
  Future<Buffer> getBuffer(
    final BuildContext context,
    final String assetPath,
  ) async {
    final b = buffers[assetPath];
    if (b != null) {
      return b;
    }
    final data = await DefaultAssetBundle.of(context).load(assetPath);
    final bytes = Uint8List.sublistView(data);
    final buffer = Buffer.fromBytes(synthizer, bytes);
    bufferPaths.add(assetPath);
    buffers[assetPath] = buffer;
    size += buffer.size;
    while (size > maxSize) {
      prune();
    }
    return buffer;
  }

  /// Prune [buffers].
  void prune() {
    final path = bufferPaths.removeAt(0);
    final buffer = buffers.remove(path)!;
    size -= buffer.size;
    buffer.destroy();
  }

  /// Destroy this buffer.
  void destroy() {
    while (size > 0) {
      prune();
    }
  }
}
