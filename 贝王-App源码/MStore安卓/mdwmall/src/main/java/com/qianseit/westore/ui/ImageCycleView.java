package com.qianseit.westore.ui;

import android.app.Activity;
import android.content.Context;
import android.graphics.Matrix;
import android.graphics.Point;
import android.graphics.PointF;
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

import com.beiwangfx.R;
import com.qianseit.westore.Run;

import java.util.ArrayList;

/**
 * 广告图片自动轮播控件</br>
 * 
 * <pre>
 *   集合ViewPager和指示器的一个轮播控件，主要用于一般常见的广告图片轮播，具有自动轮播和手动轮播功能 
 *   使用：只需在xml文件中使用{@code <com.minking.imagecycleview.ImageCycleView/>} ，
 *   然后在页面中调用  {@link #setImageResources(ArrayList, ImageCycleViewListener) }即可!
 *   
 *   另外提供{@link #startImageCycle() } \ {@link #pushImageCycle() }两种方法，用于在Activity不可见之时节省资源；
 *   因为自动轮播需要进行控制，有利于内存管理
 * </pre>
 * 
 * @author minking
 */
public class ImageCycleView<T> extends LinearLayout {

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
	private ImageCycleAdapter<T> mAdvAdapter;

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

	boolean mAutoPaper = true;

	/**
	 * @param context
	 */
	public ImageCycleView(Context context) {
		this(context, null);
	}

	/**
	 * 广告图片点击监听器
	 */
	private ImageCycleViewListener<T> mImageCycleViewListener;

