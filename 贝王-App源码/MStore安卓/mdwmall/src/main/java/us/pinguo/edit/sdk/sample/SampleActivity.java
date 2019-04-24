package us.pinguo.edit.sdk.sample;

import java.io.File;

import us.pinguo.edit.sdk.base.PGEditResult;
import us.pinguo.edit.sdk.base.PGEditSDK;
import us.pinguo.edit.sdk.core.utils.BitmapUtils;
import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Toast;

import com.beiwangfx.R;

/**
 * Created by taoli on 14/11/4.
 */
public class SampleActivity extends Activity {

    private final int REQUEST_CODE_PICK_PICTURE = 0x100001;
    private String mPicturePath;
    private ImageView mImage;
    private ImageView mLogo;

    private Button mEditBtn;
    private Button mReEditBtn;
    private Button mChoosePhotoBtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.layout_sample_main);

        mImage = (ImageView) findViewById(R.id.img);
        mLogo = (ImageView) findViewById(R.id.logo);

        mChoosePhotoBtn = (Button) findViewById(R.id.choose_photo_btn);
        mEditBtn = (Button) findViewById(R.id.start_edit_btn);
        mReEditBtn = (Button) findViewById(R.id.re_edit_btn);
    }

    public void reEdit(View v) {
        enterChoosePhotoState();
    }

    public void startEdit(View v) {
        if (null == mPicturePath) {
            Toast.makeText(this, "Please choose photo first", Toast.LENGTH_SHORT).show();
            return;
        }

        String folderPath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM)
                .getAbsolutePath() + File.separator;
        String outFilePath = folderPath + System.currentTimeMillis() + ".jpg";
        PGEditSDK.instance().startEdit(this, PGEditActivity.class, mPicturePath, outFilePath);
    }

    public void startChoosePhoto(View v) {
        Intent intent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        startActivityForResult(intent, REQUEST_CODE_PICK_PICTURE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == REQUEST_CODE_PICK_PICTURE
                && resultCode == Activity.RESULT_OK
                && null != data) {

            Uri selectedImage = data.getData();
            String[] filePathColumns = new String[]{MediaStore.Images.Media.DATA};
            Cursor c = this.getContentResolver().query(selectedImage, filePathColumns, null, null, null);
            c.moveToFirst();
            int columnIndex = c.getColumnIndex(filePathColumns[0]);
            mPicturePath = c.getString(columnIndex);
            c.close();

            if (null != mPicturePath) {

                enterEditState();

                Bitmap bitmap = BitmapUtils.scalePicture(mPicturePath, 720, true);
                mImage.setImageBitmap(bitmap);
            }

            return;
        }

        if (requestCode == PGEditSDK.PG_EDIT_SDK_REQUEST_CODE
                && resultCode == Activity.RESULT_OK) {

            PGEditResult editResult = PGEditSDK.instance().handleEditResult(data);

            mImage.setImageBitmap(editResult.getThumbNail());

            Toast.makeText(this, "Photo saved to:" + editResult.getReturnPhotoPath(), Toast.LENGTH_LONG).show();
            enterReEditState();
        }

        if (requestCode == PGEditSDK.PG_EDIT_SDK_REQUEST_CODE
                && resultCode == PGEditSDK.PG_EDIT_SDK_RESULT_CODE_CANCEL) {
            Toast.makeText(this, "Edit cancelled!", Toast.LENGTH_SHORT).show();
        }

        if (requestCode == PGEditSDK.PG_EDIT_SDK_REQUEST_CODE
                && resultCode == PGEditSDK.PG_EDIT_SDK_RESULT_CODE_NOT_CHANGED) {
            Toast.makeText(this, "Photo do not change!", Toast.LENGTH_SHORT).show();
        }
    }

    private void enterReEditState() {
        mEditBtn.setVisibility(View.GONE);
        mChoosePhotoBtn.setVisibility(View.GONE);

        mReEditBtn.setVisibility(View.VISIBLE);
    }

    private void enterChoosePhotoState() {
        mImage.setVisibility(View.GONE);
        mImage.setImageBitmap(null);

        mLogo.setVisibility(View.VISIBLE);

        mReEditBtn.setVisibility(View.GONE);

        mEditBtn.setBackgroundResource(R.drawable.sdk_sample_rect_btn_disable);
        mEditBtn.setTextColor(Color.parseColor("#444444"));
        mEditBtn.setVisibility(View.VISIBLE);
        mChoosePhotoBtn.setVisibility(View.VISIBLE);

        mPicturePath = null;
    }

    private void enterEditState() {
        mLogo.setVisibility(View.INVISIBLE);
        mImage.setVisibility(View.VISIBLE);

        mEditBtn.setBackgroundResource(R.drawable.sdk_sample_rect_btn_enable);
        mEditBtn.setTextColor(Color.WHITE);
    }
}
