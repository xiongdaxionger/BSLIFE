package com.qianseit.westore.activity.wealth;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import com.beiwangfx.R;
import com.qianseit.westore.base.BaseDoFragment;

public class WealthRechargeCardFragment extends BaseDoFragment {

	EditText mCardNumberEditText;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setShowTitleBar(false);
	}
	
	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		rootView = inflater.inflate(R.layout.fragment_wealth_recharge_card, null);
		mCardNumberEditText = (EditText) findViewById(R.id.card_number);

		findViewById(R.id.recharge).setOnClickListener(this);
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		mCardNumberEditText.requestFocus();
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.recharge:

			break;

		default:
			super.onClick(v);
			break;
		}
	}
}
