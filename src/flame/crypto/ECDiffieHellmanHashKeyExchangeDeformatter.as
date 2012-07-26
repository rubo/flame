////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.utils.ByteArrayUtil;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;

	/**
	 * Derives the elliptic curve cryptography (ECC) key material using the specified hash algorithm.
	 * <p>The amount of key material that is generated is equivalent to
	 * the size of the hash value for the specified algorithm.</p>
	 */
	public class ECDiffieHellmanHashKeyExchangeDeformatter extends AsymmetricKeyExchangeDeformatter
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _format:String;
		private var _hashAlgorithm:HashAlgorithm;
		private var _key:ECDiffieHellman;
		private var _secretAppend:ByteArray;
		private var _secretPrepend:ByteArray;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ECDiffieHellmanHashKeyExchangeDeformatter class.
		 * 
		 * @param key The instance of the ECDiffieHellman class that holds the private key.
		 */
		public function ECDiffieHellmanHashKeyExchangeDeformatter(key:AsymmetricAlgorithm = null)
		{
			super();
			
			if (key != null)
				setKey(key);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Derives the key material that is generated from the secret agreement between two parties,
		 * given a byte array that contains the second party's public key.
		 * <p>You must specify a key and a hash algorithm before calling this method.</p>
		 * 
		 * @param data A byte array that contains the public part
		 * of the elliptic curve cryptography (ECC) key from the other party in the key exchange.
		 * 
		 * @return A byte array that contains the key material.
		 * This information is generated from the secret agreement that is calculated
		 * from the current private key and the specified public key.
		 * 
		 * @throws flame.crypto.CryptoError Thrown in the following situations:<ul>
		 * <li>The private key is missing.</li>
		 * <li>The hash algorithm is missing.</li>
		 * <li>The key BLOB format is missing.</li>
		 * </ul>
		 */
		public override function decryptKeyExchange(data:ByteArray):ByteArray
		{
			if (_key == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "missingKey"));
			
			if (_hashAlgorithm == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "missingHashAlgorithm"));
			
			if (_format == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "missingKeyBLOBFormat"));
			
			var otherPartyPublicParameters:ECCParameters = ECCParameters.fromByteArray(data, _format);
			var secretAgreement:ByteArray = _key.deriveSecretAgreement(otherPartyPublicParameters);
			
			if (_secretPrepend != null)
				ByteArrayUtil.insertBytes(secretAgreement, 0, _secretPrepend);
			
			if (_secretAppend != null)
				ByteArrayUtil.addBytes(secretAgreement, _secretAppend);
			
			return _hashAlgorithm.computeHash(secretAgreement);
		}
		
		/**
		 * Sets the hash algorithm to use when generating key material.
		 * <p>You must set a hash algorithm before calling the <code>decryptKeyExchange()</code> method.</p>
		 * 
		 * @param name The name of the hash algorithm to use for hashing.
		 * 
		 * @throws ArgumentError <code>name</code> parameter is <code>null</code>.
		 */
		public function setHashAlgorithm(name:String):void
		{
			if (name == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "name" ]));
			
			_hashAlgorithm = HashAlgorithm(CryptoConfig.createFromName(name));
		}
		
		/**
		 * Sets the private key to use for deriving the key material.
		 * <p>You must set a key before calling the <code>decryptKeyExchange()</code> method.</p>
		 * 
		 * @param key The instance of the ECDiffieHellman algorithm that holds the private key.
		 * 
		 * @throws ArgumentError <code>key</code> parameter is <code>null</code>.
		 * 
		 * @see flame.crypto.ECDiffieHellman
		 */
		public override function setKey(key:AsymmetricAlgorithm):void
		{
			if (key == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "key" ]));
			
			_key = ECDiffieHellman(key);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets or sets the format of the key BLOB to generate the secret agreement.
		 * <p>You must set a format before calling the <code>decryptKeyExchange()</code> method.</p>
		 * <p>See KeyBLOBFormat enumeration for a description of specific formats.</p>
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 * 
		 * @see flame.crypto.KeyBLOBFormat
		 */
		public function get format():String
		{
			return _format;
		}
		
		/**
		 * @private 
		 */
		public function set format(value:String):void
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			_format = value;
		}
		
		/**
		 * This property is not supported for this deformatter.
		 * 
		 * @throws flash.errors.IllegalOperationError The property is not supported.
		 */
		public override function get parameters():String
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotSupported"));
		}
		
		/**
		 * @private
		 */
		public override function set parameters(value:String):void
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotSupported"));
		}

		/**
		 * Gets or sets a value that will be appended to the secret agreement
		 * when deriving key material.
		 * <p>The value is appended to the secret agreement,
		 * and the combined value is passed to the key derivation function (KDF)
		 * to generate the key material. By default, the value is <code>null</code>.</p>
		 */
		public function get secretAppend():ByteArray
		{
			return _secretAppend;
		}

		/**
		 * @private
		 */
		public function set secretAppend(value:ByteArray):void
		{
			_secretAppend = value;
		}

		/**
		 * Gets or sets a value that will be added to the beginning of the secret agreement
		 * when deriving key material.
		 * <p>The value is prepended to the secret agreement,
		 * and the combined value is passed to the key derivation function (KDF)
		 * to generate the key material. By default, the value is <code>null</code>.</p>
		 */
		public function get secretPrepend():ByteArray
		{
			return _secretPrepend;
		}

		/**
		 * @private
		 */
		public function set secretPrepend(value:ByteArray):void
		{
			_secretPrepend = value;
		}
	}
}