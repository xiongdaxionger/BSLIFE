package com.qianseit.westore.activity.goods;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.ui.ImageCycleView;
import com.qianseit.westore.ui.ImageCycleView.ImageCycleViewListener;

public class GoodsImagesPreviewFragment extends BaseDoFragment {
	final String IAMGE_URL = "imageurl";

	ImageCycleView<String> mCycleView;
	ArrayList<String> mArrayList = new ArrayList<String>();
	int mDefaultIndex = 0;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setShowTitleBar(false);
		List<String> nStrings = getExtraStringListFromBundle(Run.EXTRA_DATA);
		String nDefaultString = getExtraStringFromBundle(Run.EXTRA_VALUE);
		int i = 0;
		for (String string : nStrings) {
			mArrayList.add(string);
			if (string.equals(nDefaultString)) {
				mDefaultIndex = i;
			}
			i++;
		}
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		rootView = inflater.inflate(R.layout.fragment_goods_images_preview, null);
		mCycleView = (ImageCycleView<String>) findViewById(R.id.goods_comment_images);
		mCycleView.setImageResources(mArrayList, new ImageCycleViewListener<String>() {

			@Override
			public void onImageClick(int position, View imageView) {
				// TODO Auto-generated method stub
				mActivity.finish();
			}

			@Override
			public void displayImage(String imageURL, ImageView imageView) {
				// TODO Auto-generated method stub
				imageView.setScaleType(ScaleType.FIT_CENTER);
				displayRectangleImage(imageView, imageURL);
			}
		});
		mCycleView.pushImageCycle();
		mCycleView.setCurrentItem(mDefaultIndex);
	}
}
