package us.pinguo.edit.sdk.view;

import us.pinguo.edit.sdk.widget.ImageLoaderView;
import us.pinguo.edit.sdk.widget.PGEditMenuItemView;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.widget.RelativeLayout;

import com.beiwangfx.R;

public class PGEditEffectMenuItemView extends PGEditMenuItemView {


    public PGEditEffectMenuItemView(Context context) {
        super(context);
    }

    @Override
    protected int getLayoutResources(Context context) {
        return R.layout.pg_sdk_edit_effect_menu_item;
    }


    public void setIcon(Drawable drawable) {
        if(mIconImageView != null) {
            mIconImageView.setImageDrawable(drawable);
        }
    }

    public void displayCircle() {
        ImageLoaderView imageLoaderView = (ImageLoaderView)mIconImageView;
        imageLoaderView.displayCircle();
    }

    @Override
    public void setIconForImageUrl(String imageUrl){
        ImageLoaderView imageLoaderView = (ImageLoaderView)mIconImageView;

        imageLoaderView.setImageUrl(imageUrl);
    }

    public void setIconLayoutParams(RelativeLayout.LayoutParams layoutParams) {
        mIconImageView.setLayoutParams(layoutParams);
    }

    @Override
    public void setScrollViewBgColor(String color){

        if (null != mScrollView) {
             mScrollView.setBackgroundColor(Color.parseColor(color));

        }
    }

}
