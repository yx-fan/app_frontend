package pro.travelexpense.app  // 修改为新包名

import android.Manifest
import android.content.pm.PackageManager
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CAMERA_PERMISSION_REQUEST_CODE = 1001
    private var permissionResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "flutter.native/helper").setMethodCallHandler { call, result ->
            when (call.method) {
                "checkCameraPermission" -> {
                    result.success(checkCameraPermission())
                }
                "requestCameraPermission" -> {
                    permissionResult = result
                    requestCameraPermission()
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun checkCameraPermission(): String {
        return if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
            "granted"
        } else {
            "denied"
        }
    }

    private fun requestCameraPermission() {
        ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CAMERA), CAMERA_PERMISSION_REQUEST_CODE)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        if (requestCode == CAMERA_PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                permissionResult?.success("granted")
            } else {
                permissionResult?.success("denied")
            }
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }
}
