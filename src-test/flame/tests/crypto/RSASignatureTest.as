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
	import flame.crypto.CryptoConfig;
	import flame.crypto.HashAlgorithm;
	import flame.crypto.RSA;
	import flame.crypto.RSAPKCS1SignatureDeformatter;
	import flame.crypto.RSAPKCS1SignatureFormatter;
	import flame.crypto.RSAPSSSignatureDeformatter;
	import flame.crypto.RSAPSSSignatureFormatter;
	import flame.crypto.SHA1;
	import flame.crypto.SHA384;
	import flame.crypto.SHA512;
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
		public function testCreatePKCS1SignatureAndVerifySignatureWith384BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>w4oDeyqbkqioVmsHC4T7+gGGiL7lNWfx58Ipz61f0bt1+uiH9uAqsBk0kdpCbzB5</Modulus><Exponent>AQAB</Exponent><P>80t9YTkpAZ7Daa+FDgSGcC38GQvMGioF</P><Q>zcAYr+5j0F7jkDGuTHk9JX/XMp5h6lLl</Q><DP>uyZNuzUKGynybeDLfB31AGQPMYEGrvW1</DP><DQ>prh/CKhiRylsup4XP66KRsWlqkW+z/Kl</DQ><InverseQ>OXuiSTCHmc275TUH1xsBQYTnHY6LM3c5</InverseQ><D>DDAtGV9FhTW4EHLpZIFsh1/S9/EWLmcFJBSbTvPefAxju8euMXU8wfvRe2OB0kjR</D></RSAKeyValue>");
			
			createVerifyPKCS1SignatureAndTest("IialmtbQ8MOlR1Sn3MC1xPdRTClydsxwchIrVLDkyC2ANJ46igCPw2LjO8gBbJcl4sbHBsit6Q0/2QkZFdJvLQ==",
				"DCNVNfZDutn+FQ6KUK+scifBjdzBQ3lzgW7st8gfsrCxpjICXHh/2ZynngCFEPvb");
		}
		
		[Test(order=2)]
		public function testCreatePKCS1SignatureAndVerifySignatureWith512BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>p6AuoTxj4YPTADq0ltFg7Fiin4jRPNvVjEyS/8jkjtzPWCNOMd7bqSM2nI6FI9RFkOc3M5twaRcUuuLiMFZTSQ==</Modulus><Exponent>AQAB</Exponent><P>1VXLgK9wauYmz8NHjM3C/7Vs9fV8iJQx0PHfipZ9LgM=</P><Q>ySYu73ymrzsv357OUSVvvm1DI3iU3ZhalF0SV/V3bcM=</Q><DP>tF3aNY2evTKjI8tVxgz9TdalLfqEdLDewWqN9g0v/uM=</DP><DQ>ce1lghEo23D7cX2hv4Yjn0iFUU7XihbjnsqEPDt0dD8=</DQ><InverseQ>PAzcHqjzsNZb+ZwV9EA3EyF5Lj/LcZ12vDRmpT/hskg=</InverseQ><D>NbZWOsQnHTQogIJPK6Sb8h/UvFoS8fVfUD2ZPO0aj8wcs+9EdYW0tdcL3eibajHYO7DdkVbSQOQPof7va7UEIQ==</D></RSAKeyValue>");
			
			createVerifyPKCS1SignatureAndTest("Nsd3bb+sUIkYmT6ObC+Wy4YCyh7ZVLkejbDz+1DLWTjsBExhHH+kap6gnPD3zXFUsZFGBhCKfJIHF+v4VtE+ww==",
				"KKooxF3GZe7lGFpNaVYxZ47AEs1tWDYk9KJ3+jhujFCc2WgYbuX+Zi9gFhO9T/VRxr11+XF0uyTmK0kRMz/mfQ==");
		}
		
		[Test(order=3)]
		public function testCreatePKCS1SignatureAndVerifySignatureWith1024BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>ub5ODE9k/pFfITgGjac0qSSZiPOABLvy8jmemjkyDibizPCNz64zg1JbuKFHB6q9q5GSkfA38MNuS9g3RwdLWUaZhY+ggZi5Y7yj9+Zp1Y6lvtsRVMDNVWsyBbcVFSkPN2KaaNCLtTYhiDsIPjmVa3VBPgtQbTgFxth1cihTCO0=</Modulus><Exponent>AQAB</Exponent><P>5cNVEqFne35LL5M/9pFMSkVU0bVU4R5aaWCKQIh+u0Z98YtXveG8+IlDyOu8XFppFSgzESr27oxvv5fEM647DQ==</P><Q>zvQlOw3dWj4zUla6lEiXw/T1yex9ZspJKcVMrx20bE+OAk2Cf25l4lkJAVSmoQNj/uPxAUghV8iiZ7bzw8sNYQ==</Q><DP>Jft+is/n3YBpSXocLtSiOfzwIqLJX1W3OIhfEn/+A1OJ6m5QmPFCXgvDCun9f37qtDarCoGBxLmul4utQaXh2Q==</DP><DQ>d8kOp6C9x1cLQ5RZiCyAU3a8sTSF3PIm6Nt/KDjMToi5jJGqf/G5XQrl0HRbwgSBY24x9+j1C6dggSF+9IvZ4Q==</DQ><InverseQ>A6hKhKJCtBXzKcDCv0/7fP4mfcJYyiJxAgx0BUpBhaKf5tif8GGkwtkMoG60AoWg76Naib5riXZlIIlwN/lVPg==</InverseQ><D>Ln6hoNk66bJQAsu4cDr7pp9fw3VYhVba0KF1vxs0GXDIcw6AIQ11HZk/Fm9gjV3DDrBo5Rkhl6YD9P5Rj/kWdfwxfinqjhAtJ+BUcEQ8OvKvczDx49IJRS9UlV0ct3ww7ZtS3jKixdcLdACeNpXTQlUI6tBt7vZ1CjYSAKd7yoE=</D></RSAKeyValue>");
			
			createVerifyPKCS1SignatureAndTest("+fREFpfmljEbYDcqm5Cg+SLQAZewxdozxEtMW371y4We0cnkrxolwFq1PmcfP5nCth0GfosY+N81964AAhojiw==",
				"I0RTT+NrZ7t6Wd5BNYR2xS01JRrG3c+S5Yeko4ctjYes6BrbHw1vj7+5l8qBJvRe7CWui3mZC1PYYQHTAC1S9I3UQQPDQRb66WHHASfXWx4gN7kgUDFswvFLB8NJJMgtWI+12lFzNI7fXiFkMyGpu8YR7efv3aCPlLWejvmhlEg=");
		}
		
		[Test(order=4)]
		public function testCreatePKCS1SignatureAndVerifySignatureWith2048BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>qCm76q/D6szXgJpcYyHxj3W/JIryzM25BykDkwcruAPO4fVT2r5pcD4qfWLvpWt35ACbVJYRDV+E8QAFkQfkEkIqz6S2c3qEHznhGTg/GzIcKuUu5Qt0onan4Fxn5pzwjjst/50rY5cwqi3oApgh48F1gSCSCds3Se2dB/iPqbzGgu+cH+lZuHzz8pnsBv3A7uJf+SyzttO5rAVDzJNdVYDZyfadnQjHFmHNmiNKPRlx8fHZCZhTlwGIEPbDfiltZNiVmdcfDf9RhPIs1jV4W/8xms5Y0ojFLyLSp7x1/vpGa+2VizCWxrtB1G2yVcujj0/tf0YIN39hLtfUgYu9Hw==</Modulus><Exponent>AQAB</Exponent><P>1gDBDupjG11/QiYd2EhlABnpnuewFfZijvzlqWqhJH22sNEeNKasisc/OkrQsM7z+Bz+wZ5xdqYRytBlg6QU35noSAgH3L9CfmZUjK+cs+e1NE4fq2lXVwzjFdSmaIMW3C0AqSEPeM1bqm2si7X8aG0A6N9vAde3jcmIKqjm8sU=</P><Q>ySoJ0t5cO65KmR6u0JxngWBrQUAyFrFT6EmUHbgU59LYEaaDNefhMyJBp6NwMe+LGKTZ11XISxdkNSxDoHODSPBVtBlNlw/KyrvU2fIuxnvZHwOdaQ12ud8OHtclTks/C/D6IhOgzPc2QqDzP04vbVU+uG3PqTGRophAS61CXpM=</Q><DP>0YavfxERs+tY+8UiF27aJL06NXEWwIoZeXI20icqWvYS9w/oCRjfeokWaNZzeYlG6ThKXfvpj4eNiAt+OONf5IVmHZBvUjyYt/Us9wnB3YsRqYKME2HyN7LQa8FmpJEkwrH1IaLS6S33f+gdtjSaSwvehiKtJxq0Bsi43zu70xk=</DP><DQ>U8QXlyFU0t0+3wfxz5hxWWRnBSLQOLbas81/yehPfEFGDAOEe7v1AK/xGvdpzsFq8HYk6BAmeW5iIeoutu+i6Yp6haZLsu22ijkw5xh79da4kLuWnpomqDuDy7/XHwUiWbycy/fUa8U9aP1QjTnnceWfWnkPkeq8NDKmA11AV9U=</DQ><InverseQ>1YhK0PJ2/1tuRsquNdQLZOZ+l1a1rkQcfPPM34UJOVD1awFRUd4NHaEhtnfQRCZALql87w3g0S6E6+Pz0esN5/fXKirwpqRkfu/kHVMOKM+vkpS8NKrPgOETd3c9JuwA8quxKAhx/B0uXA/2Kv/iuCkMjaiUP/mxQNnTVnF6TwU=</InverseQ><D>lhtKxp7Gf10CMKWZOlQeUDSGvpPZT7+DHkUaD7Ai8ktT7JcUlvnJHIwhWXNq/3oCtt9jyAl8hzdwb7/ZODCXAUVW+arJwiLmtQjxSZXPnvMH+bJCPeoP3sWT7M4PYOdOQ2fIE5e0F13p7r6zjz1FYwxZWz47ndi0baVQusDBXHzXDfMa8ptpb8cejGXhOzBCuENmiOfBz1gK4KG2Udpga829y5yJyq9A7XKIbBHY2EXt4wVnEqwr/Mh0W8s+MkwR7iB6RftZZQKfQa5+XmMOdSorAYYMQuVR63jq0O2BfGX8WBAVVUmNBiTmqvq1NUM0bYvSuAWiw5FT1neVU5yzIQ==</D></RSAKeyValue>");
			
			createVerifyPKCS1SignatureAndTest("7Tgc6qMlxowfwvV/7TvE3OpOl+YQHUxcHTF1e1Hd/1sYjxbJAdmoJHPGQ8HCcorzctW2AXVL+VbwCHPMGvSU8Q==",
				"CbuimvbNYRi8WGflLUmyUrGxtGarxPhAF9N6vQJpLAmLq1IF54TrkiBerUwi409HlUNpam/DPM0gN9YkM9yQ/ydyTs4hUNzE87WDvvgb13crGIGBYIpgYG0RMQN1M6s8uv5SCU1NAAL+QsjFEXMTVaMwnfRGKufHg3TAIUKa2YsrsXW3HkptAuUaJvnT/zYvcufCGkH77tnCd1VqE7oL/6CagDo456SEhKwKJbJm9Tu2JRc+X4HkLJYo4rDCPwv40fs1lS4tUOGHabQD0UD/Va+kVL2EnqQk7n/QohFRwHfPr/Wzr53O+g7lmxrP6Cvzw8gxA4+g5CWxmal7tHUv5Q==");
		}
		
		[Test(order=5)]
		public function testCreatePSSSignatureAndVerifySignatureWith384BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>ngCnngtOX2ZVL4zmXrR7oG3EgQdzrARrhDTrcW9tEjzF+xugIzkltRR04uQ/lIFl</Modulus><Exponent>AQAB</Exponent><P>zo00FWpDNlBY2k5P1QE8kV2jXxJVPqQT</P><Q>w9QO4qi2o7SNm7zSBFQX8dPBerol78On</Q><DP>vimwRvsTMEEe3LX2t8OwsKDGFXR6ePZz</DP><DQ>KrGAzUmbB/XFKb7wyqDK154jAG609qDh</DQ><InverseQ>KXBom3nRet9oiQg2yQaAv5zOzHOGjwhv</InverseQ><D>aoLAe67ddzwRwss15LO//wbgB6cRV+1lyepH0P/8f/JSUG4s4/yaYgnSHn8SG03F</D></RSAKeyValue>");
			
			createVerifyPSSSignatureAndTest("Of2mpeSdQO+JV9UM0BS/ufzCMfj7nGLQjA1nlT/xjzB4emUHPI+clIrHAE/4ZHD6u/gz+jC/fT7aya2rFJ/mOw==",
				"SHA1", 20);
		}
		
		[Test(order=6)]
		public function testCreatePSSSignatureAndVerifySignatureWith512BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>ufMSKhJ4dX9eyFFp0wAYSXtDjCzfUooXTZeybxIeNV1oZ4gWsWftg97hUV/gjTABY2v4TpbptJFCzeblmhDhnQ==</Modulus><Exponent>AQAB</Exponent><P>8jz/IfI1NWQx98+ztN6xMReMMHUxqIZmP+DeBG2bCHE=</P><Q>xINvnYwpdqLxWkW+4gkkdOx+ZJ3zbLHBibneX7proe0=</Q><DP>wzUucN+ry0vkDIyfh/kRl7sfKQm4K9Oq4H1IzQ66qbE=</DP><DQ>ONuWpczyCkNm9amMazYd+D6c61vQHLjpuIGw153Gmpk=</DQ><InverseQ>b7SkIO5Xb2n9CsRntjAf/J+5cy6Pm15Xs+t6Z3TIgIQ=</InverseQ><D>V10rkJbC/7lLB+SwSpFF1+hQ8R/4AKiekDcQf3zMspcVHYQbYwAbQ4Y/opE2w7hzK5nu7HPruFQ5vF9hF/pSwQ==</D></RSAKeyValue>");
			
			createVerifyPSSSignatureAndTest("DoSG9IHvPpQe6rIfi8CeuWlYlNA8RRYZBrJ7DEycN7Hvwk+5xe09zPev1Il8iiwowKJOjuTZTyrCEwVPhsKtmw==",
				"SHA224", 30);
		}
		
		[Test(order=7)]
		public function testCreatePSSSignatureAndVerifySignatureWith1024BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>nOfLhGaGgw6uYa4wJxy72uzTwnklDu10INyNj40L+Rj13TEEy838hlDqm6Ej3FQWdtr73QERht7dtpHE40QAIofHqKafMP5Mkl/kcAkOcTnXbnVSaSXiIAdUFTI1Q2EVGK+srh8gMnBWx++k2evO7tb+iji7Ei4sQvpVQzNkuJk=</Modulus><Exponent>AQAB</Exponent><P>0ATPOZjzRSgcE0Nfp/mAKjhwQMZTvKZNdFSfCRAhehnhGTTHLiZAhgN8KJaGUe7T5MwHFNWajWLn4fzcHcnTSw==</P><Q>wRjSPkb2J+NcDuxbvdLWy9hm4odOmexEiKpyBvPQjS4xg3vPj85DAkMUGWdAi1ZTCS1ECZn0oIQzX/nU6jrRKw==</Q><DP>Qgr0272Cptc4Kql+Si89kKoAgaA137QQ7TkckN0NM93ZiI4oGq/MVn/uwFgh5wtjPMXGDchPXEolgqssG00Dhw==</DP><DQ>eOYalMWHT5gpxmo0UpiUxhKa8FA5ZWQp0MuvEy1KsWpvs9wsK+S/zcXD6tfb8KG+4asGw2AyauH67KeWqITk+w==</DQ><InverseQ>CiM9+2NRqkFD+xTbSeXJSZH7bVN8AMwXKsnIzXZYdpwMqGJGtXG15fOBlXcGjn/9YkKgEbj0CQowlPoiAMz8PQ==</InverseQ><D>ZYYiDGBeZsyIDtIrfBM+hfA5MJs8XEVOn7i1rA3CkoIRC/ccuFZnL+2Jb/u6/WQ3SN52m1CGq7Lm2KvHLpogTzPrXkxkHgWhjz4f/8WnDuGNzPmX95/KRQjwa4VITfACFg0QqnwITNsBK1WkRlNg2UYwS91SwMfa91F3d7KzLzU=</D></RSAKeyValue>");
			
			createVerifyPSSSignatureAndTest("DzBvNQ6XuFiVukFYuki4aMG7u2CUbr6UX98qli/Y4NxkwcNDnZsJnKiaqZMltBSvrd91yUj7ByrFYVWfqYX2mA==",
				"SHA384", 48);
		}
		
		[Test(order=8)]
		public function testCreatePSSSignatureAndVerifySignatureWith2048BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>t8j8k9uO9ZqNZCn8/FKTey4mWD3jVmwuWh1O3WWpaNhC8d+cjmRy1h5+NtBTDe0OUAu40RCLjmiJCsVJpb/GS4bRsYGJ5dCslppAeW1iRIPFBIO71SNHVYHwm++GDprt207sOmYl/WHBOvS1+tGp4X6Ap7lngRacN+3HGkO1MHx9jlAGmNdtitQn/ikcvbBDmrlbzjqBNhKEhuyFOlQiNc6HqUqKuTqno9+x/wJnagxVYh/VChfFDxnjXwpj7cZrXrxSIINGV1zM6PX4Q9m3z14YJBNOBVleoFjBBetb8RPGEJmI8mAvCsarngiUe+eVGvzFa0VCkonsnWgBm6jbew==</Modulus><Exponent>AQAB</Exponent><P>8YFNKmM5NMwrpezNn2IjJlLQeMVli+JfqJ0IcvihPKgSOgVXiWHXin90Va6SUuRKIFzsMK4b/A9npDTfx/SHIPyVRJX1nNdIHCNueg44zW1MsI9wOBxzCgLxD+FU9Li8/mUWaIMFvOPVwXHLsTYuVs1Leumks1QTEEwSZFncHDc=</P><Q>wtDS/VBkOXVpuWvYCdHbNUxp1Rs76JPcw9EKAK8DRU4tmQZ7Quc8WbKBcg9qWFwp8gWRaMTBhlJL0Y4Os7bTYOWiYu0m44SdR0BKLC72mhLbWwwmsTHmrt1De4Ex8Bq0rODUNTG4t8lhsHcbPzJmbbuROyPJ92wH7Bxklr8/gN0=</Q><DP>ykoDR+EK9uWaHgbHiZybUquFgdPephg9BjBa9mq6K+OgOMdmtmWlNJZj7K0oVZRxXsBW+sOsHysMJig/1e5GDeRkZ6mwrOpKtX8cN9KX08KcvTu4xNdXqOgj4aheEAp6DCDCb1JoSPsSflGCS/LVR9H4SoFQewGOYlVGBpaaX2s=</DP><DQ>Ja/MASD6IntqNmp8YnnsVAUyO/2Gu1lPTbo0mylAEroq6/1q/uhIrnlvvSbqRamem6kkFgZqAZgN/r3ibjWh8o65uTVzXnQbENuI/b8gCXI4aQaSvZiPrag0E8JMbMxdw0vDAX9a4oLcmQyRgso3MmckkzI7Mdf+OFjNxLO+jyk=</DQ><InverseQ>wzu50ckicjTJh4H81snGvXSU0E9CEeDGdQ7qIUsAdtioNCjxZsLiR84d9d8FH+gwUSJi0ABDg74Qx8YB/Z3EuUtL+ztrYCuS/ZuRKqBxxRLNp5AQrVhglJEO6IqfBVafPG8JfgbeVShbs1+mQFuKFOVRgj6k0GPGiGaOEx1kxM0=</InverseQ><D>e8Do4x86+oLhporngXiROqbuxwiVZoJeC+wkSMzF8IV/PqOWJgPZl/jcgEhzRLNVqezavFxpvLEDZq9GUkf6XK0h0mcp1ghXzul7dMiFHSGlrs6N0o144UkoHbiCCp+kfsJ8Ky7Rcfc7SFmzmHtJ6z9lnosn+TKiar7ADR1+inCDxPVvH+eX0Vhnf5wuVo/nZ+A8HruqbBrcCw/8OUvtmh6b3FTfdWGExdX/GV2lQFT4+G3jtodSkrSgJjhcgy1rAZ/Ly0WDFztnYILUEwzoGw6IDffFUbx/fgxj2ewykU+wvr5eRRf8CDgDYcaPVzuymlLgRg3UGaz+LogGHC7D0Q==</D></RSAKeyValue>");
			
			createVerifyPSSSignatureAndTest("j4PG8p/YPiG+jj3g2lierhH/ZZIg8zvmx+iy5qByIk6Zc/rAdVSkZHo0F96ZC7PULu8lFRZg1gB8LvNjcRB0Vg==",
				"SHA512", 64);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function assertSignatureVerified(verified:Boolean):void
		{
			Assert.assertTrue("The specified signature is not a valid signature for the specified data.", verified);
		}
		
		private function createVerifyPKCS1SignatureAndTest(data:String, expectedSignature:String):void
		{
			var formatter:AsymmetricSignatureFormatter = new RSAPKCS1SignatureFormatter(_rsa);
			var hashAlgorithm:HashAlgorithm = new SHA1();
			
			formatter.setHashAlgorithm(getQualifiedClassName(hashAlgorithm));
			
			hashAlgorithm.computeHash(Convert.fromBase64String(data));
			
			var signature:ByteArray = formatter.createSignature(hashAlgorithm.hash);
			
			Assert.assertEquals("Signature was invalid.", expectedSignature, Convert.toBase64String(signature));
			
			var deformatter:AsymmetricSignatureDeformatter = new RSAPKCS1SignatureDeformatter(_rsa);
			
			deformatter.setHashAlgorithm(getQualifiedClassName(hashAlgorithm));
			
			assertSignatureVerified(deformatter.verifySignature(hashAlgorithm.hash, signature));
		}
		
		private function createVerifyPSSSignatureAndTest(data:String, hashAlgorithmName:String, saltSize:int):void
		{
			var formatter:RSAPSSSignatureFormatter = new RSAPSSSignatureFormatter(_rsa);
			var hashAlgorithm:HashAlgorithm = HashAlgorithm(CryptoConfig.createFromName(hashAlgorithmName));
			
			formatter.setHashAlgorithm(hashAlgorithmName);
			
			formatter.saltSize = saltSize;
			
			hashAlgorithm.computeHash(Convert.fromBase64String(data));
			
			var signature:ByteArray = formatter.createSignature(hashAlgorithm.hash);
			var deformatter:RSAPSSSignatureDeformatter = new RSAPSSSignatureDeformatter(_rsa);
			
			deformatter.setHashAlgorithm(hashAlgorithmName);
			
			deformatter.saltSize = saltSize;
			
			assertSignatureVerified(deformatter.verifySignature(hashAlgorithm.hash, signature));
		}
	}
}