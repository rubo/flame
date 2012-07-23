////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto.asn1
{
	import flash.utils.ByteArray;

	/**
	 * Represents the abstract base class from which all implementations of
	 * Abstract Syntax Notation One (ASN.1) constructed form types must inherit.
	 */
	public class ASN1Construct extends ASN1Object
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Represents the child elements list.
		 */
		protected var _elements:Vector.<ASN1Object>;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1Construct class.
		 * 
		 * @param tag ASN.1 tag number.
		 * 
		 * @param elements The child elements to add.
		 * 
		 * @throws ArgumentError <code>tag</code> parameter is not a valid ASN.1 constructed form type tag.
		 */
		public function ASN1Construct(tag:uint, elements:Vector.<ASN1Object> = null)
		{
			super(tag);
			
			if ((_tag & ASN1Tag.CONSTRUCTED) != ASN1Tag.CONSTRUCTED)
				throw new ArgumentError(_resourceManager.getString("flameCrypto", "asn1InvalidConstructTag"));
			
			_elements = elements == null ? new Vector.<ASN1Object>() : elements.slice();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Adds the specified ASN.1 object to the end of the elements list of this instance.
		 * 
		 * @param element The ASN1Object instance to add as a child element.
		 */
		public function addElement(element:ASN1Object):void
		{
			addElementAt(element, _elements.length);
		}
		
		/**
		 * Adds the specified ASN.1 object at the specified index to the elements list of this instance.
		 * Any element that was after this index is moved out by one.
		 * 
		 * @param element The ASN1Object object to add as a child element.
		 * 
		 * @param index The zero-based index to add the element at.
		 * 
		 * @throws ArgumentError <code>element</code> parameter is <code>null</code>.
		 * 
		 * @throws RangeError <code>index</code> parameter is less than zero,
		 * or greater than the value of the <code>elementCount</code> property.
		 */
		public function addElementAt(element:ASN1Object, index:int):void
		{
			if (element == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "element" ]));
			
			if (index < 0 || index > _elements.length)
				throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeInsert", [ "index" ]));
			
			_elements.splice(index, 0, element);
		}
		
		/**
		 * Returns the ASN1Object object at the specified index.
		 * 
		 * @param index The zero-based index in the elements list to retrieve the element from.
		 * 
		 * @return The ASN1Object object at the specified index.
		 * 
		 * @throws RangeError <code>index</code> parameter is less than zero,
		 * or equal to or greater than the value of the <code>elementCount</code> property.
		 */
		public function getElementAt(index:int):ASN1Object
		{
			if (index < 0 || index >= _elements.length)
				throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeIndex", [ "index" ]));
			
			return _elements[index];
		}
		
		/**
		 * Removes the ASN1Object object at the specified index and returns it.
		 * Any elements that were after this index are now one index earlier.
		 * 
		 * @param index The zero-based index to remove from.
		 * 
		 * @return The removed ASN1Object object.
		 * 
		 * @throws RangeError <code>index</code> parameter is less than zero,
		 * or equal to or greater than the value of the <code>elementCount</code> property.
		 */
		public function removeElementAt(index:int):ASN1Object
		{
			if (index < 0 || index >= _elements.length)
				throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeIndex", [ "index" ]));
			
			return _elements.splice(index, 1)[0];
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets the number of child elements of this instance.
		 */
		public function get elementCount():int
		{
			return _elements.length;
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
			
			for each (var element:ASN1Object in _elements)
				buffer.writeBytes(element.toByteArray());
			
			buffer.position = 0;
			
			return buffer;
		}
	}
}