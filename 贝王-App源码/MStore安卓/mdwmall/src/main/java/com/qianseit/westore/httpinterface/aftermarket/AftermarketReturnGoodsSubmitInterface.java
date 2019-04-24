package com.qianseit.westore.httpinterface.aftermarket;

import android.content.ContentValues;

import java.io.File;
import java.util.HashMap;
import java.util.Map;


import org.json.JSONArray;
import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class AftermarketReturnGoodsSubmitInterface extends BaseHttpInterfaceTask {
	String mOrderIdString;
	JSONArray nReturnProducts;
	String mTitleString;
	String mContentString;
	File mImageFile;

	public AftermarketReturnGoodsSubmitInterface(QianseitActivityInterface activityInterface, String orderIdString, JSONArray products, String titleString, String contentString, File imageFile) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mOrderIdString = orderIdString;
		nReturnProducts = products;
		mTitleString = titleString;
		mContentString = contentString;
		mImageFile = imageFile;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.aftersales.return_save";
	}

	@Override
	public Map<String, File> BuildFiles() {
		// TODO Auto-generated method stub
		if (mImageFile != null) {
			Map<String, File> nMap = new HashMap<String, File>();
			nMap.put("file", mImageFile);
			return nMap;
		}

		return super.BuildFiles();
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("order_id", mOrderIdString);
		nContentValues.put("product_data", nReturnProducts.toString());
		nContentValues.put("title", mTitleString);
		nContentValues.put("content", mContentString);
		nContentValues.put("agree", "true");
		nContentValues.put("type", "1");
		return nContentValues;
	}
}
