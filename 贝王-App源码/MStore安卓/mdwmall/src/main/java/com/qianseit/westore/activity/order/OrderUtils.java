package com.qianseit.westore.activity.order;

import android.os.Bundle;
import android.text.TextUtils;

import com.qianseit.westore.activity.aftermarket.AftermarketOrderListFragment;

import org.json.JSONArray;
import org.json.JSONObject;

public class OrderUtils {
	public static String AftermarketOrderStatusDisplay(int orderStatus){
		String nStatusString = "未操作";
		
		switch (orderStatus) {
		case 1:
			nStatusString = "未操作";
			break;
		case 2:
			nStatusString = "审核中";
			break;
		case 3:
			nStatusString = "审核通过";
			break;
		case 4:
			nStatusString = "完成";
			break;
		case 5:
			nStatusString = "拒绝";
			break;

		default:
			break;
		}
		
		return nStatusString;
	}
	
	public static String getOrderStatus(JSONObject orderJsonObject){
		JSONArray nStatusArray = orderJsonObject.optJSONArray("status_txt");
		StringBuilder nBuilder = new StringBuilder();
		if (nStatusArray != null && nStatusArray.length() > 0) {
			for (int i = 0; i < nStatusArray.length(); i++) {
				nBuilder.append(nStatusArray.optJSONObject(i).optString("name"));
			}
		}
		String nStatus = nBuilder.toString();
		nBuilder.delete(0, nBuilder.length());
		return nStatus;
	}

	/**
	 * @param type all:全部订单,nopayed:待支付,prepare:预售订单,noship:待发货,noreceived:待收获,
	 *            nodiscuss:待评价
	 * @return
	 */
	public static OrderListFragment getOrderListFragment(String type,boolean isCommisionOrder){
		Bundle nBundle = new Bundle();
		nBundle.putString(OrderListFragment.ORDER_TYPE, type);
		nBundle.putBoolean(OrderFragment.ORDER_COMMISION_TYPE,isCommisionOrder);
		OrderListFragment nOrderListFragment = new OrderListFragment();
		nOrderListFragment.setArguments(nBundle);
		return  nOrderListFragment;
	}

	/**
	 * @return
	 */
	public static OrderListPrepareFragment getOrderListPrepareFragment(){
		Bundle nBundle = new Bundle();
		nBundle.putString(OrderListFragment.ORDER_TYPE, "prepare");
		OrderListPrepareFragment nOrderListFragment = new OrderListPrepareFragment();
		nOrderListFragment.setArguments(nBundle);
		return  nOrderListFragment;
	}

	/**
	 * @param type refund:退款,reship:退货
	 * @return
	 */
	public static AftermarketOrderListFragment getAftermarketOrderListFragment(String type){
		Bundle nBundle = new Bundle();
		nBundle.putString(OrderListFragment.ORDER_TYPE, type);
		AftermarketOrderListFragment nOrderListFragment = new AftermarketOrderListFragment();
		nOrderListFragment.setArguments(nBundle);
		return  nOrderListFragment;
	}

	/**
	 *         status_txt:{[
            name:"等待补款",//订单状态
            [
                @@@订单状态备注:
                ship_status:{
                    0 => 未发货,
                    1 => 已发货,
                    2 => 部分发货,
                    3 => 部分退货,
                    4 => 已退货,
                }
                pay_status:{
                    0 => 未支付,
                    1 => 已支付,
                    2 => 已付款至到担保方,
                    3 => 部分付款,
                    4 => 部分退款,
                    5 => 全额退款,
                }
            ]
	 * @param orderJsonObject
	 * @return
	 */
	public static boolean canLookLogistics(JSONObject orderJsonObject){
		JSONArray nStatusArray = orderJsonObject.optJSONArray("status_txt");
		if (nStatusArray != null && nStatusArray.length() > 0) {
			for (int i = 0; i < nStatusArray.length(); i++) {
				String nCode = nStatusArray.optJSONObject(i).optString("code");
				if (nCode.startsWith("ship_")) {
					String nShipCode = nCode.replace("ship_", "");
					if (nShipCode.length() > 0 && TextUtils.isDigitsOnly(nShipCode) && Integer.parseInt(nShipCode) > 0) {
						return true;
					}
				}
			}
		}
		
		return false;
	}
	
	public static boolean canPayFinalPayment(JSONObject orderJsonObject){
		JSONArray nStatusArray = orderJsonObject.optJSONArray("status_txt");
		if (nStatusArray != null && nStatusArray.length() > 0) {
			for (int i = 0; i < nStatusArray.length(); i++) {
				String nCode = nStatusArray.optJSONObject(i).optString("code");
				if (nCode.startsWith("pay_")) {
					String nPayCode = nCode.replace("pay_", "");
					if (nPayCode.length() > 0 && TextUtils.isDigitsOnly(nPayCode) && Integer.parseInt(nPayCode) == 3) {
						return true;
					}
				}
			}
		}
		
		return false;
	}
}
