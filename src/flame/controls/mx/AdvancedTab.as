////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.mx
{
	import flame.controls.TabClosePolicy;
	import flame.controls.events.TabEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.controls.tabBarClasses.Tab;
	
	/**
	 * Dispatched when the tab is closed.
	 * 
	 * @eventType flame.controls.mx.events.AdvancedTabEvent.TAB_CLOSE
	 */
	[Event(name="tabClose", type="flame.controls.events.TabEvent")]
	
	/**
	 * Height of the Close button, in pixels.
	 * 
	 * @default 11
	 */
	[Style(name="closeButtonHeight", type="Number", format="Length", inherit="no")]
	
	/**
	 * Width of the Close button, in pixels.
	 * 
	 * @default 11
	 */
	[Style(name="closeButtonWidth", type="Number", format="Length", inherit="no")]
	
	/**
	 * Name of CSS style declaration that specifies style for the Close button.
	 * 
	 * @default undefined
	 */
	[Style(name="buttonStyleName", type="String", inherit="no")]
	
	/**
	 * Name of the class to use as the skin for the drop indicator.
	 * 
	 * <p>The default value is the "tabDropIndicator" symbol in the assets.swf file.</p>
	 */
	[Style(name="dropIndicator", type="String", inherit="no")]
	
	/**
	 * The AdvancedTab is an enhancment to the standard Tab.
	 * It adds an ability to drag-and-drop and to close the tab.
	 * 
	 * @see mx.controls.tabBarClasses.Tab
	 */
	public class AdvancedTab extends Tab
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Represents the Close button. 
		 */
		protected var _closeButton:Button;
		
		/**
		 * Represents the name of style used to specify the height of the Close button. 
		 */
		protected var _closeButtonHeightProp:String = "closeButtonHeight";
		
		/**
		 * Represents the name of style used to specify the width of the Close button. 
		 */
		protected var _closeButtonWidthProp:String = "closeButtonWidth";
		
		/**
		 * Represents the name of style used to specify the Close button. 
		 */
		protected var _closeButtonStyleNameProp:String = "closeButtonStyleName";
		
		/**
		 * Represents the drop indicator. 
		 */
		protected var _dropIndicator:DisplayObject;
		
		/**
		 * Represents the name of style used to specify the drop indicator. 
		 */
		protected var _dropIndicatorProp:String = "dropIndicator";
		
		/**
		 * Indicates whether <code>dropIndicator</code> property has changed.
		 */
		protected var _dropIndicatorPropChanged:Boolean;
		
		private var _closePolicy:String = TabClosePolicy.NEVER;
		private var _rolledOver:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the AdvancedTab class.
		 */
		public function AdvancedTab()
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
			if (_dropIndicator != null)
				_dropIndicator.visible = false;
		}
		
		/**
		 * Shows the drop indicator for the tab drag-and-drop operation.
		 * 
		 * @param showOnLeft <code>true</code> to show drop indicator on the left side of the target tab; otherwise, <code>false</code>.
		 */
		public function showDropIndicator(showOnLeft:Boolean):void
		{
			if (_dropIndicator != null)
			{
				_dropIndicator.visible = true;
				_dropIndicator.x = showOnLeft ? -_dropIndicator.width / 2 : width - _dropIndicator.width / 2;
				_dropIndicator.y = -5;
			}
		}
		
		/**
		 * @inhertiDoc 
		 */
		public override function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			
			var allStyles:Boolean = styleProp == null || styleProp == "styleName";
			
			if (allStyles || styleProp == _dropIndicatorProp)
			{
				_dropIndicatorPropChanged = true;
				
				invalidateDisplayList();
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
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inhertiDoc
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			
			_closeButton = new Button();
			_closeButton.minHeight = _closeButton.minWidth = 10;
			
			_closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler);
			_closeButton.addEventListener(MouseEvent.MOUSE_DOWN, closeButton_mouseDownHandler);
			_closeButton.addEventListener(MouseEvent.MOUSE_UP, closeButton_mouseUpHandler);
			
			addChild(_closeButton);
		}
		
		/**
		 * Creates the drop indicator.
		 */
		protected function createDropIndicator():void
		{
			if (_dropIndicatorPropChanged)
			{
				var dropIndicatorClass:Class = getStyle(_dropIndicatorProp);
				
				if (dropIndicatorClass != null)
				{
					if (_dropIndicator && _dropIndicator.parent == this)
						removeChild(_dropIndicator);
					
					_dropIndicator = new dropIndicatorClass();
					_dropIndicator.visible = false;
					
					addChild(_dropIndicator);
				}
			}
		}
		
		/**
		 * @inhertiDoc 
		 */
		protected override function measure():void
		{
			super.measure();
			
			if (_closePolicy == TabClosePolicy.ALWAYS || _closePolicy == TabClosePolicy.ROLL_OVER ||
				(_closePolicy == TabClosePolicy.SELECTED && selected))
				measuredMinWidth = measuredWidth = Math.max(_closeButton.width + 6 + measuredMinWidth, measuredWidth);
		}
		
		/**
		 * @inhertiDoc 
		 */
		protected override function rollOutHandler(event:MouseEvent):void
		{
			super.rollOutHandler(event);
			
			_rolledOver = false;
		}
		
		/**
		 * @inhertiDoc 
		 */
		protected override function rollOverHandler(event:MouseEvent):void
		{
			super.rollOverHandler(event);
			
			if (enabled)
				_rolledOver = true;
		}
		
		/**
		 * @inhertiDoc 
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			switch (_closePolicy)
			{
				case TabClosePolicy.ALWAYS:
					
					_closeButton.visible = true;
					break;
				
				case TabClosePolicy.NEVER:
					
					_closeButton.visible = false;
					break;
				
				case TabClosePolicy.ROLL_OVER:
					
					_closeButton.visible = _rolledOver;
					break;
				
				case TabClosePolicy.SELECTED:
					
					_closeButton.visible = selected;
					break;
			}
			
			if (_closePolicy != TabClosePolicy.NEVER)
			{
				setChildIndex(_closeButton, numChildren - (_dropIndicator == null ? 1 : 2));
				
				var closeButtonStyleName:String = getStyle(_closeButtonStyleNameProp);
				
				if (closeButtonStyleName != null && closeButtonStyleName != _closeButton.styleName)
					_closeButton.styleName = closeButtonStyleName;
				
				var height:Number = getStyle(_closeButtonHeightProp);
				var width:Number = getStyle(_closeButtonWidthProp);
				
				_closeButton.height = height || _closeButton.minHeight;
				_closeButton.width = width || _closeButton.minWidth;
				
				var x:Number = Number(_closeButton.getStyle("left"));
				
				if (isNaN(x))
				{
					x = Number(_closeButton.getStyle("right"));
					x = unscaledWidth - _closeButton.width - (isNaN(x) ? 6 : x);
				}
				
				var y:Number = Number(_closeButton.getStyle("top"));
				
				if (isNaN(y))
				{
					y = Number(_closeButton.getStyle("bottom"));
					y = isNaN(y) ? (unscaledHeight - _closeButton.height) / 2 : unscaledHeight - _closeButton.height - y;
				}
				
				_closeButton.x = x;
				_closeButton.y = y;
			}
			
			if (_dropIndicatorPropChanged)
			{
				createDropIndicator();
				
				_dropIndicatorPropChanged = false;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function closeButton_clickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			dispatchEvent(new TabEvent(TabEvent.TAB_CLOSE));
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