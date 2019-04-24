package com.qianseit.westore.activity.wealth;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.activity.common.CommonLoginFragment.InputHandler;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;
import com.qianseit.westore.httpinterface.info.ConfirmRecCardInterface;

import org.json.JSONArray;
import org.json.JSONObject;

import java.math.BigDecimal;

public class WealthMyBankFragment extends BaseDoFragment {
	private final int PAYREQUES = 0x001;
	final int OTHER = 0;
	final int BINDING = 1;
	final int CHANGE_BINDING = 2;
	private int width;
	private Dialog dialog;
	private ImageView mIconImage;
	private Button mReceiveButton, mPayButton, mConfirmButtton, mMailButton, mChangButton;
	private TextView mMoneyTextView, mBankNumberTextView;
	private LinearLayout mReceiveLinear, mFormalLinear, mMailLinear;
	private TextView mHintTextView, mAddressTextView;
	private EditText mNameEditText, mPhoneEditText, mStreetEditText;
	private LoginedUser mLoginedUser;

	int mBindingBankType = OTHER;

	JSONObject mBankCardJsonObject;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		width = Run.getWindowsWidth(mActivity);
//		mActionBar.setTitle(R.string.menu_bank);
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);
		mActionBar.getRightLinear().getLayoutParams().width = Run.dip2px(mActivity, 60);

		mActionBar.getBackButton().setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				BankStatus();
			}
		});
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
	}

	// 返回键处理
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
			BankStatus();
			return true;
		}

		return super.onKeyDown(keyCode, event);
	}

	private void BankStatus() {
		if (mMailLinear.getVisibility() == View.VISIBLE) {
			mMailLinear.setVisibility(View.GONE);
			mFormalLinear.setVisibility(View.VISIBLE);
		} else {
			mActivity.finish();
		}
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		rootView = inflater.inflate(R.layout.fragment_bank_main, null);
		mIconImage = (ImageView) findViewById(R.id.bank_icon_image);
		RelativeLayout mIconRel = (RelativeLayout) findViewById(R.id.bank_icon_rel);
		mReceiveButton = (Button) findViewById(R.id.bank_receive_but);
		mBankNumberTextView = (TextView) findViewById(R.id.bank_number_tv);
		mMoneyTextView = (TextView) findViewById(R.id.bank_money_tv);
		mReceiveLinear = (LinearLayout) findViewById(R.id.bank_receive_linear);
		mHintTextView = (TextView) findViewById(R.id.bank_hint_tv);
		mPayButton = (Button) findViewById(R.id.bank_pay_but);
		mAddressTextView = (TextView) findViewById(R.id.mail_address_tv);
		mNameEditText = (EditText) findViewById(R.id.mail_name_et);
		mPhoneEditText = (EditText) findViewById(R.id.mail_phone_et);
		mStreetEditText = (EditText) findViewById(R.id.mail_street_et);
		mConfirmButtton = (Button) findViewById(R.id.mail_confirm_but);
		mChangButton = (Button) findViewById(R.id.bank_change_but);

		mFormalLinear = (LinearLayout) findViewById(R.id.bank_formal_linear);
		mMailLinear = (LinearLayout) findViewById(R.id.bank_mail_linear);
		mMailButton = (Button) findViewById(R.id.bank_mail_but);

		mReceiveButton.setOnClickListener(this);
		mPayButton.setOnClickListener(this);
		mConfirmButtton.setOnClickListener(this);
		mMailButton.setOnClickListener(this);
		mChangButton.setOnClickListener(this);
		findViewById(R.id.bank_binding_but).setOnClickListener(this);
		findViewById(R.id.bank_changebinding_but).setOnClickListener(this);
		findViewById(R.id.bank_confirm_rec).setOnClickListener(this);

		findViewById(R.id.mail_address_linear).setOnClickListener(this);

		LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) mIconRel.getLayoutParams();
		layoutParams.height = width * 563 / 1202;

