////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.mx
{
	import flame.core.flame_internal;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.controls.CheckBox;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.core.IMXMLObject;
	import mx.events.FlexEvent;
	import mx.resources.ResourceManager;
	import mx.utils.NameUtil;
	
	/**
	 * Dispatched when the value of the selected CheckBox control in this group changes.
	 * 
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]
	
	[ResourceBundle("flameCore")]
	
	/**
	 * The CheckBoxGroup control defines a group of CheckBox controls.
	 * <p>The <code>id</code> property is required when you use the
	 * <code>&#60;flame:CheckBoxGroup&#62;</code> tag to define the name of the group.</p>
	 * <p>Notice that the CheckBoxGroup control is a subclass of EventDispatcher, not UIComponent,
	 * and implements the IMXMLObject interface.</p>
	 * 
	 * @mxml
	 * 
	 * <p>The <code>&#60;flame:CheckBoxGroup&#62;</code> tag inherits all of the
	 * tag attributes of its superclass, and adds the following tag attributes:</p>
	 * <pre>
	 * &#60;flame:CheckBoxGroup
	 *    <strong>Properties</strong>
	 *    enabled="true|false"
	 *    id="<em>No default</em>"
	 *    labelPlacement="bottom|left|right|top"
	 *    <strong>Events</strong>
	 *    change="<em>No default</em>"
	 * /&#62;
	 * </pre>
	 */
	public class CheckBoxGroup extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _checkBoxes:Vector.<CheckBox> = new Vector.<CheckBox>();
		private var _document:IFlexDisplayObject;
		private var _labelPlacement:String;
		private var _name:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the CheckBoxGroup class.
		 */
		public function CheckBoxGroup()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Adds the specified checkbox to the group.
		 *  
		 * @param checkBox The checkbox to add.
		 * 
		 * @throws ArgumentError <code>checkBox</code> parameter cannot be <code>null</code>.
		 */
		public function addCheckBox(checkBox:CheckBox):void
		{
			if (checkBox == null)
				throw new ArgumentError(ResourceManager.getInstance().getString("flameCore", "argNullGeneric", [ "checkBox" ]));
			
			if (_checkBoxes.indexOf(checkBox) == -1)
			{
				checkBox.addEventListener(Event.CHANGE, checkBox_changeHandler);
				checkBox.addEventListener(FlexEvent.REMOVE, checkBox_removeHandler);
				
				_checkBoxes.push(checkBox);
				
				dispatchEvent(new Event("numCheckBoxesChange"));
			}
		}
		
		/**
		 * Returns the CheckBox control at the specified index.
		 * 
		 * @param index The index position of the CheckBox control.
		 * 
		 * @return The CheckBox control at the specified index position.
		 * 
		 * @throws RangeError <code>index</code> parameter is less than zero,
		 * or equals to or greater than the value of the <code>numCheckBoxes</code> property.
		 */
		public function getCheckBoxAt(index:int):CheckBox
		{
			if (index < 0 || index >= _checkBoxes.length)
				throw new RangeError(ResourceManager.getInstance().getString("flameCore", "argOutOfRangeIndex", [ "index" ]));
			
			return _checkBoxes[index];
		}
		
		/**
		 * Implementation of the <code>IMXMLObject.initialized()</code> method
		 * to support deferred instantiation.
		 * 
		 * @param document The MXML document that created this object.
		 * 
		 * @param id The identifier used by document to refer to this object.
		 * If the object is a deep property on document, <code>id</code> is null.
		 * 
		 * @see mx.core.IMXMLObject
		 */
		public function initialized(document:Object, id:String):void
		{
			_name = id;
			
			_document = document ? IFlexDisplayObject(document) : IFlexDisplayObject(FlexGlobals.topLevelApplication);
		}
		
		/**
		 * Removes the specified checkbox from the group.
		 *  
		 * @param checkBox The checkbox to remove.
		 * 
		 * @throws ArgumentError <code>checkBox</code> parameter cannot be <code>null</code>.
		 */
		public function removeCheckBox(checkBox:CheckBox):void
		{
			if (checkBox == null)
				throw new ArgumentError(ResourceManager.getInstance().getString("flameCore", "argNullGeneric", [ "checkBox" ]));
			
			var index:int = _checkBoxes.indexOf(checkBox);
			
			if (index != -1)
			{
				checkBox.addEventListener(FlexEvent.ADD, checkBox_addHandler);
				
				_checkBoxes.splice(index, 1);
				
				dispatchEvent(new Event("numCheckBoxesChange"));
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		[Bindable]
		
		/**
		 * Gets or sets a value that indicates whether selection is allowed.
		 * <p>Note that the value returned only reflects the value
		 * that was explicitly set on the CheckBoxGroup and does not reflect any values
		 * explicitly set on the individual CheckBoxes.</p>
		 */
		public function get enabled():Boolean
		{
			var i:int = 0;
			var count:int = _checkBoxes.length;
			
			while (i < count)
				if (!_checkBoxes[i++].enabled)
					break;
			
			return i == count;
		}
		
		/**
		 * @private
		 */
		public function set enabled(value:Boolean):void
		{
			for each (var checkBox:CheckBox in _checkBoxes)
				checkBox.enabled = value;
		}
		
		[Bindable]
		[Inspectable(category="General", enumeration="bottom,left,right,top", defaultValue="right")]
		
		/**
		 * Gets or sets the position of the checkbox label relative to the checkbox icon
		 * for each control in the group. You can override this setting for the individual controls.
		 * <p>Valid values in MXML are "right", "left", "bottom", and "top".</p>
		 * <p>In ActionScript, you use the following constants to set this property:
		 * <code>ButtonLabelPlacement.BOTTOM</code>, <code>ButtonLabelPlacement.LEFT</code>,
		 * <code>ButtonLabelPlacement.RIGHT</code>, and <code>ButtonLabelPlacement.TOP</code>.</p>
		 * <p>The default value is "right".</p>
		 */
		public function get labelPlacement():String
		{
			return _labelPlacement;
		}
		
		public function set labelPlacement(value:String):void
		{
			_labelPlacement = value;
			
			for each (var checkBox:CheckBox in _checkBoxes)
				checkBox.labelPlacement = value;
		}
		
		[Bindable("numCheckBoxesChange")]
		
		/**
		 * Gets the number of CheckBoxes that belong to this CheckBoxGroup.
		 */
		public function get numCheckBoxes():int
		{
			return _checkBoxes.length;
		}
		
		[Bindable("change")]
		[Bindable("valueCommit")]
		[Inspectable(category="General")]
		public function get selectedItems():Array
		{
			var items:Array = [];
			
			for each (var checkBox:CheckBox in _checkBoxes)
				if (checkBox.selected)
					items.push(checkBox);
			
			return items;
		}
		
		public function set selectedItems(value:Array):void
		{
			var checkBox:CheckBox;
			
			if (value == null || value.length == 0)
			{
				for each (checkBox in _checkBoxes)
					if (checkBox.selected)
						checkBox.selected = false;
			}
			else
			{
				for each (checkBox in _checkBoxes)
					if (value.indexOf(checkBox) == -1 && checkBox.selected)
						checkBox.selected = false;
					else if (value.indexOf(checkBox) != -1 && !checkBox.selected)
						checkBox.selected = true;
			}
			
			dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * String to uniquely identify this checkbox group.
		 * 
		 * @private
		 */
		flame_internal function get name():String
		{
			if (_name)
				_name = NameUtil.createUniqueName(this);
			
			return _name;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function checkBox_addHandler(event:FlexEvent):void
		{
			var checkBox:CheckBox = event.target as CheckBox;
			
			if (checkBox)
			{
				checkBox.removeEventListener(FlexEvent.ADD, checkBox_addHandler);
				
				addCheckBox(checkBox);
			}
		}
		
		private function checkBox_changeHandler(event:Event):void
		{
			dispatchEvent(event);
			dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
		}
		
		private function checkBox_removeHandler(event:FlexEvent):void
		{
			var checkBox:CheckBox = event.target as CheckBox;
			
			if (checkBox)
			{
				checkBox.removeEventListener(Event.CHANGE, checkBox_changeHandler);
				checkBox.removeEventListener(FlexEvent.REMOVE, checkBox_removeHandler);
				
				removeCheckBox(checkBox);
			}
		}
	}
}