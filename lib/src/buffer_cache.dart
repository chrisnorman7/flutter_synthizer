import 'dart:typed_data';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../widgets/synthizer_scope.dart';

/// A cache for storing buffers.
///
/// This class allows you to keep getting buffers without worrying about how
/// much memory is being used.
class BufferCache {
  /// Create an instance.
  BufferCache({
    required this.synthizer,
    required this.maxSize,
  })  : _size = 0,
        bufferPaths = [],
        buffers = {};

  /// The synthizer instance to use.
  ///
  /// This object is used by [getBuffer].
  final Synthizer synthizer;

  /// The maximum size of the cache.
  ///
  /// The total [_size] of all buffers will never rise above [maxSize].
  ///
  /// If this value is set too low, you may find some buffers being destroyed
  /// while they're still in use.
  ///
  /// By default, [SynthizerScope] uses 1 [gigabyte].
  final int maxSize;

  /// The loaded buffers.
  ///
  /// Every time [getBuffer] is called, the resulting buffer is added to this
  /// list.
  final Map<String, Buffer> buffers;

  /// The paths of the loaded [buffers].
  ///
  /// Every time [getBuffer] is used, the loaded asset path is added to this
  /// list.
  final List<String> bufferPaths;

  int _size;

  /// The size of the loaded [buffers].
  ///
  /// Every time [getBuffer] is used, the size of the resulting buffer will be
  /// added to this value.
  int get size => _size;

  /// Get a buffer from [assetPath].
  ///
  /// The [assetPath] must be present in the [DefaultAssetBundle].
  ///
  /// The life cycle of the resulting [Buffer] will be handled by this instance.
  Future<Buffer> getBuffer(
    final BuildContext context,
    final String assetPath,
  ) =>
      getBufferFromAssetBundle(
        assetBundle: DefaultAssetBundle.of(context),
        assetPath: assetPath,
      );

  /// Get a buffer from [assetBundle].
  Future<Buffer> getBufferFromAssetBundle({
    required final AssetBundle assetBundle,
    required final String assetPath,
  }) async {
    final b = buffers[assetPath];
    if (b != null) {
      return b;
    }
    final data = await assetBundle.load(assetPath);
    final bytes = Uint8List.sublistView(data);
    final buffer = Buffer.fromBytes(synthizer, bytes);
    bufferPaths.add(assetPath);
    buffers[assetPath] = buffer;
    _size += buffer.size;
    while (_size > maxSize) {
      prune();
    }
    return buffer;
  }

  /// Remove the oldest [Buffer] from [buffers], as well as the oldest asset
  /// path from [bufferPaths].
  void prune() {
    final path = bufferPaths.removeAt(0);
    final buffer = buffers.remove(path)!;
    _size -= buffer.size;
    buffer.destroy();
  }

  /// Destroy every [Buffer] in [buffers], and remove all [bufferPaths].
  ///
  /// This method is called by [SynthizerScopeState.dispose()].
  void destroy() {
    while (_size > 0) {
      prune();
    }
  }
}
