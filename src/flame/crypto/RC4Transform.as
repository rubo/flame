////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.utils.ByteArrayUtil;
	
	import flash.utils.ByteArray;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	[ResourceBundle("flameCore")]
	
	/**
	 * Performs a cryptographic transformation of data using the RC4 algorithm.
	 * This class cannot be inherited. 
	 */
	internal final class RC4Transform implements ICryptoTransform
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
		private static var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		private var _i:int;
		private var _j:int;
		private var _key:ByteArray;
		private var _state:ByteArray = new ByteArray();
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the RC4Transform class.
		 * 
		 * @param key The secret key.
		 * 
		 * @throws ArgumentError <code>key</code> parameter is <code>null</code>.
		 */
		public function RC4Transform(key:ByteArray)
		{
			super();
			
			_key = ByteArrayUtil.copy(key);
			
			generateKeySchedule();
		}

		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Transforms the specified region of the input byte array
		 * and copies the resulting transform to the specified region of the output byte array.
		 * 
		 * @param inputBuffer The input for which to compute the transform.
		 * 
		 * @param inputOffset The offset into the input byte array from which to begin using data.
		 * 
		 * @param inputCount The number of bytes in the input byte array to use as data.
		 * 
		 * @param outputBuffer The output to which to write the transform.
		 * 
		 * @param outputOffset The offset into the output byte array from which to begin writing data.
		 * 
		 * @return The number of bytes written.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>inputBuffer</code> paremeter is <code>null</code>.</li>
		 * <li><code>outputBuffer</code> parameter is <code>null</code>.</li>
		 * </ul>
		 * 
		 * @throws RangeError Thrown in the following situations:<ul>
		 * <li>The value of the <code>inputOffset</code> parameter is negative.</li>
		 * <li>The value of the <code>inputCount</code> parameter is less than or equal to 0.</li>
		 * <li>The value of the <code>inputCount</code> is greater
		 * than the length of the <code>inputBuffer</code> paremeter.</li>
		 * <li>The length of the input buffer is less than the sum of the input offset and the input count.</li>
		 * </ul>
		 */
		public function transformBlock(inputBuffer:ByteArray, inputOffset:int, inputCount:int, outputBuffer:ByteArray, outputOffset:int):int
		{
			if (inputBuffer == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "inputBuffer" ]));
			
			if (outputBuffer == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "outputBuffer" ]));
			
			if (inputOffset < 0)
				throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeNonNegative", [ "inputOffset" ]));
			
			if (inputCount <= 0 ||  inputCount > inputBuffer.length)
				throw new RangeError(_resourceManager.getString("flameCore", "argInvalidValue", [ "inputCount" ]));
			
			if (inputBuffer.length - inputCount < inputOffset)
				throw new RangeError(_resourceManager.getString("flameCore", "argInvalidOffsetLength"));
			
			return encrypt(inputBuffer, inputOffset, inputCount, outputBuffer, outputOffset);
		}
		
		/**
		 * Transforms the specified region of the specified byte array.
		 * 
		 * @param inputBuffer The input for which to compute the transform.
		 * 
		 * @param inputOffset The offset into the byte array from which to begin using data.
		 * 
		 * @param inputCount The number of bytes in the byte array to use as data.
		 * 
		 * @return The computed transform.
		 * 
		 * @throws ArgumentError <code>inputBuffer</code> parameter is <code>null</code>.
		 * 
		 * @throws RangeError Thrown in the following situations:<ul>
		 * <li>The value of the <code>inputOffset</code> parameter is negative.</li>
		 * <li>The value of the <code>inputCount</code> parameter is less than 0.</li>
		 * <li>The value of the <code>inputCount</code> parameter is greater
		 * than the length of the <code>inputBuffer</code> parameter.</li>
		 * <li>The length of the input buffer is less than the sum of the input offset and the input count.</li>
		 * </ul>
		 */
		public function transformFinalBlock(inputBuffer:ByteArray, inputOffset:int, inputCount:int):ByteArray
		{
			if (inputBuffer == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "inputBuffer" ]));
			
			if (inputOffset < 0)
				throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeNonNegative", [ "inputOffset" ]));
			
			if (inputCount < 0 || inputCount > inputBuffer.length)
				throw new RangeError(_resourceManager.getString("flameCore", "argInvalidValue", [ "inputCount" ]));
			
			if (inputBuffer.length - inputCount < inputOffset)
				throw new RangeError(_resourceManager.getString("flameCore", "argInvalidOffsetLength"));
			
			var buffer:ByteArray = new ByteArray();
			
			encrypt(inputBuffer, inputOffset, inputCount, buffer, 0);
			
			reset();
			
			return buffer;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets a value indicating whether the current transform can be reused. 
		 */
		public function get canReuseTransform():Boolean
		{
			return true;
		}
		
		/**
		 * Gets a value indicating whether multiple blocks can be transformed.
		 */
		public function get canTransformMultipleBlocks():Boolean
		{
			return true;
		}
		
		/**
		 * Gets the input block size.
		 */
		public function get inputBlockSize():int
		{
			return 1;
		}
		
		/**
		 * Gets the output block size.
		 */
		public function get outputBlockSize():int
		{
			return 1;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Resets the internal state of RC4Transform
		 * so it can be used again to do a different encryption or decryption. 
		 */
		internal function reset():void
		{
			_i = _j = 0;
			
			_state.clear();
			
			generateKeySchedule();
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Private methods
	    //
	    //--------------------------------------------------------------------------
	    
		private function encrypt(inputBuffer:ByteArray, inputOffset:int, inputCount:int, outputBuffer:ByteArray, outputOffset:int):int
		{
			for (var i:int = inputOffset, j:int = 0, count:int = inputOffset + inputCount, temp:int; i < count; i++, j++)
			{
				temp = _state[_i = (_i + 1) & 0xFF];
				_state[_i] = _state[_j = (_j + temp) & 0xFF];
				_state[_j] = temp;
				
				outputBuffer[outputOffset + j] = inputBuffer[i] ^ _state[(_state[_i] + temp) & 0xFF];
			}
			
			return inputCount;
		}
		
		private function generateKeySchedule():void
		{
			var i:int;
			var j:int;
			var keyLength:int = _key.length;
			var temp:int;
			
			for (i = 0; i < 256; i++)
				_state[i] = i;
			
			for (i = 0, j = 0; i < 256; i++)
			{
				temp = _state[i];
				_state[i] = _state[j = (j + temp + _key[i % keyLength]) & 0xFF];
				_state[j] = temp;
			}
		}
	}
}