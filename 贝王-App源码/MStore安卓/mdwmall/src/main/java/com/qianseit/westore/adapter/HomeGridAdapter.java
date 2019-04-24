package com.qianseit.westore.adapter;

import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.qianseit.westore.base.GridItem;
import com.beiwangfx.R;

public class HomeGridAdapter extends BaseAdapter {
	private List<GridItem> gridData;
	private LayoutInflater inflater;

	public HomeGridAdapter(Context context, List<GridItem> gridData) {
		this.gridData = gridData;
		inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
	}

	public int getCount() {
		return gridData.size();
	}

	@Override
	public GridItem getItem(int position) {
		return gridData.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder viewHolder;
		if (convertView == null) {
			viewHolder = new ViewHolder();
			convertView = inflater.inflate(R.layout.item_comm_home_grid, null);
			viewHolder.mImageView = (ImageView) convertView.findViewById(R.id.gridview_icon);
			viewHolder.mTextView = (TextView) convertView.findViewById(R.id.gridview_title);
			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}
		GridItem gridItem = getItem(position);
		viewHolder.mImageView.setImageResource(gridItem.icon);
		viewHolder.mTextView.setText(gridItem.title);
		return convertView;
	}

	private class ViewHolder {
		private ImageView mImageView;
		private TextView mTextView;

	}
}
