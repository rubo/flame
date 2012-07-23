////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto.asn1
{
	import flame.utils.DateUtil;
	import flame.utils.StringUtil;
	
	import flash.utils.ByteArray;
	
	[ResourceBundle("flameUtils")]
	
	/**
	 * Represents the Abstract Syntax Notation One (ASN.1) GeneralizedTime type.
	 */
	public class ASN1GeneralizedTime extends ASN1Primitive
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private static var _datePattern:RegExp = /^\d{14}(\.\d{1,3})?Z$/;
		
		private var _time:Number;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1GeneralizedTime class.
		 * 
		 * @param value The value to use.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
		public function ASN1GeneralizedTime(value:Date)
		{
			super(ASN1Tag.GENERALIZED_TIME);
			
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			_time = value.time;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets the actual content as a Date
		 */
		public function get value():Date
		{
			return new Date(_time);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private 
		 */
		internal static function fromRawValue(value:ByteArray):ASN1GeneralizedTime
		{
			var dateString:String = value.readMultiByte(value.bytesAvailable, "ascii");
			
			if (!_datePattern.test(dateString))
				throw new ASN1Error(_resourceManager.getString("flameCrypto", "asn1InvalidDateFormat"));
			
			var year:int = int(dateString.substr(0, 4));
			var month:int = int(dateString.substr(4, 2));
			
			if (month < 1 || month > 12)
				throw new ASN1Error(_resourceManager.getString("flameUtils", "argOutOfRangeMonth"));
			
			var day:int = int(dateString.substr(6, 2));
			var daysInMonth:int = DateUtil.daysInMonth(year, month);
			
			if (day < 1 || day > daysInMonth)
				throw new ASN1Error(_resourceManager.getString("flameUtils", "argOutOfRangeDay", [ daysInMonth ]));
			
			var hours:int = int(dateString.substr(8, 2));
			
			if (hours > 23)
				throw new ASN1Error(_resourceManager.getString("flameUtils", "argOutOfRangeHours"));
			
			var minutes:int = int(dateString.substr(10, 2));
			
			if (minutes > 59)
				throw new ASN1Error(_resourceManager.getString("flameUtils", "argOutOfRangeMinutes"));
			
			var seconds:int = int(dateString.substr(12, 2));
			
			if (seconds > 59)
				throw new ASN1Error(_resourceManager.getString("flameUtils", "argOutOfRangeSeconds"));
			
			var milliseconds:int = dateString.indexOf(".") != -1 ? parseFloat(dateString.substring(14, dateString.indexOf("Z") - 1)) * 1000 : 0;
			var date:Date = new Date();
			
			date.dateUTC = day;
			date.fullYearUTC = year;
			date.hoursUTC = hours;
			date.minutesUTC = minutes;
			date.monthUTC = month - 1;
			date.secondsUTC = seconds;
			date.millisecondsUTC = milliseconds;
			
			return new ASN1GeneralizedTime(date);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		protected override function encodeValue():ByteArray
		{
			var buffer:ByteArray = new ByteArray();
			var date:Date = new Date(_time);
			var year:String = StringUtil.padLeft(date.fullYearUTC.toString().substr(-4, 4), 4, "0");
			var month:String = StringUtil.padLeft((date.month + 1).toString(), 2, "0");
			var day:String = StringUtil.padLeft(date.dateUTC.toString(), 2, "0");
			var hours:String = StringUtil.padLeft(date.hoursUTC.toString(), 2, "0");
			var minutes:String = StringUtil.padLeft(date.minutesUTC.toString(), 2, "0");
			var seconds:String = StringUtil.padLeft(date.secondsUTC.toString(), 2, "0");
			var milliseconds:String = date.milliseconds > 0 ? "." + date.millisecondsUTC.toString().replace(/0$/, "") : "";
			
			buffer.writeMultiByte(year + month + day + hours + minutes + seconds + milliseconds + "Z", "ascii");
			
			buffer.position = 0;
			
			return buffer;
		}
	}
}