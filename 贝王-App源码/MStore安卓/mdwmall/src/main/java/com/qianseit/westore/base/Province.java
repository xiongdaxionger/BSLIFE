package com.qianseit.westore.base;

import java.util.ArrayList;
import java.util.List;

public class Province {
private String name;
private List<City> cityList=new ArrayList<City>();
public String getName() {
	return name;
}
public void setName(String name) {
	this.name = name;
}
public List<City> getCityList() {
	return cityList;
}
public void setCityList(List<City> cityList) {
	this.cityList = cityList;
}
}
