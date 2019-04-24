package com.qianseit.westore.activity.acco;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.beiwangfx.R;;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.ui.ShareView;
import com.qianseit.westore.ui.ShareView.ShareViewDataSource;
import com.qianseit.westore.ui.ShareViewPopupWindow;
import com.qianseit.westore.util.Util;

import java.util.ArrayList;
import java.util.List;

public class AccountNewCustomerFragment extends BaseDoFragment implements ShareViewDataSource {

    private NewCustomerAdapter mAdapter;
    private ShareViewPopupWindow mShareViewPopupWindow;
    private LoginedUser mLoginedUser;

    private String mShareUrl = "";
    private String mShareText = "";

    @Override
    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
//		mActionBar.setShowTitleBar(false);
        mActionBar.setTitle(R.string.add_member);
        rootView = inflater.inflate(R.layout.fragment_customer_new, null);
        mLoginedUser = AgentApplication.getLoginedUser(mActivity);
        mShareViewPopupWindow = new ShareViewPopupWindow(mActivity);
        mShareViewPopupWindow.setDataSource(this);

        ((ListView) findViewById(R.id.listView1)).setAdapter((mAdapter = new NewCustomerAdapter()));

        ((ListView) findViewById(R.id.listView1)).setOnItemClickListener(new OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> arg0, View arg1, int position, long arg3) {
                NewCustomerBean mBean = (NewCustomerBean) mAdapter.getItem(position);
                mShareText = (TextUtils.isEmpty(mLoginedUser.getName()) ? mLoginedUser.getUName() : mLoginedUser
                        .getName()) + "邀请您成为会员";
                mShareUrl = mLoginedUser.mMemberIndex.getReferrals_url();
                switch (mBean.id) {
                    case 0:        // 直接邀请

                        mShareViewPopupWindow.showAtLocation(rootView, android.view.Gravity.BOTTOM, 0, 0);
                        break;
                    case 1:        // 二维码邀请
//                        Intent intent = new Intent(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_TWODCODE));
//                        Bundle nBundle = new Bundle();
//                        nBundle.putString(Run.EXTRA_VALUE, mShareUrl);
//                        nBundle.putString(Run.EXTRA_TITLE, mShareText);
//                        intent.putExtras(nBundle);
//                        mActivity.startActivity(intent);
                        startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_TWO_CODE));
                        break;
                    case 2:        // 添加会员
                        startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_ADD_VIP));
                        break;

                }
            }
        });
    }

    private class NewCustomerAdapter extends BaseAdapter {

        private ViewHolder mHolder;
        private List<NewCustomerBean> mBeans = new ArrayList<AccountNewCustomerFragment.NewCustomerBean>();

        public NewCustomerAdapter() {
            mBeans.add(new NewCustomerBean(0, R.drawable.invite, "直接邀请", "分享到微信/QQ等渠道,好友点击注册并下载登录即可成为会员。"));
            mBeans.add(new NewCustomerBean(1, R.drawable.qrcode_invite, "二维码邀请", "分享到微信等渠道," +
                    "好友扫一扫或长按识别二维码后注册并下载登录即可成为会员。"));
            mBeans.add(new NewCustomerBean(2, R.drawable.add_member, "添加会员", "会员提供资料,代会员注册即可成为会员。"));
        }

        @Override
        public int getCount() {
            return mBeans.size();
        }

        @Override
        public Object getItem(int position) {
            return mBeans.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {

            if (convertView == null) {
                mHolder = new ViewHolder();
                convertView = View.inflate(mActivity, R.layout.item_new_customer, null);
                mHolder.mIcon = (ImageView) convertView.findViewById(R.id.imageView1);
                mHolder.mTitle = (TextView) convertView.findViewById(R.id.textView1);
                mHolder.mContent = (TextView) convertView.findViewById(R.id.textView2);
                convertView.setTag(mHolder);
            } else {
                mHolder = (ViewHolder) convertView.getTag();
            }

            NewCustomerBean mBean = mBeans.get(position);
            mHolder.mIcon.setImageResource(mBean.resId);
            mHolder.mTitle.setText(mBean.title);
            mHolder.mContent.setText(mBean.content);

//			if(position == 2) {
//				mHolder.mTitle.setTextColor(getResources().getColor(R.color.red));
//			}else {
            mHolder.mTitle.setTextColor(getResources().getColor(R.color.black));
//			}

            return convertView;
        }

        private class ViewHolder {
            public ImageView mIcon;
            public TextView mTitle;
            public TextView mContent;
        }
    }

    private class NewCustomerBean {

        public int id;
        public int resId;
        public String title;
        public String content;

        public NewCustomerBean(int id, int resId, String title, String content) {
            super();
            this.id = id;
            this.resId = resId;
            this.title = title;
            this.content = content;
        }
    }

    @Override
    public String getShareText() {

        return getString(R.string.app_name);
    }

    @Override
    public String getShareImageFile() {

//        Bitmap bitmap = BitmapFactory.decodeResource(mActivity
//                .getResources(), R.drawable.comm_icon_launcher);
//        Util.saveBitmap("share_iamge", bitmap);
//        return Util.getPath() + "/share_iamge";
        return null;
    }

    @Override
    public String getShareImageUrl() {
        Bitmap bitmap = BitmapFactory.decodeResource(mActivity
                .getResources(), R.drawable.comm_icon_launcher);
        Util.saveBitmap("share_iamge", bitmap);
        return Util.getPath() + "/share_iamge";


//        return mLoginedUser.getAvatarUri();
    }

    @Override
    public String getShareUrl() {

        return mShareUrl;
    }

    @Override
    public String getShareMessage() {
        // TODO Auto-generated method stub
        return mShareText;
    }
}
