import 'dart:convert';
import 'dart:typed_data';

import 'package:base_codecs/base_codecs.dart';
import 'package:test/test.dart';

void main() {
  const testString =
      "Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of the mind, that by a perseverance of delight in the continued and indefatigable generation of knowledge, exceeds the short vehemence of any carnal pleasure.";
  group('base16', () {
    const data = [0xDE, 0xAD, 0xBE, 0xEF];
    const codec = Base16Codec();
    test('encode', () {
      expect(codec.encode(Uint8List.fromList(data)), equals('DEADBEEF'));
    });
    test('decode', () {
      expect(codec.decode('DEADBEEF'), data);
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
  });
  group('base58', () {
    const dataWithZero = [0, 0, 0, 0, 0xff, 0, 0, 0, 0, 0xff];
    group('Bitcoin', () {
      const codec = Base58CodecBitcoin();
      const encodedDataWithZero = "11113ByzJkRhg";
      const encoded =
          "2KG5obUH7D2G2qLPjujWXdCd1FK6heTdfCjVn1MwP3unVrwcoTz3QyxtBe8Dpxfc5Afnf6VL2b4Ae9RWHEJ957WJpTXTXKcSyFZb17ALWU1BcBsNv2Cncqm5qTadzLcryeftfjtFZfJ14EKKf7UVd5h7UXFSqpmB144w2Eyb9gwvh7mofZpc7oSQv4ZSso9tD1589EjLERTebQoFtt8isgKarX4HGRWUpQCRkAPWuiNrYeV4XEmE4ez4f2mWN1vgGPcX8mKm7RXjYnQ1aGF3oZvKrQQ1ySEq4b5fLvQxcGzCp9xsVdfgK3pXC1RQPf8nyhik8JEnGdXV999wjaj7ggrcEtmkZH41ynpvSYkDecL8nNMT";
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
      const base16 = Base16Codec();
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
  });
}
