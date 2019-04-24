package com.qianseit.westore.activity.common;

import java.util.ArrayList;
import java.util.List;

import android.graphics.Point;
import android.graphics.PointF;

/**
 * @author qianseit 首页图片广告对象 每个对象占一行，高度自适应 每个对象包含的图票数不固定，布局亦不固定
 *         图片布局根据图片的大小和顺序自动适应 按从左至右，从上之下的顺序自动填充（如果剩余空间不够当前图片大小，则留空）
 */
public class IndexPictureAdBean {
	public List<IndexPictureAdBeanItem> mAdBeanItems = new ArrayList<IndexPictureAdBeanItem>();
	// /**
	// * 按屏幕宽度为1080p计算，其他屏幕根据1080p自动适应
	// */
	// final int screenWidth = 1080;
	/**
	 * 
	 * 设置屏幕定义宽度（接口返回并定义的，非当前屏幕） 需要根据该值重新计算图片的大小
	 */
	private int definitionWidth = 1080;

	/**
	 * 分割线宽度
	 */
	private float dividerSpace = 3;

	public int getDefinitionWidth() {
		return definitionWidth;
	}

	public void setDefinitionWidth(int definitionWidth) {
		this.definitionWidth = definitionWidth;
		mAdBeanShape.setScreenWidth(definitionWidth);
	}

	public void setDividerSpace(double dividerSpace) {
		this.dividerSpace = (float) dividerSpace;//(float) (dividerSpace * definitionWidth / 1080);
		mAdBeanShape.setDividerSpace(this.dividerSpace);
	}

	public float beanHeight = 0;

	IndexPictureAdBeanShape mAdBeanShape = new IndexPictureAdBeanShape();

	/**
	 * @param order
	 * @param width
	 *            图片宽度
	 * @param height
	 *            图片高度
	 * @param type
	 *            广告类型
	 * @param typevalue
	 *            值
	 * @param imageUrl
	 *            图片url
	 * @return 当前行已经加满则返回true|否则返回false
	 */
	public boolean addItem(int order, float width, float height, String type, String typevalue, String imageUrl) {
		if (width == 0 || height == 0) {
			return false;
		}

		if (beanHeight < height) {
			beanHeight = height;
		}

		IndexPictureAdBeanItem nAdBeanItem = new IndexPictureAdBeanItem(order, width, height, type, typevalue, imageUrl);
		PointF nPoint = mAdBeanItems.size() == 0 ? mAdBeanShape.addFirstRectangle(width, height) : mAdBeanShape.addRectangle(width, height);
		nAdBeanItem.left = nPoint.x;
		nAdBeanItem.top = nPoint.y;
		mAdBeanItems.add(nAdBeanItem);

		return beanHeight > 0 && mAdBeanShape.size() == 4;
	}
	
	/**
	 * 在底部加一条分隔线
	 */
	public void addDividerSpace(){
		mAdBeanShape.addRectangle(definitionWidth, dividerSpace);
	}

	public class IndexPictureAdBeanShape extends ArrayList<PointF> {
		/**
		 * 
		 */
		private static final long serialVersionUID = 6919419015933092088L;

		public int screenWidth = 0;
		public float dividerSpace = 0;

		PointF mRightTop, mRightBottom, mLeftTop, mLeftBottom;

		public void setScreenWidth(int screenWidth) {
			this.screenWidth = screenWidth;
			mLeftTop = add(0, 0);
			mRightTop = add(screenWidth, 0);
			mRightBottom = add(screenWidth, 0);
			mLeftBottom = add(0, 0);
		}

		public void setDividerSpace(float dividerSpace) {
			this.dividerSpace = dividerSpace;
		}

		public PointF add(float x, float y) {
			return add(size(), x, y);
		}

		public PointF add(int index, float x, float y) {
			PointF nPoint = new PointF(x, y);
			add(index, nPoint);
			return nPoint;
		}

		/**
		 * 返回加入加入矩形的left（x）、top（y）
		 * 
		 * @param width
		 * @param height
		 * @return
		 */
		public PointF addRectangle(float width, float height) {
			if (width > screenWidth) {
				width = screenWidth;
				height = height * width / screenWidth;
			}
			addSpace(width, height);
			PointF nPoint = null;
			List<PointF> nList = sortByYASC();
			if (nList.size() >= 2 && nList.size() % 2 == 0) {
				for (int i = 0; i < nList.size(); i = i + 2) {
					PointF nLeftTop = nList.get(i);
					PointF nRightTop = nList.get(i + 1);
					if (nRightTop.x - nLeftTop.x >= width) {// 找到可以插入矩形的左上角的点
						nPoint = new PointF(nLeftTop.x, nLeftTop.y);
						if (nPoint.y > 0) {//上分隔线
							nPoint.y = nPoint.y + dividerSpace;
						}
						//分隔线 + dividerSpace是为了增加分割线
						addRectangle(nLeftTop, width, nPoint.y > 0 ? height + dividerSpace : height);
						break;
					}
				}
			}

			return nPoint;
		}

