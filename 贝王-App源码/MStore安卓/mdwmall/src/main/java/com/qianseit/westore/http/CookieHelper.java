package com.qianseit.westore.http;

import java.io.IOException;
import java.net.CookieHandler;
import java.net.CookieManager;
import java.net.URI;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.text.TextUtils;

import com.qianseit.westore.Run;

public class CookieHelper {
	public static int getCarQty(){
		return getIntCookie("S[CART_NUMBER]");
	}
	
	public static List<String> getCookie(){
		List<String> nCookie = null;
		CookieHandler nCookieHandler = CookieManager.getDefault();
		try {
			Map<String, List<String>> nMap = new HashMap<String, List<String>>();
			nMap = nCookieHandler.get(URI.create(Run.MAIN_URL), nMap);
			nCookie = nMap.get("Cookie");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return nCookie;
	}
	
	public static int getIntCookie(String key){
		int nValue = 0;
		List<String> nList = getCookie();
		if (!TextUtils.isEmpty(key) && nList != null && nList.size() > 0) {
			String nKey = key + "=";
			for (String string : nList) {
				if (string.startsWith(nKey)) {
					String nValueString = string.substring(nKey.length());
					if (!TextUtils.isEmpty(nValueString) && TextUtils.isDigitsOnly(nValueString)) {
						nValue = Integer.parseInt(nValueString);
					}
					break;
				}
			}
		}
		return nValue;
	}
}
