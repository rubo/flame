////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.numerics.BigInteger;
	
	import flash.errors.IllegalOperationError;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	[ResourceBundle("flameCore")]
	internal class ECFieldElement
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * A reference to the IResourceManager object which manages all of the localized resources.
		 * 
		 * @see mx.resources.IResourceManager
		 */
		protected static var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ECFieldElement()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		internal function add(value:ECFieldElement):ECFieldElement
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		internal function divide(value:ECFieldElement):ECFieldElement
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		internal function equals(value:ECFieldElement):Boolean
		{
			return toBigInteger().equals(value.toBigInteger());
		}
		
		internal function multiply(value:ECFieldElement):ECFieldElement
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		internal function negate():ECFieldElement
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		internal function square():ECFieldElement
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		internal function subtract(value:ECFieldElement):ECFieldElement
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		internal function toBigInteger():BigInteger
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		internal function get fieldSize():int
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
	}
}