package com.qianseit.westore.activity.acco;

public interface PasswordVerfiyHandler {

	/**
	 * 
	 * @param json_str
	 *            反馈的json数据，字符串
	 */
	void result_success(String json_str);// 接收，保存结果数据,结束操作，对接收数据进行实际的UI线程操作

	/**
	 * 
	 * @return null
	 */
	void result_fail(String json_str);// 请求数据

}
