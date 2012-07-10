////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.mx
{
	import flame.controls.events.CollapseEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Panel;
	import mx.controls.Button;
	import mx.core.EdgeMetrics;
	import mx.core.EventPriority;
	import mx.core.ScrollPolicy;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.effects.Resize;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	import mx.skins.halo.PanelSkin;
	import mx.styles.StyleProxy;

	use namespace mx_internal;
	
	/**
	 * Dispatched when the content is collapsed.
	 * 
	 * @eventType flame.controls.events.CollapseEvent.COLLAPSE
	 */
	[Event(name="collapse", type="flame.controls.events.CollapseEvent")]
	
	/**
	 * Dispatched when the content is expanded.
	 * 
	 * @eventType flame.controls.events.CollapseEvent.EXPAND
	 */
	[Event(name="expand", type="flame.controls.events.CollapseEvent")]
	
	/**
	 * Name of the class to use as the skin for the Collapse button when it is disabled.
	 * 
	 * <p>The default value is the "collapseButtonDisabled" symbol in the Assets.swf file.</p>
	 */
	[Style(name="collapseButtonDisabledSkin", type="Class", format="EmbeddedFile", inherit="no")]
	
	/**
	 * Name of the class to use as the skin for the Collapse button when the mouse button is down.
	 * 
	 * <p>The default value is the "collapseButtonDown" symbol in the Assets.swf file.</p>
	 */
	[Style(name="collapseButtonDownSkin", type="Class", format="EmbeddedFile", inherit="no")]
	
	/**
	 * Name of the class to use as the skin for the Collapse button when the mouse is over.
	 * 
	 * <p>The default value is the "collapseButtonOver" symbol in the Assets.swf file.</p>
	 */
	[Style(name="collapseButtonOverSkin", type="Class", format="EmbeddedFile", inherit="no")]
	
	/**
	 * Name of the class to use as the skin for the Collapse button when the mouse button is up.
	 * 
	 * <p>The default value is the "collapseButtonUp" symbol in the Assets.swf file.</p>
	 */
	[Style(name="collapseButtonUpSkin", type="Class", format="EmbeddedFile", inherit="no")]
	
	/**
	 * Duration of the collapse transition, in milliseconds. 
	 */
	[Style(name="collapseDuration", type="Number", format="Time", inherit="no")]
	
	/**
	 * Easing function to control collapsing.
	 */
	[Style(name="collapseEasingFunction", type="Function", inherit="no")]
	
	/**
	 * Name of the class to use as the skin for the Expand button when it is disabled.
	 * 
	 * <p>The default value is the "expandButtonDisabled" symbol in the Assets.swf file.</p>
	 */
	[Style(name="expandButtonDisabledSkin", type="Class", format="EmbeddedFile", inherit="no")]
	
	/**
	 * Name of the class to use as the skin for the Expand button when the mouse button is down.
	 * 
	 * <p>The default value is the "expandButtonDown" symbol in the Assets.swf file.</p>
	 */
	[Style(name="expandButtonDownSkin", type="Class", format="EmbeddedFile", inherit="no")]
	
	/**
	 * Name of the class to use as the skin for the Expand button when the mouse is over.
	 * 
	 * <p>The default value is the "expandButtonOver" symbol in the Assets.swf file.</p>
	 */
	[Style(name="expandButtonOverSkin", type="Class", format="EmbeddedFile", inherit="no")]
	
	/**
	 * Name of the class to use as the skin for the Expand button when the mouse button is up.
	 * 
	 * <p>The default value is the "expandButtonUp" symbol in the Assets.swf file.</p>
	 */
	[Style(name="expandButtonUpSkin", type="Class", format="EmbeddedFile", inherit="no")]
	
	/**
	 * Duration of the expand transition, in milliseconds. 
	 */
	[Style(name="expandDuration", type="Number", format="Time", inherit="no")]
	
	/**
	 * Easing function to control expanding.
	 */
	[Style(name="expandEasingFunction", type="Function", inherit="no")]
	
	/**
	 * The CollapsiblePanel is a panel that can store content in a compact space.
	 * The content is collapsed or expanded by clicking the header of the control.
	 * 
	 * @see mx.control.Panel
	 */
	public class CollapsiblePanel extends Panel
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
		protected var _collapseButton:Button;
		protected var _collapsed:Boolean = false;
		protected var _resize:Resize = new Resize();
		
		private var _animate:Boolean;
		private var _collapseButtonStyleFilters:Object = {
			collapseButtonDisbaledSkin: "collapseButtonDisbaledSkin",
			collapseButtonDownSkin: "collapseButtonDownSkin",
			collapseButtonOverSkin: "collapseButtonOverSkin",
			collapseButtonUpSkin: "collapseButtonUpSkin"
		};
		private var _expandButtonStyleFilters:Object = {
			expandButtonDisbaledSkin: "expandButtonDisbaledSkin",
			expandButtonDownSkin: "expandButtonDownSkin",
			expandButtonOverSkin: "expandButtonOverSkin",
			expandButtonUpSkin: "expandButtonUpSkin"
		};
		private var _originalHeight:Number;
		private var _originalVerticalScrollPolicy:String;
		
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
			
			_resize.target = this;
			_resize.addEventListener(EffectEvent.EFFECT_END, resize_effectEndHandler);
			
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			addEventListener(CollapseEvent.COLLAPSE, collapseHandler, false, EventPriority.DEFAULT_HANDLER);
			addEventListener(CollapseEvent.EXPAND, expandHandler, false, EventPriority.DEFAULT_HANDLER);
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public properties
	    //
	    //--------------------------------------------------------------------------
		
		[Bindable]
		[Bindable("collapsedChange")]
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
			
			if (initialized)
				resize();
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Protected methods
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 * The default event handler called for a <code>flame.controls.events.collapse</code> event.
		 * 
		 * @param event The dispatched event.
		 */
		protected function collapseHandler(event:CollapseEvent):void
		{
			if (!event.isDefaultPrevented())
				collapse();
		}
		
		/**
		 * @inhertiDoc 
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			
			if (titleBar)
			{
				titleBar.doubleClickEnabled = true;
				
				titleBar.addEventListener(MouseEvent.DOUBLE_CLICK, titleBar_doubleClickHandler);
			}
			
			if (!_collapseButton)
			{
				_collapseButton = new Button();
				_collapseButton.enabled = enabled;
				_collapseButton.explicitHeight = _collapseButton.explicitWidth = 16;
				_collapseButton.focusEnabled = false;
				 
				setCollapseButtonSkin();

				_collapseButton.addEventListener(MouseEvent.CLICK, titleBar_doubleClickHandler);			
				
				titleBar.addChild(_collapseButton);
				
				_collapseButton.owner = this;
			}		
		}
		
		/**
		 * The default event handler called for a <code>flame.controls.events.expand</code> event.
		 * 
		 * @param event The dispatched event.
		 */
		protected function expandHandler(event:CollapseEvent):void
		{
			if (!event.isDefaultPrevented())
				expand();
		}
		
		/**
		 * @inhertiDoc 
		 */
		protected override function layoutChrome(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutChrome(unscaledWidth, unscaledHeight);
			
	        var bt:Number = getStyle("borderThickness");
	        var em:EdgeMetrics = EdgeMetrics.EMPTY;
	        var headerHeight:int = getHeaderHeight();
	        
	        if (border is PanelSkin && getStyle("borderStyle") != "default" && bt) 
	        	em = new EdgeMetrics(bt, bt, bt, bt);
	        
			if (_collapseButton)
			{
				var leftOffset:Number = 10 + em.left;
				var offset:Number = (headerHeight - titleTextField.getUITextFormat().measureText(titleTextField.text).height) / 2;
				var rightOffset:Number = 10;
				
				_collapseButton.setActualSize(_collapseButton.getExplicitOrMeasuredWidth(),
					_collapseButton.getExplicitOrMeasuredHeight());
				
				_collapseButton.move(leftOffset, (headerHeight - _collapseButton.getExplicitOrMeasuredHeight()) / 2);
				
				leftOffset += _collapseButton.getExplicitOrMeasuredWidth() + 6;
				
				if (titleIconObject)
				{
					titleIconObject.move(leftOffset, offset - 1);
					
					leftOffset += titleIconObject.width + 6;
				}
				
	            titleTextField.move(leftOffset, offset - 1);
	            
	            statusTextField.move(unscaledWidth - rightOffset - 6 - em.left - em.right - statusTextField.textWidth, offset - 1);
	            statusTextField.setActualSize(statusTextField.textWidth + 8, statusTextField.textHeight + UITextField.TEXT_HEIGHT_PADDING);
	            
	            var minX:Number = titleTextField.x + titleTextField.textWidth + 12;
	            
	            if (statusTextField.x < minX)
	            {
	                statusTextField.width = Math.max(statusTextField.width - (minX - statusTextField.x), 0);
	                statusTextField.x = minX;
	            }
			}
		}
		
		/**
		 * @inhertiDoc 
		 */
		protected override function measure():void
		{
			super.measure();
			
			if (_collapseButton)
				measuredMinWidth = measuredWidth = Math.max(_collapseButton.getExplicitOrMeasuredWidth() + 6 + measuredMinWidth, measuredWidth);
		}
		
		/**
		 * Expands or collapses the content of the control.
		 */
		protected function resize():void
		{
			_animate = false;
			
			_collapsed ? collapse() : expand();
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Private methods
	    //
	    //--------------------------------------------------------------------------
		
		private function collapse():void
		{
			if (_animate)
			{
				_collapsed = !_collapsed
				
				if (_resize.isPlaying)
					_resize.end();
				
				var duration:Number;
				var easingFunction:Function;
				
				duration = getStyle("collapseDuration");
				
				if (!isNaN(duration))
					_resize.duration = duration;
				
				_originalHeight = height;
				
				easingFunction = getStyle("collapseEasingFunction") as Function;
				
				if (easingFunction != null)
					_resize.easingFunction = easingFunction;
				
				_resize.heightTo = getHeaderHeight();
				
				_originalVerticalScrollPolicy = verticalScrollPolicy;
				_verticalScrollPolicy = ScrollPolicy.OFF;
				
				dispatchEvent(new Event("collapsedChange"));
				
				_resize.play();
			}
			else
			{
				_originalHeight = height;
				
				height = getHeaderHeight();
				
				invalidateDisplayList();
			}
			
			setCollapseButtonSkin();
		}
		
		private function creationCompleteHandler(event:FlexEvent):void
		{
			resize();
		}
		
		private function expand():void
		{
			if (_animate)
			{
				_collapsed = !_collapsed
				
				if (_resize.isPlaying)
					_resize.end();
				
				var duration:Number;
				var easingFunction:Function;
				
				duration = getStyle("expandDuration");
				
				if (!isNaN(duration))
					_resize.duration = duration;
				
				easingFunction = getStyle("expandEasingFunction") as Function;
				
				if (easingFunction != null)
					_resize.easingFunction = easingFunction;
				
				_resize.heightTo = Math.min(_originalHeight, maxHeight);
				
				_originalVerticalScrollPolicy = verticalScrollPolicy;
				_verticalScrollPolicy = ScrollPolicy.OFF;
				
				dispatchEvent(new Event("collapsedChange"));
				
				_resize.play();
			}
			else
			{
				height = _originalHeight;
				
				invalidateDisplayList();
			}
			
			setCollapseButtonSkin();
		}
		
		private function resize_effectEndHandler(event:EffectEvent):void
		{
			verticalScrollPolicy = _originalVerticalScrollPolicy;
			
			if (!_collapsed)
				height = Number.NaN;
		}
		
		private function setCollapseButtonSkin():void
		{
			if (_collapsed)
			{
				_collapseButton.styleName = new StyleProxy(this, _expandButtonStyleFilters);
				
	            _collapseButton.disabledSkinName = "expandButtonDisabledSkin";
	            _collapseButton.downSkinName = "expandButtonDownSkin";
	            _collapseButton.overSkinName = "expandButtonOverSkin";
	            _collapseButton.upSkinName = "expandButtonUpSkin";
			}
			else
			{
				_collapseButton.styleName = new StyleProxy(this, _collapseButtonStyleFilters);
				
	            _collapseButton.disabledSkinName = "collapseButtonDisabledSkin";
	            _collapseButton.downSkinName = "collapseButtonDownSkin";
	            _collapseButton.overSkinName = "collapseButtonOverSkin";
	            _collapseButton.upSkinName = "collapseButtonUpSkin";
			}
            
            _collapseButton.invalidateDisplayList();
		}
		
		private function titleBar_doubleClickHandler(event:MouseEvent):void
		{
			_animate = true;
			
			if (_collapsed)
				dispatchEvent(new CollapseEvent(CollapseEvent.EXPAND, false, true));
			else
				dispatchEvent(new CollapseEvent(CollapseEvent.COLLAPSE, false, true));
		}
	}
}