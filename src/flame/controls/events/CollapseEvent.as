////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.events
{
	import flash.events.Event;

	/**
	 * The CollapseEvent class represents the event object passed to the event listener
	 * for the <code>flame.controls.events.collapse</code>
	 * and <code>flame.controls.events.expand</code> events. 
	 */
	public class CollapseEvent extends Event
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Defines the value of the <code>type</code> property of the event object
		 * for a <code>flame.controls.mx.events.collapse</code> event.
		 * 
		 * @eventType flame.controls.events.collapse
		 */
	    public static const COLLAPSE:String = "flame.controls.events.collapse";
		
		/**
		 * Defines the value of the <code>type</code> property of the event object
		 * for a <code>flame.controls.mx.events.expand</code> event.
		 * 
		 * @eventType flame.controls.events.expand
		 */
	    public static const EXPAND:String = "flame.controls.events.expand";
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the CollapseEvent class.
		 * 
		 * @param type The event type; indicates the action that caused the event.
		 * 
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
		 * 
		 * @param cancelable Specifies whether the behavior associated with the event can be prevented.
		 */
		public function CollapseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
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
	    	return new CollapseEvent(type, bubbles, cancelable);
	    }
	}
}