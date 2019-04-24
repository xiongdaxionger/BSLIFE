package com.qianseit.westore.activity.goods;

import java.util.ArrayList;

import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.graphics.Point;
import android.os.Handler;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;
import com.beiwangfx.R;

/**
 * 广告图片自动轮播控件</br>
 * 
 * <pre>
 *   集合ViewPager和指示器的一个轮播控件，主要用于一般常见的广告图片轮播，具有自动轮播和手动轮播功能 
 *   使用：只需在xml文件中使用{@code <com.minking.imagecycleview.ImageCycleView/>} ，
 *   然后在页面中调用  {@link #setImageResources(ArrayList, GoodsCycleViewListener) }即可!
 *   
 *   另外提供{@link #startImageCycle() } \ {@link #pushImageCycle() }两种方法，用于在Activity不可见之时节省资源；
 *   因为自动轮播需要进行控制，有利于内存管理
 * </pre>
 * 
 * @author minking
 */
public class GoodsCycleView extends LinearLayout {

	/**
	 * 上下文
	 */
	private Context mContext;

	/**
	 * 图片轮播视图
	 */
	private ViewPager mAdvPager = null;

	/**
	 * 滚动图片视图适配器
	 */
	private ImageCycleAdapter mAdvAdapter;

	/**
	 * 图片轮播指示器控件
	 */
	private ViewGroup mGroup;

	/**
	 * 图片轮播指示器-个图
	 */
	private ImageView mImageView = null;

	/**
	 * 滚动图片指示器-视图列表
	 */
	private ImageView[] mImageViews = null;

	/**
	 * 图片滚动当前图片下标
	 */
	private int mImageIndex = 0;

	/**
	 * 手机密度
	 */
	private float mScale;

	/**
	 * @param context
	 */
	public GoodsCycleView(Context context) {
		super(context);
	}

	/**
	 * @param context
	 * @param attrs
	 */
	public GoodsCycleView(Context context, AttributeSet attrs) {
		super(context, attrs);
		mContext = context;
		mScale = context.getResources().getDisplayMetrics().density;
		LayoutInflater.from(context).inflate(R.layout.home_ad_view, this);
		if (!isInEditMode()) {
			mAdvPager = (ViewPager) findViewById(R.id.home_adv_pager);
			mAdvPager.setOnPageChangeListener(new GuidePageChangeListener());
			mAdvPager.setOnTouchListener(new OnTouchListener() {

				@Override
				public boolean onTouch(View v, MotionEvent event) {
					switch (event.getAction()) {
					case MotionEvent.ACTION_UP:
						// 开始图片滚动
						startImageTimerTask();
						break;
					default:
						// 停止图片滚动
						stopImageTimerTask();
						break;
					}
					return false;
				}
			});
			// 滚动图片右下指示器视图
			mGroup = (ViewGroup) findViewById(R.id.home_adv_viewGroup);
		}
	}

	/**
	 * 装填图片数据
	 * 
	 * @param goodsList
	 * @param imageCycleViewListener
	 */
	public void setImageResources(ArrayList<JSONObject> goodsList, GoodsCycleViewListener imageCycleViewListener) {
		// 清除所有子视图
		mGroup.removeAllViews();
		// 图片广告数量
		final int cycleCount = goodsList.size() % 3 == 0 ? goodsList.size() / 3 : goodsList.size() / 3 + 1;
		mImageViews = new ImageView[cycleCount];
		int imageParams = (int) (mScale * 5 + 0.5f);// XP与DP转换，适应不同分辨率
		int imagePadding = (int) (mScale * 5 + 0.5f);
		LayoutParams mLayoutParams = new LayoutParams(imageParams, imageParams);
		mLayoutParams.setMargins(0, 0, imagePadding, 0);
		for (int i = 0; i < cycleCount; i++) {
			mImageView = new ImageView(mContext);
			mImageView.setLayoutParams(mLayoutParams);
			mImageViews[i] = mImageView;
			if (i == 0) {
				mImageViews[i].setBackgroundResource(R.drawable.group_adv2_select);
			} else {
				mImageViews[i].setBackgroundResource(R.drawable.group_adv_no_select);
			}
			mGroup.addView(mImageViews[i]);
		}

		if (cycleCount <= 1) {
			mGroup.setVisibility(View.GONE);
		} else {
			mGroup.setVisibility(View.VISIBLE);
		}

		mAdvAdapter = new ImageCycleAdapter(mContext, goodsList, imageCycleViewListener);
		mAdvPager.setAdapter(mAdvAdapter);
		startImageTimerTask();
	}

