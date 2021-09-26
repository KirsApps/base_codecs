import 'dart:convert';
import 'dart:typed_data';

/// A [base32Rfc](https://tools.ietf.org/html/rfc4648) encoder and decoder.
///
/// It encodes and decodes using the base32 alphabet.
/// It does not allow invalid characters when decoding.
const Base32CodecRfc base32Rfc = Base32CodecRfc();

/// Encodes [input] using [base32Rfc](https://tools.ietf.org/html/rfc4648) encoding.
///
/// Shorthand for `base32Rfc.encode(input)`.
/// Useful if a local variable shadows the global [base32Rfc] constant.
String base32RfcEncode(Uint8List input) => base32Rfc.encode(input);

/// Decodes [input] using [base32Rfc](https://tools.ietf.org/html/rfc4648) decoding.
///
/// Shorthand for `base32Rfc.decode(input)`.
/// Useful if a local variable shadows the global [base32Rfc] constant.
Uint8List base32RfcDecode(String input) => base32Rfc.decode(input);

/// A [base32RfcHex](https://tools.ietf.org/html/rfc4648) encoder and decoder.
///
/// It encodes and decodes using the base32Hex alphabet.
/// It does not allow invalid characters when decoding.
const Base32CodecRfcHex base32RfcHex = Base32CodecRfcHex();

/// Encodes [input] using [base32RfcHex](https://tools.ietf.org/html/rfc4648) encoding.
///
/// Shorthand for `base32RfcHex.encode(input)`.
/// Useful if a local variable shadows the global [base32RfcHex] constant.
String base32RfcHexEncode(Uint8List input) => base32RfcHex.encode(input);

/// Decodes [input] using [base32RfcHex](https://tools.ietf.org/html/rfc4648) decoding.
///
/// Shorthand for `base32RfcHex.decode(input)`.
/// Useful if a local variable shadows the global [base32RfcHex] constant.
Uint8List base32RfcHexDecode(String input) => base32RfcHex.decode(input);

/// A [base32Crockford] encoder and decoder with Crockford alphabet.
///
/// It encodes and decodes using the Crockford alphabet.
/// It does not allow invalid characters when decoding.
const Base32CodecCrockford base32Crockford = Base32CodecCrockford();

/// Encodes [input] using [base32Crockford] encoding with Crockford alphabet.
///
/// Shorthand for `base32Crockford.encode(input)`.
/// Useful if a local variable shadows the global [base32Crockford] constant.
String base32CrockfordEncode(Uint8List input) => base32Crockford.encode(input);

/// Decodes [input] using [base32Crockford] decoding with Crockford alphabet.
///
/// Shorthand for `base32Crockford.decode(input)`.
/// Useful if a local variable shadows the global [base32Crockford] constant.
Uint8List base32CrockfordDecode(String input) => base32Crockford.decode(input);

/// A [base32ZBase] encoder and decoder with Z-base alphabet.
///
/// It encodes and decodes using the Z-base alphabet.
/// It does not allow invalid characters when decoding.
const Base32CodecZBase base32ZBase = Base32CodecZBase();

/// Encodes [input] using [base32ZBase] encoding with Z-base alphabet.
///
/// Shorthand for `base32ZBase.encode(input)`.
/// Useful if a local variable shadows the global [base32ZBase] constant.
String base32ZBaseEncode(Uint8List input) => base32ZBase.encode(input);

/// Decodes [input] using [base32ZBase] decoding with Z-base alphabet.
///
/// Shorthand for `base32ZBase.decode(input)`.
/// Useful if a local variable shadows the global [base32ZBase] constant.
Uint8List base32ZBaseDecode(String input) => base32ZBase.decode(input);

/// A [base32GeoHash] encoder and decoder with GeoHash alphabet.
///
/// It encodes and decodes using the GeoHash alphabet.
/// It does not allow invalid characters when decoding.
const Base32CodecGeoHash base32GeoHash = Base32CodecGeoHash();

/// Encodes [input] using [base32GeoHash] encoding with GeoHash alphabet.
///
/// Shorthand for `base32GeoHash.encode(input)`.
/// Useful if a local variable shadows the global [base32GeoHash] constant.
String base32GeoHashEncode(Uint8List input) => base32GeoHash.encode(input);

