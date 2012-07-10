////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.spark
{
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.Panel;

	/**
	 * Collapsed state of the CollapsiblePanel.
	 */
	[SkinState("collapsed")]
	
	/**
	 * The CollapsiblePanel is a panel that can store content in a compact space.
	 * The content is collapsed or expanded by clicking the header of the control.
	 * 
	 * @see spark.components.Panel
	 */
	public class CollapsiblePanel extends Panel
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		[SkinPart(required="false")]
		public var collapseButton:Button;
		
		private var _collapsed:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the CollapsiblePanel class.
		 */
		public function CollapsiblePanel()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		[Bindable]
		[Inspectable(category="General", enumeration="false,true", defaultValue="false")]
		
		/**
		 * Gets or sets the value that indicates whether the content is collapsed.
		 */
		public function get collapsed():Boolean
		{
			return _collapsed;
		}
		
		/**
		 * @private
		 */
		public function set collapsed(value:Boolean):void
		{
			_collapsed = value;
			
			invalidateSkinState();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inhertiDoc 
		 */
		protected override function getCurrentSkinState():String
		{
			return _collapsed ? "collapsed" : super.getCurrentSkinState();
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == collapseButton)
				collapseButton.addEventListener(MouseEvent.CLICK, collapseButton_clickHandler);
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == collapseButton)
				collapseButton.removeEventListener(MouseEvent.CLICK, collapseButton_clickHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function collapseButton_clickHandler(event:MouseEvent):void
		{
			collapsed = !collapsed;
		}
	}
}