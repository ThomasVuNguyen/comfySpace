import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_saver/file_saver.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';

Future<void> SaveImage(String name, Uint8List? bytes, ) async {

  if(Platform.isAndroid == true || Platform.isIOS == true){
    saveToGallery(bytes!);
  }
  await FileSaver.instance.saveFile(
    name: name,
    bytes: bytes,
    ext :"jpeg",
    mimeType: MimeType.jpeg,
  );
}

saveToGallery(Uint8List bytes) async {
  if (bytes != null) {
    await Gal.putImageBytes(bytes);
    /*await Permission.photos.onGrantedCallback(() async{
      await Permission.mediaLibrary.onGrantedCallback(() async{
        final result = await ImageGallerySaver.saveImage(name: 'img', bytes);
        print(result);
        print('img saved');

        //network
      }).onDeniedCallback(() => print('denied'));
    });*/

  }
  else{
    print('EMPTY PIC');
  }
}
