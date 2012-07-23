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
	
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	[ResourceBundle("flameCore")]
	[ResourceBundle("flameCrypto")]
	
	/**
	 * Represents the base class from which all implementations of cryptographic hash algorithms must inherit.
	 */
	public class HashAlgorithm implements ICryptoTransform
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
		
		/**
		 * Represents the value of the computed hash code.
		 */
		protected var _hash:ByteArray;
		
		/**
		 * Represents the size, in bits, of the computed hash code.
		 */
		protected var _hashSize:int;
		
		/**
		 * Represents the state of the hash computation. 
		 */
		protected var _state:int;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the HashAlgorithm class.
		 * <p>Hash functions are fundamental to modern cryptography.
		 * These functions map binary strings of an arbitrary length to small binary strings of a fixed length,
		 * known as hash values. A cryptographic hash function has the property
		 * that it is computationally infeasible to find two distinct inputs that hash to the same value.
		 * Hash functions are commonly used with digital signatures and for data integrity.</p>
		 * <p>The hash is used as a unique value of fixed size representing a large amount of data.
		 * Hashes of two sets of data should match if the corresponding data also matches.
		 * Small changes to the data result in large unpredictable changes in the hash.</p>
		 * <p><em>Notes to inheritors:</em> When you inherit from the HashAlgorithm class,
		 * you must override the following members: <code>hashCore()</code> and <code>hashFinal()</code> methods.</p>
		 */
		public function HashAlgorithm()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Computes the hash value for the specified byte array.
		 * 
		 * @param data The input to compute the hash code for.
		 * 
		 * @return The computed hash code.
		 * 
		 * @throws ArgumentError <code>data</code> parameter is <code>null</code>.
		 */		
		public function computeHash(data:ByteArray):ByteArray
		{
			if (data == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "data" ]));
			
			var position:uint = data.position;
			
			hashCore(data, 0, data.length);
			
			_hash = hashFinal();
			
			data.position = position;
			
			initialize();
			
			return hash;
		}
		
		/**
		 * Initializes an implementation of the HashAlgorithm class.
		 */
		public function initialize():void
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		/**
		 * Transforms the specified region of the input byte array
		 * and copies the resulting transform to the specified region of the output byte array.
		 * <p>You must call the <code>transformBlock()</code> method before calling the <code>transformFinalBlock()</code> method.
		 * You must call both methods before you retrieve the final hash value.</p>
		 * <p>To retrieve the final hash value after calling the <code>transformFinalBlock()</code> method,
		 * get the byte array contained within the <code>hash</code> property.</p>
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
		 * @throws ArgumentError <code>inputBuffer</code> is null.
		 * 
		 * @throws RangeError Thrown in the following situations:<ul>
		 * <li>The value of the <code>inputOffset</code> parameter is negative.</li>
		 * <li>The value of the <code>inputCount</code> parameter is less than or equal to 0.</li>
		 * <li>The value of the <code>inputCount</code> is greater
		 * than the length of the <code>inputBuffer</code> paremeter.</li>
		 * <li>The length of the <code>inputCount</code> parameter is not evenly devisable by input block size.</li>
		 * <li>The length of the input buffer is less than the sum of the input offset and the input count.</li>
		 * </ul>
		 */
		public function transformBlock(inputBuffer:ByteArray, inputOffset:int, inputCount:int, outputBuffer:ByteArray, outputOffset:int):int
		{
			if (inputBuffer == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "inputBuffer" ]));
			
			if (inputOffset < 0)
				throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeNonNegative", [ "inputOffset" ]));
			
			if (inputCount < 0 || inputCount > inputBuffer.length)
				throw new RangeError(_resourceManager.getString("flameCore", "argInvalidValue", [ "inputCount" ]));
			
			if (inputBuffer.length - inputCount < inputOffset)
				throw new RangeError(_resourceManager.getString("flameCore", "argInvalidOffsetLength"));
			
			var inputPosition:uint = inputBuffer.position;

			_state = 1;
			
			hashCore(inputBuffer, inputOffset, inputCount);
			
			if (outputBuffer != null && (outputBuffer != inputBuffer || inputOffset != outputOffset))
			{
				var outputPosition:uint = outputBuffer.position;
				
				inputBuffer.position = inputOffset;
				
				inputBuffer.readBytes(outputBuffer, outputOffset, inputCount);
				
				outputBuffer.position = outputPosition;
			}
			
			inputBuffer.position = inputPosition;
			
			return inputCount;
		}
		
		/**
		 * Transforms the specified region of the specified byte array.
		 * <p>You must call the <code>transformFinalBlock()</code> method after calling the <code>transformBlock()</code> method
		 * but before you retrieve the final hash value.</p>
		 * <p>Note that the return value of this method is not the hash value,
		 * but only a copy of the hashed part of the input data.
		 * To retrieve the final hashed value after calling the <code>transformFinalBlock()</code> method,
		 * get the byte array contained in the <code>hash</code> property.</p>
		 * 
		 * @param inputBuffer The input for which to compute the transform.
		 * 
		 * @param inputOffset The offset into the byte array from which to begin using data.
		 * 
		 * @param inputCount The number of bytes in the byte array to use as data.
		 * 
		 * @return The computed transform.
		 * 
		 * @throws ArgumentError <code>inputBuffer</code> is null.
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
				throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeNonNegative", [ "inputBuffer" ]));
			
			if (inputCount < 0 || inputCount > inputBuffer.length)
				throw new RangeError(_resourceManager.getString("flameCore", "argInvalidValue", [ "inputCount" ]));
			
			if (inputBuffer.length - inputCount < inputOffset)
				throw new RangeError(_resourceManager.getString("flameCore", "argInvalidOffsetLength"));
			
			var inputPosition:uint = inputBuffer.position;
			
			hashCore(inputBuffer, inputOffset, inputCount);
			
			_hash = hashFinal();
			
			var buffer:ByteArray = new ByteArray();
			
			if (inputCount != 0)
			{
				inputBuffer.position = inputOffset;
				
				inputBuffer.readBytes(buffer, 0, inputCount);
			}
			
			inputBuffer.position = inputPosition;
			
			_state = 0;
			
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
		 * When overridden in a derived class, gets a value indicating whether multiple blocks can be transformed. 
		 */
		public function get canTransformMultipleBlocks():Boolean
		{
			return true;
		}
		
		/**
		 * Gets the value of the computed hash code.
		 * <p>The <code>hash</code> property is a byte array;
		 * the <code>hashSize</code> property is a value that represent bits.
		 * Therefore, the number of elements in <code>hash</code> is one-eighth the size of <code>hashSize</code>.</p>
		 * 
		 * @throws flame.crypto.CryptoError <code>hash</code> property is <code>null</code>.
		 */
		public function get hash():ByteArray
		{
			if (_state != 0)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "hashNotYetFinalized"));
			
			return ByteArrayUtil.copy(_hash);
		}
		
		/**
		 * Gets the size, in bits, of the computed hash code.
		 */
		public function get hashSize():int
		{
			return _hashSize;
		}
		
		/**
		 * When overridden in a derived class, gets the input block size.
		 * <p>Unless overridden, this property returns the value 1.</p>
		 */
		public function get inputBlockSize():int
		{
			return 1;
		}
		
		/**
		 * When overridden in a derived class, gets the output block size.
		 * <p>Unless overridden, this property returns the value 1.</p>
		 */
		public function get outputBlockSize():int
		{
			return 1;
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Protected methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * When overridden in a derived class, routes data written to the object into the hash algorithm for computing the hash.
		 * <p>This method is not called by application code.</p>
		 * <p>This abstract method performs the hash computation.
		 * Every write to the cryptographic stream object passes the data through this method.
		 * For each block of data, this method updates the state of the hash object
		 * so a correct hash value is returned at the end of the data stream.</p>
		 * 
		 * @param inputBuffer The input to compute the hash code for.
		 * 
		 * @param inputOffset The offset into the byte array from which to begin using data.
		 * 
		 * @param inputCount The number of bytes in the byte array to use as data.
		 */
		protected function hashCore(inputBuffer:ByteArray, inputOffset:int, inputCount:int):void
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		/**
		 * When overridden in a derived class, finalizes the hash computation
		 * after the last data is processed by the cryptographic stream object.
		 * <p>This method finalizes any partial computation
		 * and returns the correct hash value for the data stream.</p>
		 * 
		 * @return The computed hash code.
		 */
		protected function hashFinal():ByteArray
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
	}
}