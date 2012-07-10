////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.config
{
	/**
	 * The error that is thrown when a configuration error has occurred.
	 */
	public class ConfigError extends Error
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ConfigError class.
		 * 
		 * @param message The error message that explains the reason for the error.
		 * 
		 * @param id A reference number to associate with the specific error message.
		 */
		public function ConfigError(message:* = "", id:* = 0)
		{
			super(message, id);
			
			name = "ConfigError";
		}
	}
}