package com.qianseit.westore.base;

import android.app.Activity;
import android.content.Intent;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.activity.common.CommonMainActivity;
import com.qianseit.westore.util.Util;

public class DoActionBar extends FrameLayout implements OnClickListener {
	private Activity mDoActivity;

	private TextView mTitleTV;
	private ViewGroup mContainer;
	private ViewGroup mTitleBar, mTitleView;
	private Button mRightButton;
	private ImageButton mBackButton;
	private ImageButton mRightImageButton, mTitleRightImageButton;
	private TextView mSearching;
	private ImageView mHomeImg;
	private View mTabbarView;
	private RadioGroup mRadioGroup;
	private View mParentView;
	private FrameLayout mLinearRight;
	
	public View hasNewsView;

	private LayoutInflater mInflater = null;

	// 标题栏是否悬浮在内容上
	private boolean mTitleBarFloatAboveContent = false;

	ActionBarHandler mActionBarHandler;
	
	public void setActionBarHandler(ActionBarHandler actionBarHandler){
		mActionBarHandler = actionBarHandler;
	}
	
	/**
	 * ActionBar构造器
	 * 
	 * @param context
	 */
	public DoActionBar(Activity context) {
		super(context);
		mDoActivity = context;
		mInflater = LayoutInflater.from(context);
		setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
		addView(mInflater.inflate(R.layout.qianseit_action_bar, null));

		// 初始化ActionBar
		this.initDoActionBar();
	}

