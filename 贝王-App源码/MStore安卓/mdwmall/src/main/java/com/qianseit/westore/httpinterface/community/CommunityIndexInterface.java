package com.qianseit.westore.httpinterface.community;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * Created by qianseit on 2016-09-18.
 * 8.4 故事首页
 */
public abstract class CommunityIndexInterface extends BaseHttpInterfaceTask {
    public CommunityIndexInterface(QianseitActivityInterface activityInterface) {
        super(activityInterface);
    }

    @Override
    public String InterfaceName() {
        return "content.article.story_index";
    }
}
