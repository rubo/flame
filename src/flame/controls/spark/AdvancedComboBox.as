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
	
	import spark.components.ComboBox;
	
	/**
	 * The AdvancedComboBox is an enhancment to the standard ComboBox.
	 * It adds an ability to specify a selected value of the data provider.
	 * 
	 * @see spark.components.ComboBox
	 */
	public class AdvancedComboBox extends ComboBox
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _selectedValue:Object;
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
	}
}