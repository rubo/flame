////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.numerics.BigInteger;
	
	import flash.utils.getQualifiedClassName;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	[ResourceBundle("flameCrypto")]
	internal final class RFC4050KeyFormatter
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private static const D_ELEMENT:String = "D";
		private static const DOMAIN_PARAMETERS_ELEMENT:String = "DomainParameters";
		private static const ECDH_ROOT_ELEMENT:String = "ECDHKeyValue";
		private static const ECDSA_ROOT_ELEMENT:String = "ECDSAKeyValue";
		private static const NAMED_CURVE_ELEMENT:String = "NamedCurve";
		private static const PRIVATE_KEY_ELEMENT:String = "PrivateKey";
		private static const PUBLIC_KEY_ELEMENT:String = "PublicKey";
		private static const ROOT_NAMESPACE:String = "http://www.w3.org/2001/04/xmldsig-more#";
		private static const URN_ATTRIBUTE:String = "URN";
		private static const URN_ATTRIBUTE_PREFIX:String = "urn:oid:";
		private static const VALUE_ATTRIBUTE:String = "Value";
		private static const X_ELEMENT:String = "X";
		private static const Y_ELEMENT:String = "Y";
		
		private static var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		internal static function fromXMLString(value:String):ECCParameters
		{
			var xml:XML = new XML(value);
			
			if (xml.namespace().toString() != ROOT_NAMESPACE)
				throw new ArgumentError(_resourceManager.getString("flameCrypto", "unexcpectedXMLNamespace", [ xml.namespace().toString(), ROOT_NAMESPACE ]));
			
			var parameters:ECCParameters = new ECCParameters();
			var rootElement:String = xml.localName();
			
			if (rootElement == ECDH_ROOT_ELEMENT)
				parameters.algorithmName = getQualifiedClassName(ECDiffieHellman);
			else if (rootElement == ECDSA_ROOT_ELEMENT)
				parameters.algorithmName = getQualifiedClassName(ECDSA);
			else
				throw new ArgumentError(_resourceManager.getString("flameCrypto", "unknownECAlgorithm"));
			
			var domainParameters:XMLList = xml.children().(localName() == DOMAIN_PARAMETERS_ELEMENT);
			
			if (domainParameters.length() == 0)
				throw new ArgumentError(_resourceManager.getString("flameCrypto", "missingDomainParameters"));
			
			var namedCurve:XMLList = domainParameters.children().(localName() == NAMED_CURVE_ELEMENT);
			
			if (namedCurve.length() == 0)
				throw new ArgumentError(_resourceManager.getString("flameCrypto", "missingDomainParameters"));
			
			var urn:XMLList = namedCurve.attributes().(localName() == URN_ATTRIBUTE);
			
			if (urn.length() == 0)
				throw new ArgumentError(_resourceManager.getString("flameCrypto", "missingDomainParameters"));
			
			parameters.keySize = ECCParameters.getKeySizeByCurveOID(urn.toString().substring(URN_ATTRIBUTE_PREFIX.length));
			
			var publicKey:XMLList = xml.children().(localName() == PUBLIC_KEY_ELEMENT);
			
			if (publicKey.length() == 0)
				throw new ArgumentError(_resourceManager.getString("flameCrypto", "missingPublicKey"));
			
			var x:XMLList = publicKey.children().(localName() == X_ELEMENT);
			
			if (x.length() == 0)
				throw new ArgumentError(_resourceManager.getString("flameCrypto", "missingPublicKey"));
			
			x = x.attributes().(localName() == VALUE_ATTRIBUTE);
			
			if (x.length() == 0 || !x.toString())
				throw new ArgumentError(_resourceManager.getString("flameCrypto", "missingPublicKey"));
			
			var y:XMLList = publicKey.children().(localName() == Y_ELEMENT);
			
			if (y.length() == 0)
				throw new ArgumentError(_resourceManager.getString("flameCrypto", "missingPublicKey"));
			
			y = y.attributes().(localName() == VALUE_ATTRIBUTE);
			
			if (y.length() == 0 || !y.toString())
				throw new ArgumentError(_resourceManager.getString("flameCrypto", "missingPublicKey"));
			
			var keySizeInBytes:int = (parameters.keySize + 7) / 8;
			
			parameters.x = CryptoUtil.ensureLength(new BigInteger(x.toString()).toByteArray(), keySizeInBytes);
			parameters.y = CryptoUtil.ensureLength(new BigInteger(y.toString()).toByteArray(), keySizeInBytes);
			
			var privateKey:XMLList = xml.children().(localName() == PRIVATE_KEY_ELEMENT);
			
			if (privateKey.length() != 0)
			{
				var d:XMLList = privateKey.children().(localName() == D_ELEMENT);
				
				if (d.length() == 0)
					throw new ArgumentError(_resourceManager.getString("flameCrypto", "missingPrivateKey"));
				
				d = d.attributes().(localName() == VALUE_ATTRIBUTE);
				
				if (d.length() == 0 || !d.toString())
					throw new ArgumentError(_resourceManager.getString("flameCrypto", "missingPrivateKey"));
				
				parameters.d = CryptoUtil.ensureLength(new BigInteger(d.toString()).toByteArray(), keySizeInBytes);
			}
			
			return parameters;
		}
		
		internal static function toXMLString(parameters:ECCParameters):String
		{
			var rootElement:String;
			
			if (parameters.algorithmName == getQualifiedClassName(ECDiffieHellman))
				rootElement = ECDH_ROOT_ELEMENT;
			else if (parameters.algorithmName == getQualifiedClassName(ECDSA))
				rootElement = ECDSA_ROOT_ELEMENT;
			else
				throw new CryptoError(_resourceManager.getString("flameCrypto", "unknownECAlgorithm"));
			
			var xml:XML =
				<{rootElement} xmlns={ROOT_NAMESPACE}>
					<{DOMAIN_PARAMETERS_ELEMENT}>
						<{NAMED_CURVE_ELEMENT} {URN_ATTRIBUTE}={URN_ATTRIBUTE_PREFIX + ECCParameters.getCurveOIDByKeySize(parameters.keySize)} />
					</{DOMAIN_PARAMETERS_ELEMENT}>
					<{PUBLIC_KEY_ELEMENT}>
						<{X_ELEMENT} {VALUE_ATTRIBUTE}={new BigInteger(parameters.x, true)} xsi:Type="PrimeFieldElemType" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
						<{Y_ELEMENT} {VALUE_ATTRIBUTE}={new BigInteger(parameters.y, true)} xsi:Type="PrimeFieldElemType" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
					</{PUBLIC_KEY_ELEMENT}>
				</{rootElement}>;
			
			if (parameters.d != null)
				xml.appendChild(
					<{PRIVATE_KEY_ELEMENT}>
						<{D_ELEMENT} {VALUE_ATTRIBUTE}={new BigInteger(parameters.d, true)} xsi:Type="PrimeFieldElemType" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
					</{PRIVATE_KEY_ELEMENT}>
				);
			
			return xml.toXMLString();
		}
	}
}