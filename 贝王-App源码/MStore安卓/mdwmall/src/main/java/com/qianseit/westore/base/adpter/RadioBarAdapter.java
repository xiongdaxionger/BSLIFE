package com.qianseit.westore.base.adpter;

import java.util.ArrayList;
import java.util.List;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.text.TextPaint;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.qianseit.westore.Run;
import com.qianseit.westore.base.bean.RadioBarBean;
import com.beiwangfx.R;

public class RadioBarAdapter extends BaseAdapter implements OnClickListener {
	Context mContext;
	List<RadioBarBean> mRadioLists;
	int mRadioWidth;
	int width;
	RadioBarCallback mBarCallback;
	private Drawable divideDrawable=null;

	public RadioBarAdapter(Context context, List<RadioBarBean> barBeans, RadioBarCallback callback) {
		mContext = context;
		mRadioLists = barBeans;
		mBarCallback = callback;
		if (mRadioLists == null) {
			mRadioLists = new ArrayList<RadioBarBean>();
		}
		width = Run.getWindowsWidth((Activity) mContext);
		mRadioWidth = width / 5;
		setVisibleRadios(mRadioLists.size());
		selectedDefaultRadio();
	}

	@Override
	public int getCount() {
		return mRadioLists.size();
	}

	@Override
	public RadioBarBean getItem(int position) {
		return mRadioLists.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@SuppressLint({ "ResourceAsColor", "NewApi" })
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {

		if (convertView == null) {
			convertView = View.inflate(mContext, R.layout.base_item_radio_bar, null);
			convertView.setOnClickListener(this);
			Drawable drawable=getDivideColor();
			if(drawable!=null){
				convertView.findViewById(R.id.view_divide).setBackground(drawable);
			}
		}
		final RadioBarBean item = this.getItem(position);
		if (mBarCallback.highlightSelectedRadioBar()) {
			convertView.findViewById(R.id.textView1).setSelected(item.mSelected);
			convertView.findViewById(R.id.view_color).setSelected(item.mSelected);
		} else {
			convertView.findViewById(R.id.textView1).setSelected(false);
			convertView.findViewById(R.id.view_color).setSelected(false);
		}
		TextView titleText = ((TextView) convertView.findViewById(R.id.textView1));
		titleText.setText(item.mTitleString);
//		int displayWidth = getTextViewLength(titleText, item.mTitleString) + Run.dip2px(mContext, 10);
		RelativeLayout barRelativeLayout = (RelativeLayout) convertView.findViewById(R.id.bar_item_rel);
		RelativeLayout.LayoutParams layoutParams = (android.widget.RelativeLayout.LayoutParams) barRelativeLayout.getLayoutParams();
		layoutParams.width = mRadioWidth;
//		if (displayWidth < mRadioWidth) {
//			layoutParams.width = mRadioWidth;
//		} else {
//			layoutParams.width = displayWidth;
//		}

		if (position > 0 && mBarCallback.showRadioBarsDivider()) {
			convertView.findViewById(R.id.view_divide).setSelected(true);
		} else {
			convertView.findViewById(R.id.view_divide).setSelected(false);
		}

		if (item.mSelected) {
			mBarCallback.onSelectedRadioBarChanged(item);
			if (item.mFilternContentValuess != null && item.mFilternContentValuess.size() > 0) {
				if (item.mFilterDrawable != null && item.mFilterDrawable.size() > 0) {
					if (item.mCurFilterItemIndex < item.mFilterDrawable.size()) {
						((TextView) convertView.findViewById(R.id.textView1)).setCompoundDrawablePadding(5);
						((TextView) convertView.findViewById(R.id.textView1)).setCompoundDrawablesWithIntrinsicBounds(null, null, item.mFilterDrawable.get(item.mCurFilterItemIndex), null);
					} else {
						((TextView) convertView.findViewById(R.id.textView1)).setCompoundDrawablePadding(5);
						((TextView) convertView.findViewById(R.id.textView1)).setCompoundDrawablesWithIntrinsicBounds(null, null,
								item.mFilterDrawable.get(item.mCurFilterItemIndex % item.mFilterDrawable.size()), null);
					}
				}
			}
		} else {
			item.mCurFilterItemIndex = 0;
			if (item.mFilternContentValuess != null && item.mFilternContentValuess.size() > 0) {
				if (item.mFilterDrawable != null && item.mFilterDrawable.size() > 0) {
					((TextView) convertView.findViewById(R.id.textView1)).setCompoundDrawablePadding(5);
					((TextView) convertView.findViewById(R.id.textView1)).setCompoundDrawablesWithIntrinsicBounds(null, null,
							item.mFilterDrawable.get(item.mCurFilterItemIndex % item.mFilterDrawable.size()), null);
				}
			}
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
    
	public Drawable getDivideColor(){  
		return divideDrawable;
	}
	/**
	 * 设置分栏线颜色
	 * @param drawable
	 */
	public void setDivideColor(Drawable drawable){
		this.divideDrawable=drawable;
	}
	/**
	 * @param visibleRadios
	 *            小于等于0时为根据内容自动适应
	 */
	public void setVisibleRadios(int visibleRadios) {
		if (visibleRadios <= 0) {
			mRadioWidth = RelativeLayout.LayoutParams.WRAP_CONTENT;
			return;
		} else {
			if (visibleRadios <= 5)
				mRadioWidth = width / visibleRadios;
		}
	}

	public void selectedRadio(int index) {
		if (mRadioLists == null || mRadioLists.size() <= index) {
			return;
		}

		RadioBarBean nRadioBean = mRadioLists.get(index);
		if (nRadioBean.mSelected) {
			if (nRadioBean.mFilternContentValuess != null && nRadioBean.mFilternContentValuess.size() > 0) {
				if (nRadioBean.mCurFilterItemIndex < nRadioBean.mFilternContentValuess.size()) {
					nRadioBean.mCurFilterItemIndex++;
				} else {
					nRadioBean.mCurFilterItemIndex = 0;
				}
			}
		} else {
			for (RadioBarBean radioBean : mRadioLists) {
				if (radioBean.mSelected) {
					radioBean.mSelected = false;
				}
			}

			nRadioBean.mSelected = true;
		}

		notifyDataSetChanged();
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		selectedRadio((Integer) v.getTag());
	}

	void selectedDefaultRadio() {
		if (mRadioLists == null || mRadioLists.size() <= 0) {
			return;
		}

		boolean nHasDefaultSelectedRadio = false;
		for (RadioBarBean item : mRadioLists) {
			item.mSelected = item.mId == mBarCallback.defualtSelectRadioBarId();
			if (!nHasDefaultSelectedRadio) {
				nHasDefaultSelectedRadio = item.mSelected;
			}
		}

		if (!nHasDefaultSelectedRadio && mRadioLists.size() > 0) {
			mRadioLists.get(0).mSelected = true;
		}
	}

	public int getSelectedType() {
		RadioBarBean nBarBean = getSelectedRadioBean();
		if (nBarBean == null) {
			return -1;
		}

		return getSelectedRadioBean().mId;
	}

	public RadioBarBean getSelectedRadioBean() {
		if (mRadioLists.size() <= 0) {
			return null;
		}
		RadioBarBean nBarBean = mRadioLists.get(0);
		for (RadioBarBean radioBean : mRadioLists) {
			if (radioBean.mSelected) {
				return radioBean;
			}
		}
		return nBarBean;
	}

}
