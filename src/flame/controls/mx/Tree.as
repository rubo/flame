////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.mx
{
	import mx.controls.Tree;
	import mx.core.EventPriority;
	import mx.events.ListEvent;

	/**
	 * The Tree is an enhancment to the standard Tree.
	 * It adds an ability to open or close a branch item by double-clicking on it.
	 * 
	 * @see mx.controls.Tree
	 */
	public class Tree extends mx.controls.Tree
	{
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the Tree class.
		 */
		public function Tree()
		{
			super();
			
			addEventListener(ListEvent.ITEM_DOUBLE_CLICK, itemDoubleClickHandler, false, EventPriority.DEFAULT_HANDLER);
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Private methods
	    //
	    //--------------------------------------------------------------------------
		
		private function itemDoubleClickHandler(event:ListEvent):void
		{
			expandItem(selectedItem, !isItemOpen(selectedItem), true, true, event);
		}
	}
}