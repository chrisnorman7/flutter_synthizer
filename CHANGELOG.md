# Changelog

## 0.6.0

- Allow loading buffers from file paths as well as assets.

## 0.5.0

- Renamed `BuildContext.playSound` to `BuildContext.playAssetPath`.

## 0.4.1

- Stop enforcing `linger`.

## 0.4.0

- Added more parameters to `BuildContext.playSound`.

## 0.3.4

- Fixed a bug which was introduced in 0.3.3.

## 0.3.3

- Don't configure linger when `destroy` is `true`.

## 0.3.2

- Affected the change from `0.3.1` that I didn't actually do.

## 0.3.1

- Made the `destroy` argument to `BuildContext.playSound` mandatory.

## 0.3.0

- Added the `addInput` and `removeInput` extension methods to `Source`s.

## 0.2.0

- Made arguments on `BufferCache.getBufferFromAssetBundle` positional.

## 0.1.0

- Added the `getBufferFromAssetBundle` method.
- Made `fade` work on any `SynthizerObject` which has `gain`.`

## 0.0.2

- Added a proper license.

## 0.0.1

- Initial release.
