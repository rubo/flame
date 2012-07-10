////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	/**
	 * Determines the set of valid key sizes for the symmetric cryptographic algorithms.
	 */
	public class KeySizes
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
		
		private var _maxSize:int;
		private var _minSize:int;
		private var _skipSize:int;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the KeySizes class with the specified key values.
		 *  
		 * @param minSize The minimum valid key size.
		 * 
		 * @param maxSize The maximum valid key size.
		 * 
		 * @param skipSize The interval between valid key sizes.
		 */
		public function KeySizes(minSize:int, maxSize:int, skipSize:int)
		{
			super();
			
			_maxSize = maxSize;
			_minSize = minSize;
			_skipSize = skipSize;
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public properties
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Specifies the maximum key size in bits. 
		 */
	    public function get maxSize():int
	    {
	    	return _maxSize;
	    }
	    
		/**
		 * Specifies the minimum key size in bits.
		 */
	    public function get minSize():int
	    {
	    	return _minSize;
	    }
	    
		/**
		 * Specifies the interval between valid key sizes in bits.
		 */
	    public function get skipSize():int
	    {
	    	return _skipSize;
	    }
	}
}