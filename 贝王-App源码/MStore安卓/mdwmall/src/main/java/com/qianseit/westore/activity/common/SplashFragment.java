package com.qianseit.westore.activity.common;

import java.util.ArrayList;
import org.json.JSONArray;
import org.json.JSONObject;
import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.ImageView;
import com.beiwangfx.R;
import com.qianseit.frame.widget.pagetabs.ViewPagerTabProvider;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.DoActivity;
import com.qianseit.westore.http.Json;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTaskHandler;
import com.qianseit.westore.ui.ImageCycleView;

public class SplashFragment extends BaseDoFragment {
	private final int[] splash_bgimages = { R.drawable.slide_1, R.drawable.slide_2, R.drawable.slide_3, R.drawable.slide_4
	};//, R
	// .drawable.transparent
	ImageCycleView<Integer> pager;
	public SplashFragment() {
		super();
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}

	@SuppressWarnings("deprecation")
	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		mActionBar.setShowTitleBar(false);
		mActionBar.setShowHomeView(false);

		rootView = inflater.inflate(R.layout.fragment_comm_splash, null);
		findViewById(R.id.splash_pages_next).setOnClickListener(this);

		ArrayList<Integer> nIntegers = new ArrayList<Integer>();
		for (int i = 0; i < splash_bgimages.length; i++) {
			nIntegers.add(splash_bgimages[i]);
		}
		pager = (ImageCycleView<Integer>) findViewById(R.id.splash_pages);
		pager.pushImageCycle();
		pager.setImageResources(nIntegers, new ImageCycleView.ImageCycleViewScrollListener<Integer>(){

			@Override
			public void displayImage(Integer t, ImageView imageView) {
				// TODO Auto-generated method stub
				imageView.setBackgroundResource(t);
			}

			@Override
			public void onImageClick(int position, View imageView) {
				// TODO Auto-generated method stub
//				if (position == splash_bgimages.length - 1) {
//					mActivity.startActivity(CommonMainActivity.GetMainTabActivity(mActivity));
//					Run.saveFlag(mActivity, Run.getVersionCode(mActivity));
//					mActivity.finish();
//				}
			}

			@Override
			public void onPageScrollStateChanged(int state) {
				// TODO Auto-generated method stub
				if (state == ViewPager.SCROLL_STATE_IDLE && pager.getCurrentItem() == splash_bgimages.length) {
					mActivity.startActivity(CommonMainActivity.GetMainTabActivity(mActivity));
					Run.saveFlag(mActivity, Run.getVersionCode(mActivity));
					mActivity.finish();
				}
			}
		});
	}

	/* 分页视图适配器 */
	private class FPAdapter extends FragmentPagerAdapter implements ViewPagerTabProvider {

		public FPAdapter(DoActivity activity) {
			super(activity.getSupportFragmentManager());
		}

		@Override
		public int getCount() {
			return splash_bgimages.length;
		}

		@Override
		public String getTitle(int position) {
			return Run.EMPTY_STR;
		}

		@Override
		public Fragment getItem(int position) {
			BaseDoFragment fragment;
			fragment = new SplashPageFragment();
			Bundle bundle = new Bundle();
			bundle.putInt(Run.EXTRA_VALUE, splash_bgimages[position]);
			fragment.setArguments(bundle);
			return fragment;
		}
	}

	@Override
	public void onClick(View v) {
		super.onClick(v);
		if (v.getId() == R.id.splash_pages_next && pager.getCurrentItem() == splash_bgimages.length - 1) {
			mActivity.startActivity(CommonMainActivity.GetMainTabActivity(mActivity));
			Run.saveFlag(mActivity, Run.getVersionCode(mActivity));
			mActivity.finish();
		}
	}

	@SuppressLint("ValidFragment")
	private class SplashPageFragment extends BaseDoFragment {
		public SplashPageFragment() {
			super();
		}

		@Override
		public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
			mActionBar.setShowTitleBar(false);
			mActionBar.setShowHomeView(false);

			rootView = new ImageView(mActivity);
			rootView.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
			try {
				rootView.setBackgroundResource(getArguments().getInt(Run.EXTRA_VALUE));
			} catch (Exception e) {
			}
		}
	}

	public static class UpdateJsonTask implements JsonTaskHandler {
		private Context mCtx;

		public UpdateJsonTask(Context context) {
			this.mCtx = context;
		}

		@Override
		public JsonRequestBean task_request() {
			return new com.qianseit.westore.http.JsonRequestBean(Run.API_URL, "");
		}

		@Override
		public void task_response(String json_str) {
			try {
				JSONObject all = new JSONObject(json_str);

				// applock版本更新
				JSONArray versions = Json.getJsonArray(all, "version");
				if (versions == null || versions.length() == 0)
					return;

				long myVerCode = Run.getVersionCode(mCtx);
				long newVerCode = all.optLong("version_code");
				if (newVerCode > myVerCode) {
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
			}
		}
	}

}
