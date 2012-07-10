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
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import mx.collections.CursorBookmark;
	import mx.controls.ComboBox;
	import mx.events.FlexEvent;

	/**
	 * The AdvancedComboBox is an enhancment to the standard ComboBox.
	 * It adds an ability to specify a selected value of the data provider,
	 * to set different widths for the ComboBox and its drop-down list,
	 * and provides autocomplete item selection.
	 * 
	 * @see mx.controls.ComboBox
	 */
	public class AdvancedComboBox extends ComboBox
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
		
		private var _preferredWidth:Number = 0;
		private var _selectedValue:Object;
		private var _typedText:String = "";
		private var _typeTimer:Timer = new Timer(1000, 1);
		private var _useFixedDropdownWidth:Boolean;
		private var _valueField:String = "value";
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the AdvancedComboBox class.
		 */
		public function AdvancedComboBox()
		{
			super();
			
			_typeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, typeTimer_timerCompleteHandler);
			
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public properties
	    //
	    //--------------------------------------------------------------------------
	    
	    [Bindable("change")]
	    [Bindable("collectionChange")]
	    [Bindable("valueCommit")]
	    [Inspectable(category="General")]
		
		/**
		 * Gets the value of the selected item in the data provider, or selects the item in the data provider
		 * that contains the specified value.
		 * <p>The value of the selected item is specified by the value of its <code>valueField</code> property.</p>
		 * 
		 * @see #valueField valueField
		 * @see #selectedItem selectedItem
		 */
	    public function get selectedValue():Object
	    {
	    	if (selectedItem != null && _valueField)
	    		return selectedItem[_valueField];
	    	
	    	return null;
	    }
	    
	    [Bindable("change")]
	    [Bindable("collectionChange")]
	    [Bindable("valueCommit")]
	    [Inspectable(category="General")]
		
		/**
		 * @private 
		 */
	    public function set selectedValue(value:Object):void
	    {
	    	_selectedValue = value;
	    	
	    	setSelectedValue(value);
	    }
	    
	    [Bindable]
	    [Inspectable(category="Data", defaultValue="value")]
		
		/**
		 * Gets or sets the name of the field of the item in the data provider
		 * that provides the value of each list item.
		 * 
		 * @see #selectedValue selectedValue
		 */
	    public function get valueField():String
	    {
	    	return _valueField;
	    }
	    
		/**
		 * @private 
		 */
	    public function set valueField(value:String):void
	    {
	    	_valueField = value;
	    }
	    
	    [Bindable]
	    [Inspectable(category="General")]
		
		/**
		 * Gets or sets the value that indicates whether the drop-down list has the same width
		 * as the <code>width</code> property.
		 */
	    public function get useFixedDropdownWidth():Boolean
	    {
	    	return _useFixedDropdownWidth;
	    }
	    
		/**
		 * @private 
		 */
	    public function set useFixedDropdownWidth(value:Boolean):void
	    {
	    	_useFixedDropdownWidth = value;
	    }
		
		//--------------------------------------------------------------------------
	    //
	    //  Protected methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * @inheritDoc
		 */
	    protected override function calculatePreferredSizeFromData(count:int):Object
	    {
	    	var preferredSize:Object = super.calculatePreferredSizeFromData(count);
	    	
	    	if (!_useFixedDropdownWidth)
	    		_preferredWidth = preferredSize.width;
	    	
	    	return preferredSize;
	    }
	    
		/**
		 * @inheritDoc
		 */
	    protected override function collectionChangeHandler(event:Event):void
	    {
	    	super.collectionChangeHandler(event);
	    	
	    	setSelectedValue(_selectedValue);
	    	
	    	callLater(adjustDropdownWidth);
	    }
		
		/**
		 * @inheritDoc
		 */
		protected override function keyDownHandler(event:KeyboardEvent):void
		{
			if (!editable && enabled)
			{
				switch (event.keyCode)
				{
					case Keyboard.DOWN:
					case Keyboard.END:
					case Keyboard.ENTER:
					case Keyboard.ESCAPE:
					case Keyboard.HOME:
					case Keyboard.PAGE_DOWN:
					case Keyboard.PAGE_UP:
					case Keyboard.UP:
						
						super.keyDownHandler(event);
						break;
					
					default:
						
						_typeTimer.reset();
						_typeTimer.start();
						
						_typedText += String.fromCharCode(event.charCode);
						
						if (_typedText.length == 1)
							super.keyDownHandler(event);
						else
						{
							var label:String;
							
							iterator.seek(CursorBookmark.FIRST);
							
							do
							{
								if (iterator.current is String)
									label = iterator.current as String;
								else if (labelFunction != null)
									label = labelFunction(iterator.current);
								else if (labelField != null)
									label = iterator.current[labelField];
								
								if (label && label.toLowerCase().indexOf(_typedText.toLowerCase()) == 0)
								{
									selectedItem = iterator.current;
									
									break;
								}
							}
							while (iterator.moveNext());
						}
						
						break;
				}
			}
			else
				super.keyDownHandler(event);
		}
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Private methods
	    //
	    //--------------------------------------------------------------------------
	    
	    private function adjustDropdownWidth():void
	    {
	    	if (!_useFixedDropdownWidth)
	    		dropdownWidth = Math.max(width, _preferredWidth);
	    }
	    
	    private function creationCompleteHandler(event:FlexEvent):void
	    {
			adjustDropdownWidth();	    	
	    }
	    
	    private function setSelectedValue(value:Object):void
	    {
	    	if (value != null && _valueField && collection != null)
	    	{
				var i:int = 0;
				
				selectedIndex = -1;
				
				iterator.seek(CursorBookmark.FIRST);
				
				do
				{
					if (iterator.current != null && iterator.current[_valueField] === value)
					{
						selectedIndex = i;
						
						break;
					}
					
					i++;
				}
				while (iterator.moveNext());
				
				invalidateDisplayList();
	    	}
	    }
		
		private function typeTimer_timerCompleteHandler(event:TimerEvent):void
		{
			_typedText = "";
		}
	}
}