////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.tests.crypto
{
	import flame.crypto.AsymmetricKeyExchangeDeformatter;
	import flame.crypto.AsymmetricKeyExchangeFormatter;
	import flame.crypto.RSA;
	import flame.crypto.RSAOAEPKeyExchangeDeformatter;
	import flame.crypto.RSAOAEPKeyExchangeFormatter;
	import flame.crypto.RSAPKCS1KeyExchangeDeformatter;
	import flame.crypto.RSAPKCS1KeyExchangeFormatter;
	import flame.crypto.RandomNumberGenerator;
	import flame.utils.Convert;
	
	import flash.utils.ByteArray;
	
	import mx.utils.StringUtil;
	
	import org.flexunit.Assert;

	[TestCase(order=2)]
	public final class RSAPaddingTest
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
		
		public function RSAPaddingTest()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		[Test(order=1)]
		public function testEncryptAndDecryptWithOAEPAndWith384BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>tvQjwt+yyldn3qIcIfZWf+Hl86tWdi0g0IJ9Mcpa9bgjKIFuBolv4qZ5ZZ5VWB0r</Modulus><Exponent>AQAB</Exponent><P>64wF30vfB9/9P9nAACcdtZ96X4S2OFub</P><Q>xtcFBfqo17ShPIyy6EqQ/rAjKbYqEEWx</Q><DP>tn2ioxDuN/SzCcATwEqN+wQW1GBGqT1X</DP><DQ>VV+/JWkRk8RXsnLK4lgZ13DzOBaiCuiR</DQ><InverseQ>JGUhzgB+yyJTQQG7NHC9JZ3GdkPhicgx</InverseQ><D>KDuQEa631p9aDC+CGEXfx8eZlfg7z0kk6q7np8Pli5zL9D0KtBdtOA+J0fFdMMaB</D></RSAKeyValue>");
			
			encryptDecryptWithOAEPAndTest();
		}
		
		[Test(order=2)]
		public function testEncryptAndDecryptWithOAEPAndWith512BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>moenQ6fxQIsnl2Xev7xxGxTpF/dMWRuvjzKsLBxpdtxajbWh7OMbsp1xwZxCVGU8Vk7yZ5cuHgjj0RRQDT5Otw==</Modulus><Exponent>AQAB</Exponent><P>yEvcMfm6ztLfJvnE5pMskqxwwaZ0cuzmO1y6tQ7XFds=</P><Q>xYFxOnr01L/cWFK76Pmf95viAWnAWl1YhjfNiGUGN1U=</Q><DP>oZbR5l+anhDxhvgqKfrCEvKbZR9tAuqsM2f0GO4IB9E=</DP><DQ>bw5ZD8whrRtxGAz1cowiwgVaMPc43NcONvJb1O0RcL0=</DQ><InverseQ>pqGAcPCtHwpO1jasfOAly1d/WAciOLZ8zG9ogAEI0Ug=</InverseQ><D>RDul5b/gTQmk37sBklQY9UZUblqqAaax7F8JmyiogOy4ADWDdqHzZtCUCJWoJu4LoRU7qjAsZRgZ6fZHuCYXUQ==</D></RSAKeyValue>");
			
			encryptDecryptWithOAEPAndTest();
		}
		
		[Test(order=3)]
		public function testEncryptAndDecryptWithOAEPAndWith1024BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>reFjQNvkKFWCiGzVxUyyjem5lLccTkTOLouHEqxf0h7eppu7QJ+SnjpmhfjvY2WETdpWkp1gn2nsWI7jzEqzwewPu2QFjRkoMeLHS1AR5HJmFTsUZcPjMq/lNCm72xOCJ6sOA1a96pPJJ2L6wld3KOhgHpK0nCbFoWdXCd6r+X8=</Modulus><Exponent>AQAB</Exponent><P>2jCCPAOGUf+phor4q6z5LtJNx4eUsrhMjzpRHL+4sIxAPB2gibJzrl6pd0M7pDCK9pKZeSbiD0fNa5s9Me7UXw==</P><Q>zAM0r5cUPRd1G6YeDvBbJ5aWTIJA0PxfnXxhTZ8zwPVB2X7pLj7lHB7kruMRn6iFyWkFjT7SznIQfVfIRo3u4Q==</Q><DP>XvytRdk2+a22rMcFeR+ln5eYmtvQhXmsgtIdi8l/awSz1jgDss6IhAnb9vrDFTi41p19yPt/gK1+pXEA1CMoOw==</DP><DQ>pnYPLR6WsupK8Y5vhDz2A61JYY/+Fwd1dOih9FXsQotbeX2mAcfr5TAH4/L+1EkLMLXyg7c5Bp3nen5/uaHhwQ==</DQ><InverseQ>mp7xfUD83A4mM2buStPp+66nvTJhgClgD4S2s7lNzTydJ6jVDuAzvtXK+pSxOYD8rxnfv398XjrG/b0J2meqEA==</InverseQ><D>W/l+sM4fj547n8JCCU0anapl+d4p4NTQYxp25k+7l7+wclyp3fMKcRvfIzqcFe2a4Dt/06nfdDNpSya6JFPXZPsO+GZh281gXtipG0N7FsdXVGqcUdVBRvGY5hS9KZUT1oKINZbkCrF5haMBlrQ7yfeDwVwMWJbw3AW9Df6nNoE=</D></RSAKeyValue>");
			
			encryptDecryptWithOAEPAndTest();
		}
		
		[Test(order=4)]
		public function testEncryptAndDecryptWithOAEPAndWith2048BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>11S6eLgLdAz4FhGF7DAiiFty5uM5CNtXNnUWS6o9p5yirJnVXtLDjNT0RdaLhuDxMKAzKCtimrv9OFEQJ23bmFxoVDUWyOqpVyUluj+DopafksuP5IdNFUwXYSL8vXNy3sudwywfolB1di74PqpasHSwg4bOmaDPSVG9xb3AONcM+0sXeleiyNBJoXA23bp6IZRm8w+JlRfKW/KYPQ+D/ZvxWpPLL0kJvdREdPBZ33hr/2Y1I95XrtV4oKakStZyBzE/4yeHaVomuqu+qqKG5vYvukmOpt3szHYGwM3AOjR05KndP27loCm7k3PJ6S5l56vmYDcuaZ/YT6FFIGQNAw==</Modulus><Exponent>AQAB</Exponent><P>/6854REagnug6hJjnUmKvWS7tXw9gQH08aBrIf3HagMavFw+JyCadI3xoWUBzAsTrBGdpKKHRC6ypyJI/0qE22+Xohw06hlk56jTZmbs/xt0f0nzo4fbBwEu5l2oOS6EHLYMb5VudrH+U+8pzmMIf1dTNm7w1Fp8NoLa+wsV6Cc=</P><Q>15jBDz846VtCSVJFs2dMlM2gAd4dZNRuEhVbAH5nKcqCWMIxkW9vaGdQvHIJ8G7P4scP03KakrS294gZkcByla+9xRL+2rW6cK9GD5XSgGtbJDbGpsFzLkJJsTnCa3kSiYJ6oRdduYkTk4vLow4pGpvuh4OKUMQdMy+yuK5FwcU=</Q><DP>hIub35b0PSxFsNIznbggGip8PIrZf2U6S4AzyX07wTM2yuquta3rI/zphBdOpS4g1pSTOmOe57OlnYrieKVy1ia1Xq5sp+beLlGQtYcp2N2suMfna6Dj5G+ylm165Zm9lvyw2a+HgjSneW+EJp+kKg9k7dT5N7xopAGV74pBowU=</DP><DQ>z0v65VQevpGWrLVEe3lpcvI7VVBh5t8yboTGGTVwsAgdSIZ/7py8/B/Ky0bDM8D4dc588wyQf1rvShY8r53hDvgJeYIINfbiKxL8RGQEIKIY4jsgypnay7HE9XjZ7UhegIVKr7Wt0oVwoz+ZL1CgSQuBUB80UPAgO2UzbMt0Gxk=</DQ><InverseQ>+DVnVvE0UezOarM30YFcmxEDpoUJTva1yCcHix4cXEZYjPwqmDOjqdvA6I4OquCG9Ilw4UFcAVF7q7uVmNw7GjXEsBH6jZqiS6IZRwm9Hped2jwNa5oWvLDmI2d7+dI4EaVylBs+zw8o15L7t2WN1Kptzxs2lW4PUpCjGBIn/y4=</InverseQ><D>w6MIVFuqlEKgN7St/1vwVAD6EQoKrKBTyXdxzUccAyfNqJGPiTpmTpLAaJ83X1EJ8Urrj6hzSvBXbQ5BZgFqzS/P3gnp7Js/RZzLfT7tgw/kZUOrNU80WpAqgad/B0VX7VIDwOpax2bggYLFKnIuOTmbkbQuCuhOzGeGypzOgxQ7WPIO0x7HKOBmHsv7Hnc3tiHDcDNWvhKSlTG5vobf0kt0nvOLM8H7FzNv2q51znAEyYR4yGW9gpQ3kIZjEtmygfV9GmnyuZuKHYaYn9uvvMzpA/bFf1fuwXi4wVp5F6lmt4BaazOHKRUQLzzDdihoyWSV3LVFoDN01iOMLJczKQ==</D></RSAKeyValue>");
			
			encryptDecryptWithOAEPAndTest();
		}
		
		[Test(order=5)]
		public function testEncryptAndDecryptWithPKCS1AndWith384BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>p/dMsvOehIKterShE9eKvaJhicRCf/21fRvI2m+YKSkb6drOq/EcPOlw1CC7/wj9</Modulus><Exponent>AQAB</Exponent><P>0r1IsLJbGG9HGnXpnQbeiQ7ItGCdMlmZ</P><Q>zApIIhmEj4crMB5bv/F0s2Gkv7qJ5TEF</Q><DP>rquVBF/QgYA6PwRcjXqUGKXYVSl/IayB</DP><DQ>ZUyhfVR/7KYl+fDIimX9E2Xh3lJlTcVl</DQ><InverseQ>0k5R/pjG3RLHuBLv44VQn7/rycOz3lwA</InverseQ><D>k2ax94VWAkHPzhRAG3KXPe4HnOgP19SkCaNs/D9QRolYU/+JtjUb5/9K1/RuBW1h</D></RSAKeyValue>");
			
			encryptDecryptWithPKCS1AndTest();
		}
		
		[Test(order=6)]
		public function testEncryptAndDecryptWithPKCS1AndWith512BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>6v6Hu8j5Yr4NLBmH4c7rYJ4LtPrWoGF/BiRTV4PbW8NcKXvRpsQ5rufFCoXtCNHjn0QFaxZRPgI8ns+qdZ3SfQ==</Modulus><Exponent>AQAB</Exponent><P>+oF2wR6vzdtZHQnKii1CLXeRvPlX5agkR6dmzF1l5/k=</P><Q>8CX5CNZXO3ej45Ck59E48TrllGD31Sp4X46UkIczh6U=</Q><DP>7SWGoMhGMiGHOUA9p5W04oohQ77hAR6uSc8mOC3q/TE=</DP><DQ>6kcxRzTLjyEtinDu35SV54hctj9PJ+8x1Y8kUkcDt10=</DQ><InverseQ>CjpNLhshwDdea1W7AH9Sfu+LZPFJ37toNfO2mF+Rdn4=</InverseQ><D>hVu9G8yJ+odwYj565qLO4R3P9v0DIDE0LQAga+Hgcsns6Kh7FVsQPpmUsSeQ2+UyDFB/P6XzZy9XAw64ljuvAQ==</D></RSAKeyValue>");
			
			encryptDecryptWithPKCS1AndTest();
		}
		
		[Test(order=7)]
		public function testEncryptAndDecryptWithPKCS1AndWith1024BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>zyBejZDfk+W+TRAKv+Tv+ant0/v6QYfKL4yIOWMzis6aMnY26z/b5ov74oZ3/1MdtYPyeKZX7Hn+miGN16fmG1DJCy7SRXruSFei10KpCcK4d/kk1s+eHZipbmNP+oDRg/f11edbBjZ/p+NX7n7AcCWNOltwUnMRAZme/6yRI+k=</Modulus><Exponent>AQAB</Exponent><P>78zQDMqYRRzXOLR33mhW3tQWVLOO5bvbPuTPH0hSq5jYt+ge/aJsf6+SAR4K5FJ0QhjVamkxzKnal53sUegwlw==</P><Q>3R582KVbbG1eBIy+gXFM6mXR2Ns3KyFKl7wjjrOkkL3JFTxOcGzSzBIigzNJD2TCVQByZU9YvArR4LcGpI9ffw==</Q><DP>LGMqA6QgqXJcOEfXhFil89soQwd1pPqv66Vo3W6Ctva07t3Nlr9Q/BWgngpUk8zbbjywjGDqceri5nu5+bNUAw==</DP><DQ>1zpozTvPDHA8FnOkrzxIYNOw+cMPJQUnpSA1AB7t7RE+XFQyCY5zdL2mKEzQLZKm8bQYpXIhbg+eEHw2lBEWIw==</DQ><InverseQ>E4fi4M05e3Hsrj/YVO1uQE03WVIGA0Y1kr1ntoj9kN4ghmz/PUmGNwRt+64eidABam9xo6BVjFPijL/TDZIPiA==</InverseQ><D>JstmSlevOLFYUnDFwqlrtTR5wjG47tszKHLG9RC6j64gvYDcynU8h9MCS6xp/12e++eJ28U0RKuY31+XhKQC+hZzyvdNvgndf6J6VLsGo4/2f5JfOiWwWPdzxU/yO2ZxKblhXZMSeWBwUYwj3YBbKveeifhXZM9lmeBRUU4uPj0=</D></RSAKeyValue>");
			
			encryptDecryptWithPKCS1AndTest();
		}
		
		[Test(order=8)]
		public function testEncryptAndDecryptWithPKCS1AndWith2048BitKey():void
		{
			_rsa.fromXMLString("<RSAKeyValue><Modulus>thcMD2NESmOMInPzgNtHLlg9PCFA4P8XOXqIiPxVWoLtsgVcBR9Ti8Ki5wuHUQ4YLws8a3XAQv/UAdmuaQL4+UsQ9bafz9c5GxD8dzzGlRZYtDJOmNlcCidTmfqsi1QcNDBOyGRkep6XFUxS7q25O+YPoBPUd7iERHVkG7LomXBRvns0MyXlyxa5fNmU5hUb5p8fQRjAaZ0Z2K6Fozs280An/medrePSLZsCxHu74E30k1eIEK7M63E9weU0CywMrpM/GenVunqxDJkttz1bgDIeFMXdk5KalYVIBh5/MxS9ZXvJ7mExn/UmLZbuE4bgro6SyLZDWZrqrWthaPRkoQ==</Modulus><Exponent>AQAB</Exponent><P>7iqx+9m1deVhF+u0txrD7MzgfHJ4Lgf6803+G17IX5fC71Y239vZPb79+1/XqC+k7wh46lE2aUmaMqwqakSvCdYxLSuHizbkdcP3CwvuAsOO2ww4xWRvreYO+Bpqzw8aALP7RMLA6Nz4d8DbfSWPGz+V/F6nlL4eLaMa1Lpfs70=</P><Q>w7lxir8r01lokJQteqfQdavdLMOmxZOuNRiaboeFyhZ2VpnsbqfiTetcrtcIXhciceIvQt6tcCJdHdm3H+MhUo6WgKyRWICAegmphMm/Y7ukn2JVZQcK/Emms4BsUu1ChN6KYF0mbF/vtWFnsRsAxuwWmn7JQhvuymD9RtHwkLU=</Q><DP>qL+hmkO4Oc+LiupcAfy543eKe0KT+nF3EpspN3Vh3bFm0jOw784Sz5ga1tgisi0H3MGRAt0GA3W+BrdL2j3OE9cqwsl74VzEZNizmqUaP+UVvAid1OaD5qAB7TKyiQE3OFZN63teOeAPQLJqEfLhwbm86LKcZFyMf2N4qE9hbbU=</DP><DQ>bdSaSmmMhkUd0EPWYYXaDK4spvoDk8uTbmgoAO47vXNtZJtreYzsCR2SHOq9307MHWv3aWbbnJkr95w8jsA96r3o5rvvs+IoNlNFtSYhKC4b6vSbRt305C3QRdpC7yYEtdrLe9fJv/b15KqMLW4huX6yEHAlL9vM2/QhLKSSgiE=</DQ><InverseQ>y+GR4UY1Q8UFrtoRcMReIdiQT5og9Owx4rIuIaJ9mn1qmbxKOMH2C4vI2Wg0v4YrvHfsuZjwnmtU+0Xhcrj/KmDQpMP0Hu3jgOJQvWWNshYBUpzrT887lrHxu+koMsQOzbyXcnIurGmhYvbc7Yk5MZqJujEiv7tbgDiojLY2NtE=</InverseQ><D>Cz/3RcgbQwFNeh9xzuc9SZa4CcwAJyZ7d9ijMNtuJo5qQxJjsglSbxMSX3Xt4UseoWFvVTBMNZd6sLaTOPevDC/gF142F3AzngF5p6BAoJtl1ZQ6GOVs80+ksaG0IVOL/olxhJ33O0ArE2zIvuhKxnGbS4eOG+txeI1MJw3xovEbvTCnkB1nEp/8SbS7Ekl0q14/ncP7LEpDA4pqKCz5Ieef9cOwpGkimh9SmUUifh67ZrOWyMahLqIIzylmyJ40kQqbqdZP7XLdopdXocT0HSCeWbmdPv/joVanUlVxY90TzdvZQEx1GkWF6XY+JrmN1eZCWzHJ10Oc12tGqLAXMQ==</D></RSAKeyValue>");
			
			encryptDecryptWithPKCS1AndTest();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function assertDecipherIsValid(data:String, decipher:String):void
		{
			Assert.assertEquals(StringUtil.substitute("Decrypted data was invalid with the specified key length of {0}-bit.", _rsa.keySize), decipher, data);
		}
		
		private function encryptDecryptWithOAEPAndTest():void
		{
			var data:ByteArray = RandomNumberGenerator.getBytes(_rsa.keySize >> 6);
			var deformatter:AsymmetricKeyExchangeDeformatter = new RSAOAEPKeyExchangeDeformatter(_rsa);
			var formatter:AsymmetricKeyExchangeFormatter = new RSAOAEPKeyExchangeFormatter(_rsa);
			var cipher:ByteArray = formatter.createKeyExchange(data);
			var decipher:ByteArray = deformatter.decryptKeyExchange(cipher);
			
			assertDecipherIsValid(Convert.toBase64String(decipher), Convert.toBase64String(data));
		}
		
		private function encryptDecryptWithPKCS1AndTest():void
		{
			var data:ByteArray = RandomNumberGenerator.getBytes(_rsa.keySize >> 4);
			var deformatter:AsymmetricKeyExchangeDeformatter = new RSAPKCS1KeyExchangeDeformatter(_rsa);
			var formatter:AsymmetricKeyExchangeFormatter = new RSAPKCS1KeyExchangeFormatter(_rsa);
			var cipher:ByteArray = formatter.createKeyExchange(data);
			var decipher:ByteArray = deformatter.decryptKeyExchange(cipher);
			
			assertDecipherIsValid(Convert.toBase64String(decipher), Convert.toBase64String(data));
		}
	}
}