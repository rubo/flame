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
	
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	[ResourceBundle("flameCore")]
	[ResourceBundle("flameCrypto")]
	
	/**
	 * Represents the abstract base class from which all implementations of symmetric algorithms must inherit.
	 * <p>The classes that derive from the SymmetricAlgorithm class
	 * use a chaining mode called cipher block chaining (CBC),
	 * which requires a key (<code>key</code>) and an initialization vector (<code>iv</code>)
	 * to perform cryptographic transformations on data.
	 * To decrypt data that was encrypted using one of the SymmetricAlgorithm classes,
	 * you must set the <code>key</code> property and the <code>iv</code> property to the same values
	 * that were used for encryption. For a symmetric algorithm to be useful,
	 * the secret key must be known only to the sender and the receiver.</p>
	 */
	public class SymmetricAlgorithm
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * A reference to the IResourceManager object which manages all of the localized resources.
		 * 
		 * @see mx.resources.IResourceManager
		 */
		protected static var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		/**
		 * Represents the block size, in bits, of the cryptographic operation.
		 */
		protected var _blockSize:int;
		
		/**
		 * Represents the feedback size, in bits, of the cryptographic operation.
		 */
		protected var _feedbackSize:int;
		
		/**
		 * Represents the initialization vector (IV) for the symmetric algorithm.
		 */
		protected var _iv:ByteArray;
		
		/**
		 * Represents the secret key for the symmetric algorithm.
		 */
		protected var _key:ByteArray;
		
		/**
		 * Represents the size, in bits, of the secret key used by the symmetric algorithm.
		 */
		protected var _keySize:int;
		
		/**
		 * Specifies the block sizes, in bits, that are supported by the symmetric algorithm.
		 */
		protected var _legalBlockSizes:Vector.<KeySizes>;
		
		/**
		 * Specifies the key sizes, in bits, that are supported by the symmetric algorithm.
		 */
		protected var _legalKeySizes:Vector.<KeySizes>;
		
		/**
		 *  Represents the cipher mode used in the symmetric algorithm.
		 */
		protected var _mode:uint = CipherMode.CBC;
		
		/**
		 * Represents the padding mode used in the symmetric algorithm.
		 */
		protected var _padding:uint = PaddingMode.PKCS7;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the SymmetricAlgorithm class.
		 */
		public function SymmetricAlgorithm()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * When overridden in a derived class, creates a symmetric decryptor object
		 * with the specified <code>key</code> property and initialization vector (<code>iv</code>).
		 *  
		 * @param key The secret key to use for the symmetric algorithm.
		 * 
		 * @param iv The initialization vector to use for the symmetric algorithm.
		 * 
		 * @return A symmetric decryptor object.
		 */
		public function createDecryptor(key:ByteArray = null, iv:ByteArray = null):ICryptoTransform
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		/**
		 * When overridden in a derived class, creates a symmetric encryptor object
		 * with the specified <code>key</code> property and initialization vector (<code>iv</code>).
		 * 
		 * @param key The secret key to use for the symmetric algorithm.
		 * 
		 * @param iv The initialization vector to use for the symmetric algorithm.
		 * 
		 * @return A symmetric encryptor object.
		 */
		public function createEncryptor(key:ByteArray = null, iv:ByteArray = null):ICryptoTransform
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		/**
		 * When overridden in a derived class, generates a random initialization vector (<code>iv</code>)
		 * to use for the algorithm.
		 * <p>Use this method to generate a random initialization vector when none is specified.</p>
		 */
		public function generateIV():void
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		/**
		 * When overridden in a derived class, generates a random key (<code>key</code>) to use for the algorithm.
		 * <p>Use this method to generate a random key when none is specified.</p>
		 */
		public function generateKey():void
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		/**
		 * Determines whether the specified key size is valid for the current algorithm.
		 * 
		 * @param value The length, in bits, to check for a valid key size.
		 * 
		 * @return <code>true</code> if the specified key size is valid for the current algorithm;
		 * otherwise, <code>false</code>.
		 */
		public function validateKeySize(value:int):Boolean
		{
			for (var i:int = 0, count:int = _legalKeySizes.length; i < count; i++)
	    		if (_legalKeySizes[i].skipSize == 0)
	    		{
	    			if (value == _legalKeySizes[i].minSize)
	    				return true;
	    		}
	    		else
	    		{
	    			var maxSize:int = _legalKeySizes[i].maxSize;
					var minSize:int = _legalKeySizes[i].minSize;
	    			var skipSize:int = _legalKeySizes[i].skipSize;
	    			
	    			for (var j:int = minSize; j <= maxSize; j += skipSize)
	    				if (value == j)
	    					return true;
	    		}
	    	
	    	return false;
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public properties
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Gets or sets the block size, in bits, of the cryptographic operation.
		 * <p>The block size is the basic unit of data that can be encrypted or decrypted in one operation.
		 * Messages longer than the block size are handled as successive blocks;
		 * messages shorter than the block size must be padded with extra bits to reach the size of a block.
		 * Valid block sizes are determined by the symmetric algorithm used.</p>
		 */
		public function get blockSize():int
		{
			return _blockSize;
		}
		
		/**
		 * @private
		 */
		public function set blockSize(value:int):void
		{
			for (var i:int = 0, count:int = _legalBlockSizes.length; i < count; i++)
				if (_legalBlockSizes[i].skipSize == 0)
				{
					if (value == _legalBlockSizes[i].minSize)
					{
						_blockSize = value;
						_iv = null;
						
						return;
					}
				}
				else
				{
					var maxSize:int = _legalBlockSizes[i].maxSize;
					var minSize:int = _legalBlockSizes[i].minSize;
					var skipSize:int = _legalBlockSizes[i].skipSize;
					
					for (var j:int = minSize; j <= maxSize; j += skipSize)
						if (value == j)
						{
							if (_blockSize != value)
							{
								_blockSize = value;
								_iv = null;
							}
							
							return;
						}
				}
				
			throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidBlockSize"));
		}
		
		/**
		 * Gets or sets the feedback size, in bits, of the cryptographic operation.
		 * <p>The feedback size determines the amount of data that is fed back
		 * to successive encryption or decryption operations.
		 * The feedback size cannot be greater than the block size.</p>
		 * 
		 * @throws flame.crypto.CryptoError The feedback size is larger than the block size.
		 */
		public function get feedbackSize():int
		{
			return _feedbackSize;
		}
		
		/**
		 * @private
		 */
		public function set feedbackSize(value:int):void
		{
			if (value > _blockSize || value % 8 != 0)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidFeedbackSize"));
			
			_feedbackSize = value;
		}
		
		/**
		 * Gets or sets the initialization vector (IV) for the symmetric algorithm.
		 * <p>The <code>iv</code> property is automatically set to a new random value
		 * whenever you create a new instance of one of the SymmetricAlgorithm classes
		 * or when you manually call the <code>generateIV()</code> method.
		 * The size of the <code>iv</code> property must be the same as the <code>blockSize</code> property.</p>
		 * <p>The classes that derive from the SymmetricAlgorithm class
		 * use a chaining mode called cipher block chaining (CBC),
		 * which requires a key and an initialization vector to perform cryptographic transformations on data.
		 * To decrypt data that was encrypted using one of the SymmetricAlgorithm classes,
		 * you must set the <code>key</code> property and <code>iv</code> property to the same values
		 * that were used for encryption.</p>
		 * <p>For a given secret key k, a simple block cipher that does not use an initialization vector will encrypt
		 * the same input block of plain text into the same output block of cipher text.
		 * If you have duplicate blocks within your plain text stream,
		 * you will have duplicate blocks within your cipher text stream.
		 * If unauthorized users know anything about the structure of a block of your plain text,
		 * they can use that information to decipher the known cipher text block and possibly recover your key.
		 * To combat this problem, information from the previous block is mixed into the process of encrypting the next block.
		 * Thus, the output of two identical plain text blocks is different.
		 * Because this technique uses the previous block to encrypt the next block,
		 * an initialization vector is needed to encrypt the first block of data.</p>
		 * 
		 * @throws ArgumentError An attempt was made to set the initialization vector to <code>null</code>.
		 * 
		 * @throws flame.crypto.CryptoError An attempt was made to set the initialization vector to an invalid size.
		 */		
		public function get iv():ByteArray
		{
			if (_iv == null)
				generateIV();
				
			return ByteArrayUtil.copy(_iv);
		}
		
		/**
		 * @private
		 */
		public function set iv(value:ByteArray):void
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			if (value.length != _blockSize >> 3)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidIVSize"));
			
			_iv = ByteArrayUtil.copy(value);
		}
		
		/**
		 * Gets or sets the secret key for the symmetric algorithm.
		 * <p>The secret key is used both for encryption and for decryption.
		 * For a symmetric algorithm to be successful, the secret key must be known only to the sender and the receiver.
		 * The valid key sizes are specified by the particular symmetric algorithm implementation
		 * and are listed in the <code>legalKeySizes</code> property.</p>
		 * <p>If this property is null when it is used,
		 * the <code>generateKey()</code> method is called to create a new random value.</p>
		 * 
		 * @throws ArgumentError An attempt was made to set the key to <code>null</code>.
		 * 
		 * @throws flame.crypto.CryptoError The key size is invalid.
		 */		
		public function get key():ByteArray
		{
			if (_key == null)
				generateKey();
			
			return ByteArrayUtil.copy(_key);
		}
		
		/**
		 * @private
		 */
		public function set key(value:ByteArray):void
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			if (!validateKeySize(value.length << 3))
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeySize"));
				
			_key = ByteArrayUtil.copy(value);
			_keySize = value.length << 3;
		}
		
		/**
		 * Gets or sets the size, in bits, of the secret key used by the symmetric algorithm.
		 * <p>The valid key sizes are specified by the particular symmetric algorithm implementation
		 * and are listed in the <code>legalKeySizes</code> property.</p>
		 */
		public function get keySize():int
		{
			return _keySize;
		}
		
		/**
		 * @private
		 */
		public function set keySize(value:int):void
		{
			if (!validateKeySize(value))
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeySize"));
				
			_keySize = value;
		}
		
		/**
		 * Gets the block sizes, in bits, that are supported by the symmetric algorithm.
		 * <p>The symmetric algorithm supports only block sizes that match an entry in this array.</p>
		 */
		public function get legalBlockSizes():Vector.<KeySizes>
		{
			return _legalBlockSizes.slice();
		}
		
		/**
		 * Gets the key sizes, in bits, that are supported by the symmetric algorithm.
		 * <p>The symmetric algorithm supports only key sizes that match an entry in this array.</p>
		 */
		public function get legalKeySizes():Vector.<KeySizes>
		{
			return _legalKeySizes.slice();
		}
		
		/**
		 * Gets or sets the mode for operation of the symmetric algorithm.
		 * <p>The default is <code>CipherMode.CBC</code>.</p>
		 * See CipherMode enumeration for a description of specific modes.
		 * 
		 * @throws flame.crypto.CryptoError The cipher mode is not one of the CipherMode values.
		 * 
		 * @see flame.crypto.CipherMode
		 */		
		public function get mode():uint
		{
			return _mode;
		}
		
		/**
		 * @private
		 */
		public function set mode(value:uint):void
		{
			if (value < CipherMode.CBC || value > CipherMode.CTR)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidCipherMode"));
			
			_mode = value;
		}
		
		/**
		 * Gets or sets the padding mode used in the symmetric algorithm.
		 * <p>The default is <code>PaddingMode.PKCS7</code>.</p>
		 * <p>Most plain text messages do not consist of a number of bytes that completely fill blocks.
		 * Often, there are not enough bytes to fill the last block. When this happens,
		 * a padding string is added to the text. For example, if the block length is 64 bits
		 * and the last block contains only 40 bits, 24 bits of padding are added.
		 * See the PaddingMode enumeration for a description of specific modes.</p>
		 * 
		 * @throws flame.crypto.CryptoError The padding mode is not one of the PaddingMode values.
		 * 
		 * @see flame.crypto.PaddingMode
		 */		
		public function get padding():uint
		{
			return _padding;
		}
		
		/**
		 * @private
		 */
		public function set padding(value:uint):void
		{
			if (value < PaddingMode.NONE || value > PaddingMode.ISO10126)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidPaddingMode"));
			
			_padding = value;
		}
	}
}