////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.validators
{
	/**
	 * Defines the properties that objects that participate in validation must implement.
	 */
	public interface IBindableValidator
	{
		//--------------------------------------------------------------------------
	    //
	    //  Properties
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Gets or sets a value that indicates whether the associated source passes validation.
		 */
		function get isValid():Boolean;
		
		/**
		 * Gets or sets the description for the associated source.
		 */
		function get sourceDescription():String;
		
		/**
		 * @private
		 */
		function set sourceDescription(value:String):void;
	}
}