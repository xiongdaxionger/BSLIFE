package com.qianseit.westore.httpinterface.shopping;

import android.content.ContentValues;

import java.util.List;


import com.qianseit.westore.base.QianseitActivityInterface;

public abstract class ShoppCarAddInterface extends BaseShoppCarInterface {
	boolean mIsFastby = false;
	/**
	 * 积分兑换商品
	 */
	boolean mIsGift = false;
	String mGoodsId;
	String mProductId;
	int mQty;
	int mAdjunctQty = 0;
	ContentValues mAdjunctContentValues = new ContentValues();

	public ShoppCarAddInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.cart.add";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("goods[goods_id]", mGoodsId);
		nContentValues.put("goods[product_id]", mProductId);
		nContentValues.put("goods[num]", String.valueOf(mQty));
		nContentValues.put("btype", mIsFastby?"is_fastbuy":"");
		nContentValues.put("obj_type", mIsGift?"gift":"goods");
		
		if (mAdjunctContentValues.size() > 0) {
			nContentValues.putAll(mAdjunctContentValues);
		}
		return nContentValues;
	}
	
	public void setData(String goodsId, String productId, int qty){
		mIsFastby = false;
		mIsGift = false;
		mGoodsId = goodsId;
		mProductId = productId;
		mQty = qty;
		mAdjunctQty = 0;
		mAdjunctContentValues.clear();
	}
	
	/**
	 * 拼接当前加入购物车商品的ident_id
	 * @return
	 */
	public String getIdentId(){
		String nIdent = String.format("%s_%s_%s", mIsGift?"gift":"goods", mGoodsId, mProductId);
		return nIdent;
	}

	/**
	 * 是立即购买
	 */
	public void setIsFastBuy(){
		mIsFastby = true;
	}

	public boolean isFastBuy(){
		return mIsFastby;
	}
	
	public int getQty(){
		return mAdjunctQty + mQty;
	}
	
	/**
	 * 是积分兑换商品
	 */
	public void setIsGift(){
		mIsGift = true;
	}

	public void setAdjunct(List<AdjunctBean> adjunctBeans){
		for (AdjunctBean adjunctBean : adjunctBeans) {
			addAdjunct(adjunctBean.groupId, adjunctBean.productId, adjunctBean.qty);
		}
	}
	
	/**
	 * @param groupId 组id
	 * @param productId 货品id
	 * @param adjunctQty 配件数量
	 */
	public void addAdjunct(int groupId, int productId, int adjunctQty){
		String nKey = String.format("adjunct[%d][%d]", groupId, productId);

		if (mAdjunctContentValues.containsKey(nKey)){
			mAdjunctContentValues.put(nKey, mAdjunctContentValues.getAsInteger(nKey) + adjunctQty);
		}else{
			mAdjunctContentValues.put(nKey, adjunctQty);
		}

		mAdjunctQty += adjunctQty;
	}
	
	public static class AdjunctBean{
		public int groupId, productId, qty;
		public AdjunctBean(int groupId, int productId, int qty){
			this.groupId = groupId;
			this.productId = productId;
			this.qty = qty;
		}
	}
}
