package com.qianseit.westore.activity.recommend;

import android.database.Cursor;
import android.net.Uri;
import android.provider.ContactsContract;

import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseRadioBarFragment;
import com.qianseit.westore.base.adpter.RadioBarBean;
import com.qianseit.westore.httpinterface.member.MemberMobileListInterface;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class RecommendTelBookFragment extends BaseRadioBarFragment {
    public final static int TEL_BOOK_ADDED = 1;
    public final static int TEL_BOOK_ATTENTION_ADD = 2;

    List<RadioBarBean> mBarBeans = new ArrayList<RadioBarBean>();

    @Override
    protected List<RadioBarBean> initRadioBar() {
        // TODO Auto-generated method stub
        mBarBeans.add(new RadioBarBean("已加入", TEL_BOOK_ADDED, new RecommendTelBookAddedFragment()));
        mBarBeans.add(new RadioBarBean("邀请加入", TEL_BOOK_ATTENTION_ADD, new RecommendTelBookInvitedAddFragment()));
        return mBarBeans;
    }

    @Override
    protected void init() {
        // TODO Auto-generated method stub
        mActionBar.setTitle("手机通讯录好友");
        new MemberMobileListInterface(this, getContact().toString()) {

            @Override
            public void NeedInvitedList(JSONArray needInvitedArray) {
                // TODO Auto-generated method stub
                List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
                for (int i = 0; i < needInvitedArray.length(); i++) {
                    nJsonObjects.add(needInvitedArray.optJSONObject(i));
                }

//				((RecommendTelBookInvitedAddFragment)mBarBeans.get(1).mFragment).setItems(nJsonObjects);
            }

            @Override
            public void HadInvitedList(JSONArray hadInvitedArray) {
                // TODO Auto-generated method stub
                List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
                for (int i = 0; i < hadInvitedArray.length(); i++) {
                    nJsonObjects.add(hadInvitedArray.optJSONObject(i));
                }

//				((RecommendTelBookAddedFragment)mBarBeans.get(0).mFragment).setItems(nJsonObjects);
            }
        }.RunRequest();
    }

    /**
     * 获取手机通讯录 creatTime 2015-7-31 下午5:55:37
     *
     * @return return ArrayList<ContactMember>
     */
    private ArrayList<JSONObject> getContact() {
        // ArrayList<ContactMember> listMembers = new
        // ArrayList<ContactMember>();
        ArrayList<JSONObject> listContact = new ArrayList<JSONObject>();
        Cursor cursor = null;
        try {

            Uri uri = ContactsContract.CommonDataKinds.Phone.CONTENT_URI;
            // 这里是获取联系人表的电话里的信息 包括：名字，名字拼音，联系人id,电话号码；
            // 然后在根据"sort-key"排序
            cursor = mActivity.getContentResolver().query(uri, new String[]{"display_name", "sort_key", "contact_id", "data1"}, null, null, "sort_key");
            if (cursor == null) return listContact;

            if (cursor.moveToFirst()) {
                do {
                    // ContactMember contact = new ContactMember();
                    JSONObject json = new JSONObject();
                    String contact_phone = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
                    String name = cursor.getString(0);
                    json.put("name", name);
                    json.put("mobile", contact_phone.replaceAll(" ", ""));
                    if (name != null) {
                        // listMembers.add(contact);
                        listContact.add(json);
                    }
                } while (cursor.moveToNext());
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (cursor != null)
                cursor.close();
        }
        return listContact;
    }

    @Override
    protected BaseDoFragment getRadioBarFragemnt(long radioBarId) {
        // TODO Auto-generated method stub
        return null;
    }
}
