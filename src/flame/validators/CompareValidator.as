////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.validators
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.events.FlexEvent;
	import mx.events.ValidationResultEvent;
	import mx.resources.ResourceManager;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	[ResourceBundle("flameCore")]
	[ResourceBundle("flameValidators")]
	
	/**
	 * Compares the value entered by the user in an input control
	 * with the value entered in another input control, or with a constant value.
	 * <p>Use the CompareValidator to compare the value entered by the user in an input control,
	 * such as a TextInput control, with the value entered in another input control or a constant value.</p>
	 * <p>Specify the input control to validate by setting the <code>source</code> property.
	 * If you want to compare a specific input control with another input control,
	 * set the <code>target</code> property to specify the control to compare with.</p>
	 */
	public class CompareValidator extends Validator implements IBindableValidator
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
	    private var _notMatchError:String;
	    private var _notMatchErrorOverride:String;
		private var _isValid:Boolean = false;
		private var _sourceDescription:String;
		private var _target:Object;
		private var _targetProperty:String;
		private var _targetTrigger:IEventDispatcher;
		private var _targetTriggerEvent:String = FlexEvent.VALUE_COMMIT;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the CompareValidator class.
		 */
		public function CompareValidator()
		{
			super();
			
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
		 * @param validator The CompareValidator instance.
		 * 
		 * @param sourceValue The object to validate.
		 * 
		 * @param targetValue The object to compare with.
		 * 
		 * @return An Array of ValidationResult objects,
		 * with one ValidationResult object for each field examined by the validator.
		 * 
		 * @throws ArgumentError <code>validator</code> parameter is <code>null</code>.
		 * 
		 * @see mx.validators.ValidationResult
		 */
		public static function compareValues(validator:CompareValidator, sourceValue:Object, targetValue:Object):Array
		{
			if (validator == null)
				throw new ArgumentError(ResourceManager.getInstance().getString("flameCore", "argNullGeneric", [ "validator" ]));
			
			var results:Array = [];
			
			if (sourceValue !== targetValue)
				results.push(new ValidationResult(true, "", "notMatch", validator.notMatchError));
			
			return results;
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
		
		[Inspectable(category="Errors", defaultValue="null")]
		
		/**
		 * Gets or sets the error message when the compared values do not match. 
		 */		
		public function get notMatchError():String
		{
			return _notMatchError;
		}
		
		/**
		 * @private 
		 */
		public function set notMatchError(value:String):void
		{
			_notMatchErrorOverride = value;
			
			_notMatchError = value == null ? resourceManager.getString("flameValidators", "notMatchError") : value;
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
		
		[Inspectable(category="General")]
		
		/**
		 * Gets or sets the input control to compare with the input control being validated.
		 */
		public function get target():Object
		{
			return _target;
		}
		
		/**
		 * @private 
		 */
		public function set target(value:Object):void
		{
			removeTargetTriggerHandler();
			
			_target = value;
			
			addTargetTriggerHandler();
		}
		
		[Inspectable(category="General")]
		
		/**
		 * Gets or sets the name of the property of the target object that contains the value to compare with.
		 */
		public function get targetProperty():String
		{
			return _targetProperty;
		}
		
		/**
		 * @private 
		 */
		public function set targetProperty(value:String):void
		{
			_targetProperty = value;
		}
		
		[Inspectable(category="General")]
		
		/**
		 * Gets or sets the component generating the event that triggers the validator.
		 * If not specified, the value of the <code>target</code> property is used.
		 * When the <code>targetTrigger</code> dispatches a <code>targetTriggerEvent</code>, validation executes.
		 */
		public function get targetTrigger():IEventDispatcher
		{
			return _targetTrigger;
		}
		
		/**
		 * @private 
		 */
		public function set targetTrigger(value:IEventDispatcher):void
		{
			removeTargetTriggerHandler();
			
			_targetTrigger = value;
			
			addTargetTriggerHandler();
		}
		
		[Inspectable(category="General")]
		
		/**
		 * Specifies the event that triggers the validation. If not specified, the <code>valueCommit</code> event is used.
		 * Flex dispatches the <code>valueCommit</code> event when a user completes data entry into a control.
		 * Usually this is when the user removes focus from the component,
		 * or when a property value is changed programmatically.
		 * If you want a validator to ignore all events,
		 * set the <code>targetTriggerEvent</code> property to an empty string ("").
		 */
		public function get targetTriggerEvent():String
		{
			return _targetTriggerEvent;
		}
		
		/**
		 * @private 
		 */
		public function set targetTriggerEvent(value:String):void
		{
			if (_targetTriggerEvent != value)
			{
				removeTargetTriggerHandler();
				
				_targetTriggerEvent = value;
				
				addTargetTriggerHandler();
			}
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
	    	var results:Array = super.doValidation(value);
	    	
	    	return (results.length > 0 || (value ? value.toString() : "").length == 0 && !required)
				? results : compareValues(this, value, getValueFromTarget());
	    }
	    
	    protected function getValueFromTarget():Object
	    {
	        if (_target != null && _targetProperty)
	            return _target[_targetProperty];
	        else if (_target == null && _targetProperty)
	            throw new Error(resourceManager.getString("flameValidators", "targetAttributeMissing"));
	        else if (_target != null && !_targetProperty)
	        	throw new Error(resourceManager.getString("flameValidators", "targetPropertyAttributeMissing"));
	        
	        return null;
	    }
	    
		/**
		 * @inheritDoc
		 */
	    protected override function resourcesChanged():void
	    {
	    	super.resourcesChanged();
	    	
	    	notMatchError = _notMatchErrorOverride;
	    }
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Protected properties
	    //
	    //--------------------------------------------------------------------------
	    
	    protected function get actualTargetTrigger():IEventDispatcher
	    {
	    	if (_targetTrigger != null)
	    		return _targetTrigger;
	    	
	    	if (_target != null)
	    		return _target as IEventDispatcher;
	    	
	    	return null;
	    }
		
		//--------------------------------------------------------------------------
	    //
	    //  Private methods
	    //
	    //--------------------------------------------------------------------------
		
		private function addTargetTriggerHandler():void
		{
			if (actualTargetTrigger != null)
				actualTargetTrigger.addEventListener(_targetTriggerEvent, targetTriggerHandler);
		}
		
		private function removeTargetTriggerHandler():void
		{
			if (actualTargetTrigger != null)
				actualTargetTrigger.removeEventListener(_targetTriggerEvent, targetTriggerHandler);
		}
		
		private function targetTriggerHandler(event:Event):void
		{
			validate();
		}
		
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