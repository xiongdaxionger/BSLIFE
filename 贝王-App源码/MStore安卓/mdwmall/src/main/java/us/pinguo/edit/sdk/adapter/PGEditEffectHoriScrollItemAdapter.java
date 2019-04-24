package us.pinguo.edit.sdk.adapter;

import us.pinguo.edit.sdk.base.PGEditTools;
import us.pinguo.edit.sdk.base.widget.LinearHoriScrollView;
import us.pinguo.edit.sdk.core.model.PGEftDispInfo;
import us.pinguo.edit.sdk.core.utils.SystemUtils;
import us.pinguo.edit.sdk.widget.ImageLoaderView;
import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;

public class PGEditEffectHoriScrollItemAdapter extends PGEditEffectSelectAdapter {

    private View.OnClickListener mOnItemViewClickListener;
    private View.OnClickListener mOnScrollClickListener;
    private Context mContext;

    private View mLastSelectedView;
    private View.OnClickListener mOnClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            View effectState = v.findViewById(R.id.effect_state_parent);
            if (effectState.getVisibility() == View.VISIBLE) {
                if (mOnScrollClickListener != null) {
                    mOnScrollClickListener.onClick(v);
                }

            } else {
                effectState.setVisibility(View.VISIBLE);

                if (mOnItemViewClickListener != null) {
                    mOnItemViewClickListener.onClick(v);
                }

                if (mLastSelectedView != null) {
                    mLastSelectedView.findViewById(R.id.effect_state_parent).setVisibility(View.INVISIBLE);
                }

                mLastSelectedView = v;
            }
        }
    };

    private boolean isShowFirstPosition = true;
    private String mMaskResource;

    public PGEditEffectHoriScrollItemAdapter(LinearHoriScrollView parentView, int selectPosition) {
        super(parentView, selectPosition);
    }

    @Override
    public int getCount() {
        if (isShowFirstPosition) {
            return super.getCount() + 1;
        } else {
            return super.getCount();
        }
    }

    @Override
    public PGEftDispInfo getItem(int position) {
        if (isShowFirstPosition) {
            return (PGEftDispInfo) super.getItem(position - 1);
        } else {
            return (PGEftDispInfo) super.getItem(position);
        }
    }


    @Override
    public View initView(LinearHoriScrollView parent, Context context, int position) {

        View item;
        if (isShowFirstPosition && position == 0) {
            item = View.inflate(context, R.layout.layout_effect_select_empty, null);
        } else {
            PGEftDispInfo effect = getItem(position);

            item = View.inflate(context, R.layout.layout_effect_select_item, null);
            ImageLoaderView icon = (ImageLoaderView) item.findViewById(R.id.effect_image);
            icon.setScaleType(ImageView.ScaleType.FIT_XY);
            icon.setImageUrl(effect.getIconFileUrl(context));
            TextView text = (TextView) item.findViewById(R.id.effect_text);

            ImageView maskImageView = (ImageView) item.findViewById(R.id.effect_mask);
            View effectStateParent = item.findViewById(R.id.effect_state_parent);

            //隐藏掉特效选中状态
            item.findViewById(R.id.effect_selected).setVisibility(View.GONE);
            effectStateParent.setVisibility(View.GONE);
            maskImageView.setImageResource(PGEditTools.getDrawableByName(mContext, mMaskResource));

            int color = effect.getColor();
            maskImageView.setBackgroundColor(color & 0xb3ffffff);
            text.setBackgroundColor(Color.WHITE);
            String info = SystemUtils.getLocationInfo();
            text.setText(effect.getName(info.replace("-", "_")));
            item.setTag(effect);

            item.setOnClickListener(mOnClickListener);

            //进入三级菜单的时候，如果上次点击中的话，就让它处于选中状态
            if (mLastSelectedView != null) {
                PGEftDispInfo lastEffect = (PGEftDispInfo) mLastSelectedView.getTag();
                if (lastEffect.eft_key.equals(effect.eft_key)) {
                    item.findViewById(R.id.effect_state_parent).setVisibility(View.VISIBLE);
                    mLastSelectedView = item;
                }

            }
            if(position==0||position==8||position==6||position==11||position==13||position==14||position==16||position==17){
            	item.setVisibility(View.GONE);
            }
            if(position==1){
            	text.setText("sunny");
            }
            if(position==9){
            	text.setText("film");
            }
            if(position==7){
            	text.setText("memory");
            }
            if(position==10){
            	text.setText("maple");
            }
            if(position==15){
            	text.setText("fantacy");
            }
            if(position==3){
            	text.setText("cool");
            }
            if(position==5){
            	text.setText("clear");
            }
            if(position==4){
            	text.setText("impress");
            }
            if(position==2){
            	text.setText("sweat");
            }
            
        }

        return item;
    }

    public void setMaskResource(String maskResource) {
        mMaskResource = maskResource;
    }

    public void hideFirstPosition() {
        isShowFirstPosition = false;
    }

    public void setContext(Context context) {
        this.mContext = context;
    }

    public void setOnItemViewClickListener(View.OnClickListener mOnItemViewClickListener) {
        this.mOnItemViewClickListener = mOnItemViewClickListener;
    }

    public void setOnScrollClickListener(View.OnClickListener mOnScrollClickListener) {
        this.mOnScrollClickListener = mOnScrollClickListener;
    }

    public void setLastSelectedView(View lastSelectedView) {
        mLastSelectedView = lastSelectedView;
    }
}