/// Decodes [input] using [base32GeoHash] decoding with GeoHash alphabet.
///
/// Shorthand for `base32GeoHash.decode(input)`.
/// Useful if a local variable shadows the global [base32GeoHash] constant.
Uint8List base32GeoHashDecode(String input) => base32GeoHash.decode(input);

/// A [base32WordSafe] encoder and decoder with WordSafe alphabet.
///
/// It encodes and decodes using the WordSafe alphabet.
/// It does not allow invalid characters when decoding.
const Base32CodecWordSafe base32WordSafe = Base32CodecWordSafe();

/// Encodes [input] using [base32WordSafe] encoding with WordSafe alphabet.
///
/// Shorthand for `base32WordSafe.encode(input)`.
/// Useful if a local variable shadows the global [base32WordSafe] constant.
String base32WordSafeEncode(Uint8List input) => base32WordSafe.encode(input);

/// Decodes [input] using [base32WordSafe] decoding with WordSafe alphabet.
///
/// Shorthand for `base32WordSafe.decode(input)`.
/// Useful if a local variable shadows the global [base32WordSafe] constant.
Uint8List base32WordSafeDecode(String input) => base32WordSafe.decode(input);

/// A [base32Rfc](https://tools.ietf.org/html/rfc4648) encoder and decoder.
///
/// It encodes and decodes using the base32 alphabet.
/// It does not allow invalid characters when decoding.
class Base32CodecRfc extends Codec<Uint8List, String> {
  static const String _alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
  static const String _padding = "=";
  const Base32CodecRfc();

  @override
  Converter<Uint8List, String> get encoder =>
      const Base32Encoder(_alphabet, _padding);

  @override
  Converter<String, Uint8List> get decoder =>
      const Base32Decoder(_alphabet, _padding);
}

/// A [base32RfcHex](https://tools.ietf.org/html/rfc4648) encoder and decoder.
///
/// It encodes and decodes using the base32Hex alphabet.
/// It does not allow invalid characters when decoding.
class Base32CodecRfcHex extends Codec<Uint8List, String> {
  static const String _alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUV";
  static const String _padding = "=";
  const Base32CodecRfcHex();

  @override
  Converter<Uint8List, String> get encoder =>
      const Base32Encoder(_alphabet, _padding);

  @override
  Converter<String, Uint8List> get decoder =>
      const Base32Decoder(_alphabet, _padding);
}

/// A [base32Crockford] encoder and decoder with Crockford alphabet.
///
/// It encodes and decodes using the Crockford alphabet.
/// It does not allow invalid characters when decoding.
class Base32CodecCrockford extends Codec<Uint8List, String> {
  static const String _alphabet = "0123456789ABCDEFGHJKMNPQRSTVWXYZ";
  static const String _padding = "";
  const Base32CodecCrockford();

  @override
  Converter<Uint8List, String> get encoder =>
      const Base32Encoder(_alphabet, _padding);

  @override
  Converter<String, Uint8List> get decoder =>
      const Base32DecoderCrockford(_alphabet, _padding);
}

/// A [base32ZBase] encoder and decoder with Z-base alphabet.
///
/// It encodes and decodes using the Z-base alphabet.
/// It does not allow invalid characters when decoding.
class Base32CodecZBase extends Codec<Uint8List, String> {
  static const String _alphabet = "YBNDRFG8EJKMCPQXOT1UWISZA345H769";
  static const String _padding = "";
  const Base32CodecZBase();

  @override
  Converter<Uint8List, String> get encoder =>
      const Base32Encoder(_alphabet, _padding);

  @override
  Converter<String, Uint8List> get decoder =>
      const Base32Decoder(_alphabet, _padding);
}

/// A [base32GeoHash] encoder and decoder with GeoHash alphabet.
///
/// It encodes and decodes using the GeoHash alphabet.
/// It does not allow invalid characters when decoding.
class Base32CodecGeoHash extends Codec<Uint8List, String> {
  static const String _alphabet = "0123456789bcdefghjkmnpqrstuvwxyz";
  static const String _padding = "";
  const Base32CodecGeoHash();

  @override
  Converter<Uint8List, String> get encoder =>
      const Base32Encoder(_alphabet, _padding);

