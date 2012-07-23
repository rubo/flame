////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.core
{
	import flame.formatters.TimeSpanFormatter;
	import flame.utils.StringUtil;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.utils.StringUtil;
	
	[ResourceBundle("flameCore")]
	
	/**
	 * Represents a time interval. This class is immutable and cannot be inherited.
	 * <p>A TimeSpan object represents a time interval (duration of time or elapsed time)
	 * that is measured as a positive or negative number of days, hours, minutes, seconds, and milliseconds.
	 * The TimeSpan type can also be used to represent the time of day,
	 * but only if the time is unrelated to a particular date.
	 * Otherwise, the Date type should be used instead.</p>
	 * <p>The largest unit of time that the TimeSpan type uses to measure duration is a day.
	 * Time intervals are measured in days for consistency, because the number of days in larger units of time,
	 * such as months and years, varies.</p>
	 */
	public final class TimeSpan
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Represents the zero TimeSpan value.
		 * <p>Because it returns a TimeSpan object that represents a zero time value,
		 * the <code>ZERO</code> field can be compared with other TimeSpan objects
		 * to determine whether the latter represent positive, non-zero, or negative time spans.</p>
		 */
		public static const ZERO:TimeSpan = new TimeSpan(0, 0, 0, 0);
		
		private static var _dhmsfPattern:RegExp = /^\-?(\d+)[\.|\:]([0-5]\d?)\:([0-5]\d?)\:([0-5]\d?)\.(\d{1,3})$/;
		private static var _dhmsPattern:RegExp = /^\-?(\d+)[\.|\:]([0-5]\d?)\:([0-5]\d?)\:([0-5]\d?)$/;
		private static var _dPattern:RegExp = /^\-?(\d+)$/;
		private static var _formatter:TimeSpanFormatter = new TimeSpanFormatter();
		private static var _hmsfPattern:RegExp = /^\-?([0-5]\d?)\:([0-5]\d?)\:([0-5]\d?)\.(\d{1,3})$/;
		private static var _hmPattern:RegExp = /^\-?([0-5]\d?)\:([0-5]\d?)$/;
		private static var _hmsPattern:RegExp = /^\-?([0-5]\d?)\:([0-5]\d?)\:([0-5]\d?)$/;
		private static var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
	    
	    private var _milliseconds:Number = 0;
	    private var _sign:int = 1;
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 * Initializes a new TimeSpan to a specified number of days, hours, minutes, seconds, and milliseconds.
		 * 
		 * @param days Number of days.
		 * 
		 * @param hours Number of hours.
		 * 
		 * @param minutes Number of minutes.
		 * 
		 * @param seconds Number of seconds.
		 * 
		 * @param milliseconds Number of milliseconds.
		 */
		public function TimeSpan(days:Number = 0, hours:Number = 0, minutes:Number = 0, seconds:Number = 0, milliseconds:Number = 0)
		{
			super();
			
			_milliseconds += Math.floor(days) * 86400000;
			_milliseconds += Math.floor(hours) * 3600000;
			_milliseconds += Math.floor(milliseconds);
			_milliseconds += Math.floor(minutes) * 60000;
			_milliseconds += Math.floor(seconds) * 1000;
			
			if (_milliseconds < 0)
				_sign = -1;
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Adds the specified TimeSpan to this instance.
		 *  
		 * @param value The time interval to add.
		 * 
		 * @return An object that represents the value of this instance plus the value of <code>value</code> parameter.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
	    public function add(value:TimeSpan):TimeSpan
	    {
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
				
	    	return new TimeSpan(0, 0, 0, 0, _milliseconds + value.totalMilliseconds);
	    }
	    
		/**
		 * Compares two TimeSpan values and returns an integer
		 * that indicates whether the first value is shorter than, equal to, or longer than the second value.
		 * 
		 * @param timespan1 The first time interval to compare. The value can be <code>null</code>.
		 * 
		 * @param timespan2 The second time interval to compare. The value can be <code>null</code>.
		 * 
		 * @return One of the following values.
		 * <table class="innertable">
		 * <tr><th>Value</th><th>Description</th></tr>
		 * <tr><td>A negative integer</td><td><code>timespan1</code> parameter is shorter than <code>timespan2</code> parameter.</td></tr>
		 * <tr><td>Zero</td><td><code>timespan1</code> parameter is equal to <code>timespan2</code> parameter.</td></tr>
		 * <tr><td>A positive integer</td><td><code>timespan1</code> parameter is longer than <code>timespan2</code> parameter.</td></tr>
		 * </table>
		 */		
		public static function compare(timespan1:TimeSpan, timespan2:TimeSpan):int
		{
			if (timespan1 == null && timespan2 == null)
				return 0;
			
			if (timespan1 == null)
				return 1;
			
			if (timespan2 == null)
				return -1;
			
			return timespan1.compareTo(timespan2);
		}
		
		/**
		 * Compares this instance to a specified TimeSpan object and returns an integer
		 * that indicates whether this instance is shorter than, equal to, or longer than the TimeSpan object.
		 * 
		 * @param value An object to compare to this instance.
		 * 
		 * @return A signed number indicating the relative values of this instance and value.
		 * <table class="innertable">
		 * <tr><th>Value</th><th>Description</th></tr>
		 * <tr><td>A negative integer</td><td>This instance is shorter than <code>value</code> parameter.</td></tr>
		 * <tr><td>Zero</td><td>This instance is equal to <code>value</code> parameter.</td></tr>
		 * <tr><td>A positive integer</td><td>This instance is longer than <code>value</code> parameter.</td></tr>
		 * </table>
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
	    public function compareTo(value:TimeSpan):int
	    {
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
	    	if (_milliseconds < value.totalMilliseconds)
	    		return -1;
	    	
	    	if (_milliseconds > value.totalMilliseconds)
	    		return 1;
	    	
	    	return 0;
	    }
	    
		/**
		 * Returns a new TimeSpan object whose value is the absolute value
		 * of the current TimeSpan object.
		 * 
		 * @return A new object whose value is the absolute value of the current TimeSpan object. 
		 */
		public function duration():TimeSpan
		{
			return new TimeSpan(0, 0, 0, 0, Math.abs(_milliseconds));
		}
		
		/**
		 * Returns a TimeSpan that represents a specified number of days,
		 * where the specification is accurate to the nearest millisecond.
		 * <p>The <code>value</code> parameter is converted to milliseconds.
		 * Therefore, <code>value</code> parameter will only be considered accurate to the nearest millisecond.</p>
		 * 
		 * @param value A number of days, accurate to the nearest millisecond.
		 * 
		 * @return An object that represents <code>value</code> parameter.
		 */
	    public static function fromDays(value:Number):TimeSpan
	    {
	    	return new TimeSpan(value);
	    }
	    
		/**
		 * Returns a TimeSpan that represents a specified number of hours,
		 * where the specification is accurate to the nearest millisecond.
		 * <p>The value parameter is converted to milliseconds.
		 * Therefore, <code>value</code> parameter will only be considered accurate to the nearest millisecond.</p>
		 * 
		 * @param value A number of hours accurate to the nearest millisecond.
		 * 
		 * @return An object that represents <code>value</code> parameter.
		 */
	    public static function fromHours(value:Number):TimeSpan
	    {
	    	return new TimeSpan(0, value);
	    }
	    
		/**
		 * Returns a TimeSpan that represents a specified number of milliseconds.
		 * <p><code>value</code> parameter will only be considered accurate to the nearest millisecond.</p>
		 * 
		 * @param value A number of milliseconds.
		 * 
		 * @return An object that represents <code>value</code>.
		 */
	    public static function fromMilliseconds(value:Number):TimeSpan
	    {
	    	return new TimeSpan(0, 0, 0, 0, value);
	    }
	    
		/**
		 * Returns a TimeSpan that represents a specified number of minutes,
		 * where the specification is accurate to the nearest millisecond.
		 * <p>The <code>value</code> parameter is converted to milliseconds.
		 * Therefore, <code>value</code> parameter will only be considered accurate to the nearest millisecond.</p>
		 * 
		 * @param value A number of minutes, accurate to the nearest millisecond.
		 * 
		 * @return An object that represents <code>value</code> parameter.
		 */
	    public static function fromMinutes(value:Number):TimeSpan
	    {
	    	return new TimeSpan(0, 0, value);
	    }
	    
		/**
		 * Returns a TimeSpan that represents a specified number of seconds,
		 * where the specification is accurate to the nearest millisecond.
		 * <p>The <code>value</code> parameter is converted to millisecond.
		 * Therefore, <code>value</code> parameter will only be considered accurate to the nearest millisecond.</p>
		 * 
		 * @param value A number of seconds, accurate to the nearest millisecond.
		 * 
		 * @return An object that represents <code>value</code> parameter.
		 */
	    public static function fromSeconds(value:Number):TimeSpan
	    {
	    	return new TimeSpan(0, 0, 0, value);
	    }
	    
		/**
		 * Returns a TimeSpan whose value is the negated value of this instance.
		 * 
		 * @return The same numeric value as this instance, but with the opposite sign.
		 */
	    public function negate():TimeSpan
	    {
	    	return new TimeSpan(0, 0, 0, 0, -_milliseconds);
	    }
	    
		/**
		 * Converts the string representation of a time interval to its TimeSpan equivalent.
		 * 
		 * @param value A string that specifies the time interval to convert.
		 * 
		 * @return A time interval that corresponds to <code>value</code> parameter.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
	    public static function parse(value:String):TimeSpan
	    {
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
	    	var matches:Array;
	    	var timeSpan:TimeSpan;
	    	
	    	if ((matches = _dhmsfPattern.exec(value)) != null)
	    		timeSpan = new TimeSpan(matches[1], matches[2], matches[3], matches[4], matches[5]);
	    	else if ((matches = _dhmsPattern.exec(value)) != null)
	    		timeSpan = new TimeSpan(matches[1], matches[2], matches[3], matches[4]);
	    	else if ((matches = _hmsfPattern.exec(value)) != null)
	    		timeSpan = new TimeSpan(0, matches[1], matches[2], matches[3], matches[4]);
	    	else if ((matches = _hmsPattern.exec(value)) != null)
	    		timeSpan = new TimeSpan(0, matches[1], matches[2], matches[3]);
	    	else if ((matches = _hmPattern.exec(value)) != null)
	    		timeSpan = new TimeSpan(0, matches[1], matches[2]);
	    	else if ((matches = _dPattern.exec(value)) != null)
	    		timeSpan = new TimeSpan(matches[1]);
	    	
	    	if (timeSpan != null && value.indexOf("-") == 0)
	    		timeSpan._milliseconds *= -1;
	    	
	    	return timeSpan;
	    }
	    
		/**
		 * Subtracts the specified TimeSpan from this instance.
		 * 
		 * @param value The time interval to be subtracted.
		 * 
		 * @return A time interval whose value is the result of the value of this instance
		 * minus the value of <code>value</code> parameter.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
	    public function subtract(value:TimeSpan):TimeSpan
	    {
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
	    	return new TimeSpan(0, 0, 0, 0, _milliseconds - value.totalMilliseconds);
	    }
	    
		/**
		 * Converts the value of the current TimeSpan object to its equivalent string representation.
		 * 
		 * @return The string representation of the current TimeSpan value.
		 */
	    public function toString():String
	    {
	    	return _formatter.format(this);
	    }
		
		//--------------------------------------------------------------------------
	    //
	    //  Public properties
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Gets the days component of the time interval represented by the current TimeSpan object.
		 * <p>A TimeSpan value can be represented as <code>[-]D.HH:MM:SS.FFF</code>,
		 * where the optional minus sign indicates a negative time interval,
		 * the <code>D</code> component is days, <code>HH</code> is hours as measured on a 24-hour clock,
		 * <code>MM</code> is minutes, <code>SS</code> is seconds, and <code>FFF</code> is fractions of a second.
		 * The value of the <code>days</code> property is the day component, <code>D</code>.</p>
		 */
	    public function get days():Number
	    {
	    	return Math.floor(Math.abs(_milliseconds / 86400000)) * _sign;
	    }
	    
		/**
		 * Gets the hours component of the time interval represented by the current TimeSpan object.
		 * <p>A TimeSpan value can be represented as <code>[-]D.HH:MM:SS.FFF</code>,
		 * where the optional minus sign indicates a negative time interval,
		 * the <code>D</code> component is days, <code>HH</code> is hours as measured on a 24-hour clock,
		 * <code>MM</code> is minutes, <code>SS</code> is seconds, and <code>FFF</code> is fractions of a second.
		 * The value of the <code>hours</code> property is the hour component, <code>HH</code>.</p>
		 */
	    public function get hours():Number
	    {
	    	return Math.floor(Math.abs(_milliseconds / 3600000)) % 24 * _sign;
	    }
	    
		/**
		 * Gets the milliseconds component of the time interval represented by the current TimeSpan object.
		 * <p>A TimeSpan value can be represented as <code>[-]D.HH:MM:SS.FFF</code>,
		 * where the optional minus sign indicates a negative time interval,
		 * the <code>D</code> component is days, <code>HH</code> is hours as measured on a 24-hour clock,
		 * <code>MM</code> is minutes, <code>SS</code> is seconds, and <code>FFF</code> is fractions of a second.
		 * The value of the <code>milliseconds</code> property is the fractional second component, <code>FFF</code>.</p>
		 */
	    public function get milliseconds():Number
	    {
	    	return _milliseconds % 1000;
	    }
	    
		/**
		 * Gets the minutes component of the time interval represented by the current TimeSpan object.
		 * <p>A TimeSpan value can be represented as <code>[-]D.HH:MM:SS.FFF</code>,
		 * where the optional minus sign indicates a negative time interval,
		 * the <code>D</code> component is days, <code>HH</code> is hours as measured on a 24-hour clock,
		 * <code>MM</code> is minutes, <code>SS</code> is seconds, and <code>FFF</code> is fractions of a second.
		 * The value of the <code>minutes</code> property is the minute component, <code>MM</code>.</p>
		 */
	    public function get minutes():Number
	    {
	    	return Math.floor(Math.abs(_milliseconds / 60000)) % 60 * _sign;
	    }
	    
		/**
		 * Gets the seconds component of the time interval represented by the current TimeSpan object.
		 * <p>A TimeSpan value can be represented as <code>[-]D.HH:MM:SS.FFF</code>,
		 * where the optional minus sign indicates a negative time interval,
		 * the <code>D</code> component is days, <code>HH</code> is hours as measured on a 24-hour clock,
		 * <code>MM</code> is minutes, <code>SS</code> is seconds, and <code>FFF</code> is fractions of a second.
		 * The value of the <code>seconds</code> property is the second component, <code>SS</code>.</p>
		 */
	    public function get seconds():Number
	    {
	    	return Math.floor(Math.abs(_milliseconds / 1000)) % 60 * _sign;
	    }
	    
		/**
		 * Gets the value of the current TimeSpan object expressed in whole and fractional days.
		 * <p>This property converts the value of this instance from milliseconds to days.
		 * This number might include whole and fractional days.</p>
		 */
	    public function get totalDays():Number
	    {
	    	return _milliseconds / 86400000;
	    }
	    
		/**
		 * Gets the value of the current TimeSpan object expressed in whole and fractional hours.
		 * <p>This property converts the value of this instance from milliseconds to hours.
		 * This number might include whole and fractional hours.</p>
		 */
	    public function get totalHours():Number
	    {
	    	return _milliseconds / 3600000;
	    }
	    
		/**
		 * Gets the number of milliseconds that represent the value of the current TimeSpan object.
		 * <p>The number of milliseconds contained in this instance.</p>
		 */
	    public function get totalMilliseconds():Number
	    {
	    	return _milliseconds;
	    }
	    
		/**
		 * Gets the value of the current TimeSpan object expressed in whole and fractional minutes.
		 * <p>This property converts the value of this instance from milliseconds to minutes.
		 * This number might include whole and fractional minutes.</p>
		 */
	    public function get totalMinutes():Number
	    {
	    	return _milliseconds / 60000;
	    }
	    
		/**
		 * Gets the value of the current TimeSpan object expressed in whole and fractional seconds.
		 * <p>This property converts the value of this instance from milliseconds to seconds.
		 * This number might include whole and fractional seconds.</p>
		 */
	    public function get totalSeconds():Number
	    {
	    	return _milliseconds / 1000;
	    }
	}
}