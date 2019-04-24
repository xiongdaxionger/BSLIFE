package com.qianseit.westore.httpinterface.shopping;



import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;

import java.util.Set;

/**
 * @author admin
 * 3.3 修改购物车数量
 *
 */
public abstract class ShoppCarUpdateInterface extends BaseShoppCarInterface {
	
	/**
	 * 	修改类型goods:商品
	 */
	String mType = "goods";
	final String mTypeName = "obj_type";
	/**
	 * 	修改对象
	 */
	String mGoodIdent = "";
	final String mGoodIdentName = "goods_ident";
	
	String mGoodsId = "goods";
	final String mGoodsIdName = "goods_id";
	/**
	 * 修改数量
	 */
	int mProductQty = 0;
	final String mProductQtyName = "modify_quantity[%s][quantity]";
	/**
	 * 配件数量
	 */
	String mAdjunctQty = "";
	final String mAdjunctQtyName = "modify_quantity[%s][adjunct][%d][%d][quantity]";
	/**
	 * 已选中购物车的选项
	 */
	String mSelectedIdent = "";
	final String mSelectedIdentName = "obj_ident[%d]";
	
	ContentValues mAdjunctContentValues = new ContentValues();
	ContentValues mSelectedContentValues = new ContentValues();

	public ShoppCarUpdateInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.cart.update";
	}

	public void setData(String goodsIdent, String goodsId, int productQty){
		mAdjunctContentValues.clear();
		mSelectedContentValues.clear();
		mSelectedIdent = "";
		mGoodIdent = goodsIdent;
		mGoodsId = goodsId;
		mProductQty = productQty;
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put(mTypeName, mType);
		nContentValues.put(mGoodIdentName, mGoodIdent);
		nContentValues.put(mGoodsIdName, mGoodsId);
		
		if (mProductQty > 0) {
			nContentValues.put(String.format(mProductQtyName, mGoodIdent), String.valueOf(mProductQty));
		}
		
		if (mAdjunctContentValues.size() > 0) {
			nContentValues.putAll(mAdjunctContentValues);
		}
		if (mSelectedContentValues.size() > 0) {
			nContentValues.putAll(mSelectedContentValues);
		}
		return nContentValues;
	}
	
	/**
	 * @param groupId 组id
	 * @param productId 货品id
	 * @param adjunctQty 配件数量
	 */
	public void addAdjunct(int groupId, int productId, int adjunctQty){
		String nKey = String.format(mAdjunctQtyName, mGoodIdent, groupId, productId);
		if (mAdjunctContentValues.containsKey(nKey)){
			mAdjunctContentValues.put(nKey, mAdjunctContentValues.getAsInteger(nKey) + adjunctQty);
		}else{
			mAdjunctContentValues.put(nKey, adjunctQty);
		}
	}

	/**
	 * @param goodsIdent
	 */
	public void addSelected(String goodsIdent){
		Set<String> nStrings = mSelectedContentValues.keySet();
		for (String string : nStrings) {
			if (mSelectedContentValues.getAsString(string).equals(goodsIdent)) {
				return;
			}
		}

		mSelectedContentValues.put(String.format(mSelectedIdentName, mSelectedContentValues.size()), goodsIdent);
	}
}
