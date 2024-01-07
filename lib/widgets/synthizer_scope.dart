import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../src/buffer_cache.dart';

/// A gigabyte.
const gigabyte = 1073741824;

/// A widget which holds and maintains the life cycle of synthizer objects.
///
/// There must be one and only one instance of this widget, and it must be
/// placed as close to the top of the widget tree as possible, in particular,
/// above the [MaterialApp] widget.
class SynthizerScope extends StatefulWidget {
  /// Create an instance.
  const SynthizerScope({
    required this.child,
    this.bufferCacheMaxSize = gigabyte,
    super.key,
  });

  /// Possibly return the nearest instance.
  static SynthizerScopeState? maybeOf(final BuildContext context) =>
      context.findAncestorStateOfType<SynthizerScopeState>();

  /// Return the nearest instance.
  static SynthizerScopeState of(final BuildContext context) =>
      maybeOf(context)!;

  /// The maximum size of the buffer cache to use.
  final int bufferCacheMaxSize;

  /// The widget below this widget in the tree.
  ///
  /// If this widget is placed above the [MaterialApp], [child] does not need to
  /// be a [Builder].
  final Widget child;

  /// Create state for this widget.
  @override
  SynthizerScopeState createState() => SynthizerScopeState();
}

/// State for [SynthizerScope].
class SynthizerScopeState extends State<SynthizerScope> {
  /// The synthizer instance to be used for creating objects such as
  /// [synthizerContext], and buffers in the [bufferCache].
  late final Synthizer synthizer;

  /// The synthizer context to use.
  ///
  /// This context should be used whenever [synthizer] objects are created.
  late final Context synthizerContext;

  /// The buffer cache to use.
  ///
  /// This buffer cache will use the [widget]'s
  /// [SynthizerScope.bufferCacheMaxSize].
  late final BufferCache bufferCache;

  /// Initialise state.
  ///
  /// This method calls [synthizer.initialize()], and creates [synthizerContext]
  /// and [bufferCache].
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
  ///
  /// This method calls `synthizer.shutdown()`, `synthizerContext.destroy()`,
  /// and `bufferCache.destroy()`.
  @override
  void dispose() {
    super.dispose();
    bufferCache.destroy();
    synthizerContext.destroy();
    synthizer.shutdown();
  }

  /// Build a widget.
  ///
  /// This method only returns the [widget]'s [SynthizerScope.child].
  @override
  Widget build(final BuildContext context) => widget.child;
}
