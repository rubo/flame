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
	internal class EllipticCurve
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
		
		protected var _a:ECFieldElement;
		protected var _b:ECFieldElement;
		protected var _pointAtInfinity:ECPoint;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function EllipticCurve()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		internal function bigIntegerToFieldElement(value:BigInteger):ECFieldElement
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		internal function createPoint(x:BigInteger, y:BigInteger):ECPoint
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		internal function equals(value:EllipticCurve):Boolean
		{
			return _a.equals(value._a) && _b.equals(value._b);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal properties
		//
		//--------------------------------------------------------------------------
		
		internal function get a():ECFieldElement
		{
			return _a;
		}
		
		internal function get b():ECFieldElement
		{
			return _b;
		}
		
		internal function get fieldSize():int
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		internal function get pointAtInfinity():ECPoint
		{
			return _pointAtInfinity;
		}
	}
}