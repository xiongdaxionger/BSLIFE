package com.qianseit.westore.httpinterface.member;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

public abstract class MemberUploadImageInterface extends BaseHttpInterfaceTask {

	File mFile;
	
	public MemberUploadImageInterface(QianseitActivityInterface activityInterface, File file) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
		mFile = file;
	}

	@Override
	public Map<String, File> BuildFiles() {
		// TODO Auto-generated method stub
		Map<String, File> nMap = new HashMap<String, File>();
		nMap.put("file", mFile);
		return nMap;
	}
	
	public void uploadImage(File file){
		mFile = file;
		RunRequest();
	}
	
	public String getFileFullPath(){
		return mFile == null ? "" : "file://" + mFile.getAbsolutePath();
	}
	
	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.uploadImg";
	}
}
