////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.mx
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import flame.utils.StringUtil;
	
	import mx.controls.TextInput;
	import mx.events.FlexEvent;

	/**
	 * Name of CSS style declaration that specifies style for the watermark text.
	 * <p>If not specified, the default value of the <code>watermarkStyleName</code> style property is used.</p>
	 */
	[Style(name="watermarkStyleName", type="String", inherit="no")]
	
	/**
	 * Adds a watermark feature to the standard TextInput.
	 * <p>When a watermarked TextInput is empty, it displays a message to the user with a custom style.
	 * Once the user has typed some text into the TextInput, the watermarked appearance goes away.
	 * The typical purpose of a watermark is to provide more information to the user
	 * about the TextInput itself without cluttering up the rest of the UI.</p>
	 * 
	 * @see mx.controls.TextInput
	 */
	public class WatermarkTextInput extends TextInput
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Represents the name of style used to specify the <code>watermarkStyleName</code>. 
		 */
		protected var _watermarkStyleNameProp:String = "watermarkStyleName";
		
		/**
		 * Indicates whether <code>watermarkStyleName</code> property has changed.
		 */
		protected var _watermarkStyleNamePropChanged:Boolean = false;
		
		private var _displayAsPassword:Boolean;
		private var _hasFocus:Boolean;
		private var _hasText:Boolean;
		private var _styleNameBackup:Object;
		private var _watermarkText:String;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the WatermarkTextInput class.
		 */
		public function WatermarkTextInput()
		{
			super();
			
			addEventListener(Event.CHANGE, changeHandler, false, int.MAX_VALUE);
			addEventListener(FlexEvent.INITIALIZE, initializeHandler);
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * @inheritDoc
		 */
		public override function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			
			var allStyles:Boolean = styleProp == null || styleProp == "styleName";
			
			if (allStyles || styleProp == _watermarkStyleNameProp)
			{
				_watermarkStyleNamePropChanged = true;
				
				invalidateDisplayList();
			}
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public properties
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * @inheritDoc
		 */
		public override function get displayAsPassword():Boolean
		{
			return _displayAsPassword;
		}
		
		/**
		 * @private
		 */
		public override function set displayAsPassword(value:Boolean):void
		{
			_displayAsPassword = super.displayAsPassword = value;
		}
		
		[Bindable("textChanged")]
	    [CollapseWhiteSpace]
	    [Inspectable(category="General", defaultValue="")]
	    [NonCommittingChangeEvent("change")]
		
		/**
		 * @inheritDoc
		 */
		public override function get text():String
		{
			return _hasText ? super.text : "";
		}
		
		/**
		 * @private
		 */
		public override function set text(value:String):void
		{
			super.text = value;
			
			_hasText = !StringUtil.isNullOrEmpty(value);
			
			invalidateDisplayList();
		}
		
		/**
		 * The text to show when the control has no value.
		 */
		public function get watermarkText():String
		{
			return _watermarkText;
		}
		
		/**
		 * @private 
		 */
		public function set watermarkText(value:String):void
		{
			_watermarkText = value;
			
			invalidateDisplayList();
			invalidateProperties();
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Protected methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * @inheritDoc
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if (!_hasFocus && !_hasText && !StringUtil.isNullOrEmpty(_watermarkText))
			{
				super.text = _watermarkText;
				
				if (super.displayAsPassword)
				{
					_displayAsPassword = super.displayAsPassword;
					
					super.displayAsPassword = false;
				}
				
				if (_watermarkStyleNamePropChanged)
				{
					_styleNameBackup = styleName;
			
					styleName = getStyle(_watermarkStyleNameProp);
					
					_watermarkStyleNamePropChanged = false;
				}
			}
			else
			{
				styleName = _styleNameBackup;
				
				if (super.displayAsPassword != _displayAsPassword)
					super.displayAsPassword = _displayAsPassword;
			}
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function focusInHandler(event:FocusEvent):void
		{
			super.focusInHandler(event);
			
			_hasFocus = true;
			
			if (!_hasText)
			{
				super.text = "";
				
				invalidateDisplayList();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function focusOutHandler(event:FocusEvent):void
		{
			super.focusOutHandler(event);
			
			_hasFocus = false;
			
			invalidateDisplayList();
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Private methods
	    //
	    //--------------------------------------------------------------------------
	    
		private function changeHandler(event:Event):void
		{
			_hasText = !StringUtil.isNullOrEmpty(super.text);
		}
		
		private function initializeHandler(event:FlexEvent):void
		{
			_styleNameBackup = styleName;
		}
	}
}