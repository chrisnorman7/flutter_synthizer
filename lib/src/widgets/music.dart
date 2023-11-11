import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../../flutter_synthizer.dart';

/// A widget that plays music.
class Music extends StatefulWidget {
  /// Create an instance.
  const Music({
    required this.assetPath,
    required this.source,
    required this.child,
    this.gain = 0.7,
    this.fadeOutLength,
    super.key,
  });

  /// The asset path to use for the music.
  final String assetPath;

  /// The source to play music through.
  final Source source;

  /// The widget below this one in the tree.
  final Widget child;

  /// The gain to use.
  final double gain;

  /// The fade out time to use.
  final double? fadeOutLength;

  /// Create state for this widget.
  @override
  MusicState createState() => MusicState();
}

/// State for [Music].
class MusicState extends State<Music> {
  /// The generator to use.
  BufferGenerator? generator;

  /// Load the music.
  Future<void> loadMusic() async {
    final synthizerScope = context.synthizerScope;
    final buffer =
        await synthizerScope.bufferCache.getBuffer(context, widget.assetPath);
    final g = synthizerScope.synthizerContext.createBufferGenerator(
      buffer: buffer,
    )
      ..gain.value = widget.gain
      ..looping.value = true
      ..configDeleteBehavior(linger: true);
    widget.source.addGenerator(g);
    generator = g;
  }

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    loadMusic();
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    final fadeLength = widget.fadeOutLength;
    if (fadeLength != null) {
      generator?.fade(
        fadeLength: fadeLength,
        startGain: widget.gain,
        endGain: 0.0,
      );
    }
    generator?.destroy();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => widget.child;
}
