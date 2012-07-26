////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	
	/**
	 * Decrypts Optimal Asymmetric Encryption Padding (OAEP) key exchange data.
	 * <p>Key exchange allows a sender to create secret information, for example,
	 * random data that can be used as a key in a symmetric encryption algorithm,
	 * and use encryption to send it to the intended recipient.</p>
	 * <p>Use RSAOAEPKeyExchangeFormatter to create the key exchange message with the RSA algorithm.</p>
	 * 
	 * @see flame.crypto.RSAOAEPKeyExchangeFormatter
	 */
	public class RSAOAEPKeyExchangeDeformatter extends AsymmetricKeyExchangeDeformatter
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _hashAlgorithm:HashAlgorithm = new SHA1();
		private var _key:RSA;
		private var _label:ByteArray = new ByteArray();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the RSAOAEPKeyExchangeDeformatter class.
		 * 
		 * @param key The instance of the RSA algorithm that holds the private key.
		 */
		public function RSAOAEPKeyExchangeDeformatter(key:AsymmetricAlgorithm = null)
		{
			super();
			
			if (key != null)
				setKey(key);
			
			_label = _hashAlgorithm.computeHash(_label);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Performs direct RSA decryption using OAEP padding.
		 * 
		 * @param data The data to be decrypted.
		 * 
		 * @return The decrypted data, which is the original plain text before encryption.
		 * 
		 * @throws flame.crypto.CryptoError Thrown in the following situations:<ul>
		 * <li>The private key is missing.</li>
		 * <li>The length of the <code>data</code> parameter is greater than <code>keySize</code>.</li>
		 * <li>The padding is invalid and cannot be removed.</li>
		 * </ul>
		 */
		public override function decryptKeyExchange(data:ByteArray):ByteArray
		{
			if (_key == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "missingKey"));
			
			var buffer:ByteArray = _key.decrypt(data);
			var hashSize:int = _hashAlgorithm.hashSize >> 3;
			var modulusSize:int = _key.keySize >> 3;
			
			if ((hashSize << 1) + 2 > modulusSize)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "paddingDecryptDataTooLong", [ modulusSize ]));
			
			var db:ByteArray = new ByteArray();
			var seed:ByteArray = new ByteArray();
			
			seed.writeBytes(buffer, 1, hashSize);
			db.writeBytes(buffer, hashSize + 1);
			
			var count:int;
			var i:int;
			var mask:ByteArray = CryptoUtil.generatePKCS1Mask(db, hashSize, _hashAlgorithm);
			
			for (i = 0, count = seed.length; i < count; i++)
				seed[i] ^= mask[i];
			
			mask = CryptoUtil.generatePKCS1Mask(seed, db.length, _hashAlgorithm);
			
			for (i = 0, count = db.length; i < count; i++)
				db[i] ^= mask[i];
			
			for (i = 0; i < hashSize; i++)
				if (db[i] != _label[i])
					throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidPadding"));
			
			while (db[i] == 0)
				i++;
			
			if (db[i] != 1 || ++i > db.length - 1)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidPadding"));
			
			var output:ByteArray = new ByteArray();
			
			output.writeBytes(db, i);
			
			output.position = 0;
			
			return output;
		}
		
		/**
		 * Sets the private key to use for decrypting the secret information.
		 * <p>You must set the key before calling the <code>decryptKeyExchange()</code> method.</p>
		 * 
		 * @param key The instance of the RSA algorithm that holds the private key.
		 * 
		 * @throws ArgumentError <code>key</code> parameter is <code>null</code>.
		 * 
		 * @see flame.crypto.RSA
		 */
		public override function setKey(key:AsymmetricAlgorithm):void
		{
			if (key == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "key" ]));
			
			_key = RSA(key);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
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
	}
}