////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.events
{
	import flash.events.Event;
	
	/**
	 * The TabEvent class represents the event object passed to the event listener
	 * for the <code>flame.controls.events.tabClose</code> event. 
	 */
	public class TabEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event object
		 * for a <code>flame.controls.events.tabClose</code> event.
		 * 
		 * @eventType flame.controls.events.tabClose
		 */
		public static const TAB_CLOSE:String = "flame.controls.events.tabClose";
		
		private var _index:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the TabEvent class.
		 * 
		 * @param type The event type; indicates the action that caused the event.
		 * 
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
		 * 
		 * @param cancelable Specifies whether the behavior associated with the event can be prevented.
		 * 
		 * @param index The zero-based index of the tab.
		 */
		public function TabEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, index:int = -1)
		{
			super(type, bubbles, cancelable);
			
			_index = index;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public override function clone():Event
		{
			return new TabEvent(type, bubbles, cancelable, index);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets the zero-based index of the tab.
		 */
		public function get index():int
		{
			return _index;
		}
	}
}