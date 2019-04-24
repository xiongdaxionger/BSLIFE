package com.qianseit.westore.httpinterface.member;


import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 *4.7 删除商品收藏
 */
public abstract class MemberDelFavInterface extends BaseHttpInterfaceTask {
	String mGoodsIdString;
	public MemberDelFavInterface(QianseitActivityInterface activityInterface, String goodsString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mGoodsIdString = goodsString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.ajax_del_fav";
	}
	
	public void delFav(String goodsId){
		mGoodsIdString = goodsId;
		RunRequest();
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("gid", mGoodsIdString);
		return nContentValues;
	}
}
