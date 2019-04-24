package com.qianseit.westore.httpinterface.shopping;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author qianseit
 *3.17 使用优惠劵
 */
public abstract class ShoppCarUseCouponInterface extends BaseHttpInterfaceTask {

	String mCouponNumber;
	boolean mIsFastBy = false;
	public ShoppCarUseCouponInterface(QianseitActivityInterface activityInterface) {
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
		nContentValues.put("coupon", mCouponNumber);
		nContentValues.put("obj_type", "coupon");
		if (mIsFastBy) {
			nContentValues.put("is_fastbuy", "1");
		}
		return nContentValues;
	}
	
	/**
	 * @param couponNumber
	 */
	public void useCoupon(String couponNumber){
		useCoupon(couponNumber, false);
	}

	/**
	 * @param couponNumber
	 */
	public void useCoupon(String couponNumber, boolean isFastBy){
		mCouponNumber = couponNumber;
		mIsFastBy = isFastBy;
		RunRequest();
	}
}
