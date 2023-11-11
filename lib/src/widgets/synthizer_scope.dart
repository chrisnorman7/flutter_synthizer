import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../buffer_cache.dart';

/// A gigabyte.
const gigabyte = 1073741824;

/// A widget which holds synthizer objects.
class SynthizerScope extends StatefulWidget {
  /// Create an instance.
  const SynthizerScope({
    required this.child,
    this.bufferCacheMaxSize = gigabyte,
    super.key,
  });

  /// Return the nearest instance.
  static SynthizerScopeState? of(final BuildContext context) =>
      context.findAncestorStateOfType<SynthizerScopeState>();

  /// The maximum size of the buffer cache to use.
  final int bufferCacheMaxSize;

  /// The child below this one in the tree.
  final Widget child;

  /// Create state for this widget.
  @override
  SynthizerScopeState createState() => SynthizerScopeState();
}

/// State for [SynthizerScope].
class SynthizerScopeState extends State<SynthizerScope> {
  /// The synthizer instance to use.
  late final Synthizer synthizer;

  /// The synthizer context to use.
  late final Context synthizerContext;

  /// The buffer cache to use.
  late final BufferCache bufferCache;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    synthizer = Synthizer()..initialize();
    synthizerContext = synthizer.createContext();
    bufferCache = BufferCache(
      synthizer: synthizer,
      maxSize: widget.bufferCacheMaxSize,
    );
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    while (bufferCache.bufferPaths.isNotEmpty) {
      bufferCache.prune();
    }
    synthizerContext.destroy();
    synthizer.shutdown();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => widget.child;
}
