package com.qianseit.westore.httpinterface.aftermarket;


import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class AftermarketSaveExpressInterface extends BaseHttpInterfaceTask {

	String mCompanyString;
	String mNumberString;
	String mReturnIdString;
	
	public AftermarketSaveExpressInterface(QianseitActivityInterface activityInterface, String companyString, String numberString, String returnIdString) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mCompanyString = companyString;
		mNumberString = numberString;
		mReturnIdString = returnIdString;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.aftersales.save_return_delivery";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("return_id", mReturnIdString);
		nContentValues.put("crop_code", mCompanyString);
		nContentValues.put("crop_no", mNumberString);
		return nContentValues;
	}
}
