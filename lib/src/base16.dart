import 'dart:convert';
import 'dart:typed_data';

const Base16Codec base16 = Base16Codec();

String base16Encode(Uint8List input) => base16.encode(input);

Uint8List base16Decode(String input) => base16.decode(input);

const hex = base16;

String hexEncode(Uint8List input) => base16Encode(input);

Uint8List hexDecode(String input) => base16Decode(input);

class Base16Codec extends Codec<Uint8List, String> {
  static const String _alphabet = "0123456789ABCDEF";
  const Base16Codec();

  @override
  Converter<Uint8List, String> get encoder => const Base16Encoder(_alphabet);

  @override
  Converter<String, Uint8List> get decoder => const Base16Decoder(_alphabet);
}

class Base16CodecCustom extends Codec<Uint8List, String> {
  final String alphabet;
  const Base16CodecCustom(this.alphabet);

  @override
  Converter<Uint8List, String> get encoder => Base16Encoder(alphabet);

  @override
  Converter<String, Uint8List> get decoder => Base16Decoder(alphabet);
}

class Base16Encoder extends Converter<Uint8List, String> {
  final String _alphabet;
  const Base16Encoder(this._alphabet);

  @override
  String convert(Uint8List input) {
    final buffer = StringBuffer();
    for (final byte in input) {
      buffer.write(
        "${byte < 16 ? '0' : _alphabet[byte >> 4]}${_alphabet[byte & 0xF]}",
      );
    }

    return buffer.toString();
  }
}

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
      data = "0$data";
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
