package com.qianseit.westore.activity.marketing;

import android.app.Dialog;
import android.content.ContentValues;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.media.AudioManager;
import android.media.SoundPool;
import android.os.Bundle;
import android.os.Message;
import android.text.Html;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.LinearInterpolator;
import android.view.animation.OvershootInterpolator;
import android.view.animation.TranslateAnimation;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.marketing.MarketingShakeIndexInterface;
import com.qianseit.westore.httpinterface.marketing.MarketingShakeInterface;
import com.qianseit.westore.ui.Sentence;
import com.qianseit.westore.ui.VerticalScrollTextView;
import com.qianseit.westore.util.DateUtils;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class MarketingShakeFragment extends BaseDoFragment implements SensorEventListener {
    final int LOAD_NEXT = 0X01;

    private Dialog RuleDialog, WinningDialog, HintDialog;
    private ImageButton mVoiceImgBut;
    private ImageView mRuleBut, mLoadImg;
    private String RuleString;
    private TextView mHintNumText;
    private int limitNum;
    private int usageNum;
    private TextView hintText;
    private View mDisplayView, mRequestView, mHintView;
    private TextView mWinningName, mWinningType, mWinningTime, mWinningHint;
    private TextView mShakeHintText;
    private TextView mHintText;
    private String winningName, winningType, winningTime, winningHint, shakeHint;
    private ImageView mDisplayImg;
    private Button mShakeHintBut;

    private SensorManager sensorManager;
    private boolean isSensor = true;
    private SoundPool soundPool;
    private boolean isVoice = true;
    private int soundId;
    private View mShakeImgeView;

    VerticalScrollTextView mFlipper;
    LinearLayout mWinningLayout;
    int mTextColor = 0, mPaddingHeight, mPaddingWidth;
    float mTextSize = 13;

    int mPageNumber = 1;
    boolean isLoadedAll = false;
    MarketingShakeIndexInterface mIndexInterface = new MarketingShakeIndexInterface(this) {

        @Override
        public ContentValues BuildParams() {
            // TODO Auto-generated method stub
            ContentValues nContentValues = new ContentValues();
            nContentValues.put("type", "1");
            nContentValues.put("page", String.valueOf(mPageNumber));
            return nContentValues;
        }

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            if (responseJson != null) {

                RuleString = responseJson.optString("rule_desc");
                limitNum = responseJson.optInt("limit_count");
                usageNum = responseJson.optInt("usage_limit");

                if(limitNum == 0) {

                    mHintNumText.setText("今日还可摇无限次");
                } else {

                    mHintNumText.setText("今日还可摇" + usageNum + "次");
                }

                JSONArray nArray = responseJson.optJSONArray("winners_list");
                if (nArray == null || nArray.length() <= 0) {
                    isLoadedAll = true;
                    return;
                }

                for (int i = 0; i < nArray.length(); i++) {
                    JSONObject nJsonObject = nArray.optJSONObject(i);
                    Sentence sen = new Sentence(i, String.format("%s刚刚摇中%s", nJsonObject.optString("username"), nJsonObject.optJSONObject("data").optString("name")));
                    mSentences.add(sen);
                }
                if (mPageNumber == 1) {
                    mFlipper.setList(mSentences);
                    mFlipper.updateUI();
                    mHandler.sendEmptyMessage(LOAD_NEXT);
                } else {
                    mHandler.sendEmptyMessageDelayed(LOAD_NEXT, 2000);
                }

                if (usageNum <= 0) {
//					sensorManager.unregisterListener(MarketingShakeFragment.this, sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER));
                }
            }
        }
    };
    MarketingShakeInterface mShakeInterface = new MarketingShakeInterface(this) {

        @Override
        public void SuccCallBack(JSONObject responseJson) {
            // TODO Auto-generated method stub
            setDisplayStatue(4);
            isSensor = true;
            FillShakeData(responseJson);
        }

        @Override
        public void FailRequest() {
            setDisplayStatue(4);
            isSensor = true;
        }
    };
    List<Sentence> mSentences = new ArrayList<Sentence>();

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mActionBar.setTitle(R.string.shake_title);
        sensorManager = (SensorManager) mActivity.getSystemService(Context.SENSOR_SERVICE);
        soundPool = new SoundPool(1, AudioManager.STREAM_MUSIC, 100);
        soundId = soundPool.load(mActivity, R.raw.yao, 1);

        mTextColor = getResources().getColor(R.color.white);
        mPaddingHeight = Run.dip2px(mActivity, 3);
        mPaddingWidth = Run.dip2px(mActivity, 10);
        mActionBar.getTitleTV().setTextColor(getResources().getColor(R.color.white));
        mActionBar.getTitleBar().setBackgroundResource(R.color.westore_red);
        mActionBar.getBackButton().setImageResource(R.drawable.comm_button_back_white);
    }

    @Override
    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.init(inflater, container, savedInstanceState);
        rootView = inflater.inflate(R.layout.fragment_marketing_sharke_main, null);

        mVoiceImgBut = (ImageButton) findViewById(R.id.shake_voice_imgbut);
        mRuleBut = (ImageView) findViewById(R.id.shake_rule_but);
        mLoadImg = (ImageView) findViewById(R.id.shake_load_image);
        mDisplayView = findViewById(R.id.shake_display_linear);
        mRequestView = findViewById(R.id.shake_display_request_linear);
        mHintView = findViewById(R.id.shake_display_hint_linear);
        mHintText = (TextView) findViewById(R.id.shake_hint_text);
        mHintNumText = (TextView) findViewById(R.id.sharke_hint_num_text);
        mDisplayImg = (ImageView) findViewById(R.id.dhake_idsplay_img);
        mShakeImgeView = findViewById(R.id.shake_person_img);
        mRuleBut.setOnClickListener(this);
        mVoiceImgBut.setOnClickListener(this);

        mFlipper = (VerticalScrollTextView) findViewById(R.id.flipper);

        //给View传递数据

        Animation rotateAnimation = AnimationUtils.loadAnimation(mActivity, R.anim.shake_rotate);
        LinearInterpolator lir = new LinearInterpolator();
        rotateAnimation.setInterpolator(lir);
        mLoadImg.startAnimation(rotateAnimation);
        mIndexInterface.RunRequest();
    }

    @Override
    public void ui(int what, Message msg) {
        // TODO Auto-generated method stub
        if (what == LOAD_NEXT) {
            mPageNumber++;
            mIndexInterface.AutoStartLoadingDialog(false);
            mIndexInterface.RunRequest();
        }
    }

    @Override
    public void onResume() {
        // TODO Auto-generated method stub
        super.onResume();
        sensorManager.registerListener(this, sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER), SensorManager.SENSOR_DELAY_NORMAL);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        if (v.getId() == R.id.shake_voice_imgbut) {
            if (isVoice) {
                mVoiceImgBut.setImageResource(R.drawable.sharke_no_voice);
                isVoice = false;
            } else {
                mVoiceImgBut.setImageResource(R.drawable.sharke_voice);
                isVoice = true;
            }
        } else if (v.getId() == R.id.shake_rule_but) {
            isSensor = false;
            ShowHintRuleDialog();
        }
    }

    TextView getWinningView(String winningValue) {
        TextView nTextView = new TextView(mActivity);
        nTextView.setTextColor(mTextColor);
        nTextView.setPadding(mPaddingWidth, mPaddingHeight, mPaddingWidth, mPaddingHeight);
        nTextView.setGravity(Gravity.LEFT);
        nTextView.setText(winningValue);
        nTextView.setTag(winningValue);
        nTextView.setTextSize(TypedValue.COMPLEX_UNIT_SP, mTextSize);
        return nTextView;
    }

    public void ShowHintRuleDialog() {
        if (RuleDialog != null) {
            if (RuleDialog.isShowing()) {
                RuleDialog.dismiss();
            } else {
                hintText.setText(Html.fromHtml(RuleString));
                RuleDialog.show();
            }
            return;
        }

        RuleDialog = new Dialog(mActivity, R.style.shake_rule_dialog);
        RuleDialog.setCancelable(false);
        View RuleDialogView = mActivity.getLayoutInflater().inflate(R.layout.item_rule, null);
        hintText = (TextView) RuleDialogView.findViewById(R.id.rule_text);
        RuleDialogView.findViewById(R.id.rule_calcel_image).setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                isSensor = true;
                RuleDialog.dismiss();
            }
        });
        RuleDialog.setContentView(RuleDialogView);
        Window RuleDialogWindow = RuleDialog.getWindow();
        RuleDialogWindow.setGravity(Gravity.BOTTOM);

        RuleDialogWindow.setWindowAnimations(R.style.rule_dialog_animstyle);
        WindowManager.LayoutParams wl = RuleDialogWindow.getAttributes();
        wl.x = 0;
        wl.y = Run.getWindowsHeight(mActivity);
        hintText.setText(Html.fromHtml(RuleString));
        RuleDialog.show();
    }

    public void ShowWinningDialog() {
        if (WinningDialog != null) {
            if (WinningDialog.isShowing()) {
                WinningDialog.dismiss();
            } else {
                mWinningName.setText(winningName);
                mWinningType.setText(winningType);
                mWinningTime.setText(winningTime);
                mWinningHint.setText(winningHint);
                WinningDialog.show();
            }
            return;
        }

        WinningDialog = new Dialog(mActivity, R.style.shake_winning_dialog);
        WinningDialog.setCancelable(false);
        View WinningDialogView = mActivity.getLayoutInflater().inflate(R.layout.item_shake_winning, null);
        mWinningName = (TextView) WinningDialogView.findViewById(R.id.shake_winning_name);
        mWinningType = (TextView) WinningDialogView.findViewById(R.id.shake_winning_type);
        mWinningTime = (TextView) WinningDialogView.findViewById(R.id.shake_winning_time);
        mWinningHint = (TextView) WinningDialogView.findViewById(R.id.shake_winning_hint);
        mWinningName.setText(winningName);
        mWinningType.setText(winningType);
        mWinningTime.setText(winningTime);
        mWinningHint.setText(winningHint);
        WinningDialogView.findViewById(R.id.shake_winning_cancel).setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                WinningDialog.dismiss();
                isSensor = true;
            }
        });

        WinningDialogView.findViewById(R.id.shake_winning_see_but).setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                // 查看优惠券
                isSensor = true;
                WinningDialog.dismiss();
                startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_COUPON));
            }
        });
        WinningDialog.setContentView(WinningDialogView);
        Window RuleDialogWindow = WinningDialog.getWindow();
        RuleDialogWindow.setGravity(Gravity.BOTTOM);

        RuleDialogWindow.setWindowAnimations(R.style.rule_dialog_animstyle);
        WindowManager.LayoutParams wl = RuleDialogWindow.getAttributes();
        wl.x = 0;
        wl.y = Run.getWindowsHeight(mActivity);
        wl.width = Run.getWindowsWidth(mActivity);
        RuleDialogWindow.setAttributes(wl);
        WinningDialog.show();
    }

    public void ShowHintDialog() {
        if (HintDialog != null) {
            if (HintDialog.isShowing()) {
                HintDialog.dismiss();
            } else {
                mShakeHintText.setText(shakeHint);
                HintDialog.show();
            }
            return;
        }

        HintDialog = new Dialog(mActivity, R.style.shake_winning_dialog);
        HintDialog.setCancelable(false);
        View HintDialogView = mActivity.getLayoutInflater().inflate(R.layout.item_shake_hint, null);
        mShakeHintText = (TextView) HintDialogView.findViewById(R.id.shake_hint_text);
        mShakeHintBut = (Button) HintDialogView.findViewById(R.id.shake_hint_but);
        mShakeHintText.setText(shakeHint);
        HintDialogView.findViewById(R.id.shake_hint_cancel).setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                HintDialog.dismiss();
                isSensor = true;
            }
        });

        HintDialogView.findViewById(R.id.shake_hint_but).setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                // 明日再战
                HintDialog.dismiss();
                isSensor = true;

            }
        });
        HintDialog.setContentView(HintDialogView);
        Window RuleDialogWindow = HintDialog.getWindow();
        RuleDialogWindow.setGravity(Gravity.BOTTOM);

        RuleDialogWindow.setWindowAnimations(R.style.rule_dialog_animstyle);
        WindowManager.LayoutParams wl = RuleDialogWindow.getAttributes();
        wl.x = 0;
        wl.y = Run.getWindowsHeight(mActivity);
        wl.width = Run.getWindowsWidth(mActivity);
        RuleDialogWindow.setAttributes(wl);
        HintDialog.show();
    }

    private void FillShakeData(JSONObject data) {
        int code = data.optInt("status");
        usageNum = data.optInt("limit_count");
        limitNum = data.optInt("limit");

        if(limitNum == 0) {

            mHintNumText.setText("今日还可摇无限次");
        } else {

            mHintNumText.setText("今日还可摇" + usageNum + "次");
        }

        switch (code) {
            case 0:
                JSONObject couponJSON = data.optJSONObject("coupon");
                if (couponJSON != null) {
                    winningName = couponJSON.optString("cpns_name");
                    JSONObject ruleJSON = couponJSON.optJSONObject("rule");
                    if (ruleJSON != null) {
                        Long formTime = ruleJSON.optLong("from_time") * 1000;
                        Long toTime = ruleJSON.optLong("to_time") * 1000;
                        String formStr = DateUtils.getDateToString(formTime, "yyyy.MM.dd");
                        String toStr = DateUtils.getDateToString(toTime, "yyyy.MM.dd");
                        winningTime = formStr + "-" + toStr;
                        winningType = ruleJSON.optString("description");
                    }
                    String username = couponJSON.optString("username");
                    winningHint = "已放入" + username + "的" + getString(R.string.app_name) + "账户";

                }
                isSensor = false;
                setDisplayStatue(1);
                ShowWinningDialog();
                break;
            case 1:
            case 2:
            case 3:
            case 4:
            case 6:
            case 10:
            case 7:
                isSensor = false;
                shakeHint = data.optString("msg");
                ShowHintDialog();
                mShakeHintBut.setText(mActivity.getResources().getString(R.string.shake_hint_click));
                setDisplayStatue(2);
                break;
            case 5:
                isSensor = false;
                shakeHint = data.optString("msg");
                ShowHintDialog();
                mShakeHintBut.setText(mActivity.getResources().getString(R.string.shake_hint_finish_click));
                setDisplayStatue(2);
                break;
            case 8:
                isSensor = true;
                mHintView.setVisibility(View.GONE);
                mHintText.setText(data.optString("msg"));
                setDisplayStatue(3);
                break;
            case 9:
                isSensor = false;
                if (data.isNull("msg")) {
                    shakeHint = mActivity.getResources().getString(R.string.shake_hint_message);
                    ShowHintDialog();
                    mShakeHintBut.setText(mActivity.getResources().getString(R.string.shake_hint_click));
                } else {
                    shakeHint = data.optString("msg");
                    ShowHintDialog();
                }
                break;
            default:
                isSensor = true;
                setDisplayStatue(4);
                break;
        }
    }

    @Override
    public void onStop() {
        // TODO Auto-generated method stub
        super.onStop();
        sensorManager.unregisterListener(MarketingShakeFragment.this, sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER));
    }

    /**
     * @param status 0: 加载 1： 中奖 2：没有中将弹窗提示 3:没有中奖不是弹窗提示 4:网络加载错误
     */
    private void setDisplayStatue(int status) { // 0: 加载 1： 中奖 2：没有中将弹窗提示
        // 3:没有中奖不是弹窗提示 4:网络加载错误
        switch (status) {
            case 0:
                mDisplayImg.setVisibility(View.INVISIBLE);
                mDisplayView.setVisibility(View.VISIBLE);
                mRequestView.setVisibility(View.VISIBLE);
                mHintView.setVisibility(View.GONE);
                break;
            case 1:
            case 4:
            case 2:
                mDisplayImg.setVisibility(View.VISIBLE);
                mDisplayView.setVisibility(View.GONE);
                break;
            case 3:
                mDisplayImg.setVisibility(View.INVISIBLE);
                mDisplayView.setVisibility(View.VISIBLE);
                mRequestView.setVisibility(View.GONE);
                mHintView.setVisibility(View.VISIBLE);
                break;
            default:
                break;
        }

    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
        // TODO Auto-generated method stub

    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        int sensorType = event.sensor.getType();
        // values[0]:X轴，values[1]：Y轴，values[2]：Z轴
        float[] values = event.values;

        if (sensorType == Sensor.TYPE_ACCELEROMETER && isSensor) {

			/*
             * 正常情况下，任意轴数值最大就在9.8~10之间，只有在突然摇动手机 的时候，瞬时加速度才会突然增大或减少。
			 * 监听任一轴的加速度大于17即可
			 */
            if ((Math.abs(values[0]) > 17 || Math.abs(values[1]) > 17 || Math.abs(values[2]) > 17)) {
                if (!mShakeInterface.isExcuting()) {
                    if (isVoice) {
                        soundPool.play(soundId, 1, 1, 0, 0, 1);
                    }
                    setDisplayStatue(0);
                    TranslateAnimation animation = new TranslateAnimation(0, -25, 0, 0);
                    animation.setInterpolator(new OvershootInterpolator());
                    animation.setDuration(100);
                    animation.setRepeatCount(3);
                    animation.setRepeatMode(Animation.REVERSE);
                    mShakeImgeView.startAnimation(animation);
                    mShakeInterface.RunRequest();
                } else {
                    if (isVoice) {
                        soundPool.play(soundId, 1, 1, 0, 0, 1);
                    }
                    setDisplayStatue(0);
                    TranslateAnimation animation = new TranslateAnimation(0, -20, 0, 0);
                    animation.setInterpolator(new OvershootInterpolator());
                    animation.setDuration(100);
                    animation.setRepeatCount(3);
                    animation.setRepeatMode(Animation.REVERSE);
                    mShakeImgeView.startAnimation(animation);
//                    mShakeInterface.RunRequest();
                }
            }
        }
    }

}
