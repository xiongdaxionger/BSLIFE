package com.qianseit.westore.base;

public class FunctBean {
	public int id;
	public int resId;
	public String name;
	public String str;
	public int values;
	public int num;
	public boolean isSelect;
	
	public FunctBean(int id, int resId, String name,String str,boolean isSelect,int values) {
		this.id = id;
		this.resId = resId;
		this.name = name;
		this.str=str;
		this.isSelect=isSelect;
		this.values=values;
	}
	public FunctBean(int id, int resId, String name,String str,boolean isSelect,int values,int num) {
		this.id = id;
		this.resId = resId;
		this.name = name;
		this.str=str;
		this.isSelect=isSelect;
		this.values=values;
		this.num=num;
	}
	public FunctBean(int id, int resId, String name,String str) {
		this.id = id;
		this.resId = resId;
		this.name = name;
		this.str=str;
	}
	
	
	public String createJson() {
		return "{\"id\":" + id + ",\"name\":" + name + "\"}";
	}
}