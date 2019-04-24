package com.qianseit.westore.activity.address;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.qianseit.westore.Run;
import com.qianseit.westore.SimpleTextWatcher;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.index.AreaInterface;
import com.beiwangfx.R;;

public class MyAddresPickerFragment extends BaseDoFragment implements OnItemClickListener {
	private ListView mListView;
	private EditText mKeywodsText;
	private RegionAdapter mAdapter;

	JSONObject mAearJsonObject, mAearTreeJsonObject;
	String mCurParentID = "0";
	List<String> mCurAearList = new ArrayList<String>();
	List<String> mPathChoosedList = new ArrayList<String>();

	public MyAddresPickerFragment() {
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		mActionBar.setTitle(R.string.province);
		rootView = inflater.inflate(R.layout.fragment_myaddress_picker, null);

		mListView = (ListView) findViewById(android.R.id.list);
		mKeywodsText = (EditText) findViewById(android.R.id.text1);
		mKeywodsText.addTextChangedListener(new SimpleTextWatcher() {
			@Override
			public void afterTextChanged(Editable s) {
			}
		});
		mListView.setOnItemClickListener(this);
		mAdapter = new RegionAdapter(mCurAearList);
		mListView.setAdapter(mAdapter);

		mActionBar.getBackButton().setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				if (!goBackLastLavel()) {
					getActivity().finish();
				}
			}
		});

		// 获取地区列表
		new AreaInterface(this) {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				mAearJsonObject = responseJson.optJSONObject("info");
				mAearTreeJsonObject = responseJson.optJSONObject("tree");
				mCurParentID = "0";
				mPathChoosedList.clear();
				mPathChoosedList.add(mCurParentID);
				loadCurList();
			}
		}.RunRequest();
	}

	void loadCurList() {
		JSONArray nArray = mAearTreeJsonObject.optJSONArray(String.valueOf(mCurParentID));

		if (nArray != null && nArray.length() > 0) {
			mCurAearList.clear();
			for (int i = 0; i < nArray.length(); i++) {
				mCurAearList.add(nArray.optString(i));
			}
			mAdapter.notifyDataSetChanged();
		}
	}

	@Override
	public void onItemClick(AdapterView<?> p, View v, int pos, long id) {
		RegionAdapter adapter = (RegionAdapter) mListView.getAdapter();
		JSONObject mChooosedAearJsonObject = mAearJsonObject.optJSONObject(String.valueOf(adapter.getItem(pos)));
		String mAearId = mChooosedAearJsonObject.optString("region_id");
		if (mAearTreeJsonObject.has(mAearId)) {
			mCurParentID = mAearId;
			mPathChoosedList.add(mCurParentID);
			loadCurList();
		} else {
			String textArea = "", area = "mainland:";
			StringBuilder nAreaBuilder = new StringBuilder();
			nAreaBuilder.append("mainland:");
			for (int i = 1, c = mPathChoosedList.size(); i < c; i++) {
				String nAreaName = mAearJsonObject.optJSONObject(mPathChoosedList.get(i)).optString("local_name");
				textArea += nAreaName + " ";
				nAreaBuilder.append(nAreaName).append("/");
			}
			textArea += mChooosedAearJsonObject.optString("local_name");
			nAreaBuilder.append(mChooosedAearJsonObject.optString("local_name")).append(":").append(mChooosedAearJsonObject.optString("region_id"));
			area = nAreaBuilder.toString();
			nAreaBuilder.delete(0, nAreaBuilder.length());
			Intent data = new Intent();

			data.putExtra(Run.EXTRA_VALUE, textArea);
			data.putExtra(Run.EXTRA_DATA, area);
			data.putExtra(Run.EXTRA_ADDR, mKeywodsText.getText().toString());
			mActivity.setResult(Activity.RESULT_OK, data);
			mActivity.finish();
		}

		mKeywodsText.setText("");
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			if (goBackLastLavel()) {
				return true;
			}
		}
		return super.onKeyDown(keyCode, event);
	}

	private boolean goBackLastLavel() {
		JSONObject mCurParentJsonObject = mAearJsonObject.optJSONObject(String.valueOf(mCurParentID));
		if (mCurParentJsonObject != null && mCurParentJsonObject.length() >= 2) {
			mPathChoosedList.remove(mPathChoosedList.size() - 1);
			mCurParentID = mPathChoosedList.get(mPathChoosedList.size() - 1);
			loadCurList();
			mKeywodsText.setText("");
			return true;
		}
		return false;
	}

	private class RegionAdapter extends BaseAdapter {
		private List<String> mList;

		public RegionAdapter(List<String> array) {
			this.mList = array;
		}

		@Override
		public int getCount() {
			return mList.size();
		}

		@Override
		public String getItem(int position) {
			return mList.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			if (convertView == null) {
				convertView = mActivity.getLayoutInflater().inflate(R.layout.simple_list_item1, null);
				((TextView) convertView.findViewById(R.id.text1)).setTextSize(18);
			}

			String mAearId = getItem(position);
			JSONObject nItemJSONObject = mAearJsonObject.optJSONObject(mAearId);
			((TextView) convertView.findViewById(R.id.text1)).setText(nItemJSONObject.optString("local_name"));
			return convertView;
		}
	}
}