//		JSONObject mCardJsonObject = mLoginedUser.getUserInfo().optJSONObject("card");
//		String nLvName = "白金会员";
//		if (mCardJsonObject != null && mCardJsonObject.optBoolean("can")) {
//			nLvName = mCardJsonObject.optString("lv_name");
//		}
//		mHintTextView.setText(Html.fromHtml("<font color='#ff0000'>*</font><font color='#666666'>备注：本卡仅会员等级达到</font><font color='#ff0000'>" + nLvName
//				+ "或以上</font><font color='#666666'>的会员才能申请邮寄</font>"));
//
//		BigDecimal b = new BigDecimal(mLoginedUser.getCardMoney());
//		b = b.setScale(2, BigDecimal.ROUND_DOWN);
//		mMoneyTextView.setText(b + "元");
//		String nums = mLoginedUser.getCardNums();
//		mBankNumberTextView.setText(TextUtils.isEmpty(nums) ? "88888888" : nums);
//		if (!mLoginedUser.isCard()) {
//			mReceiveLinear.setVisibility(View.VISIBLE);
//		} else {
//			mActionBar.setRightTitleButton("账单>", new OnClickListener() {
//
//				@Override
//				public void onClick(View v) {
//					startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_WEALTH_BILL).putExtra(Run.EXTRA_CLASS_ID, mLoginedUser.getCardNums()));
//				}
//			});
//			Run.excuteJsonTask(new JsonTask(), new BankInfoTask(mLoginedUser.getCardNums()));
//			mFormalLinear.setVisibility(View.VISIBLE);
//			if (!mLoginedUser.isMail()) {
//				mMailButton.setEnabled(false);
//			} else {
//				mMailButton.setEnabled(true);
//			}
//		}
	}

	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (resultCode != Activity.RESULT_OK) {
			return;
		}
		if (requestCode == PAYREQUES) {
//			Run.excuteJsonTask(new JsonTask(), new BankInfoTask(mLoginedUser.getBank_name()));
		} else if (requestCode == 100) {
			String result = data.getStringExtra(Run.EXTRA_DATA);
			mAddressTextView.setTag(result);
			result = result.replace("mainland:", "");
			result = result.replace("/", " ");
			result = result.replace("/", ":");
			mAddressTextView.setText(result);

			int lastIndexOf = result.lastIndexOf(":");
			if (lastIndexOf >= 0) {
				result = result.substring(0, lastIndexOf);
				mAddressTextView.setText(result);
			}
		}

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.bank_receive_but: // 领取卡
			mBindingBankType = OTHER;
			Run.excuteJsonTask(new JsonTask(), new ReceiveTask(""));
			break;
		case R.id.bank_pay_but:
			startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_WEALTH_RECHARGE), PAYREQUES);
			break;
		case R.id.mail_address_linear:
			startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ADDR_MY_ADDRESS_PICKER), 100);
			break;
		case R.id.bank_change_but:// 卡密码修改
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_PASSWORD_MANAGE_MODIFY_BUSINISS_PW));
			break;
		case R.id.bank_binding_but:// 绑定储值卡
			mBindingBankType = BINDING;
			CommonLoginFragment.showInputBankNumDialog(mActivity, "请输入您要绑定的卡号", new InputHandler() {

				@Override
				public void onOk(String inputString) {
					// TODO Auto-generated method stub
					Run.excuteJsonTask(new JsonTask(), new BankInfoTask(inputString));
				}

				@Override
				public boolean verify(String inputString) {
					// TODO Auto-generated method stub
					return true;
				}
			});
			break;
		case R.id.bank_changebinding_but:// 换绑
			mBindingBankType = CHANGE_BINDING;
			CommonLoginFragment.showInputBankNumDialog(mActivity, "请输入您要绑定的卡号", new InputHandler() {

				@Override
				public void onOk(String inputString) {
					// TODO Auto-generated method stub
					Run.excuteJsonTask(new JsonTask(), new BankInfoTask(inputString));
				}

				@Override
				public boolean verify(String inputString) {
					// TODO Auto-generated method stub
					if (TextUtils.isEmpty(inputString)) {
						return false;
					}

//					if (inputString.equals(mLoginedUser.getCardNums())) {
//						Run.alert(mActivity, "和当前卡号相同，无需换绑");
//						return false;
//					}
					return true;
				}
			});
			break;
		case R.id.mail_confirm_but:// 邮寄确认
			String name = mNameEditText.getText().toString().trim();
			String phone = mPhoneEditText.getText().toString().trim();
			String address = (String) mAddressTextView.getTag();
			String stree = mStreetEditText.getText().toString().trim();
			if (TextUtils.isEmpty(name) || TextUtils.isEmpty(phone) || !Run.isPhoneNumber(phone) || TextUtils.isEmpty(address) || TextUtils.isEmpty(stree)) {
				if (TextUtils.isEmpty(name)) {
					Run.alert(mActivity, "请输入收货人姓名");
					mNameEditText.requestFocus();
				} else if (TextUtils.isEmpty(phone) || !Run.isPhoneNumber(phone)) {
					Run.alert(mActivity, "请输入正确的手机号（11位）");
					mPhoneEditText.requestFocus();
				} else if (TextUtils.isEmpty(address)) {
					Run.alert(mActivity, "请选择所在地区");
				} else {
					Run.alert(mActivity, "请输入街道地址");
					mStreetEditText.requestFocus();
				}
			} else {
				Run.excuteJsonTask(new JsonTask(), new MailTask());
			}
			break;
		case R.id.bank_mail_but: // 申请邮寄
			// JSONObject mCardJsonObject =
			// mLoginedUser.getUserInfo().optJSONObject("card");
			// if (mCardJsonObject == null ||
			// !mCardJsonObject.optBoolean("can")) {
			// Run.alert(mActivity, "会员等级必须达到" + mCardJsonObject == null ?
			// "白金会员" : mCardJsonObject.optString("lv_name") + "才能申请邮寄");
			// return;
			// }
			if (mBankCardJsonObject.has("addr")) {
				JSONObject nJsonObject = mBankCardJsonObject.optJSONObject("addr");
				int nStatus = nJsonObject.optInt("status");
				if (nStatus == 1) {
					Run.alert(mActivity, "您的卡已经在路上了，请不要重复申请");
					return;
				}
			}

			mFormalLinear.setVisibility(View.GONE);
			mMailLinear.setVisibility(View.VISIBLE);
			break;
		case R.id.bank_confirm_rec:
			dialog = CommonLoginFragment.showAlertDialog(mActivity, "确定已经收到您的储值卡了吗？", null, "确定", null, new OnClickListener() {

				@Override
				public void onClick(View v) {
					dialog.dismiss();
					new ConfirmRecCardInterface(WealthMyBankFragment.this) {

						public void SuccCallBack(JSONObject responseJson) {
							findViewById(R.id.bank_confirm_rec).setVisibility(View.GONE);
							((TextView) findViewById(R.id.bank_card_status_tv)).setText("已收卡");
							mMailButton.setText("已收卡");
							mMailButton.setEnabled(false);
						}

					}.RunRequest();
				}
			}, false, null);
			break;
		default:
			break;
		}
	}

	protected void ShowReceivtask(String bankNum) {

		String nMsgString = "恭喜你储值卡领取成功！";
		if (mBindingBankType == BINDING) {
			nMsgString = "恭喜你储值卡绑定成功！";
			mBindingBankType = OTHER;
			Run.excuteJsonTask(new JsonTask(), new BankInfoTask(bankNum));
		} else if (mBindingBankType == CHANGE_BINDING) {
			mBindingBankType = OTHER;
			nMsgString = "恭喜你更换绑定储值卡成功！";
			Run.excuteJsonTask(new JsonTask(), new BankInfoTask(bankNum));
		}
		dialog = CommonLoginFragment.showAlertDialog(mActivity, nMsgString, null, "确定", null, new OnClickListener() {

			@Override
			public void onClick(View v) {
				dialog.dismiss();
				mReceiveLinear.setVisibility(View.GONE);
				mFormalLinear.setVisibility(View.VISIBLE);

			}
		}, false, null);
	}

	private class ReceiveTask implements JsonTaskHandler { // 领取卡
		String mBankNum = null;

		public ReceiveTask(String bankNum) {
			mBankNum = bankNum;
		}

		@Override
		public void task_response(String json_str) {
			hideLoadingDialog_mt();
			try {
				JSONObject all = new JSONObject(json_str);
				if (Run.checkRequestJson(mActivity, all)) {
					ShowReceivtask(mBankNum);
					JSONObject dataJSON = all.optJSONObject("data");
					if (dataJSON != null) {
//						mLoginedUser.setCardId(dataJSON.optString("card_id"));
//						mLoginedUser.setCardNums(dataJSON.optString("card_nums"));
						mBankNumberTextView.setText(dataJSON.optString("card_nums"));
						if (!TextUtils.isEmpty(mBankNum)) {
							updateCardInfo();
							return;
						}
//						Run.excuteJsonTask(new JsonTask(), new BankInfoTask(mLoginedUser.getCardNums()));
					}
				}
			} catch (Exception e) {

			}

		}

		@Override
		public JsonRequestBean task_request() {
			JsonRequestBean jrb = new JsonRequestBean(Run.API_URL, "erpshanhuyun.card.bind_card");
			if (!TextUtils.isEmpty(mBankNum)) {
				jrb.addParams("card_nums", mBankNum);
			} else {
				showCancelableLoadingDialog();
			}
			return jrb;
		}
	}

	private class BankInfoTask implements JsonTaskHandler { // 卡信息
		private String carNum;

		public BankInfoTask(String carNum) {
			this.carNum = carNum;
		}

		@Override
		public void task_response(String json_str) {
			hideLoadingDialog_mt();
			try {
				JSONObject all = new JSONObject(json_str);
				if (Run.checkRequestJson(mActivity, all)) {
					mBankCardJsonObject = all.optJSONObject("data");
					if (mBindingBankType != OTHER) {
						Run.excuteJsonTask(new JsonTask(), new ReceiveTask(carNum.split(",")[0]));
					} else {
						updateCardInfo();
					}
				}
			} catch (Exception e) {

			}
		}

		@Override
		public JsonRequestBean task_request() {
			JsonRequestBean jrb = new JsonRequestBean(Run.API_URL, "erpshanhuyun.card.cardInfo");
			if (mBindingBankType != OTHER) {
				showCancelableLoadingDialog();
				String[] nStrings = carNum.split(",");
				jrb.addParams("cardNo", nStrings[0]);
				jrb.addParams("cardPwd", nStrings[1]);
			} else {
				jrb.addParams("cardNo", carNum);
			}
			return jrb;
		}
	}

	void updateCardInfo() {
		if (mBankCardJsonObject != null) {
			JSONObject infoJSON = mBankCardJsonObject.optJSONObject("info");
			if (infoJSON != null) {
				JSONArray cardsArray = infoJSON.optJSONArray("cards");
				if (cardsArray != null && cardsArray.length() > 0) {
					JSONObject itemJSON = cardsArray.optJSONObject(0);
//					mLoginedUser.setCardMoney(itemJSON.optString("balance"));
					BigDecimal b = new BigDecimal(itemJSON.optString("balance"));
					b = b.setScale(2, BigDecimal.ROUND_DOWN);
					mMoneyTextView.setText(b + "元");
				}
			}
		}

		if (mBankCardJsonObject != null && mBankCardJsonObject.has("addr")) {
			findViewById(R.id.bank_card_courier_rel).setVisibility(View.GONE);
			JSONObject nJsonObject = mBankCardJsonObject.optJSONObject("addr");
			int nStatus = nJsonObject.optInt("status");
			if (nStatus == 2) {
				mMailButton.setText("已收卡");
				mMailButton.setEnabled(false);
			}

			findViewById(R.id.bank_confirm_rec).setVisibility(nStatus == 1 ? View.VISIBLE : View.GONE);

			String nStatusString = nStatus == 0 ? "已申请" : (nStatus == 1 ? "快递中" : "已收卡");
			findViewById(R.id.bank_card_express_linear).setVisibility(nStatus != 0 ? View.VISIBLE : View.INVISIBLE);
			findViewById(R.id.bank_card_courier_num_linear).setVisibility(nStatus != 0 ? View.VISIBLE : View.INVISIBLE);
			((TextView) findViewById(R.id.bank_card_status_tv)).setText(nStatusString);
			((TextView) findViewById(R.id.bank_card_express_tv)).setText(nStatus == 0 ? "" : nJsonObject.optString("crop_code"));
			((TextView) findViewById(R.id.bank_card_courier_num_tv)).setText(nStatus == 0 ? "" : nJsonObject.optString("crop_no"));
		} else {
			findViewById(R.id.bank_card_courier_rel).setVisibility(View.GONE);
		}
	}

	private class MailTask implements JsonTaskHandler { // 邮寄信息

		@Override
		public void task_response(String json_str) {
			hideLoadingDialog_mt();
			try {
				JSONObject all = new JSONObject(json_str);
				if (Run.checkRequestJson(mActivity, all)) {
					Run.alert(mActivity, "申请邮寄成功");
					mMailLinear.setVisibility(View.GONE);
					mFormalLinear.setVisibility(View.VISIBLE);
				}
			} catch (Exception e) {

			}
		}

		@Override
		public JsonRequestBean task_request() {
			showCancelableLoadingDialog();
			JsonRequestBean jrb = new JsonRequestBean(Run.API_URL, "erpshanhuyun.card.save_addr");
//			jrb.addParams("card_id", mLoginedUser.getCardId());
			jrb.addParams("name", mNameEditText.getText().toString().trim());
			jrb.addParams("mobile", mPhoneEditText.getText().toString().trim());
			jrb.addParams("area", mAddressTextView.getText().toString().trim());
			jrb.addParams("addr", mStreetEditText.getText().toString().trim());
			return jrb;
		}
	}
}
