////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flash.utils.getQualifiedClassName;

	/**
	 * The error that is thrown when an error occurs during a cryptographic operation.
	 */
	public class CryptoError extends Error
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the CryptoError class.
		 * 
		 * @param message The error message that explains the reason for the error.
		 * 
		 * @param id A reference number to associate with the specific error message.
		 */
		public function CryptoError(message:String = "", id:int = 0)
		{
			super(message, id);
			
			name = getQualifiedClassName(this);
		}		
	}
}