////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.validators
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	import mx.controls.RadioButtonGroup;
	import mx.events.ValidationResultEvent;
	import mx.resources.ResourceManager;
	import mx.validators.Validator;
	
	import spark.components.RadioButtonGroup;
	
	[Exclude(name="property", kind="property")]
	
	/**
	 * Validates a RadioButtonGroup object and visualizes the validation result
	 * on each RadioButton control in the group.
	 * 
	 * @see mx.controls.RadioButtonGroup
	 * @see spark.components.RadioButtonGroup
	 */
	public class RadioButtonGroupValidator extends Validator implements IBindableValidator
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
		
		private var _isValid:Boolean = false;
		private var _radionButtonGroupInitialized:Boolean = false;
		private var _sourceDescription:String;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the RadioButtonGroupValidator class.
		 */
		public function RadioButtonGroupValidator()
		{
			super();
			
			super.property = "selectedValue";
			
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
		 * @param validator The RadioButtonGroupValidator instance.
		 * 
		 * @return An Array of ValidationResult objects,
		 * with one ValidationResult object for each field examined by the validator.
		 * 
		 * @throws ArgumentError <code>validator</code> parameter is <code>null</code>.
		 * 
		 * @see mx.validators.ValidationResult
		 */
		public static function validateRadioButtonGroup(validator:RadioButtonGroupValidator):Array
		{
			if (validator == null)
				throw new ArgumentError(ResourceManager.getInstance().getString("flameLocale", "argNullGeneric", [ "validator" ]));
			
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
			throw new IllegalOperationError(resourceManager.getString("flameLocale", "argNotSupported"));
		}
		
		/**
		 * @private
		 */
		public override function set property(value:String):void
		{
			throw new IllegalOperationError(resourceManager.getString("flameLocale", "argNotSupported"));
		}
		
		/**
		 * Gets or sets a RadioButtonGroup to validate.
		 * <p>This property is optional.</p>
		 * 
		 * @throws TypeError The source is not a RadioButtonGroup.
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
			if (value != null && !isRadioButtonGroup(value))
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
			if (!_radionButtonGroupInitialized && (isRadioButtonGroup(source) || isRadioButtonGroup(listener)))
			{
				removeListenerHandler();
				
				addListenerHandler();
			}
			
			return super.doValidation(value);
		}
		
		/**
		 * Indicates whether the specified object is a radio button.
		 *  
		 * @param value The object to check.
		 * 
		 * @return <code>true</code>, if the <code>value</code> parameter represents a radio button;
		 * otherwise, <code>false</code>. 
		 */
		protected function isRadioButtonGroup(value:Object):Boolean
		{
			return value is mx.controls.RadioButtonGroup || value is spark.components.RadioButtonGroup;
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
			
			if ((result != null || result.length != 0) && isRadioButtonGroup(result[0]))
			{
				var radioButtonGroup:* = result[0];
				var count:int = radioButtonGroup.numRadioButtons;
				
				for (var i:int = 0; i < count; i++)
					result.push(radioButtonGroup.getRadioButtonAt(i));
				
				if (count > 0)
					_radionButtonGroupInitialized = true;
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