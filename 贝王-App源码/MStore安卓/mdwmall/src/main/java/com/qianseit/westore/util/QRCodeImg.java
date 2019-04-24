package com.qianseit.westore.util;

import java.util.Hashtable;

import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.PorterDuff.Mode;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

/**
 * Created by wwp on 14-11-7.
 */
public class QRCodeImg {

    // 图片宽度的一般
    private static final int IMAGE_HALFWIDTH = 20;
    //前景色
    private static final int FOREGROUND_COLOR=0xff000000;
    //背景色
    private static final int BACKGROUND_COLOR=0xffffffff;

    /**
     * 生成二维码，中心不带图片
     * @param str
     * @return
     */
    public static  Bitmap Create2DCode(String str)  {
        // 生成二维矩阵,编码时指定大小,不要生成了图片以后再进行缩放,这样会模糊导致无法识别
        try{
            BitMatrix matrix = new MultiFormatWriter().encode(str,BarcodeFormat.QR_CODE, 400, 400);
            int width = matrix.getWidth();
            int height = matrix.getHeight();
            // 二维矩阵转为一维像素数组,也就是一直横着排
            int[] pixels = new int[width * height];
            for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                    if(matrix.get(x, y)){
                        pixels[y * width + x] = 0xff000000;
                    }
                }
            }
            Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            // 通过像素数组生成bitmap,具体参考api
            bitmap.setPixels(pixels, 0, width, 0, 0, width, height);
            return bitmap;
        }catch (WriterException e){
            e.printStackTrace();
        }

        return null;
    }

    /**
     * 生成二维码 中间插入小图片
     *
     * @param str
     *            内容
     * @return Bitmap
     * @throws WriterException
     */
    public static Bitmap cretaeBitmap(String str, Bitmap icon) throws WriterException {
        // 缩放一个40*40的图片
        icon =zoomBitmap(icon, IMAGE_HALFWIDTH);
        Hashtable<EncodeHintType, Object> hints = new Hashtable<EncodeHintType, Object>();
        hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);
        hints.put(EncodeHintType.CHARACTER_SET, "utf-8");
        hints.put(EncodeHintType.MARGIN, 0);
        // 生成二维矩阵,编码时指定大小,不要生成了图片以后再进行缩放,这样会模糊导致识别失败
        BitMatrix matrix = new MultiFormatWriter().encode(str,
                BarcodeFormat.QR_CODE, 300, 300, hints);
        int width = matrix.getWidth();
        int height = matrix.getHeight();
        // 二维矩阵转为一维像素数组,也就是一直横着排了
        int halfW = width / 2;
        int halfH = height / 2;
        int[] pixels = new int[width * height];
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                if (x > halfW - IMAGE_HALFWIDTH && x < halfW + IMAGE_HALFWIDTH
                        && y > halfH - IMAGE_HALFWIDTH
                        && y < halfH + IMAGE_HALFWIDTH) {
                    pixels[y * width + x] = icon.getPixel(x - halfW
                            + IMAGE_HALFWIDTH, y - halfH + IMAGE_HALFWIDTH);
                } else {
                    if (matrix.get(x, y)) {
                        pixels[y * width + x] = FOREGROUND_COLOR;
                    } else { // 无信息设置像素点为白色
                        pixels[y * width + x] = BACKGROUND_COLOR;
                    }
                }

            }
        }
        Bitmap bitmap = Bitmap.createBitmap(width, height,
                Bitmap.Config.ARGB_8888);
        // 通过像素数组生成bitmap
        bitmap.setPixels(pixels, 0, width, 0, 0, width, height);

        return bitmap;
    }

    /**
     *  缩放图片
     * @param icon
     * @param h
     * @return
     */
    public static Bitmap  zoomBitmap(Bitmap icon,int h){
        // 缩放图片
        Matrix m = new Matrix();
        float sx = (float) 2 * h / icon.getWidth();
        float sy = (float) 2 * h / icon.getHeight();
//        icon = getRoundedCornerBitmap(icon);
        m.setScale(sx, sy);
        // 重新构造一个2h*2h的图片
        return Bitmap.createBitmap(icon, 0, 0,icon.getWidth(), icon.getHeight(), m, false);
    }
    
    public static Bitmap getRoundedCornerBitmap(Bitmap bitmap){
        Bitmap outBitmap = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getHeight(), Config.ARGB_8888);
        Canvas canvas = new Canvas(outBitmap);
        final int color =0xff424242;
        final Paint paint = new Paint();
        final Rect rect = new Rect(0,0,bitmap.getWidth(),bitmap.getHeight());
        final RectF rectF = new RectF(rect);
        final float roundPX = bitmap.getWidth()/2;
        paint.setAntiAlias(true);
        canvas.drawARGB(0,0,0,0);
        paint.setColor(color);
        canvas.drawRoundRect(rectF, roundPX, roundPX, paint);
        paint.setXfermode(new PorterDuffXfermode(Mode.SRC_IN));
        canvas.drawBitmap(bitmap, rect, rect, paint);
        return outBitmap;
    }
}
