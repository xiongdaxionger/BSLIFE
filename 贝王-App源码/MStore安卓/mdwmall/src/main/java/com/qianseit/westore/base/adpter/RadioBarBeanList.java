package com.qianseit.westore.base.adpter;

import java.util.ArrayList;


public class RadioBarBeanList extends ArrayList<RadioBarBean> {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1905145697545375381L;

	@Override
	public boolean add(RadioBarBean object) {
		for (int i = 0; i < this.size(); i++) {
			if (get(i).mId == object.mId) {
				return true;
			}
		}
		return super.add(object);
	}
	
	public void add(long id, String title, Object value){
		this.add(new RadioBarBean(title, id, value));
	}

	public void add(long id, String title){
		add(id, title, null);
	}
}
