////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.collections
{
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ListCollectionView;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import flame.utils.VectorUtil;
	
	[DefaultProperty("source")]
	[ResourceBundle("flameCore")]
	
	/**
	 * The VectorCollection class is a wrapper class that exposes a Vector as
	 * a collection that can be accessed and manipulated using the methods
	 * and properties of the ICollectionView or IList interfaces.
	 * Operations on a VectorCollection instance modify the data source;
	 * for example, if you use the <code>removeItemAt()</code> method on a
	 * VectorCollection, you remove the item from the underlying Vector.
	 * 
	 * @mxml
	 * 
	 * <p>The <code>&#60;flame:VectorCollection&#62;</code> tag inherits all the attributes of its
	 * superclass, and adds the following attributes:</p>
	 * <pre>
	 * &#60;flame:VectorCollection
	 * <strong>Properties</strong>
	 * source="null"
	 * /&#62;
	 * </pre>
	 * 
	 * @example The following code creates a simple VectorCollection object that
	 * accesses and manipulates a Vector with a single int element.
	 * It retrieves the element using the IList interface <code>getItemAt()</code> method
	 * and an IViewCursor object that it obtains using the ICollectionView <code>createCursor()</code> method.
	 * <pre>
	 * var myCollection:VectorCollection = new VectorCollection(new &#60;Contact&#62;[ new Contact("Matt", "Matthews") ]);
	 * var myCursor:IViewCursor = myCollection.createCursor();
	 * var firstItem:Object = myCollection.getItemAt(0);
	 * var firstItemFromCursor:Object = myCursor.current;
	 * if (firstItem == firstItemFromCursor)
	 * 	doCelebration();
	 * </pre>
	 * 
	 * @see mx.collections.ICollectionView
	 * @see mx.collections.IList
	 */
	public class VectorCollection extends ListCollectionView implements IExternalizable
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		protected var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the VectorCollection class.
		 * 
		 * @param source The data source to use.
		 * 
		 * @throws TypeError <code>source</code> parameter must be of type 'Vector'.
		 */
		public function VectorCollection(source:* = null)
		{
			super();
			
			if (source != null && !VectorUtil.isVector(source))
				throw new TypeError(_resourceManager.getString("flameCore", "argTypeMismatch", [ "source", getQualifiedClassName(Vector.<*>) ]));
			
			this.source = source;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public function readExternal(input:IDataInput):void
		{
			if (list is IExternalizable)
				IExternalizable(list).readExternal(input);
			else
				source = input.readObject();
		}
		
		/**
		 * @private
		 */
		public function writeExternal(output:IDataOutput):void
		{
			if (list is IExternalizable)
				IExternalizable(list).writeExternal(output);
			else
				output.writeObject(list);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		[Bindable("listChanged")]
		[Inspectable(category="General")]
		
		/**
		 * Gets or sets the source of data in the VectorCollection.
		 * <p>The VectorCollection object does not represent any changes that you make
		 * directly to the source Vector. Always use the ICollectionView or IList methods to modify the collection.</p>
		 * 
		 * @throws TypeError <code>value</code> parameter must be of type 'Vector'.
		 * 
		 * @see mx.collections.ICollectionView
		 * @see mx.collections.IList
		 */
		public function get source():*
		{
			return list is VectorList ? VectorList(list).source : null;
		}
		
		/**
		 * @private
		 */
		public function set source(value:*):void
		{
			if (value != null && !VectorUtil.isVector(source))
				throw new TypeError(_resourceManager.getString("flameCore", "argTypeMismatch",
					[ "value", getQualifiedClassName(Vector.<*>) ]));
			
			list = new VectorList(value);
		}
	}
}