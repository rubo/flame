////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flash.utils.ByteArray;

	/**
	 * Creates an RSA PSS signature.
	 * <p>This class is used to create a digital signature using the RSA algorithm.
	 * Use RSAPSSSignatureDeformatter to verify digital signatures with the RSA algorithm.</p>
	 * 
	 * @see flame.crypto.RSAPSSSignatureDeformatter
	 */
	public class RSAPSSSignatureFormatter extends AsymmetricSignatureFormatter
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _hashAlgorithm:HashAlgorithm;
		private var _key:RSA;
		private var _saltSize:int = 20;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the RSAPSSSignatureFormatter class.
		 * 
		 * @param key The instance of the RSA algorithm that holds the private key.
		 */
		public function RSAPSSSignatureFormatter(key:AsymmetricAlgorithm)
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
		 * Creates the RSA PSS signature for the specified hash.
		 * <p>You must specify a key and a hash algorithm before calling this method.</p>
		 * 
		 * @param hash The hash value of the data to be signed.
		 * 
		 * @return The digital signature for <code>hash</code>.
		 * 
		 * @throws flame.crypto.CryptoError Thrown in the following situations:<ul>
		 * <li>The private key is missing.</li>
		 * <li>The hash algorithm is missing.</li>
		 * </ul>
		 * 
		 * @throws ArgumentError <code>hash</code> parameter is <code>null</code>.
		 */
		public override function createSignature(hash:ByteArray):ByteArray
		{
			if (_key == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "missingKey"));
			
			if (_hashAlgorithm == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "missingHashAlgorithm"));
			
			if (hash == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "hash" ]));
			
			var hashSize:int = _hashAlgorithm.hashSize >> 3;
			var modulusSize:int = _key.keySize >> 3;
			
			if (hashSize + _saltSize + 2 > modulusSize)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "paddingSignatureHashTooLong", [ modulusSize ]));
			
			var hash2:ByteArray = new ByteArray();
			var salt:ByteArray = RandomNumberGenerator.getBytes(_saltSize);
			
			hash2.position = 8;
			
			hash2.writeBytes(hash);
			hash2.writeBytes(salt);
			
			hash2 = _hashAlgorithm.computeHash(hash2);
			
			var db:ByteArray = new ByteArray();
			
			db.position = modulusSize - hashSize - _saltSize - 2;
			
			db.writeByte(1);
			db.writeBytes(salt);
			
			var mask:ByteArray = CryptoUtil.generatePKCS1Mask(hash2, db.length, _hashAlgorithm);
			
			for (var i:int = 0, count:int = db.length; i < count; i++)
				db[i] ^= mask[i];
			
			var buffer:ByteArray = new ByteArray();
			
			buffer.writeBytes(db);
			buffer.writeBytes(hash2);
			buffer.writeByte(188);
			
			buffer[0] &= 0x7F;
			
			return _key.decrypt(buffer);
		}
		
		/**
		 * Sets the hash algorithm to use for creating the signature.
		 * <p>You must set the hash algorithm before calling the <code>createSignature()</code> method.</p>
		 * 
		 * @param name The name of the hash algorithm to use for creating the signature.
		 */
		public override function setHashAlgorithm(name:String):void
		{
			_hashAlgorithm = HashAlgorithm(CryptoConfig.createFromName(name));
		}
		
		/**
		 * Sets the private key to use for creating the signature.
		 * <p>You must set the key before calling the <code>createSignature()</code> method.</p>
		 * 
		 * @param key The instance of the RSA algorithm that holds the public key.
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
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets or sets the number of bytes of salt to use when signing data.
		 * <p>The default value is 20.</p>
		 * 
		 * @throws RangeError <code>value</code> parameter is less than zero.
		 */
		public function get saltSize():int
		{
			return _saltSize;
		}
		
		/**
		 * @private
		 */
		public function set saltSize(value:int):void
		{
			if (value < 0)
				throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeNonNegative", [ "count" ]));
			
			_saltSize = value;
		}
	}
}