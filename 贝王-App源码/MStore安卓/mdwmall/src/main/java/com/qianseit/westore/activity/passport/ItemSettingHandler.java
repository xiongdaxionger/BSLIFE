package com.qianseit.westore.activity.passport;

/**
 * @author qianseit
 * diy项接口，主要用于自定义注册项和个人信息修改
 */
public interface ItemSettingHandler {
	/**
	 * @return
	 * 获取设置项值
	 */
	String getSettingValue();

	/**
	 * @return
	 * 设置设置项值
	 */
	void setSettingValue(String t);

	/**
	 * @return
	 * 验证设置项值是否正确
	 */
	boolean verifySettingValue(String t);

	/**
	 * @return
	 * 验证设置项值是否正确
	 */
	void requestFoucs();
}
