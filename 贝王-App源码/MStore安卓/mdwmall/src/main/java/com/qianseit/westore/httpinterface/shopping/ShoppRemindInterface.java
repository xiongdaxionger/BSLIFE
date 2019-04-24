package com.qianseit.westore.httpinterface.shopping;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 * 保存调：9.2 订阅提醒|取消调：9.3 取消订阅
 */
public abstract class ShoppRemindInterface extends BaseHttpInterfaceTask {

	protected boolean isSave = true;
	String mProductId, mType, mRemindTime, mBeginTime;

	public ShoppRemindInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		if (isSave) {
			nContentValues.put("product_id", mProductId);
			nContentValues.put("type_id", mType);
			nContentValues.put("remind_time", mRemindTime);
			nContentValues.put("begin_time", mBeginTime);
		}else{
			nContentValues.put("product_id", mProductId);
		}
		return nContentValues;
	}
	
	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return isSave ? "starbuy.special.save_remind" : "starbuy.special.del_remind";
	}
	
	/**
	 * @param productId
	 * @param type special id
	 * @param remindTime 时间戳
	 * @param beginTime 时间戳
	 */
	public void save(String productId, String type, String remindTime, String beginTime){
		isSave = true;
		mProductId = productId;
		mType = type;
		mRemindTime = remindTime;
		mBeginTime = beginTime;
		RunRequest();
	}
	
	public void cancel(String productId){
		isSave = false;
		mProductId = productId;
		RunRequest();
	}
}
