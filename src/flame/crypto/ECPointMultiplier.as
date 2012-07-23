////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
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
	internal class ECPointMultiplier
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
		
		protected var _point:ECPoint;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ECPointMultiplier(point:ECPoint)
		{
			super();
			
			_point = point;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		internal function multiply(value:BigInteger):ECPoint
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
	}
}