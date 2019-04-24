package com.qianseit.westore.activity.statistics;

import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RadioGroup.OnCheckedChangeListener;
import android.widget.TextView;

import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.listener.OnChartValueSelectedListener;
import com.beiwangfx.R;
import com.qianseit.westore.httpinterface.statistics.VisitorInterface;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * 统计
 * 
 * @author Administrator
 * 
 */
public class StatisticsChartVisitorActivity extends BaseStatisticsChartFragment implements OnChartValueSelectedListener, OnClickListener, OnCheckedChangeListener {



	private TextView mTimeTextView;
	private LayoutInflater mInflater;
	private LinearLayout mTopLinearLayout,mBottomLinearLayout;

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.init(inflater, container, savedInstanceState);
		mTimeTextView = (TextView) findViewById(R.id.time);
		mTopLinearLayout=(LinearLayout)findViewById(R.id.browse_top_linear);
		mBottomLinearLayout=(LinearLayout)findViewById(R.id.browse_bottom_linear);
		
	}

	@Override
	protected int layoutFragmentRes() {
		// TODO Auto-generated method stub
		return R.layout.fragment_statistics_chart_visitor;
	}

	@Override
	void showSelectedItemInfo(int selectedIndex) {
		// TODO Auto-generated method stub

		JSONObject nJsonObject = mCurArray.optJSONObject(0).optJSONArray("list").optJSONObject(selectedIndex);
		//nJsonObject = mCurArray.optJSONObject(1).optJSONArray("list").optJSONObject(selectedIndex);
		mTimeTextView.setText(nJsonObject.optString("date") + " " + nJsonObject.optString("day"));
	}

	@Override
	protected void showTotal(JSONObject jsonObject) {
		// TODO Auto-generated method stub
		if (jsonObject == null || !jsonObject.has("label")) {
			return;
		}
		
		String nLabelString = jsonObject.optString("label");
//		if (nLabelString.equals("浏览")) {
//			mBrowseTotalTextView.setText(jsonObject.optString("sum"));
//		}else{
//			mVisitorTotalTextView.setText(jsonObject.optString("sum"));
//		}
	}

	@Override
	protected ArrayList<LineDataSet> buildDataSets(JSONArray array) {
		// TODO Auto-generated method stub
		ArrayList<LineDataSet> dataSets = new ArrayList<LineDataSet>();
		if (array == null&&!(dataSets.size()>0)) {
			return dataSets;
		}
		for(int i=0;i<array.length();i++){
			switch (i) {
			case 0:
				dataSets.add(buildLineData(getYValues(array.optJSONObject(i).optJSONArray("list")), R.color.chart_color1));
				break;
			case 1:
				dataSets.add(buildLineData(getYValues(array.optJSONObject(i).optJSONArray("list")), R.color.chart_color2));
				break;
			default:
				dataSets.add(buildLineData(getYValues(array.optJSONObject(i).optJSONArray("list")), R.color.chart_color2));
				break;
			}
			showTotal(array.optJSONObject(i));	
		}
		mBottomLinearLayout.removeAllViews();
		mTopLinearLayout.removeAllViews();
		for(int i=0;i<array.length();i++){
			 JSONObject nJsonObject = array.optJSONObject(i);
			 if(nJsonObject!=null&&nJsonObject.has("label")){
				 String nKeyString = nJsonObject.optString("label");
				 String nValue=nJsonObject.optString("sum");
				 mInflater=mActivity.getLayoutInflater();
				 TextView mTipText=(TextView)mInflater.inflate(R.layout.item_statistics_chart_text, null);
				 mTipText.setText(nKeyString+"  "+nValue+"      ");
				 mTopLinearLayout.addView(mTipText);
				 //下方数据
				 View bonttomView=mInflater.inflate(R.layout.item_statistics_chart_linear, null);
				TextView mVisitorText=(TextView)bonttomView.findViewById(R.id.visitor_total);
				TextView mVisitorTipText=(TextView)bonttomView.findViewById(R.id.visitor_total_tip);
				mVisitorText.setText(nValue);
				mVisitorTipText.setText(nKeyString);
				switch (i) {
				case 0:

					Drawable drawable= getResources().getDrawable(R.drawable.chart_mark1);  
					/// 这一步必须要做,否则不会显示.  
					drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());  
					mVisitorTipText.setCompoundDrawables(drawable,null,null,null);
					break;
               case 1:
               	Drawable drawable1= getResources().getDrawable(R.drawable.chart_mark2);  
					/// 这一步必须要做,否则不会显示.  
					drawable1.setBounds(0, 0, drawable1.getMinimumWidth(), drawable1.getMinimumHeight());  
					mVisitorTipText.setCompoundDrawables(drawable1,null,null,null);
					break;
				default:
					Drawable drawable2= getResources().getDrawable(R.drawable.chart_mark2);  
					/// 这一步必须要做,否则不会显示.  
					drawable2.setBounds(0, 0, drawable2.getMinimumWidth(), drawable2.getMinimumHeight());  
					mVisitorTipText.setCompoundDrawables(drawable2,null,null,null);
					break;
				}
				bonttomView.setLayoutParams(new LinearLayout.LayoutParams(
						LinearLayout.LayoutParams.MATCH_PARENT,
						LinearLayout.LayoutParams.MATCH_PARENT, 1));
				mBottomLinearLayout.addView(bonttomView);
			 }
		 }
		return dataSets;
	}

	@Override
	protected void initData() {
		// TODO Auto-generated method stub
		new VisitorInterface(this) {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				JSONObject nDataJsonObject = responseJson.optJSONObject("data");
				if (nDataJsonObject != null) {
					JSONArray nArray = nDataJsonObject.optJSONArray("data");
					if(nArray!=null&&nArray.length()>0){
					 parseStatisticsData(nArray);
					}
				}
			}
		}.RunRequest();
	}
}

