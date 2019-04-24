package com.qianseit.westore.activity.community;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.httpinterface.article.ArticleAddPraiseDiscoverInterface;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class CommDiscoverNoteListFragment extends BaseListFragment<JSONObject> {
    final int REQUEST_DETAIL = 0x01;

    int mImageWith = 0;

    String defualtId = "";
    String noteType = "";
    JSONObject mCurJsonObject = null;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
        mImageWith = 1080;

        defualtId = getExtraStringFromBundle(Run.EXTRA_CLASS_ID);
        noteType = getExtraStringFromBundle(Run.EXTRA_DETAIL_TYPE);
        mActionBar.setTitle(getExtraStringFromBundle(Run.EXTRA_TITLE));

        if (TextUtils.isEmpty(defualtId) && TextUtils.isEmpty(noteType)) {
            Bundle nBundle = getArguments();
            defualtId = nBundle.getString(Run.EXTRA_CLASS_ID);
            mActionBar.setTitle(nBundle.getString(Run.EXTRA_TITLE));
        }

        if (TextUtils.isEmpty(defualtId)) {
            mActionBar.setShowTitleBar(true);
        } else {
            mActionBar.setShowTitleBar(false);
        }
    }

    @Override
    protected View getItemView(JSONObject itemJson, View convertView, ViewGroup parent) {
        // TODO Auto-generated method stub
        if (convertView == null) {
            convertView = View.inflate(mActivity, R.layout.item_discover_note1, null);
            setViewSize(convertView.findViewById(R.id.image), mImageWith, mImageWith * 2 / 5);

            convertView.findViewById(R.id.discover_note_footer_comment).setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    mCurJsonObject = (JSONObject) v.getTag();
                    Bundle nBundle = new Bundle();
                    nBundle.putString(Run.EXTRA_ARTICLE_ID, mCurJsonObject.optString("article_id"));
                    nBundle.putString(Run.EXTRA_DATA, mCurJsonObject.optString("s_url"));
                    startActivityForResult(AgentActivity.FRAGMENT_COMMUNITY_COMMENT, nBundle, REQUEST_DETAIL);
                }
            });
            convertView.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    mCurJsonObject = (JSONObject) v.getTag();
                    Bundle nBundle = new Bundle();
                    nBundle.putString(Run.EXTRA_ARTICLE_ID, mCurJsonObject.optString("article_id"));
                    nBundle.putString(Run.EXTRA_DATA, mCurJsonObject.optString("s_url"));
                    startActivityForResult(AgentActivity.FRAGMENT_COMMUNITY_COMMENT, nBundle, REQUEST_DETAIL);
                }
            });

            convertView.findViewById(R.id.discover_note_footer_praise).setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    final JSONObject nJsonObject = (JSONObject) v.getTag();
                    new ArticleAddPraiseDiscoverInterface(CommDiscoverNoteListFragment.this, nJsonObject.optString("article_id")) {

                        @Override
                        public void SuccCallBack(JSONObject responseJson) {
                            // TODO Auto-generated method stub
                            try {
                                int nPraise = nJsonObject.optInt("praise_nums", 0);
                                if (nJsonObject.optBoolean("ifpraise")) {
                                    nJsonObject.put("ifpraise", false);
                                    nJsonObject.put("praise_nums", nPraise - 1);
                                } else {
                                    nJsonObject.put("ifpraise", true);
                                    nJsonObject.put("praise_nums", nPraise + 1);
                                }
                            } catch (JSONException e) {
                                // TODO Auto-generated catch block
                                e.printStackTrace();
                            }
                            mAdapter.notifyDataSetChanged();
                        }
                    }.RunRequest();
                }
            });
        }

        displayRectangleImage((ImageView) convertView.findViewById(R.id.image), itemJson.optString("url"), ImageScaleType.EXACTLY);
        ((TextView) convertView.findViewById(R.id.title)).setText(itemJson.optString("title"));

        convertView.findViewById(R.id.discover_note_footer_praise).setSelected(itemJson.optBoolean("ifpraise"));
        ((TextView) convertView.findViewById(R.id.discover_note_footer_praise)).setText(itemJson.optString("praise_nums"));
        ((TextView) convertView.findViewById(R.id.discover_note_footer_comment)).setText(itemJson.optString("discuss_nums"));
        ((TextView) convertView.findViewById(R.id.discover_note_footer_title)).setText(itemJson.optString("author"));
        ((TextView) convertView.findViewById(R.id.discover_note_footer_time)).setText(StringUtils.LongTimeToString("yyyy-MM-dd", itemJson.optLong("uptime")));

        convertView.setTag(itemJson);
        convertView.findViewById(R.id.discover_note_footer_praise).setTag(itemJson);
        convertView.findViewById(R.id.discover_note_footer_comment).setTag(itemJson);
        return convertView;
    }

    @Override
    protected List<JSONObject> fetchDatas(JSONObject responseJson) {
        // TODO Auto-generated method stub
        List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();

        JSONArray nArray = responseJson.optJSONArray("articles");
        if (nArray == null || nArray.length() <= 0) {
            return nJsonObjects;
        }

        for (int i = 0; i < nArray.length(); i++) {
            nJsonObjects.add(nArray.optJSONObject(i));
        }

        return nJsonObjects;
    }

    @Override
    protected String requestInterfaceName() {
        // TODO Auto-generated method stub
        return "content.article.l";
    }

    @Override
    protected ContentValues extentConditions() {
        // TODO Auto-generated method stub
        ContentValues nContentValues = new ContentValues();
        if (!TextUtils.isEmpty(articleId())) {
            nContentValues.put("node_id", articleId());
        } else {
            nContentValues.put("node_type", noteType);
        }
        return nContentValues;
    }

    public String articleId() {
        return defualtId;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        // TODO Auto-generated method stub
        if (resultCode != Activity.RESULT_OK) {
            return;
        }

        if (requestCode == REQUEST_DETAIL) {
            try {
                JSONObject nJsonObject = new JSONObject(data.getStringExtra(Run.EXTRA_DATA));
                mCurJsonObject.put("praise_nums", nJsonObject.opt("praise_nums"));
                mCurJsonObject.put("discuss_nums", nJsonObject.opt("discuss_nums"));
                mCurJsonObject.put("ifpraise", nJsonObject.opt("ifpraise"));
                mAdapter.notifyDataSetChanged();
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            return;
        }
        super.onActivityResult(requestCode, resultCode, data);
    }
}