	/**
	 * @param context
	 * @param attrs
	 */
	public ImageCycleView(Context context, AttributeSet attrs) {
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
	 * @param imageUrlList
	 * @param imageCycleViewListener
	 */
	public void setImageResources(ArrayList<T> imageUrlList, ImageCycleViewListener<T> imageCycleViewListener) {
		// 清除所有子视图
		mGroup.removeAllViews();
		// 图片广告数量
		final int imageCount = imageUrlList.size();
		mImageViews = new ImageView[imageCount];
		int imageParams = (int) (mScale * 5 + 0.5f);// XP与DP转换，适应不同分辨率
		int imagePadding = (int) (mScale * 5 + 0.5f);
		LayoutParams mLayoutParams = new LayoutParams(imageParams, imageParams);
		mLayoutParams.setMargins(0, 0, imagePadding, 0);
		for (int i = 0; i < imageCount; i++) {
			mImageView = new ImageView(mContext);
			mImageView.setLayoutParams(mLayoutParams);
			mImageViews[i] = mImageView;
			if (i == 0) {
				mImageViews[i].setBackgroundResource(R.drawable.group_adv_select);
			} else {
				mImageViews[i].setBackgroundResource(R.drawable.group_adv_no_select);
			}
			mGroup.addView(mImageViews[i]);
		}
		if (imageCount <= 1) {
			mGroup.setVisibility(View.GONE);
		} else {
			mGroup.setVisibility(View.VISIBLE);
		}
		mImageCycleViewListener = imageCycleViewListener;
		mAdvAdapter = new ImageCycleAdapter<T>(mContext, imageUrlList, mImageCycleViewListener);
		mAdvPager.setAdapter(mAdvAdapter);
		startImageTimerTask();
	}

	private final class TouchListener implements OnTouchListener {

		/** 记录是拖拉照片模式还是放大缩小照片模式 */
		private int mode = 0;// 初始状态
		/** 拖拉照片模式 */
		private static final int MODE_DRAG = 1;
		/** 放大缩小照片模式 */
		private static final int MODE_ZOOM = 2;

		/** 用于记录开始时候的坐标位置 */
		private PointF startPoint = new PointF();
		/** 用于记录拖拉图片移动的坐标位置 */
		private Matrix matrix = new Matrix();
		/** 用于记录图片要进行拖拉时候的坐标位置 */
		private Matrix currentMatrix = new Matrix();

		/** 两个手指的开始距离 */
		private float startDis;
		/** 两个手指的中间点 */
		private PointF midPoint;

		ImageView mImageView;

		public TouchListener(ImageView imageView) {
			mImageView = imageView;
		}

		@Override
		public boolean onTouch(View v, MotionEvent event) {
			/** 通过与运算保留最后八位 MotionEvent.ACTION_MASK = 255 */
			switch (event.getAction() & MotionEvent.ACTION_MASK) {
			// 手指压下屏幕
			case MotionEvent.ACTION_DOWN:
				mode = MODE_DRAG;
				// 记录ImageView当前的移动位置
				currentMatrix.set(mImageView.getImageMatrix());
				startPoint.set(event.getX(), event.getY());
				break;
			// 手指在屏幕上移动，改事件会被不断触发
			case MotionEvent.ACTION_MOVE:
				// 拖拉图片
				if (mode == MODE_DRAG) {
					float dx = event.getX() - startPoint.x; // 得到x轴的移动距离
					float dy = event.getY() - startPoint.y; // 得到x轴的移动距离
					// 在没有移动之前的位置上进行移动
					matrix.set(currentMatrix);
					matrix.postTranslate(dx, dy);
				}
				// 放大缩小图片
				else if (mode == MODE_ZOOM) {
					float endDis = distance(event);// 结束距离
					if (endDis > 10f) { // 两个手指并拢在一起的时候像素大于10
						float scale = endDis / startDis;// 得到缩放倍数
						matrix.set(currentMatrix);
						matrix.postScale(scale, scale, midPoint.x, midPoint.y);
					}
				}
				break;
			// 手指离开屏幕
			case MotionEvent.ACTION_UP:
				float x2 = event.getX();
				float y2 = event.getY();
				if (distance(startPoint.x, startPoint.y, x2, y2) < 10) {
					mImageView.performClick();
				}
				// 当触点离开屏幕，但是屏幕上还有触点(手指)
			case MotionEvent.ACTION_POINTER_UP:
				mode = 0;
				break;
			// 当屏幕上已经有触点(手指)，再有一个触点压下屏幕
			case MotionEvent.ACTION_POINTER_DOWN:
				mode = MODE_ZOOM;
				/** 计算两个手指间的距离 */
				startDis = distance(event);
				/** 计算两个手指间的中间点 */
				if (startDis > 10f) { // 两个手指并拢在一起的时候像素大于10
					midPoint = mid(event);
					// 记录当前ImageView的缩放倍数
					currentMatrix.set(mImageView.getImageMatrix());
				}
				break;
			}
			mImageView.setImageMatrix(matrix);
			return true;
		}

		/** 计算两个手指间的距离 */
		private float distance(MotionEvent event) {
			float dx = event.getX(1) - event.getX(0);
			float dy = event.getY(1) - event.getY(0);
			/** 使用勾股定理返回两点之间的距离 */
			return (float)Math.sqrt(dx * dx + dy * dy);
		}

		/** 计算两个手指间的中间点 */
		private PointF mid(MotionEvent event) {
			float midX = (event.getX(1) + event.getX(0)) / 2;
			float midY = (event.getY(1) + event.getY(0)) / 2;
			return new PointF(midX, midY);
		}

		/** 计算两个手指间的距离 */
		private float distance(float x1, float y1, float x2, float y2) {
			float dx = x1 - x2;
			float dy = y1 - y2;
			/** 使用勾股定理返回两点之间的距离 */
			return (float)Math.sqrt(dx * dx + dy * dy);
		}

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
		mAutoPaper = false;
		stopImageTimerTask();
	}

	/**
	 * 开始图片滚动任务
	 */
	private void startImageTimerTask() {
		stopImageTimerTask();
		// 图片每3秒滚动一次
		if (!mAutoPaper) {
			return;
		}
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

	public boolean mIsChanged;

	public void setCurrentItem(int index) {
		if (index < mImageViews.length && index >= 0) {
			mImageIndex = index;
			mAdvPager.setCurrentItem(index);
		}
	}

	public int getCurrentItem() {
		return mAdvPager.getCurrentItem();
	}

	/**
	 * 轮播图片状态监听器
	 * 
	 * @author minking
	 */
	private final class GuidePageChangeListener implements OnPageChangeListener {

		@Override
		public void onPageScrollStateChanged(int state) {
			if (mImageCycleViewListener != null && mImageCycleViewListener instanceof ImageCycleViewScrollListener) {
				((ImageCycleViewScrollListener<T>) mImageCycleViewListener).onPageScrollStateChanged(state);
			} else {
				if (state == ViewPager.SCROLL_STATE_IDLE) {
					if (mIsChanged) {
						mIsChanged = false;
						mAdvPager.setCurrentItem(mImageIndex, false);
					}
					startImageTimerTask(); // 开始下次计时
				}
			}
		}

		@Override
		public void onPageScrolled(int arg0, float arg1, int arg2) {
		}

		@Override
		public void onPageSelected(int index) {
			// 设置当前显示的图片下标
			mIsChanged = true;
			if (index >= mImageViews.length) {
				mImageIndex = 0;
			} else if (index < 0) {
				mImageIndex = mImageViews.length - 1;
			} else {
				mImageIndex = index;
			}
			ImageCycleView.this.setCurrentItem(mImageIndex);
			// 设置图片滚动指示器背景
			mImageViews[index].setBackgroundResource(R.drawable.group_adv_select);
			for (int i = 0; i < mImageViews.length; i++) {
				if (index != i) {
					mImageViews[i].setBackgroundResource(R.drawable.group_adv_no_select);
				}
			}

		}

	}

	private class ImageCycleAdapter<T> extends PagerAdapter {

		/**
		 * 图片视图缓存列表
		 */
		private ArrayList<ImageView> mImageViewCacheList;

		/**
		 * 图片资源列表
		 */
		private ArrayList<T> mAdList = new ArrayList<T>();

		/**
		 * 广告图片点击监听器
		 */
		private ImageCycleViewListener<T> mImageCycleViewListener;

		private Context mContext;
		private Point mPoint;

		public ImageCycleAdapter(Context context, ArrayList<T> adList, ImageCycleViewListener<T> imageCycleViewListener) {
			mContext = context;
			mPoint = Run.getScreenSize(((Activity) context).getWindowManager());
			mAdList = adList;
			mImageCycleViewListener = imageCycleViewListener;
			mImageViewCacheList = new ArrayList<ImageView>();
		}

		@Override
		public int getCount() {
			return mAdList.size();
		}

		@Override
		public boolean isViewFromObject(View view, Object obj) {
			return view == obj;
		}

		@Override
		public Object instantiateItem(ViewGroup container, final int position) {
			T imageUrlJSON = mAdList.get(position);
			ImageView imageView = null;
			if (mImageViewCacheList.isEmpty()) {
				imageView = new ImageView(mContext);
				imageView.setLayoutParams(new LayoutParams(mPoint.x, mPoint.x));
				imageView.setScaleType(ImageView.ScaleType.FIT_CENTER);

			} else {
				imageView = mImageViewCacheList.remove(0);
			}
			// 设置图片点击监听
			imageView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					mImageCycleViewListener.onImageClick(position, v);
				}
			});
			// imageView.setOnTouchListener(new TouchListener(imageView));
			imageView.setTag(imageUrlJSON);
			container.addView(imageView);
			mImageCycleViewListener.displayImage(imageUrlJSON, imageView);
			return imageView;
		}

		@Override
		public void destroyItem(ViewGroup container, int position, Object object) {
			ImageView view = (ImageView) object;
			container.removeView(view);
			mImageViewCacheList.add(view);
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
	public interface ImageCycleViewListener<T> {

		/**
		 * 加载图片资源
		 * 
		 * @param t
		 * @param imageView
		 */
		void displayImage(T t, ImageView imageView);

		/**
		 * 单击图片事件
		 * 
		 * @param position
		 * @param imageView
		 */
		void onImageClick(int position, View imageView);
	}

	/**
	 * 轮播控件的监听事件(带滑动监听)
	 * 
	 * @author ytq
	 */
	public interface ImageCycleViewScrollListener<T> extends ImageCycleViewListener<T> {
		/**
		 * @param state
		 *            滑动监听
		 */
		void onPageScrollStateChanged(int state);
	}

}
