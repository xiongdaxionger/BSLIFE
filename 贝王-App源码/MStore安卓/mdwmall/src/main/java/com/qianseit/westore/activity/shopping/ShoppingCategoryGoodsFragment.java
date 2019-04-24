package com.qianseit.westore.activity.shopping;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseExpandListFragment;
import com.beiwangfx.R;

public class ShoppingCategoryGoodsFragment extends BaseExpandListFragment<JSONObject, ShoppCategoryDetail> {

	Map<Integer, List<JSONObject>> mThirdCategory = new HashMap<Integer, List<JSONObject>>();

	@Override
	protected List<ExpandListItemBean<JSONObject, ShoppCategoryDetail>> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		return parseCategoryLevels(responseJson.optJSONObject("data").optJSONArray("datas"));
	}

	@Override
	protected View getGroupItemView(final ExpandListItemBean<JSONObject, ShoppCategoryDetail> groupBean, final boolean isExpanded, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.header_shopp_category, null);
			setViewHeight(convertView.findViewById(R.id.header_fewer_icon), 435);
			final View fewerView=convertView.findViewById(R.id.header_fewer);
            final View spreadView=convertView.findViewById(R.id.header_spread);
			
			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					Integer nIndex = (Integer) v.getTag();
					if (mListView.isGroupExpanded(nIndex)){
						mListView.collapseGroup(nIndex);
						fewerView.setVisibility(View.VISIBLE);
						spreadView.setVisibility(View.GONE);
						return;
					}

					for (int i = 0; i < mAdatpter.getGroupCount(); i++) {
						if (mListView.isGroupExpanded(i))
							mListView.collapseGroup(i);
					}
					mListView.expandGroup(nIndex);
					mAdatpter.notifyDataSetChanged();
				}
			});
		}
		convertView.setTag(mResultLists.indexOf(groupBean));
		if (isExpanded) {
			convertView.findViewById(R.id.header_fewer).setVisibility(View.GONE);
			convertView.findViewById(R.id.header_spread).setVisibility(View.VISIBLE);
		} else {
			convertView.findViewById(R.id.header_fewer).setVisibility(View.VISIBLE);
			convertView.findViewById(R.id.header_spread).setVisibility(View.GONE);
			displayRectangleImage((ImageView) convertView.findViewById(R.id.header_fewer_icon), groupBean.mGrupItem.optString("picture"));
		}

		((TextView) convertView.findViewById(R.id.header_spread_title)).setText(groupBean.mGrupItem.optString("cat_name"));
		((TextView) convertView.findViewById(R.id.header_fewer_title)).setText(groupBean.mGrupItem.optString("cat_name"));
		((TextView) convertView.findViewById(R.id.header_fewer_desc)).setText(groupBean.mGrupItem.optString("type_name"));
		return convertView;
	}

	@Override
	protected View getDetailItemView(ExpandListItemBean<JSONObject, ShoppCategoryDetail> groupBean, ShoppCategoryDetail detailBean, boolean isLastChild, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_shopp_category, null);
			convertView.findViewById(R.id.title1).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					onClickDetail((JSONObject) v.getTag());
				}
			});
			convertView.findViewById(R.id.title2).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					onClickDetail((JSONObject) v.getTag());
				}
			});
		}

		convertView.findViewById(R.id.title1).setTag(detailBean.leftJsonObject);
		convertView.findViewById(R.id.title2).setTag(detailBean.rightJsonObject);
		((TextView) convertView.findViewById(R.id.title1)).setText(detailBean.leftJsonObject != null ? detailBean.leftJsonObject.optString("cat_name") : "");
		((TextView) convertView.findViewById(R.id.title2)).setText(detailBean.rightJsonObject != null ? detailBean.rightJsonObject.optString("cat_name") : "");

		return convertView;
	}

	void onClickDetail(JSONObject categoryJsonObject) {
		if (categoryJsonObject != null) {
			String cat_id = categoryJsonObject.optString("cat_id");
			String title = categoryJsonObject.optString("cat_name");

			mActivity.startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_GOODS_LIST)
					.putExtra(Run.EXTRA_DATA, listJsonToString(mThirdCategory.get(categoryJsonObject.optInt("cat_id")))).putExtra(Run.EXTRA_CLASS_ID, cat_id).putExtra(Run.EXTRA_TITLE, title));
		}
	}

	String listJsonToString(List<JSONObject> jsonObjects) {
		if (jsonObjects == null || jsonObjects.size() <= 0) {
			return "[]";
		}

		JSONArray nArray = new JSONArray();
		for (JSONObject jsonObject : jsonObjects) {
			nArray.put(jsonObject);
		}

		return nArray.toString();
	}

	@Override
	protected int defualtExpandType() {
		// TODO Auto-generated method stub
		return ExpandType.FIRST;
	}

	@Override
	protected void initActionBar() {
		// TODO Auto-generated method stub
		mActionBar.setShowTitleBar(false);
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.goods.get_cat";
	}

	@Override
	protected void initTop(LinearLayout topLayout) {
		// TODO Auto-generated method stub
		disablePage();
		mListView.setDividerHeight(0);

		ItemSearchView nItemSearchView = new ItemSearchView(mActivity);
		nItemSearchView.setSearchCallback(new SearchCallback() {

			@Override
			public void search(String searchKey) {
				// TODO Auto-generated method stub
				mActivity.startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_GOODS_LIST).putExtra(Run.EXTRA_KEYWORDS, searchKey)
						.putExtra(Run.EXTRA_TITLE, searchKey));
			}
		});
		topLayout.addView(nItemSearchView);
	}

	/**
	 * 解析
	 * 
	 * @param all
	 */
	private List<ExpandListItemBean<JSONObject, ShoppCategoryDetail>> parseCategoryLevels(JSONArray all) {
		List<ExpandListItemBean<JSONObject, ShoppCategoryDetail>> nBeans = new ArrayList<BaseExpandListFragment.ExpandListItemBean<JSONObject, ShoppCategoryDetail>>();
		// 分拆顶级和二级分类
		if (all != null && all.length() > 0) {
			mThirdCategory.clear();
			for (int i = 0, c = all.length(); i < c; i++) {
				JSONObject child = all.optJSONObject(i);
				int pid = child.optInt("pid");
				if (pid == 0) {
					ExpandListItemBean<JSONObject, ShoppCategoryDetail> nBean = new ExpandListItemBean<JSONObject, ShoppCategoryDetail>();
					nBean.mGrupItem = child;
					nBeans.add(nBean);
				} else {
					if (!mThirdCategory.containsKey(pid)) {
						mThirdCategory.put(pid, new ArrayList<JSONObject>());
					}
					mThirdCategory.get(pid).add(child);
				}
			}

			for (ExpandListItemBean<JSONObject, ShoppCategoryDetail> nBean : nBeans) {
				int nPid = nBean.mGrupItem.optInt("cat_id");
				if (mThirdCategory.containsKey(nPid)) {
					List<JSONObject> nJsonObjects = mThirdCategory.remove(nBean.mGrupItem.optInt("cat_id"));
					for (JSONObject jsonObject : nJsonObjects) {
						if (nBean.mDetailLists.size() > 0 && nBean.mDetailLists.get(nBean.mDetailLists.size() - 1).rightJsonObject == null) {
							nBean.mDetailLists.get(nBean.mDetailLists.size() - 1).rightJsonObject = jsonObject;
						} else {
							ShoppCategoryDetail nCategoryDetail = new ShoppCategoryDetail();
							nCategoryDetail.leftJsonObject = jsonObject;
							nBean.mDetailLists.add(nCategoryDetail);
						}
					}
				}
			}
		}

		return nBeans;
	}
}
