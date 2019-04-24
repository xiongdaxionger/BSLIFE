package com.qianseit.westore.base;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.KeyEvent;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.ui.CustomProgrssDialog;
import com.qianseit.westore.ui.LoadingDialog;
import com.qianseit.westore.util.Util;

import java.util.Locale;

public abstract class DoActivity extends TopActivity implements QianseitActivityInterface {
    public static final String EXTRA_SHOW_BACK = "EXTRA_SHOW_BACK";

    private final int HANDLE_HIDE_LOADING_DIALOG = 100;
    private final int HANDLE_SHOW_LOADING_DIALOG = 101;
    private final int HANDLE_SHOW_CANCEL_LOADING_DIALOG = 102;
    private final int REQUEST_MEMBER_LOGIN_FOR_STARACTIVITY = 0x1001;

    private CustomProgrssDialog progress;
    private LoadingDialog progress1;
    public AgentApplication mApp;

    int mWaitStarFragmentId = 0;
    Bundle mWaitStarFragmentBundler;
    UPPayInterface mInterface;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mApp = AgentApplication.getApp(this);
        // if (!(this instanceof MainTabFragmentActivity))
        // mApp.getRecentActivies().add(this);

        setContentView(R.layout.qianseit_action_bar_activity);
//        //透明状态栏
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
//            Window window = getWindow();
//            // Translucent status bar
//            window.setFlags(
//                    WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS,
//                    WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
//        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        Run.changeResourceLocale(getResources(), Locale.CHINA);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mApp.getRecentActivies().remove(this);
    }

    // 关闭所有历史打开的Activity
    public void finishAllRecentActivities() {
        for (Activity activity : mApp.getRecentActivies())
            activity.finish();
    }

    protected void startNeedloginActivity(int fragmentId, Bundle bundle) {
        if (!AgentApplication.getLoginedUser(this).isLogined()) {
            startActivity(AgentActivity.intentForFragment(this, AgentActivity.FRAGMENT_COMM_LOGIN).setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP));
            mWaitStarFragmentBundler = bundle;
            mWaitStarFragmentId = fragmentId;
            return;
        }

        startActivity(fragmentId, bundle);
    }

    protected void startNeedloginActivity(int fragmentId) {
        startNeedloginActivity(fragmentId, new Bundle());
    }

    protected void startActivity(int fragmentId) {
        startActivity(fragmentId, new Bundle());
    }

    protected void startActivity(int fragmentId, Bundle bundle) {
        startActivity(AgentActivity.intentForFragment(this, fragmentId).putExtras(bundle));
    }

    protected void startActivityForResult(int fragmentId, Bundle bundle, int requestCode) {
        startActivityForResult(AgentActivity.intentForFragment(this, fragmentId).putExtras(bundle), requestCode);
    }

    protected void startActivityForResult(int fragmentId, int requestCode) {
        startActivityForResult(fragmentId, new Bundle(), requestCode);
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        // 不继承父类，防止旋转或者重载Fragment出错
    }

    public void setUPPayCallBack(UPPayInterface payInterface) {
        mInterface = payInterface;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        String str = (data == null || data.getExtras() == null) ? null : data.getExtras().getString("pay_result");
        if (str != null && (str.equalsIgnoreCase("success") || str.equalsIgnoreCase("fail") || str.equalsIgnoreCase("cancel"))) {
            if (mInterface != null)
                mInterface.UPPayCallback(data);
            return;
        }

        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == REQUEST_MEMBER_LOGIN_FOR_STARACTIVITY && mWaitStarFragmentId > 0) {
                startActivity(mWaitStarFragmentId, mWaitStarFragmentBundler);
                mWaitStarFragmentId = 0;
                mWaitStarFragmentBundler = null;
                return;
            }
        }

        super.onActivityResult(requestCode, resultCode, data);
    }

    /* 当前Fragment */
    public Fragment getCurrentFragment() {
        return getSupportFragmentManager().findFragmentById(R.id.do_activity_fragment);
    }

    /**
     * 返回ActionBar
     *
     * @return
     */
    public DoActionBar getDoActionBar() {
        Fragment fragment = getCurrentFragment();
        if (fragment != null && (fragment instanceof DoFragment))
            return ((DoFragment) fragment).getActionBar();
        return null;
    }

    /**
     * 设置主Fragment
     *
     * @param fragment
     */
    public void setMainFragment(DoFragment fragment) {
        setMainFragment(fragment, 0, 0);
    }

    /**
     * 设置主Fragment和切换动画
     *
     * @param fragment
     * @param enter    进场动画id
     * @param exit     出场动画id
     */
    public void setMainFragment(DoFragment fragment, int enter, int exit) {
        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        if (enter != 0 && exit != 0) {
            transaction.setCustomAnimations(enter, exit);
        }
        transaction.replace(R.id.do_activity_fragment, fragment);
        transaction.commitAllowingStateLoss();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
        }
        return super.onKeyDown(keyCode, event);
    }

    // 评价应用
    public void evaluateApp() {
        Util.evaluateApp(this);
    }

    private Handler tHandler = new Handler() {
        public void handleMessage(Message msg) {
            Activity activity = DoActivity.this;

            switch (msg.what) {
                case HANDLE_SHOW_LOADING_DIALOG:
                    // if (progress != null && progress.isShowing())
                    // progress.dismiss();
                    // progress = Util.showLoadingDialog(activity, null, null);
                    // progress.setCancelable(false);
                    if (progress1 == null || progress1.isShowing()) {
                        progress1 = new LoadingDialog(activity);
                    }
                    progress1.show();
                    progress1.setCancelable(false);
                    break;
                case HANDLE_SHOW_CANCEL_LOADING_DIALOG:
                    // if (progress != null && progress.isShowing())
                    // progress.dismiss();
                    // progress = Util.showLoadingDialog(activity, null, null);
                    // progress.setCancelable(true);

                    if (progress1 != null && progress1.isShowing()) {
                        progress1.dismiss();
                    }
                    progress1 = new LoadingDialog(activity);
                    progress1.show();
                    progress1.setCancelable(true);
                    break;
                case HANDLE_HIDE_LOADING_DIALOG:
                    // Util.hideLoading(progress);
                    if (progress1 != null) {
                        progress1.dismiss();
                    }
                    break;
            }
        }
    };

    /**
     * 显示加载提示框
     */
    public void showLoadingDialog() {
        tHandler.sendEmptyMessage(HANDLE_SHOW_LOADING_DIALOG);
    }

    /**
     * 显示可以取消的提示框
     */
    public void showCancelableLoadingDialog() {
        tHandler.sendEmptyMessage(HANDLE_SHOW_CANCEL_LOADING_DIALOG);
    }

    // 隐藏提示框
    public void hideLoadingDialog() {
        tHandler.sendEmptyMessageDelayed(HANDLE_HIDE_LOADING_DIALOG, 1000);
    }

    // 隐藏提示框
    public void hideLoadingDialog_mt() {
        // Util.hideLoading(progress);
        if (progress1 != null) {
            progress1.dismiss();
        }
    }

    @Override
    public Context getContext() {
        // TODO Auto-generated method stub
        return this;
    }
}
