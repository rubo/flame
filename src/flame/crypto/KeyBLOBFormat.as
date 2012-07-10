////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	/**
	 * Specifies a key BLOB format for use with asymmetric algorithms. 
	 */
	public final class KeyBLOBFormat
	{
		/**
		 * Specifies an ECC private key BLOB.
		 * <p>The ECC private key BLOB format contains both the public and private portions of an ECC key.</p>
		 * <p>The key BLOB structure is:</p>
		 * <p><table class="innertable">
		 * <tr><th>Parameter</th><th>Length</th><th>Description</th></tr>
		 * <tr><td>Magic</td><td>4 bytes</td><td>The type of the key (little-endian unsigned integer).</td></tr>
		 * <tr><td>KeySize</td><td>4 bytes</td><td>The size, in bytes, of the key (little-endian unsigned integer).</td></tr>
		 * <tr><td>X</td><td><i>KeySize</i> bytes</td><td>The X parameter of the key (big-endian unsigned integer).</td></tr>
		 * <tr><td>Y</td><td><i>KeySize</i> bytes</td><td>The Y parameter of the key (big-endian unsigned integer).</td></tr>
		 * <tr><td>D</td><td><i>KeySize</i> bytes</td><td>The D parameter of the key (big-endian unsigned integer).</td></tr>
		 * </table></p>
		 * <p>The Magic parameter specifies the type of key the BLOB represents.
		 * The following values use the NIST prime curves defined in FIPS 186-3.</p>
		 * <p><table class="innertable">
		 * <tr><th>Value</th><th>Description</th></tr>
		 * <tr><td>0x324B4345</td><td>The key is a 256-bit ECDH private key.</td></tr>
		 * <tr><td>0x344B4345</td><td>The key is a 384-bit ECDH private key.</td></tr>
		 * <tr><td>0x364B4345</td><td>The key is a 521-bit ECDH private key.</td></tr>
		 * <tr><td>0x32534345</td><td>The key is a 256-bit ECDSA private key.</td></tr>
		 * <tr><td>0x34534345</td><td>The key is a 384-bit ECDSA private key.</td></tr>
		 * <tr><td>0x36534345</td><td>The key is a 521-bit ECDSA private key.</td></tr>
		 * </table></p>
		 */
		public static const ECC_PRIVATE_BLOB:String = "ECCPRIVATEBLOB";
		
		/**
		 * Specifies an ECC public key BLOB.
		 * <p>The key BLOB structure is:</p>
		 * <p><table class="innertable">
		 * <tr><th>Parameter</th><th>Length</th><th>Description</th></tr>
		 * <tr><td>Magic</td><td>4 bytes</td><td>The type of the key (little-endian unsigned integer).</td></tr>
		 * <tr><td>KeySize</td><td>4 bytes</td><td>The size, in bytes, of the key (little-endian unsigned integer).</td></tr>
		 * <tr><td>X</td><td><i>KeySize</i> bytes</td><td>The X parameter of the key (big-endian unsigned integer).</td></tr>
		 * <tr><td>Y</td><td><i>KeySize</i> bytes</td><td>The Y parameter of the key (big-endian unsigned integer).</td></tr>
		 * </table></p>
		 * <p>The Magic parameter specifies the type of key the BLOB represents.
		 * The following values use the NIST prime curves defined in FIPS 186-3.</p>
		 * <p><table class="innertable">
		 * <tr><th>Value</th><th>Description</th></tr>
		 * <tr><td>0x314B4345</td><td>The key is a 256-bit ECDH public key.</td></tr>
		 * <tr><td>0x334B4345</td><td>The key is a 384-bit ECDH public key.</td></tr>
		 * <tr><td>0x354B4345</td><td>The key is a 521-bit ECDH public key.</td></tr>
		 * <tr><td>0x31534345</td><td>The key is a 256-bit ECDSA public key.</td></tr>
		 * <tr><td>0x33534345</td><td>The key is a 384-bit ECDSA public key.</td></tr>
		 * <tr><td>0x35534345</td><td>The key is a 521-bit ECDSA public key.</td></tr>
		 * </table></p>
		 */
		public static const ECC_PUBLIC_BLOB:String = "ECCPUBLICBLOB";
		
		/**
		 * Specifies a PKCS #8 private key BLOB.
		 * <p>PKCS #8 private key BLOB contains both private and public key material in PKCS #8 format.</p>
		 */
		public static const PKCS8_PRIVATE_BLOB:String = "PKCS8_PRIVATEKEY";
		
		/**
		 * Specifies a PKCS #8 public key BLOB.
		 */
		public static const PKCS8_PUBLIC_BLOB:String = "PKCS8_PUBLICKEY";
		
		/**
		 * Specifies an RSA full private key BLOB.
		 * <p>The RSA private key BLOB format contains both the public and private portions of an RSA key.</p>
		 * <p>The key BLOB structure is:</p>
		 * <p><table class="innertable">
		 * <tr><th>Parameter</th><th>Length</th><th>Description</th></tr>
		 * <tr><td>Magic</td><td>4 bytes</td><td>The type of the key (0x33415352, little-endian unsigned integer).</td></tr>
		 * <tr><td>KeySize</td><td>4 bytes</td><td>The size, in bits, of the key (little-endian unsigned integer).</td></tr>
		 * <tr><td>PublicExponentSize</td><td>4 bytes</td><td>The size, in bytes, of the public exponent of the key (little-endian unsigned integer).</td></tr>
		 * <tr><td>ModulusSize</td><td>4 bytes</td><td>The size, in bytes, of the modulus of the key (little-endian unsigned integer).</td></tr>
		 * <tr><td>Prime1Size</td><td>4 bytes</td><td>The size, in bytes, of the first prime number of the key. This is only used for private key BLOBs (little-endian unsigned integer).</td></tr>
		 * <tr><td>Prime2Size</td><td>4 bytes</td><td>The size, in bytes, of the second prime number of the key. This is only used for private key BLOBs (little-endian unsigned integer).</td></tr>
		 * <tr><td>PublicExponent</td><td><i>PublicExponentSize</i> bytes</td><td>The public exponent of the key (big-endian unsigned integer).</td></tr>
		 * <tr><td>Modulus</td><td><i>ModulusSize</i> bytes</td><td>The modulus of the key (big-endian unsigned integer).</td></tr>
		 * <tr><td>Prime1</td><td><i>Prime1Size</i> bytes</td><td>The first prime number of the key (big-endian unsigned integer).</td></tr>
		 * <tr><td>Prime2</td><td><i>Prime2Size</i> bytes</td><td>The second prime number of the key (big-endian unsigned integer).</td></tr>
		 * <tr><td>Exponent1</td><td><i>Prime1Size</i> bytes</td><td>The first exponent of the key (big-endian unsigned integer).</td></tr>
		 * <tr><td>Exponent2</td><td><i>Prime2Size</i> bytes</td><td>The second exponent of the key (big-endian unsigned integer).</td></tr>
		 * <tr><td>Coefficient</td><td><i>Prime1Size</i> bytes</td><td>The coefficient of the key (big-endian unsigned integer).</td></tr>
		 * <tr><td>PrivateExponent</td><td><i>ModulusSize</i> bytes</td><td>The private exponent of the key (big-endian unsigned integer).</td></tr>
		 * </table></p>
		 */
		public static const RSA_FULL_PRIVATE_BLOB:String = "RSAFULLPRIVATEBLOB";
		
		/**
		 * Specifies an RSA private key BLOB.
		 * <p>The RSA private key BLOB format contains both the public and private portions of an RSA key.</p>
		 * <p>The key BLOB structure is:</p>
		 * <p><table class="innertable">
		 * <tr><th>Parameter</th><th>Length</th><th>Description</th></tr>
		 * <tr><td>Magic</td><td>4 bytes</td><td>The type of the key (0x32415352, little-endian unsigned integer).</td></tr>
		 * <tr><td>KeySize</td><td>4 bytes</td><td>The size, in bits, of the key (little-endian unsigned integer).</td></tr>
		 * <tr><td>PublicExponentSize</td><td>4 bytes</td><td>The size, in bytes, of the public exponent of the key (little-endian unsigned integer).</td></tr>
		 * <tr><td>ModulusSize</td><td>4 bytes</td><td>The size, in bytes, of the modulus of the key (little-endian unsigned integer).</td></tr>
		 * <tr><td>Prime1Size</td><td>4 bytes</td><td>The size, in bytes, of the first prime number of the key. This is only used for private key BLOBs (little-endian unsigned integer).</td></tr>
		 * <tr><td>Prime2Size</td><td>4 bytes</td><td>The size, in bytes, of the second prime number of the key. This is only used for private key BLOBs (little-endian unsigned integer).</td></tr>
		 * <tr><td>PublicExponent</td><td><i>PublicExponentSize</i> bytes</td><td>The public exponent of the key (big-endian unsigned integer).</td></tr>
		 * <tr><td>Modulus</td><td><i>ModulusSize</i> bytes</td><td>The modulus of the key (big-endian unsigned integer).</td></tr>
		 * <tr><td>Prime1</td><td><i>Prime1Size</i> bytes</td><td>The first prime number of the key (big-endian unsigned integer).</td></tr>
		 * <tr><td>Prime2</td><td><i>Prime2Size</i> bytes</td><td>The second prime number of the key (big-endian unsigned integer).</td></tr>
		 * </table></p>
		 */
		public static const RSA_PRIVATE_BLOB:String = "RSAPRIVATEBLOB";
		
		/**
		 * Specifies an RSA public key BLOB.
		 * <p>The key BLOB structure is:</p>
		 * <p><table class="innertable">
		 * <tr><th>Parameter</th><th>Length</th><th>Description</th></tr>
		 * <tr><td>Magic</td><td>4 bytes</td><td>The type of the key (0x31415352, little-endian unsigned integer).</td></tr>
		 * <tr><td>KeySize</td><td>4 bytes</td><td>The size, in bits, of the key (little-endian unsigned integer).</td></tr>
		 * <tr><td>PublicExponentSize</td><td>4 bytes</td><td>The size, in bytes, of the public exponent of the key (little-endian unsigned integer).</td></tr>
		 * <tr><td>ModulusSize</td><td>4 bytes</td><td>The size, in bytes, of the modulus of the key (little-endian unsigned integer).</td></tr>
		 * <tr><td>Prime1Size</td><td>4 bytes</td><td>The size, in bytes, of the first prime number of the key. This is only used for private key BLOBs (little-endian unsigned integer).</td></tr>
		 * <tr><td>Prime2Size</td><td>4 bytes</td><td>The size, in bytes, of the second prime number of the key. This is only used for private key BLOBs (little-endian unsigned integer).</td></tr>
		 * <tr><td>PublicExponent</td><td><i>PublicExponentSize</i> bytes</td><td>The public exponent of the key (big-endian unsigned integer).</td></tr>
		 * <tr><td>Modulus</td><td><i>ModulusSize</i> bytes</td><td>The modulus of the key (big-endian unsigned integer).</td></tr>
		 * </table></p>
		 */
		public static const RSA_PUBLIC_BLOB:String = "RSAPUBLICBLOB";
	}
}