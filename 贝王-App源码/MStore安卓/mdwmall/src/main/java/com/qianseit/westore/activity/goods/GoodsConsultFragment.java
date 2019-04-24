package com.qianseit.westore.activity.goods;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.util.LongSparseArray;
import android.view.View;
import android.view.View.OnClickListener;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseRadioBarFragment;
import com.qianseit.westore.base.adpter.RadioBarBean;
import com.qianseit.westore.httpinterface.goods.GoodsConsultInterface;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class GoodsConsultFragment extends BaseRadioBarFragment {
	final int REQUEST_PUBLISH = 0x01;
	String mGoodsId;
	List<RadioBarBean> mBarBeans = new ArrayList<RadioBarBean>();
	LongSparseArray<BaseDoFragment> mFragmentArray = new LongSparseArray<BaseDoFragment>();

	JSONObject mSettingJsonObject;
	JSONObject mPageInfoJsonObject;
	JSONArray mConsultTypeArray;

	boolean mCanPublish = false;

	GoodsConsultInterface mConsultInterface = new GoodsConsultInterface(this) {
		@Override
		public void responseSetting(JSONObject settingJsonObject) {
			// TODO Auto-generated method stub
			mSettingJsonObject = settingJsonObject;
			mCanPublish = mSettingJsonObject.optBoolean("power_status");
			mActionBar.getRightImageButton().setVisibility(mCanPublish ? View.VISIBLE : View.GONE);
		}

		@Override
		public void responsePageInfo(JSONObject pageInfoJsonObject) {
			// TODO Auto-generated method stub
			mPageInfoJsonObject = pageInfoJsonObject;
		}

		@Override
		public void responseAskType(JSONArray askTypeArray) {
			// TODO Auto-generated method stub
			if (askTypeArray == null || askTypeArray.length() <= 0) {
				return;
			}

			mConsultTypeArray = askTypeArray;

			mBarBeans.clear();
			for (int i = 0; i < askTypeArray.length(); i++) {
				JSONObject nJsonObject = askTypeArray.optJSONObject(i);
				RadioBarBean nBarBean = new RadioBarBean(String.format("%s(%s)", nJsonObject.optString("name"), nJsonObject.optString("total")), nJsonObject.optLong("type_id"));
				mBarBeans.add(nBarBean);

				if (mFragmentArray.get(nBarBean.mId) == null) {
					GoodsConsultRecordFragment nGoodsConsultRecordFragment = new GoodsConsultRecordFragment();
					Bundle nBundle = new Bundle();
					nBundle.putString(Run.EXTRA_GOODS_ID, mGoodsId);
					nBundle.putLong(Run.EXTRA_DETAIL_TYPE, nBarBean.mId);
					nBundle.putString(Run.EXTRA_DATA, mSettingJsonObject.toString());
					nGoodsConsultRecordFragment.setArguments(nBundle);
					mFragmentArray.put(nBarBean.mId, nGoodsConsultRecordFragment);
				}
			}

			reloadRadio();
		}

		@Override
		public void responseAsk(JSONArray askArray) {
			// TODO Auto-generated method stub

		}
	};
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mGoodsId = getExtraStringFromBundle(Run.EXTRA_GOODS_ID);
		mActionBar.setTitle("购买咨询");
		mActionBar.setRightImageButton(R.drawable.publish, new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Bundle nBundle = new Bundle();
				nBundle.putString(Run.EXTRA_DATA, mSettingJsonObject.toString());
				nBundle.putString(Run.EXTRA_DETAIL_TYPE, mConsultTypeArray != null ? mConsultTypeArray.toString() : new JSONArray().toString());
				nBundle.putString(Run.EXTRA_GOODS_ID, mGoodsId);
				startActivityForResult(AgentActivity.FRAGMENT_SHOPP_GOODS_CONSULT_PUBLISH, nBundle, REQUEST_PUBLISH);
			}
		});
	}

	@Override
	protected List<RadioBarBean> initRadioBar() {
		// TODO Auto-generated method stub
		return mBarBeans;
	}

	@Override
	protected void init() {
		// TODO Auto-generated method stub
		mConsultInterface.loadFirstPage(mGoodsId);
	}
	
	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
	}

	@Override
	public boolean showRadioBarsDivider() {
		// TODO Auto-generated method stub
		return false;
	}
	
	@Override
	protected int visibleCount() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	protected BaseDoFragment getRadioBarFragemnt(long radioBarId) {
		// TODO Auto-generated method stub
		return mFragmentArray.get(radioBarId);
	}
	
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		if (resultCode == Activity.RESULT_OK) {
			mConsultInterface.loadFirstPage(mGoodsId);
		}
		super.onActivityResult(requestCode, resultCode, data);
	}
}
