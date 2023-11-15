import 'dart:math';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../flutter_synthizer.dart';

/// Useful methods for finding synthizer objects.
extension FlutterSynthizerBuildContextExtensions on BuildContext {
  /// Get a synthizer scope from the widget tree.
  SynthizerScopeState get synthizerScope => SynthizerScope.of(this);

  /// Get the synthizer object from the nearest [synthizerScope].
  Synthizer get synthizer => synthizerScope.synthizer;

  /// Get the synthizer context from the nearest [synthizerScope].
  Context get synthizerContext => synthizerScope.synthizerContext;

  /// Get the buffer cache from the nearest [synthizerScope].
  BufferCache get bufferCache => synthizerScope.bufferCache;

  /// Play a simple sound.
  ///
  /// If [destroy] is `true`, then the resulting [BufferGenerator] will be
  /// scheduled for destruction. Either way, `linger` is configured to be
  /// `true`.
  Future<BufferGenerator> playSound({
    required final String assetPath,
    required final Source source,
    final double gain = 0.7,
    final bool destroy = false,
  }) async {
    final scope = synthizerScope;
    final buffer = await scope.bufferCache.getBuffer(this, assetPath);
    final generator = scope.synthizerContext.createBufferGenerator(
      buffer: buffer,
    )
      ..gain.value = gain
      ..configDeleteBehavior(linger: true);
    source.addGenerator(generator);
    if (destroy) {
      generator.destroy();
    }
    return generator;
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

/// Useful methods for converting [double]s.
extension FlutterSynthizerDoubleExtension on double {
  /// Create a [Double6], using this [double] as an angle.
  ///
  /// This method is mainly useful for setting [Context.orientation.value].
  Double6 angleToDouble6() => Double6(
        sin(this * pi / 180),
        cos(this * pi / 180),
        0.0,
        0.0,
        0.0,
        1.0,
      );
}

/// Useful methods for audio contexts.
extension FlutterSynthizerContextExtension on Context {
  /// Set the [orientation] from [angle].
  void setOrientationFromAngle(final double angle) =>
      orientation.value = angle.angleToDouble6();
}
