package com.apieceofcode1801.facebook_messenger_share

import android.graphics.BitmapFactory
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import com.facebook.FacebookSdk
import com.facebook.share.model.*
import com.facebook.share.widget.MessageDialog
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.Exception

/** FacebookMessengerSharePlugin */
class FacebookMessengerSharePlugin: FlutterPlugin, MethodCallHandler,ActivityAware {
  private lateinit var channel: MethodChannel
  private var activityPluginBinding: ActivityPluginBinding? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "facebook_messenger_share")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    val mapResult = mutableMapOf<String,Any>()
    Log.e("frank","method ${call.method}")
    System.out.println("frank method ${call.method}")

    try {

      when (call.method) {
        "shareDataImage" -> {
          Log.e("frank", "shareDataImage")
          System.out.println("frank shareDataImage")
          // share an images as bytes
          val data = call.arguments as ByteArray
          val bitmap = BitmapFactory.decodeByteArray(data, 0, data.size)
          val photo = SharePhoto.Builder().setBitmap(bitmap).build()
          val content = SharePhotoContent.Builder().addPhoto(photo).build()

          MessageDialog.show(this.activityPluginBinding?.activity, content)
          mapResult["code"] = 1
          mapResult["message"] = "share success"
          result.success(mapResult)

          return
        }
        "shareImages" -> {
          Log.e("frank", "shareImages")
          System.out.println("frank shareImages")
          // share a list of images by path
          val listPaths = call.arguments as List<String>
          val mediaContentBuilder = ShareMediaContent.Builder()
          listPaths.forEach { path ->
            val photo = SharePhoto.Builder().setImageUrl(Uri.parse(path)).build()
            mediaContentBuilder.addMedium(photo)
          }
          MessageDialog.show(this.activityPluginBinding?.activity, mediaContentBuilder.build())
          mapResult["code"] = 1
          mapResult["message"] = "share success"
          result.success(mapResult)
          return
        }
        "shareUrl" -> {

          // share an url
          val url = call.arguments as String?
          Log.e("frank", "shareUrl $url")
          System.out.println("frank shareUrl $url")
          val link = ShareLinkContent.Builder().setContentUrl(Uri.parse(url)).build()
          MessageDialog.show(this.activityPluginBinding?.activity, link)
          mapResult["code"] = 1
          mapResult["message"] = "share success"
          result.success(mapResult)
          return
        }
        "shareVideos" -> {
          Log.e("frank", "shareVideos")
          System.out.println("frank shareVideos")
          val listPaths = call.arguments as List<String>
          val mediaContentBuilder = ShareMediaContent.Builder()
          listPaths.forEach {
            val video = ShareVideo.Builder().setLocalUrl(Uri.parse(it)).build()
            mediaContentBuilder.addMedium(video)
          }
          MessageDialog.show(this.activityPluginBinding?.activity, mediaContentBuilder.build())
          mapResult["code"] = 1
          mapResult["message"] = "share success"
          result.success(mapResult)
          return
        }
        else -> {
          System.out.println("frank nothing")
          Log.e("Frank", "nothing")
          result.notImplemented()
        }
      }
    }catch (e: Exception){
      val message  = e.message ?: "Share fail"
      result.error("0",message,null)
    }

  }


  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }


  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    attachToActivity(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    disposeActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    attachToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    disposeActivity()
  }


  private fun attachToActivity(binding: ActivityPluginBinding) {
    activityPluginBinding = binding

  }

  private fun disposeActivity() {

    activityPluginBinding = null
  }
}
