package com.qianseit.westore.bean;

import android.content.Context;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.reflect.TypeToken;
import com.qianseit.westore.Run;
import com.qianseit.westore.util.NotNull;

import java.io.Serializable;
import java.lang.reflect.Type;

abstract public class BaseBean implements Serializable {

	public final static String NULL_VALUE = "未设置";

	protected static String getValueString(String value) {
		return !NotNull.isNotNull(value) ? "未设置" : value;
	}

	static Gson mGson = new Gson();
	/**
	 * 
	 */
	private static final long serialVersionUID = -7821494720976114514L;

	static String toJson(BaseBean bean) {
		return mGson.toJson(bean);
	}

	/**
	 * Gson获取实体类
	 * 
	 * @author july.zeng 2014年4月28日 下午5:48:08
	 * @param mContext
	 * @param token
	 * @param jsonString
	 * @return
	 */
	public static <T> T getGsonList(Context mContext, TypeToken<T> token, String jsonString) {
		if (NotNull.isNotNull(jsonString)) {
			try {
				if (!NotNull.isNotNull(mGson)) {
					getGson();
				}
				return mGson.fromJson(jsonString, token.getType());
			} catch (Exception e) {
				Run.alert(mContext, "Json格式错误");
				e.printStackTrace();
			}
		} else {
			Run.alert(mContext, "Json内容为空");
		}
		return null;
	}

	public static <T> T getGsonData(Context mContext, TypeToken<T> token, String jsonString) {
		if (NotNull.isNotNull(jsonString)) {
			try {
				if (!NotNull.isNotNull(mGson)) {
					getGson();
				}
				return mGson.fromJson(jsonString, token.getType());
			} catch (Exception e) {
				Run.alert(mContext, "Json格式错误");
				e.printStackTrace();
			}
		} else {
			Run.alert(mContext, "Json内容为空");
		}
		return null;
	}

	/**
	 * Gson构造器
	 * 
	 * @author july.zeng 2014年5月7日 上午11:26:02
	 */
	private static void getGson() {
		GsonBuilder gsonBuilder = new GsonBuilder();
		gsonBuilder.registerTypeAdapter(Double.class, new JsonDeserializer<Double>() {
			@Override
			public Double deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) {
				try {
					return json.getAsDouble();
				} catch (Exception e) {
					return null;
				}
			}
		});
		mGson = gsonBuilder.serializeNulls().create();
	}
}
