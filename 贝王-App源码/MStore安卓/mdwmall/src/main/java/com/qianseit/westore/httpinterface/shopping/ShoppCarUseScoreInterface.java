package com.qianseit.westore.httpinterface.shopping;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 *3.19 积分抵扣换算
 */
public abstract class ShoppCarUseScoreInterface extends BaseHttpInterfaceTask {
	float mRate = 0;
	int mScore = 0;

	public ShoppCarUseScoreInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.cart.count_digist";
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("point[rate]", String.valueOf(mRate));
		nContentValues.put("point[score]", String.valueOf(mScore));
		return nContentValues;
	}
	
	/**
	 * @param rate
	 * @param score
	 */
	public void useScore(float rate, int score){
		mRate = rate;
		mScore = score;
		RunRequest();
	}
}
