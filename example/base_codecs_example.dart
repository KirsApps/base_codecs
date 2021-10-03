import 'dart:convert';
import 'dart:typed_data';

import 'package:base_codecs/base_codecs.dart';

void main() {
  const testString =
      "Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of the mind, that by a perseverance of delight in the continued and indefatigable generation of knowledge, exceeds the short vehemence of any carnal pleasure.";

  /// Base16 (Hex)
  const data = [0xDE, 0xAD, 0xBE, 0xEF];
  hexEncode(Uint8List.fromList(data)); //DEADBEEF
  hexDecode('DEADBEEF'); // == data

  /// Base16 Custom
  const custom = Base16CodecCustom('ABCDEF9876543210');
  final customData = Uint8List.fromList(
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
  );
  custom.encode(customData); // AAABACADAEAFA9A8A7A6A5A4A3A2A1A0
  custom.decode('AAABACADAEAFA9A8A7A6A5A4A3A2A1A0'); // == customData

  /// Base32
  /// RFC
  const encoded =
      "JVQW4IDJOMQGI2LTORUW4Z3VNFZWQZLEFQQG433UEBXW43DZEBRHSIDINFZSA4TFMFZW63RMEBRHK5BAMJ4SA5DINFZSA43JNZTXK3DBOIQHAYLTONUW63RAMZZG63JAN52GQZLSEBQW42LNMFWHGLBAO5UGSY3IEBUXGIDBEBWHK43UEBXWMIDUNBSSA3LJNZSCYIDUNBQXIIDCPEQGCIDQMVZHGZLWMVZGC3TDMUQG6ZRAMRSWY2LHNB2CA2LOEB2GQZJAMNXW45DJNZ2WKZBAMFXGIIDJNZSGKZTBORUWOYLCNRSSAZ3FNZSXEYLUNFXW4IDPMYQGW3TPO5WGKZDHMUWCAZLYMNSWKZDTEB2GQZJAONUG64TUEB3GK2DFNVSW4Y3FEBXWMIDBNZ4SAY3BOJXGC3BAOBWGKYLTOVZGKLQ=";

  base32RfcEncode(Uint8List.fromList(utf8.encode(testString)));

  base32RfcDecode(encoded);

  /// RFC HEX

  const encodedRFCHex =
      "9LGMS839ECG68QBJEHKMSPRLD5PMGPB45GG6SRRK41NMSR3P41H7I838D5PI0SJ5C5PMURHC41H7AT10C9SI0T38D5PI0SR9DPJNAR31E8G70OBJEDKMURH0CPP6UR90DTQ6GPBI41GMSQBDC5M76B10ETK6IOR841KN683141M7ASRK41NMC83KD1II0RB9DPI2O83KD1GN8832F4G6283GCLP76PBMCLP62RJ3CKG6UPH0CHIMOQB7D1Q20QBE41Q6GP90CDNMST39DPQMAP10C5N68839DPI6APJ1EHKMEOB2DHII0PR5DPIN4OBKD5NMS83FCOG6MRJFETM6AP37CKM20PBOCDIMAP3J41Q6GP90EDK6USJK41R6AQ35DLIMSOR541NMC831DPSI0OR1E9N62R10E1M6AOBJELP6ABG=";

  base32RfcHexEncode(Uint8List.fromList(utf8.encode(testString)));

  base32RfcHexDecode(encodedRFCHex);

  /// ZBase
  const encodedZbase =
      "JIOSHEDJQCOGE4MUQTWSH35IPF3SO3MRFOOGH55WRBZSH5D3RBT81EDEPF31YHUFCF3S65TCRBT8K7BYCJH1Y7DEPF31YH5JP3UZK5DBQEO8YAMUQPWS65TYC33G65JYP74GO3M1RBOSH4MPCFS8GMBYQ7WG1A5ERBWZGEDBRBS8KH5WRBZSCEDWPB11Y5MJP31NAEDWPBOZEEDNXROGNEDOCI38G3MSCI3GN5UDCWOG63TYCT1SA4M8PB4NY4MQRB4GO3JYCPZSH7DJP34SK3BYCFZGEEDJP31GK3UBQTWSQAMNPT11Y35FP31ZRAMWPFZSHEDXCAOGS5UXQ7SGK3D8CWSNY3MACP1SK3DURB4GO3JYQPWG6HUWRB5GK4DFPI1SHA5FRBZSCEDBP3H1YA5BQJZGN5BYQBSGKAMUQI3GKMO";

  base32ZBaseEncode(Uint8List.fromList(utf8.encode(testString)));

  base32ZBaseDecode(encodedZbase);

  const encodedCrockford =
      "9NGPW839ECG68TBKEHMPWSVND5SPGSB45GG6WVVM41QPWV3S41H7J838D5SJ0WK5C5SPYVHC41H7AX10C9WJ0X38D5SJ0WV9DSKQAV31E8G70RBKEDMPYVH0CSS6YV90DXT6GSBJ41GPWTBDC5P76B10EXM6JRV841MQ683141P7AWVM41QPC83MD1JJ0VB9DSJ2R83MD1GQ8832F4G6283GCNS76SBPCNS62VK3CMG6YSH0CHJPRTB7D1T20TBE41T6GS90CDQPWX39DSTPAS10C5Q68839DSJ6ASK1EHMPERB2DHJJ0SV5DSJQ4RBMD5QPW83FCRG6PVKFEXP6AS37CMP20SBRCDJPAS3K41T6GS90EDM6YWKM41V6AT35DNJPWRV541QPC831DSWJ0RV1E9Q62V10E1P6ARBKENS6ABG";

  base32CrockfordEncode(Uint8List.fromList(utf8.encode(testString)));

  base32CrockfordDecode(encodedCrockford);

  /// WordSafe
  const encodedWordSafe =
      "FfRgrC5FPJR8CpHXPVcgrmqfM7mgRmH67RR8rqqc63hgrq5m63V9WC5CM7mW2rX7J7mgwqVJ63V9Gv32JFrW2v5CM7mW2rqFMmXhGq53PCR92jHXPMcgwqV2Jmm8wqF2Mvp8RmHW63RgrpHMJ7g98H32Pvc8WjqC63ch8C5363g9Grqc63hgJC5cM3WW2qHFMmW4jC5cM3RhCC54Q6R84C5RJfm98mHgJfm84qX5JcR8wmV2JVWgjpH9M3p42pHP63p8RmF2JMhgrv5FMmpgGm32J7h8CC5FMmW8GmX3PVcgPjH4MVWW2mq7MmWh6jHcM7hgrC5QJjR8gqXQPvg8Gm59Jcg42mHjJMWgGm5X63p8RmF2PMc8wrXc63q8Gp57MfWgrjq763hgJC53MmrW2jq3PFh84q32P3g8GjHXPfm8GHR";

  base32WordSafeEncode(Uint8List.fromList(utf8.encode(testString)));

  base32WordSafeDecode(encodedWordSafe);

  /// GeoHash
  const encodedGeoHash =
      "9phqw839fdh68ucmfjnqwtvpe5tqhtc45hh6wvvn41rqwv3t41j7k838e5tk0wm5d5tqyvjd41j7bx10d9wk0x38e5tk0wv9etmrbv31f8h70scmfenqyvj0dtt6yv90exu6htck41hqwuced5q76c10fxn6ksv841nr683141q7bwvn41rqd83ne1kk0vc9etk2s83ne1hr8832g4h6283hdpt76tcqdpt62vm3dnh6ytj0djkqsuc7e1u20ucf41u6ht90derqwx39etuqbt10d5r68839etk6btm1fjnqfsc2ejkk0tv5etkr4scne5rqw83gdsh6qvmgfxq6bt37dnq20tcsdekqbt3m41u6ht90fen6ywmn41v6bu35epkqwsv541rqd831etwk0sv1f9r62v10f1q6bscmfpt6bch";

  base32GeoHashEncode(Uint8List.fromList(utf8.encode(testString)));

  base32GeoHashDecode(encodedGeoHash);

  ///Custom'
  const codec = Base32CodecCustom("0123456789ABCDEFGHJKMNPQRSTVWXYZ", '');
  const encodedCustom =
      "9NGPW839ECG68TBKEHMPWSVND5SPGSB45GG6WVVM41QPWV3S41H7J838D5SJ0WK5C5SPYVHC41H7AX10C9WJ0X38D5SJ0WV9DSKQAV31E8G70RBKEDMPYVH0CSS6YV90DXT6GSBJ41GPWTBDC5P76B10EXM6JRV841MQ683141P7AWVM41QPC83MD1JJ0VB9DSJ2R83MD1GQ8832F4G6283GCNS76SBPCNS62VK3CMG6YSH0CHJPRTB7D1T20TBE41T6GS90CDQPWX39DSTPAS10C5Q68839DSJ6ASK1EHMPERB2DHJJ0SV5DSJQ4RBMD5QPW83FCRG6PVKFEXP6AS37CMP20SBRCDJPAS3K41T6GS90EDM6YWKM41V6AT35DNJPWRV541QPC831DSWJ0RV1E9Q62V10E1P6ARBKENS6ABG";

  codec.encode(Uint8List.fromList(utf8.encode(testString)));

  codec.decode(encodedCustom);

  /// Base58

  const encodedBitcoin =
      "2KG5obUH7D2G2qLPjujWXdCd1FK6heTdfCjVn1MwP3unVrwcoTz3QyxtBe8Dpxfc5Afnf6VL2b4Ae9RWHEJ957WJpTXTXKcSyFZb17ALWU1BcBsNv2Cncqm5qTadzLcryeftfjtFZfJ14EKKf7UVd5h7UXFSqpmB144w2Eyb9gwvh7mofZpc7oSQv4ZSso9tD1589EjLERTebQoFtt8isgKarX4HGRWUpQCRkAPWuiNrYeV4XEmE4ez4f2mWN1vgGPcX8mKm7RXjYnQ1aGF3oZvKrQQ1ySEq4b5fLvQxcGzCp9xsVdfgK3pXC1RQPf8nyhik8JEnGdXV999wjaj7ggrcEtmkZH41ynpvSYkDecL8nNMT";

  base58BitcoinEncode(Uint8List.fromList(utf8.encode(testString)));

  base58BitcoinDecode(encodedBitcoin);

  /// Flickr

  const encodedFlickr =
      '2jg5NAth7d2g2QkoJUJvwCcC1fj6GDsCEcJuM1mWo3UMuRWBNsZ3pYXTbD8dPXEB5aEME6uk2A4aD9qvhei957viPswswjBrYfyA17akvt1bBbSnV2cMBQL5QszCZkBRYDETEJTfyEi14ejjE7tuC5G7twfrQPLb144W2eYA9FWVG7LNEyPB7NrpV4yrSN9Td1589eJkeqsDApNfTT8HSFjzRw4hgqvtPpcqKaovUHnRxDu4weLe4DZ4E2Lvn1VFgoBw8LjL7qwJxMp1zgf3NyVjRpp1YreQ4A5EkVpXBgZcP9XSuCEFj3Pwc1qpoE8MYGHK8ieMgCwu999WJzJ7FFRBeTLKyh41YMPVrxKdDBk8Mnms';

  base58FlickrEncode(Uint8List.fromList(utf8.encode(testString)));

  base58FlickrDecode(encodedFlickr);

  /// Ripple

  const encodedRipple =
      'pKGnob7HfDpGpqLPjujWXdUdrEKa6eTdCUjV8rMAPsu8ViAcoTzsQyxtBe3DFxCcnwC8CaVLpbhwe9RWHNJ9nfWJFTXTXKcSyEZbrfwLW7rBcB14vpU8cqmnqT2dzLciyeCtCjtEZCJrhNKKCf7Vdn6f7XESqFmBrhhApNyb9gAv6fmoCZFcfoSQvhZS1o9tDrn39NjLNRTebQoEtt351gK2iXhHGRW7FQURkwPWu54iYeVhXNmNhezhCpmW4rvgGPcX3mKmfRXjY8Qr2GEsoZvKiQQrySNqhbnCLvQxcGzUF9x1VdCgKsFXUrRQPC38y65k3JN8GdXV999Aj2jfggicNtmkZHhry8FvSYkDecL384MT';

  base58RippleEncode(Uint8List.fromList(utf8.encode(testString)));

  base58RippleDecode(encodedRipple);

  /// Base58Check

  const encodedCheck = "5Kd3NBUAdUnhyzenEwVLy9pBKxSwXvE9FMPyR4UKZvpe6E3AgLr";
  const decodedCheck =
      "80EDDBDC1168F1DAEADBD3E44C1E3F8F5A284C2029F78AD26AF98583A499DE5B19";

  base58CheckEncode(base16.decode(decodedCheck));

  base16.encode(base58CheckDecode(encodedCheck));

  ///Base85

  /// Ascii
  final zeroDecoded = Uint8List.fromList(
    [0, 0, 0, 0, 0, 0, 0, 0, 0xd9, 0x47, 0xa3, 0xd5, 0, 0, 0, 0],
  );

  base85AsciiEncode(Uint8List.fromList(utf8.encode(testString)));

  base85AsciiEncode(zeroDecoded);

  /// Z85
  const rfcTestData = [0x86, 0x4F, 0xD2, 0x6F, 0xB5, 0x59, 0xF7, 0x5B];
  const rfcTestDataEncoded = "HelloWorld";

  base85ZEncode(
    Uint8List.fromList(rfcTestData),
  );

  base85ZDecode(rfcTestDataEncoded);

  /// IPv6
  //  1080:0:0:0:8:800:200C:417A from RFC 1924
  const address = '108000000000000000080800200C417A';
  const encodedIPv6 = "4)+k&C#VzJ4br>0wv%Yp";

  base85IPv6Encode(
    Uint8List.fromList(base16.decode(address)),
  );

  base85IPv6Decode(encodedIPv6);
}
