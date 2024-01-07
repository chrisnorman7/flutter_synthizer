import 'buffer_cache.dart';

/// The type of a path.
///
/// This enum is used by [BufferCache.getAssetBuffer].
enum PathType {
  /// A Flutter asset.
  asset,

  /// A file on the filesystem.
  file,
}
