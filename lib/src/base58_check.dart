import 'dart:typed_data';

import 'package:base_codecs/base_codecs.dart';
import 'package:crypto/crypto.dart' show sha256;

String base58CheckEncode(Uint8List input) {
  return base58Bitcoin.encode(
    Uint8List.fromList([
      ...input,
      ..._doubleSha256(input).sublist(0, 4),
    ]),
  );
}

Uint8List base58CheckDecode(String input) {
  final data = base58Bitcoin.decode(input);
  final payload = data.sublist(0, data.length - 4);
  final checksum = data.sublist(data.length - 4);
  final newChecksum = _doubleSha256(payload);
  if (checksum[0] != newChecksum[0] ||
      checksum[1] != newChecksum[1] ||
      checksum[2] != newChecksum[2] ||
      checksum[3] != newChecksum[3]) {
    throw ArgumentError("Invalid checksum");
  }
  return payload;
}

Uint8List _doubleSha256(Uint8List buffer) {
  return Uint8List.fromList(sha256.convert(sha256.convert(buffer).bytes).bytes);
}
