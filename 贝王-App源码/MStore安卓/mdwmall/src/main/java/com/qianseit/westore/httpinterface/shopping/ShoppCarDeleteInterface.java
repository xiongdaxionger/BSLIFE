package com.qianseit.westore.httpinterface.shopping;



import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;

import java.util.Set;

/**
 * @author admin 3.4 删除购物车商品
 */
public abstract class ShoppCarDeleteInterface extends BaseShoppCarInterface {

	/**
	 * 修改类型goods:商品| all:清空购物车
	 */
	String mType = "goods";
	final String mTypeName = "obj_type";
	/**
	 * 修改对象
	 */
	String mGoodIdent = "";
	final String mGoodIdentName = "goods_ident";

	String mGoodsId = "goods";
	final String mGoodsIdName = "goods_id";
	int mProductCount = 0;
	/**
	 * 删除数量
	 */
	int mProductQty = 0;
	final String mProductQtyName = "modify_quantity[%s][quantity]";
	/**
	 * 配件数量
	 */
	int mAdjunctQty = 0;
	final String mAdjunctQtyName = "modify_quantity[%s][adjunct][%d][%d][quantity]";
	/**
	 * 已选中购物车的选项
	 */
	String mSelectedIdent = "";
	final String mSelectedIdentName = "obj_ident[%d]";

	ContentValues mAdjunctContentValues = new ContentValues();
	ContentValues mGiftScoreContentValues = new ContentValues();
	ContentValues mSelectedContentValues = new ContentValues();
	ContentValues mBatchContentValues = new ContentValues();

	public ShoppCarDeleteInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.cart.remove";
	}

	public void setData(String goodsIdent, String goodsId, int productQty) {
		mType = "goods";
		mAdjunctContentValues.clear();
		mSelectedContentValues.clear();
		mBatchContentValues.clear();
		mGiftScoreContentValues.clear();
		mSelectedIdent = "";
		mGoodIdent = goodsIdent;
		mGoodsId = goodsId;
		mProductQty = productQty;
		mAdjunctQty = 0;
		mProductCount = 0;
	}
	
	public void reset(){
		mAdjunctQty = 0;
		mProductQty = 0;
		mAdjunctContentValues.clear();
		mSelectedContentValues.clear();
		mBatchContentValues.clear();
		mGiftScoreContentValues.clear();
		mType = "goods";
		mSelectedIdent = "";
		mGoodIdent = "";
		mGoodsId ="";
		mProductCount = 0;
	}
	
	public void addProduct(String goodsIdent, String goodsId, int productQty){
		mBatchContentValues.put(String.format("goods_ident[%d]", mProductCount), goodsIdent);
		mBatchContentValues.put(String.format("goods_id[%d]", mProductCount), goodsId);
		mBatchContentValues.put(String.format(mProductQtyName, goodsIdent), String.valueOf(productQty));
		mProductCount++;
		mProductQty += productQty;
	}

	/**
	 * 清空购物车
	 */
	public void clear() {
		mType = "all";
		RunRequest();
	}

	public int getQty() {
		return mProductQty + mAdjunctQty;
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put(mTypeName, mType);
		if (mBatchContentValues.size() > 0) {
			nContentValues.putAll(mBatchContentValues);
		} else if(!TextUtils.isEmpty(mGoodsId)) {
			nContentValues.put(mGoodIdentName, mGoodIdent);
			nContentValues.put(mGoodsIdName, mGoodsId);
			if (mProductQty > 0) {
				nContentValues.put(String.format(mProductQtyName, mGoodIdent), String.valueOf(mProductQty));
			}
		}
		
		if (mGiftScoreContentValues.size() > 0) {
			nContentValues.putAll(mGiftScoreContentValues);
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
	 * @param groupId
	 *            组id
	 * @param productId
	 *            货品id
	 * @param adjunctQty
	 *            配件数量
	 */
	public void addAdjunct(int groupId, int productId, int adjunctQty) {
		String nKey = String.format(mAdjunctQtyName, mGoodIdent, groupId, productId);
		if (mAdjunctContentValues.containsKey(nKey)){
			mAdjunctContentValues.put(nKey, mAdjunctContentValues.getAsInteger(nKey) + adjunctQty);
		}else{
			mAdjunctContentValues.put(nKey, adjunctQty);
		}
		mAdjunctQty += adjunctQty;
	}
	
	public void addGiftScore(String giftIdent, int giftQty){
		mGiftScoreContentValues.put(String.format("modify_quantity[%s][gift]", giftIdent), String.valueOf(giftQty));
		mProductCount++;
		mProductQty += giftQty;
		mType = "gift";
	}

	/**
	 * @param goodsIdent
	 */
	public void addSelected(String goodsIdent) {
		Set<String> nStrings = mSelectedContentValues.keySet();
		for (String string : nStrings) {
			if (mSelectedContentValues.getAsString(string).equals(goodsIdent)) {
				return;
			}
		}

		mSelectedContentValues.put(String.format(mSelectedIdentName, mSelectedContentValues.size()), goodsIdent);
	}
}
