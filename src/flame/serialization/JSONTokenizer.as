////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.serialization
{
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	[ResourceBundle("flameCore")]
	[ResourceBundle("flameSerialization")]
	
	internal final class JSONTokenizer
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private static var _datePattern:RegExp = /^\/Date\((\-?\d+)(?:[A-Za-z]|(?:\+|\-)\d{4})?\)\/$/;
		
		private var _currentChar:String;
		private var _jsonString:String;
		private var _position:int = -1;
		private var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the JSONTokenizer class.
		 */
		public function JSONTokenizer(value:String)
		{
			super();
			
			_jsonString = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		internal function nextToken():JSONToken
		{
			do
				readChar();
			while (_currentChar == " " || _currentChar >= "\t" && _currentChar <= "\r" || _currentChar == "\u0085" || _currentChar == "\u00A0");
			
			switch (_currentChar)
			{
				case "[":
					
					return new JSONToken(JSONTokenType.LEFT_SQUARE_BRACKET, _currentChar);
				
				case "{":
					
					return new JSONToken(JSONTokenType.LEFT_CURLY_BRACKET, _currentChar);
				
				case "]":
					
					return new JSONToken(JSONTokenType.RIGHT_SQUARE_BRACKET, _currentChar);
				
				case "}":
					
					return new JSONToken(JSONTokenType.RIGHT_CURLY_BRACKET, _currentChar);
				
				case ":":
					
					return new JSONToken(JSONTokenType.COLON, _currentChar);
				
				case ",":
					
					return new JSONToken(JSONTokenType.COMMA, _currentChar);
				
				case "\"":
					
					return readString();
				
				case "f":
					
					var falsePrimitive:String = _currentChar + readChar() + readChar() + readChar() + readChar();
					
					if (falsePrimitive == "false")
						return new JSONToken(JSONTokenType.FALSE, false);
					
					throw new JSONError(_resourceManager.getString("flameSerialization", "jsonIllegalPrimitive", [ falsePrimitive ]));
				
				case "n":
					
					var nullPrimitive:String = _currentChar + readChar() + readChar() + readChar();
					
					if (nullPrimitive == "null")
						return new JSONToken(JSONTokenType.NULL, null);
					
					throw new JSONError(_resourceManager.getString("flameSerialization", "jsonIllegalPrimitive", [ nullPrimitive ]));
				
				case "t":
					
					var truePrimitive:String = _currentChar + readChar() + readChar() + readChar();
					
					if (truePrimitive == "true")
						return new JSONToken(JSONTokenType.FALSE, true);
					
					throw new JSONError(_resourceManager.getString("flameSerialization", "jsonIllegalPrimitive", [ truePrimitive ]));				
				
				default:
					
					if (isDigit(_currentChar) || _currentChar == "-")
						return readNumber();
					
					throw new JSONError(_resourceManager.getString("flameSerialization", "jsonIllegalPrimitive", [ _currentChar ]));
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		internal function get position():int
		{
			return _position;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function isDigit(value:String):Boolean
		{
			return value >= "0" && value <= "9";
		}
		
		private function readChar():String
		{
			return _currentChar = _jsonString.charAt(++_position);
		}
		
		private function readNumber():JSONToken
		{
			var value:String = "";
			
			if (_currentChar == "-")
			{
				value += _currentChar;
				
				readChar();
			}
			
			if (!isDigit(_currentChar))
				throw new JSONError(_resourceManager.getString("flameSerialization", "jsonIllegalPrimitive", [ value + _currentChar ]));
			
			if (_currentChar == "0")
			{
				value += _currentChar;
				
				if (isDigit(readChar()))
					throw new JSONError(_resourceManager.getString("flameSerialization", "jsonIllegalPrimitive", [ value + _currentChar ]));
			}
			else
				do
					value += _currentChar;
				while (isDigit(readChar()));
					
			if (_currentChar == ".")
			{
				value += _currentChar;
				
				if (!isDigit(readChar()))
					throw new JSONError(_resourceManager.getString("flameSerialization", "jsonIllegalPrimitive", [ value + _currentChar ]));
				
				do
					value += _currentChar;
				while (isDigit(readChar()));
			}
			
			if (_currentChar == "E" || _currentChar == "e")
			{
				value += _currentChar;
				
				readChar();
				
				if (_currentChar == "+" || _currentChar == "-")
				{
					value += _currentChar;
					
					readChar();
				}
				
				if (!isDigit(_currentChar))
					throw new JSONError(_resourceManager.getString("flameSerialization", "jsonIllegalPrimitive", [ value + _currentChar ]));
				
				do
					value += _currentChar;
				while (isDigit(readChar()));
			}
			
			_position--;
			
			var number:Number = Number(value);
			
			if (isFinite(number) && !isNaN(number))
				return new JSONToken(JSONTokenType.NUMBER, number);
			
			throw new JSONError(_resourceManager.getString("flameSerialization", "jsonIllegalPrimitive", [ value ]));
		}
		
		private function readString():JSONToken
		{
			var escapedSolidusCount:int = 0;
			var string:String = "";
			
			readChar();
			
			for (; _currentChar != "\"" && _currentChar.length != 0; readChar())
			{
				if (_currentChar == "\\")
				{
					switch (readChar())
					{
						case "\"":
						case "\\":
							
							string += _currentChar; 
							break;
						
						case "/":
							
							escapedSolidusCount++;
							
							string += _currentChar;
							break;
						
						case "b":
							
							string += "\b";
							break;
						
						case "f":
							
							string += "\f";
							break;
						
						case "n":
							
							string += "\n";
							break;
						
						case "r":
							
							string += "\r";
							break;
						
						case "t":
							
							string += "\t";
							break;
						
						case "u":
							
							var charCode:String = "";
							
							for (var i:int = 0; i < 4; i++, readChar())
								if (isDigit(_currentChar) || _currentChar >= "A" && _currentChar <= "F" || _currentChar >= "a" && _currentChar <= "f")
									charCode += _currentChar;
								else
									throw new JSONError(_resourceManager.getString("flameCore", "formatInvalidString"));
							
							string += String.fromCharCode(parseInt(charCode, 16));
							break;
						
						default:
							
							throw new JSONError(_resourceManager.getString("flameSerialization", "jsonInvalidEscape", [ _position ]));
					}
				}
				else
					string += _currentChar;
			}
			
			if (_currentChar.length == 0)
				throw new JSONError(_resourceManager.getString("flameSerialization", "jsonUnterminatedString", [ _position ]));
			
			if (escapedSolidusCount == 2)
			{
				var matches:Array = _datePattern.exec(string);
				
				if (matches != null)
					return new JSONToken(JSONTokenType.STRING, new Date(Number(matches[1])));
			}
			
			return new JSONToken(JSONTokenType.STRING, string);
		}
	}
}