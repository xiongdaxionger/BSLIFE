package com.qianseit.westore.activity.address;

import android.app.Activity;
import android.app.Dialog;
import android.content.ContentValues;
import android.content.Intent;
import android.os.Bundle;
import android.text.InputType;
import android.text.TextUtils;
import android.text.method.NumberKeyListener;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.beiwangfx.R;;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.member.MemberAddrDeleteInterface;
import com.qianseit.westore.httpinterface.member.MemberAddrSaveInterface;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONObject;

public class AccountAddressAddFragment extends BaseDoFragment {

    private EditText mNameEdt;
    private EditText mPhoneEdt;
    private EditText mTelEdt;
    private EditText mAddrDetailEdt;
    private EditText mAddrUserID;
    private TextView mAddrArea;

    private JSONObject mAddressInfo;

    private Dialog dialog;
    private String title;
    private CheckBox mCheckBox;

    private String mSelectMemberID;

    MemberAddrDeleteInterface mAddrDeleteInterface = new MemberAddrDeleteInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            Run.alert(mActivity, "删除收货地址成功");
            mActivity.setResult(Activity.RESULT_OK);
            mActivity.finish();
        }
    };
    MemberAddrSaveInterface mAddrSaveInterface = new MemberAddrSaveInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            Intent data = new Intent();
            data.putExtra(Run.EXTRA_DATA, responseJson.toString());
            mActivity.setResult(Activity.RESULT_OK, data);
            if (title != null) {
                Toast.makeText(mActivity, "保存成功", Toast.LENGTH_SHORT).show();
            } else {
                Toast.makeText(mActivity, "添加成功", Toast.LENGTH_SHORT).show();
            }
            mActivity.finish();
        }

        @Override
        public ContentValues BuildParams() {
            ContentValues nContentValues = new ContentValues();
            nContentValues.put("name", mNameEdt.getText().toString());
            if (mPhoneEdt.getText().length() > 0) {
                nContentValues.put("mobile", mPhoneEdt.getText().toString());
            }
            if (mTelEdt.getText().length() > 0) {
                nContentValues.put("tel", mTelEdt.getText().toString());
            }
            nContentValues.put("area", (String) mAddrArea.getTag());
            nContentValues.put("member_id",mSelectMemberID);
            nContentValues.put("addr", mAddrDetailEdt.getText().toString());
            if (mAddressInfo != null && !TextUtils.isEmpty(mAddressInfo.optString("addr_id")))
                nContentValues.put("addr_id", mAddressInfo.optString("addr_id"));
            nContentValues.put("def_addr", mCheckBox.isChecked() ? "1" : "0");
            return nContentValues;
        }
    };

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        try {
            Intent data = mActivity.getIntent();
            title = data.getStringExtra("com.qianseit.westore.EXTRA_FILE_NAME");
            mSelectMemberID = data.getStringExtra("member_id");
            if (title != null) {
                mActionBar.setTitle(title);
            } else {
                mActionBar.setTitle(R.string.my_address_book_editor);
            }
            mAddressInfo = new JSONObject(data.getStringExtra(Run.EXTRA_DATA));
            mActionBar.setShowRightButton(true);
            mActionBar.getRightButton().setText("删除");
            mActionBar.getRightButton().setOnClickListener(this);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.fragment_add_address_main, null);
        mNameEdt = (EditText) rootView.findViewById(R.id.fragment_add_reciver_address_name);
        mPhoneEdt = (EditText) rootView.findViewById(R.id.fragment_add_reciver_address_phone);
        mTelEdt = (EditText) rootView.findViewById(R.id.fragment_add_reciver_address_tel);
        mAddrDetailEdt = (EditText) rootView.findViewById(R.id.fragment_add_reciver_address_detail);
        mAddrUserID = (EditText) findViewById(R.id.fragment_add_reciver_address_id);
        mAddrArea = (TextView) findViewById(R.id.fragment_add_reciver_address_area);
        mCheckBox = (CheckBox) findViewById(R.id.address_raid);

        mAddrArea.setOnClickListener(this);
        findViewById(R.id.acco_save_address_text).setOnClickListener(this);
        mAddrUserID.setOnClickListener(this);

        // 身份证号
        mAddrUserID.setKeyListener(new NumberKeyListener() {
            protected char[] getAcceptedChars() {
                char[] numberChars = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'X', 'x'};
                return numberChars;
            }

            @Override
            public int getInputType() {
                return InputType.TYPE_CLASS_TEXT;
            }
        });

        setEditData();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == 100) {
                final String areaDisplayString = data.getStringExtra(Run.EXTRA_VALUE);
                final String areaValueString = data.getStringExtra(Run.EXTRA_DATA);
                mAddrArea.setText(areaDisplayString);
                mAddrArea.setTag(areaValueString);
            }
        }
    }

    @Override
    public void onClick(View v) {
        if (v == mActionBar.getRightButton()) {
            if (mAddressInfo != null) {
                dialog = CommonLoginFragment.showAlertDialog(mActivity, "确定删除此收货信息？", "取消", "确定", new OnClickListener() {

                    @Override
                    public void onClick(View v) {
                        dialog.dismiss();
                    }
                }, new OnClickListener() {

                    @Override
                    public void onClick(View v) {
                        String addrId = mAddressInfo.optString("addr_id");
                        mAddrDeleteInterface.delete(addrId,mSelectMemberID);

                    }
                }, false, null);
            }
        }
        if (v.getId() == R.id.acco_save_address_text) {
            if (TextUtils.isEmpty(mNameEdt.getText().toString())) {
                String label = mActivity.getString(R.string.my_address_book_editor_username);
                dialog = CommonLoginFragment.showAlertDialog(mActivity, label, "", "ok", new OnClickListener() {

                    @Override
                    public void onClick(View v) {
                        dialog.dismiss();
                    }
                }, null, false, null);
            } else if ((mPhoneEdt.getText().length() <= 0 || !Run.isChinesePhoneNumber(mPhoneEdt.getText().toString()))
                    && (mTelEdt.getText().length() <= 0 || !Run.isChineseTelNumber(mTelEdt.getText().toString()))) {

                mPhoneEdt.requestFocus();
                CommonLoginFragment.showAlertDialog(mActivity, "请填写正确的手机号!", "", "OK", null, null, false, null);

            } else if (TextUtils.isEmpty(mAddrArea.getText().toString().trim())) {
                dialog = CommonLoginFragment.showAlertDialog(mActivity, "请填写地区信息", "", "ok", new OnClickListener() {
                    public void onClick(View v) {
                        dialog.dismiss();
                    }
                }, null, false, null);
            } else if (TextUtils.isEmpty(mAddrDetailEdt.getText().toString())) {
                String label = mActivity.getString(R.string.my_address_book_editor_address);
                dialog = CommonLoginFragment.showAlertDialog(mActivity, label, "", "ok", new OnClickListener() {

                    @Override
                    public void onClick(View v) {
                        dialog.dismiss();
                    }
                }, null, false, null);
            } else if (TextUtils.isEmpty(mAddrDetailEdt.getText().toString())) {
                String label = mActivity.getString(R.string.my_address_book_editor_address);
                dialog = CommonLoginFragment.showAlertDialog(mActivity, label, "", "ok", new OnClickListener() {

                    @Override
                    public void onClick(View v) {
                        dialog.dismiss();
                    }
                }, null, false, null);
            }
            // else if (TextUtils.isEmpty(mAddrUserID.getText().toString())) {
            // dialog = CommonLoginFragment.showAlertDialog(mActivity,
            // "身份证不能为空", "", "ok", new OnClickListener() {
            //
            // @Override
            // public void onClick(View v) {
            // dialog.dismiss();
            // }
            // }, null, false, null);
            // }
            else {
                mAddrSaveInterface.getCreateAddress(mSelectMemberID);
            }

        }
        if (v.getId() == R.id.fragment_add_reciver_address_area) {
            startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ADDR_MY_ADDRESS_PICKER), 100);
        } else {
            super.onClick(v);
        }
    }

    /**
     * 修改收货地址，重新匹配地址
     */
    private void setEditData() {
        if (mAddressInfo != null) {
            mNameEdt.setText(mAddressInfo.optString("name"));
            mNameEdt.setSelection(mAddressInfo.optString("name").trim().length());
            mPhoneEdt.setText(StringUtils.getString(mAddressInfo, "mobile"));
            mTelEdt.setText(StringUtils.getString(mAddressInfo, "tel"));
            mAddrDetailEdt.setText(mAddressInfo.optString("addr"));
            mAddrUserID.setText(mAddressInfo.optString("card_num"));
            String tempArea = mAddressInfo.optString("area");
            boolean isDef = mAddressInfo.optInt("def_addr") == 1;
            if (isDef)
                mCheckBox.setChecked(true);
            mAddrArea.setTag(tempArea);
            mAddrArea.setText(StringUtils.FormatArea(tempArea));
        }
    }
}