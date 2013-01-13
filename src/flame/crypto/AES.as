////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flash.utils.ByteArray;
	
	/**
	 * Performs symmetric encryption and decryption using the Advanced Encryption Standard (AES) algorithm.
	 * This class cannot be inherited.
	 * <p>The AES algorithm is essentially the Rijndael symmetric algorithm with a fixed block size and iteration count.
	 * This class functions the same way as the Rijndael class but limits blocks to 128 bits.</p>
	 * 
	 * @see flame.crypto.Rijndael
	 */
	public final class AES extends SymmetricAlgorithm
	{
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the AES class.
		 */
		public function AES()
		{
			super();
			
			_blockSize = _feedbackSize = 128;
			_keySize = 256;
			
			_legalBlockSizes = new <KeySizes>[ new KeySizes(128, 128, 0) ];
			_legalBlockSizes.fixed = true;
			
			_legalKeySizes = new <KeySizes>[ new KeySizes(128, 256, 64) ];
			_legalKeySizes.fixed = true;
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Creates a symmetric AES decryptor object using the specified key and initialization vector (IV).
		 * 
		 * @param key The secret key to use for the symmetric algorithm.
		 * 
		 * @param iv The initialization vector to use for the symmetric algorithm.
		 * 
		 * @return A symmetric AES decryptor object.
		 */
		public override function createDecryptor(key:ByteArray = null, iv:ByteArray = null):ICryptoTransform
		{
			return createTransform(key, iv, false);
		}
		
		/**
		 * Creates a symmetric AES encryptor object using the specified key and initialization vector (IV).
		 * 
		 * @param key The secret key to use for the symmetric algorithm.
		 * 
		 * @param iv The initialization vector to use for the symmetric algorithm.
		 * 
		 * @return A symmetric AES encryptor object.
		 */
		public override function createEncryptor(key:ByteArray = null, iv:ByteArray = null):ICryptoTransform
		{
			return createTransform(key, iv, true);
		}
		
		/**
		 * Generates a random initialization vector (IV) to use for the algorithm.
		 */
		public override function generateIV():void
		{
			_iv = RandomNumberGenerator.getBytes(_blockSize >> 3);
		}
		
		/**
		 * Generates a random key to use for the algorithm.
		 */
		public override function generateKey():void
		{
			_key = RandomNumberGenerator.getBytes(_keySize >> 3);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets or sets the mode for operation of the symmetric algorithm.
		 * <p>The default is <code>CipherMode.CBC</code>.</p>
		 * <p>The <code>CipherMode.CTS</code> mode is not supported.</p>
		 * See CipherMode enumeration for a description of specific modes.
		 * 
		 * @throws flame.crypto.CryptoError The cipher mode is set to <code>CipherMode.CTS</code>.
		 * 
		 * @see flame.crypto.CipherMode
		 */
		public override function get mode():uint
		{
			return super.mode;
		}
		
		/**
		 * @private
		 */
		public override function set mode(value:uint):void
		{
			if (value == CipherMode.CTS)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidCipherMode"));
			
			super.mode = value;
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Private methods
	    //
	    //--------------------------------------------------------------------------
	    
		private function createTransform(key:ByteArray, iv:ByteArray, useEncryptMode:Boolean):ICryptoTransform
		{
			if (iv != null && iv.length != _blockSize >> 3)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidIVSize"));
			
			if (key != null && !validateKeySize(key.length << 3))
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeySize"));
			
			return new RijndaelTransform(key || super.key, mode, iv || super.iv, blockSize, feedbackSize, padding, useEncryptMode); 
		}
	}
}