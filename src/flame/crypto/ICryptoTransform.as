////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flash.utils.ByteArray;
	
	/**
	 * Defines the basic operations of cryptographic transformations.
	 */
	public interface ICryptoTransform
	{
		//--------------------------------------------------------------------------
	    //
	    //  Methods
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
		 */
		function transformBlock(inputBuffer:ByteArray, inputOffset:int, inputCount:int, outputBuffer:ByteArray, outputOffset:int):int;
		
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
		 */
		function transformFinalBlock(inputBuffer:ByteArray, inputOffset:int, inputCount:int):ByteArray;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets a value indicating whether the current transform can be reused. 
		 */
		function get canReuseTransform():Boolean;
		
		/**
		 * Gets a value indicating whether multiple blocks can be transformed.
		 */
		function get canTransformMultipleBlocks():Boolean;
		
		/**
		 * Gets the input block size.
		 */
		function get inputBlockSize():int;
		
		/**
		 * Gets the output block size.
		 */
		function get outputBlockSize():int;
	}
}