import 'dart:convert';
import 'dart:typed_data';

import 'constants.dart';

/// A [base58Bitcoin] encoder and decoder with Bitcoin alphabet.
///
/// It encodes and decodes using the Bitcoin alphabet.
/// It does not allow invalid characters when decoding.
const Base58CodecBitcoin base58Bitcoin = Base58CodecBitcoin();

/// Encodes [input] using [base58Bitcoin] encoding with Bitcoin alphabet.
///
/// Shorthand for `base58Bitcoin.encode(input)`.
/// Useful if a local variable shadows the global [base58Bitcoin] constant.
String base58BitcoinEncode(Uint8List input) => base58Bitcoin.encode(input);

/// Decodes [input] using [base58Bitcoin] decoding with Bitcoin alphabet.
///
/// Shorthand for `base58Bitcoin.decode(input)`.
/// Useful if a local variable shadows the global [base58Bitcoin] constant.
Uint8List base58BitcoinDecode(String input) => base58Bitcoin.decode(input);

/// A [base58Flickr] encoder and decoder with Flickr alphabet.
///
/// It encodes and decodes using the Flickr alphabet.
/// It does not allow invalid characters when decoding.
const Base58CodecFlickr base58Flickr = Base58CodecFlickr();

/// Encodes [input] using [base58Flickr] encoding with Flickr alphabet.
///
/// Shorthand for `base58Flickr.encode(input)`.
/// Useful if a local variable shadows the global [base58Flickr] constant.
String base58FlickrEncode(Uint8List input) => base58Flickr.encode(input);

/// Decodes [input] using [base58Flickr] decoding with Flickr alphabet.
///
/// Shorthand for `base58Flickr.decode(input)`.
/// Useful if a local variable shadows the global [base58Flickr] constant.
Uint8List base58FlickrDecode(String input) => base58Flickr.decode(input);

/// A [base58Ripple] encoder and decoder with Ripple alphabet.
///
/// It encodes and decodes using the Ripple alphabet.
/// It does not allow invalid characters when decoding.
const Base58CodecRipple base58Ripple = Base58CodecRipple();

/// Encodes [input] using [base58Ripple] encoding with Ripple alphabet.
///
/// Shorthand for `base58Ripple.encode(input)`.
/// Useful if a local variable shadows the global [base58Ripple] constant.
String base58RippleEncode(Uint8List input) => base58Ripple.encode(input);

/// Decodes [input] using [base58Ripple] decoding with Ripple alphabet.
///
/// Shorthand for `base58Ripple.decode(input)`.
/// Useful if a local variable shadows the global [base58Ripple] constant.
Uint8List base58RippleDecode(String input) => base58Ripple.decode(input);

/// A [base58Bitcoin] encoder and decoder with Bitcoin alphabet.
///
/// It does not allow invalid characters when decoding.
class Base58CodecBitcoin extends Codec<Uint8List, String> {
  static const String _alphabet =
      "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
  const Base58CodecBitcoin();

  @override
  Converter<Uint8List, String> get encoder => const Base58Encoder(_alphabet);

  @override
  Converter<String, Uint8List> get decoder =>
      const Base58Decoder(_alphabet, bitcoinListBase58);
}

/// A [base58Flickr] encoder and decoder with Flickr alphabet.
///
/// It does not allow invalid characters when decoding.
class Base58CodecFlickr extends Codec<Uint8List, String> {
  static const String _alphabet =
      "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ";
  const Base58CodecFlickr();

  @override
  Converter<Uint8List, String> get encoder => const Base58Encoder(_alphabet);

  @override
  Converter<String, Uint8List> get decoder =>
      const Base58Decoder(_alphabet, flickrListBase58);
}

/// A [base58Ripple] encoder and decoder with Ripple alphabet.
///
/// It does not allow invalid characters when decoding.
class Base58CodecRipple extends Codec<Uint8List, String> {
  static const String _alphabet =
      "rpshnaf39wBUDNEGHJKLM4PQRST7VWXYZ2bcdeCg65jkm8oFqi1tuvAxyz";
  const Base58CodecRipple();

  @override
  Converter<Uint8List, String> get encoder => const Base58Encoder(_alphabet);

  @override
  Converter<String, Uint8List> get decoder =>
      const Base58Decoder(_alphabet, rippleListBase58);
}

/// A Base58 encoder and decoder with custom [alphabet] and given [decodeList].
///
/// It does not allow invalid characters when decoding.
class Base58CodecCustom extends Codec<Uint8List, String> {
  final String alphabet;
  final List<int> decodeList;
  const Base58CodecCustom({required this.alphabet, required this.decodeList});

  @override
  Converter<Uint8List, String> get encoder => Base58Encoder(alphabet);

  @override
  Converter<String, Uint8List> get decoder =>
      Base58Decoder(alphabet, decodeList);
}

/// Base58 encoding converter with given [_alphabet].
///
/// Encodes lists of bytes using Bitcoin [base58Bitcoin], Flickr [base58Flickr],
/// Ripple [base58Ripple] alphabets and [Base58CodecCustom] alphabet.
///
/// The results are ASCII strings using a restricted alphabet.
class Base58Encoder extends Converter<Uint8List, String> {
  final String _alphabet;
  const Base58Encoder(this._alphabet);

  @override
  String convert(Uint8List input) {
    final buffer = StringBuffer();
    final length = input.length;

    int zeroCount = 0;
    for (; zeroCount < length && input[zeroCount] == 0;) {
      zeroCount++;
    }
    final data = input.sublist(zeroCount);
    final size = data.length * 138 ~/ 100 + 1;
    final output = Uint8List(size);
    final maxIndex = size - 1;
    for (final byte in data) {
      for (int carry = byte, i = 0; i < maxIndex || carry != 0; i++) {
        carry = carry + 256 * (0xFF & output[i]);
        output[i] = (carry % 58) & 0xFF;
        carry = carry ~/ 58;
      }
    }
    if (zeroCount > 0) buffer.write(_alphabet[0] * zeroCount);
    for (final i in output.reversed.skipWhile((e) => e == 0)) {
      buffer.write(_alphabet[i]);
    }

    return buffer.toString();
  }
}

/// Decoder for base58 encoded data based on given [_alphabet] and [_decodeList]
class Base58Decoder extends Converter<String, Uint8List> {
  final String _alphabet;
  final List<int> _decodeList;
  const Base58Decoder(this._alphabet, this._decodeList);

  @override
  Uint8List convert(String input) {
    final length = input.length;

    int zeroCount = 0;
    final zero = _alphabet[0];
    for (; zeroCount < length && input[zeroCount] == zero;) {
      zeroCount++;
    }
    final data = input.substring(zeroCount);
    final size = data.length * 733 ~/ 1000 + 1;
    final output = Uint8List(size);
    final maxIndex = size - 1;
    for (final char in data.runes) {
      int carry = _decodeList[char];
      if (carry == -1) {
        throw FormatException(
          'Invalid character detected ${String.fromCharCode(char)}',
        );
      }
      for (int i = 0; i < maxIndex || carry != 0; i++) {
        carry = (carry & 0xFF) + 58 * output[i];
        output[i] = (carry % 256) & 0xFF;
        carry = carry ~/ 256;
      }
    }
    return Uint8List.fromList(
      [...Uint8List(zeroCount), ...output.reversed.skipWhile((e) => e == 0)],
    );
  }
}
