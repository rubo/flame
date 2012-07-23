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
	 * Represents the Abstract Syntax Notation One (ASN.1) UTCTime type.
	 */
	public class ASN1UTCTime extends ASN1Primitive
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private static var _datePattern:RegExp = /^\d{12}Z$/;
		
		private var _time:Number;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1UTCTime class.
		 * 
		 * @param value The value to use.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
		public function ASN1UTCTime(value:Date)
		{
			super(ASN1Tag.UTC_TIME);
			
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
		 * Gets the actual content as a Date.
		 */
		public function get value():Date
		{
			return new Date(_time);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private 
		 */
		internal static function fromRawValue(value:ByteArray):ASN1UTCTime
		{
			var dateString:String = value.readMultiByte(value.bytesAvailable, "ascii");
			
			if (!_datePattern.test(dateString))
				throw new ASN1Error(_resourceManager.getString("flameCrypto", "asn1InvalidDateFormat"));
			
			var year:int = int(dateString.substr(0, 2));
			
			year += year < 50 ? 2000 : 1900;
			
			var month:int = int(dateString.substr(2, 2));
			
			if (month < 1 || month > 12)
				throw new ASN1Error(_resourceManager.getString("flameUtils", "argOutOfRangeMonth"));
			
			var day:int = int(dateString.substr(4, 2));
			var daysInMonth:int = DateUtil.daysInMonth(year, month);
			
			if (day < 1 || day > daysInMonth)
				throw new ASN1Error(_resourceManager.getString("flameUtils", "argOutOfRangeDay", [ daysInMonth ]));
			
			var hours:int = int(dateString.substr(6, 2));
			
			if (hours > 23)
				throw new ASN1Error(_resourceManager.getString("flameUtils", "argOutOfRangeHours"));
			
			var minutes:int = int(dateString.substr(8, 2));
			
			if (minutes > 59)
				throw new ASN1Error(_resourceManager.getString("flameUtils", "argOutOfRangeMinutes"));
			
			var seconds:int = int(dateString.substr(10, 2));
			
			if (seconds > 59)
				throw new ASN1Error(_resourceManager.getString("flameUtils", "argOutOfRangeSeconds"));
			
			var date:Date = new Date();
			
			date.dateUTC = day;
			date.fullYearUTC = year;
			date.hoursUTC = hours;
			date.minutesUTC = minutes;
			date.monthUTC = month - 1;
			date.secondsUTC = seconds;
			
			return new ASN1UTCTime(date);
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
			var year:String = StringUtil.padLeft(date.fullYearUTC.toString().substr(-2, 2), 2, "0");
			var month:String = StringUtil.padLeft((date.month + 1).toString(), 2, "0");
			var day:String = StringUtil.padLeft(date.dateUTC.toString(), 2, "0");
			var hours:String = StringUtil.padLeft(date.hoursUTC.toString(), 2, "0");
			var minutes:String = StringUtil.padLeft(date.minutesUTC.toString(), 2, "0");
			var seconds:String = StringUtil.padLeft(date.secondsUTC.toString(), 2, "0");
			
			buffer.writeMultiByte(year + month + day + hours + minutes + seconds + "Z", "ascii");
			
			buffer.position = 0;
			
			return buffer;
		}
	}
}