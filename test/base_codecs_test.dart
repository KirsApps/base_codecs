import 'dart:convert';
import 'dart:typed_data';

import 'package:base_codecs/base_codecs.dart';
import 'package:test/test.dart';

void main() {
  const testString =
      "Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of the mind, that by a perseverance of delight in the continued and indefatigable generation of knowledge, exceeds the short vehemence of any carnal pleasure.";
  const base16 = Base16Codec();
  group('base16', () {
    const data = [0xDE, 0xAD, 0xBE, 0xEF];
    test('encode', () {
      expect(base16.encode(Uint8List.fromList(data)), equals('DEADBEEF'));
    });
    test('decode', () {
      expect(base16.decode('DEADBEEF'), data);
    });
    const custom = Base16CodecCustom('ABCDEF9876543210');
    final customData = Uint8List.fromList(
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);
    test('encode custom', () {
      expect(custom.encode(customData),
          equals('0A0B0C0D0E0F09080706050403020100'));
    });
    test('decode custom', () {
      expect(custom.decode('AAABACADAEAFA9A8A7A6A5A4A3A2A1A0'), customData);
    });
  });
  group('base32', () {
    group('RFC', () {
      const codec = Base32CodecRfc();
      const encoded =
          "JVQW4IDJOMQGI2LTORUW4Z3VNFZWQZLEFQQG433UEBXW43DZEBRHSIDINFZSA4TFMFZW63RMEBRHK5BAMJ4SA5DINFZSA43JNZTXK3DBOIQHAYLTONUW63RAMZZG63JAN52GQZLSEBQW42LNMFWHGLBAO5UGSY3IEBUXGIDBEBWHK43UEBXWMIDUNBSSA3LJNZSCYIDUNBQXIIDCPEQGCIDQMVZHGZLWMVZGC3TDMUQG6ZRAMRSWY2LHNB2CA2LOEB2GQZJAMNXW45DJNZ2WKZBAMFXGIIDJNZSGKZTBORUWOYLCNRSSAZ3FNZSXEYLUNFXW4IDPMYQGW3TPO5WGKZDHMUWCAZLYMNSWKZDTEB2GQZJAONUG64TUEB3GK2DFNVSW4Y3FEBXWMIDBNZ4SAY3BOJXGC3BAOBWGKYLTOVZGKLQ=";
      test('encode', () {
        expect(
          codec.encode(Uint8List.fromList(utf8.encode(testString))),
          equals(encoded),
        );
      });
      test('decode', () {
        expect(codec.decode(encoded), utf8.encode(testString));
      });
    });
    group('HEX', () {
      const codec = Base32CodecRfcHex();
      const encoded =
          "9LGMS839ECG68QBJEHKMSPRLD5PMGPB45GG6SRRK41NMSR3P41H7I838D5PI0SJ5C5PMURHC41H7AT10C9SI0T38D5PI0SR9DPJNAR31E8G70OBJEDKMURH0CPP6UR90DTQ6GPBI41GMSQBDC5M76B10ETK6IOR841KN683141M7ASRK41NMC83KD1II0RB9DPI2O83KD1GN8832F4G6283GCLP76PBMCLP62RJ3CKG6UPH0CHIMOQB7D1Q20QBE41Q6GP90CDNMST39DPQMAP10C5N68839DPI6APJ1EHKMEOB2DHII0PR5DPIN4OBKD5NMS83FCOG6MRJFETM6AP37CKM20PBOCDIMAP3J41Q6GP90EDK6USJK41R6AQ35DLIMSOR541NMC831DPSI0OR1E9N62R10E1M6AOBJELP6ABG=";
      test('encode', () {
        expect(
          codec.encode(Uint8List.fromList(utf8.encode(testString))),
          equals(encoded),
        );
      });
      test('decode', () {
        expect(codec.decode(encoded), utf8.encode(testString));
      });
    });
    group('ZBase', () {
      const codec = Base32CodecZBase();
      const encoded =
          "JIOSHEDJQCOGE4MUQTWSH35IPF3SO3MRFOOGH55WRBZSH5D3RBT81EDEPF31YHUFCF3S65TCRBT8K7BYCJH1Y7DEPF31YH5JP3UZK5DBQEO8YAMUQPWS65TYC33G65JYP74GO3M1RBOSH4MPCFS8GMBYQ7WG1A5ERBWZGEDBRBS8KH5WRBZSCEDWPB11Y5MJP31NAEDWPBOZEEDNXROGNEDOCI38G3MSCI3GN5UDCWOG63TYCT1SA4M8PB4NY4MQRB4GO3JYCPZSH7DJP34SK3BYCFZGEEDJP31GK3UBQTWSQAMNPT11Y35FP31ZRAMWPFZSHEDXCAOGS5UXQ7SGK3D8CWSNY3MACP1SK3DURB4GO3JYQPWG6HUWRB5GK4DFPI1SHA5FRBZSCEDBP3H1YA5BQJZGN5BYQBSGKAMUQI3GKMO";
      test('encode', () {
        expect(
          codec.encode(Uint8List.fromList(utf8.encode(testString))),
          equals(encoded),
        );
      });
      test('decode', () {
        expect(codec.decode(encoded), utf8.encode(testString));
      });
    });
    group('Crockford', () {
      const codec = Base32CodecCrockford();
      const encoded =
          "9NGPW839ECG68TBKEHMPWSVND5SPGSB45GG6WVVM41QPWV3S41H7J838D5SJ0WK5C5SPYVHC41H7AX10C9WJ0X38D5SJ0WV9DSKQAV31E8G70RBKEDMPYVH0CSS6YV90DXT6GSBJ41GPWTBDC5P76B10EXM6JRV841MQ683141P7AWVM41QPC83MD1JJ0VB9DSJ2R83MD1GQ8832F4G6283GCNS76SBPCNS62VK3CMG6YSH0CHJPRTB7D1T20TBE41T6GS90CDQPWX39DSTPAS10C5Q68839DSJ6ASK1EHMPERB2DHJJ0SV5DSJQ4RBMD5QPW83FCRG6PVKFEXP6AS37CMP20SBRCDJPAS3K41T6GS90EDM6YWKM41V6AT35DNJPWRV541QPC831DSWJ0RV1E9Q62V10E1P6ARBKENS6ABG";
      const encodedWithReplaceSymbols =
          "9NGPW839ECG68TBKEHMPWSVND5SPGSB45GG6WVVM41QPWV3S41H7J838D5SJoWK5C5SPYVHC41H7AX10C9WJOX38D5SJOWV9DSKQAV31E8G70RBKEDMPYVH0CSS6YV90DXT6GSBJ41GPWTBDC5P76B10EXM6JRV84lMQ683i4IP7AWVM41QPC83MDiJJ0VB9DSJ2R83MD1GQ8832F4G6283GCNS76SBPCNS62VK3CMG6YSH0CHJPRTB7D1T20TBE4IT6GS90CDQPWX39DSTPAS10C5Q68839DSJ6ASKLEHMPERB2DHJJ0SV5DSJQ4RBMD5QPW83FCRG6PVKFEXP6AS37CMP2oSBRCDJPAS3K41T6GS90EDM6YWKM4LV6AT35DNJPWRV541QPC831DSWJ0RVIE9Q62V10E1P6ARBKENS6ABG";
      test('encode', () {
        expect(
          codec.encode(Uint8List.fromList(utf8.encode(testString))),
          equals(encoded),
        );
      });
      test('decode with i I l L  o O symbols', () {
        expect(
          codec.decode(encodedWithReplaceSymbols),
          utf8.encode(testString),
        );
      });
      test('decode', () {
        expect(codec.decode(encoded), utf8.encode(testString));
      });
    });
    group('WordSafe', () {
      const codec = Base32CodecWordSafe();
      const encoded =
          "FfRgrC5FPJR8CpHXPVcgrmqfM7mgRmH67RR8rqqc63hgrq5m63V9WC5CM7mW2rX7J7mgwqVJ63V9Gv32JFrW2v5CM7mW2rqFMmXhGq53PCR92jHXPMcgwqV2Jmm8wqF2Mvp8RmHW63RgrpHMJ7g98H32Pvc8WjqC63ch8C5363g9Grqc63hgJC5cM3WW2qHFMmW4jC5cM3RhCC54Q6R84C5RJfm98mHgJfm84qX5JcR8wmV2JVWgjpH9M3p42pHP63p8RmF2JMhgrv5FMmpgGm32J7h8CC5FMmW8GmX3PVcgPjH4MVWW2mq7MmWh6jHcM7hgrC5QJjR8gqXQPvg8Gm59Jcg42mHjJMWgGm5X63p8RmF2PMc8wrXc63q8Gp57MfWgrjq763hgJC53MmrW2jq3PFh84q32P3g8GjHXPfm8GHR";
      test('encode', () {
        expect(
          codec.encode(Uint8List.fromList(utf8.encode(testString))),
          equals(encoded),
        );
      });
      test('decode', () {
        expect(codec.decode(encoded), utf8.encode(testString));
      });
    });
    group('GeoHash', () {
      const codec = Base32CodecGeoHash();
      const encoded =
          "9phqw839fdh68ucmfjnqwtvpe5tqhtc45hh6wvvn41rqwv3t41j7k838e5tk0wm5d5tqyvjd41j7bx10d9wk0x38e5tk0wv9etmrbv31f8h70scmfenqyvj0dtt6yv90exu6htck41hqwuced5q76c10fxn6ksv841nr683141q7bwvn41rqd83ne1kk0vc9etk2s83ne1hr8832g4h6283hdpt76tcqdpt62vm3dnh6ytj0djkqsuc7e1u20ucf41u6ht90derqwx39etuqbt10d5r68839etk6btm1fjnqfsc2ejkk0tv5etkr4scne5rqw83gdsh6qvmgfxq6bt37dnq20tcsdekqbt3m41u6ht90fen6ywmn41v6bu35epkqwsv541rqd831etwk0sv1f9r62v10f1q6bscmfpt6bch";
      test('encode', () {
        expect(
          codec.encode(Uint8List.fromList(utf8.encode(testString))),
          equals(encoded),
        );
      });
      test('decode', () {
        expect(codec.decode(encoded), utf8.encode(testString));
      });
    });
    group('Custom', () {
      const codec = Base32CodecCustom("0123456789ABCDEFGHJKMNPQRSTVWXYZ", '');
      const encoded =
          "9NGPW839ECG68TBKEHMPWSVND5SPGSB45GG6WVVM41QPWV3S41H7J838D5SJ0WK5C5SPYVHC41H7AX10C9WJ0X38D5SJ0WV9DSKQAV31E8G70RBKEDMPYVH0CSS6YV90DXT6GSBJ41GPWTBDC5P76B10EXM6JRV841MQ683141P7AWVM41QPC83MD1JJ0VB9DSJ2R83MD1GQ8832F4G6283GCNS76SBPCNS62VK3CMG6YSH0CHJPRTB7D1T20TBE41T6GS90CDQPWX39DSTPAS10C5Q68839DSJ6ASK1EHMPERB2DHJJ0SV5DSJQ4RBMD5QPW83FCRG6PVKFEXP6AS37CMP20SBRCDJPAS3K41T6GS90EDM6YWKM41V6AT35DNJPWRV541QPC831DSWJ0RV1E9Q62V10E1P6ARBKENS6ABG";
      test('encode', () {
        expect(
          codec.encode(Uint8List.fromList(utf8.encode(testString))),
          equals(encoded),
        );
      });
      test('decode', () {
        expect(codec.decode(encoded), utf8.encode(testString));
      });
    });
  });
  group('base58', () {
    const dataWithZero = [0, 0, 0, 0, 0xff, 0, 0, 0, 0, 0xff];
    group('Bitcoin', () {
      const codec = Base58CodecBitcoin();
      const testData = [
        ["", ""],
        ["61", "2g"],
        ["626262", "a3gV"],
        ["636363", "aPEr"],
        [
          "73696d706c792061206c6f6e6720737472696e67",
          "2cFupjhnEsSn59qHXstmK2ffpLv2"
        ],
        [
          "00eb15231dfceb60925886b67d065299925915aeb172c06647",
          "1NS17iag9jJgTHD1VXjvLCEnZuQ3rJDE9L"
        ],
        ["516b6fcd0f", "ABnLTmg"],
        ["bf4f89001e670274dd", "3SEo3LWLoPntC"],
        ["572e4794", "3EFU7m"],
        ["ecac89cad93923c02321", "EJDM8drfXA6uyA"],
        ["10c8511e", "Rt5zm"],
        ["00000000000000000000", "1111111111"],
        [
          "000111d38e5fc9071ffcd20b4a763cc9ae4f252bb4e48fd66a835e252ada93ff480d6dd43dc62a641155a5",
          "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
        ],
        [
          "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff",
          "1cWB5HCBdLjAuqGGReWE3R3CguuwSjw6RHn39s2yuDRTS5NsBgNiFpWgAnEx6VQi8csexkgYw3mdYrMHr8x9i7aEwP8kZ7vccXWqKDvGv3u1GxFKPuAkn8JCPPGDMf3vMMnbzm6Nh9zh1gcNsMvH3ZNLmP5fSG6DGbbi2tuwMWPthr4boWwCxf7ewSgNQeacyozhKDDQQ1qL5fQFUW52QKUZDZ5fw3KXNQJMcNTcaB723LchjeKun7MuGW5qyCBZYzA1KjofN1gYBV3NqyhQJ3Ns746GNuf9N2pQPmHz4xpnSrrfCvy6TVVz5d4PdrjeshsWQwpZsZGzvbdAdN8MKV5QsBDY"
        ]
      ];
      const encodedDataWithZero = "11113ByzJkRhg";
      const encoded =
          "2KG5obUH7D2G2qLPjujWXdCd1FK6heTdfCjVn1MwP3unVrwcoTz3QyxtBe8Dpxfc5Afnf6VL2b4Ae9RWHEJ957WJpTXTXKcSyFZb17ALWU1BcBsNv2Cncqm5qTadzLcryeftfjtFZfJ14EKKf7UVd5h7UXFSqpmB144w2Eyb9gwvh7mofZpc7oSQv4ZSso9tD1589EjLERTebQoFtt8isgKarX4HGRWUpQCRkAPWuiNrYeV4XEmE4ez4f2mWN1vgGPcX8mKm7RXjYnQ1aGF3oZvKrQQ1ySEq4b5fLvQxcGzCp9xsVdfgK3pXC1RQPf8nyhik8JEnGdXV999wjaj7ggrcEtmkZH41ynpvSYkDecL8nNMT";

      group(
        'base58 from testData',
        () {
          test('encode', () {
            for (final set in testData) {
              expect(
                codec.encode(Uint8List.fromList(base16.decode(set[0]))),
                equals(set[1]),
              );
            }
          });
          test('decode', () {
            for (final set in testData) {
              expect(
                base16.encode(codec.decode(set[1])),
                equals(set[0].toUpperCase()),
              );
            }
          });
        },
      );
      test('encode', () {
        expect(
          codec.encode(Uint8List.fromList(utf8.encode(testString))),
          equals(encoded),
        );
      });
      test('decode', () {
        expect(codec.decode(encoded), utf8.encode(testString));
      });
      test('encode with zero', () {
        expect(
          codec.encode(Uint8List.fromList(dataWithZero)),
          equals(encodedDataWithZero),
        );
      });
      test('decode with zero', () {
        expect(codec.decode(encodedDataWithZero), dataWithZero);
      });
    });
    group('Flickr', () {
      const codec = Base58CodecFlickr();
      const encodedDataWithZero = "11113bYZiKqGF";
      const encoded =
          '2jg5NAth7d2g2QkoJUJvwCcC1fj6GDsCEcJuM1mWo3UMuRWBNsZ3pYXTbD8dPXEB5aEME6uk2A4aD9qvhei957viPswswjBrYfyA17akvt1bBbSnV2cMBQL5QszCZkBRYDETEJTfyEi14ejjE7tuC5G7twfrQPLb144W2eYA9FWVG7LNEyPB7NrpV4yrSN9Td1589eJkeqsDApNfTT8HSFjzRw4hgqvtPpcqKaovUHnRxDu4weLe4DZ4E2Lvn1VFgoBw8LjL7qwJxMp1zgf3NyVjRpp1YreQ4A5EkVpXBgZcP9XSuCEFj3Pwc1qpoE8MYGHK8ieMgCwu999WJzJ7FFRBeTLKyh41YMPVrxKdDBk8Mnms';
      test('encode', () {
        expect(
          codec.encode(Uint8List.fromList(utf8.encode(testString))),
          equals(encoded),
        );
      });
      test('decode', () {
        expect(codec.decode(encoded), utf8.encode(testString));
      });
      test('encode with zero', () {
        expect(
          codec.encode(Uint8List.fromList(dataWithZero)),
          equals(encodedDataWithZero),
        );
      });
      test('decode with zero', () {
        expect(codec.decode(encodedDataWithZero), dataWithZero);
      });
    });
    group('Ripple', () {
      const codec = Base58CodecRipple();
      const encodedDataWithZero = "rrrrsByzJkR6g";
      const encoded =
          'pKGnob7HfDpGpqLPjujWXdUdrEKa6eTdCUjV8rMAPsu8ViAcoTzsQyxtBe3DFxCcnwC8CaVLpbhwe9RWHNJ9nfWJFTXTXKcSyEZbrfwLW7rBcB14vpU8cqmnqT2dzLciyeCtCjtEZCJrhNKKCf7Vdn6f7XESqFmBrhhApNyb9gAv6fmoCZFcfoSQvhZS1o9tDrn39NjLNRTebQoEtt351gK2iXhHGRW7FQURkwPWu54iYeVhXNmNhezhCpmW4rvgGPcX3mKmfRXjY8Qr2GEsoZvKiQQrySNqhbnCLvQxcGzUF9x1VdCgKsFXUrRQPC38y65k3JN8GdXV999Aj2jfggicNtmkZHhry8FvSYkDecL384MT';
      test('encode', () {
        expect(
          codec.encode(Uint8List.fromList(utf8.encode(testString))),
          equals(encoded),
        );
      });
      test('decode', () {
        expect(codec.decode(encoded), utf8.encode(testString));
      });
      test('encode with zero', () {
        expect(
          codec.encode(Uint8List.fromList(dataWithZero)),
          equals(encodedDataWithZero),
        );
      });
      test('decode with zero', () {
        expect(codec.decode(encodedDataWithZero), dataWithZero);
      });
    });
    group('Custom', () {
      const codec = Base58CodecCustom(alphabet: "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ",
        decodeList: [
        -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,1,2,3,4,5,6,7,
        8,-1,-1,-1,-1,-1,-1,-1,34,35,36,37,38,39,40,41,-1,42,43,
        44,45,46,-1,47,48,49,50,51,52,53,54,55,56,57,-1,-1,-1,-1,
        -1,-1,9,10,11,12,13,14,15,16,17,18,19,-1,20,21,22,23,24,
        25,26,27,28,29,30,31,32,33,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,-1,-1,-1
      ],);
      const encodedDataWithZero = "11113bYZiKqGF";
      const encoded =
          '2jg5NAth7d2g2QkoJUJvwCcC1fj6GDsCEcJuM1mWo3UMuRWBNsZ3pYXTbD8dPXEB5aEME6uk2A4aD9qvhei957viPswswjBrYfyA17akvt1bBbSnV2cMBQL5QszCZkBRYDETEJTfyEi14ejjE7tuC5G7twfrQPLb144W2eYA9FWVG7LNEyPB7NrpV4yrSN9Td1589eJkeqsDApNfTT8HSFjzRw4hgqvtPpcqKaovUHnRxDu4weLe4DZ4E2Lvn1VFgoBw8LjL7qwJxMp1zgf3NyVjRpp1YreQ4A5EkVpXBgZcP9XSuCEFj3Pwc1qpoE8MYGHK8ieMgCwu999WJzJ7FFRBeTLKyh41YMPVrxKdDBk8Mnms';
      test('encode', () {
        expect(
          codec.encode(Uint8List.fromList(utf8.encode(testString))),
          equals(encoded),
        );
      });
      test('decode', () {
        expect(codec.decode(encoded), utf8.encode(testString));
      });
      test('encode with zero', () {
        expect(
          codec.encode(Uint8List.fromList(dataWithZero)),
          equals(encodedDataWithZero),
        );
      });
      test('decode with zero', () {
        expect(codec.decode(encodedDataWithZero), dataWithZero);
      });
    });
  });
  group('base85', () {
    group('Ascii', () {
      const codec = Base85CodecAscii();
      const encoded =
          "<~9jqo^BlbD-BleB1DJ+*+F(f,q/0JhKF<GL>Cj@.4Gp\$d7F!,L7@<6@)/0JDEF<G%<+EV:2F!,O<DJ+*.@<*K0@<6L(Df-\\0Ec5e;DffZ(EZee.Bl.9pF\"AGXBPCsi+DGm>@3BB/F*&OCAfu2/AKYi(DIb:@FD,*)+C]U=@3BN#EcYf8ATD3s@q?d\$AftVqCh[NqF<G:8+EV:.+Cf>-FD5W8ARlolDIal(DId<j@<?3r@:F%a+D58'ATD4\$Bl@l3De:,-DJs`8ARoFb/0JMK@qB4^F!,R<AKZ&-DfTqBG%G>uD.RTpAKYo'+CT/5+Cei#DII?(E,9)oF*2M7/c~>";
      const encodedWithSymbols =
          "<~9jqo^BlbD-BleB1DJ+*+F(f,q/0JhKF<GL>  Cj@.4Gp\$d7F!,L7@<6@)/0JDEF<G%<+EV  :2F!,O<DJ+*.@<*K0@<6L(Df-\\0Ec5e"
          ";DffZ(EZee.Bl.9pF\"AGXBPCsi+DGm>@3BB/F*&OCAfu2/AKYi(DIb:@F      D,*)+C] U=@3BN#EcYf 8ATD3s@q?d\$AftVqCh           [NqF<G:8+EV:.+Cf>-FD5W8ARlolDIal(DId<j@<?3r@:F%a+D58'ATD4\$Bl@l3De:,-DJs`8ARoFb/0JMK@qB4^F!,R<AKZ&-DfTqBG%G>uD.RTpAKYo'+CT/5+Cei#DII?(E,9)oF*2M7/c~>";
      test('encode', () {
        expect(
          codec.encode(Uint8List.fromList(utf8.encode(testString))),
          equals(encoded),
        );
      });
      test('decode', () {
        expect(utf8.decode(codec.decode(encoded)), testString);
      });
      test('decode with spec symbols', () {
        expect(utf8.decode(codec.decode(encodedWithSymbols)), testString);
      });
    });
    group('Z85', () {
      const codec = Base85CodecZ();
      const encoded =
          "o<}]Zx(+zcx(!xgzFa9aB7/b}efF?GBrCHty<vdjC{3^mB0bHmvrlv8efFzABrC4raARphB0bKrzFa9dvr9GfvrlH7z/cXfA=k!qz//V7AV!!dx(do{B1wCTxLy%&azC)tvixxeB95Kyw/#hewGU&7zE+pvBzb98ayYQsvixJ2A=U/nwPzi%v}u^3w/\$R}y?WJ}BrCpnaARpday/tcBzkSnwN(](zE:(7zE^r<vrui@vpB4:azkn6wPzj3x(v(iz!pbczF%-nwN]B+efFIGv}xjZB0bNrwGV5cz/P}xC4Ct#zdNP{wGU]6ayPekay!&2zEEu7Abo8]B9hIme=U>K";
      const encodedWithSymbols =
          "o<}]Zx(+zcx(!xgzFa9a     B7/b}efF?GBrCHt y<vdjC{3^mB0bHmvrlv8efFzABrC   "
          "4raARphB0bKr zFa9dvr9GfvrlH7z/cXfA=k!qz//V7AV!!dx(do{B1wCTxLy%&a zC)tvixxeB95Kyw/#hewGU&7      zE+pvBzb98ayYQsvixJ2A=U/nwPzi%      v}u^3w/\$R}y?WJ}BrCpnaARpday/tcBzkSnwN(](zE:(7zE^r<vrui@vpB4:azkn6wPzj3x(v(iz!pbczF%-nwN]B+efFIGv}xjZB0bNrwGV5cz/P}xC4Ct#zdNP{wGU]6ayPekay!&2zEEu7Abo8]B9hIme=U>K";
      const rfcTestData = [0x86, 0x4F, 0xD2, 0x6F, 0xB5, 0x59, 0xF7, 0x5B];
      const rfcTestDataEncoded = "HelloWorld";
      test('encode', () {
        expect(
          codec.encode(
            Uint8List.fromList([...utf8.encode(testString), 0, 0, 0]),
          ),
          equals(encoded),
        );
        expect(
          codec.encode(
            Uint8List.fromList(rfcTestData),
          ),
          equals(rfcTestDataEncoded),
        );
      });
      test('decode', () {
        expect(codec.decode(encoded), [...utf8.encode(testString), 0, 0, 0]);
        expect(codec.decode(rfcTestDataEncoded), rfcTestData);
      });
      test('decode with spec symbols', () {
        expect(
          codec.decode(encodedWithSymbols),
          [...utf8.encode(testString), 0, 0, 0],
        );
      });
    });
    group('IPv6', () {
      const codec = Base85CodecIPv6();
      //  1080:0:0:0:8:800:200C:417A from RFC 1924
      const address = '108000000000000000080800200C417A';
      const encoded = "4)+k&C#VzJ4br>0wv%Yp";
      test('encode', () {
        expect(
          codec.encode(
            Uint8List.fromList(base16.decode(address)),
          ),
          equals(encoded),
        );
      });
      test('decode', () {
        expect(codec.decode(encoded), base16.decode(address));
      });
    });
    group('base58Check', () {
      const encoded = "5Kd3NBUAdUnhyzenEwVLy9pBKxSwXvE9FMPyR4UKZvpe6E3AgLr";
      const decoded =
          "80EDDBDC1168F1DAEADBD3E44C1E3F8F5A284C2029F78AD26AF98583A499DE5B19";
      test('encode', () {
        expect(base58CheckEncode(base16.decode(decoded)), equals(encoded));
      });
      test('decode', () {
        expect(base16.encode(base58CheckDecode(encoded)), decoded);
      });
    });
  });
}
