package com.qianseit.westore.base.viewHolder;

import android.util.SparseArray;
import android.view.View;

///视图存储器,主要用于保存视图的子视图,不需要每次获取的时候都通过 findViewById来获取
public class ViewHolder {

    /**
     * 通过id获取视图
     * @param rootView 根视图
     * @param id 视图id
     * @param <T> 泛型,返回值必须是 View或者其子类
     * @return 子视图
     */
    @SuppressWarnings("unchecked")
    public static <T extends View> T get(View rootView, int id){

        ///保存子视图的集合
        SparseArray<View> holder = (SparseArray<View>) rootView.getTag(Integer.MAX_VALUE);

        if (holder == null) {

            ///创建集合并关联rootView
            holder = new SparseArray<>();
            rootView.setTag(Integer.MAX_VALUE, holder);
        }

        View childView = holder.get(id);
        if (childView == null) {

            ///获取子类并保存
            childView = rootView.findViewById(id);
            holder.put(id, childView);
        }

        return (T) childView;
    }
}
