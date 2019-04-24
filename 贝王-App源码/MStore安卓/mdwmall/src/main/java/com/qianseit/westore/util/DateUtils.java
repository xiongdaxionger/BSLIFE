package com.qianseit.westore.util;

import android.annotation.SuppressLint;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {
	private static SimpleDateFormat sf = null;

	/* 获取系统时间 格式为："yyyy/MM/dd " */
	public static String getCurrentDate() {
		Date d = new Date();
		sf = new SimpleDateFormat("yyyy年MM月dd日");
		return sf.format(d);
	}
	
	public static String getCurrentDate(String FormatType) {
		Date d = new Date();
		sf = new SimpleDateFormat(FormatType);
		return sf.format(d);
	}


	/* 时间戳转换成字符窜 */
	@SuppressLint("SimpleDateFormat")
	public static String getDateToString(long time) {
		Date d = new Date(time);
		sf = new SimpleDateFormat("yyyy年MM月dd日");
		return sf.format(d);
	}

	@SuppressLint("SimpleDateFormat")
	public static String getDateToString(long time,String FormatType) {
		Date d = new Date(time);
		sf = new SimpleDateFormat(FormatType);
		return sf.format(d);
	}
	/* 将字符串转为时间戳 */
	@SuppressLint("SimpleDateFormat")
	public static long getStringToDate(String time) {
		sf = new SimpleDateFormat("yyyy年MM月dd日");
		Date date = new Date();
		try {
			date = sf.parse(time);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return date.getTime();
	}
	public static long getStringToDate(String time,String FormatType) {
		sf = new SimpleDateFormat(FormatType);
		Date date = new Date();
		try {
			date = sf.parse(time);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return date.getTime();
	}
	
}
