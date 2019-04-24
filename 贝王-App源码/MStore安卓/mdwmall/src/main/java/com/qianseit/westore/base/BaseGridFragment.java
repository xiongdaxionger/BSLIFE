package com.qianseit.westore.base;

import android.graphics.Bitmap;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.ScaleAnimation;
import android.view.animation.TranslateAnimation;
import android.view.animation.Animation.AnimationListener;
import android.widget.FrameLayout;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.ui.MyGridView;
import com.qianseit.westore.ui.MyScrollView.OnScrollListener;
import com.qianseit.westore.ui.pull.PullToRefreshLayout;
import com.qianseit.westore.ui.pull.PullToRefreshLayout.OnRefreshListener;
import com.qianseit.westore.ui.pull.PullableScrollView;
import com.qianseit.westore.util.Util;

public abstract class BaseGridFragment<T> extends BasePageFragment<T> implements OnRefreshListener {

	// no data view
	private ImageView mEmptyImageView;
	private TextView mEmptyTextView;
	private RelativeLayout mEmptyViewRL;
	private String mEmptyString = "";
	private int mEmptyStringRes = -1;
	private int mImageRes = -1;

	protected int mImageWidth;

	// pull view
	protected PullToRefreshLayout mPullToRefreshLayout;
	protected LinearLayout mListBottomLinearLayout;
	protected LinearLayout mListTopLinearLayout;
	protected LinearLayout mListHeaderLinearLayout;
	protected MyGridView mGridView;

	// 快速工具栏
	protected PullableScrollView mPullableScrollView;
	int mScreenHeight = 0;
	ImageView mToTopImageView, mShopCarImageView;
	boolean mShowShopCar = false;
	private FrameLayout mAnimationLayout;
	TextView mShopCarcountTextView;
	
	boolean showEmptyView = true;

	@Override
	protected void onLoadFinished() {
		// TODO Auto-generated method stub
		mPullToRefreshLayout.refreshFinish(PullToRefreshLayout.SUCCEED);
		mPullToRefreshLayout.loadmoreFinish(PullToRefreshLayout.SUCCEED);
		mPullToRefreshLayout.setPullUp(!isLoadAll());
	}

	@Override
	protected void onPageEnable(boolean enable) {
		// TODO Auto-generated method stub
		mPullToRefreshLayout.setPullDown(enable);
		mPullToRefreshLayout.setPullUp(enable);
	}

	protected void onPageUpEnable(boolean enable) {
		// TODO Auto-generated method stub
		mPullToRefreshLayout.setPullUp(enable);
	}

	protected void addHeader(LinearLayout headerLayout) {

	}

	protected void setAnimation(Bitmap bmp, float x, float y) {
		ImageView img = new ImageView(getActivity());
		img.setLayoutParams(new FrameLayout.LayoutParams(bmp.getWidth(), bmp.getHeight()));
		img.setX(x + Util.dip2px(mActivity, 10));
		img.setY(y + Util.dip2px(mActivity, 10));
		img.setImageBitmap(bmp);
		mAnimationLayout.addView(img);

		setAnimation(img);
	}

	private void setAnimation(View view) {
		AnimationSet set = new AnimationSet(true);
		TranslateAnimation t = new TranslateAnimation(0, Util.dip2px(mActivity, 327), 0, Util.dip2px(mActivity, 493) - view.getY() * 0.1f);
		t.setDuration(500);
		ScaleAnimation sa = new ScaleAnimation(1.0f, 0.1f, 1.0f, 0.1f);
		sa.setDuration(500);
		set.addAnimation(sa);
		set.addAnimation(t);
		view.startAnimation(set);
		set.setAnimationListener(new AnimationListener() {

			@Override
			public void onAnimationStart(Animation arg0) {
			}

			@Override
			public void onAnimationRepeat(Animation arg0) {
			}

			@Override
			public void onAnimationEnd(Animation arg0) {
				mAnimationLayout.removeAllViews();
			}
		});
	}

