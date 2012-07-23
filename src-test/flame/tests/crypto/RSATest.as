////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.tests.crypto
{
	import flame.crypto.RSA;
	import flame.utils.ByteArrayUtil;
	import flame.utils.Convert;
	
	import flash.utils.ByteArray;
	
	import mx.utils.StringUtil;
	
	import org.flexunit.Assert;

	[TestCase(order=1)]
	public final class RSATest
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _rsa:RSA;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function RSATest()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		[Test(order=1)]
		public function testConstructorDefault():void
		{
			_rsa = new RSA();
			
			Assert.assertEquals("The default key length is invalid.", 512, _rsa.keySize);
		}
		
		[Test(order=2)]
		public function testConstructorWithKeySize():void
		{
			_rsa = new RSA(1024);
			
			Assert.assertEquals("The specified key length doesn't match the current key length.", 1024, _rsa.keySize);
		}
		
		[Test(order=3, expects="flame.crypto.CryptoError")]
		public function testConstructorWithTooBigKeySize():void
		{
			_rsa = new RSA(8192);
		}
		
		[Test(order=4, expects="flame.crypto.CryptoError")]
		public function testConstructorWithTooSmallKeySize():void
		{
			_rsa = new RSA(256);
		}
		
		[Test(order=7)]
		public function testEncryptAndDecryptWith384BitKey():void
		{
			_rsa = new RSA();
			
			_rsa.fromXMLString("<RSAKeyValue><Modulus>4B+hrOs19uVP+SfPy2/PP/QTeswxbsQzLGOcDl7JFKOOOmAHZPPkVWb56tsS1yGV</Modulus><Exponent>AQAB</Exponent><P>9rWVCX6mNv+IR/oJqlTTDjWH2OCdBA7B</P><Q>6JBPWbN86oWEC2dE5jX/G5r2iirjiJvV</Q><DP>dN7UOWk7yDYJEz/JsFz6lnKZZg4Rk8iB</DP><DQ>MG5dGAEY8n37kaRf5NE53zXWQc/MspZB</DQ><InverseQ>2OLO6JIBQXDjEdgEJ8C42oH6z8WHFKBZ</InverseQ><D>nsuKn5vfllkO+reMcNV9gBCNJLo8ZAC59auSkMOHqOP6ohHkHwt7BksOp0EYo44B</D></RSAKeyValue>");
			
			encryptDecryptAndTest("gSJ6/C8PTfQzNBQ5hI6UT6bNbRw8zgf4scXnwWA56Qg=", "rXn+mI/57zu6L40qhqfIpTy+KYDfGaml09z4NpyuaQZb8vO4xXPRsIQVRyJtHAC2");
		}
		
		[Test(order=8)]
		public function testEncryptAndDecryptWith512BitKey():void
		{
			_rsa = new RSA();
			
			_rsa.fromXMLString("<RSAKeyValue><Modulus>sKz+cv0xK8L97iy0Xw5Y+6AF1x8J46pnw6DP4fMNbvc0GAEp89hZZQKCnyZexmWTGxzzR1miEm7YxFjd5xVEKw==</Modulus><Exponent>AQAB</Exponent><P>3NxvePo3mG4NMgSlypBFxbv+Qt+FyODOpOOQwWY7RmE=</P><Q>zMjpcpidWkPMWpFLPywmXdp5N+t9AupcpUD/uKTV/gs=</Q><DP>FgNSiPhHekXdwtJ7w8jFa4PlP70PlInzjrOvxdbuqYE=</DP><DQ>CECcb7rItIeA57FtN9l+nk+cjO1Xd1OccihhZb52xSs=</DQ><InverseQ>pRKrmBKVJKFXQUyPZExC2NXjR0WlkodI3UmotgEAUDU=</InverseQ><D>iNQx7FRy9HV7vC4bM1MlTxtL6qM7QXsECdpNpaxbRwgbRVlPlkrQCwk6Iz+OsL7hw1VzzrhiE6camlzUGd1vAQ==</D></RSAKeyValue>");
			
			encryptDecryptAndTest("rSEOrzCsYWypuqb6g2/6fjtOh0dFxGkOh+ONd0CiCp4=", "kqUgvw3f/PAYSRsJazJumTBzyZ90T/2ddlbazpjLV6RNXZpdwI+2sVYKAvXsLOPuM+MUuyhqjTMcA9182BP39w==");
		}
		
		[Test(order=9)]
		public function testEncryptAndDecryptWith1024BitKey():void
		{
			_rsa = new RSA();
			
			_rsa.fromXMLString("<RSAKeyValue><Modulus>qr1BbKjFxOBCVeRfxL9dv2KitwiuBjKegVLIcFTFOs3gNOiK0NEiicfbOFL0WVJHsdvCk9cr91rcs0g7gDlpCmF1S+ncslqvGRgNB4CxswXNAADh9NQ3ntmqlIfb+oFuthtE7sFi/1XtPb73+629NEViyslsdy3MXjLKGCYlFDE=</Modulus><Exponent>AQAB</Exponent><P>2HL2uCFIO/0hzX8o7RiwBDnpCVfztdJnuABnbnwKzFkgAQjMZ7hjK9hHdFerzGM4IUmGkfauZkqvVJFQ5McHrQ==</P><Q>yfAVNaWOmj+XwmSEe2/chUvAI/Gf5mBN8qqzJ0d4/GFqBJyNM23I8S0juB2oZCp8EaRhJoBGOYuxtAj0ueGfFQ==</Q><DP>IzGOLCI9PIPMGz2xydtZw1YnLf2/ArFTa/ek2bIRj2hua7yif7rbZSWleKVIqdL4LXFnEBSsBrXeDEIUhR5XgQ==</DP><DQ>UcMCY2k39t4+rPeT6IKfL90+247OZjGh/dn9la7Lnqw2h813IlaWIIhdSQPBFWVaPK5oo3UWeeBEwBdMNyLSDQ==</DQ><InverseQ>db4Js7456mhX/qESrV8IMQYlpkMaeC5Ezn2+XIzJzHixVRpfpp4r3Fw0fUXZzI5ni5RuSO39UYKCCFm+uZiU5w==</InverseQ><D>W7D1QKBGTRtOJIhXcfZ/JveWgIsVwdhPTQ4i/EhZ/uFvBZrYaZnWXX3J2a6a8JkCTZ7CGNkWEGloWpNw+MRcBsltyJTdPB0duvYJlwuglb1qJlPN4m/OG1gU9O0xfBhnEcGvCM8XHSvTOz9ZEQ9mgfXndcW2wxzvvLx6ICqIhNE=</D></RSAKeyValue>");
			
			encryptDecryptAndTest("gcCyTS+hA4djVMFIumwT71vWwHANF6681TA23png6z4=", "A2EIlExQJRXeIao8mr5niZkfy89yPezqWHwKrk6/jRT3NlS5P20H2P0pP/SGxo73xQC1GacTBPDbRkWc2uK/d57G2+1Vpfw9/xGf+zFdVCJ+ibPi0Mh1YIFASjzAZ9VmaF0YusW7IG0vJxAM6ezOWPUCA0cf033MtHS7PnKVyJ8=");
		}
		
		[Test(order=10)]
		public function testEncryptAndDecryptWith2048BitKey():void
		{
			_rsa = new RSA();
			
			_rsa.fromXMLString("<RSAKeyValue><Modulus>s352yryMBYJ6nPizyIne/U7/1Xn5I6uKQYW78ngQJPxlzW0NUCc4ozWrFjLUyTI/3hM2+4LjoWe6pTgioUd+GnPya9TOodCGwPieAMOZoNcDsAPWrlBtByR5ClBi+UOm4Xhu5mJeW+Di807RrMraq1zY1JJDXcszTg97va7eldW80It0PdFJd8Yi45q205o94igWlzqEYNG5kFxW1pU5dOhHMgTi+dgkDdIUXkr0LWwz50A5bndaG93LFMql6Jm2YZVndZfWkdPE35IGR9/Yv3O4HAPSur/e3vCjZ4bb5M78s7CMeM8fzRW8l+XDUBaxlZPAfjffD4EUQFkFbnXGdQ==</Modulus><Exponent>AQAB</Exponent><P>4J344nzEik+GJYG28GqstGHqoCwJ4Gja4AUED/EvBVKd4v/kO9mVk198Yr81Feu6G0YLV+OS6dQeq1rd10EQqP7JWUqIINlnWhNfJGVE3c7DQwioOlpIvg6RNfXs0y07UDZkvx+tSF3hXPom2POagdruN5aCYfv6SrZuuyYO0k8=</P><Q>zJKLdyTo6szTq+oXOzuMg0j2Ll64aYkr/GQw8AWQuTwoa5C9uwJ0DHEfGew4Sl/bHNxWhSavv6Hh7rEb85qLI9kQ50IhZZ+uXntQTsgZK7mbyXO1zy9BAIVJ82jofZakw/Jbwtb5RuQfJuj9UhYkkmFxe6ul8UuktYF8DOyzffs=</Q><DP>tfpGcfhzozrai/iTpiRG172cwTfsqItLCMQHjoLwfXd5wzdeSb72l/d8ZuRStffNR9tvxTzzAc6BKoLryEFGpiQGLPldYH/CZA/dvTbunGWvfNe+s8gBtzlGHFmqDU1QCKSI6u9XDJJCy3k/j/WM8DfXV+HwsEHdfjpfa/BhgbE=</DP><DQ>nzhv1AumPRmupd9MtY1jj8r50J1oaruYwJg6fpXWTlXEH/RHt4XxTL2+ty5joX95yryzmm7B2yTj9CNk3fUq1nvb7CJMXAwsat0PZEHZVW7hEao9l0PwE7eqFwlP6m+VTe0T/lHTMpnapS4x+/HABS5SZS7zuRpm194v7t9L1IE=</DQ><InverseQ>ViW50sdI99YMXpnE2+p7s9w9h6SmzCruWL0bOFU5U5WsV6rNadxjpVRafpc5y6PwSyW2z94SvwVBf9dHG6vCVGip5ben9AtsFppyy9q4w2kEngObpK/oirLv0X/H5ECKBvsISvQWL8WsrAhZld12C+FXCIdn8ZdXSCt16yUDhAg=</InverseQ><D>p9+JXsfE9Yo4/wKjstUvlx4BrDjtyGyxW+KmC3o7LzxYQi7SGrrz/8E8CAD2fk3e6eZyr/yUxOps6AV+bfSdfkQe4LchormSrnxX2kMWNhWiv0Z3zIQv1FRKWFkimBqrw4iNwC8ULT5BRGndNIxsw4SMzxMUqm5Xx5Q3mQop51t0WakLPClOfUrrTu4g5QovdBfYzMDNdb2J5Qqn96SD0yTGkrogNyhlCZM7gfA2VSxqQI/vPVECPb6IE8Syeo4nk8dT9tqcUue8QRIHnuz1ToComyHE75+9yDuH7QWQJ/cJypgCXAVwWoQ4iuXdczyST1GdZyTrCMDrF49zF4ba6Q==</D></RSAKeyValue>");
			
			encryptDecryptAndTest("H05ytUGJtYN8PaEdZHviB9FyGuBf2vIcdNEWgIwDnsM=", "rb3gliRudxB6QCdJTkR774mShySz28EmS47qJC2fpo9hNIVXjMze0grjspGts0J0L5/vUE1sfxsYo3x9HndfQ0TRpIrOO0LmFSqixBSmbq57I3NdXyazVKaaFzoJzdIRQE0VnzhUtsD50KLxxF1hLKtXTqkFNy3CdUDikQCvJJw5EK9SYMPo6tG+3P/ptmqlloYO6EbX2YB/FDqTbYmwVMUpd3j7Fdo1C+m3gOrMIr9N/McomHhs4qSqeKK0IRh5Z4I9PiITfwU6eE0Reg8iVLUqt8Mlrig6QvRdZGdjGtf1/Zufn7JhaSqmqtCAxB6TNXWkHELDOxUOxFAwIJrCkQ==");
		}
		
		[Test(order=11)]
		public function testEncryptAndDecryptWith384BitKeyAndKeyBlinding():void
		{
			_rsa = new RSA();
			
			_rsa.fromXMLString("<RSAKeyValue><Modulus>xFQP8DVH+hXKtmCj9nSc76f2J/TyQVjknOuHHTkCeTBspVhGPhF8EkmJt5QBXoMz</Modulus><Exponent>AQAB</Exponent><P>9FwArSuXr6TZIVvtdCkXUUx3LsBBlPWD</P><Q>za5QhnBp+mw3dIXGRpeZvablYYR+XHyR</Q><DP>O7lo6OporqNp9n9TcDrC2joIP0L6RIAl</DP><DQ>t4VNvGcZaKSeZo3meJ5UQ3BjQzvhM8zB</DQ><InverseQ>rE7l4UcZcUFpuhimAXofRm/jR3CxehTt</InverseQ><D>mxiBgtTEqLcgbhVIUkFrXRRGLOifnKoYhKtXiNcENZvjgT+9nMltp5QjlaNR31Sh</D></RSAKeyValue>");
			
			_rsa.useKeyBlinding = true;
			
			encryptDecryptAndTest("gT6wzbcGwJovM0i+KqjeBR6bnKTnHtQ5FvnyatYk4gc=", "kxSQMpwdg4nK/h8jBrtWy7TRuP0fwl1VlPvdk7IvlmOW6rJWYDff2sHTIW/tH+Kx");
			
			_rsa.useKeyBlinding = false;
		}
		
		[Test(order=12)]
		public function testEncryptAndDecryptWith512BitKeyAndKeyBlinding():void
		{
			_rsa = new RSA();
			
			_rsa.fromXMLString("<RSAKeyValue><Modulus>2Fq2nJNJJkqztC8O2Kb6yrMQ9t5xWmmZ/QmlpGe4KePTLuKA/iYBwJVub1EgMb56bLtnJa25FN4vk+2riXOyJw==</Modulus><Exponent>AQAB</Exponent><P>+Hn+fQKUMQXBOTYyFkZJN+APAr+I9Sx+S76gmPY8JW0=</P><Q>3ue7WQk10KT6Ewx/LwxZ9D5nWFakmEA/s0YHMVW3fWM=</Q><DP>iKwRnxFcEdrofV+iDT5755AGsaxI2RKwJVmlXH2Ud8E=</DP><DQ>kS1ke+zfu/B3X4i4HTByNf2e2Y40zWSrGFv3u04Un/k=</DQ><InverseQ>EgvaVYNLKOo/2eAOjlsg2NDALEYOMEN8iX4PV2CrkEk=</InverseQ><D>EAY3/ETUaCekQ7YwjU9gx96XZRF4p8+mfh1WzWR5OXDpa3qVnrm9r+CmI1P7rAajuBxZFlTR5vPrZNEyK5HukQ==</D></RSAKeyValue>");
			
			_rsa.useKeyBlinding = true;
			
			encryptDecryptAndTest("DoiXiyUOwn8QwFaHaA/t7wTUxtT0xT99sjIxtiBRkDg=", "b81FdU4sP6LQj645nMR/sS6Q9hZfTngKZA8LBHHwROEk9O+4EucgrqKjqqhUCd/I3LAdWTAzOgVghEdxccHwLw==");
			
			_rsa.useKeyBlinding = false;
		}
		
		[Test(order=13)]
		public function testEncryptAndDecryptWith1024BitKeyAndKeyBlinding():void
		{
			_rsa = new RSA();
			
			_rsa.fromXMLString("<RSAKeyValue><Modulus>tWmr5TDfrEL9YjVQ04lHcpe1IBeSaLhnGNCs/HOqW0ZjJ7ELF3UCcUeZQcqjYI42Jx0NmL4jqLLee1oV2o4XONtvWoO+OpK7QMSeLcritzhGj4cpSpihXANGnBjZQIaAc5JAfFI77upfZf/ugSQ08xitP3LAYgjhw9gjwgrieQE=</Modulus><Exponent>AQAB</Exponent><P>15/7uxTVZaYhE1/IELqq536fbIUxNhmDZK4+1pnI9s/p1aPkAHHbPw6P8kN3YM45qR6//SjpjfC9h+6IRSE8DQ==</P><Q>12G5C/aXvsO3/H5+/3b/uMe8rJUnzfX3SWLm1230D8w5x+Md3KQReaJKt/9obYDfiQz//1JFMKpY94K7gdSPxQ==</Q><DP>SsSh4GQ//uhVTceHsy1XN8BzfYjN4KmGIzI8feODiPndZoRW+kSAtuPQzDvSuFGqMteD0UAPhHV28xymSfpVPQ==</DP><DQ>AvAkVBNzEnkdA2a+WMHIzz56RmhqeJbIXsnomDu5vpVsnFtuxtm+G0ipeEUVqZi+c+Ing9Ydd4J7YDT6VdUOeQ==</DQ><InverseQ>V8rkk5+WvLmBeXU4NVYULyGYbHcuhVUAsen1QrxiX1pRTpjZQGEnMycvKOfzgJW1AcbstjFZfA48mIoaZ930vg==</InverseQ><D>AOLDNBtI/E5XbmNUQbQp5SVYfQ+gZ2J/Hl/meFUYP9nYIhl7NGId4O+4j9mtcos/OHGr31MOWYSGEZQfBzIqatqMroJ9XQNs4lS/myDOPIGBfr7K0+Ml0zPXTvy2iS3Wr41CWpa32MrlT0jbza3dsXKurzCkpdt2/OGx/WvXfAE=</D></RSAKeyValue>");
			
			_rsa.useKeyBlinding = true;
			
			encryptDecryptAndTest("M2rH9R06/C/4RyPUuwWfuTfeAyg40j9zjs5+UpRXY6U=", "f72LT7jyOcS/6HLI15p2P8CZvTFCmd+nISUyypbl+RaLT1SiAPREVjHjVNbs+TWWGf0LxAdLL1MSfIyvi5ZOy93mY3w8pNtp2gUiiJm4mx+QqDlWRft4ru+hjxhckUhBCZ/+V3/XTNAjABkn07JxinvIOwNos4Y7k8qRhTILuVo=");
			
			_rsa.useKeyBlinding = false;
		}
		
		[Test(order=14)]
		public function testEncryptAndDecryptWith2048BitKeyAndKeyBlinding():void
		{
			_rsa = new RSA();
			
			_rsa.fromXMLString("<RSAKeyValue><Modulus>qlQ6U9d1KxKSQ5HGO91OkBSBIdLERTXU0rYMED8mA3j3BK2Bk7A10f1vNZ+Vai9eD3H0VacUn864aKXm6fJyCTKTZoPqHC2UzL0HXhiL43PYwxDr2G3+L5EhYFUY/UE2SlZvsM9el0z32xnGIASXYEHLrpKVMZ9FZ9xMWxpuw4EieWFpwYPA1w0iWjK5SOe8iBnzKRfIggakbZt8cRZbOGunTm85m6zl/Vea+EiiH5g0tF+uyt7Q66tqrb1OJIbn+AtbttbpWO07HonMxPVyjec8jAeNsLPM56nvzyhI7GEKKnMMT4aTlwHWq4jI17rPvTZ6HLhz5ggRv7Rr7hs2Zw==</Modulus><Exponent>AQAB</Exponent><P>36eqHxIyuPkSJHDY0NlFZIpAHTlHstDeZL8HJbRqey7FD57r8tUyYqMt7vMpAx8IaNlF7qpSHqW5SCOXDrxvOh56u6qNX5dWg26FjhZM1AkFLYyPaCocAFv+RIjbemSgWYLniR0nNZZTmgHtwRUYH0GH2QKqvKTcatSoDVzXTO8=</P><Q>wvZJlxmkcODslazfX9TT+qO59pQ8QJxTWR9SpZAxEjYgBIWq/5kQG1zHkwXhQ5v6lVRfeyBCsAdozy397acVlaqNbSIIjwVo0HX7lFt91dOyoeyIrjRRh6Xczjw04yXMjl+493MXypaGpTpeDLgmeRzOH0cigBYVNZk9yyPSngk=</Q><DP>WA2gsr7tbVnSRLqRAhioc17iwx6sFcCZ7jwvSi7vxTOyreW5q084mRD5opvlR69OFkmEeORhlGNWwQoSDOEvQUiCtaP+KOZiTziSKFCrSseKXFZ8l1wMzi9puf3Puy4m21boZVku+LAIlhewTVZKuvOH0m50XfTiOsUirLAiq80=</DP><DQ>cfaPm9C0a/s+sFtmE1mQM/Gi0b1i3w3CNtV1dSwtUwzqeFo+U7yASs5YJtwICoJR3xp72bhI4ybhoEGtLk898cfJdeKwCBJMa5ab4eP9UZG22KowV0xj4BwXT0KoU6MTyKGxuIvBe32z5T+SHHNEogUxg90MEL1X1oXmNimRgyk=</DQ><InverseQ>nhryfOtjfe5b/OxwsS2WWvfJ+ounIRMOy8McQfthbLC79l+yaKVALxwRJDLd/b4smzSNjmy/R15fLGnDxqI+b61s0FTUbgRhG4dDYlDcpHRPH4MHPS58RCSHOFKHr3Cg9YR1rTJGOBYH4alwp57VDv3b88DIfAgZghG9PmTRiwU=</InverseQ><D>dukwg0Hi6bwgYo3NoBODenDmKe/T2CGZv7UaPOlpJ3l2skxTLwEQwdY1onETxbrl5tB+bKGlc1/FPEG+MMtys1scrrAfa6aiwECjeRyX5KYGyT/x9vnrP9gJPhCKzpuNRF6NwRk0h1pTmyGmQMoTyD6G7Qwmnir8MGMK53tPoqpLX6x5eF+yVV6OhNJitfimEXo4290cIFv1zkNlZpEhSrAj4027e0hS6wFmRCOLeG/3Th2SeH4yjOggSzFWyfElYwTPsdzFb0R4rfpItqEi1RgwBM0rN0QZa3p8tEQ4rvzaRdwGdfaJQs37Gcyv0gUgPttrpw1RSYJ0gFFAeWJj8Q==</D></RSAKeyValue>");
			
			_rsa.useKeyBlinding = true;
			
			encryptDecryptAndTest("k/L1ckoD71J1m+q7SyUAz+tXr/gFcvRJus5rPG70UOw=", "hG8xdu2R4g8o0dgTP8Fjz6+sqG6wnaiP8f0ZVqElfFe0NUR22DGQHfqAe/eD6MEW4lwz8Xq5qPaYAB5CaIxKy5Q1u/ZRJw3RcseJjgfJ1T/JS7idEv0D2sMsFvjkZ0ERbCB+xSF/lKXpRcShWmHa1BNM8IxsKwks2V8M9kqps7Tx8g2DIPx6xiNZdAMMzFMIc6gqzxA/i9WH5gb9j9Bl43UChS5UYLde2bFmoNAaASSHcdvHcAwGoaA1RARo5KkkdpzdCDAkNRFg4VHcyML4fWd/XMX852TWDees/x2qC9BYyPSjioiafC0UITcUlm2yT761MSa8HgfhvoFV0CrBBg==");
			
			_rsa.useKeyBlinding = false;
		}
		
		[Test(order=15)]
		public function testEncryptAndDecryptWith384BitKeyAndWithoutCRT():void
		{
			_rsa = new RSA();
			
			_rsa.fromXMLString("<RSAKeyValue><Modulus>y5yt3ZO7j3DJvPsynBThoBBsM0f6dc6Cfll+RVMVGj9NDfm3gjJYsrFRGTCF+zXZ</Modulus><Exponent>AQAB</Exponent><D>BXShQ/qdX+6JuUKRzJTSptNJ0uXu1BFAaZ4kqhR8tLr1UUjdqm7TDfF35nZtfS7B</D></RSAKeyValue>");
			
			encryptDecryptAndTest("lLD/h/tXOF+HbNa2UyP9p01D2BcvgVvRO9BCZmX9IYE=", "v/mCygLxX5kHXnpAW2D64/0MsmHjfX8nUcWDeyn9iUW0hIhOF4kx4PNgcCOvFLJG");
		}
		
		[Test(order=16)]
		public function testEncryptAndDecryptWith512BitKeyAndWithoutCRT():void
		{
			_rsa = new RSA();
			
			_rsa.fromXMLString("<RSAKeyValue><Modulus>vwnnQ7ZbkkZIqYc8+m8ciLwyx2oYo+Uu1CW6n+Kilfv99DilX8yQ6pRyDqcjV+ZELxxvXk/1JlC6gtcMSn62OQ==</Modulus><Exponent>AQAB</Exponent><D>jETBQb6LzgM9JvzdkSQ0V1GYF0OXg/+rOqnZNbw6lNSDWPx/zGSFOL8PeV6gGEQReHVl73voSc3tEWZ7QxijgQ==</D></RSAKeyValue>");
			
			encryptDecryptAndTest("yUagLYif1wQuu3BtA8CXgJSn+k5MK5sLg1LjFCRf+zg=", "CtwCShKVL8rdGIuSt8RB68bGsuzoqU9RjskL7V18z+SGA43lNRnzysUXdpupmH9F5uqP0e2lR7jgHlVZLGjK1Q==");
		}
		
		[Test(order=17)]
		public function testEncryptAndDecryptWith1024BitKeyAndWithoutCRT():void
		{
			_rsa = new RSA();
			
			_rsa.fromXMLString("<RSAKeyValue><Modulus>wwg3+kaqjLusopvrXnkWDnfNfzhowsklUPDcsScK4hOec0UGAKjwT7Uaw3Xz73qWTEE9lwiKPgphTS3MfLWp3JMQvejHgXsF9+FTuRfpR3p/OVvAwgB+vzzqHMdkWx0CbjyhG0cVUymiAwYQgB54Y0KZDw6tji7ua4UjSlXPpWk=</Modulus><Exponent>AQAB</Exponent><D>VZxl9hbPBrfbMAYBa5b7d55fNlkso1RobP9N4PWicVrrUu4ZlHCUDGkTNnmweo71KsP4pTO6e0FTNO3FtXiI9uTgeVcmy1+tTEFHPQTgWcRrABZCeLQfvkvfQtjJu225ESZs4HJor/Tylr8NVO3FjlVCvpJavvG4V6fAKrH+cYE=</D></RSAKeyValue>");
			
			encryptDecryptAndTest("1xAKIv2rraiq2xN5dbegPsJlyP19Fgy21RNjNZHMI3E=", "Z6tXYnwRYT+QRSLVOs8Pw3rg3a/+4fO9WMAYgGq87kS0PwCMpzcsgv2r1nPDz3GMZJVKuwjdbZ9Yz6E0RZLqTrQ7LtFd+M44xl5cPQOIimBperwUKGrHsZMr2JxIW88VuKTuHVSEEYFaRJMU/jQysMI3FTqJ/7/ZVeF33CD04+o=");
		}
		
		[Test(order=18)]
		public function testEncryptAndDecryptWith2048BitKeyAndWithoutCRT():void
		{
			_rsa = new RSA();
			
			_rsa.fromXMLString("<RSAKeyValue><Modulus>0Unk8KqQhPTDoJuAD2+LWvuy2U3cJCx6FThp1oIskmCRdPA+FLUH01HaRzbR0UcguwRmoB2D623owi+4x7G/s2c3hLYIIYDiVPoama7sKyt84qXuL1JhQ+Lird0sWxLWC+EdY6oT4U6buAKA5Mg/YRjwdB6oISohKo1fl5XRhwYlOxUIzJ4bS/SbJv9PO6cGZ8Vex6nNDNmmwQkH2AN3m9vz5GwJrZc7WgIGAKh18O/nlYKLlMT5/eHvn9kMLoqu1TkJ6H0mk2Dc5y1j1k64Fu9XkhwKU6LygqgxC2d2BESnniTjtPlAcJHrvt/DJfGYhtk+L3yP1lRFaTVLt+295w==</Modulus><Exponent>AQAB</Exponent><D>X/+CGPZTtfjDpu7Mzce/ZytevRhequUP1p36xh8NrNLIxZfREhR7k23PLq0xjsoOdFovbLA9K4dNpYzYOBkLMpJcv+3zStLgflP+UZIP2DlpXlj4KRKjdM0kZtW1m8zHC8nlfiqsVcOF3+CeGNLVZ4dV/B13x0aY0fjo6RIaetD9S9mtVokfQl3hoaoWjbQQTGywxTbkdEV6p6VHZMWSbFV6ITwhzZjZaEWMG31V+KTH4aLKivgZ+IiUhYRWgpdTEQWmDaVJRCZ0hx/vnE4Zbx11Cvsk39YMnOV/bdFsgB2QoxKOLNjeNDlix/Lt/LtXgyBK2tHIhlQF7V1HG+POmQ==</D></RSAKeyValue>");
			
			encryptDecryptAndTest("/vGLGZI2G9GrUo6YRwdxiJQ7uwrKyX6yrC5t8WUSBnM=", "smNn+8WtwrCv0NS0moDtEi1xscsji+xe7EULeWKLC7i504h2tJUskwDRxbl2dVad1ooFQvVyo9UEnqL9pUB38kSGaYw1f9/XU56j7cv5zggL6Eb/r8EMwDGzWOzNsO/N+THwJs3jWX8B9hDnRV0Plz0n+I25yVJxGDDmKzBx8x1XkoBWNn97oPxacugLcfYLZ8CnvufUXvzF43su7NU+dqdZ9ijsL7uo2R5dv8x/eCdyRtlHZ4D1tBzYj9ZDvT6VRpb3XBJTiPFLLD6POiMqp6zWzcopEGvLVEkE++52uQcI0Dami6zmhXzDqAvss/lQOiDUQbDOf8e8WNl5hemkMQ==");
		}
		
		[Test(order=5)]
		public function testFromXMLStringAndToXMLString():void
		{
			importExportAndTest("<RSAKeyValue><Modulus>2qSrPyXx2+nBA1AcLwvTfGJ1J3kfa6HmDbCA7tmtEOEkHMPzH+MuYxPrk56O+orRYKovHANVOopuKVEGwaE7lrM/NX/pCUjU2FYtC9wgL9ReCSuas+uCQR1AEOpf3fGDOdHOWGU9t6m1klHI5edx5mzCXxYnqd49So4UNZ3XOnM=</Modulus><Exponent>AQAB</Exponent><P>/4oPUyQS51oNfXHqOFfBPBQMjA7TpPKzXFAN3uaN8v5I7qlsZXOIFYWDUjA3ncf3cMYu9RS7XPp764bEgCSYxQ==</P><Q>2wmUjOw5zYOMyOx4SVZbf/ppGzzJPJMk/L/oCF9J8DteOvlwZ2yS/HT2bllOhvatmGAhxdVwaTY007rTIowJ1w==</Q><DP>mxrOkHVt7/UOCR1ywD4rsO6uavi45/7UdWy17pzcfihwVkSJ4c5NRFrkyacwqtlsTIxOhj3ON/Jl8yC69ti/zQ==</DP><DQ>np0nZ41ApmQWtQEYcfMJO3m4VzMDfswHQsgtXLK0NjSnngk3ro1fO1XvhiVBylYji25BxqMzTd0lEBYAAspp7Q==</DQ><InverseQ>fiB+fSF3uQaNFcBa5iaBU73Ot3ucJvqM72yRtH5WqUb/6SzurI1D0HU9PQkAMVnyjPHTJgWmc3WU5/yxs3z18w==</InverseQ><D>WjXW8hcV00Z+/H7xIfgfKhL1g3PWIvKJmNxaVjI51d0OqU+v4Fg7q2VsrVueYoEkIl4VUdmOMLks+p8TypBbpO5A27S4GBZ0zIZ5HibTKk29h3/vofHc0t0ffAWrlxQOBxSb3ELhXNq9t0U2gKw0iaYvnTzIAl6p1EwhWk1lfwE=</D></RSAKeyValue>");
		}
		
		[Test(order=6)]
		public function testFromXMLStringAndToXMLStringWithoutCRTParameters():void
		{
			importExportAndTest("<RSAKeyValue><Modulus>4h+8ZCigf04CjTkZ2auduwEeAht9wRAnzCn++KynM4NzTkGltBRPVOr7pu8XJFuLOS/zfZFZeBk8VOKwVE+8C0kld1qlTEgs/JvDDdAxOzpfcoYrIlJwfvl2BpSYnh4FzT13EtiIGQ0jBCRt/Ql52UazvrFnStCdhOb2Bjvc9l8=</Modulus><Exponent>AQAB</Exponent><D>yhlvOV2ORPmmEi5syj02VkMjXOLRPFKCH1mRhxRYxBPCZLkLrq1QUidLD+I1Hsuq3UvcJehYvJxhbcTFsDUrbIRoWmnnzQlyNA3sg9c2ibvElI2e2uzML9j6SRzwQuoGNrzxZAL4J72Ew637qgGUhbj+LMhNmM0gYCtMQFbAU7E=</D></RSAKeyValue>");
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function encryptDecryptAndTest(data:String, expectedCipher:String):void
		{
			var value:ByteArray = Convert.fromBase64String(data);
			var cipher:ByteArray = _rsa.encrypt(value);
			
			Assert.assertEquals("Encrypted data was invalid.", expectedCipher, Convert.toBase64String(cipher));
			
			var decipher:ByteArray = _rsa.decrypt(cipher);
			// Removes the leading bytes as the decrypted data is right padded with zeros.
			ByteArrayUtil.removeBytes(decipher, 0, decipher.length - value.length);
			
			Assert.assertEquals(StringUtil.substitute("Decrypted data was invalid with the specified key length of {0}-bit.", _rsa.keySize),
				data, Convert.toBase64String(decipher));
		}
		
		private function importExportAndTest(xml:String):void
		{
			_rsa = new RSA();
			
			_rsa.fromXMLString(xml);
			// Converts XML strings to XML objects and back to force the same format.
			Assert.assertEquals(new XML(xml).toXMLString(), new XML(_rsa.toXMLString(true)).toXMLString());
		}
	}
}