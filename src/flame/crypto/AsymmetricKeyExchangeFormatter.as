////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	[ResourceBundle("flameCore")]
	
	/**
	 * Represents the base class from which all asymmetric key exchange formatters must inherit.
	 * <p>Asymmetric key exchange formatters encrypt key exchange data.
	 * Key exchange allows a sender to create secret information,
	 * such as random data that can be used as a key in a symmetric encryption algorithm,
	 * and use encryption to send it to the intended recipient.</p>
	 */
	public class AsymmetricKeyExchangeFormatter
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
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the AsymmetricKeyExchangeFormatter class.
		 */
		public function AsymmetricKeyExchangeFormatter()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * When overridden in a derived class, creates the encrypted key exchange data from the specified input data.
		 * 
		 * @param data The secret information to be passed in the key exchange.
		 * 
		 * @return The encrypted key exchange data to be sent to the intended recipient.
		 */
		public function createKeyExchange(data:ByteArray):ByteArray
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		/**
		 * When overridden in a derived class, sets the public key to use for encrypting the secret information.
		 * <p>You must set a key before calling an implementation of the <code>createKeyExchange()</code> method.</p>
		 * 
		 * @param key The instance of the implementation of AsymmetricAlgorithm that holds the public key.
		 * 
		 * @see flame.crypto.AsymmetricAlgorithm
		 */
		public function setKey(key:AsymmetricAlgorithm):void
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * When overridden in a derived class, gets or sets the parameters for the asymmetric key exchange.
		 */
		public function get parameters():String
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		/**
		 * @private
		 */
		public function set parameters(value:String):void
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
	}
}