////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.serialization
{
	import flash.utils.getQualifiedClassName;

	/**
	 * The error that is thrown when an error occurs during a JSON deserialization.
	 */
	public class JSONError extends Error
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the JSONError class.
		 * 
		 * @param message The error message that explains the reason for the error.
		 * 
		 * @param id A reference number to associate with the specific error message.
		 */
		public function JSONError(message:* = "", id:* = 0)
		{
			super(message, id);
			
			name = getQualifiedClassName(this);
		}
	}
}