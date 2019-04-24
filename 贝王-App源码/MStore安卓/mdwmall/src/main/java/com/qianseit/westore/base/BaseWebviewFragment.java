package com.qianseit.westore.base;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.LinearLayout;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;

public abstract class BaseWebviewFragment extends BaseDoFragment {

	protected WebView mWebView;
	LinearLayout mTopLayout;

	String mFontSizeAdjust = "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" /><style>* {max-width:100%;}* {font-size:1.0em;}</style>";
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}

	@SuppressLint("SetJavaScriptEnabled")
	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// mActionBar.setRightImageButton(R.drawable.shop_preview_share, this);

		rootView = inflater.inflate(R.layout.base_fragment_webview, null);
		mTopLayout = (LinearLayout) findViewById(R.id.base_top);
		mWebView = (WebView) rootView.findViewById(R.id.base_webview);
		mWebView.setBackgroundColor(0x00000000);
		
		initWebsettings();
		initTop(mTopLayout);
		init();
		
		loadWebContent();
	}

	protected void initWebsettings(){
		// 打开网页时不调用系统浏览器， 而是在本WebView中显示：
		mWebView.setWebViewClient(new WebViewClient() {
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
				return super.shouldOverrideUrlLoading(view, url);
			}
		});
		mWebView.setWebChromeClient(new WebChromeClient() {
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
		WebSettings webSettings = mWebView.getSettings();
		webSettings.setUseWideViewPort(true);// 设置此属性，可任意比例缩放,将图片调整到适合webview的大小
		webSettings.setLoadWithOverviewMode(true);// 缩放至屏幕的大小

		// 便页面支持缩放：
		webSettings.setJavaScriptEnabled(true);
		webSettings.setBuiltInZoomControls(true);
		webSettings.setSupportZoom(true);

//		 mWebView.setPluginsEnabled(true); //支持插件
		webSettings.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.NORMAL); // 支持内容重新布局
		webSettings.supportMultipleWindows(); // 多窗口
		webSettings.setCacheMode(WebSettings.LOAD_NO_CACHE); // 关闭webview中缓存
		// webSettings.setAllowFileAccess(true); //设置可以访问文件
		// webSettings.setNeedInitialFocus(true);
		// //当webview调用requestFocus时为webview设置节点
		webSettings.setJavaScriptCanOpenWindowsAutomatically(true); // 支持通过JS打开新窗口
		webSettings.setLoadsImagesAutomatically(true); // 支持自动加载图片
	}
	
	protected void loadWebContent() {
		if (!TextUtils.isEmpty(getContent())) {
			mWebView.loadDataWithBaseURL(null, mFontSizeAdjust + getContent(), "text/html", "utf8", null);
		} else if (!TextUtils.isEmpty(getUrl())) {
			String nString = getUrl();
			if (!nString.startsWith("http")) {
				nString = "http://" + nString;
			}
			mWebView.loadUrl(nString);
		}
	}

	public String getUrl() {
		return "";
	}

	public String getContent() {
		return "";
	}

	protected abstract void init();
	
	protected void initTop(LinearLayout topContainLayout){
		
	}

	protected void showTopDivider(boolean show){
		findViewById(R.id.base_top_divider).setVisibility(show ? View.VISIBLE : View.GONE);
	}
	
	/*
	 * (非 Javadoc) <p>Title: onKeyDown</p> <p>Description: </p>
	 * 
	 * @param keyCode
	 * 
	 * @param event
	 * 
	 * @return
	 * 
	 * @see com.qianseit.westore.DoFragment#onKeyDown(int,
	 * android.view.KeyEvent)
	 */
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		// TODO 自动生成的方法存根
		// 按返回键时， 不退出程序而是返回上一浏览页面：
		if ((keyCode == KeyEvent.KEYCODE_BACK) && mWebView.canGoBack()) {
			mWebView.goBack();
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

	/*
	 * (非 Javadoc) <p>Title: onPause</p> <p>Description: </p>
	 * 
	 * @see android.support.v4.app.Fragment#onPause()
	 */
	@SuppressLint("NewApi")
	@Override
	public void onPause() {
		// TODO 自动生成的方法存根
		super.onPause();
	}
}
