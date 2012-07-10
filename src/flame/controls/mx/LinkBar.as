////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.mx
{
	import mx.controls.LinkBar;
	import mx.core.ClassFactory;
	import mx.core.mx_internal;
	
	/**
	 * The LinkBar is an enhancment to the standard LinkBar.
	 * It adds an ability to specify a text decoration of the label as the user moves the mouse pointer over the button.
	 * 
	 * @see mx.controls.LinkBar
	 */
	public class LinkBar extends mx.controls.LinkBar
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the LinkBar class.
		 */
		public function LinkBar()
		{
			super();
			
			mx_internal::navItemFactory = new ClassFactory(LinkButton);
		}
	}
}