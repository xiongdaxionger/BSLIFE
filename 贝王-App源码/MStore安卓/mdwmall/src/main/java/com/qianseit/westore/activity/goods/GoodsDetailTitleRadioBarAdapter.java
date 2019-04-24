package com.qianseit.westore.activity.goods;

import java.util.List;

import com.beiwangfx.R;
import com.qianseit.westore.base.adpter.BaseRadioBarAdapter.RadioBarCallback;
import com.qianseit.westore.base.adpter.BaseSelectAdapter;
import com.qianseit.westore.base.adpter.RadioBarBean;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.text.TextPaint;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class GoodsDetailTitleRadioBarAdapter extends BaseSelectAdapter<RadioBarBean> {
	Context mContext;
	int mVisibleCount = 5;
	int width;
	RadioBarCallback mBarCallback;
	private Drawable divideDrawable = null;

	public GoodsDetailTitleRadioBarAdapter(Context context, List<RadioBarBean> dataList, RadioBarCallback callback) {
		super(dataList);
		// TODO Auto-generated constructor stub
		mContext = context;
		mBarCallback = callback;
		width = mBarCallback.parentWindowsWidth();
	}

	@SuppressLint("NewApi")
	@Override
	public View getSelectView(int position, View convertView, ViewGroup parent, boolean isSelected) {
		// TODO Auto-generated method stub

		if (convertView == null) {
			convertView = View.inflate(mContext, R.layout.goods_detail_title_radio_bar_item, null);
			Drawable drawable = getDivideColor();
			if (drawable != null) {
				convertView.findViewById(R.id.view_divide).setBackground(drawable);
			}
		}
		convertView.setSelected(isSelected);
		final RadioBarBean item = this.getItem(position);
		TextView titleText = ((TextView) convertView.findViewById(R.id.textView1));
		titleText.setText(item.mTitleString);

		RelativeLayout barRelativeLayout = (RelativeLayout) convertView.findViewById(R.id.bar_item_rel);
		RelativeLayout.LayoutParams layoutParams = (android.widget.RelativeLayout.LayoutParams) barRelativeLayout.getLayoutParams();
		layoutParams.width = getRadioWidth();

		if (position > 0 && mBarCallback.showRadioBarsDivider()) {
			convertView.findViewById(R.id.view_divide).setVisibility(View.VISIBLE);
		} else {
			convertView.findViewById(R.id.view_divide).setVisibility(View.GONE);
		}

		convertView.setTag(position);
		return convertView;
	}

	// 计算出该TextView中文字的长度(像素)
	public static int getTextViewLength(TextView textView, String text) {
		TextPaint paint = textView.getPaint();
		// 得到使用该paint写上text的时候,像素为多少
		float textLength = paint.measureText(text);
		return (int) textLength;
	}

	public Drawable getDivideColor() {
		return divideDrawable;
	}

	/**
	 * 设置分栏线颜色
	 * 
	 * @param drawable
	 */
	public void setDivideColor(Drawable drawable) {
		this.divideDrawable = drawable;
	}

	/**
	 * @param visibleRadios
	 *            小于等于0时为根据内容自动适应
	 *            最大值是5
	 */
	public void setVisibleRadios(int visibleRadios) {
		mVisibleCount = visibleRadios > 5 ? 5 : visibleRadios;
	}

	int getRadioWidth() {
		if (mVisibleCount <= 0 || width <= 0) {
			return RelativeLayout.LayoutParams.WRAP_CONTENT;
		} else {
			if (mVisibleCount <= getCount()) {
				return width / mVisibleCount;
			} else if (getCount() > 0) {
				return width / getCount();
			} else {
				return RelativeLayout.LayoutParams.WRAP_CONTENT;
			}
		}
	}

	@Override
	public void onSelectedChanged(int selectedIndex) {
		// TODO Auto-generated method stub
		mBarCallback.onSelectedRadioBar(getItem(selectedIndex));
	}
}
