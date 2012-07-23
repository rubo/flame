////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.utils.ByteArrayUtil;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.getQualifiedClassName;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	[ResourceBundle("flameCore")]
	
	/**
	 * Accesses the cryptography configuration information.
	 * <p>You do not create instances of CryptoConfig;
	 * instead you call methods such as the <code>CryptoConfig.createFromName()</code> method.</p>
	 * <p>The following table shows the simple names recognized by this class
	 * and the default algorithm implementations to which they map.
	 * Alternatively, you can map other implementations to these names.</p>
	 * <p><table class="innertable">
	 * <tr><th>Simple name</th><th>Algorithm implementation</th></tr>
	 * <tr><td>AES, flame.crypto::AES</td><td>flame.crypto.AES</td></tr>
	 * <tr><td>ECDiffieHellman, ECDH, flame.crypto::ECDiffieHellman</td><td>flame.crypto.ECDiffieHellman</td></tr>
	 * <tr><td>flame.crypto::HashAlgorithm</td><td>flame.crypto.SHA1</td></tr>
	 * <tr><td>flame.crypto::HMAC</td><td>flame.crypto.HMACSHA1</td></tr>
	 * <tr><td>flame.crypto::KeyedHashAlgorithm</td><td>flame.crypto.HMACSHA1</td></tr>
	 * <tr><td>HMACMD5, HMAC-MD5, flame.crypto::HMACMD5</td><td>flame.crypto.HMACMD5</td></tr>
	 * <tr><td>HMACRIMPEMD160, HMAC-RIPEMD160, HMAC-RIPEMD-160, flame.crypto::HMACRIPEMD160</td><td>flame.crypto.HMACRIPEMD160</td></tr>
	 * <tr><td>HMACSHA1, HMAC-SHA1, HMAC-SHA-1, flame.crypto::HMACSHA1</td><td>flame.crypto.HMACSHA1</td></tr>
	 * <tr><td>HMACSHA224, HMAC-SHA224, HMAC-SHA-224, flame.crypto::HMACSHA224</td><td>flame.crypto.HMACSHA224</td></tr>
	 * <tr><td>HMACSHA256, HMAC-SHA256, HMAC-SHA-256, flame.crypto::HMACSHA256</td><td>flame.crypto.HMACSHA256</td></tr>
	 * <tr><td>HMACSHA384, HMAC-SHA384, HMAC-SHA-384, flame.crypto::HMACSHA384</td><td>flame.crypto.HMACSHA384</td></tr>
	 * <tr><td>HMACSHA512, HMAC-SHA512, HMAC-SHA-512, flame.crypto::HMACSHA512</td><td>flame.crypto.HMACSHA512</td></tr>
	 * <tr><td>MD5, flame.crypto::MD5</td><td>flame.crypto.MD5</td></tr>
	 * <tr><td>RC4, flame.crypto::RC4</td><td>flame.crypto.RC4</td></tr>
	 * <tr><td>Rijndael, flame.crypto::Rijndael</td><td>flame.crypto.Rijndael</td></tr>
	 * <tr><td>RIPEMD160, RIPEMD-160, flame.crypto::RIPEMD160</td><td>flame.crypto.RIPEMD160</td></tr>
	 * <tr><td>RSA, flame.crypto::RSA</td><td>flame.crypto.RSA</td></tr>
	 * <tr><td>SHA1, SHA-1, flame.crypto::SHA1</td><td>flame.crypto.SHA1</td></tr>
	 * <tr><td>SHA224, SHA-224, flame.crypto::SHA224</td><td>flame.crypto.SHA224</td></tr>
	 * <tr><td>SHA256, SHA-256, flame.crypto::SHA256</td><td>flame.crypto.SHA256</td></tr>
	 * <tr><td>SHA384, SHA-384, flame.crypto::SHA384</td><td>flame.crypto.SHA384</td></tr>
	 * <tr><td>SHA512, SHA-512, flame.crypto::SHA512</td><td>flame.crypto.SHA512</td></tr>
	 * </table></p>
	 */
	public final class CryptoConfig
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private static const _oidTable:Dictionary = new Dictionary();
		private static const _typeTable:Dictionary = new Dictionary();
		
		private static var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		//--------------------------------------------------------------------------
		//
		//  Static constructor
		//
		//--------------------------------------------------------------------------
		
		{
			addAlgorithm(AES, "AES", getQualifiedClassName(AES));
			addAlgorithm(ECDiffieHellman, "ECDiffieHellman", "ECDH", getQualifiedClassName(ECDiffieHellman));
			addAlgorithm(HMACMD5, "HMACMD5", "HMAC-MD5", getQualifiedClassName(HMACMD5));
			addAlgorithm(HMACRIPEMD160, "HMACRIPEMD160", "HMAC-RIPEMD160", "HMAC-RIPEMD-160", getQualifiedClassName(HMACRIPEMD160));
			addAlgorithm(HMACSHA1, "HMACSHA1", "HMAC-SHA1", "HMAC-SHA-1", getQualifiedClassName(HMACSHA1), getQualifiedClassName(HMAC), getQualifiedClassName(KeyedHashAlgorithm));
			addAlgorithm(HMACSHA224, "HMACSHA224", "HMAC-SHA224", "HMAC-SHA-224", getQualifiedClassName(HMACSHA224));
			addAlgorithm(HMACSHA256, "HMACSHA256", "HMAC-SHA256", "HMAC-SHA-256", getQualifiedClassName(HMACSHA256));
			addAlgorithm(HMACSHA384, "HMACSHA384", "HMAC-SHA384", "HMAC-SHA-384", getQualifiedClassName(HMACSHA384));
			addAlgorithm(HMACSHA512, "HMACSHA512", "HMAC-SHA512", "HMAC-SHA-512", getQualifiedClassName(HMACSHA512));
			addAlgorithm(MD5, "MD5", getQualifiedClassName(MD5));
			addAlgorithm(RC4, "RC4", getQualifiedClassName(RC4));
			addAlgorithm(Rijndael, "Rijndael", getQualifiedClassName(Rijndael));
			addAlgorithm(RIPEMD160, "RIPEMD160", "RIPEMD-160", getQualifiedClassName(RIPEMD160));
			addAlgorithm(RSA, "RSA", getQualifiedClassName(RSA));
			addAlgorithm(SHA1, "SHA1", "SHA-1", getQualifiedClassName(SHA1), getQualifiedClassName(HashAlgorithm));
			addAlgorithm(SHA224, "SHA224", "SHA-224", getQualifiedClassName(SHA224));
			addAlgorithm(SHA256, "SHA256", "SHA-256", getQualifiedClassName(SHA256));
			addAlgorithm(SHA384, "SHA384", "SHA-384", getQualifiedClassName(SHA384));
			addAlgorithm(SHA512, "SHA512", "SHA-512", getQualifiedClassName(SHA512));
			
			addOID("1.0.18033.3.2.1", "Rijndael", getQualifiedClassName(Rijndael));
			addOID("1.2.840.10045.2.1", "ECC");
			addOID("1.2.840.10045.3.1.7", "ansix9p256r1", "secp256r1", "NIST P-256");
			addOID("1.2.840.113549.1.1.1", "RSA", getQualifiedClassName(RSA));
			addOID("1.2.840.113549.2.5", "MD5", getQualifiedClassName(MD5));
			addOID("1.2.840.113549.2.7", "HMAC-SHA1", "HMAC-SHA-1"), getQualifiedClassName(HMACSHA1);
			addOID("1.2.840.113549.2.8", "HMAC-SHA224", "HMAC-SHA-224", getQualifiedClassName(HMACSHA224));
			addOID("1.2.840.113549.2.9", "HMAC-SHA256", "HMAC-SHA-256", getQualifiedClassName(HMACSHA256));
			addOID("1.2.840.113549.2.10", "HMAC-SHA384", "HMAC-SHA-384", getQualifiedClassName(HMACSHA384));
			addOID("1.2.840.113549.2.11", "HMAC-SHA512", "HMAC-SHA-512", getQualifiedClassName(HMACSHA512));
			addOID("1.2.840.113549.3.4", "RC4", getQualifiedClassName(RC4));
			addOID("1.3.6.1.5.5.8.1.1", "HMAC-MD5", getQualifiedClassName(HMACMD5));
			addOID("1.3.6.1.5.5.8.1.4", "HMAC-RIPEMD160", "HMAC-RIPEMD-160", getQualifiedClassName(HMACRIPEMD160));
			addOID("1.3.14.3.2.26", "SHA1", "SHA-1", getQualifiedClassName(SHA1));
			addOID("1.3.36.3.2.1", "RIPEMD160", "RIPEMD-160", getQualifiedClassName(RIPEMD160));
			addOID("1.3.132.0.34", "ansix9p384r1", "secp384r1", "NIST P-384");
			addOID("1.3.132.0.35", "ansix9p521r1", "secp521r1", "NIST P-521");
			addOID("2.16.840.1.101.3.4.1", "AES", getQualifiedClassName(AES));
			addOID("2.16.840.1.101.3.4.2.1", "SHA256", "SHA-256", getQualifiedClassName(SHA256));
			addOID("2.16.840.1.101.3.4.2.2", "SHA384", "SHA-384", getQualifiedClassName(SHA384));
			addOID("2.16.840.1.101.3.4.2.3", "SHA512", "SHA-512", getQualifiedClassName(SHA512));
			addOID("2.16.840.1.101.3.4.2.4", "SHA224", "SHA-224", getQualifiedClassName(SHA224));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Adds a set of names to algorithm mappings to be used for the current application domain.
		 * <p>The specified mappings take precedence over the built-in mappings.</p>
		 * 
		 * @param algorithm The algorithm to map to.
		 * 
		 * @param names Names to map to the algorithm.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>algorithm</code> parameter is <code>null</code>.</li>
		 * <li><code>names</code> parameter is <code>null</code>.</li>
		 * </ul>
		 */
		public static function addAlgorithm(algorithm:Class, ...names):void
		{
			if (algorithm == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "algorithm" ]));
			
			if (names.length == 0)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "names" ]));
			
			for each (var name:String in names)
				_typeTable[name] = algorithm;
		}
		
		/**
		 * Adds a set of names to object identifier (OID) mappings to be used for the current application domain.
		 * <p>The specified mappings take precedence over the built-in mappings.</p>
		 * 
		 * @param oid The object identifier (OID) to map to.
		 * 
		 * @param names names to map to the OID.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>oid</code> parameter is <code>null</code>.</li>
		 * <li><code>names</code> parameter is <code>null</code>.</li>
		 * </ul>
		 */
		public static function addOID(oid:String, ...names):void
		{
			if (oid == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "oid" ]));

			if (names.length == 0)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "names" ]));
			
			for each (var name:String in names)
				_oidTable[name] = oid;
		}
		
		/**
		 * Creates a new instance of the specified cryptographic object with the specified arguments.
		 * 
		 * @param name The simple name of the cryptographic object of which to create an instance.
		 * 
		 * @param params The arguments used to create the specified cryptographic object.
		 * 
		 * @return A new instance of the specified cryptographic object.
		 * 
		 * @throws ArgumentError <code>name</code> parameter is <code>null</code>.
		 */
		public static function createFromName(name:String, ...params):*
		{
			if (name == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "name" ]));
			
			var type:Class = _typeTable[name];
			
			if (type != null)
				return params.length == 0 ? new type() : new type(params);
			
			return null;
		}
		
		/**
		 * Gets the object identifier (OID) of the algorithm corresponding to the specified simple name.
		 * 
		 * @param name The simple name of the algorithm for which to get the OID.
		 * 
		 * @return The OID of the specified algorithm.
		 * 
		 * @throws ArgumentError <code>name</code> parameter is <code>null</code>.
		 */
		public static function mapNameToOID(name:String):String
		{
			if (name == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "name" ]));
			
			return _oidTable[name];
		}
	}
}