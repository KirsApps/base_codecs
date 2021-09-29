import 'dart:convert';
import 'dart:typed_data';

import 'constants.dart';

/// 85 pow 4
const pow4 = 52200625;

/// 85 pow 3
const pow3 = 614125;

/// 85 pow 2
const pow2 = 7225;

/// 85 pow 1
const pow1 = 85;

const powList = [pow4, pow3, pow2, pow1, 1];

/// Uint 32 max value
const maxUint32 = 4294967295;

const Base85CodecAscii base85Ascii = Base85CodecAscii();

final base85RegExp = RegExp(r'(^<~)+|[\x09\x0a\x0b\x0c\x0d\x20]|(~>$)+');

String base85AsciiEncode(Uint8List input) => base85Ascii.encode(input);

Uint8List base85AsciiDecode(String input) => base85Ascii.decode(input);

const Base85CodecZ base85Z = Base85CodecZ();

String base85ZEncode(Uint8List input) => base85Z.encode(input);

Uint8List base85ZDecode(String input) => base85Z.decode(input);

const Base85CodecIPv6 base85IPv6 = Base85CodecIPv6();

String base85IPv6Encode(Uint8List input) => base85IPv6.encode(input);

Uint8List base85IPv6Decode(String input) => base85IPv6.decode(input);

class Base85CodecAscii extends Codec<Uint8List, String> {
  static const _alphabet =
      '!"#\$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstu';
  const Base85CodecAscii();

  @override
  Converter<Uint8List, String> get encoder =>
      const Base85EncoderAscii(_alphabet);

  @override
  Converter<String, Uint8List> get decoder => const Base85DecoderAscii();
}

class Base85EncoderAscii extends Converter<Uint8List, String> {
  final String _alphabet;
  const Base85EncoderAscii(this._alphabet);

  @override
  String convert(Uint8List input) {
    final length = input.length;
    final padding = length % 4 == 0 ? 0 : 4 - (length % 4);
    if (padding != 0) {
      input = Uint8List.fromList([...input, ...Uint8List(padding)]);
    }

    final output = _processEncodeInput(
      alphabet: _alphabet,
      input: input,
      zeroCompressionEnabled: true,
    );

    return "<~${output.substring(0, output.length - padding)}~>";
  }
}

class Base85DecoderAscii extends Converter<String, Uint8List> {
  const Base85DecoderAscii();

  @override
  Uint8List convert(String input) {
    input = input.replaceAll(base85RegExp, '');
    final length = input.length;
    final output = <int>[];
    final codeUnits = Uint8List.fromList(input.codeUnits);
    int unitCounter = 0;
    int value = 0;
    for (int i = 0; i < length; i++,) {
      if (input[i] == 'z') {
        if (unitCounter == 0) {
          output.addAll([0, 0, 0, 0]);
          continue;
        } else {
          throw const FormatException(
            'Misaligned z in input',
          );
        }
      }
      value += decodeBase85Ascii[codeUnits[i]] * powList[unitCounter];
      if (unitCounter == 4) {
        if (value > maxUint32 || value.isNegative) {
          throw FormatException(
            'Value result $value larger than max Uint 32 or negative, invalid data provided',
          );
        }
        output.addAll([
          value >> 24 & 0xFF,
          value >> 16 & 0xFF,
          value >> 8 & 0xFF,
          value & 0xFF
        ]);
        value = 0;
        unitCounter = 0;
      } else {
        unitCounter++;
      }
    }
    int padding = 0;
    if (unitCounter > 0) {
      while (unitCounter < 5) {
        /// 117 - u char
        value += decodeBase85Ascii[117] * powList[unitCounter];
        unitCounter++;
        padding++;
      }
      output.addAll([
        value >> 24 & 0xFF,
        value >> 16 & 0xFF,
        value >> 8 & 0xFF,
        value & 0xFF
      ]);
    }
    return Uint8List.fromList(output.sublist(0, output.length - padding));
  }
}

class Base85CodecZ extends Codec<Uint8List, String> {
  static const String _alphabet =
      r"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-:+=^!/*?&<>()[]{}@%$#";
  const Base85CodecZ();

  @override
  Converter<Uint8List, String> get encoder => const Base85EncoderZ(_alphabet);

  @override
  Converter<String, Uint8List> get decoder => const Base85DecoderZ();
}

class Base85EncoderZ extends Converter<Uint8List, String> {
  final String _alphabet;
  const Base85EncoderZ(this._alphabet);

