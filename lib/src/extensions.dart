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
