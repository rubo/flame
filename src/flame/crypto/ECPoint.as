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
	internal class ECPoint
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
		
		protected var _curve:EllipticCurve;
		protected var _multiplier:ECPointMultiplier;
		protected var _x:ECFieldElement;
		protected var _y:ECFieldElement;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ECPoint(curve:EllipticCurve, x:ECFieldElement, y:ECFieldElement)
		{
			super();
			
			_curve = curve;
			_x = x;
			_y = y;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		internal function add(value:ECPoint):ECPoint
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		internal function double():ECPoint
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		internal function multiply(value:BigInteger):ECPoint
		{
			return _multiplier.multiply(value);
		}
		
		internal function negate():ECPoint
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		internal function subtract(value:ECPoint):ECPoint
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal properties
		//
		//--------------------------------------------------------------------------
		
		internal function get curve():EllipticCurve
		{
			return _curve;
		}
		
		internal function get isAtInfinity():Boolean
		{
			return _x == null && _y == null;
		}
		
		internal function get x():ECFieldElement
		{
			return _x;
		}
		
		internal function get y():ECFieldElement
		{
			return _y;
		}
	}
}