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
	 * Represents the abstract base class from which all implementations of asymmetric signature deformatters must inherit.
	 * <p>Asymmetric signature deformatters verify the digital signatures
	 * that are created using implementations of AsymmetricSignatureFormatter.</p>
	 * 
	 * @see flame.crypto.AsymmetricSignatureFormatter
	 */
	public class AsymmetricSignatureDeformatter
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
		 * Initializes a new instance of the AsymmetricSignatureDeformatter class.
		 */
		public function AsymmetricSignatureDeformatter()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * When overridden in a derived class, sets the hash algorithm to use for verifying the signature.
		 * <p>You must set a hash algorithm before calling an implementation of the <code>verifySignature()</code> method.</p>
		 * 
		 * @param hashAlgorithm The class of the hash algorithm to use for verifying the signature.
		 */		
		public function setHashAlgorithm(name:String):void
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		/**
		 * When overridden in a derived class, sets the public key to use for verifying the signature.
		 * <p>You must set a key before calling an implementation of the <code>verifySignature()</code> method.</p>
		 * 
		 * @param key The instance of the implementation of AsymmetricAlgorithm that holds the public key.
		 * 
		 * @see flame.crypto.AsymmetricAlgorithm
		 */
		public function setKey(key:AsymmetricAlgorithm):void
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		/**
		 * When overridden in a derived class, verifies the signature for the specified data.
		 * <p>You must specify a public key and a hash algorithm before calling this method.</p>
		 * 
		 * @param hash The data signed with <code>signature</code>.
		 * 
		 * @param signature The signature to be verified for <code>hash</code>.
		 * 
		 * @return <code>true</code> if <code>signature</code> matches the signature
		 * computed using the specified hash algorithm and key on <code>hash</code>; otherwise, <code>false</code>.
		 */
		public function verifySignature(hash:ByteArray, signature:ByteArray):Boolean
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
	}
}