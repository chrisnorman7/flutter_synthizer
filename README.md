# flutter_synthizer

## description

This package provides classes and convenience methods for using
[dart_synthizer](https://pub.dev/packages/dart_synthizer) from within
[Flutter](https://flutter.dev/).

## Getting Started

Begin by wrapping your [MaterialApp](https://api.flutter.dev/flutter/material/MaterialApp-class.html) in a `SynthizerScope` instance:

```dart
  Widget build(final BuildContext context) {
    final synthizerScope = SynthizerScope.of(context);
    ...
  }
```

Now you can use properties of the scope as you would expect.
