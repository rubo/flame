package flame.crypto
{
	import flame.numerics.BigInteger;

	internal final class ECDomainParameters
	{
		internal var a:BigInteger;
		internal var b:BigInteger;
		internal var n:BigInteger;
		internal var q:BigInteger;
		internal var x:BigInteger;
		internal var y:BigInteger;
		
		public function ECDomainParameters()
		{
			super();
		}
	}
}