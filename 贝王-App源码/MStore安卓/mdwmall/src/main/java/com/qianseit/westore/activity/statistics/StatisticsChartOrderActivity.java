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
import com.qianseit.westore.httpinterface.statistics.OrderInterface;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * 统计
 * 
 * @author Administrator
 * 
 */
public class StatisticsChartOrderActivity extends BaseStatisticsChartFragment implements OnChartValueSelectedListener, OnClickListener, OnCheckedChangeListener {

	private TextView mDxCountTextView;
	private TextView mDxTotalTextView;
	private TextView mZyCountTextView;
	private TextView mZyTotalTextView;
	private TextView mTimeTextView;
	private TextView mDxTipText,mZyTipText,mDxBottonText,mXyBottonText;

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.init(inflater, container, savedInstanceState);

		mDxCountTextView = (TextView) findViewById(R.id.dx_count);
		mDxTotalTextView = (TextView) findViewById(R.id.dx_total);
		mZyCountTextView = (TextView) findViewById(R.id.zy_count);
		mZyTotalTextView = (TextView) findViewById(R.id.zy_total);
		mTimeTextView = (TextView) findViewById(R.id.time);
		
		mDxTipText = (TextView) findViewById(R.id.dx_count_tip);
		mZyTipText = (TextView) findViewById(R.id.zy_count_tip);
		mDxBottonText = (TextView) findViewById(R.id.dx_total_tip);
		mXyBottonText = (TextView) findViewById(R.id.zy_total_tip);
	}

	@Override
	protected int layoutFragmentRes() {
		// TODO Auto-generated method stub
		return R.layout.fragment_statistics_chart_order;
	}

	@Override
	void showSelectedItemInfo(int selectedIndex) {
		// TODO Auto-generated method stub

		JSONObject nJsonObject = mCurArray.optJSONObject(0).optJSONArray("list").optJSONObject(selectedIndex);
		mDxCountTextView.setText(nJsonObject.optString("data"));
		nJsonObject = mCurArray.optJSONObject(1).optJSONArray("list").optJSONObject(selectedIndex);
		mZyCountTextView.setText(nJsonObject.optString("data"));
		mTimeTextView.setText(nJsonObject.optString("date") + " " + nJsonObject.optString("day"));
	}

	@Override
	protected void showTotal(JSONObject jsonObject) {
		// TODO Auto-generated method stub
		if (jsonObject == null || !jsonObject.has("label")) {
			return;
		}
		
		String nLabelString = jsonObject.optString("label");
		if (nLabelString.equals("代销订单")) {
			mDxTotalTextView.setText(jsonObject.optString("sum"));
		}else{
			mZyTotalTextView.setText(jsonObject.optString("sum"));
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
		dataSets.add(buildLineData(getYValues(array.optJSONObject(1).optJSONArray("list")), R.color.chart_color2));
		showTotal(array.optJSONObject(0));
		showTotal(array.optJSONObject(1));
		String str1=array.optJSONObject(0).optString("label");
		String str2=array.optJSONObject(1).optString("label");
		mDxTipText.setText(str1);
		mZyTipText.setText(str2);
		mDxBottonText.setText(str1);
		mXyBottonText.setText(str2);
		
		return dataSets;
	}

	@Override
	protected void initData() {
		// TODO Auto-generated method stub
		new OrderInterface(this) {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				JSONObject nDataJsonObject = responseJson.optJSONObject("data");
				if (nDataJsonObject != null) {
					JSONArray nArray = nDataJsonObject.optJSONArray("data");
					parseStatisticsData(nArray);
				}
			}
		}.RunRequest();
	}
}

