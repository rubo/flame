////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.utils.ByteArrayUtil;
	
	import flash.utils.ByteArray;
	
	/**
	 * Represents the abstract class from which all implementations of
	 * Hash-based Message Authentication Code (HMAC) must inherit.
	 * <p>A Hash-based Message Authentication Code (HMAC) can be used to determine
	 * whether a message sent over an insecure channel has been tampered with,
	 * provided that the sender and receiver share a secret key.
	 * The sender computes the hash value for the original data
	 * and sends both the original data and the HMAC as a single message.
	 * The receiver recomputes the hash value on the received message
	 * and checks that the computed hash value matches the transmitted hash value.</p>
	 * <p>HMAC can be used with any iterative cryptographic hash function,
	 * such as MD5 or SHA-1, in combination with a secret shared key.
	 * The cryptographic strength of HMAC depends on the properties of the underlying hash function.</p>
	 * <p>Any change to the data or the hash value results in a mismatch,
	 * because knowledge of the secret key is required to change the message and reproduce the correct hash value.
	 * Therefore, if the original and computed hash values match, the message is authenticated.</p>
	 */
	public class HMAC extends KeyedHashAlgorithm
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
		private var _blockSize:int;
		private var _hashAlgorithm1:HashAlgorithm;
		private var _hashAlgorithm2:HashAlgorithm;
		private var _hashName:String;
		private var _inner:ByteArray = new ByteArray();
		private var _isHashing:Boolean;
		private var _outer:ByteArray = new ByteArray();
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the HMAC class.
		 */
		public function HMAC()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creates an instance of the specified implementation of a Hash-based Message Authentication Code (HMAC).
		 * <p>By default, the SHA-1 algorithm is used.</p>
		 * <p>HMAC supports a number of hash algorithms, including MD5, SHA-1, SHA-256, and RIPEMD-160.
		 * For the full list, see the supported values for the <code>algorithmName</code> parameter.</p>
		 * 
		 * @param algorithmName The HMAC implementation to use. The following table shows the valid values
		 * for the <code>algorithmName</code> parameter and the algorithms they map to.
		 * <p><table class="innertable">
		 * <tr><th>Parameter value</th><th>Algorithm implementation</th></tr>
		 * <tr><td>flame.crypto::HMAC</td><td>flame.crypto.HMACSHA1</td></tr>
		 * <tr><td>flame.crypto::KeyedHashAlgorithm</td><td>flame.crypto.HMACSHA1</td></tr>
		 * <tr><td>HMACMD5, HMAC-MD5, flame.crypto::HMACMD5</td><td>flame.crypto.HMACMD5</td></tr>
		 * <tr><td>HMACRIPEMD160, HMAC-RIPEMD160, HMAC-RIPEMD-160, flame.crypto::HMACRIPEMD160</td><td>flame.crypto.HMACRIPEMD160</td></tr>
		 * <tr><td>HMACSHA1, HMAC-SHA1, HMAC-SHA-1, flame.crypto::HMACSHA1</td><td>flame.crypto.HMACSHA1</td></tr>
		 * <tr><td>HMACSHA224, HMAC-SHA224, HMAC-SHA-224, flame.crypto::HMACSHA224</td><td>flame.crypto.HMACSHA224</td></tr>
		 * <tr><td>HMACSHA256, HMAC-SHA256, HMAC-SHA-256, flame.crypto::HMACSHA256</td><td>flame.crypto.HMACSHA256</td></tr>
		 * <tr><td>HMACSHA384, HMAC-SHA384, HMAC-SHA-384, flame.crypto::HMACSHA384</td><td>flame.crypto.HMACSHA384</td></tr>
		 * <tr><td>HMACSHA512, HMAC-SHA512, HMAC-SHA-512, flame.crypto::HMACSHA512</td><td>flame.crypto.HMACSHA512</td></tr>
		 * </table></p>

		 * @return A new instance of the specified HMAC implementation.
		 */
		public static function create(algorithmName:String = "SHA1"):HMAC
		{
			return HMAC(CryptoConfig.createFromName(algorithmName));
		}
		
		/**
		 * Initializes an instance of HMAC. 
		 */		
		public override function initialize():void
		{
			_hashAlgorithm1.initialize();
			_hashAlgorithm2.initialize();
			
			_isHashing = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets the name of the hash algorithm to use for hashing.
		 */
		public function get hashName():String
		{
			return _hashName;
		}
		
		/**
		 * @private
		 */
		public override function set key(value:ByteArray):void
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			if (_isHashing)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "hashKeySet"));
			
			initializeKey(value);
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Protected methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * @inheritDoc
		 */
		protected override function hashCore(inputBuffer:ByteArray, inputOffset:int, inputCount:int):void
		{
			if (!_isHashing)
			{
				_hashAlgorithm1.transformBlock(_inner, 0, _inner.length, _inner, 0);
				
				_isHashing = true;
			}
			
			_hashAlgorithm1.transformBlock(inputBuffer, inputOffset, inputCount, inputBuffer, inputOffset);
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function hashFinal():ByteArray
		{
			if (!_isHashing)
			{
				_hashAlgorithm1.transformBlock(_inner, 0, _inner.length, _inner, 0);
				
				_isHashing = true;
			}
			
			_hashAlgorithm1.transformFinalBlock(new ByteArray(), 0, 0);
			
			var hash:ByteArray = _hashAlgorithm1.hash;
			
			_hashAlgorithm2.transformBlock(_outer, 0, _outer.length, _outer, 0);
			_hashAlgorithm2.transformBlock(hash, 0, hash.length, hash, 0);
			
			_isHashing = false;
			
			_hashAlgorithm2.transformFinalBlock(new ByteArray(), 0, 0);
			
			return _hashAlgorithm2.hash;
		}
		
		/**
		 * Sets the name of the hash algorithm to use for hashing.
		 * 
		 * @param name The name of the hash algorithm.
		 * 
		 * @throws flame.crypto.CryptoError The current hash algorithm cannot be changed. 
		 */
		protected function setHashAlgorithm(name:String):void
		{
			if (_isHashing)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "hashAlgorithmSet"));
			
			_hashName = name;
			_hashAlgorithm1 = HashAlgorithm(CryptoConfig.createFromName(_hashName));
			_hashAlgorithm2 = HashAlgorithm(CryptoConfig.createFromName(_hashName));
			_hashSize = _hashAlgorithm1.hashSize;
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Protected properties
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Gets or sets the block size to use in the hash value.
		 * <p>A Hash-based Message Authentication Code (HMAC) uses a hash function
		 * where data is hashed by iterating a basic compression function on blocks of data.
		 * <code>blockSize</code> is the byte size of such a block. Its value is 64 bytes.</p>
		 */		
		protected function get blockSize():int
		{
			return _blockSize;
		}
		
		/**
		 * @private 
		 */
		protected function set blockSize(value:int):void
		{
			_blockSize = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function initializeKey(key:ByteArray):void
		{
			_key = key.length > _blockSize ? _hashAlgorithm1.computeHash(key) : ByteArrayUtil.copy(key);
			
			_inner.clear();
			_outer.clear();
			
			for (var i:int = 0, count:int = _blockSize; i < count; i++)
			{
				_inner[i] = 0x36;
				_outer[i] = 0x5C;
			}
			
			for (i = 0, count = _key.length; i < count; i++)
			{
				_inner[i] ^= _key[i];
				_outer[i] ^= _key[i];
			}
		}
	}
}