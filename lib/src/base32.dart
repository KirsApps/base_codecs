import 'dart:convert';
import 'dart:typed_data';

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

class Base32CodecCrockford extends Codec<Uint8List, String> {
  static const String _alphabet = "0123456789ABCDEFGHJKMNPQRSTVWXYZ";
  static const String _padding = "";
  const Base32CodecCrockford();

  @override
  Converter<Uint8List, String> get encoder =>
      const Base32Encoder(_alphabet, _padding);

  @override
  Converter<String, Uint8List> get decoder =>
      const Base32Decoder(_alphabet, _padding);
}

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

class Base32CodecGeoHash extends Codec<Uint8List, String> {
  static const String _alphabet = "0123456789BCDEFGRVWXCFGHJMPQRVWX";
  static const String _padding = "";
  const Base32CodecGeoHash();

  @override
  Converter<Uint8List, String> get encoder =>
      const Base32Encoder(_alphabet, _padding);

  @override
  Converter<String, Uint8List> get decoder =>
      const Base32Decoder(_alphabet, _padding);
}

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

class Base32CodecCustom extends Codec<Uint8List, String> {
  final String alphabet;
  final String padding;
  const Base32CodecCustom(this.alphabet, this.padding);

  @override
  Converter<Uint8List, String> get encoder => Base32Encoder(alphabet, padding);

  @override
  Converter<String, Uint8List> get decoder => Base32Decoder(alphabet, padding);
}

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
      data = input.replaceAll(_padding, "");
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
