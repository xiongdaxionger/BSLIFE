/*
 * Copyright (c) 2015, Balilan Co.,Ltd. All rights reserved.
 *
 */

package com.qianseit.westore.util;

import android.text.TextUtils;
import android.text.format.DateFormat;

import com.qianseit.westore.Run;

import org.json.JSONObject;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * @author yangtq
 */
public class StringUtils {
    final static SimpleDateFormat nLongStringTimeDf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    final static SimpleDateFormat nShortStringTimeDf = new SimpleDateFormat("yyyy-MM-dd");
    final static String mIdentityCardRex = "^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$|^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X|x)$";
    final static String[] WEEK = new String[]{"周日", "周一", "周二", "周三", "周四", "周五", "周六"};
    static final int WEEKDAYS = 7;
    static String[] units = {"", "十", "百", "千", "万", "十万", "百万", "千万", "亿", "十亿", "百亿", "千亿", "万亿"};
    static char[] numArray = {'零', '一', '二', '三', '四', '五', '六', '七', '八', '九'};

    public static String PhoneToPW(String phoneString) {

        String nPhone1String = "";
        String nPhone2String = "";
        if (phoneString.length() == 11) {
            nPhone1String = phoneString.substring(0, 3);
            nPhone2String = phoneString.substring(7, 11);
            phoneString = nPhone1String + "****" + nPhone2String;
        }

        return phoneString;
    }

    public static String IdentityToPW(String identityString) {
        String nIdentityString = identityString;
        if (identityString.length() >= 15) {
            String nFormatString = "%" + (identityString.length() - 2) + "s";
            nIdentityString = identityString.substring(0, 1) + String.format(nFormatString, "").replace(" ", "*") + identityString.substring(identityString.length() - 1);
        }

        return nIdentityString;
    }

    public static String BankCardNumberToPW(String bankCardNumberString) {

        String nBankCardNumber1String = "";
        String nBankCardNumberItemBeginString = "";
        String nBankCardNumberItemEndString = "";
        String nBankCardNumberItemCenterString = "";
        List<String> nBankCardNumberItemCenterItems = new ArrayList<String>();
        nBankCardNumber1String = bankCardNumberString.replace(" ", "");
        if (nBankCardNumber1String.length() > 8) {
            nBankCardNumberItemBeginString = nBankCardNumber1String.substring(0, 4);
            nBankCardNumberItemEndString = nBankCardNumber1String.substring(nBankCardNumber1String.length() - 4, nBankCardNumber1String.length());
            nBankCardNumberItemCenterString = nBankCardNumber1String.substring(4, nBankCardNumber1String.length() - 4);
        } else {
            return bankCardNumberString;
        }

        int nCenterLen = nBankCardNumberItemCenterString.length();
        int nStartIndex = 0;
        while (nCenterLen - nStartIndex > 4) {
            nBankCardNumberItemCenterItems.add(nBankCardNumberItemCenterString.substring(nStartIndex, nStartIndex + 4));
            nStartIndex = nStartIndex + 4;
        }
        if (nStartIndex < nCenterLen) {
            nBankCardNumberItemCenterItems.add(nBankCardNumberItemCenterString.substring(nStartIndex, nCenterLen));
        }

        StringBuilder nBuilder = new StringBuilder();
        nBuilder.append(nBankCardNumberItemBeginString);
        for (int i = 0; i < nBankCardNumberItemCenterItems.size(); i++) {
            String nFormatString = "%" + nBankCardNumberItemCenterItems.get(i).length() + "s";
            nBuilder.append(" ").append(String.format(nFormatString, "").replace(" ", "*"));
        }
        nBuilder.append(" ").append(nBankCardNumberItemEndString);
        return nBuilder.toString();
    }

