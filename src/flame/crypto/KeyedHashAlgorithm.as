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
	
	import flash.utils.ByteArray;	
	
	/**
	 * Represents the abstract class from which all implementations of keyed hash algorithms must inherit.
	 * <p>Hash functions map binary strings of an arbitrary length to small binary strings of a fixed length.
	 * A cryptographic hash function has the property that it is computationally infeasible
	 * to find two distinct inputs that hash to the same value.
	 * Small changes to the data result in large, unpredictable changes in the hash.</p>
	 * <p>A keyed hash algorithm is a key-dependent, one-way hash function used as a message authentication code.
	 * Only someone who knows the key can verify the hash.
	 * Keyed hash algorithms provide authenticity without secrecy.</p>
	 * <p>Hash functions are commonly used with digital signatures and for data integrity.
	 * The HMAC class is an example of a keyed hash algorithm.</p>
	 */
	public class KeyedHashAlgorithm extends HashAlgorithm
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
		protected var _key:ByteArray;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the KeyedHashAlgorithm class.
		 */
		public function KeyedHashAlgorithm()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public properties
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Gets or sets the key to use in the hash algorithm.
		 * 
		 * @throws ArgumentError <code>key</code> parameter is <code>null</code>.
		 * 
		 * @throws flame.crypto.CryptoError An attempt is made to change
		 * the <code>key</code> property after hashing has begun.
		 */
		public function get key():ByteArray
		{
			return ByteArrayUtil.copy(_key);
		}
		
		/**
		 * @private 
		 */
		public function set key(value:ByteArray):void
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			if (_state != 0)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "hashKeySet"));
			
			_key = value;
		}
	}
}