  @override
  String convert(Uint8List input) {
    final length = input.length;
    if (length % 4 != 0) {
      throw ArgumentError('input list must be bounded to 4 bytes');
    }

    return _processEncodeInput(
      alphabet: _alphabet,
      input: input,
      zeroCompressionEnabled: false,
    );
  }
}

class Base85DecoderZ extends Converter<String, Uint8List> {
  const Base85DecoderZ();

  @override
  Uint8List convert(String input) {
    input = input.replaceAll(base85RegExp, '');
    final length = input.length;
    if (length % 5 != 0) {
      throw ArgumentError('input string must be bounded to 5 bytes');
    }
    final output = Uint8List(length ~/ 5 * 4);
    final codeUnits = Uint8List.fromList(input.codeUnits);
    for (int i = 0, offset = 0; i < length; i += 5, offset += 4) {
      final value = (decodeBase85Z[codeUnits[i]] * pow4) +
          (decodeBase85Z[codeUnits[i + 1]] * pow3) +
          (decodeBase85Z[codeUnits[i + 2]] * pow2) +
          (decodeBase85Z[codeUnits[i + 3]] * pow1) +
          decodeBase85Z[codeUnits[i + 4]];
      if (value > maxUint32 || value.isNegative) {
        throw FormatException(
          'Value result $value larger than max Uint 32 or negative, invalid data provided',
        );
      }
      output[offset] = value >> 24;
      output[offset + 1] = value >> 16;
      output[offset + 2] = value >> 8;
      output[offset + 3] = value & 0xFF;
    }
    return output;
  }
}

class Base85CodecIPv6 extends Codec<Uint8List, String> {
  static const _alphabet =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#\$%&()*+-;<=>?@^_`{|}~';
  const Base85CodecIPv6();

  @override
  Converter<Uint8List, String> get encoder =>
      const Base85EncoderIPv6(_alphabet);

  @override
  Converter<String, Uint8List> get decoder =>
      const Base85DecoderIPv6(decodeBase58IPv6);
}

class Base85EncoderIPv6 extends Converter<Uint8List, String> {
  final String _alphabet;
  const Base85EncoderIPv6(this._alphabet);

  @override
  String convert(Uint8List input) {
    BigInt value = BigInt.zero;
    int counter = 0;
    for (final byte in input.reversed) {
      value += BigInt.from(byte) << (8 * counter);
      counter++;
    }
    final output = Uint8List(20);
    for (int i = 19; i >= 0; i--) {
      output[i] = _alphabet.codeUnitAt((value % BigInt.from(85)).toInt());
      value = value ~/ BigInt.from(85);
    }
    return String.fromCharCodes(output);
  }
}

class Base85DecoderIPv6 extends Converter<String, Uint8List> {
  final List<int> _decodeList;
  const Base85DecoderIPv6(this._decodeList);

  @override
  Uint8List convert(String input) {
    if (input.length != 20) {
      throw const FormatException(
        'An encoded IPv6 is always (5/4) * 16 = 20 bytes',
      );
    }
    BigInt value = BigInt.zero;
    int counter = 0;
    final codeUnits = input.codeUnits;
    for (final unit in codeUnits.reversed) {
      final _value = BigInt.from(_decodeList[unit]);
      final pow = BigInt.from(85).pow(counter);
      value += _value * pow;
      counter++;
    }

    final output = Uint8List(16);
    for (int i = 15; i >= 0; i--) {
      output[i] = (value & BigInt.from(0xFF)).toInt();
      value >>= 8;
    }
    return output;
  }
}

String _processEncodeInput({
  required String alphabet,
  required Uint8List input,
  required bool zeroCompressionEnabled,
}) {
  final length = input.length;
  final output = Uint8List(length ~/ 4 * 5);
  int offset = 0;
  int padding = 0;
  for (int i = 0; i < length; i += 4) {
    if (zeroCompressionEnabled &&
        input[i] == 0 &&
        input[i + 1] == 0 &&
        input[i + 2] == 0 &&
        input[i + 3] == 0) {
      /// z char code
      output[offset] = 122;
      offset += 1;
      padding += 4;
      continue;
    }
    int value = (input[i] << 24) +
        (input[i + 1] << 16) +
        (input[i + 2] << 8) +
        input[i + 3];
    for (int b = 4; b >= 0; b--) {
      output[offset + b] = alphabet.codeUnitAt(value % 85);
      value ~/= 85;
    }
    offset += 5;
  }
  return String.fromCharCodes(output.sublist(0, output.length - padding));
}
