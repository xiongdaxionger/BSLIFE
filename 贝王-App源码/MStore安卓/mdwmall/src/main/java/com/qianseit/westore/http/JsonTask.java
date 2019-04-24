package com.qianseit.westore.http;

import java.util.ArrayList;
import java.util.List;

import android.os.AsyncTask;
import android.os.Debug;

import com.qianseit.westore.util.Util;

/**
 * 通用网络交互任务<br/>
 * 请求接口，返回请求参数<br/>
 * 回调接口，反馈调用结果<br/>
 * <br/>
 * <br/>
 */
public class JsonTask extends AsyncTask<JsonTaskHandler, Integer, List<JsonTaskHandler>> {
    public boolean isExcuting = false;
    public boolean isFinished = false;

    // static final int ok = 200;
    List<String> infos;

    /**
     * 任务开始
     */
    @Override
    protected void onPreExecute() {
        isExcuting = true;
        isFinished = false;
    }

    /**
     * 任务执行操作，publishProgress可提示任务进程
     */
    @Override
    protected List<JsonTaskHandler> doInBackground(JsonTaskHandler... handlers) {
        List<JsonTaskHandler> nHandlers = new ArrayList<JsonTaskHandler>();
        infos = new ArrayList<String>();
        for (JsonTaskHandler jsonTaskHandler : handlers) {
            JsonRequestBean data = jsonTaskHandler.task_request();
            if (data.params.size() > 0) // 签名参数
                data.addParams("sign", data.signatureParams());

            if (Debug.isDebuggerConnected())
                Util.log(data.url, data.toString());

            // 请求数据
            // if (data.files != null || data.bytess != null)
            // else
            String nInfo = "";
            nInfo = JsonHttpHandler.senddata_upload(data);
            infos.add(nInfo);
            nHandlers.add(jsonTaskHandler);
        }

        return nHandlers;
    }

    /**
     * 进度提示
     */
    @Override
    protected void onProgressUpdate(Integer... values) {
        // 更新进度
        System.out.println("" + values[0]);
    }

    /**
     * 任务结束操作
     */
    @Override
    protected void onPostExecute(List<JsonTaskHandler> handlers) {
        for (int i = 0; i < handlers.size(); i++) {
            Util.log(infos.get(i));
            handlers.get(i).task_response(infos.get(i));
        }

        isExcuting = false;
        isFinished = true;
    }

    /**
     * 任务终止
     */
    @Override
    public void onCancelled() {
        super.onCancelled();
    }

}
