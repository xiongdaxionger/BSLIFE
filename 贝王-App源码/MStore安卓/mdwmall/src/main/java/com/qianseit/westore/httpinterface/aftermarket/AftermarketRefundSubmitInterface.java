package com.qianseit.westore.httpinterface.aftermarket;


import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class AftermarketRefundSubmitInterface extends BaseHttpInterfaceTask {
	String mOrderIdString;
	String mTitleString;
	String mContentString;
	
	ContentValues mnContentValues = new ContentValues();
	int mProductCount = 0;
	int mType = 1;

	ContentValues mImageValuePair = new ContentValues();

	public AftermarketRefundSubmitInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "aftersales.aftersales.return_save";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("order_id", mOrderIdString);
		nContentValues.put("title", mTitleString);
		nContentValues.put("content", mContentString);
		nContentValues.put("type", String.valueOf(mType));
		nContentValues.put("agree", "on");
		nContentValues.putAll(mnContentValues);
		if (mImageValuePair != null && mImageValuePair.size() > 0) {
			nContentValues.putAll(mImageValuePair);
		}
		return nContentValues;
	}
	
	/**
	 * @param bn
	 * @param qty
	 * @param name
	 * @param price
	 */
	public void addGoods(String productId, String bn, String qty, String name, String price){
		mnContentValues.put(String.format("product_bn[%s]", productId), bn);
		mnContentValues.put(String.format("product_nums[%s]", productId), qty);
		mnContentValues.put(String.format("product_name[%s]", productId), name);
		mnContentValues.put(String.format("product_price[%s]", productId), price);
		mProductCount++;
	}

	public void reset(){
		mImageValuePair.clear();
		mnContentValues.clear();
		mProductCount = 0;
	}

	/**
	 * @param imageShortUrl 没有域名的图片路径
	 */
	public void addImage(String imageShortUrl){
		mImageValuePair.put(String.format("file[%d]", mImageValuePair.size()), imageShortUrl);
	}
	
	public void setRefundType(String orderIdString, int type){
		mOrderIdString = orderIdString;
		mType = type;
		reset();
	}

	public void refund(String titleString, String contentString){
		mTitleString = titleString;
		mContentString = contentString;
		RunRequest();
	}

	public int getRefundProductCount(){
		return mProductCount;
	}
}
