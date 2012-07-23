////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.tests.crypto
{
	import flame.crypto.CipherMode;
	import flame.crypto.ICryptoTransform;
	import flame.crypto.PaddingMode;
	import flame.crypto.RC4;
	import flame.utils.ByteArrayUtil;
	
	import flash.utils.ByteArray;
	
	import org.flexunit.Assert;

	[TestCase(order=10)]
	public final class RC4Test
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _rc4:RC4 = new RC4();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function RC4Test()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		[Test(order=1, expects="flame.crypto.CryptoError")]
		public function testBlockSizeWithInvalidValue():void
		{
			_rc4.blockSize = 128;
		}
		
		[Test(order=2, expects="flash.errors.IllegalOperationError")]
		public function testFeedbackSize():void
		{
			_rc4.feedbackSize = 128;
		}
		
		[Test(order=3, expects="flash.errors.IllegalOperationError")]
		public function testIV():void
		{
			_rc4.iv = new ByteArray();
		}
		
		[Test(order=4, expects="flame.crypto.CryptoError")]
		public function testKeyWithTooBigValue():void
		{
			_rc4.key = ByteArrayUtil.repeat(0, 512);
		}
		
		[Test(order=5, expects="flame.crypto.CryptoError")]
		public function testKeyWithTooSmallValue():void
		{
			_rc4.key = ByteArrayUtil.repeat(0, 4);
		}
		
		[Test(order=6, expects="flame.crypto.CryptoError")]
		public function testKeySizeWithTooBigValue():void
		{
			_rc4.keySize = 4096;
		}
		
		[Test(order=7, expects="flame.crypto.CryptoError")]
		public function testKeySizeWithTooSmallValue():void
		{
			_rc4.keySize = 32;
		}
		
		[Test(order=8, expects="flame.crypto.CryptoError")]
		public function testModeWithCBC():void
		{
			_rc4.mode = CipherMode.CBC;
		}
		
		[Test(order=9, expects="flame.crypto.CryptoError")]
		public function testModeWithCFB():void
		{
			_rc4.mode = CipherMode.CFB;
		}
		
		[Test(order=10, expects="flame.crypto.CryptoError")]
		public function testModeWithCTS():void
		{
			_rc4.mode = CipherMode.CTS;
		}
		
		[Test(order=11, expects="flame.crypto.CryptoError")]
		public function testModeWithECB():void
		{
			_rc4.mode = CipherMode.ECB;
		}
		
		[Test(order=12, expects="flame.crypto.CryptoError")]
		public function testPaddingWithANSIX923():void
		{
			_rc4.padding = PaddingMode.ANSIX923;
		}
		
		[Test(order=13, expects="flame.crypto.CryptoError")]
		public function testPaddingWithISO10126():void
		{
			_rc4.padding = PaddingMode.ISO10126;
		}
		
		[Test(order=14, expects="flame.crypto.CryptoError")]
		public function testPaddingWithPKCS7():void
		{
			_rc4.padding = PaddingMode.PKCS7;
		}
		
		[Test(order=15, expects="flame.crypto.CryptoError")]
		public function testPaddingWithZEROS():void
		{
			_rc4.padding = PaddingMode.ZEROS;
		}
		
		[Test(order=23)]
		public function testTransformBlockDecryption():void
		{
			_rc4.key = ByteArrayUtil.fromHexString("E3EEFE10CB956C5C779B3FD4A1902D8DED50A4F14D1F120AB0B297F40AF3AA06662DA5B83C205F3B26D54EA60C5E2A89EA8CDAB8F64CEC0A1E01A801B2597617B8E813B3281AFC9CE9DAA5A39EA57AB6631FAEC2F3837748005B6741E397FAA2B4B0364B0030B55A50B48FC09E1B933674688D6824BDB0F3BBD125247ABA2941C767BA6BDDDD19ADBA4479346DA3F5BFF98132AA402DE289333B64D95F0866C4EB29BEB7749470DFD3F363F6BA29BAB7F38728B8B81192A631C5B4C5053BD07A4E6A2B8D3F7E12447090192D184B108DDB5A9E71164EF4615B53DAFB71E12B1965F944BF0748BD63B9DC8CFBCDF8713929451ABE1BFBE10B5B269896A98806AB");
			
			var encryptor:ICryptoTransform = _rc4.createDecryptor();
			var data:ByteArray = ByteArrayUtil.fromHexString("8A738BC7E49B31CA7FE5AB7F0E74DAE6");
			
			encryptor.transformBlock(data, 0, data.length, data, 0);
			
			assertCipherIsValid(ByteArrayUtil.toHexString(data), "F5AB13F0FCB5C7A6BC0F2159A8F04F0D");
			
			data = ByteArrayUtil.fromHexString("B642D40D696266CBB57C9E73151D31F4");
			
			encryptor.transformBlock(data, 0, data.length, data, 0);
			
			assertCipherIsValid(ByteArrayUtil.toHexString(data), "A5EA4EBF4A27937D0B5CD612687FE92E");
			
			data = ByteArrayUtil.fromHexString("B6C8DEB699B43F9F0722FD8B446F6EB9");
			
			encryptor.transformBlock(data, 0, data.length, data, 0);
			
			assertCipherIsValid(ByteArrayUtil.toHexString(data), "AA287D56AB67B1D46B78EE67DACA0300");
		}
		
		[Test(order=22)]
		public function testTransformBlockEncryption():void
		{
			_rc4.key = ByteArrayUtil.fromHexString("E3EEFE10CB956C5C779B3FD4A1902D8DED50A4F14D1F120AB0B297F40AF3AA06662DA5B83C205F3B26D54EA60C5E2A89EA8CDAB8F64CEC0A1E01A801B2597617B8E813B3281AFC9CE9DAA5A39EA57AB6631FAEC2F3837748005B6741E397FAA2B4B0364B0030B55A50B48FC09E1B933674688D6824BDB0F3BBD125247ABA2941C767BA6BDDDD19ADBA4479346DA3F5BFF98132AA402DE289333B64D95F0866C4EB29BEB7749470DFD3F363F6BA29BAB7F38728B8B81192A631C5B4C5053BD07A4E6A2B8D3F7E12447090192D184B108DDB5A9E71164EF4615B53DAFB71E12B1965F944BF0748BD63B9DC8CFBCDF8713929451ABE1BFBE10B5B269896A98806AB");
			
			var encryptor:ICryptoTransform = _rc4.createEncryptor();
			var data:ByteArray = ByteArrayUtil.fromHexString("F5AB13F0FCB5C7A6BC0F2159A8F04F0D");
			
			encryptor.transformBlock(data, 0, data.length, data, 0);
			
			assertCipherIsValid(ByteArrayUtil.toHexString(data), "8A738BC7E49B31CA7FE5AB7F0E74DAE6");
			
			data = ByteArrayUtil.fromHexString("A5EA4EBF4A27937D0B5CD612687FE92E");
			
			encryptor.transformBlock(data, 0, data.length, data, 0);
			
			assertCipherIsValid(ByteArrayUtil.toHexString(data), "B642D40D696266CBB57C9E73151D31F4");
			
			data = ByteArrayUtil.fromHexString("AA287D56AB67B1D46B78EE67DACA0300");
			
			encryptor.transformBlock(data, 0, data.length, data, 0);
			
			assertCipherIsValid(ByteArrayUtil.toHexString(data), "B6C8DEB699B43F9F0722FD8B446F6EB9");
		}
		
		[Test(order=17)]
		public function testTransformFinalBlockDecryptionWith40BitKey():void
		{
			testTransformFinalBlockDecryption(
				ByteArrayUtil.fromHexString("33E5457F076A4BF46E62C4A3D47A200CE26A81BED3292D57D4598920B848687D"),
				ByteArrayUtil.fromHexString("62B7A8D03E"),
				"D00AB62C57BD537E45929742463F1635C72D642D2BF5464D5EE6D63D751D5C14"
			);
		}
		
		[Test(order=19)]
		public function testTransformFinalBlockDecryptionWith512BitKey():void
		{
			testTransformFinalBlockDecryption(
				ByteArrayUtil.fromHexString("00B12DCAA359C2E03392E2FF0BCCDC32EE601379FCCA5B68C911248E55523062BBE3D54E39E860D167086B88CAA988E69FA5D62F1987BBD36E0795FDC3D919E2F24F41B8A2E531A078F65B1B90032B5A59F3F0D8593C26F64486F7A6543F410327F82145E43454B6D38502BEF0D49E3654F11EA8A7C6EE168464A997E9DC7640"),
				ByteArrayUtil.fromHexString("78E8AD0946177214DB3AABDFB8696C9CCAE854C641DA8E53E85381CAB46E0F690D27959D78DD04DB575A65AFD860CBB58EB20D1A8FABFEA746D3CA8DD6931C87"),
				"62513C62896F460E9661F0777EAB4BF99FCBBC283AAE2FD8084727C9C313063EB50271422F9C622BEBD5CE7217CDDCC24B40C30D094C922E189368817346E637646C4843CFE8C1556B85948B478FC91BC317082FA2BA06ABD6A89974C517380557B5F42518FA0BF4FEA6F2B88DDA90EA8D3A4CD8CCB60DE1BD208801FA36C197"
			);
		}
		
		[Test(order=21)]
		public function testTransformFinalBlockDecryptionWith1024BitKey():void
		{
			testTransformFinalBlockDecryption(
				ByteArrayUtil.fromHexString("C3ECB8DD59CFE7620A4B1DD6CD8C2D12BF0FDF3E03825120A818C7E44AE967C4FF986123D4D84A1EB474C776FC96D42F4103E0D2A4CBEC68CD4BA33D67F1133E2E28222127FEBF0BA8A5FCCFB8CC282BEC1D4E4A486947F648E296DE7A2A63EA4438792241B44A3458CF96781E035C1FD95766DA9AD00C3CCB6A303DBB6158A10A2B4588CBA9C684C4FFA4666B0778E7F49D5404A30F6C785F6B6380133776AC4DF635B42F5DE861197FCC236CE4B83A34C897645F168801C2CD3EBD19E0F5AC97BD867F3A6A31A24C6CF141D2F017B04024EA44312A1CB84A5FD33142E323D1E169FB41F38A17E3D771D64D4ECFFC54807E28E54330DEF94737A72456626C3C"),
				ByteArrayUtil.fromHexString("4B1F1DCE3565017A06ED15DA66F7488EC8ED579404428BAA755EC93DFE71883877525744CDC3F48660866DE694B230FD3463EBFD4D447972769C5D48ED7F75BEF13F5BBC6D481EEEB5C29504DDFABDECB37DB089FE4B1FA70021864B640093096F01BBB651A4B7ED01956C7E2321C4774147089283FEBE71B5AFA4BAD53F8D4E"),
				"DE6BC73DA851E98A45FD6A22D30AAA00C376510366F242E962FCDCC35AA6ABD9C4E65B47A29FE46CF6111DE135EF5488E471AAFEB9C975475763C64908099E82410D2F2CC1185FAB21E130BFA98EB14FA6099B6FA9FFC2381D744051CCBCBD8B87DB50FAE3BD373B26B4911F877B2D82A3CC12580845A51B8BCA4F303E9EF1B4D228AA8F411A3553BC08C74152EA2BD770F0A8B7BAA227B573DCE1A0884FFAFAFD03667E0F287EFF3CC62EC8DBB17043A8DFB746523640F903CD634FB7A8458A6CEAD387816780E76FDF7741F556CD53619907DA8BC318F419862C7310D4A3A14EA2FDEBA573B98F8F3A26B115ED206F49C9E4B718158980AF3F55DCA28F666A"
			);
		}
		
		[Test(order=16)]
		public function testTransformFinalBlockEncryptionWith40BitKey():void
		{
			testTransformFinalBlockEncryption(
				ByteArrayUtil.fromHexString("D00AB62C57BD537E45929742463F1635C72D642D2BF5464D5EE6D63D751D5C14"),
				ByteArrayUtil.fromHexString("62B7A8D03E"),
				"33E5457F076A4BF46E62C4A3D47A200CE26A81BED3292D57D4598920B848687D"
			);
		}
		
		[Test(order=18)]
		public function testTransformFinalBlockEncryptionWith512BitKey():void
		{
			testTransformFinalBlockEncryption(
				ByteArrayUtil.fromHexString("62513C62896F460E9661F0777EAB4BF99FCBBC283AAE2FD8084727C9C313063EB50271422F9C622BEBD5CE7217CDDCC24B40C30D094C922E189368817346E637646C4843CFE8C1556B85948B478FC91BC317082FA2BA06ABD6A89974C517380557B5F42518FA0BF4FEA6F2B88DDA90EA8D3A4CD8CCB60DE1BD208801FA36C197"),
				ByteArrayUtil.fromHexString("78E8AD0946177214DB3AABDFB8696C9CCAE854C641DA8E53E85381CAB46E0F690D27959D78DD04DB575A65AFD860CBB58EB20D1A8FABFEA746D3CA8DD6931C87"),
				"00B12DCAA359C2E03392E2FF0BCCDC32EE601379FCCA5B68C911248E55523062BBE3D54E39E860D167086B88CAA988E69FA5D62F1987BBD36E0795FDC3D919E2F24F41B8A2E531A078F65B1B90032B5A59F3F0D8593C26F64486F7A6543F410327F82145E43454B6D38502BEF0D49E3654F11EA8A7C6EE168464A997E9DC7640"
			);
		}
		
		[Test(order=20)]
		public function testTransformFinalBlockEncryptionWith1024BitKey():void
		{
			testTransformFinalBlockEncryption(
				ByteArrayUtil.fromHexString("DE6BC73DA851E98A45FD6A22D30AAA00C376510366F242E962FCDCC35AA6ABD9C4E65B47A29FE46CF6111DE135EF5488E471AAFEB9C975475763C64908099E82410D2F2CC1185FAB21E130BFA98EB14FA6099B6FA9FFC2381D744051CCBCBD8B87DB50FAE3BD373B26B4911F877B2D82A3CC12580845A51B8BCA4F303E9EF1B4D228AA8F411A3553BC08C74152EA2BD770F0A8B7BAA227B573DCE1A0884FFAFAFD03667E0F287EFF3CC62EC8DBB17043A8DFB746523640F903CD634FB7A8458A6CEAD387816780E76FDF7741F556CD53619907DA8BC318F419862C7310D4A3A14EA2FDEBA573B98F8F3A26B115ED206F49C9E4B718158980AF3F55DCA28F666A"),
				ByteArrayUtil.fromHexString("4B1F1DCE3565017A06ED15DA66F7488EC8ED579404428BAA755EC93DFE71883877525744CDC3F48660866DE694B230FD3463EBFD4D447972769C5D48ED7F75BEF13F5BBC6D481EEEB5C29504DDFABDECB37DB089FE4B1FA70021864B640093096F01BBB651A4B7ED01956C7E2321C4774147089283FEBE71B5AFA4BAD53F8D4E"),
				"C3ECB8DD59CFE7620A4B1DD6CD8C2D12BF0FDF3E03825120A818C7E44AE967C4FF986123D4D84A1EB474C776FC96D42F4103E0D2A4CBEC68CD4BA33D67F1133E2E28222127FEBF0BA8A5FCCFB8CC282BEC1D4E4A486947F648E296DE7A2A63EA4438792241B44A3458CF96781E035C1FD95766DA9AD00C3CCB6A303DBB6158A10A2B4588CBA9C684C4FFA4666B0778E7F49D5404A30F6C785F6B6380133776AC4DF635B42F5DE861197FCC236CE4B83A34C897645F168801C2CD3EBD19E0F5AC97BD867F3A6A31A24C6CF141D2F017B04024EA44312A1CB84A5FD33142E323D1E169FB41F38A17E3D771D64D4ECFFC54807E28E54330DEF94737A72456626C3C"
			);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function assertCipherIsValid(cipher:String, expectedCipher:String):void
		{
			Assert.assertEquals("Invalid cipher.", expectedCipher, cipher);
		}
		
		private function assertDecipherIsValid(decipher:String, expectedDecipher:String):void
		{
			Assert.assertEquals("Invalid decipher.", expectedDecipher, decipher);
		}
		
		private function testTransformFinalBlockDecryption(cipher:ByteArray, key:ByteArray, expectedDecipher:String):void
		{
			assertDecipherIsValid(ByteArrayUtil.toHexString(_rc4.createDecryptor(key).transformFinalBlock(cipher, 0, cipher.length)), expectedDecipher);
		}
		
		private function testTransformFinalBlockEncryption(data:ByteArray, key:ByteArray, expectedCipher:String):void
		{
			assertCipherIsValid(ByteArrayUtil.toHexString(_rc4.createEncryptor(key).transformFinalBlock(data, 0, data.length)), expectedCipher);
		}
	}
}