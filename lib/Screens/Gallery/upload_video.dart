import 'package:flutter/material.dart';
import 'package:konmoaref/Provider/gallery_provider.dart';
import 'package:konmoaref/Themes/theme.dart';
import 'package:provider/provider.dart';

class UploadVideo extends StatelessWidget {
  const UploadVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GalleryProvider>(context);

    return GestureDetector(
      onTap: () => provider.uploadFile(context),
      child: Container(
        decoration: BoxDecoration(
          color: kBackgroundIconColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.folder_open_rounded,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}
