package com.qianseit.westore.activity.acco;

import android.app.Dialog;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.beiwangfx.R;;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.base.BaseLocalListFragment;
import com.qianseit.westore.httpinterface.index.GetOnlineSeveiceInterface;

import java.util.ArrayList;
import java.util.List;

public class AccoServiceFragment extends BaseLocalListFragment<ModelBean> {
	final int MODEL_ONLINE_SERVICE=0X01;
	final int MODEL_FEEDBACK=0X02;
	final int MODEL_SERVICE_TEL=0X03;

	TextView mRemarkTextView;
	GetOnlineSeveiceInterface mGetOnlineSeveiceInterface;
	Dialog mDialog;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("客户服务");
	}

	@Override
	protected View getItemView(ModelBean modelBean, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_news, null);
			convertView.findViewById(R.id.left).setOnClickListener(mOnClickListener);
			convertView.findViewById(R.id.middle).setOnClickListener(mOnClickListener);
			convertView.findViewById(R.id.right).setOnClickListener(mOnClickListener);
			setViewHeight(convertView.findViewById(R.id.left), 360);
			setViewHeight(convertView.findViewById(R.id.middle), 360);
			setViewHeight(convertView.findViewById(R.id.right), 360);
		}

		int nPosition = mResultLists.indexOf(modelBean) * 3;
		convertView.findViewById(R.id.divider_top).setVisibility(nPosition == 0 ? View.VISIBLE : View.GONE);
		convertView.findViewById(R.id.divider_bottom).setVisibility(View.VISIBLE);

		assignment(mResultLists.get(nPosition), convertView.findViewById(R.id.left));
		assignment(nPosition + 1 < mResultLists.size() ? mResultLists.get(nPosition + 1) : null, convertView.findViewById(R.id.middle));
		assignment(nPosition + 2 < mResultLists.size() ? mResultLists.get(nPosition + 2) : null, convertView.findViewById(R.id.right));

		return convertView;
	}

	void assignment(ModelBean modelBean, View convertView) {
		if (modelBean == null) {
			((ImageView) convertView.findViewById(R.id.icon)).setImageBitmap(null);
			((TextView) convertView.findViewById(R.id.title)).setText("");
		} else {
			((ImageView) convertView.findViewById(R.id.icon)).setImageResource(modelBean.mIconRes);
			((TextView) convertView.findViewById(R.id.title)).setText(modelBean.mTitle);
		}
		convertView.setTag(modelBean.mType);
	}

	OnClickListener mOnClickListener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			Object nObject = v.getTag();
			if (nObject == null) {
				return;
			}

			switch ((Integer) nObject){
				case MODEL_ONLINE_SERVICE:
					if (mGetOnlineSeveiceInterface.mOnlineServiceType.equals(GetOnlineSeveiceInterface.QQ)) {
						String url = String.format("mqqwpa://im/chat?chat_type=wpa&uin=%s", mGetOnlineSeveiceInterface.mOnlineServiceValue);
						startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
					} else if (mGetOnlineSeveiceInterface.mOnlineServiceType.equals(GetOnlineSeveiceInterface.WECHAT)) {
						Run.alert(mActivity, "微信客服接口已关闭");
					} else if (mGetOnlineSeveiceInterface.mOnlineServiceType.equals(GetOnlineSeveiceInterface.THRID)) {
						startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(mGetOnlineSeveiceInterface.mOnlineServiceValue)));
					} else {
						Run.alert(mActivity, "客服数据有误");
					}
					break;
				case MODEL_FEEDBACK:
					startNeedloginActivity(AgentActivity.FRAGMENT_ACCO_FEEDBACK);
					break;
				case MODEL_SERVICE_TEL:
					mDialog = CommonLoginFragment.showAlertDialog(mActivity, String.format("%s", mGetOnlineSeveiceInterface.mServiceTel), "取消", "拨打", null, new OnClickListener() {

						@Override
						public void onClick(View v) {
							String nPhone = mGetOnlineSeveiceInterface.mServiceTel;
							if (nPhone.contains("-")) {
								nPhone = nPhone.replaceAll("-", "");
							}
							Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:" + nPhone));
							intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
							startActivity(intent);
							mDialog.hide();
						}
					}, false, null);
					break;
			}
		}
	};

	@Override
	public int getItemCount() {
		// TODO Auto-generated method stub
		return (int) Math.ceil(mResultLists.size() / 3.0);
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		onRefresh();
	}

	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		setEmptyText("");
		mGetOnlineSeveiceInterface =  new GetOnlineSeveiceInterface(this){

			@Override
			public void responseService(String type, String serviceValue) {
				mRemarkTextView.setText(mRemark);
			}
		};
		mGetOnlineSeveiceInterface.RunRequest();
	}

	@Override
	protected List<ModelBean> buildLocalItems() {
		List<ModelBean> nModelItems = new ArrayList<ModelBean>();
		nModelItems.add(new ModelBean(MODEL_ONLINE_SERVICE, "在线客服", R.drawable.home_online_service));
		nModelItems.add(new ModelBean(MODEL_FEEDBACK,"意见反馈", R.drawable.home_feedback));
		nModelItems.add(new ModelBean(MODEL_SERVICE_TEL, "客服电话", R.drawable.home_service_tel));
		return nModelItems;
	}

	@Override
	protected void addFooter(ListView listView) {
		View nFooterView =View.inflate(mActivity, R.layout.footer_acco_service, null);
		mRemarkTextView = (TextView) nFooterView.findViewById(R.id.remark);
		listView.addFooterView(nFooterView);
		listView.setDividerHeight(0);
	}
}