		/**
		 * @param width
		 * @param height
		 *            为该尺寸的图片加上适当的分割线
		 * 
		 *            x大于0左边加分隔线；y大于0上面加分割线(上分割线不加，因为会引起图片插入位置不对)
		 */
		private void addSpace(float width, float height){
			if (dividerSpace <= 0) {
				return;
			}
			addSpaceLeft(width, height);
//			addSpaceTop(width, height);
		}
		/**
		 * @param width
		 * @param height
		 *            为该尺寸的图片加上适当的分割线
		 * 
		 *            x大于0左边加分隔线；y大于0上面加分割线
		 */
		private void addSpaceLeft(float width, float height) {
			List<PointF> nList = sortByYASC();
			if (nList.size() >= 2 && nList.size() % 2 == 0) {
				for (int i = 0; i < nList.size(); i = i + 2) {
					PointF nLeftTop = nList.get(i);
					PointF nRightTop = nList.get(i + 1);
					if (nRightTop.x - nLeftTop.x >= width + dividerSpace) {// 找到可以插入矩形的左上角的点
						if (nLeftTop.x > 0) {// 左分割线
							//顶部分隔线 + dividerSpace是为了增加顶部分割线
							addRectangle(nLeftTop, dividerSpace, nLeftTop.y > 0 ? height + dividerSpace : height);
						}
						break;
					}
				}
			}
		}

		/**
		 * @param width
		 * @param height
		 *            为该尺寸的图片加上适当的分割线
		 * 
		 *            x大于0左边加分隔线；y大于0上面加分割线
		 */
		private void addSpaceTop(float width, float height) {
			List<PointF> nList = sortByYASC();
			if (nList.size() >= 2 && nList.size() % 2 == 0) {
				for (int i = 0; i < nList.size(); i = i + 2) {
					PointF nLeftTop = nList.get(i);
					PointF nRightTop = nList.get(i + 1);
					if (nRightTop.x - nLeftTop.x >= width) {// 找到可以插入矩形的左上角的点
						if (nLeftTop.y > 0) {// 上分割线
							addRectangle(nLeftTop, width, dividerSpace);
						}
						break;
					}
				}
			}
		}

		/**
		 * 以leftTop为左上角点插入一个矩形
		 * 
		 * @param leftTop
		 * @param width
		 * @param height
		 */
		void addRectangle(PointF leftTop, float width, float height) {
			int nIndex = indexOf(leftTop);
			List<PointF> nNewList = new ArrayList<PointF>();
			nNewList.add(0, new PointF(leftTop.x, leftTop.y + height));// 左下
			nNewList.add(0, new PointF(leftTop.x + width, leftTop.y + height));// 右下
			nNewList.add(0, new PointF(leftTop.x + width, leftTop.y));// 右上

			PointF nOldRightTop = get(nIndex - 1);
			PointF nOldRightBottom = get(nIndex - 2);
			PointF nOldLeftBottom = nIndex == size() - 1 ? null : get(nIndex + 1);

			int nInsertIndex = nIndex;

			if (nOldLeftBottom == null) {// 改变mLeftBottom的y值
				mLeftBottom.y = mLeftBottom.y + height;
				nNewList.remove(2);
			} else if (nOldLeftBottom.y == nNewList.get(2).y) {// 两个点都去掉
				nNewList.remove(2);
				remove(nOldLeftBottom);
				remove(nIndex);
			} else {// 两个点都保留
				remove(nIndex);
			}

			if (nOldRightBottom.x == nNewList.get(1).x) {
				if (nOldRightBottom.x == screenWidth) {// 改变mRgihtBottom的y值
					mRightBottom.y = nNewList.get(1).y;
					nNewList.remove(1);
				} else if (nOldRightBottom.y == nNewList.get(1).y) {// 两个点都去掉
					nNewList.remove(1);
					remove(nOldRightBottom);
					nInsertIndex--;
				}
			} else {// 两个点都保留

			}

			if (nOldRightTop.x == nNewList.get(0).x) {
				if (nOldRightTop.x == screenWidth) {// 去掉这个点就行了
					nNewList.remove(0);
				} else {// 两个点都去掉
					nNewList.remove(0);
					remove(nOldRightTop);
					nInsertIndex--;
				}
			} else {// 两个点都保留

			}

			addAll(nInsertIndex, nNewList);
		}

		/**
		 * 返回加入加入矩形的left（x）、top（y）
		 * 
		 * @param width
		 * @param height
		 * @return
		 */
		public PointF addFirstRectangle(float width, float height) {
			if (width > screenWidth) {
				width = screenWidth;
				height = height * width / screenWidth;
			}
			PointF nPoint = null;
			if (width < screenWidth) {
				add(3, width, height);
				add(3, width, 0);
			} else {
				mRightBottom.y = height;
			}
			mLeftBottom.y = height;
			nPoint = get(0);

			return nPoint;
		}

		/**
		 * 将第2至第n个元素按y值升序、x值升序排序
		 * 
		 * @return
		 */
		List<PointF> sortByYASC() {
			List<PointF> nList = new ArrayList<PointF>();
			if (size() > 2) {
				for (int i = 2; i < size(); i++) {
					PointF nWaitSortPoint = get(i);
					if (nList.size() <= 0) {
						nList.add(nWaitSortPoint);
					} else {
						int low = 0;
						int high = nList.size() - 1;
						int mid = 0;
						do {
							mid = (low + high) / 2;
							PointF nMidPoint = nList.get(mid);
							if (nMidPoint.y > nWaitSortPoint.y) {
								high = mid - 1;
							} else {
								low = mid + 1;
							}

						} while (low <= high);

						if (low > mid) {
							nList.add(mid + 1, nWaitSortPoint);
						} else {
							nList.add(mid, nWaitSortPoint);
						}
					}
				}
			}

			for (int i = 0; i < nList.size() - 1; i = i + 2) {
				if (nList.get(i).x > nList.get(i + 1).x) {
					nList.add(i, nList.remove(i + 1));
				}
			}

			return nList;
		}
	}
}
