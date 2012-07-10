////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.serialization
{
	/**
	 * Represents a JSON token with a specific type and value. 
	 */
	internal final class JSONToken
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _type:uint;
		private var _value:*;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the JSONToken class.
		 * 
		 * @param type The type of the token.
		 * 
		 * @param value Tha value of the token.
		 */
		public function JSONToken(type:uint, value:*)
		{
			super();
			
			_type = type;
			_value = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal properties
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		internal function get type():uint
		{
			return _type;
		}

		/**
		 * @private
		 */
		internal function get value():*
		{
			return _value;
		}
	}
}