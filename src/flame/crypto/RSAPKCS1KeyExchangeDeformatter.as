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
	 * Decrypts the PKCS #1 key exchange data using RSA.
	 * <p>Key exchange allows a sender to create secret information, for example,
	 * random data that can be used as a key in a symmetric encryption algorithm,
	 * and use encryption to send it to the intended recipient.</p>
	 * <p>Use RSAPKCS1KeyExchangeFormatter to create the key exchange message using the RSA algorithm.</p>
	 * 
	 * @see flame.crypto.RSAPKCS1KeyExchangeFormatter
	 */
	public class RSAPKCS1KeyExchangeDeformatter extends AsymmetricKeyExchangeDeformatter
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
		 * Initializes a new instance of the RSAPKCS1KeyExchangeDeformatter class.
		 * 
		 * @param key The instance of the RSA algorithm that holds the private key.
		 */
		public function RSAPKCS1KeyExchangeDeformatter(key:AsymmetricAlgorithm = null)
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
		 * Performs direct RSA decryption using PKCS #1 v.15 padding.
		 * 
		 * @param data The data to be decrypted.
		 * 
		 * @return The decrypted data, which is the original plain text before encryption.
		 * 
		 * @throws flame.crypto.CryptoError Thrown in the following situations:<ul>
		 * <li>The private key is missing.</li>
		 * <li>The padding is invalid and cannot be removed.</li>
		 * </ul>
		 */
		public override function decryptKeyExchange(data:ByteArray):ByteArray
		{
			if (_key == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "missingKey"));
			
			var buffer:ByteArray = _key.decrypt(data);
			
			if (buffer[0] == 0 && buffer[1] == 2)
			{
				var i:int = 2;
				var count:int = buffer.length;
				
				while (i < count && buffer[i] != 0)
					i++;
				
				if (i < 10 || i == count)
					throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidPadding"));
				
				var output:ByteArray = new ByteArray();
				
				output.writeBytes(buffer, i + 1);
				
				output.position = 0;
				
				return output;
			}
			
			throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidPadding"));
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