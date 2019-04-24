package com.qianseit.westore.activity.wealth;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;

import com.amap.api.maps.model.Text;
import com.beiwangfx.R;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseDoFragment;

public class WealthCollectionFragment extends BaseDoFragment {
	private EditText mMoneyEditText, mNameText;
	private TextView mhintText;
	private CheckBox mCheckBox;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("收钱");
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		super.init(inflater, container, savedInstanceState);
		rootView = inflater.inflate(R.layout.collection_main, null);
		mMoneyEditText = (EditText) findViewById(R.id.collection_money);
		mNameText = (EditText) findViewById(R.id.collction_money_tit);
		mCheckBox = (CheckBox) findViewById(R.id.collection_raid);
		mhintText = (TextView) findViewById(R.id.collection_hint);

		String name = TextUtils.isEmpty(LoginedUser.getInstance().getName()) ? LoginedUser.getInstance().getUName() :
				LoginedUser.getInstance().getName();
		mNameText.setText(name + "直接收款");
		findViewById(R.id.collection_next).setOnClickListener(this);
		mhintText.setText(getString(R.string.collection_hint, getResources().getString(R.string.app_name)));
		mMoneyEditText.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				if (mMoneyEditText.getText().toString().indexOf(".") > 0) {
					if (mMoneyEditText.getText().toString().indexOf(".", mMoneyEditText.getText().toString().indexOf(".") + 1) > 0) {
						mMoneyEditText.setText(mMoneyEditText.getText().toString().substring(0, mMoneyEditText.getText().toString().length() - 1));
						mMoneyEditText.setSelection(mMoneyEditText.getText().toString().length());
					}
				} else {
					if (mMoneyEditText.getText().toString().indexOf(".") == 0) {
						mMoneyEditText.setText("");
					}
				}

			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
				// TODO Auto-generated method stub

			}

			@Override
			public void afterTextChanged(Editable s) {
				// TODO Auto-generated method stub

			}
		});

	}

	@Override
	public void onClick(View v) {
		super.onClick(v);
		switch (v.getId()) {
		case R.id.collection_next:
			String money = mMoneyEditText.getText().toString();
			if (TextUtils.isEmpty(money)) {
				Run.alert(mActivity, "输入金额不能为空");
				mMoneyEditText.setFocusable(true);
			} else if (TextUtils.isEmpty(mNameText.getText().toString())){
				Run.alert(mActivity, "收款名称不能为空");
				mNameText.setFocusable(true);
			}else {
				startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_WEAL_COLLECTION_NEXT)
						.putExtra(Run.EXTRA_DATA, money)
						.putExtra(Run.EXTRA_CLASS_ID, mCheckBox.isChecked()).putExtra(WealthCollectionNextFragment
								.COLLECT_DESC_KEY, mNameText.getText().toString()));
			}
			break;
		default:
			break;
		}
	}

}
