package com.qianseit.westore.httpinterface.shopping;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class ShoppCarNouserCouponInterface extends BaseHttpInterfaceTask {

	String mCouponNumber;
	boolean mIsFastBy = false;
	
	public ShoppCarNouserCouponInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.cart.removeCartCoupon";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("cpn_ident", mCouponNumber);
		if (mIsFastBy) {
			nContentValues.put("is_fastbuy", "1");
		}
		return nContentValues;
	}
	
	/**
	 * @param couponNumber
	 */
	public void nouseCoupon(String couponNumber){
		nouseCoupon(couponNumber, false);
	}

	/**
	 * @param couponNumber
	 */
	public void nouseCoupon(String couponNumber, boolean isFastBy){
		mCouponNumber = couponNumber;
		mIsFastBy = isFastBy;
		RunRequest();
	}
}