	/**
	 * 开始轮播(手动控制自动轮播与否，便于资源控制)
	 */
	public void startImageCycle() {
		startImageTimerTask();
	}

	/**
	 * 暂停轮播——用于节省资源
	 */
	public void pushImageCycle() {
		stopImageTimerTask();
	}

	/**
	 * 开始图片滚动任务
	 */
	private void startImageTimerTask() {
		stopImageTimerTask();
		// 图片每3秒滚动一次
		mHandler.postDelayed(mImageTimerTask, 5000);
	}

	/**
	 * 停止图片滚动任务
	 */
	private void stopImageTimerTask() {
		mHandler.removeCallbacks(mImageTimerTask);
	}

	private Handler mHandler = new Handler();

	/**
	 * 图片自动轮播Task
	 */
	private Runnable mImageTimerTask = new Runnable() {

		@Override
		public void run() {
			if (mImageViews != null) {
				// 下标等于图片列表长度说明已滚动到最后一张图片,重置下标
				if ((++mImageIndex) == mImageViews.length) {
					mImageIndex = 0;
				}
				mAdvPager.setCurrentItem(mImageIndex);
			}
		}
	};

	/**
	 * 轮播图片状态监听器
	 * 
	 * @author minking
	 */
	private final class GuidePageChangeListener implements OnPageChangeListener {

		@Override
		public void onPageScrollStateChanged(int state) {
			if (state == ViewPager.SCROLL_STATE_IDLE)
				startImageTimerTask(); // 开始下次计时
		}

		@Override
		public void onPageScrolled(int arg0, float arg1, int arg2) {
		}

		@Override
		public void onPageSelected(int index) {
			// 设置当前显示的图片下标
			mImageIndex = index;
			// 设置图片滚动指示器背景
			mImageViews[index].setBackgroundResource(R.drawable.group_adv2_select);
			for (int i = 0; i < mImageViews.length; i++) {
				if (index != i) {
					mImageViews[i].setBackgroundResource(R.drawable.group_adv_no_select);
				}
			}

		}

	}

	private class ImageCycleAdapter extends PagerAdapter {

		/**
		 * 图片视图缓存列表
		 */
		private ArrayList<View> mViewCacheList;

		/**
		 * 图片资源列表
		 */
		private ArrayList<JSONObject> mAdList = new ArrayList<JSONObject>();

		/**
		 * 广告图片点击监听器
		 */
		private GoodsCycleViewListener mImageCycleViewListener;

		private Context mContext;
		private Point mPoint;

		public ImageCycleAdapter(Context context, ArrayList<JSONObject> adList, GoodsCycleViewListener imageCycleViewListener) {
			mContext = context;
			mPoint = Run.getScreenSize(((Activity) context).getWindowManager());
			mAdList = adList;
			mImageCycleViewListener = imageCycleViewListener;
			mViewCacheList = new ArrayList<View>();
		}

		@Override
		public int getCount() {
			return mAdList.size() % 3 == 0 ? mAdList.size() / 3 : mAdList.size() / 3 + 1;
		}

		@Override
		public boolean isViewFromObject(View view, Object obj) {
			return view == obj;
		}

