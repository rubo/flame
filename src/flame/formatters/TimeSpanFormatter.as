////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.formatters
{
	import flame.core.TimeSpan;
	import flame.utils.StringUtil;
	
	import mx.formatters.Formatter;

	[ResourceBundle("flameFormatters")]
	
	/**
	 * The TimeSpanFormatter class uses a format string
	 * to return a string representation of a <code>TimeSpan</code> object.
	 * You can create many variations easily, including international formats.
	 * <p>If an error occurs, an empty string ("") is returned
	 * and a string describing the error is saved to the <code>error</code> property.
	 * The <code>error</code> property can have one of the following values:<ul>
	 * <li>"Invalid value" means a value that is not a <code>TimeSpan</code> object.</li>
	 * <li>"Invalid format" means either the <code>formatString</code> property is set to empty string (""),
	 * or there is less than one format specifier in the <code>formatString</code> property.</li>
	 * </ul></p>
	 * 
	 * @mxml
	 * 
	 * <p>You use the <code>&#60;flame:TimeSpanFormatter&#62;</code> tag
	 * to render time strings from a TimeSpan object.</p>
	 * <p>The <code>&#60;flame:TimeSpanFormatter&#62;</code> tag inherits all of the tag attributes
	 * of its superclass, and adds the following tag attributes:</p>
	 * <pre><code>&#60;flame:TimeSpanFormatter&#62; formatString="D|DD|F|FFF|H|HH|M|MM|N|S|SS" /&#62;</code></pre> 
	 */
	public class TimeSpanFormatter extends Formatter
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
		private static var _formatSpeciiferPattern:RegExp = /(D|F|H|M|N|S)/;
		
	    private var _formatString:String;
	    private var _formatStringOverride:String;
	    
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the TimeSpanFormatter class.
		 */
		public function TimeSpanFormatter()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Converts the value of the TimeSpan object to its equivalent string representation
		 * by using the format specified in the <code>formatString</code> property.
		 * If <code>value</code> parameter cannot be formatted, returns an empty string ("")
		 * and writes a description of the error to the <code>error</code> property.
		 * 
		 * @param value The TimeSpan to format.
		 * 
		 * @return The string representation of the <code>value</code> parameter,
		 * as specified by <code>formatString</code> property. 
		 */
	    public override function format(value:Object):String
	    {
	    	if (value is TimeSpan)
	    		return internalFormat(value as TimeSpan);
	    	else
				error = defaultInvalidValueError;
	    	
	    	return "";
	    }
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Public properties
	    //
	    //--------------------------------------------------------------------------
	    
	    [Inspectable(category="General", defaultValue="null")]
		
		/**
		 * A TimeSpan format string defines the string representation
		 * of a TimeSpan value that results from a formatting operation.
		 * A format string consists of one or more TimeSpan format specifiers
		 * along with any number of literal characters.
		 * <p>The following table describes the format specifiers.</p>
		 * <table class="innertable">
		 * <tr><th>Format specifier</th><th>Description</th></tr>
		 * <tr><td>N</td><td>A sign, which indicates either a positive or a negative time interval.</td></tr>
		 * <tr><td>D</td><td>The number of whole days in the time interval, with no leading zeros.</td></tr>
		 * <tr><td>H</td><td>The number of whole hours (0-23) in the time interval
		 * that are not counted as part of days.
		 * Single-digit hours do not have a leading zero.</td></tr>
		 * <tr><td>HH</td><td>The number of whole hours (0-23) in the time interval
		 * that are not counted as part of days.
		 * Single-digit hours have a leading zero.</td></tr>
		 * <tr><td>M</td><td>The number of whole minutes (0-59) in the time interval
		 * that are not included as part of hours or days.
		 * Single-digit minutes do not have a leading zero.</td></tr>
		 * <tr><td>MM</td><td>The number of whole minutes (0-59) in the time interval
		 * that are not included as part of hours or days.
		 * Single-digit minutes have a leading zero.</td></tr>
		 * <tr><td>S</td><td>The number of whole seconds (0-59) in the time interval
		 * that are not included as part of minutes, hours, or days.
		 * Single-digit seconds do not have a leading zero.</td></tr>
		 * <tr><td>SS</td><td>The number of whole seconds (0-59) in the time interval
		 * that are not included as part of minutes, hours, or days.
		 * Single-digit seconds have a leading zero.</td></tr>
		 * <tr><td>F</td><td>The number of whole milliseconds (0-999) in the time interval
		 * that are not included as part of seconds, minutes, hours, or days.
		 * Single-digit milliseconds do not have a leading zero.</td></tr>
		 * <tr><td>FFF</td><td>The number of whole milliseconds (0-999) in the time interval
		 * that are not included as part of seconds, minutes, hours, or days.
		 * Single-digit milliseconds have leading zeros.</td></tr>
		 * </table>
		 */
	    public function get formatString():String
	    {
	    	return _formatString;
	    }
	    
		/**
		 * @private 
		 */
	    public function set formatString(value:String):void
	    {
	    	_formatStringOverride = value;
	    	_formatString = value || resourceManager.getString("flameFormatters", "timeSpanFormat");
	    }
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Protected methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * @inheritDoc
		 */
	    protected override function resourcesChanged():void
	    {
	    	super.resourcesChanged();

        	formatString = _formatStringOverride;
	    }
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Private methods
	    //
	    //--------------------------------------------------------------------------
	    
	    private function internalFormat(value:TimeSpan):String
	    {
			if (!_formatString || !_formatSpeciiferPattern.test(_formatString))
			{
				error = defaultInvalidFormatError;
				
				return "";
			}
			
	    	var formattedString:String = _formatString;
	    	
	    	if (_formatString.indexOf("D") != -1)
	    		formattedString = formattedString.replace("D", Math.abs(value.days));
	    		
    		if (_formatString.indexOf("HH") != -1)
    			formattedString = formattedString.replace("HH", StringUtil.padLeft(Math.abs(value.hours).toString(), 2, "0"));
    		
    		if (_formatString.indexOf("H") != -1)
    			formattedString = formattedString.replace("H", Math.abs(value.hours));
    		
    		if (_formatString.indexOf("MM") != -1)
    			formattedString = formattedString.replace("MM", StringUtil.padLeft(Math.abs(value.minutes).toString(), 2, "0"));
    		
    		if (_formatString.indexOf("M") != -1)
    			formattedString = formattedString.replace("M", Math.abs(value.minutes));
    		
    		if (_formatString.indexOf("SS") != -1)
    			formattedString = formattedString.replace("SS", StringUtil.padLeft(Math.abs(value.seconds).toString(), 2, "0"));
    		
    		if (_formatString.indexOf("S") != -1)
    			formattedString = formattedString.replace("S", Math.abs(value.seconds));
    		
    		if (_formatString.indexOf("FFF") != -1)
    			formattedString = formattedString.replace("FFF", StringUtil.padLeft(Math.abs(value.milliseconds).toString(), 3, "0"));
    		
    		if (_formatString.indexOf("F") != -1)
    			formattedString = formattedString.replace("F", Math.abs(value.milliseconds));
    		
    		if (_formatString.indexOf("N") != -1)
    			formattedString = formattedString.replace("N", value.totalMilliseconds < 0 ? "-" : "");
    		
			return formattedString;
	    }
	}
}