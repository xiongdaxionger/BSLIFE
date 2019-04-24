package com.qianseit.westore.base;

import java.util.List;

import org.json.JSONObject;

import android.widget.ListView;

public class County {
	private String name;
	private List<JSONObject> dataList;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<JSONObject> getDataList() {
		return dataList;
	}

	public void setDataList(List<JSONObject> dataList) {
		this.dataList = dataList;
	}
}
