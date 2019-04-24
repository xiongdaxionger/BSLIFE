package com.qianseit.westore.httpinterface;

import android.content.ContentValues;

import java.io.File;
import java.util.List;
import java.util.Map;


import org.json.JSONObject;

public interface InterfaceHandler {
	String InterfaceName();
	ContentValues BuildParams();
	void SuccCallBack(JSONObject responseJson);
	Map<String, File> BuildFiles();
}
