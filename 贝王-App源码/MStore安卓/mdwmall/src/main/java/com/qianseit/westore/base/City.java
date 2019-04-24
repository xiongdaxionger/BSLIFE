package com.qianseit.westore.base;

import java.util.ArrayList;
import java.util.List;

public class City {
	private String name;
	private List<County> countList = new ArrayList<County>();

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<County> getCountList() {
		return countList;
	}

	public void setCountList(List<County> countList) {
		this.countList = countList;
	}
   
	
}
