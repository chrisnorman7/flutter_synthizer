import 'dart:async';
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

  /// Get a generator from [buffer].
  BufferGenerator getGenerator({
    required final Buffer buffer,
    required final Source source,
    required final double gain,
    required final bool looping,
    required final bool? linger,
    required final bool destroy,
  }) {
    final generator = synthizerContext.createBufferGenerator(
      buffer: buffer,
    )
      ..gain.value = gain
      ..looping.value = looping
      ..configDeleteBehavior(linger: linger ?? destroy);
    source.addGenerator(generator);
    if (destroy) {
      generator.destroy();
    }
    return generator;
  }

  /// Play a sound from [assetPath].
  ///
  /// If [destroy] is `true`, then the resulting [BufferGenerator] will be
  /// scheduled for destruction.
  ///
  /// If [linger] is `true`, the sound will continue playing until it has
  /// finished, even after it has been deleted. If [linger] is `null`, then
  /// [destroy] will be used instead.
  Future<BufferGenerator> playAssetPath({
    required final String assetPath,
    required final Source source,
    required final bool destroy,
    final bool? linger,
    final double gain = 0.7,
    final bool looping = false,
  }) async {
    final buffer = await bufferCache.getAssetBuffer(this, assetPath);
    return getGenerator(
      buffer: buffer,
      source: source,
      gain: gain,
      looping: looping,
      linger: linger,
      destroy: destroy,
    );
  }

  /// Play a sound from [filePath].
  BufferGenerator playFilePath({
    required final String filePath,
    required final Source source,
    required final bool destroy,
    final bool? linger,
    final double gain = 0.7,
    final bool looping = false,
  }) {
    final buffer = bufferCache.getFileBuffer(filePath);
    return getGenerator(
      buffer: buffer,
      source: source,
      gain: gain,
      looping: looping,
      linger: linger,
      destroy: destroy,
    );
  }

  /// Play a sound from [bufferReference].
  FutureOr<BufferGenerator> playBufferReference({
    required final BufferReference bufferReference,
    required final Source source,
    required final bool destroy,
    final bool? linger,
    final double gain = 0.7,
    final bool looping = false,
  }) async {
    final buffer = await bufferCache.getBuffer(
      context: this,
      bufferReference: bufferReference,
    );
    return getGenerator(
      buffer: buffer,
      source: source,
      gain: gain,
      looping: looping,
      linger: linger,
      destroy: destroy,
    );
  }
}

/// Useful methods for generators.
extension FlutterSynthizerGeneratorExtensions on GainMixin {
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
  /// This method is mainly useful for setting `Context.orientation.value`.
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

/// Useful extension methods for sources.
extension FlutterSynthizerSourceExtension on Source {
  /// Add an input.
  void addInput(final SynthizerObject input) =>
      context.configRoute(this, input);

  /// Remove an input.
  void removeInput(final SynthizerObject input) =>
      context.removeRoute(this, input);
}
