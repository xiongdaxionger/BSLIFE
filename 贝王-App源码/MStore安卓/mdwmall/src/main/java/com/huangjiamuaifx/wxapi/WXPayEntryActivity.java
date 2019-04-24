package com.huangjiamuaifx.wxapi;

import org.json.JSONObject;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.DoActivity;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;
import com.tencent.mm.sdk.constants.ConstantsAPI;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

public class WXPayEntryActivity extends DoActivity implements IWXAPIEventHandler {

	private IWXAPI api;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		View view = new View(this);
		view.setLayoutParams(new LayoutParams(-1, -1));
		setContentView(view);

		api = WXAPIFactory.createWXAPI(this, Constants.APP_ID);
		api.handleIntent(getIntent(), this);
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		setIntent(intent);
		api.handleIntent(intent, this);
	}

	@Override
	public void onReq(BaseReq req) {
		switch (req.getType()) {
		case ConstantsAPI.COMMAND_GETMESSAGE_FROM_WX:
			break;
		case ConstantsAPI.COMMAND_SHOWMESSAGE_FROM_WX:
			break;
		case ConstantsAPI.COMMAND_LAUNCH_BY_WX:
			break;
		default:
			break;
		}
	}

	@Override
	public void onResp(final BaseResp resp) {
		if (resp.errCode == 0) {
			String orderId = Run.loadOptionString(WXPayEntryActivity.this, "orderId", "");
			String sing = Run.loadOptionString(WXPayEntryActivity.this, "sign", "");
			Run.savePrefs(WXPayEntryActivity.this, "WXPayResult", true);
			Run.savePrefs(WXPayEntryActivity.this, "PayResult", true);
			if (!TextUtils.isEmpty(orderId) && !TextUtils.isEmpty(sing)) {
				Run.excuteJsonTask(new JsonTask(), new WXSuccessTask(orderId, sing));
			}
			this.finish();
		} else {
			Run.savePrefs(WXPayEntryActivity.this, "WXPayResult", true);
			Run.savePrefs(WXPayEntryActivity.this, "PayResult", false);
			this.finish();
		}

		// CustomDialog dialog = new CustomDialog(this);
		// if (resp.errCode == -1) {
		// dialog.setMessage("支付失败");
		// } else if (resp.errCode == 0) {
		// dialog.setMessage("支付成功");
		// } else {
		// dialog.setMessage("退出支付");
		// }
		// dialog.setNegativeButton(R.string.ok, new View.OnClickListener() {
		//
		// @Override
		// public void onClick(View view) {
		// if (resp.errCode == 0) {
		// Run.savePrefs(WXPayEntryActivity.this, "WXPayResult", true);
		// Run.savePrefs(WXPayEntryActivity.this, "PayResult", true);
		// } else {
		// Run.savePrefs(WXPayEntryActivity.this, "WXPayResult", false);
		// Run.savePrefs(WXPayEntryActivity.this, "PayResult", false);
		// }
		// }
		// });
		//
		// dialog.setOnDismissListener(new PopupWindow.OnDismissListener() {
		// @Override
		// public void onDismiss() {
		// finish();
		// }
		// });
		// dialog.setCancelable(true).show();
	}

	private class WXSuccessTask implements JsonTaskHandler {
		private String orderId;
		private String sing;

		public WXSuccessTask(String orderId, String sing) {
			this.orderId = orderId;
			this.sing = sing;
		}

		@Override
		public JsonRequestBean task_request() {
			showCancelableLoadingDialog();
			JsonRequestBean bean = new JsonRequestBean(Run.API_URL, "mobileapi.goods.weixin_pay");
			bean.addParams("orderid", orderId);
			bean.addParams("order_sign", sing);
			return bean;
		}

		@Override
		public void task_response(String json_str) {
			try {
				JSONObject all = new JSONObject(json_str);
				if (Run.checkRequestJson(WXPayEntryActivity.this, all)) {
					Run.alert(WXPayEntryActivity.this, "微信支付成功");
				}
			} catch (Exception e) {
			} finally {
				hideLoadingDialog_mt();
				WXPayEntryActivity.this.finish();
			}
		}
	}
}