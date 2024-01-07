import 'package:quiver/core.dart';

import '../../flutter_synthizer.dart';

/// A reference to a buffer in a [BufferCache].
class BufferReference {
  /// Create an instance.
  const BufferReference({
    required this.path,
    required this.pathType,
  });

  /// The path to load from.
  final String path;

  /// The type of the object that [path] refers to.
  final PathType pathType;

  /// Return a hash code based on [path] and [pathType].
  @override
  int get hashCode => hash2(path, pathType);

  /// Test equality.
  @override
  bool operator ==(final Object other) {
    if (other is BufferReference) {
      return other.path == path && other.pathType == pathType;
    }
    return super == other;
  }
}
