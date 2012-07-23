////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.tests.crypto
{
	import flame.crypto.AsymmetricSignatureDeformatter;
	import flame.crypto.AsymmetricSignatureFormatter;
	import flame.crypto.HashAlgorithm;
	import flame.crypto.RSA;
	import flame.crypto.RSAPKCS1SignatureDeformatter;
	import flame.crypto.RSAPKCS1SignatureFormatter;
	import flame.crypto.SHA1;
	import flame.utils.Convert;
	
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import org.flexunit.Assert;

	[TestCase(order=3)]
	public final class RSASignatureTest
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _rsa:RSA = new RSA();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function RSASignatureTest()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		[Test(order=1)]
		public function testCreateSignatureAndVerifySignatureWith384BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>w4oDeyqbkqioVmsHC4T7+gGGiL7lNWfx58Ipz61f0bt1+uiH9uAqsBk0kdpCbzB5</Modulus><Exponent>AQAB</Exponent><P>80t9YTkpAZ7Daa+FDgSGcC38GQvMGioF</P><Q>zcAYr+5j0F7jkDGuTHk9JX/XMp5h6lLl</Q><DP>uyZNuzUKGynybeDLfB31AGQPMYEGrvW1</DP><DQ>prh/CKhiRylsup4XP66KRsWlqkW+z/Kl</DQ><InverseQ>OXuiSTCHmc275TUH1xsBQYTnHY6LM3c5</InverseQ><D>DDAtGV9FhTW4EHLpZIFsh1/S9/EWLmcFJBSbTvPefAxju8euMXU8wfvRe2OB0kjR</D></RSAKeyValue>");
			
			createVerifySignatureAndTest("IialmtbQ8MOlR1Sn3MC1xPdRTClydsxwchIrVLDkyC2ANJ46igCPw2LjO8gBbJcl4sbHBsit6Q0/2QkZFdJvLQ==",
				"DCNVNfZDutn+FQ6KUK+scifBjdzBQ3lzgW7st8gfsrCxpjICXHh/2ZynngCFEPvb");
		}
		
		[Test(order=2)]
		public function testCreateSignatureAndVerifySignatureWith512BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>p6AuoTxj4YPTADq0ltFg7Fiin4jRPNvVjEyS/8jkjtzPWCNOMd7bqSM2nI6FI9RFkOc3M5twaRcUuuLiMFZTSQ==</Modulus><Exponent>AQAB</Exponent><P>1VXLgK9wauYmz8NHjM3C/7Vs9fV8iJQx0PHfipZ9LgM=</P><Q>ySYu73ymrzsv357OUSVvvm1DI3iU3ZhalF0SV/V3bcM=</Q><DP>tF3aNY2evTKjI8tVxgz9TdalLfqEdLDewWqN9g0v/uM=</DP><DQ>ce1lghEo23D7cX2hv4Yjn0iFUU7XihbjnsqEPDt0dD8=</DQ><InverseQ>PAzcHqjzsNZb+ZwV9EA3EyF5Lj/LcZ12vDRmpT/hskg=</InverseQ><D>NbZWOsQnHTQogIJPK6Sb8h/UvFoS8fVfUD2ZPO0aj8wcs+9EdYW0tdcL3eibajHYO7DdkVbSQOQPof7va7UEIQ==</D></RSAKeyValue>");
			
			createVerifySignatureAndTest("Nsd3bb+sUIkYmT6ObC+Wy4YCyh7ZVLkejbDz+1DLWTjsBExhHH+kap6gnPD3zXFUsZFGBhCKfJIHF+v4VtE+ww==",
				"KKooxF3GZe7lGFpNaVYxZ47AEs1tWDYk9KJ3+jhujFCc2WgYbuX+Zi9gFhO9T/VRxr11+XF0uyTmK0kRMz/mfQ==");
		}
		
		[Test(order=3)]
		public function testCreateSignatureAndVerifySignatureWith1024BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>ub5ODE9k/pFfITgGjac0qSSZiPOABLvy8jmemjkyDibizPCNz64zg1JbuKFHB6q9q5GSkfA38MNuS9g3RwdLWUaZhY+ggZi5Y7yj9+Zp1Y6lvtsRVMDNVWsyBbcVFSkPN2KaaNCLtTYhiDsIPjmVa3VBPgtQbTgFxth1cihTCO0=</Modulus><Exponent>AQAB</Exponent><P>5cNVEqFne35LL5M/9pFMSkVU0bVU4R5aaWCKQIh+u0Z98YtXveG8+IlDyOu8XFppFSgzESr27oxvv5fEM647DQ==</P><Q>zvQlOw3dWj4zUla6lEiXw/T1yex9ZspJKcVMrx20bE+OAk2Cf25l4lkJAVSmoQNj/uPxAUghV8iiZ7bzw8sNYQ==</Q><DP>Jft+is/n3YBpSXocLtSiOfzwIqLJX1W3OIhfEn/+A1OJ6m5QmPFCXgvDCun9f37qtDarCoGBxLmul4utQaXh2Q==</DP><DQ>d8kOp6C9x1cLQ5RZiCyAU3a8sTSF3PIm6Nt/KDjMToi5jJGqf/G5XQrl0HRbwgSBY24x9+j1C6dggSF+9IvZ4Q==</DQ><InverseQ>A6hKhKJCtBXzKcDCv0/7fP4mfcJYyiJxAgx0BUpBhaKf5tif8GGkwtkMoG60AoWg76Naib5riXZlIIlwN/lVPg==</InverseQ><D>Ln6hoNk66bJQAsu4cDr7pp9fw3VYhVba0KF1vxs0GXDIcw6AIQ11HZk/Fm9gjV3DDrBo5Rkhl6YD9P5Rj/kWdfwxfinqjhAtJ+BUcEQ8OvKvczDx49IJRS9UlV0ct3ww7ZtS3jKixdcLdACeNpXTQlUI6tBt7vZ1CjYSAKd7yoE=</D></RSAKeyValue>");
			
			createVerifySignatureAndTest("+fREFpfmljEbYDcqm5Cg+SLQAZewxdozxEtMW371y4We0cnkrxolwFq1PmcfP5nCth0GfosY+N81964AAhojiw==",
				"I0RTT+NrZ7t6Wd5BNYR2xS01JRrG3c+S5Yeko4ctjYes6BrbHw1vj7+5l8qBJvRe7CWui3mZC1PYYQHTAC1S9I3UQQPDQRb66WHHASfXWx4gN7kgUDFswvFLB8NJJMgtWI+12lFzNI7fXiFkMyGpu8YR7efv3aCPlLWejvmhlEg=");
		}
		
		[Test(order=4)]
		public function testCreateSignatureAndVerifySignatureWith2048BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>qCm76q/D6szXgJpcYyHxj3W/JIryzM25BykDkwcruAPO4fVT2r5pcD4qfWLvpWt35ACbVJYRDV+E8QAFkQfkEkIqz6S2c3qEHznhGTg/GzIcKuUu5Qt0onan4Fxn5pzwjjst/50rY5cwqi3oApgh48F1gSCSCds3Se2dB/iPqbzGgu+cH+lZuHzz8pnsBv3A7uJf+SyzttO5rAVDzJNdVYDZyfadnQjHFmHNmiNKPRlx8fHZCZhTlwGIEPbDfiltZNiVmdcfDf9RhPIs1jV4W/8xms5Y0ojFLyLSp7x1/vpGa+2VizCWxrtB1G2yVcujj0/tf0YIN39hLtfUgYu9Hw==</Modulus><Exponent>AQAB</Exponent><P>1gDBDupjG11/QiYd2EhlABnpnuewFfZijvzlqWqhJH22sNEeNKasisc/OkrQsM7z+Bz+wZ5xdqYRytBlg6QU35noSAgH3L9CfmZUjK+cs+e1NE4fq2lXVwzjFdSmaIMW3C0AqSEPeM1bqm2si7X8aG0A6N9vAde3jcmIKqjm8sU=</P><Q>ySoJ0t5cO65KmR6u0JxngWBrQUAyFrFT6EmUHbgU59LYEaaDNefhMyJBp6NwMe+LGKTZ11XISxdkNSxDoHODSPBVtBlNlw/KyrvU2fIuxnvZHwOdaQ12ud8OHtclTks/C/D6IhOgzPc2QqDzP04vbVU+uG3PqTGRophAS61CXpM=</Q><DP>0YavfxERs+tY+8UiF27aJL06NXEWwIoZeXI20icqWvYS9w/oCRjfeokWaNZzeYlG6ThKXfvpj4eNiAt+OONf5IVmHZBvUjyYt/Us9wnB3YsRqYKME2HyN7LQa8FmpJEkwrH1IaLS6S33f+gdtjSaSwvehiKtJxq0Bsi43zu70xk=</DP><DQ>U8QXlyFU0t0+3wfxz5hxWWRnBSLQOLbas81/yehPfEFGDAOEe7v1AK/xGvdpzsFq8HYk6BAmeW5iIeoutu+i6Yp6haZLsu22ijkw5xh79da4kLuWnpomqDuDy7/XHwUiWbycy/fUa8U9aP1QjTnnceWfWnkPkeq8NDKmA11AV9U=</DQ><InverseQ>1YhK0PJ2/1tuRsquNdQLZOZ+l1a1rkQcfPPM34UJOVD1awFRUd4NHaEhtnfQRCZALql87w3g0S6E6+Pz0esN5/fXKirwpqRkfu/kHVMOKM+vkpS8NKrPgOETd3c9JuwA8quxKAhx/B0uXA/2Kv/iuCkMjaiUP/mxQNnTVnF6TwU=</InverseQ><D>lhtKxp7Gf10CMKWZOlQeUDSGvpPZT7+DHkUaD7Ai8ktT7JcUlvnJHIwhWXNq/3oCtt9jyAl8hzdwb7/ZODCXAUVW+arJwiLmtQjxSZXPnvMH+bJCPeoP3sWT7M4PYOdOQ2fIE5e0F13p7r6zjz1FYwxZWz47ndi0baVQusDBXHzXDfMa8ptpb8cejGXhOzBCuENmiOfBz1gK4KG2Udpga829y5yJyq9A7XKIbBHY2EXt4wVnEqwr/Mh0W8s+MkwR7iB6RftZZQKfQa5+XmMOdSorAYYMQuVR63jq0O2BfGX8WBAVVUmNBiTmqvq1NUM0bYvSuAWiw5FT1neVU5yzIQ==</D></RSAKeyValue>");
			
			createVerifySignatureAndTest("7Tgc6qMlxowfwvV/7TvE3OpOl+YQHUxcHTF1e1Hd/1sYjxbJAdmoJHPGQ8HCcorzctW2AXVL+VbwCHPMGvSU8Q==",
				"CbuimvbNYRi8WGflLUmyUrGxtGarxPhAF9N6vQJpLAmLq1IF54TrkiBerUwi409HlUNpam/DPM0gN9YkM9yQ/ydyTs4hUNzE87WDvvgb13crGIGBYIpgYG0RMQN1M6s8uv5SCU1NAAL+QsjFEXMTVaMwnfRGKufHg3TAIUKa2YsrsXW3HkptAuUaJvnT/zYvcufCGkH77tnCd1VqE7oL/6CagDo456SEhKwKJbJm9Tu2JRc+X4HkLJYo4rDCPwv40fs1lS4tUOGHabQD0UD/Va+kVL2EnqQk7n/QohFRwHfPr/Wzr53O+g7lmxrP6Cvzw8gxA4+g5CWxmal7tHUv5Q==");
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function createVerifySignatureAndTest(data:String, expectedSignature:String):void
		{
			var formatter:AsymmetricSignatureFormatter = new RSAPKCS1SignatureFormatter(_rsa);
			var hashAlgorithm:HashAlgorithm = new SHA1();
			
			formatter.setHashAlgorithm(getQualifiedClassName(hashAlgorithm));
			
			hashAlgorithm.computeHash(Convert.fromBase64String(data));
			
			var signature:ByteArray = formatter.createSignature(hashAlgorithm.hash);
			
			Assert.assertEquals("Signature was invalid.", expectedSignature, Convert.toBase64String(signature));
			
			var deformatter:AsymmetricSignatureDeformatter = new RSAPKCS1SignatureDeformatter(_rsa);
			
			deformatter.setHashAlgorithm(getQualifiedClassName(hashAlgorithm));
			
			Assert.assertTrue("The specified signature is not a valid signature for the specified data.",
				deformatter.verifySignature(hashAlgorithm.hash, signature));
		}
	}
}