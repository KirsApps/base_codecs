
[![codecov](https://codecov.io/gh/KirsApps/base_codecs/branch/master/graph/badge.svg)](https://codecov.io/gh/KirsApps/base_codecs)
[![Build Status](https://github.com/KirsApps/base_codecs/workflows/build/badge.svg)](https://github.com/KirsApps/base_codecs/actions?query=workflow%3A"build"+branch%3Amaster)
[![pub](https://img.shields.io/pub/v/base_codecs.svg)](https://pub.dev/packages/lint)
[![style: lint](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)

A set of codecs for encode and decode data.

## Features

* [base16 (hex)](#Base16)
* [base32](#Base32)
* [base58](#Base58)
* [base85](#Base85)

## Base16
Supported hex alphabet and custom alphabets.
### Hex
- **Codec** - Base16Codec
- **codec variable** - base16 (and alias hex)
- **Functions** - base16Encode (hexEncode), base16Decode (hexDecode)

### Custom

- **Codec** - Base16CodecCustom
- **Description** - You can pass custom alphabet to Codec for encode and decode data by this alphabet.

## Base32
Supported Rfc, RfcHex, Crockford, ZBase, GeoHash, WordSafe, Custom alphabets
### Rfc
- **Codec** - Base32CodecRfc
- **codec variable** - base32Rfc
- **Functions** - base32RfcEncode, base32RfcDecode
### RfcHex
- **Codec** - Base32CodecRfcHex
- **codec variable** - base32RfcHex
- **Functions** - base32RfcHexEncode, base32RfcHexDecode
### Crockford
- **Codec** - Base32CodecCrockford
- **codec variable** - base32Crockford
- **Functions** - base32CrockfordEncode, base32CrockfordDecode
### ZBase
- **Codec** - Base32CodecZBase
- **codec variable** - base32ZBase
- **Functions** - base32ZBaseEncode, base32ZBaseDecode
### GeoHash
- **Codec** - Base32CodecGeoHash
- **codec variable** - base32GeoHash
- **Functions** - base32GeoHashEncode, base32GeoHashDecode
### WordSafe
- **Codec** - Base32CodecWordSafe
- **codec variable** - base32WordSafe
- **Functions** - base32WordSafeEncode, base32WordSafeDecode
### Custom
- **Codec** - Base32CodecCustom
- **Description** - You can pass custom alphabet and padding to Codec for encode and decode data by this alphabet.

## Base58
Supported Bitcoin, Flickr, Ripple, Custom alphabets
### Bitcoin
- **Codec** - Base58CodecBitcoin
- **codec variable** - base58Bitcoin
- **Functions** - base58BitcoinEncode, base58BitcoinDecode
### Flickr
- **Codec** - Base58CodecFlickr
- **codec variable** - base58Flickr
- **Functions** - base58FlickrEncode, base58FlickrDecode
### Ripple
- **Codec** - Base58CodecRipple
- **codec variable** - base58Ripple
- **Functions** - base58RippleEncode, base58RippleDecode
### Custom
- **Codec** - Base58CodecCustom
- **Description** - You can pass custom alphabet and decodeList to Codec for encode and decode data by this alphabet.
### Base58Check
- **Functions** - base58CheckEncode, base58CheckDecode
## Base85

Supported Ascii85, ZeroMq, IPv6

### Ascii85
- **Codec** - Base85CodecAscii
- **codec variable** - base85Ascii
- **Functions** - base85AsciiEncode, base85AsciiDecode
### ZeroMq
- **Codec** - Base85CodecZ
- **codec variable** - base85Z
- **Functions** - base85ZEncode, base85ZDecode
### IPv6
- **Codec** - Base85CodecIPv6
- **codec variable** - base85IPv6
- **Functions** - base85IPv6Encode, base85IPv6Decode