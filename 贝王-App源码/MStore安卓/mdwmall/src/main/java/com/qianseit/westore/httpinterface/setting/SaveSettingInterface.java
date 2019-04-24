package com.qianseit.westore.httpinterface.setting;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class SaveSettingInterface extends BaseHttpInterfaceTask {

	String mFieldName;
	String mValue;
	File mImageFile;
	List<String> mValueList = new ArrayList<String>();
	public SaveSettingInterface(QianseitActivityInterface activityInterface, String fieldName, String value) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mFieldName = fieldName;
		mValue = value;
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.save_setting";
	}

	public String getValue(){
		return mValue;
	}

	public List<String> getValueList(){
		return mValueList;
	}

	public String getFieldName(){
		return mFieldName;
	}

	public void save(String fieldName, String value){
		mValueList.clear();
		mImageFile = null;
		mFieldName = fieldName;
		mValue = value;
		RunRequest();
	}

	public void save(String fieldName, File imageFile){
		mValueList.clear();
		mImageFile = imageFile;
		mFieldName = fieldName;
		mValue = "";
		RunRequest();
	}

	public void save(String fieldName, List<String> valueList){
		mValueList.clear();
		mValueList.addAll(valueList);
		mImageFile = null;
		mFieldName = fieldName;
		mValue = "";
		RunRequest();
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		if (!TextUtils.isEmpty(mValue)) {
			nContentValues.put(mFieldName, mValue);
		}
		if (mValueList.size() > 0) {//多选项
			int i = 0;
			for (String string : mValueList) {
				nContentValues.put(String.format("box:%s[%d]", mFieldName, i), string);
				i++;
			}
		}
		return nContentValues;
	}
	
	@Override
	public Map<String, File> BuildFiles() {
		// TODO Auto-generated method stub
		Map<String, File> nMap = new HashMap<String, File>();
		if (mImageFile != null) {
			nMap.put(mFieldName, mImageFile);
		}
		return nMap;
	}
}
