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
	 * Performs symmetric encryption and decryption using the Rijndael algorithm.
	 * This class cannot be inherited.
	 * <p>This algorithm supports key lengths of 128, 192, or 256 bits.</p>
	 */
	public final class Rijndael extends SymmetricAlgorithm
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the Rijndael class. 
		 */
		public function Rijndael()
		{
			super();
			
			_keySize = _feedbackSize = _blockSize = 128;
			
			_legalBlockSizes = new Vector.<KeySizes>(1, true);
			_legalBlockSizes[0] = new KeySizes(128, 256, 64);
			
			_legalKeySizes = new Vector.<KeySizes>(1, true);
			_legalKeySizes[0] = new KeySizes(128, 256, 64);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creates a symmetric Rijndael decryptor object using the specified key and initialization vector (IV).
		 * 
		 * @param key The secret key to use for the symmetric algorithm.
		 * 
		 * @param iv The initialization vector to use for the symmetric algorithm.
		 * 
		 * @return A symmetric Rijndael decryptor object.
		 */
		public override function createDecryptor(key:ByteArray = null, iv:ByteArray = null):ICryptoTransform
		{
			return createTransform(key, iv, false);
		}
		
		/**
		 * Creates a symmetric Rijndael encryptor object using the specified key and initialization vector (IV).
		 * 
		 * @param key The secret key to use for the symmetric algorithm.
		 * 
		 * @param iv The initialization vector to use for the symmetric algorithm.
		 * 
		 * @return A symmetric Rijndael encryptor object.
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
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function createTransform(key:ByteArray, iv:ByteArray, useEncryptMode:Boolean):ICryptoTransform
		{
			return new RijndaelTransform(key || super.key, mode, iv || super.iv, blockSize, feedbackSize, padding, useEncryptMode); 
		}
	}
}