    public static String BankCardNumber(String bankCardNumberString) {

        String nBankCardNumber1String = "";
        String nBankCardNumberItemEndString = "";
        String nBankCardNumberItemCenterString = "";
        List<String> nBankCardNumberItemCenterItems = new ArrayList<String>();
        nBankCardNumber1String = bankCardNumberString.replace(" ", "");
        if (nBankCardNumber1String.length() > 8) {
            nBankCardNumberItemEndString = nBankCardNumber1String.substring(nBankCardNumber1String.length() - 4, nBankCardNumber1String.length());
            nBankCardNumberItemCenterString = nBankCardNumber1String.substring(0, nBankCardNumber1String.length() - 4);
        } else {
            return bankCardNumberString;
        }

        int nCenterLen = nBankCardNumberItemCenterString.length();
        int nStartIndex = 0;
        while (nCenterLen - nStartIndex > 4) {
            nBankCardNumberItemCenterItems.add(nBankCardNumberItemCenterString.substring(nStartIndex, nStartIndex + 4));
            nStartIndex = nStartIndex + 4;
        }
        if (nStartIndex < nCenterLen) {
            nBankCardNumberItemCenterItems.add(nBankCardNumberItemCenterString.substring(nStartIndex, nCenterLen));
        }

        StringBuilder nBuilder = new StringBuilder();
        for (int i = 0; i < nBankCardNumberItemCenterItems.size(); i++) {
            String nFormatString = "%" + nBankCardNumberItemCenterItems.get(i).length() + "s";
            nBuilder.append(" ").append(String.format(nFormatString, "").replace(" ", "*"));
        }
        nBuilder.append(" ").append(nBankCardNumberItemEndString);
        return nBuilder.toString();
    }

    public static boolean VerifyIdentityCard(String identityCard) {
        if (identityCard == null || TextUtils.isEmpty(identityCard)) {
            return false;
        }

        return identityCard.matches(mIdentityCardRex);
    }

    public static String FormatArea(String areaString) {
        String nAreaString = areaString.replace("mainland:", "").replace("/", " ");
        int indexAreaNo = nAreaString.indexOf(':');
        indexAreaNo = indexAreaNo > 0 ? indexAreaNo : nAreaString.length();
        nAreaString = nAreaString.substring(0, indexAreaNo);
        return nAreaString;
    }

    /**
     * 对字符做一些通用处理（null转为""）
     *
     * @param souceString
     * @return
     */
    public static String CommfilterString(String souceString) {
        if (souceString == null) {
            return "";
        }

        if (souceString.equalsIgnoreCase("null")) {
            return "";
        }

        return souceString;
    }

    /**
     * @param time
     * @return yyyy-MM-dd HH:mm:ss
     */
    public static String LongTimeToLongString(long time) {
        return LongTimeToString("yyyy-MM-dd HH:mm:ss", time);
    }

    /**
     * @param time
     * @return yyyy-MM-dd
     */
    public static String LongTimeToShortString(long time) {
        return LongTimeToString("yyyy-MM-dd", time);
    }

    public static String LongTimeToString(String timeFormatString, long time) {
        long nTime = time < 10000000000l ? time * 1000 : time;
        return DateFormat.format(timeFormatString, nTime).toString();
    }

    /**
     * @param time
     * @return 1分钟内：刚刚|60分钟以内：xx分钟前|24小时以内：xx小时前|从当前至上个月的今天：xx天前|从当前至上一年的今天：xx月前|xx年前
     */
    public static String friendlyFormatTime(long time) {
        long oldTime = time < 10000000000l ? time * 1000 : time;
        Date nInputDate = new Date(oldTime);
        Calendar nInputCalendar = Calendar.getInstance();
        nInputCalendar.setTime(nInputDate);

        Date nDate = new Date(System.currentTimeMillis());
        time = (nDate.getTime() - oldTime) / 1000;
        Calendar nCalendar = Calendar.getInstance();
        nCalendar.setTime(nDate);

        Calendar nPreCalendar = Calendar.getInstance();
        nPreCalendar.setTime(nCalendar.getTime());
        nPreCalendar.add(Calendar.MONTH, -1);

        int nDaysOfMonth = nCalendar.getActualMaximum(Calendar.DAY_OF_MONTH);
        int nDaysOfPerMonth = nPreCalendar.getActualMaximum(Calendar.DAY_OF_MONTH);
        long nDays = time / 86400;

        if (time < 60) {
            return Run.buildString(time, "刚刚");
        } else if (time < 3600) {
            return Run.buildString(time / 60, "分钟前");
        } else if (time < 86400) {
            return Run.buildString(time / 3600, "小时前");
        } else if (time < 86400 * nDaysOfMonth) {
            if (nCalendar.get(Calendar.DAY_OF_MONTH) + nDaysOfPerMonth < nDays) {
                return "1月前";
            } else {
                return Run.buildString(nDays, "天前");
            }
        } else {
            int nMonth = nCalendar.get(Calendar.MONTH) + 1;
            int nInputMonth = nInputCalendar.get(Calendar.MONTH) + 1;
            int nYear = nCalendar.get(Calendar.YEAR);
            int nInputYear = nInputCalendar.get(Calendar.YEAR);
            int nDifMonth = nMonth - (nYear == nInputYear ? nInputMonth : ((nInputMonth - 12) - (nYear - nInputYear - 1) * 12));
            if (nInputCalendar.get(Calendar.DAY_OF_MONTH) >= nMonth) nDifMonth = nDifMonth - 1;
            if (nDifMonth == 0){
                return Run.buildString(nDays, "天前");
            }else if (nDifMonth < 12) {
                return Run.buildString(nDifMonth, "月前");
            } else {
                return Run.buildString(nDifMonth / 12, "年前");
            }
        }
    }

