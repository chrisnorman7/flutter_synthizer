import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../../widgets/synthizer_scope.dart';
import 'buffer_reference.dart';
import 'path_type.dart';

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
  /// This object is used by [getAssetBuffer].
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
  /// Every time [getAssetBuffer] is called, the resulting buffer is added to
  /// this map.
  final Map<BufferReference, Buffer> buffers;

  /// The paths of the loaded [buffers].
  ///
  /// Every time [getAssetBuffer] is used, the loaded asset path is added to
  /// this list.
  final List<BufferReference> bufferPaths;

  int _size;

  /// The size of the loaded [buffers].
  ///
  /// Every time [getAssetBuffer] is used, the size of the resulting buffer will
  /// be added to this value.
  int get size => _size;

  /// Get a buffer from the provided [bufferReference].
  FutureOr<Buffer> getBuffer({
    required final BuildContext context,
    required final BufferReference bufferReference,
  }) async {
    switch (bufferReference.pathType) {
      case PathType.asset:
        return getAssetBuffer(context, bufferReference.path);
      case PathType.file:
        return getFileBuffer(bufferReference.path);
    }
  }

  /// Get a buffer from [assetPath].
  ///
  /// The [assetPath] must be present in the [DefaultAssetBundle].
  ///
  /// The life cycle of the resulting [Buffer] will be handled by this instance.
  Future<Buffer> getAssetBuffer(
    final BuildContext context,
    final String assetPath,
  ) =>
      getBufferFromAssetBundle(
        DefaultAssetBundle.of(context),
        BufferReference(path: assetPath, pathType: PathType.asset),
      );

  /// Get a buffer from [assetBundle].
  Future<Buffer> getBufferFromAssetBundle(
    final AssetBundle assetBundle,
    final BufferReference bufferReference,
  ) async {
    final b = buffers[bufferReference];
    if (b != null) {
      return b;
    }
    final data = await assetBundle.load(bufferReference.path);
    final bytes = Uint8List.sublistView(data);
    final buffer = Buffer.fromBytes(synthizer, bytes);
    bufferPaths.add(bufferReference);
    buffers[bufferReference] = buffer;
    _size += buffer.size;
    maybePrune();
    return buffer;
  }

  /// Call [prune] if [size] is greater than [maxSize].
  void maybePrune() {
    while (_size > maxSize) {
      prune();
    }
  }

  /// Get a buffer from [path].
  Buffer getFileBuffer(final String path) {
    final bufferReference = BufferReference(
      path: path,
      pathType: PathType.file,
    );
    final b = buffers[bufferReference];
    if (b != null) {
      return b;
    }
    final file = File(path);
    final bytes = file.readAsBytesSync();
    final buffer = Buffer.fromBytes(synthizer, bytes);
    buffers[bufferReference] = buffer;
    bufferPaths.add(bufferReference);
    maybePrune();
    return buffer;
  }

  /// Remove the oldest [Buffer] from [buffers], as well as the oldest asset
  /// path from [bufferPaths].
  void prune() {
    final bufferReference = bufferPaths.removeAt(0);
    final buffer = buffers.remove(bufferReference)!;
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
