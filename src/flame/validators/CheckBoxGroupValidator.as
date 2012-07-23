////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.validators
{
	import flame.controls.mx.CheckBoxGroup;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	import mx.events.ValidationResultEvent;
	import mx.resources.ResourceManager;
	import mx.validators.Validator;
	
	[Exclude(name="property", kind="property")]
	
	/**
	 * Validates a CheckBoxGroup object and visualizes the validation result
	 * on each CheckBox control in the group.
	 * 
	 * @see mx.controls.CheckBoxGroup
	 * @see spark.components.CheckBoxGroup
	 */
	public class CheckBoxGroupValidator extends Validator implements IBindableValidator
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _isValid:Boolean = false;
		private var _checkBoxGroupInitialized:Boolean = false;
		private var _sourceDescription:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the CheckBoxGroupValidator class.
		 */
		public function CheckBoxGroupValidator()
		{
			super();
			
			super.property = "selectedItems";
			
			addEventListener(ValidationResultEvent.INVALID, validationResultEventHandler);	
			addEventListener(ValidationResultEvent.VALID, validationResultEventHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Convenience method for calling a validator from within a custom validation function.
		 * 
		 * @param validator The CheckBoxGroupValidator instance.
		 * 
		 * @return An Array of ValidationResult objects,
		 * with one ValidationResult object for each field examined by the validator.
		 * 
		 * @throws ArgumentError <code>validator</code> parameter is <code>null</code>.
		 * 
		 * @see mx.validators.ValidationResult
		 */
		public static function validateCheckBoxGroup(validator:CheckBoxGroupValidator):Array
		{
			if (validator == null)
				throw new ArgumentError(ResourceManager.getInstance().getString("flameCore", "argNullGeneric", [ "validator" ]));
			
			return validator.doValidation(validator.getValueFromSource());
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		[Bindable("isValidChange")]
		
		/**
		 * Gets or sets a value that indicates whether the associated source passes validation.
		 */
		public function get isValid():Boolean
		{
			return _isValid;
		}
		
		/**
		 * This property is not supported.
		 * 
		 * @throws flash.errors.IllegalOperationError The property is not supported.
		 */
		public override function get property():String
		{
			throw new IllegalOperationError(resourceManager.getString("flameCore", "argNotSupported"));
		}
		
		/**
		 * @private
		 */
		public override function set property(value:String):void
		{
			throw new IllegalOperationError(resourceManager.getString("flameCore", "argNotSupported"));
		}
		
		/**
		 * Gets or sets a CheckBoxGroup to validate.
		 * <p>This property is optional.</p>
		 * 
		 * @throws TypeError The source is not a CheckBoxGroup.
		 */
		public override function get source():Object
		{
			return super.source;
		}
		
		/**
		 * @private
		 */
		public override function set source(value:Object):void
		{
			if (value != null && !isCheckBoxGroup(value))
				throw new TypeError();
			
			super.source = value;
		}
		
		[Inspectable(category="General")]
		
		/**
		 * Gets or sets the description for the associated source.
		 */
		public function get sourceDescription():String
		{
			return _sourceDescription;
		}
		
		/**
		 * @private 
		 */
		public function set sourceDescription(value:String):void
		{
			_sourceDescription = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		protected override function doValidation(value:Object):Array
		{
			if (!_checkBoxGroupInitialized && (isCheckBoxGroup(source) || isCheckBoxGroup(listener)))
			{
				removeListenerHandler();
				
				addListenerHandler();
			}
			
			return super.doValidation(int(value) == 0 ? "" : value);
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function getValueFromSource():Object
		{
			var value:Object = super.getValueFromSource();
			
			if (value != null)
				return (value as Array).length;
			
			return null;
		}
		
		/**
		 * Indicates whether the specified object is a checkbox.
		 *  
		 * @param value The object to check.
		 * 
		 * @return <code>true</code>, if the <code>value</code> parameter represents a checkbox;
		 * otherwise, <code>false</code>. 
		 */
		protected function isCheckBoxGroup(value:Object):Boolean
		{
			return value is CheckBoxGroup;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		protected override function get actualListeners():Array
		{
			var result:Array = super.actualListeners;
			
			if ((result != null || result.length != 0) && isCheckBoxGroup(result[0]))
			{
				var checkBoxGroup:* = result[0];
				var count:int = checkBoxGroup.numCheckBoxes;
				
				for (var i:int = 0; i < count; i++)
					result.push(checkBoxGroup.getCheckBoxAt(i));
				
				if (count > 0)
					_checkBoxGroupInitialized = true;
			}
			
			return result;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function validationResultEventHandler(event:ValidationResultEvent):void
		{
			if (_isValid != (event.type == ValidationResultEvent.VALID))
			{
				_isValid = !_isValid;
				
				dispatchEvent(new Event("isValidChange"));
			}
		}
	}
}