    /**
     * @param time
     * @return 如20分钟，15秒， 2小时 或 yyyy-MM-dd HH:mm:ss
     */
    public static String friendly2FormatTime(long time) {
        if (time < 60) {
            if (time == 0) {
                return Run.buildString(time, "1秒");
            }
            return Run.buildString(time, "秒");
        } else if (time < 3600) {
            return Run.buildString(time / 60, "分钟");
        } else if (time < 86400) {
            return Run.buildString(time / 3600, "小时");
        } else {
            return LongTimeToString("yyyy-MM-dd HH:mm:ss", time);
        }
    }

    /**
     * 日期变量转成对应的星期字符串
     *
     * @param date
     * @return
     */
    public static String DateToWeek(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        int dayIndex = calendar.get(Calendar.DAY_OF_WEEK);
        if (dayIndex < 1 || dayIndex > WEEKDAYS) {
            return null;
        }

        return WEEK[dayIndex - 1];
    }

    public static String formatLongStringTime(String timeFormatString, String longTimeString) {
        Date nDate = new Date();
        try {
            nDate = nLongStringTimeDf.parse(longTimeString);
        } catch (ParseException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }

        return LongTimeToString(timeFormatString, nDate.getTime());
    }

    public static String formatShortStringTimeToSecTime(String shortTime) {
        Date nDate = new Date();
        try {
            nDate = nShortStringTimeDf.parse(shortTime);
        } catch (ParseException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }

        return nDate.getTime() / 1000 + "";
    }

    public static String friendlyFormatLongStringTime(String longTimeString) {
        Date nDate = new Date();
        try {
            nDate = nLongStringTimeDf.parse(longTimeString);
        } catch (ParseException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }

        return friendlyFormatTime(nDate.getTime());
    }

    public static String prasePrice(double price) {
        return String.format("%.2f", price);
    }

    public static String formatPrice(String price) {
        Double nPrice = 0d;
        nPrice = Double.parseDouble(price);
        return prasePrice(nPrice);
    }

    public static String prasePrice(JSONObject jsonObject, String keyString) {
        if (jsonObject == null || keyString == null) {
            return "";
        }
        return prasePrice(jsonObject.optDouble(keyString, 0d));
    }

    /**
     * @param num
     * @return 转为中文数字
     */
    public static String formatInteger2ChinaNum(int num) {
        char[] val = String.valueOf(num).toCharArray();
        int len = val.length;
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < len; i++) {
            String m = val[i] + "";
            int n = Integer.valueOf(m);
            boolean isZero = n == 0;
            String unit = units[(len - 1) - i];
            if (isZero && i > 0) {
                if ('0' == val[i - 1]) {
                    // not need process if the last digital bits is 0
                    continue;
                } else {
                    // no unit for 0
                    sb.append(numArray[n]);
                }
            } else {
                sb.append(numArray[n]);
                sb.append(unit);
            }
        }
        return sb.toString();
    }

    /**
     * @param decimal
     * @return 转为中文小数
     */
    public static String formatDecimal2ChinaNum(double decimal) {
        String decimals = String.valueOf(decimal);
        int decIndex = decimals.indexOf(".");
        int integ = Integer.valueOf(decimals.substring(0, decIndex));
        int dec = Integer.valueOf(decimals.substring(decIndex + 1));
        String result = formatInteger2ChinaNum(integ) + "." + formatFractionalPart2ChinaNum(dec);
        return result;
    }

    /**
     * @param decimal
     * @return 小数部分
     */
    public static String formatFractionalPart2ChinaNum(int decimal) {
        char[] val = String.valueOf(decimal).toCharArray();
        int len = val.length;
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < len; i++) {
            int n = Integer.valueOf(val[i] + "");
            sb.append(numArray[n]);
        }
        return sb.toString();
    }

    /**
     * 过滤null
     *
     * @param jsonObject
     * @param fieldName
     * @return
     */
    public static String getString(JSONObject jsonObject, String fieldName) {
        if (jsonObject == null || TextUtils.isEmpty(fieldName)) {
            return "";
        }

        String nString = jsonObject.optString(fieldName);
        if (nString != null && nString.equalsIgnoreCase("null")) {
            nString = "";
        }

        return nString;
    }
}
