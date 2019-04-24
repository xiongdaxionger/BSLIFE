package com.qianseit.westore.activity.statistics;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.RadioGroup.OnCheckedChangeListener;
import android.widget.TextView;

import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.listener.OnChartValueSelectedListener;
import com.beiwangfx.R;
import com.qianseit.westore.httpinterface.statistics.IncomeInterface;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * 统计
 * 
 * @author Administrator
 * 
 */
public class StatisticsChartIncomeActivity extends BaseStatisticsChartFragment implements OnChartValueSelectedListener, OnClickListener, OnCheckedChangeListener {

	private TextView mCommissionCountTextView;
	private TextView mCommissionTotalTextView;
//	private TextView mOrderCountTextView;
//	private TextView mOrderTotalTextView;
	private TextView mTimeTextView;
	private TextView mCommissionTip,mConnmissBottom;
//	private TextView mOrderTip,mOrderBottom;

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.init(inflater, container, savedInstanceState);

		mCommissionCountTextView = (TextView) findViewById(R.id.commission_count);
		mCommissionTotalTextView = (TextView) findViewById(R.id.commission_total);
//		mOrderCountTextView = (TextView) findViewById(R.id.order_count);
//		mOrderTotalTextView = (TextView) findViewById(R.id.order_total);
		mTimeTextView = (TextView) findViewById(R.id.time);
		
		mCommissionTip = (TextView) findViewById(R.id.commission_count_tip);
//		mOrderTip = (TextView) findViewById(R.id.order_count_tip);
		mConnmissBottom = (TextView) findViewById(R.id.commission_total_tip);
//		mOrderBottom = (TextView) findViewById(R.id.order_total_tip);
		
		
	}

	@Override
	protected int layoutFragmentRes() {
		// TODO Auto-generated method stub
		return R.layout.fragment_statistics_chart_income;
	}

	@Override
	void showSelectedItemInfo(int selectedIndex) {
		// TODO Auto-generated method stub

		JSONObject nJsonObject = mCurArray.optJSONObject(0).optJSONArray("list").optJSONObject(selectedIndex);
		mCommissionCountTextView.setText(nJsonObject.optString("data"));
//		nJsonObject = mCurArray.optJSONObject().optJSONArray("list").optJSONObject(selectedIndex);
//		mOrderCountTextView.setText(nJsonObject.optString("data"));
		mTimeTextView.setText(nJsonObject.optString("date") + " " + nJsonObject.optString("day"));
	}

	@Override
	protected void showTotal(JSONObject jsonObject) {
		// TODO Auto-generated method stub
		if (jsonObject == null || !jsonObject.has("label")) {
			return;
		}
		
		String nLabelString = jsonObject.optString("label");
		if (nLabelString.equals("佣金收入")) {
			mCommissionTotalTextView.setText(jsonObject.optString("sum"));
		}else{
//			mOrderTotalTextView.setText(jsonObject.optString("sum"));
		}
	}

	@Override
	protected ArrayList<LineDataSet> buildDataSets(JSONArray array) {
		// TODO Auto-generated method stub
		ArrayList<LineDataSet> dataSets = new ArrayList<LineDataSet>();
		if (array == null) {
			return dataSets;
		}
		
		dataSets.add(buildLineData(getYValues(array.optJSONObject(0).optJSONArray("list")), R.color.chart_color1));
//		dataSets.add(buildLineData(getYValues(array.optJSONObject(1).optJSONArray("list")), R.color.chart_color2));
		showTotal(array.optJSONObject(0));
//		showTotal(array.optJSONObject(1));
		String str1=array.optJSONObject(0).optString("label");
//		String str2=array.optJSONObject(1).optString("label");
		mCommissionTip.setText(str1);
//		mOrderTip.setText(str2);
//		mCommissionTip.setText(str1);
//		mOrderBottom.setText(str2);
		return dataSets;
	}

	@Override
	protected void initData() {
		// TODO Auto-generated method stub
		new IncomeInterface(this) {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				if (responseJson != null) {
					JSONArray nArray = responseJson.optJSONArray("data");
					parseStatisticsData(nArray);
				}
			}
		}.RunRequest();
	}
}