  @override
  Converter<String, Uint8List> get decoder =>
      const Base32Decoder(_alphabet, _padding, caseInsensitive: false);
}

/// A [base32WordSafe] encoder and decoder with WordSafe alphabet.
///
/// It encodes and decodes using the WordSafe alphabet.
/// It does not allow invalid characters when decoding.
class Base32CodecWordSafe extends Codec<Uint8List, String> {
  static const String _alphabet = "23456789CFGHJMPQRVWXcfghjmpqrvwx";
  static const String _padding = "";
  const Base32CodecWordSafe();

  @override
  Converter<Uint8List, String> get encoder =>
      const Base32Encoder(_alphabet, _padding);

  @override
  Converter<String, Uint8List> get decoder =>
      const Base32Decoder(_alphabet, _padding, caseInsensitive: false);
}

/// A Base32 encoder and decoder with custom [alphabet] and [padding].
///
/// [padding] may be empty.
/// It does not allow invalid characters when decoding.
class Base32CodecCustom extends Codec<Uint8List, String> {
  final String alphabet;
  final String padding;
  const Base32CodecCustom(this.alphabet, this.padding);

  @override
  Converter<Uint8List, String> get encoder => Base32Encoder(alphabet, padding);

  @override
  Converter<String, Uint8List> get decoder => Base32Decoder(alphabet, padding);
}

/// Base32 encoding converter with given [_alphabet] and [_padding].
///
/// [_padding] may be empty.
/// Encodes lists of bytes using Rfc [base32Rfc], RfcHex [base32RfcHex],
/// Crockford [base32Crockford], Z-base [base32ZBase], GeoHash [base32GeoHash],
/// WordSafe [base32WordSafe] alphabets and [Base32CodecCustom] alphabet.
///
/// The results are ASCII strings using a restricted alphabet.
class Base32Encoder extends Converter<Uint8List, String> {
  final String _alphabet;
  final String _padding;
  const Base32Encoder(this._alphabet, this._padding);

  @override
  String convert(Uint8List input) {
    final buffer = StringBuffer();
    int bits = 0;
    int value = 0;

    for (int i = 0; i < input.length; i++) {
      value = (value << 8) | input[i];
      bits += 8;

      while (bits >= 5) {
        buffer.write(_alphabet[(value >> (bits - 5)) & 0x1F]);
        bits -= 5;
      }
    }

    if (bits > 0) {
      buffer.write(_alphabet[(value << (5 - bits)) & 0x1F]);
    }

    if (_padding.isNotEmpty && (buffer.length % 8) != 0) {
      buffer.write(_padding * ((buffer.length % 8) - 8).abs());
    }

    return buffer.toString();
  }
}

/// Decoder for base32 encoded data based on given [_alphabet] and [_padding]
class Base32Decoder extends Converter<String, Uint8List> {
  final String _alphabet;
  final String _padding;
  final bool caseInsensitive;
  const Base32Decoder(
    this._alphabet,
    this._padding, {
    this.caseInsensitive = true,
  });

  @override
  Uint8List convert(String input) {
    String data = caseInsensitive ? input.toUpperCase() : input;
    if (_padding.isNotEmpty) {
      data = data.replaceAll(_padding, "");
    }
    final buffer = Uint8List(data.length * 5 ~/ 8);
    final length = data.length;
    int bits = 0;
    int value = 0;
    int byte = 0;
    for (int i = 0; i < length; i++) {
      final index = _alphabet.indexOf(data[i]);
      if (index == -1) {
        throw FormatException('Invalid character detected: ${data[i]}');
      }
      value = (value << 5) | index;
      bits += 5;
      if (bits >= 8) {
        buffer[byte++] = (value >> (bits - 8)) & 0xFF;
        bits -= 8;
      }
    }
    return buffer;
  }
}

/// Decoder for [base32Crockford]
class Base32DecoderCrockford extends Base32Decoder {
  const Base32DecoderCrockford(String alphabet, String padding)
      : super(alphabet, padding);
  @override
  Uint8List convert(String input) {
    return super.convert(
      input.replaceAll(RegExp('[oO]'), '0').replaceAll(RegExp('[IiLl]'), '1'),
    );
  }
}
