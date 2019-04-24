package com.qianseit.westore.activity.acco;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Bundle;
import android.text.Html;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout.LayoutParams;
import android.widget.TextView;

import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;
import com.beiwangfx.R;;

public class AccoJoinFragment extends BaseDoFragment {
	private EditText mPhoneEditText,mNameEditText,mAddressEditText;
	private TextView mJoninPhoneText;
	private ImageView mJoninTopImage;
	private String url;
	int width;
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("合伙人加盟");
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		super.init(inflater, container, savedInstanceState);
		rootView=inflater.inflate(R.layout.fragment_join_main, null);
		mPhoneEditText=(EditText)findViewById(R.id.join_phone_et);
		mNameEditText=(EditText)findViewById(R.id.join_name_et);
		mAddressEditText=(EditText)findViewById(R.id.join_city_et);
		mJoninPhoneText=(TextView)findViewById(R.id.join_phone_tv);
		mJoninTopImage=(ImageView)findViewById(R.id.join_top_image);
		
		
		mJoninTopImage.setOnClickListener(this);
		findViewById(R.id.join_comit_but).setOnClickListener(this);
		width=Run.getWindowsWidth(mActivity);
		LayoutParams layoutParams=(LayoutParams)mJoninTopImage.getLayoutParams();
		layoutParams.height=width/2;
		Run.excuteJsonTask(new JsonTask(), new GetJoinInfo());
	}
	 
	@Override
	public void onClick(View v) {
		if(v.getId()==R.id.join_top_image){
			JSONObject jsonData=(JSONObject)mJoninTopImage.getTag();
			if(jsonData!=null){
				setAdData(jsonData);
			}
		}else if(v.getId()==R.id.join_comit_but){
			String name=mNameEditText.getText().toString().trim();
			String phone=mPhoneEditText.getText().toString().trim();
			String address=mAddressEditText.getText().toString().trim();
			if(TextUtils.isEmpty(name)||TextUtils.isEmpty(phone)||TextUtils.isEmpty(address)||!Run.isChinesePhoneNumber(phone)){
				if(TextUtils.isEmpty(name)){
					Run.alert(mActivity, "请输入你的姓名");
					mNameEditText.setFocusable(true);
					mNameEditText.requestFocus();
				}else if(TextUtils.isEmpty(phone)){
					Run.alert(mActivity, "请输入你的手机号码");
					mPhoneEditText.setFocusable(true);
					mPhoneEditText.requestFocus();
				}else if(TextUtils.isEmpty(address)){
					Run.alert(mActivity, "请输入你所在的城市");
					mAddressEditText.setFocusable(true);
					mAddressEditText.requestFocus();
				}else{
					Run.alert(mActivity, "请输入正确的11位手机号码");
					mPhoneEditText.setFocusable(true);
					mPhoneEditText.requestFocus();
				}
			}else{
				Run.excuteJsonTask(new JsonTask(), new CommitJoinInfo(name,phone,address));
			}
		}
	}
	
	private void setAdData(JSONObject data) {

		String urlType = data.optString("url_type");
		if ("goods".equals(urlType)) {
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_CLASS_ID, data.optString("ad_url")));
		} else if ("article".equals(urlType)) {
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_OTHER_ARTICLE_READER).putExtra(Run.EXTRA_ARTICLE_ID, data.optString("ad_url")));
		} else if ("virtual_cat".equals(urlType)) {
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_GOODS_LIST).putExtra(Run.EXTRA_VITUAL_CATE, data.optString("ad_url"))
					.putExtra(Run.EXTRA_TITLE, data.optString("ad_name")));
		} else if ("cat".equals(urlType)) {
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_GOODS_LIST).putExtra(Run.EXTRA_CLASS_ID, data.optString("ad_url"))
					.putExtra(Run.EXTRA_TITLE, data.optString("ad_name")));
		} else if ("brand".equals(urlType)) {
			Bundle nBundle = new Bundle();
			nBundle.putString(Run.EXTRA_ARTICLE_ID, data.optString("ad_url"));
			nBundle.putString(Run.EXTRA_DATA, data.optString("ad_name"));
			startActivity(AgentActivity.FRAGMENT_SHOPP_BRAND, nBundle);
		} else if ("brand".equals(urlType)) {
			
		}
	}
	
	private class GetJoinInfo implements JsonTaskHandler{

		@Override
		public void task_response(String json_str) {
			try {
				JSONObject all=new JSONObject(json_str);
				if(Run.checkRequestJson(mActivity, all)){
					JSONArray dataArray=all.optJSONArray("data");
					for(int i = 0;i < dataArray.length();i ++){

						JSONObject object = dataArray.optJSONObject(i);
						String type = object.optString("widgets_type");
						JSONObject params = object.optJSONObject("params");
						if(type == null || params == null)
							continue;

						if(type.equals("ad_pic")){
							displayRectangleImage(mJoninTopImage, params.optString("ad_pic"));
						}else if(type.equals("custom_html")) {
							String text = params.optString("usercustom");
							if(text != null){
								mJoninPhoneText.setText(Html.fromHtml(text));
							}
						}
					}
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}finally{
				displayRectangleImage(mJoninTopImage, url);
			}
			
		}
       
		@Override
		public JsonRequestBean task_request() {
		    JsonRequestBean jrb=new JsonRequestBean(Run.API_URL,"distribution.apply.index");
			return jrb;
		}
		
	}
	
	private class CommitJoinInfo implements JsonTaskHandler{
        private String contact,phone,address;
		public CommitJoinInfo(String contact,String phone,String address){
			this.contact=contact;
			this.phone=phone;
			this.address=address;
		}
		@Override
		public void task_response(String json_str) {
			try {
				JSONObject all=new JSONObject(json_str);
				if(Run.checkRequestJson(mActivity, all)){
					Run.alert(mActivity, "请求已发送，请等待客服人员与您联系");
					mActivity.finish();
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
			
		}
       
		@Override
		public JsonRequestBean task_request() {
		    JsonRequestBean jrb=new JsonRequestBean(Run.API_URL,"distribution.apply.add");
		    jrb.addParams("contact", contact);
		    jrb.addParams("phone", phone);
		    jrb.addParams("company", address);
			return jrb;
		}
		
	}
}
