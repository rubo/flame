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
	 * Creates the PKCS #1 key exchange data using RSA.
	 * <p>Key exchange allows a sender to create secret information, for example,
	 * random data that can be used as a key in a symmetric encryption algorithm,
	 * and use encryption to send it to the intended recipient.</p>
	 * <p>Use RSAPKCS1KeyExchangeDeformatter to receive the key exchange and extract the secret information from it.</p>
	 * 
	 * @see flame.crypto.RSAPKCS1KeyExchangeDeformatter
	 */
	public class RSAPKCS1KeyExchangeFormatter extends AsymmetricKeyExchangeFormatter
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _key:RSA;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the RSAPKCS1KeyExchangeFormatter class.
		 * 
		 * @param key The instance of the RSA algorithm that holds the public key.
		 */
		public function RSAPKCS1KeyExchangeFormatter(key:AsymmetricAlgorithm = null)
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
		 * Performs direct RSA encryption using PKCS #1 v1.5 padding.
		 * 
		 * @param data The data to be encrypted.
		 * 
		 * @return The encrypted data.
		 * 
		 * @throws flame.crypto.CryptoError Thrown in the following situations:<ul>
		 * <li>The private key is missing.</li>
		 * <li>The length of the <code>data</code> parameter is greater than the maximum allowed length.</li>
		 * </ul>
		 * 
		 * @throws ArgumentError <code>data</code> parameter is <code>null</code>.
		 */
		public override function createKeyExchange(data:ByteArray):ByteArray
		{
			if (_key == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "missingKey"));
			
			if (data == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "data" ]));
			
			var modulusSize:int = _key.keySize >> 3;
			
			if (data.length + 11 > modulusSize)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "paddingEncryptDataTooLong", [ modulusSize ]));
			
			var buffer:ByteArray = new ByteArray();
			
			buffer.writeByte(0);
			buffer.writeByte(2);
			buffer.writeBytes(RandomNumberGenerator.getNonZeroBytes(modulusSize - data.length - 3));
			buffer.writeByte(0);
			buffer.writeBytes(data);
			
			return _key.encrypt(buffer);
		}
		
		/**
		 * Sets the public key to use for encrypting the key exchange data.
		 * <p>You must set the key before calling the <code>createKeyExchange()</code> method.</p>
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
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * This property is not supported for this formatter.
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