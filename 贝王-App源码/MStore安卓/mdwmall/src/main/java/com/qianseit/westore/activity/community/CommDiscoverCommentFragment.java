package com.qianseit.westore.activity.community;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebSettings.LayoutAlgorithm;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.httpinterface.article.ArticleAddPraiseDiscoverInterface;
import com.qianseit.westore.httpinterface.article.ArticleGetDetailInterface;
import com.qianseit.westore.ui.ShareView.ShareViewDataSource;
import com.qianseit.westore.ui.ShareViewPopupWindow;
import com.qianseit.westore.ui.XPullDownListView;
import com.qianseit.westore.util.StringUtils;
import com.qianseit.westore.util.Util;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class CommDiscoverCommentFragment extends BaseListFragment<JSONObject> implements ShareViewDataSource {

	private EditText mEt_comment;
	private Button mSendBut;
	private String mUserId;
	private String mArticleId;

	TextView mPraiseTextView, mCommentTextView;
	String mImageUrl = "";
	
	WebView mDiscoverDescView;

	private ShareViewPopupWindow mShareViewPopupWindow;
	AticleCommentDialog mCommentDialog;
	JSONObject mIndexJsonObject = new JSONObject();

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mArticleId = getExtraStringFromBundle(Run.EXTRA_ARTICLE_ID);
		mImageUrl = getExtraStringFromBundle(Run.EXTRA_DATA);

		mActionBar.setTitle(getExtraStringFromBundle(Run.EXTRA_TITLE));
	}

	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_discover_comment, null);
		}
		((TextView) convertView.findViewById(R.id.member_name)).setText(Run.defaultName(responseJson.optString("name")));
		((TextView) convertView.findViewById(R.id.comment_content)).setText(responseJson.optString("content"));
		String nLv = StringUtils.getString(responseJson, "member_lv_name");
		if (TextUtils.isEmpty(nLv)) {
			convertView.findViewById(R.id.member_hander_lv).setVisibility(View.GONE);
		}else{
			((TextView) convertView.findViewById(R.id.member_hander_lv)).setText(nLv);
		}
		((TextView) convertView.findViewById(R.id.comment_time)).setText(StringUtils.friendlyFormatTime( responseJson.optLong("uptime")));
		displayCircleImage((ImageView) convertView.findViewById(R.id.member_avatar), responseJson.optString("avatar"));
		return convertView;
	}

	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();

		JSONArray nArray = responseJson.optJSONArray("comment_list");
		if (nArray == null || nArray.length() <= 0) {
			return nJsonObjects;
		}

		for (int i = 0; i < nArray.length(); i++) {
			nJsonObjects.add(nArray.optJSONObject(i));
		}

		return nJsonObjects;
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("ifpraise", "false");
		nContentValues.put("article_id", mArticleId);
		return nContentValues;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "content.article.getcommentlist";
	}

	@Override
	protected void addHeader(XPullDownListView listView) {
		// TODO Auto-generated method stub
		View nHeaderView = View.inflate(mActivity, R.layout.header_comm_discover, null);
		listView.addHeaderView(nHeaderView);
		
		mDiscoverDescView = (WebView) nHeaderView.findViewById(R.id.header_discover_webview);
		listView.setEmptyView(null);
		initWebsettings();
	}

	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		mCommentDialog = new AticleCommentDialog(this) {
			
			@Override
			public void commment(final String content) {
				// TODO Auto-generated method stub
				mSendBut.setEnabled(false);

				new ArticleAddPraiseDiscoverInterface(CommDiscoverCommentFragment.this, false, mArticleId, content) {

					@Override
					public void SuccCallBack(JSONObject responseJson) {
						// TODO Auto-generated method stub
						mSendBut.setEnabled(true);
						Run.alert(getActivity(), "评论成功");
						JSONObject mCommendJson = new JSONObject();
						try {
							mCommendJson.put("member_id", mUserId);
							mCommendJson.put("name", mLoginedUser.getMember().getUname());
							mCommendJson.put("avatar", mLoginedUser.getAvatarUri());
							mCommendJson.put("content", content);
							mCommendJson.put("member_lv_name", mLoginedUser.getMemberLvName());
							Date date = new Date(System.currentTimeMillis());
							mCommendJson.put("uptime", date.getTime());
							
							mIndexJsonObject.put("discuss_nums", mIndexJsonObject.optInt("discuss_nums", 0) + 1);
							mCommentTextView.setText(mIndexJsonObject.optString("discuss_nums"));
							
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						mResultLists.add(0, mCommendJson);
						mAdapter.notifyDataSetChanged();
						mListView.setSelection(0);
					}

					@Override
					public void FailRequest() {
						mSendBut.setEnabled(true);
					}
				}.RunRequest();
			}
		};
		
		new ArticleGetDetailInterface(this, Integer.parseInt(mArticleId)) {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub

				mIndexJsonObject = responseJson.optJSONObject("indexs");
				if (mIndexJsonObject == null || !mIndexJsonObject.has("title")) {
					responseTitle("");
				} else {
					responseTitle(mIndexJsonObject.optString("title"));
				}

				JSONObject nContentJsonObject = responseJson.optJSONObject("bodys");
				if (nContentJsonObject == null || !nContentJsonObject.has("content")) {
					responseContent("");
				} else {
					responseContent(nContentJsonObject.optString("content"));
					mImageUrl = nContentJsonObject.optString("s_image_id");
				}
				
				mPraiseTextView.setText(mIndexJsonObject.optString("praise_nums"));
				mCommentTextView.setText(mIndexJsonObject.optString("discuss_nums"));
				mPraiseTextView.setSelected(mIndexJsonObject.optBoolean("ifpraise"));
			}

			@Override
			public void responseTitle(String titleString) {
				// TODO Auto-generated method stub
				if (!TextUtils.isEmpty(titleString)) {
					mActionBar.setTitle(titleString);
				}
			}

			@Override
			public void responseContent(String contentString) {
				// TODO Auto-generated method stub
				String nDescString = "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" /><style>* {max-width:100%;}* {font-size:1.0em;}</style>" + contentString;
				mDiscoverDescView.loadDataWithBaseURL(null, nDescString, "text/html", "utf8", null);
			}
		}.RunRequest();
		
		mShareViewPopupWindow = new ShareViewPopupWindow(mActivity);
		mShareViewPopupWindow.setDataSource(this);
	}

	void initWebsettings() {
		// 打开网页时不调用系统浏览器， 而是在本WebView中显示：
		mDiscoverDescView.setWebViewClient(new WebViewClient() {
			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				String nProductKey = "product-";
				if (!url.contains("product-")){
					nProductKey = "product_id=";
					if(!url.contains("product_id=")){
						nProductKey = "";
					}
				}

				if (url.startsWith(Run.DOMAIN) && !TextUtils.isEmpty(nProductKey)) {
					int index = url.indexOf(nProductKey);
					int end = url.indexOf('.', index);
					if(end <= 0)end = url.indexOf('&', index);
					if (end <= 0) {
						end = url.length();
					}

					Bundle nBundle = new Bundle();
					nBundle.putString(Run.EXTRA_PRODUCT_ID, url.substring(index + nProductKey.length(), end));
					startActivity(AgentActivity.FRAGMENT_GOODS_DETAIL, nBundle);
					return true;
				}
				view.loadUrl(url);
				return true;
			}
		});
		mDiscoverDescView.setWebChromeClient(new WebChromeClient() {
			@Override
			public void onReceivedTitle(WebView view, String title) {
				// TODO Auto-generated method stub
				super.onReceivedTitle(view, title);
				if (TextUtils.isEmpty(title) || title.equalsIgnoreCase("about:blank")) {
					return;
				}
				mActionBar.setTitle(title);
			}
		});

		// 打开页面时， 自适应屏幕：
		WebSettings webSettings = mDiscoverDescView.getSettings();
		webSettings.setUseWideViewPort(true);// 设置此属性，可任意比例缩放,将图片调整到适合webview的大小
		webSettings.setLoadWithOverviewMode(true);

		// 便页面支持缩放：
		webSettings.setJavaScriptEnabled(false);
		webSettings.setBuiltInZoomControls(false);
		webSettings.setSupportZoom(false);

		// mWebView.setPluginsEnabled(true); //支持插件
		webSettings.setLayoutAlgorithm(LayoutAlgorithm.NORMAL); // 支持内容重新布局
		webSettings.supportMultipleWindows(); // 多窗口
		webSettings.setCacheMode(WebSettings.LOAD_NO_CACHE); // 关闭webview中缓存
		// webSettings.setAllowFileAccess(true); //设置可以访问文件
		// webSettings.setNeedInitialFocus(true);
		// //当webview调用requestFocus时为webview设置节点
		webSettings.setJavaScriptCanOpenWindowsAutomatically(true); // 支持通过JS打开新窗口
		webSettings.setLoadWithOverviewMode(true); // 缩放至屏幕的大小
		webSettings.setLoadsImagesAutomatically(true); // 支持自动加载图片
	}

	@Override
	protected void initBottom(LinearLayout bottomLayout) {
		// TODO Auto-generated method stub
		View nBottomView = View.inflate(mActivity, R.layout.footer_recommend_goods_comment, null);
		bottomLayout.addView(nBottomView);
		if (mLoginedUser != null)
			mUserId = mLoginedUser.getMember().getMember_id();

		mPraiseTextView = (TextView) nBottomView.findViewById(R.id.praise);
		mCommentTextView = (TextView) nBottomView.findViewById(R.id.comment);
		
		nBottomView.findViewById(R.id.share).setOnClickListener(this);
		mCommentTextView.setOnClickListener(this);
		mPraiseTextView.setOnClickListener(this);

		mEt_comment = (EditText) findViewById(R.id.et_comment);
		mSendBut = ((Button) findViewById(R.id.send));
		mSendBut.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				if (mUserId == null) {
					Toast.makeText(getActivity(), "请登录", Toast.LENGTH_LONG).show();
					return;
				}
				if (mEt_comment.getText().toString().trim().equals("")) {
					Toast.makeText(getActivity(), "请输入评论内容", Toast.LENGTH_LONG).show();
					return;
				}
				mSendBut.setEnabled(false);

				new ArticleAddPraiseDiscoverInterface(CommDiscoverCommentFragment.this, false, mArticleId, mEt_comment.getText().toString().trim()) {

					@Override
					public void SuccCallBack(JSONObject responseJson) {
						// TODO Auto-generated method stub
						mSendBut.setEnabled(true);
						Run.alert(getActivity(), "评论成功");
						JSONObject mCommendJson = new JSONObject();
						try {
							mCommendJson.put("member_id", mUserId);
							mCommendJson.put("name", mLoginedUser.getMember().getUname());
							mCommendJson.put("avatar", mLoginedUser.getAvatarUri());
							mCommendJson.put("content", mEt_comment.getText().toString());
							mCommendJson.put("member_lv_name", mLoginedUser.getMemberLvName());
							Date date = new Date(System.currentTimeMillis());
							mCommendJson.put("uptime", date.getTime());
							
							mIndexJsonObject.put("discuss_nums", mIndexJsonObject.optInt("discuss_nums") + 1);
							mCommentTextView.setText(mIndexJsonObject.optString("discuss_nums"));
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						mResultLists.add(0, mCommendJson);
						mAdapter.notifyDataSetChanged();
						mListView.setSelection(mResultLists.size());
					}

					@Override
					public void FailRequest() {
						mSendBut.setEnabled(true);
					}
				}.RunRequest();
			}
		});
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.comment:
			mCommentDialog.show();
