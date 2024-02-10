import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_saver/file_saver.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';

Future<void> SaveImage(Uint8List? bytes) async {

  if(Platform.isAndroid == true || Platform.isIOS == true){
    saveToGallery(bytes!);
  }
}

saveToGallery(Uint8List bytes) async {
  await Gal.putImageBytes(bytes);

}
