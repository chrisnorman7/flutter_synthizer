/// A package for managing synthizer objects from Flutter.
///
/// You must place a [SynthizerScope] widget as close to the top of the widget
/// tree as possible.
///
/// To retrieve synthizer objects, you can either use the [SynthizerScope.of]
/// static methods, or the extension methods found in
/// [FlutterSynthizerBuildContextExtensions].
library flutter_synthizer;

import 'src/extensions.dart';
import 'widgets/synthizer_scope.dart';

export 'src/buffer_cache/buffer_cache.dart';
export 'src/buffer_cache/buffer_reference.dart';
export 'src/buffer_cache/path_type.dart';
export 'src/extensions.dart';
export 'widgets/synthizer_scope.dart';
