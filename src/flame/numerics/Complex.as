////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.numerics
{
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.utils.StringUtil;
	
	[ResourceBundle("flameCore")]
	
	/**
	 * Represents a complex number. This class is immutable and cannot be inherited.
	 * <p>A complex number is a number that comprises a real number part and an imaginary number part.
	 * A complex number <code>z</code> is usually written in the form <code>z = x + yi</code>,
	 * where <code>x</code> and <code>y</code> are real numbers, and <code>i</code> is the imaginary unit
	 * that has the property <code>i<sup>2</sup> = -1</code>. The real part of the complex number is represented
	 * by <code>x</code>, and the imaginary part of the complex number is represented by <code>y</code>.</p>
	 * <p>The Complex type uses the Cartesian coordinate system (real, imaginary)
	 * when instantiating and manipulating complex numbers. A complex number can be represented
	 * as a point in a two-dimensional coordinate system, which is known as the complex plane.
	 * The real part of the complex number is positioned on the x-axis (the horizontal axis),
	 * and the imaginary part is positioned on the y-axis (the vertical axis).</p>
	 * <p>Any point in the complex plane can also be expressed based on its absolute value,
	 * by using the polar coordinate system. In polar coordinates, a point is characterized by two numbers:<ul>
	 * <li>Its magnitude, which is the distance of the point from the origin
	 * (that is, 0,0, or the point at which the x-axis and the y-axis intersect).</li>
	 * <li>Its phase, which is the angle between the real axis and the line drawn from the origin to the point.</li>
	 * </ul></p> 
	 */
	public final class Complex
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Represents a complex number with a real number equal to zero and an imaginary number equal to one. 
		 */
	    public static const IMAGINARY_ONE:Complex = new Complex(0, 1);
		
		/**
		 * Represents a complex number with a real number equal to one and an imaginary number equal to zero.
		 */
	    public static const ONE:Complex = new Complex(1, 0);
		
		/**
		 * Represents a complex number with a real number equal to zero and an imaginary number equal to zero.
		 */
	    public static const ZERO:Complex = new Complex(0, 0);
		
		private static var _resourceManager:IResourceManager = ResourceManager.getInstance();

		private var _imaginary:Number;
		private var _real:Number;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the Complex class using the specified real and imaginary values.
		 * 
		 * @param real The real part of the complex number.
		 * 
		 * @param imaginary The imaginary part of the complex number.
		 */
		public function Complex(real:Number, imaginary:Number)
		{
			super();
			
			_imaginary = imaginary;
			_real = real;
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Gets the absolute value (or magnitude) of this instance.
		 * <p>The absolute value of a complex number is equivalent to its <code>magnitude</code> property.
		 * The absolute value of a real number <code>a + bi</code> is calculated as follows:
		 * <ul>
		 * <li>If <code>b = 0</code>, the result is 0.</li>
		 * <li>If <code>a &#62; b</code>, the result is a <code>Math.sqrt(1 + b<sup>2</sup>/a<sup>2</sup>)</code>.</li>
		 * <li>If <code>b &#62; a</code>, the result is <code>b * Math.sqrt(1 + a<sup>2</sup>/b<sup>2</sup>)</code>.</li>
		 * </ul></p>
		 * 
		 * @return The absolute value of this instance.
		 */
	    public function abs():Number
	    {
	    	var i:Number = Math.abs(_imaginary);
	    	var n:Number;
	    	var r:Number = Math.abs(_real);
	    	
	    	if (r > i)
	    	{
	    		n = i / r;
	    		
	    		return r * Math.sqrt(1 + n * n);
	    	}
	    	
	    	if (i == 0)
	    		return 0;
	    	
	    	n = r / i;
	    	
	    	return i * Math.sqrt(1 + n * n);
	    }
	    
		/**
		 * Computes the angle that is the arc cosine of this instance and returns the result.
		 * <p>This method uses the following formula:</p>
		 * <pre>-IMAGINARY_ONE ~~ log(this + IMAGINARY_ONE ~~ sqrt(ONE - this ~~ this)))</pre>
		 * 
		 * @return The angle, measured in radians, which is the arc cosine of this instance.
		 */
	    public function acos():Complex
	    {
	    	return IMAGINARY_ONE.negate().multiply(add(IMAGINARY_ONE.multiply(ONE.subtract(multiply(this)).sqrt())).log());
	    }
	    
		/**
		 * Adds the specified Complex to this instance and returns the result.
		 * <p>The addition of a complex number, <code>a + bi</code>, and a second complex number,
		 * <code>c + di</code>, takes the following form:</p>
		 * <pre>(a + c) + (b + d)i</pre>
		 * 
		 * @param value The value to add.
		 * 
		 * @return The sum of the addition.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
	    public function add(value:Complex):Complex
	    {
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
	    	return new Complex(_real + value._real, _imaginary + value._imaginary);
	    }
	    
		/**
		 * Computes the angle that is the arc sine of this instance and returns the result.
		 * <p>This method uses the following formula:</p>
		 * <pre>-IMAGINARY_ONE ~~ log(IMAGINARY_ONE ~~ this + sqrt(ONE - this ~~ this))</pre>
		 * 
		 * @return The angle, measured in radians, which is the arc sine of this instance.
		 */
	    public function asin():Complex
	    {
	    	return IMAGINARY_ONE.negate().multiply(multiply(IMAGINARY_ONE).add(ONE.subtract(multiply(this)).sqrt()).log());
	    }
	    
		/**
		 * Computes the angle that is the arc tangent of this instance.
		 * <p>This method uses the following formula:</p>
		 * <pre>IMAGINARY_ONE / new Complex(2.0, 0.0)) ~~ (log(ONE - IMAGINARY_ONE ~~ this) - log(ONE + IMAGINARY_ONE ~~ this)</pre>
		 * 
		 * @return The angle, measured in radians, that is the arc tangent of this instance.
		 */
	    public function atan():Complex
	    {
	    	return IMAGINARY_ONE.divide(new Complex(2, 0)).multiply(ONE.subtract(multiply(IMAGINARY_ONE)).log()).subtract(ONE.add(multiply(IMAGINARY_ONE)).log());
	    }
	    
		/**
		 * Computes the conjugate of this instance and returns the result.
		 * <p>The conjugate of a complex number inverts the sign of the imaginary component;
		 * that is, it applies unary negation to the imaginary component.
		 * If <code>a + bi</code> is a complex number, its conjugate is <code>a - bi</code>.</p>
		 * 
		 * @return The conjugate of this instance.
		 */
	    public function conjugate():Complex
	    {
	    	return new Complex(_real, -_imaginary);
	    }
	    
		/**
		 * Computes the cosine of this instance and returns the result.
		 * <p>This method uses the following formula to calculate the cosine of the complex number <code>a + bi</code>:</p>
		 * <pre>(cos(a) ~~ cosh(b), -(sin(a) ~~ sinh(b)))</pre>
		 * 
		 * @return The cosine of this instance.
		 */
	    public function cos():Complex
	    {
	    	return new Complex(Math.cos(_real) * Complex.cosh(_imaginary), -Math.sin(_real) * Complex.sinh(_imaginary));
	    }
	    
		/**
		 * Computes the hyperbolic cosine of this instance and returns the result.
		 * <p>This method uses the following formula to calculate
		 * the hyperbolic cosine of the complex number <code>a + bi</code>:</p>
		 * <pre>(cosh(a) ~~ cos(b), sinh(a) ~~ sin(b))</pre>
		 * 
		 * @return The hyperbolic cosine of this instance.
		 */
	    public function cosh():Complex
	    {
	    	return new Complex(Complex.cosh(_real) * Math.cos(_imaginary), Complex.sinh(_real) * Math.sin(_imaginary));
	    }
	    
		/**
		 * Divides one this instance by the specified Complex and returns the result.
		 * <p>The division of a complex number, <code>a + bi</code>, by a second complex number,
		 * <code>c + di</code>, takes the following form:</p>
		 * <pre>((ac + bd) / (c<sup>2</sup> + d<sup>2</sup>)) + ((bc - ad) / (c<sup>2</sup> + d<sup>2</sup>)i</pre>
		 * 
		 * @param value The value to divide by.
		 * 
		 * @return The quotient of the division.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
	    public function divide(value:Complex):Complex
	    {
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
	    	if (Math.abs(value._imaginary) < Math.abs(value._real))
	    		return new Complex((_real + _imaginary * (value._imaginary / value._real)) / (value._real + value._imaginary * (value._imaginary / value._real)), (_imaginary - _real * (value._imaginary / value._real)) / (value._real + value._imaginary * (value._imaginary / value._real)));
	    	
	    	return new Complex((_imaginary + _real * (value._real / value._imaginary)) / (value._imaginary + value._real * (value._real / value._imaginary)), (-_real + _imaginary * (value._real / value._imaginary)) / (value._imaginary + value._real * (value._real / value._imaginary)));
	    }
	    
		/**
		 * Returns a value that indicates whether this instance and the specified Complex have the same value.
		 * 
		 * @param value The value to compare.
		 * 
		 * @return <code>true</code> if this instance and <code>value</code> parameter have the same value;
		 * otherwise, <code>false</code>.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
	    public function equals(value:Complex):Boolean
	    {
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
	    	return _real == value._real && _imaginary == value._imaginary;
	    }
	    
		/**
		 * Raises <em>e</em> to the power of this instance and returns the result.
		 * <p>Use the <code>pow()</code> method to calculate the powers of other bases.</p>
		 * <p>This method is the inverse of the <code>log()</code> method.</p>
		 * 
		 * @return The number <em>e</em> raised to the power of this instance.
		 * 
		 * @see #log() log()
		 * @see #pow() pow()
		 */
	    public function exp():Complex
	    {
	    	var n:Number = Math.exp(_real);
	    	
	    	return new Complex(n * Math.cos(_imaginary), n * Math.sin(_imaginary));
	    }
	    
		/**
		 * Creates a complex number from a point's polar coordinates.
		 * <p>This method instantiates a complex number based on its polar coordinates.</p>
		 * <p>Because there are multiple representations of a point on a complex plane,
		 * the return value of this method is normalized. The magnitude is normalized to a positive number,
		 * and the phase is normalized to a value in the range of <code>-Math.PI</code> to <code>Math.PI</code>.
		 * As a result, the values of the <code>phase</code> and <code>magnitude</code> properties
		 * of the resulting complex number may not equal the original values
		 * of the <code>magnitude</code> and <code>phase</code> parameters.</p>
		 * <p>To convert a value from degrees to radians for the <code>phase</code> parameter,
		 * multiply it by <code>Math.PI/180</code>.</p>
		 *  
		 * @param magnitude The magnitude, which is the distance from the origin
		 * (the intersection of the x-axis and the y-axis) to the number.
		 * 
		 * @param phase The phase, which is the angle from the line to the horizontal axis, measured in radians.
		 * 
		 * @return A complex number.
		 */
	    public static function fromPolarCoordinates(magnitude:Number, phase:Number):Complex
	    {
	    	return new Complex(magnitude * Math.cos(phase), magnitude * Math.sin(phase));
	    }
	    
		/**
		 * Computes the logarithm of this instance in the specified base and returns the result.
		 * 
		 * @param base The base of the logarithm.
		 * 
		 * @return The logarithm of this instance in base <code>base</code>.
		 */
	    public function log(base:Number = Number.NaN):Complex
	    {
	    	return isNaN(base) ? new Complex(Math.log(abs()), Math.atan2(_imaginary, _real)) : log().divide(new Complex(base, 0).log());
	    }
	    
		/**
		 * Computes the base-10 logarithm of this instance and returns the result.
		 *  
		 * @return The base-10 logarithm of this instance.
		 */
	    public function log10():Complex
	    {
	    	return log().scale(.43429448190325);
	    }
	    
		/**
		 * Multiplies this instance and the specified Complex and returns the result.
		 * <p>The multiplication of a complex number, <code>a + bi</code>, and a second complex number,
		 * <code>c + di</code>, takes the following form:</p>
		 * <pre>(ac - bd) + (ad + bc)i</pre>
		 * 
		 * @param value The value to multiply.
		 * 
		 * @return The product of the multiplication.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
	    public function multiply(value:Complex):Complex
	    {
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
	    	return new Complex(_real * value._real - _imaginary * value._imaginary, _imaginary * value._real + _real * value._imaginary);
	    }
	    
		/**
		 * Returns the additive inverse of this instance.
		 * <p>The additive inverse of a complex number is a complex number
		 * that produces a value of <code>ZERO</code> when it is added to the original complex number.
		 * This method returns a complex number in which the real and imaginary components
		 * of the original complex number are multiplied by -1.</p>
		 * 
		 * @return The result of the <code>real</code> and <code>imaginary</code> components
		 * of this instance multiplied by -1.
		 */
	    public function negate():Complex
	    {
	    	return new Complex(-_real, -_imaginary);
	    }
	    
		/**
		 * Raises this instance to the power of the specified value and returns the result.
		 * 
		 * @param exponent The exponent to raise by. This parameter can accept a Number, or a Complex.
		 * 
		 * @return The value of this instance raised to the power <code>exponent</code>.
		 * 
		 * @throws TypeError <code>value</code> parameter has an invalid type.
		 */
	    public function pow(exponent:*):Complex
	    {
	    	if (equals(ZERO))
	    		return ZERO;
	    	
	    	if (exponent is Complex)
	    	{
		    	var a:Number = abs();
		    	var b:Number = Math.atan2(_imaginary, _real);
		    	var c:Number = exponent._real * b + exponent._imaginary * Math.log(a);
		    	var d:Number = Math.pow(a, exponent._real) * Math.pow(Math.E, -exponent._imaginary * b);
		    	
		    	return new Complex(d * Math.cos(c), d * Math.sin(c));
	    	}
	    	else if (exponent is Number)
	    		return pow(new Complex(exponent, 0));
	    	
			throw new TypeError(_resourceManager.getString("flameCore", "argInvalidValue", [ "exponent" ]));
	    }
	    
		/**
		 * Returns the multiplicative inverse of this instance.
		 * <p>The reciprocal, or multiplicative inverse, of a number <code>x</code> is a number <code>y</code>
		 * where <code>x</code> multiplied by <code>y</code> yields 1.
		 * The reciprocal of a complex number is the complex number that produces <code>Complex.ONE</code>
		 * when the two numbers are multiplied. If a complex number is represented by <code>a + bi</code>,
		 * its reciprocal is represented by the expression <code>a / (a<sup>2</sup> + b<sup>2</sup>) - b / (a<sup>2</sup> + b<sup>2</sup>)</code>.</p>
		 * <p>If this instance is <code>Complex.ZERO</code>, the method returns <code>Complex.ZERO</code>.
		 * Otherwise, it returns the result of the expression <code>Complex.ONE/this</code>.</p>
		 * 
		 * @return The reciprocal of this instance.
		 */
	    public function reciprocal():Complex
	    {
	    	if (_real == 0 && _imaginary == 0)
	    		return ZERO;
	    	
	    	return ONE.divide(this);
	    }
	    
		/**
		 * Computes the sine of this instance and returns the result.
		 * <p>This method uses the following formula to calculate the sine of the complex number <code>a + bi</code>:</p>
		 * <pre>(sin(a) ~~ cosh(b), cos(a) ~~ sinh(b))</pre>
		 * 
		 * @return The sine of this instance.
		 */
	    public function sin():Complex
	    {
	    	return new Complex(Math.sin(_real) * Complex.cosh(_imaginary), Math.cos(_real) * Complex.sinh(_imaginary));
	    }
	    
		/**
		 * Computes the hyperbolic sine of this instance and returns the result.
		 * <p>This method uses the following formula to calculate the hyperbolic sine
		 * of the complex number <code>a + bi</code>:</p>
		 * <pre>(sinh(a) ~~ cos(b), cosh(a) ~~ sin(b))</pre>
		 *  
		 * @return The hyperbolic sine of this instance.
		 */
	    public function sinh():Complex
	    {
	    	return new Complex(Complex.sinh(_real) * Math.cos(_imaginary), Complex.cosh(_real) * Math.sin(_imaginary));
	    }
	    
		/**
		 * Computes the square root of this instance and returns the result.
		 * <p>The square root of the complex number value is calculated by using the following formula:</p>
		 * <pre>fromPolarCoordinates(Math.sqrt(magnitude), phase / 2)</pre>
		 * 
		 * @return The square root of this instance.
		 */		
	    public function sqrt():Complex
	    {
	    	return fromPolarCoordinates(Math.sqrt(magnitude), phase / 2);
	    }
	    
		/**
		 * Subtracts the specified Complex from this instance and returns the result.
		 * <p>The subtraction of a complex number, <code>c + di</code>, from another complex number,
		 * <code>a + bi</code>, takes the following form:</p>
		 * <pre>(a - c) + (b - d)i</pre>
		 * 
		 * @param value The value to subtract (the subtrahend).
		 * 
		 * @return The result of subtraction.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
	    public function subtract(value:Complex):Complex
	    {
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
	    	return new Complex(_real - value._real, _imaginary - value._imaginary);
	    }
	    
		/**
		 * Computes the tangent of this instance and returns the result.
		 * <p>This method uses the following formula to calculate the tangent of the complex number value:</p>
		 * <pre>sin(this) / cos(this)</pre>
		 *  
		 * @return The tangent of this instance.
		 */
	    public function tan():Complex
	    {
	    	return sin().divide(cos());
	    }
	    
		/**
		 * Computes the hyperbolic tangent of this instance and returns the result.
		 * <p>This method uses the following formula to calculate the hyperbolic tangent of the complex number value:</p>
		 * <pre>sinh(this) / cosh(this)</pre>
		 * 
		 * @return The hyperbolic tangent of this instance.
		 */
	    public function tanh():Complex
	    {
	    	return sinh().divide(cosh());
	    }
	    
		/**
		 * Converts the value of this instance
		 * to its equivalent string representation in Cartesian form.
		 * <p>The default string representation of a complex number displays the number
		 * using its Cartesian coordinates in the form <code>(a, b)</code>,
		 * where <code>a</code> is the real part of the complex number, and <code>b</code> is its imaginary part.</p>
		 * 
		 * @return The string representation of this instance in Cartesian form.
		 */
	    public function toString():String
	    {
	    	return StringUtil.substitute("({0}, {1})", _real, _imaginary);
	    }
		
		/**
		 * Returns a Complex whose value is equal to that of this instance.
		 * 
		 * @return A Complex with the value of this instance.
		 */
		public function valueOf():Complex
		{
			return new Complex(_real, _imaginary);
		}
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Public properties
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Gets the imaginary component of this instance.
		 * <p>Given a complex number <code>a + bi</code>,
		 * the <code>imaginary</code> property returns the value of <code>b</code>.</p>
		 */		
	    public function get imaginary():Number
	    {
	    	return _imaginary;
	    }
	    
		/**
		 * Gets the magnitude (or absolute value) of this instance.
		 * <p>The <code>magnitude</code> property is equivalent to the absolute value of a complex number.
		 * It specifies the distance from the origin (the intersection of the x-axis and the y-axis
		 * in the Cartesian coordinate system) to the two-dimensional point represented by a complex number.
		 * The absolute value is calculated as follows:</p>
		 * <pre>| a + bi | = Math.sqrt(a<sup>2</sup> + b<sup>2</sup>)</pre>
		 * <p>The <code>magnitude</code> and the <code>phase</code> properties define the position of a point
		 * that represents a complex number in the polar coordinate system.</p>
		 * <p>You can instantiate a complex number based on its polar coordinates
		 * instead of its Cartesian coordinates by calling the <code>fromPolarCoordinates()</code> method.</p>
		 */
	    public function get magnitude():Number
	    {
	    	return abs();
	    }
	    
		/**
		 * Gets the phase of this instance.
		 * <p>For a complex number <code>a + bi</code>, the phase is computed as <code>Math.atan2(b, a)</code>.</p>
		 * <p>You can identify a complex number by its Cartesian coordinates on the complex plane
		 * or by its polar coordinates. The phase (argument) of a complex number is the angle
		 * to the real axis of a line drawn from the point of origin (the intersection of the x-axis and the y-axis)
		 * to the point represented by the complex number.
		 * The magnitude (represented by the <code>magnitude</code> property) is the distance
		 * from the point of origin to the point that is represented by the complex number.</p>
		 * <p>You can instantiate a complex number based on its polar coordinates
		 * instead of its Cartesian coordinates by calling the <code>fromPolarCoordinates()</code> method.</p>
		 * <p>To convert the phase from radians to degrees, multiply it by <code>180/Math.PI</code>.</p>
		 */
	    public function get phase():Number
	    {
	    	return Math.atan2(_imaginary, _real);
	    }
	    
		/**
		 * Gets the real component of this instance.
		 * <p>Given a complex number <code>a + bi</code>,
		 * the <code>real</code> property returns the value of <code>a</code>.</p>
		 */
	    public function get real():Number
	    {
	    	return _real;
	    }
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Private methids
	    //
	    //--------------------------------------------------------------------------
	    
	    private static function cosh(value:Number):Number
		{
			return (Math.pow(Math.E, value) + Math.pow(Math.E, -value)) / 2;
		}
		
	    private function scale(factor:Number):Complex
	    {
	    	return new Complex(_real * factor, _imaginary * factor);
	    }
	    
	    private static function sinh(value:Number):Number
		{
			return (Math.pow(Math.E, value) - Math.pow(Math.E, -value)) / 2;
		}
	}
}