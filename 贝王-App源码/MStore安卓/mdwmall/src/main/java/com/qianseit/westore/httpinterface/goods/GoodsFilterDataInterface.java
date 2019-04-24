package com.qianseit.westore.httpinterface.goods;

import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 1.6 相关数据筛选列表
 */
public abstract class GoodsFilterDataInterface extends BaseHttpInterfaceTask {

	String mCatId;
	public GoodsFilterDataInterface(QianseitActivityInterface activityInterface, String catId) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mCatId = TextUtils.isEmpty(catId) ? "" : catId;
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("cat_id", mCatId);
		return nContentValues;
	}
	
	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.gallery.filter_entries";
	}
	
	public void fetchFilterData(String catId){
		mCatId = catId;
		if (TextUtils.isEmpty(catId)) {
			SuccCallBack(null);
			return;
		}
		RunRequest();
	}
}
