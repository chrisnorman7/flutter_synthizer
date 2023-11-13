import 'dart:math';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../flutter_synthizer.dart';

/// Useful methods for finding synthizer objects.
extension FlutterSynthizerBuildContextExtensions on BuildContext {
  /// Get a synthizer scope.
  SynthizerScopeState get synthizerScope => SynthizerScope.of(this)!;

  /// Get the synthizer object.
  Synthizer get synthizer => synthizerScope.synthizer;

  /// Get the synthizer context.
  Context get synthizerContext => synthizerScope.synthizerContext;

  /// Get the buffer cache.
  BufferCache get bufferCache => synthizerScope.bufferCache;

  /// Play a simple sound.
  Future<void> playSound({
    required final String assetPath,
    required final Source source,
    final double gain = 0.7,
  }) async {
    final scope = synthizerScope;
    final buffer = await scope.bufferCache.getBuffer(this, assetPath);
    final generator =
        scope.synthizerContext.createBufferGenerator(buffer: buffer)
          ..gain.value = gain
          ..configDeleteBehavior(linger: true);
    source.addGenerator(generator);
    generator.destroy();
  }
}

/// Useful methods for generators.
extension FlutterSynthizerGeneratorExtensions on Generator {
  /// Fade in or out.
  void fade({
    required final double fadeLength,
    required final double startGain,
    required final double endGain,
  }) {
    final startTime = context.suggestedAutomationTime.value;
    gain.automate(
      startTime: startTime,
      startValue: startGain,
      endTime: startTime + fadeLength,
      endValue: endGain,
    );
  }
}

/// Useful methods.
extension FlutterSynthizerDouble6Extension on Double6 {
  /// Create an instance from an [angle].
  static Double6 fromAngle(final double angle) => Double6(
        sin(angle * pi / 180),
        cos(angle * pi / 180),
        0.0,
        0.0,
        0.0,
        1.0,
      );
}
