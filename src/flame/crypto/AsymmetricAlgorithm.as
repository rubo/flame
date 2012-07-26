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
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	[ResourceBundle("flameCore")]
	[ResourceBundle("flameCrypto")]
	
	/**
	 * Represents the abstract base class from which all implementations of asymmetric algorithms must inherit.
	 */
	public class AsymmetricAlgorithm
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
		 * Represents the size, in bits, of the key modulus used by the asymmetric algorithm.
		 */
	    protected var _keySize:int;
		
		/**
		 * Specifies the key sizes that are supported by the asymmetric algorithm. 
		 */
	    protected var _legalKeySizes:Vector.<KeySizes>;
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the AsymmetricAlgorithm class.
		 */
		public function AsymmetricAlgorithm()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * When overridden in a derived class, reconstructs an AsymmetricAlgorithm object from an XML string.
		 *  
		 * @param value The XML string to use to reconstruct the AsymmetricAlgorithm object.
		 */
	    public function fromXMLString(value:String):void
	    {
	    	throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
	    }
	    
		/**
		 * When overridden in a derived class, creates and returns an XML string representation
		 * of the current AsymmetricAlgorithm object.
		 * 
		 * @param includePrivateParameters <code>true</code> to include private parameters; otherwise, <code>false</code>.
		 * 
		 * @return An XML string encoding of the current AsymmetricAlgorithm object.
		 */
	    public function toXMLString(includePrivateParameters:Boolean):String
	    {
	    	throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
	    }
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Public properties
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Gets or sets the size, in bits, of the key modulus used by the asymmetric algorithm.
		 * <p>The valid key sizes are specified by the particular implementation of the asymmetric algorithm
		 * and are listed in the <code>legalKeySizes</code> property.</p>
		 */
	    public function get keySize():int
		{
			return _keySize;
		}
		
		/**
		 * Gets the key sizes that are supported by the asymmetric algorithm.
		 * <p>The asymmetric algorithm supports only key sizes that match an entry in this array.</p>
		 */
		public function get legalKeySizes():Vector.<KeySizes>
		{
			return _legalKeySizes.slice();
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Protected methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Determines whether the specified key size is valid for the current algorithm.
		 * 
		 * @param value The length, in bits, to check for a valid key size.
		 * 
		 * @return <code>true</code> if the specified key size is valid for the current algorithm;
		 * otherwise, <code>false</code>.
		 */
	    protected function validateKeySize(value:int):Boolean
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
	}
}