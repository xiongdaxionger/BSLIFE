package com.qianseit.westore.activity.news;

import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONObject;

public class NewsSystemFragment extends BaseNewsFragment {

    @Override
    protected String msgType() {
        // TODO Auto-generated method stub
        return "system";
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
        mTitle = getArguments().getString(Run.EXTRA_TITLE);
        mActionBar.setShowTitleBar(false);
    }

    @Override
    protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
        // TODO Auto-generated method stub
        if (convertView == null) {
            convertView = View.inflate(mActivity, R.layout.item_news_system, null);
        }

        ((TextView) convertView.findViewById(R.id.title)).setText(responseJson.optString("title"));
        ((TextView) convertView.findViewById(R.id.time)).setText(StringUtils.LongTimeToLongString(responseJson.optLong("time")));
        ((TextView) convertView.findViewById(R.id.message)).setText(Html.fromHtml(responseJson.optString("comment")));

        readNews(responseJson);

        return convertView;
    }

    @Override
    public void onResume() {
        super.onResume();
        setEmptyText("暂无" + mTitle);
    }
}
