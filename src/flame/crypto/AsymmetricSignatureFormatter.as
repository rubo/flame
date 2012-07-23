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
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	[ResourceBundle("flameCore")]
	
	/**
	 * Represents the base class from which all implementations of asymmetric signature formatters must inherit.
	 * <p>Asymmetric signature formatters create digital signatures
	 * that are verified using implementations of AsymmetricSignatureDeformatter.</p>
	 * 
	 * @see flame.crypto.AsymmetricSignatureDeformatter
	 */
	public class AsymmetricSignatureFormatter
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
		 * Initializes a new instance of the AsymmetricSignatureFormatter class.
		 */
		public function AsymmetricSignatureFormatter()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * When overridden in a derived class, creates the signature for the specified data.
		 * <p>You must specify a key and a hash algorithm before calling this method.</p>
		 * 
		 * @param hash The data to be signed.
		 * 
		 * @return The digital signature for the <code>hash</code> parameter.
		 */
		public function createSignature(hash:ByteArray):ByteArray
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		/**
		 * When overridden in a derived class, sets the hash algorithm to use for creating the signature.
		 * <p>You must set a hash algorithm before calling an implementation of the <code>createSignature()</code> method.</p>
		 * 
		 * @param hashAlgorithm The class of the hash algorithm to use for creating the signature.
		 */		
		public function setHashAlgorithm(name:String):void
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		/**
		 * When overridden in a derived class, sets the asymmetric algorithm to use to create the signature.
		 * <p>You must set a key before calling an implementation of the <code>createSignature()</code> method.</p>
		 * 
		 * @param key The instance of the implementation of AsymmetricAlgorithm to use to create the signature.
		 * 
		 * @see flame.crypto.AsymmetricAlgorithm
		 */
		public function setKey(key:AsymmetricAlgorithm):void
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
	}
}