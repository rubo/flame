////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.serialization
{
	internal final class JSONTokenType
	{
		internal static const NONE:uint					= 0;
		internal static const LEFT_SQUARE_BRACKET:uint	= 1;
		internal static const LEFT_CURLY_BRACKET:uint	= 2;
		internal static const RIGHT_SQUARE_BRACKET:uint	= 3;
		internal static const RIGHT_CURLY_BRACKET:uint	= 4;
		internal static const COLON:uint				= 5;
		internal static const COMMA:uint				= 6;
		internal static const STRING:uint				= 7;
		internal static const NUMBER:uint				= 8;
		internal static const FALSE:uint				= 9;
		internal static const NULL:uint					= 10;
		internal static const TRUE:uint					= 11;
	}
}