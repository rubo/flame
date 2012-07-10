////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.spark
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import mx.core.mx_internal;
	
	import spark.components.DropDownList;
	
	/**
	 * The AdvancedComboBox is an enhancment to the standard DropDownList.
	 * It adds an ability to specify a selected value of the data provider
	 * and provides autocomplete item selection.
	 * 
	 * @see spark.components.DropDownList
	 */
	public class AdvancedDropDownList extends DropDownList
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _selectedValue:Object;
		private var _typedText:String = "";
		private var _typeTimer:Timer = new Timer(1000, 1);
		private var _valueField:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the AdvancedDropDownList class.
		 */
		public function AdvancedDropDownList()
		{
			super();
			
			_typeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, typeTimer_timerCompleteHandler);
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
		[Inspectable(category="Data")]
		
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
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		protected override function dataProvider_collectionChangeHandler(event:Event):void
		{
			super.dataProvider_collectionChangeHandler(event);
			
			setSelectedValue(_selectedValue);
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function keyDownHandler(event:KeyboardEvent):void
		{
			if (!enabled)
				return;
			
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
						var item:Object;
						var label:String;
						
						for (var i:int = 0, count:int = dataProvider.length; i < count; i++)
						{
							item = dataProvider.getItemAt(i);
							
							if (item is String)
								label = item as String;
							else if (labelFunction != null)
								label = labelFunction(item);
							else if (labelField != null)
								label = item[labelField];
							
							if (label && label.toLowerCase().indexOf(_typedText.toLowerCase()) == 0)
							{
								mx_internal::changeHighlightedSelection(i);
								mx_internal::setSelectedIndex(i, true);
								
								break;
							}
						}
					}
					
					break;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function setSelectedValue(value:Object):void
		{
			if (value != null && _valueField && dataProvider != null)
			{
				selectedIndex = -1;
				
				var item:Object;
				
				for (var i:int = 0, count:int = dataProvider.length; i < count; i++)
				{
					item = dataProvider.getItemAt(i);
					
					if (item != null && item[_valueField] === value)
					{
						selectedIndex = i;
						
						break;
					}
				}
				
				invalidateDisplayList();
			}
		}
		
		private function typeTimer_timerCompleteHandler(event:TimerEvent):void
		{
			_typedText = "";
		}
	}
}