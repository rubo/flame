////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	
	/**
	 * Performs symmetric encryption and decryption using the RC4 algorithm.
	 * This class cannot be inherited.
	 */
	public final class RC4 extends SymmetricAlgorithm
	{
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the RC4 class.
		 */
		public function RC4()
		{
			super();
			
			_blockSize = 1;
			_keySize = 128;
			
			_legalBlockSizes = new <KeySizes>[ new KeySizes(1, 1, 0) ];
			_legalBlockSizes.fixed = true;
			
			_legalKeySizes = new <KeySizes>[ new KeySizes(40, 128, 8) ];
			_legalKeySizes.fixed = true;
			
			_mode = CipherMode.OFB;
			_padding = PaddingMode.NONE;
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Creates a symmetric RC4 decryptor object using the specified key.
		 * 
		 * @param key The secret key to use for the symmetric algorithm.
		 * 
		 * @param iv This parameter is not supported for this algorithm.
		 * 
		 * @return A symmetric RC4 decryptor object.
		 */
		public override function createDecryptor(key:ByteArray = null, iv:ByteArray = null):ICryptoTransform
		{
			return createEncryptor(key);
		}
		
		/**
		 * Creates a symmetric RC4 encryptor object using the specified key.
		 * 
		 * @param key The secret key to use for the symmetric algorithm.
		 * 
		 * @param iv This parameter is not supported for this algorithm.
		 * 
		 * @return A symmetric RC4 encryptor object.
		 */
		public override function createEncryptor(key:ByteArray = null, iv:ByteArray = null):ICryptoTransform
		{
			return new RC4Transform(key || super.key);
		}
		
		/**
		 * This method is not supported for this algorithm.
		 * 
		 * @throws flash.errors.IllegalOperationError The method is not supported.
		 */
		public override function generateIV():void
		{
			throw new IllegalOperationError(_resourceManager.getString("flameLocale", "argNotSupported"));
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
		 * This property is not supported for this algorithm.
		 * 
		 * @throws flash.errors.IllegalOperationError The property is not supported.
		 */
		public override function get feedbackSize():int
		{
			throw new IllegalOperationError(_resourceManager.getString("flameLocale", "argNotSupported"));
		}
		
		/**
		 * @private
		 */
		public override function set feedbackSize(value:int):void
		{
			throw new IllegalOperationError(_resourceManager.getString("flameLocale", "argNotSupported"));
		}
		
		/**
		 * This property is not supported for this algorithm.
		 * 
		 * @throws flash.errors.IllegalOperationError The property is not supported.
		 */
		public override function get iv():ByteArray
		{
			throw new IllegalOperationError(_resourceManager.getString("flameLocale", "argNotSupported"));
		}
		
		/**
		 * @private
		 */
		public override function set iv(value:ByteArray):void
		{
			throw new IllegalOperationError(_resourceManager.getString("flameLocale", "argNotSupported"));
		}
		
		/**
		 * Gets or sets the mode for operation of the symmetric algorithm.
		 * <p>The default is <code>CipherMode.OFB</code>.</p>
		 * See CipherMode enumeration for a description of specific modes.
		 * 
		 * @throws flame.crypto.CryptoError The cipher mode is not supported for this algorithm.
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
			if (value != CipherMode.OFB)
				throw new CryptoError(_resourceManager.getString("flameLocale", "cryptoInvalidCipherMode"));
				
			_mode = value;
		}
		
		/**
		 * Gets or sets the padding mode used in the symmetric algorithm.
		 * <p>The default is <code>PaddingMode.NONE</code>.</p>
		 * See PaddingMode enumeration for a description of specific modes.
		 * 
		 * @throws flame.crypto.CryptoError The padding mode is not supported for this algorithm.
		 * 
		 * @see flame.crypto.PaddingMode
		 */
		public override function get padding():uint
		{
			return super.padding;
		}
		
		/**
		 * @private 
		 */		
		public override function set padding(value:uint):void
		{
			if (value != PaddingMode.NONE)
				throw new CryptoError(_resourceManager.getString("flameLocale", "cryptoInvalidPaddingMode"));
			
			_padding = value;
		}
	}
}