	/**
	 * 初始化ActionBar
	 */
	private void initDoActionBar() {
		mTitleBar = (ViewGroup) findViewById(R.id.action_bar_titlebar);
		mTitleView = (ViewGroup) findViewById(R.id.action_bar_titlebar_titleview);
		mContainer = (ViewGroup) findViewById(R.id.action_bar_container);
		mTitleTV = (TextView) findViewById(R.id.action_bar_titlebar_title);
		mBackButton = (ImageButton) findViewById(R.id.action_bar_titlebar_left);
		mTitleRightImageButton = (ImageButton) findViewById(R.id.action_bar_titlebar_title_right_ib);
		mRightButton = (Button) findViewById(R.id.action_bar_titlebar_right);
		mSearching = (TextView) findViewById(R.id.action_bar_titlebar_rightsearch);
		mHomeImg = (ImageView) findViewById(R.id.action_bar_home);
		mTabbarView = findViewById(R.id.action_bar_tabbar);
		mLinearRight=(FrameLayout)findViewById(R.id.action_bar_titlebar_right_layout);
		mRadioGroup = (RadioGroup) findViewById(R.id.action_bar_radiogroup);
		mRightImageButton = (ImageButton) findViewById(R.id.action_bar_titlebar_right_ib);
		hasNewsView = findViewById(R.id.has_unread);
		for (int i = 0, c = mRadioGroup.getChildCount(); i < c; i++) {
			mRadioGroup.getChildAt(i).setOnClickListener(this);
		}
		mParentView = findViewById(R.id.action_bar_parent);
		mParentView.setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View arg0, MotionEvent arg1) {
				if (mTabbarView.getVisibility() == View.VISIBLE) {
					mTabbarView.setVisibility(View.GONE);
					return true;
				}
				return false;
			}
		});

		setShowBackButton(false);
		setShowRightButton(false);
		mBackButton.setOnClickListener(this);
		mBackButton.setOnLongClickListener(new OnLongClickListener() {

			@Override
			public boolean onLongClick(View v) {
				try {
					Thread.sleep(1000);
					Intent nIntent = new Intent(mDoActivity, CommonMainActivity.class);
					nIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
					mDoActivity.startActivity(nIntent);
					mDoActivity.finish();
				} catch (InterruptedException e) {

					e.printStackTrace();
				}
				return false;
			}
		});
		mHomeImg.setOnClickListener(this);
	}

	/**
	 * 是否有新消息
	 * @param hasNews
	 */
	public void setHasNews(boolean hasNews){
		hasNewsView.setVisibility(hasNews ? View.VISIBLE : View.GONE);
	}
	
	public void setShowHomeView(boolean isShow) {
		mHomeImg.setVisibility(isShow ? View.VISIBLE : View.GONE);
	}

	public ImageView getHomeView() {
		return mHomeImg;
	}
     
	public TextView getRightSearchView() {
		return mSearching;
	}

	/**
	 * 获取返回按钮
	 * 
	 * @return
	 */
	public ImageButton getBackButton() {
		return mBackButton;
	}

	/**
	 * 判断是否为返回按钮
	 * 
	 * @return
	 */
	public boolean isBackButton(View v) {
		return mBackButton.getId() == v.getId();
	}

	/**
	 * 获取标题栏
	 * 
	 * @return
	 */
	public View getTitleBar() {
		return mTitleBar;
	}

	/**
	 * 获取返回按钮
	 * 
	 * @return
	 */
	public Button getRightButton() {
		return mRightButton;
	}
    
	public FrameLayout getRightLinear(){
		return mLinearRight;
	}
	/**
	 * 返回标题TextView
	 * 
	 * @return
	 */
	public TextView getTitleTV() {
		return mTitleTV;
	}

	/**
	 * ActionBar标题
	 * 
	 * @param title
	 */
	public void setTitle(String title) {
		if (mTitleTV != null && !TextUtils.isEmpty(title))
			mTitleTV.setText(title);
	}

	/**
	 * ActionBar标题
	 * 
	 * @param titleId
	 */
	public void setTitle(int titleId) {
		if (titleId != 0)
			setTitle(mDoActivity.getString(titleId));
	}

	/**
	 * 
	 * @param v
	 */
	public void setCustomTitleView(View v) {
		mTitleView.removeAllViews();
		if (v != null) {
			FrameLayout.LayoutParams nLayoutParams = new LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.CENTER);
			android.view.ViewGroup.LayoutParams nLayoutParams1 = v.getLayoutParams();
			if (nLayoutParams1 != null) {
				nLayoutParams = new FrameLayout.LayoutParams(nLayoutParams1);
				nLayoutParams.gravity = Gravity.CENTER;
			}
			v.setLayoutParams(nLayoutParams);
			mTitleView.addView(v);
		}
	}

	public View getCustomTitleView() {
		return mTitleView;
	}

	/**
	 * 设置标题栏左边按钮
	 * 
	 * @param imageRes
	 * @param listener
	 */
	// public void setLeftTitleButton(int imageRes, OnClickListener listener) {
	// mBackButton.setImageResource(imageRes);
	// mBackButton.setOnClickListener(listener);
	// setShowBackButton(true);
	// }

	/**
	 * 设置标题栏左边按钮
	 * 
	 * @param image
	 * @param listener
	 */
	// private void setLeftTitleButton(Drawable image, OnClickListener listener)
	// {
	// mBackButton.setImageDrawable(image);
	// mBackButton.setOnClickListener(listener);
	// setShowBackButton(true);
	// }

	/**
	 * 设置左边标题按钮长按时的提示文字
	 * 
	 * @param text
	 */
	private void setLeftTitleButtonText(final String text) {
		if (TextUtils.isEmpty(text))
			return;

		mBackButton.setOnLongClickListener(new OnLongClickListener() {
			@Override
			public boolean onLongClick(View v) {
				Util.alert(mDoActivity, text);
				return false;
			}
		});
	}

	/**
	 * 设置左边标题按钮长按时的提示文字
	 * 
	 * @param text
	 */
	private void setLeftTitleButtonText(final int textId) {
		setLeftTitleButtonText(mDoActivity.getString(textId));
	}

	/**
	 * 设置标题栏右边按钮
	 * 
	 * @param imageRes
	 * @param listener
	 */
	public void setRightTitleButton(int title, OnClickListener listener) {
		mRightButton.setText(title);
		mRightButton.setOnClickListener(listener);
		setShowRightButton(true);
	}

	/**
	 * 设置标题栏右边按钮
	 * 
	 * @param image
	 * @param listener
	 */
	public void setRightTitleButton(String title, OnClickListener listener) {
		mRightButton.setText(title);
		mRightButton.setOnClickListener(listener);
		setShowRightButton(true);
	}

	/**
	 * 设置标题栏右边按钮为ImageButton
	 * 最右边的
	 * 
	 * @param image
	 * @param listener
	 */
	public void setRightImageButton(int resId, OnClickListener listener) {
		mRightImageButton.setImageResource(resId);
		mRightImageButton.setOnClickListener(listener);
		setShowRightImageButton(true);
	}

	/**
	 * 设置标题栏右边按钮为ImageButton
	 * 该按钮右边还有一个按钮
	 * 
	 * @param image
	 * @param listener
	 */
	public void setTitleRightImageButton(int resId, OnClickListener listener) {
		mTitleRightImageButton.setImageResource(resId);
		mTitleRightImageButton.setOnClickListener(listener);
		mTitleRightImageButton.setVisibility(View.VISIBLE);
	}

	public ImageButton getRightImageButton() {
		return mRightImageButton;
	}

	/**
	 * 设置左边标题按钮长按时的提示文字
	 * 
	 * @param text
	 */
	public void setRightTitleButtonText(final String text) {
		if (TextUtils.isEmpty(text))
			return;

		mRightButton.setOnLongClickListener(new OnLongClickListener() {
			@Override
			public boolean onLongClick(View v) {
				Util.alert(mDoActivity, text);
				return false;
			}
		});
	}

	/**
	 * 设置左边标题按钮长按时的提示文字
	 * 
	 * @param text
	 */
	public void setRightTitleButtonText(final int textId) {
		setRightTitleButtonText(mDoActivity.getString(textId));
	}

	/**
	 * 如果context是Activity，则返回此Activity，否则返回null
	 * 
	 * @return
	 */
	public Activity getActvityContex() {
		return mDoActivity;
	}

	/**
	 * 添加主内容View
	 * 
	 * @param contentView
	 */
	public void addContentView(View contentView) {
		mContainer.addView(contentView);
	}

	/**
	 * 返回ActionBar主内容视图
	 * 
	 * @return
	 */
	public ViewGroup getContainerView() {
		return mContainer;
	}

	/**
	 * 使ActionBar悬浮在内容上，而不是垂直布局
	 * 
	 * @param floated
	 */
	public void setTitlebarFloatAboveContent(boolean floated) {
		mTitleBarFloatAboveContent = floated;
		findViewById(R.id.action_bar_titlebar_margin).setVisibility(floated ? View.GONE : View.VISIBLE);
	}

	/**
	 * 是否显示标题栏，默认为显示
	 * 
	 * @param isShow
	 *            true:显示；false:隐藏
	 */
	public void setShowTitleBar(boolean isShow) {
		View margin = findViewById(R.id.action_bar_titlebar_margin);
		mTitleBar.setVisibility(isShow ? View.VISIBLE : View.GONE);
		margin.setVisibility(isShow ? View.VISIBLE : View.GONE);
		// 如果标题栏已设置为悬浮在内容上，则隐藏标题栏margin
		if (mTitleBarFloatAboveContent)
			margin.setVisibility(View.GONE);
	}

	/**
	 * 是否显示返回按钮，一般在需要返回的界面显示<br />
	 * 默认为隐藏状态
	 * 
	 * @param isShow
	 *            true:显示；false:隐藏
	 */
	public void setShowBackButton(boolean isShow) {
		findViewById(R.id.action_bar_titlebar_left_layout).setVisibility(isShow ? View.VISIBLE : View.INVISIBLE);
	}

	public View getBackLayout() {
		return findViewById(R.id.action_bar_titlebar_left_layout);
	}

	public View getParentView() {
		return mParentView;
	}

	/**
	 * 是否显示右侧按钮<br />
	 * 默认为隐藏状态，当使用addTitleButtons添加按钮会自动显示<br />
	 * 
	 * 
	 * @param isShow
	 *            true:显示；false:隐藏
	 */
	public void setShowRightButton(boolean isShow) {
		findViewById(R.id.action_bar_titlebar_right_layout).setVisibility(isShow ? View.VISIBLE : View.INVISIBLE);
	}

	public void setShowRightImageButton(boolean isShow) {
		findViewById(R.id.action_bar_titlebar_right_layout).setVisibility(isShow ? View.VISIBLE : View.INVISIBLE);
		findViewById(R.id.action_bar_titlebar_right).setVisibility(isShow ? View.GONE : View.VISIBLE);
		findViewById(R.id.action_bar_titlebar_right_ib).setVisibility(isShow ? View.VISIBLE : View.INVISIBLE);
	}

	/**
	 * 打开显示返回按钮的Activity
	 * 
	 * @param intent
	 */
	public void startActivityWithBackButton(Intent intent) {
		// intent.putExtra(DoActivity.EXTRA_SHOW_BACK, true);
		// mDoActivity.startActivity(intent);
	}

	/**
	 * 打开显示返回按钮的Activity
	 * 
	 * @param intent
	 */
	public void startActivityForResultWithBackButton(Intent intent, int requestCode) {
		// intent.putExtra(DoActivity.EXTRA_SHOW_BACK, true);
		// mDoActivity.startActivityForResult(intent, requestCode);
	}

	@Override
	public void onClick(View v) {
		if (!v.isShown()) // 按钮未显示，效点无击
			return;

		if (v == mBackButton) {
			if (mActionBarHandler != null) {
				mActionBarHandler.back();
				return;
			}
			
			if (mDoActivity != null)
				mDoActivity.finish();
		} else if (v == mHomeImg) {
			if (mTabbarView.getVisibility() == View.VISIBLE) {
				mTabbarView.setVisibility(View.GONE);
			} else {
				mTabbarView.setVisibility(View.VISIBLE);
			}
		} else {
			for (int i = 0; i < mRadioGroup.getChildCount(); i++) {
				if (mRadioGroup.getChildAt(i) == v) {

				}
			}
		}
	}
	
	public interface ActionBarHandler{
		void back();
	}
}
