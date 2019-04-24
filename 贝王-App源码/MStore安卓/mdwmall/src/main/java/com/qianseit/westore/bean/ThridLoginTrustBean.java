package com.qianseit.westore.bean;

import java.io.Serializable;

public class ThridLoginTrustBean implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1645429238368672259L;

	String nickName;
	String openId;
	String source;
	String gender;
	String avatar;

	public String getUnionid() {
		return unionid;
	}

	public void setUnionid(String unionid) {
		this.unionid = unionid;
	}

	String unionid; ///微信专用
	public String getNickName() {
		return nickName;
	}
	public void setNickName(String nickName) {
		this.nickName = nickName;
	}
	public String getOpenId() {
		return openId;
	}
	public void setOpenId(String openId) {
		this.openId = openId;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getAvatar() {
		return avatar;
	}
	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}

}
