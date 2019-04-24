package com.qianseit.westore.activity.statistics;

import android.graphics.Color;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RadioGroup;
import android.widget.RadioGroup.OnCheckedChangeListener;

import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.components.XAxis.XAxisPosition;
import com.github.mikephil.charting.components.YAxis;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.highlight.Highlight;
import com.github.mikephil.charting.listener.OnChartValueSelectedListener;
import com.beiwangfx.R;
import com.qianseit.westore.base.BaseDoFragment;
import com.xxmassdeveloper.mpchartexample.custom.MyMarkerView;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public abstract class BaseStatisticsChartFragment extends BaseDoFragment implements OnCheckedChangeListener, OnChartValueSelectedListener {
	protected String[] mMonths = new String[] { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dec" };

	protected String[] mParties = new String[] { "Party A", "Party B", "Party C", "Party D", "Party E", "Party F", "Party G", "Party H", "Party I", "Party J", "Party K", "Party L", "Party M",
			"Party N", "Party O", "Party P", "Party Q", "Party R", "Party S", "Party T", "Party U", "Party V", "Party W", "Party X", "Party Y", "Party Z" };

	private LinearLayout mTopTipLayout;
	private LineChart mChart;
	private RadioGroup mDateTypeGroup;

	private Map<String, JSONArray> mDataMap;
	protected JSONArray mCurArray;

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.init(inflater, container, savedInstanceState);
		rootView = inflater.inflate(layoutFragmentRes(), null);
		mActionBar.setShowTitleBar(false);

		mTopTipLayout = (LinearLayout) findViewById(R.id.top_tip);
		mDateTypeGroup = (RadioGroup) findViewById(R.id.rg_date_sort);
		mDateTypeGroup.setOnCheckedChangeListener(this);

		mChart = (LineChart) findViewById(R.id.chart1);
		mTopTipLayout.setVisibility(View.GONE);
		initChart();
		initData();
	}

	abstract protected int layoutFragmentRes();

	void initChart() {
		mDateTypeGroup = (RadioGroup) findViewById(R.id.rg_date_sort);

		mDateTypeGroup.setOnCheckedChangeListener(this);

		mChart.setOnChartValueSelectedListener(this);// 图表描述
		mChart.setDescription("");
		mChart.setNoDataTextDescription("You need to provide data for the chart.");
		// 是否高亮度显示
		mChart.setHighlightEnabled(true);
		// 是否可触摸
		mChart.setTouchEnabled(true);

		XAxis xAxis = mChart.getXAxis();
		xAxis.setTextColor(Color.GRAY);
		xAxis.setDrawGridLines(true);
		xAxis.setGridColor(Color.WHITE);
		xAxis.setDrawAxisLine(false);
		xAxis.setPosition(XAxisPosition.BOTTOM);
		xAxis.setTextSize(12);
		xAxis.setSpaceBetweenLabels(3);
		xAxis.setAvoidFirstLastClipping(true);

		YAxis leftAxis = mChart.getAxisLeft();
		leftAxis.setTextColor(Color.BLACK);
		// leftAxis.setAxisMaxValue(142f);
		leftAxis.setAxisMinValue(0f);
		leftAxis.setStartAtZero(false);
		leftAxis.setDrawAxisLine(false);
		leftAxis.setDrawGridLines(false);
		leftAxis.setDrawLabels(false);

		YAxis rightAxis = mChart.getAxisRight();
		rightAxis.setTextColor(Color.TRANSPARENT);
		// rightAxis.setAxisMaxValue(200f);
		rightAxis.setDrawAxisLine(false);
		rightAxis.setDrawGridLines(false);

		mChart.setDragEnabled(true);
		mChart.setScaleEnabled(true);
		mChart.setPinchZoom(true);
		mChart.setDrawGridBackground(false);

		// 是否显示左下角的点
		mChart.getLegend().setEnabled(false);
		// 点击显示图标
		MyMarkerView mv = new MyMarkerView(mActivity, R.layout.custom_marker_view);
		mChart.setMarkerView(mv);
		// 曲线上的点是否可点击
		mChart.setHighlightEnabled(false);
	}

	abstract protected void initData();

	void parseStatisticsData(JSONArray array) {
		mDataMap = new HashMap<String, JSONArray>();

		if (array != null) {
			for (int i = 0; i < array.length(); i++) {
				JSONObject nJsonObject = array.optJSONObject(i);
				if (nJsonObject.has("label") && nJsonObject.has("list")) {
					String nKeyString = nJsonObject.optString("label");
					if (TextUtils.isEmpty(nKeyString)) {
						continue;
					}
					mDataMap.put(nKeyString, nJsonObject.optJSONArray("list"));
				}
			}
		}

		if (mDataMap.size() > 0 && array != null && array.length() > 0) {
			for (int i = 0; i < array.length(); i++) {
				if (i > 0)
					return;
				JSONObject nJsonObject = array.optJSONObject(i);
				if (nJsonObject.has("label")) {
					mCurArray = mDataMap.get(nJsonObject.optString("label"));
					mChart.setData(getLineData(mCurArray)); // 设置数据
					mChart.invalidate();
				}
			}
		}
	}

	@Override
	public void onCheckedChanged(RadioGroup group, int checkedId) {
		switch (checkedId) {
		case R.id.rb_week:
			mCurArray = mDataMap.get("本周");
			break;
		case R.id.rb_month:
			mCurArray = mDataMap.get("本月");
			break;
		case R.id.rb_year:
			mCurArray = mDataMap.get("本年");
			break;
		}

		mChart.setData(getLineData(mCurArray)); // 设置数据
		mChart.invalidate();
	}

	LineData getLineData(JSONArray array) {
		if (array == null || array.length() <= 0) {
			return null;
		}

		ArrayList<String> xValues = getXValues(array.optJSONObject(0).optJSONArray("list"));

		ArrayList<LineDataSet> dataSets = buildDataSets(array);
		dataSets.add(buildZeroLineData(xValues.size()));
		LineData lineData = new LineData(xValues, dataSets);
		return lineData;
	}

	protected abstract ArrayList<LineDataSet> buildDataSets(JSONArray array);

	ArrayList<String> getXValues(JSONArray array) {
		if (array == null) {
			return null;
		}

		ArrayList<String> xValues = new ArrayList<String>();
		for (int i = 0; i < array.length(); i++) {
			// x轴显示的数据，这里默认使用数字下标显示
			JSONObject nJsonObject = array.optJSONObject(i);
			xValues.add(nJsonObject.optString("day"));
		}

		return xValues;
	}

	abstract protected void showTotal(JSONObject jsonObject);

	ArrayList<Entry> getYValues(JSONArray array) {
		if (array == null) {
			return null;
		}

		ArrayList<Entry> yValues = new ArrayList<Entry>();
		for (int i = 0; i < array.length(); i++) {
			// x轴显示的数据，这里默认使用数字下标显示
			JSONObject nJsonObject = array.optJSONObject(i);
			yValues.add(new Entry((float) nJsonObject.optDouble("data"), i));
		}

		return yValues;
	}

	ArrayList<Entry> getZeroYValues(int count) {
		ArrayList<Entry> yValues = new ArrayList<Entry>();
		for (int i = 0; i < count; i++) {
			// x轴显示的数据，这里默认使用数字下标显示
			yValues.add(new Entry(0, i));
		}

		return yValues;
	}

	protected LineDataSet buildLineData(ArrayList<Entry> yVals, int colorRes) {
		int nColor = getResources().getColor(colorRes);

		LineDataSet set1 = new LineDataSet(yVals, "DataSet 1");

		// 设置折线为虚线
		// set1.enableDashedLine(10f, 5f, 0f);

		// 设置曲线
		set1.setDrawCubic(false);
		set1.setDrawCircles(true);
		set1.setCubicIntensity(0.05f);
		set1.setLineWidth(3f);
		set1.setCircleSize(4f);

		// 设置圆点颜色以及实心圆
		set1.setCircleColor(nColor);
		set1.setCircleColorHole(nColor);

		// 设置点的字体大小
		set1.setValueTextSize(13f);
		// 设置折线颜色
		set1.setColor(nColor);
		// set1.setDrawHorizontalHighlightIndicator(false);
		// 隐藏十字线
		set1.setHighLightColor(Color.TRANSPARENT);
		set1.setDrawValues(false);
		return set1;
	}

	protected LineDataSet buildZeroLineData(int count) {

		LineDataSet set1 = new LineDataSet(getZeroYValues(count), "DataSet 1");

		// 设置折线为虚线
		// set1.enableDashedLine(10f, 5f, 0f);

		// 设置曲线
		set1.setDrawCubic(false);
		set1.setDrawCircles(true);
		set1.setCubicIntensity(0.05f);
		set1.setLineWidth(0f);
		set1.setCircleSize(0f);

		// 设置圆点颜色以及实心圆
		set1.setCircleColor(Color.TRANSPARENT);
		set1.setCircleColorHole(Color.TRANSPARENT);

		// 设置点的字体大小
		set1.setValueTextSize(0f);
		// 设置折线颜色
		set1.setColor(Color.TRANSPARENT);
		// set1.setDrawHorizontalHighlightIndicator(false);
		// 隐藏十字线
		set1.setHighLightColor(Color.TRANSPARENT);
		set1.setDrawValues(false);
		return set1;
	}

	@Override
	public void onValueSelected(Entry e, int dataSetIndex, Highlight h) {
		mTopTipLayout.setVisibility(View.VISIBLE);
		mDateTypeGroup.setVisibility(View.INVISIBLE);
		showSelectedItemInfo(e.getXIndex());
	}

	abstract void showSelectedItemInfo(int selectedIndex);

	@Override
	public void onNothingSelected() {
		mTopTipLayout.setVisibility(View.GONE);
		mDateTypeGroup.setVisibility(View.VISIBLE);
	}
}
