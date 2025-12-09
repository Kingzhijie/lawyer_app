import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:croppy/croppy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../main.dart';
import '../http/net/net_utils.dart';
import 'loading.dart';

class ImageCropTool {

  static void cropImageAction(
      Uint8List? imageBytes, Function(Map<String, dynamic>? map) resultCallBack) {
    if (!kIsWeb) {
      croppyForceUseCassowaryDartImpl = true;
    }

    if (imageBytes == null) {
      resultCallBack(null);
      return;
    }

    showCupertinoImageCropper(
      currentContext,
      locale: const Locale('zh'),
      imageProvider: MemoryImage(imageBytes),
      // heroTag: 'image-$page',
      // initialData: _data[page],
      cropPathFn: aabbCropShapeFn,
      enabledTransformations: [
        Transformation.panAndScale,
        // Transformation.rotate,
        // Transformation.rotateZ,
        // Transformation.resize
      ],
      allowedAspectRatios: [const CropAspectRatio(width: 1, height: 1)],
      postProcessFn: (result) async {
        LoadingTool.showLoading(dismissOnTap: false);
        ui.Image resultImg = result.uiImage;
        ByteData? byteData =
            await resultImg.toByteData(format: ui.ImageByteFormat.png);
        Uint8List? bytes = byteData?.buffer.asUint8List();
        if (bytes != null) {
          File file = await _writeToFile(bytes, 'image_${DateTime.now().millisecondsSinceEpoch}.png');
          Map<String, dynamic>? imgs = await NetUtils.uploadSingleImage(file.path);
          LoadingTool.dismissLoading();
          resultCallBack(imgs);
        } else {
          LoadingTool.dismissLoading();
          resultCallBack(null);
        }
        return result;
      },
    );
  }

  static Future<File> _writeToFile(Uint8List bytes, String fileName) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }
}
