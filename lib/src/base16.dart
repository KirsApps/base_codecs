import 'dart:convert';
import 'dart:typed_data';

/// A [base16](https://tools.ietf.org/html/rfc4648) encoder and decoder.
///
/// It encodes and decodes using the base16 alphabet.
/// It does not allow invalid characters when decoding.
const Base16Codec base16 = Base16Codec();

/// Encodes [input] using [base16](https://tools.ietf.org/html/rfc4648) encoding.
///
/// Shorthand for `base16.encode(input)`.
/// Useful if a local variable shadows the global [base16] constant.
String base16Encode(Uint8List input) => base16.encode(input);

/// Decodes [input] using [base16](https://tools.ietf.org/html/rfc4648) decoding.
///
/// Shorthand for `base16.decode(input)`.
/// Useful if a local variable shadows the global [base16] constant.
Uint8List base16Decode(String input) => base16.decode(input);

/// Hex (base16) codec alias to [base16]
const hex = base16;

/// Encodes [input] using [base16](https://tools.ietf.org/html/rfc4648)
/// alias to [base16Encode]
String hexEncode(Uint8List input) => base16Encode(input);

/// Decodes [input] using [base16](https://tools.ietf.org/html/rfc4648)
/// alias to [base16Decode]
Uint8List hexDecode(String input) => base16Decode(input);

/// A [base16](https://tools.ietf.org/html/rfc4648) encoder and decoder.
///
/// It encodes and decodes using the base16 alphabet.
/// It does not allow invalid characters when decoding.
class Base16Codec extends Codec<Uint8List, String> {
  static const String _alphabet = "0123456789ABCDEF";
  const Base16Codec();

  @override
  Converter<Uint8List, String> get encoder => const Base16Encoder(_alphabet);

  @override
  Converter<String, Uint8List> get decoder => const Base16Decoder(_alphabet);
}

/// A Base16 encoder and decoder with custom [alphabet].
///
/// It does not allow invalid characters when decoding.
class Base16CodecCustom extends Codec<Uint8List, String> {
  final String alphabet;
  const Base16CodecCustom(this.alphabet);

  @override
  Converter<Uint8List, String> get encoder => Base16Encoder(alphabet);

  @override
  Converter<String, Uint8List> get decoder => Base16Decoder(alphabet);
}

/// Base16 encoding converter with given [_alphabet].
///
/// Encodes lists of bytes using Rfc [base16] alphabet and [Base16CodecCustom] alphabet.
///
/// The results are ASCII strings using a restricted alphabet.
class Base16Encoder extends Converter<Uint8List, String> {
  final String _alphabet;
  const Base16Encoder(this._alphabet);

  @override
  String convert(Uint8List input) {
    final buffer = StringBuffer();
    final zero = _alphabet[0];
    for (final byte in input) {
      buffer.write(
        "${byte < 16 ? zero : _alphabet[byte >> 4]}${_alphabet[byte & 0xF]}",
      );
    }

    return buffer.toString();
  }
}

/// Decoder for base16 encoded data based on given [_alphabet].
class Base16Decoder extends Converter<String, Uint8List> {
  final String _alphabet;
  const Base16Decoder(this._alphabet);

  @override
  Uint8List convert(String input) {
    if (input.isEmpty) {
      return Uint8List(0);
    }
    if (input.startsWith('0x')) {
      input = input.substring(2);
    }
    String data = input.toUpperCase();
    if (data.length % 2 != 0) {
      data = "${_alphabet[0]}$data";
    }
    final result = Uint8List(data.length ~/ 2);
    for (int i = 0; i < result.length; i++) {
      final firstDigit = _alphabet.indexOf(data[i * 2]);
      final secondDigit = _alphabet.indexOf(data[i * 2 + 1]);
      if (firstDigit == -1 || secondDigit == -1) {
        throw FormatException("Non-hex character detected in $data");
      }
      result[i] = (firstDigit << 4) + secondDigit;
    }
    return result;
  }
}
