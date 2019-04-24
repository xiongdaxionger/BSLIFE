package com.qianseit.westore.httpinterface.goods;


import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class GoodsAddCommentsInterface extends BaseHttpInterfaceTask {

	String mMemberIdString;
	String mGoodsIdString;
	String mContentString;
	String mOrderIdString;
	
	public GoodsAddCommentsInterface(QianseitActivityInterface activityInterface, String memberIdString, String goodsIdString, String contentString, String orderIdString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mMemberIdString = memberIdString;
		mGoodsIdString = goodsIdString;
		mContentString = contentString;
		mOrderIdString = orderIdString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.goods.add_comment";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("member_id", mMemberIdString);
		nContentValues.put("goods_id", mGoodsIdString);
		nContentValues.put("content", mContentString);
		nContentValues.put("order_id", mOrderIdString);
		return nContentValues;
	}

}
