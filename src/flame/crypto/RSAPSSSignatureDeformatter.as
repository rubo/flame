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
	 * Verifies an RSA PSS signature.
	 * <p>This class is used to verify a digital signature made with the RSA algorithm.
	 * Use RSAPSSSignatureFormatter to create digital signatures with the RSA algorithm.</p>
	 * 
	 * @see flame.crypto.RSAPSSSignatureFormatter
	 */
	public class RSAPSSSignatureDeformatter extends AsymmetricSignatureDeformatter
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
		 * Initializes a new instance of the RSAPSSSignatureDeformatter class.
		 * 
		 * @param key The instance of the RSA algorithm that holds the public key.
		 */
		public function RSAPSSSignatureDeformatter(key:AsymmetricAlgorithm)
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
		 * Verifies the RSA PSS signature for the specified hash.
		 * 
		 * @param hash The hash value of the data signed with <code>signature</code>.
		 * 
		 * @param signature The signature to be verified for <code>hash</code>.
		 * 
		 * @return <code>true</code> if <code>signature</code> matches the signature
		 * computed using the specified hash algorithm and key on <code>hash</code>; otherwise, <code>false</code>.
		 * 
		 * @throws flame.crypto.CryptoError Thrown in the following situations:<ul>
		 * <li>The private key is missing.</li>
		 * <li>The hash algorithm is missing.</li>
		 * </ul>
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>hash</code> parameter is <code>null</code>.</li>
		 * <li><code>signature</code> parameter is <code>null</code>.</li>
		 * </ul>
		 */
		public override function verifySignature(hash:ByteArray, signature:ByteArray):Boolean
		{
			if (_key == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "missingKey"));
			
			if (_hashAlgorithm == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "missingHashAlgorithm"));
			
			if (hash == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "hash" ]));
			
			if (signature == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "signature" ]));
			
			var hashSize:int = _hashAlgorithm.hashSize >> 3;
			var modulusSize:int = _key.keySize >> 3;
			
			if (hashSize + _saltSize + 2 > modulusSize)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "paddingSignatureHashTooLong", [ modulusSize ]));
			
			var buffer:ByteArray = _key.encrypt(signature);
			
			if ((buffer[0] & 0x80) != 0 || buffer[buffer.length - 1] != 188)
				return false;
			
			var db:ByteArray = new ByteArray();
			var hash2:ByteArray = new ByteArray();
			
			buffer.readBytes(db, 0, modulusSize - hashSize - 1);
			buffer.readBytes(hash2, 0, hashSize);
			
			var count:int;
			var i:int;
			var mask:ByteArray = CryptoUtil.generatePKCS1Mask(hash2, db.length, _hashAlgorithm);
			var paddingSize:int = modulusSize - hashSize - _saltSize - 2;
			
			for (i = 0, count = db.length; i < count; i++)
				db[i] ^= mask[i];
			
			db[0] &= 0x7F;
			
			for (i = 0, count = modulusSize - hashSize - _saltSize - 2; i < count; i++)
				if (db[i] != 0)
					return false;
			
			if (db[count] != 1)
				return false;
			
			var salt:ByteArray = new ByteArray();
			
			salt.writeBytes(db, count + 1);
			
			buffer.clear();
			
			buffer.position = 8;
			
			buffer.writeBytes(hash);
			buffer.writeBytes(salt);
			
			buffer = _hashAlgorithm.computeHash(buffer);
			
			for (i = 0, count = buffer.length; i < count; i++)
				if (buffer[i] != hash2[i])
					return false;
			
			return true;
		}
		
		/**
		 * Sets the hash algorithm to use for verifying the signature.
		 * <p>You must set the hash algorithm before calling the <code>verifySignature()</code> method.</p>
		 * 
		 * @param name The name of the hash algorithm to use for verifying the signature.
		 */
		public override function setHashAlgorithm(name:String):void
		{
			_hashAlgorithm = HashAlgorithm(CryptoConfig.createFromName(name));
		}
		
		/**
		 * Sets the public key to use for verifying the signature.
		 * <p>You must set the key before calling the <code>verifySignature()</code> method.</p>
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
		 * Gets or sets the number of bytes of salt to use when verifying a signature.
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