		@Override
		public Object instantiateItem(ViewGroup container, final int position) {
			View contentView = null, contentLeftView = null, contentRightView = null, contentMiddleView = null;
			if (mViewCacheList.isEmpty()) {
				contentView = View.inflate(mContext, R.layout.item_goods_detail_goods, null);
				contentLeftView = contentView.findViewById(R.id.item_goods_linear_left);
				contentMiddleView = contentView.findViewById(R.id.item_goods_linear_middle);
				contentRightView = contentView.findViewById(R.id.item_goods_linear_right);
				BaseDoFragment.setViewSize(contentLeftView.findViewById(R.id.item_goods_icon), 360, 360);
				BaseDoFragment.setViewSize(contentMiddleView.findViewById(R.id.item_goods_icon), 360, 360);
				BaseDoFragment.setViewSize(contentRightView.findViewById(R.id.item_goods_icon), 360, 360);
				contentLeftView.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						if (v.getTag() != null) {
							mImageCycleViewListener.onClick((JSONObject) v.getTag(), v);
						}
					}
				});
				contentMiddleView.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						if (v.getTag() != null) {
							mImageCycleViewListener.onClick((JSONObject) v.getTag(), v);
						}
					}
				});
				contentRightView.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						if (v.getTag() != null) {
							mImageCycleViewListener.onClick((JSONObject) v.getTag(), v);
						}
					}
				});
			} else {
				contentView = mViewCacheList.remove(0);
				contentLeftView = contentView.findViewById(R.id.item_goods_linear_left);
				contentMiddleView = contentView.findViewById(R.id.item_goods_linear_middle);
				contentRightView = contentView.findViewById(R.id.item_goods_linear_right);
			}

			if (mAdList.size() > position * 3) {// left
				contentLeftView.setTag(mAdList.get(position * 3));
			} else {
				contentLeftView.setTag(null);
			}

			if (mAdList.size() > position * 3 + 1) {// middle
				contentMiddleView.setTag(mAdList.get(position * 3 + 1));
			} else {
				contentMiddleView.setTag(null);
			}

			if (mAdList.size() > position * 3 + 2) {// right
				contentRightView.setTag(mAdList.get(position * 3 + 2));
			} else {
				contentRightView.setTag(null);
			}

			container.addView(contentView);

			assignmentValue(contentLeftView);
			assignmentValue(contentMiddleView);
			assignmentValue(contentRightView);

			return contentView;
		}

		@Override
		public void destroyItem(ViewGroup container, int position, Object object) {
			View view = (View) object;
			container.removeView(view);
			mViewCacheList.add(view);
		}

		void assignmentValue(View parentView) {
			if (parentView == null) {
				return;
			}

			Object nObject = parentView.getTag();
			JSONObject nJsonObject = null;
			if (nObject instanceof JSONObject) {
				nJsonObject = (JSONObject) nObject;
			}

			if (nJsonObject == null) {
				((ImageView) parentView.findViewById(R.id.item_goods_icon)).setImageBitmap(null);
				((TextView) parentView.findViewById(R.id.item_goods_title)).setText("");
				((TextView) parentView.findViewById(R.id.item_goods_price)).setText("");
			} else {
				mImageCycleViewListener.displayImage(nJsonObject, (ImageView) parentView.findViewById(R.id.item_goods_icon));
				((TextView) parentView.findViewById(R.id.item_goods_title)).setText(nJsonObject.optString("name"));
				((TextView) parentView.findViewById(R.id.item_goods_price)).setText(nJsonObject.optString("price"));
			}
		}
	}

	@Override
	public boolean dispatchTouchEvent(MotionEvent ev) {
		if (ev.getAction() == MotionEvent.ACTION_DOWN) {
			this.getParent().getParent().getParent().requestDisallowInterceptTouchEvent(false);
		} else if (ev.getAction() == MotionEvent.ACTION_MOVE) {
			this.getParent().getParent().getParent().requestDisallowInterceptTouchEvent(true);
		}
		return super.dispatchTouchEvent(ev);

	}

	@Override
	public boolean onInterceptTouchEvent(MotionEvent ev) {
		// TODO Auto-generated method stub
		return false;
	}

	/**
	 * 轮播控件的监听事件
	 * 
	 * @author minking
	 */
	public interface GoodsCycleViewListener {

		/**
		 * 加载图片资源
		 * 
		 * @param imageURL
		 * @param imageView
		 */
		void displayImage(JSONObject imageURLJson, ImageView imageView);

		/**
		 * 单击图片事件
		 * 
		 * @param jsonObject
		 * @param imageView
		 */
		void onClick(JSONObject jsonObject, View view);
	}

}