	@Override
	final protected void init() {
		// TODO Auto-generated method stub
		rootView = View.inflate(mActivity, R.layout.base_fragment_grid, null);

		mListBottomLinearLayout = (LinearLayout) findViewById(R.id.base_fragment_listview_bottom_ll);
		mListTopLinearLayout = (LinearLayout) findViewById(R.id.base_fragment_listview_top_ll);

		mPullToRefreshLayout = ((PullToRefreshLayout) findViewById(R.id.refresh_view));
		mPullToRefreshLayout.setOnRefreshListener(this);

		mEmptyViewRL = (RelativeLayout) findViewById(R.id.base_error_rl);
		mEmptyImageView = (ImageView) findViewById(R.id.base_error_iv);
		mEmptyTextView = (TextView) findViewById(R.id.base_error_tv);
		findViewById(R.id.base_reload_tv).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				onRefresh(null);
			}
		});

		mImageWidth = (1080 - Run.dip2px(mActivity, 5 * (getNumColumns() + 1))) / getNumColumns();
		mGridView = (MyGridView) findViewById(R.id.base_gv);
		mGridView.setEmptyView(null);
		mGridView.setAdapter(mAdapter);
		mGridView.setNumColumns(getNumColumns());
		mGridView.setHorizontalSpacing(Util.dip2px(mActivity, 5));
		mGridView.setVerticalSpacing(Util.dip2px(mActivity, 5));
		mGridView.setStretchMode(GridView.STRETCH_COLUMN_WIDTH);

		// no data view
		if (mImageRes != -1) {
			setEmptyImage(mImageRes);
		}
		if (mEmptyStringRes != -1) {
			setEmptyText(mEmptyStringRes);
		}
		if (mEmptyString != null && !TextUtils.isEmpty(mEmptyString)) {
			setEmptyText(mEmptyString);
		}

		initToTop();

		mListHeaderLinearLayout = (LinearLayout) findViewById(R.id.base_fragment_header_ll);
		mListHeaderLinearLayout.setVisibility(View.VISIBLE);

		initTop(mListTopLinearLayout);
		initBottom(mListBottomLinearLayout);

		addHeader(mListHeaderLinearLayout);

		endInit();
	}

	protected void setCustomEmptyView(View customEmptyView) {
		mEmptyViewRL.removeAllViews();

		mEmptyViewRL.addView(customEmptyView);
		RelativeLayout.LayoutParams nLayoutParams = (RelativeLayout.LayoutParams) customEmptyView.getLayoutParams();
		nLayoutParams.width = RelativeLayout.LayoutParams.MATCH_PARENT;
	}

	void initToTop() {
		mScreenHeight = Run.getWindowsHeight(mActivity);

		mToTopImageView = (ImageView) findViewById(R.id.to_top);
		mToTopImageView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				mPullableScrollView.smoothScrollTo(0, 0);
			}
		});

		mPullableScrollView = (PullableScrollView) findViewById(R.id.base_pull_scrollview);
		mPullableScrollView.setOnScrollListener(new OnScrollListener() {

			@Override
			public void onScroll(int scrollY) {
				// TODO Auto-generated method stub
				if (mShowShopCar || Math.abs(scrollY) > mScreenHeight * 2) {
					findViewById(R.id.tools_ll).setVisibility(View.VISIBLE);
				} else {
					findViewById(R.id.tools_ll).setVisibility(View.GONE);
				}
			}
		});

		mAnimationLayout = (FrameLayout) findViewById(R.id.animation_layout);
		mShopCarImageView = (ImageView) findViewById(R.id.shopcar);
		mShopCarImageView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub,进入购物车
				startActivity(AgentActivity.FRAGMENT_SHOPP_GOODS_CAR);
			}
		});
		mShopCarcountTextView = (TextView) findViewById(R.id.shopcar_count);
	}

	protected int getNumColumns() {
		return 2;
	}

	protected void setShowShopCar(boolean showShopCar) {
		mShowShopCar = showShopCar;
		if (mShowShopCar) {
			findViewById(R.id.tools_ll).setVisibility(View.VISIBLE);
			findViewById(R.id.shopcar_rl).setVisibility(View.VISIBLE);
		}
	}

	protected void setShopCarCount(int count) {
		mShopCarcountTextView.setVisibility(count > 0 ? View.VISIBLE : View.GONE);
		if (count < 100) {
			mShopCarcountTextView.setText(String.valueOf(count));
		} else {
			mShopCarcountTextView.setText("99+");
		}
	}

	@Override
	protected void VisbleNull(boolean isNull) {
		if (isNull && showEmptyView) {
			mGridView.setEmptyView(mEmptyViewRL);
			mEmptyViewRL.setVisibility(View.VISIBLE);
		} else {
			mGridView.setEmptyView(null);
			mEmptyViewRL.setVisibility(View.GONE);
		}
	}

	final protected void setEmptyImage(int imgRes) {
		if (mEmptyImageView == null) {
			mImageRes = imgRes;
			return;
		}
		mEmptyImageView.setImageResource(imgRes);
	}

	final protected void setEmptyText(int strRes) {
		if (mEmptyImageView == null) {
			mEmptyStringRes = strRes;
			return;
		}
		mEmptyTextView.setText(strRes);
	}

	final protected void setEmptyText(String emptyString) {
		if (mEmptyImageView == null) {
			mEmptyString = emptyString;
			return;
		}
		mEmptyTextView.setText(emptyString);
	}
	
	final protected void setShowEmptyText(boolean show) {
		showEmptyView = show;
	}
	
	private void showDivideTop(boolean show) {
		findViewById(R.id.base_fragment_top_divide).setVisibility(show ? View.VISIBLE : View.GONE);
	}

	@Override
	public void onRefresh(PullToRefreshLayout pullToRefreshLayout) {
		// TODO Auto-generated method stub
		onPageUpEnable(true);
		loadNextPage(0);
	}

	@Override
	public void onLoadMore(PullToRefreshLayout pullToRefreshLayout) {
		// TODO Auto-generated method stub
		loadNextPage(mPageNum);
	}
}
