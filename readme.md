Flame is an ActionScript library that provides a number of useful UI controls, collections, cryptographic services, and utilities to work with the Flex SDK.

The API is heavily inspired by .NET Framework.

## License
The code is released under the [Microsoft Public License (MS-PL)](http://opensource.org/licenses/MS-PL).

## Features
#### Collections
Provides wrapper classes that expose a Vector as a collection that can be accessed and manipulated using the methods and properties of the ICollectionView or IList interfaces.

#### Cryptographic services
Provides cryptographic services including support for [National Security Agency (NSA) Suite B](http://www.nsa.gov/ia/programs/suiteb_cryptography) algorithms, secure encoding and decoding of data, as well as hashing and random number generation. All algorithms has been tested for the compatibility with .NET Framework and JDK (JCE).
- Hash algorithms: MD5, RIPEMD-160, SHA-1, SHA-2 (SHA-224, SHA-256, SHA-384, SHA-512)
- Keyed-hash algorithms: HMAC
- Symmetric algorithms: AES, Rijndael, RC4
- Asymmetric algorithms: RSA (with key blinding, OAEP, PKCS #1, PSS), Elliptic Curve Diffie-Hellman (ECDH), Elliptic Curve Digital Signature Algorithm (ECDSA)
- Abstract Syntax Notation One (ASN.1) encoding and decoding

#### Numerics
Provides classes to represent arbitrarily large signed integers (BigInteger) and complex numbers.

#### UI controls
Provides both Spark and MX controls for single and multi-file uploading, checkbox grouping, collapsible panel, advanced tab bar, flow layout, bindable validators, and a few small extensions to several controls of the Flex SDK.

#### Utilities
Provides a few utility classes to work with Array, Vector, ByteArray, Date, and String types as well as methods for data conversion.

## Build
The library can be compiled using Ant:

	ant -f <Path to the project>/build.xml -Dbasedir=<Path to the project>

Note that it is required to define an environment variable FLEX_HOME pointing to the Flex SDK directory.

## Downloads
- [Flame 2.9.3 binary (SWC)](http://flame.blob.core.windows.net/flame/flame-2.9.4.swc)
- [Flame 2.9.0 documentation](http://flame.blob.core.windows.net/flame/flame-2.9.0.docs.zip)