//			mActivity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_VISIBLE | WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
			break;
		case R.id.praise:
			new ArticleAddPraiseDiscoverInterface(this, mIndexJsonObject.optString("article_id")) {

				@Override
				public void SuccCallBack(JSONObject responseJson) {
					// TODO Auto-generated method stub
					try {
						int nPraise = mIndexJsonObject.optInt("praise_nums", 0);
						if (mIndexJsonObject.optBoolean("ifpraise")) {
							mIndexJsonObject.put("ifpraise", false);
							mIndexJsonObject.put("praise_nums", nPraise - 1);
						} else {
							mIndexJsonObject.put("ifpraise", true);
							mIndexJsonObject.put("praise_nums", nPraise + 1);
						}
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					mPraiseTextView.setText(mIndexJsonObject.optString("praise_nums"));
					mPraiseTextView.setSelected(mIndexJsonObject.optBoolean("ifpraise"));
				}
			}.RunRequest();
			break;
		case R.id.share:
			mShareViewPopupWindow.showAtLocation(rootView, android.view.Gravity.BOTTOM, 0, 0);
			break;

		default:
			break;
		}
		super.onClick(v);
	}

	@Override
	protected void back() {
		// TODO Auto-generated method stub
		Intent nIntent = new Intent();
		nIntent.putExtra(Run.EXTRA_DATA, mIndexJsonObject.toString());
		mActivity.setResult(Activity.RESULT_OK, nIntent);
		super.back();
	}
	
	@Override
	public String getShareText() {
		// TODO Auto-generated method stub
		return mIndexJsonObject.optString("title");
	}

	@Override
	public String getShareImageFile() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getShareImageUrl() {
		// TODO Auto-generated method stub
		if (TextUtils.isEmpty(mImageUrl)) {
			Bitmap bitmap = BitmapFactory.decodeResource(mActivity.getResources(), R.drawable.comm_icon_launcher);
			Util.saveBitmap("share_iamge", bitmap);
			return Util.getPath() + "/share_iamge";
		}
		return mImageUrl;
	}

	@Override
	public String getShareUrl() {
		// TODO Auto-generated method stub
		return mIndexJsonObject.optString("share_url");
	}

	@Override
	public String getShareMessage() {
		// TODO Auto-generated method stub
		return mIndexJsonObject.optString("brief");
	}
}
