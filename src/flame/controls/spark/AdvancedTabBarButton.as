////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.spark
{
	import flame.controls.TabClosePolicy;
	import flame.controls.events.TabEvent;
	
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElement;
	
	import spark.components.Button;
	import spark.components.ButtonBarButton;
	
	/**
	 * Dispatched when the tab is closed.
	 * 
	 * @eventType flame.controls.events.TabEvent.TAB_CLOSE
	 */
	[Event(name="tabClose", type="flame.controls.events.TabEvent")]
	
	/**
	 * The AdvancedTabBarButton is an enhancment to the standard ButtonBarButton.
	 * It adds an ability to drag-and-drop and to close the tab.
	 * 
	 * @see spark.components.ButtonBarButton
	 */
	public class AdvancedTabBarButton extends ButtonBarButton
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		[SkinPart(required="true")]
		public var closeButton:Button;
		
		[SkinPart(required="true")]
		public var dropIndicator:IVisualElement;
		
		private var _closePolicy:String = TabClosePolicy.NEVER;
		private var _rolledOver:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the AdvancedTabBarButton class.
		 */
		public function AdvancedTabBarButton()
		{
			super();
			
			mouseChildren = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Hides the drop indicator.
		 * 
		 * @param isLeft
		 */
		public function hideDropIndicator():void
		{
			if (dropIndicator != null)
				dropIndicator.visible = false;
		}
		
		/**
		 * Shows the drop indicator for the tab drag-and-drop operation.
		 * 
		 * @param showOnLeft <code>true</code> to show drop indicator on the left side of the target tab; otherwise, <code>false</code>.
		 */
		public function showDropIndicator(showOnLeft:Boolean):void
		{
			if (dropIndicator != null)
			{
				dropIndicator.visible = true;
				
				if (showOnLeft)
					dropIndicator.left = -dropIndicator.width / 2;
				else
					dropIndicator.right = -dropIndicator.width / 2;
				
				dropIndicator.y = -5;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		[Inspectable(category="General", enumeration="always,never,rollOver,selected", defaultValue="never")]
		
		/**
		 * Gets or sets the value that indicates whether the Close button is always present, always absent,
		 * or visible on mouse roll over or on tab select.
		 * 
		 * @see flame.controls.TabClosePolicy
		 */
		public function get closePolicy():String
		{
			return _closePolicy;
		}
		
		/**
		 * @private
		 */
		public function set closePolicy(value:String):void
		{
			_closePolicy = value;
			
			skin.invalidateDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		protected override function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == closeButton)
			{
				closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler);
				closeButton.addEventListener(MouseEvent.MOUSE_DOWN, closeButton_mouseDownHandler);
				closeButton.addEventListener(MouseEvent.MOUSE_UP, closeButton_mouseUpHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == closeButton)
			{
				closeButton.removeEventListener(MouseEvent.CLICK, closeButton_clickHandler);
				closeButton.removeEventListener(MouseEvent.MOUSE_DOWN, closeButton_mouseDownHandler);
				closeButton.removeEventListener(MouseEvent.MOUSE_UP, closeButton_mouseUpHandler);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function closeButton_clickHandler(event:MouseEvent):void
		{
			event.stopPropagation();
			
			dispatchEvent(new TabEvent(TabEvent.TAB_CLOSE, true, false, itemIndex));
		}
		
		private function closeButton_mouseDownHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		private function closeButton_mouseUpHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}
	}
}