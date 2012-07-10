Flame is an ActionScript library that provides a number of useful UI controls, cryptographic services, and utilities to work with the Flex SDK.

The code is released under the [Microsoft Public License (MS-PL)](http://opensource.org/licenses/MS-PL). 

The API is heavily inspired by .NET Framework.

### Collections
Provides wrapper classes that expose a Vector as a collection that can be accessed and manipulated using the methods and properties of the ICollectionView or IList interfaces. 

### Cryptographic Services
Provides cryptographic services including support for National Security Agency (NSA) Suite B algorithms, secure encoding and decoding of data, as well as hashing and random number generation. All algorithms has been tested for the compatibility with .NET Framework and JDK (JCE). 
- Hash algorithms: MD5, RIPEMD-160, SHA-1, SHA-2 (SHA-224, SHA-256, SHA-384, SHA-512) 
- Keyed-hash algorithms: HMAC 
- Symmetric algorithms: AES, Rijndael, RC4 
- Asymmetric algorithms: RSA, Elliptic Curve Diffie-Hellman (ECDH), Elliptic Curve Digital Signature Algorithm (ECDSA) 

Also provides support for Abstract Syntax Notation One (ASN.1) encoding and decoding. 

### Numerics
Provides classes to represent arbitrarily large signed integers and complex numbers. 

### UI Controls
Provides both Spark and MX controls for single/multi-file uploading, checkbox grouping, collapsible panel, advanced tab bar, flow layout, bindable validators, and a few small extensions to several controls of the Flex SDK. 

### Utilities
Provides a few utility classes to work with Array, Vector, ByteArray, Date, and String types as well as methods for data conversion.

### How to build

The library can be built using Ant:
	ant -f <Path to the project>/build.xml -Dbasedir=<Path to the project>
Note that it is required to define an environment variable FLEX_HOME pointing to the Flex SDK 4.6 directory.