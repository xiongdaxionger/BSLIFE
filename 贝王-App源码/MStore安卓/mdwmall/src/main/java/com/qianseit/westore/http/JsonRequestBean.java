package com.qianseit.westore.http;

import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.Run;
import com.qianseit.westore.util.Md5;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class JsonRequestBean {
    public static final String METHOD_POST = "POST";
    public static final String METHOD_GET = "GET";

    public String url; // 请求接口url
    public String charset; // 接口字符编码，默认为utf-8
    public String method = METHOD_POST; // 请求的方法GET/POST
    public ContentValues params; // 参数列表

    // 上传文件时候使用，请看接口文档
    public Map<String, File> files = new HashMap<String, File>();
    public byte[][] bytess;

    /**
     * 新建Request Bean，并设置请求url
     *
     * @param new_url
     */
    public JsonRequestBean(String new_url, String method) {
        this.params = new ContentValues();
        this.url = new_url;

        // 默认必须添加的参数
        if (!TextUtils.isEmpty(method)) {
            this.addParams("method", method);
        }
    }

    public JsonRequestBean(String new_url) {
        this.params = new ContentValues();
        this.url = new_url;
    }

    /**
     * 新建Request Bean，并设置请求url
     *
     * @param new_url
     * @param srcCharset 接口编码类型
     */
    public JsonRequestBean(String new_url, String method, String srcCharset) {
        this(new_url, method);
        this.charset = srcCharset;
    }

    /**
     * 添加请求参数
     *
     * @param key
     * @param value
     */
    public JsonRequestBean addParams(String key, String value) {
        params.put(key, value);
        return this;
    }

    /**
     * @param contentValues
     * @return
     */
    public JsonRequestBean addAllParams(ContentValues contentValues){
        params.putAll(contentValues);
        return this;
    }

    /**
     * 签名表单数据
     *
     * @return
     */
    public String signatureParams() {
        if (params == null) return "";

        List<String> stringList = new ArrayList<String>();
        stringList.addAll(params.keySet());
        if (stringList.size() <= 0) return "";

        Collections.sort(stringList, new Comparator<String>() {
            @Override
            public int compare(String a, String b) {
                return a.compareTo(b);
            }
        });

        String result = "";
        String lastKey = "";

        for (String string :
                stringList) {
            String nString = string.substring(0);
            int start = nString.indexOf("[");
            if (start != -1) {
                String theKey = nString.substring(0, start);
                if (TextUtils.equals(lastKey, theKey))
                    nString = nString.substring(start);
                lastKey = theKey;
            }

            result = Run.buildString(result, nString.replaceAll("\\[", "")
                    .replace("]", ""), params.getAsString(string));
        }

        Run.log("result", result);
        return Md5.getMD5(
                Run.buildString(Md5.getMD5(result).toUpperCase(), Run.TOKEN))
                .toUpperCase();
    }

    @Override
    public String toString() {
        StringBuilder nBuilder = new StringBuilder(url);
        if (params == null) {
            return nBuilder.toString();
        }

        Set<String> strings = params.keySet();
        if (strings == null || strings.size() <= 0) return nBuilder.toString();

        for (String string :
                strings) {
            nBuilder.append('&');
            nBuilder.append(string);
            nBuilder.append('=');
            nBuilder.append(params.getAsString(string));
        }

        String nResult = nBuilder.toString();
        nBuilder.delete(0, nBuilder.length());
        return nResult;
    }

    public interface JsonRequestCallback {
        void task_response(String jsonStr);
    }
}
