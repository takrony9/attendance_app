import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/auth.dart';

class ProfilePic extends StatefulWidget {
  final bool type;
  final String image;
  ProfilePic(this.type, this.image);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  final picker = ImagePicker();

  void _showImageSourceActionSheet(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text('Camera'),
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Gallery'),
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery);
              },
            )
          ],
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              _getImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_album),
            title: Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              _getImage(ImageSource.gallery);
            },
          ),
        ]),
      );
    }
  }

  Future _getImage(imageSource) async {
    final image = await picker.getImage(source: imageSource);
    File _image;
    setState(() {
      if (image != null) {
        _image = File(image.path);
        print(image.path.toString());
        Provider.of<Auth>(context, listen: false).updatePic(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context, listen: true);
    return Center(
      child: Stack(
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 4, color: Theme.of(context).scaffoldBackgroundColor),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 10))
                ],
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: user.image != null
                      ? Image.file(user.image).image
                      : widget.image == ""
                          ? CachedNetworkImageProvider(
                              "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg")
                          : CachedNetworkImageProvider(widget.image),
                )),
          ),
          Positioned(
              bottom: 0,
              right: widget.type ? 0 : 10,
              child: Container(
                height: widget.type ? 40 : 30,
                width: widget.type ? 40 : 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 4,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  color: widget.type
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
                child: widget.type
                    ? InkWell(
                        onTap: () => _showImageSourceActionSheet(context),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      )
                    : InkWell(),
              )),
        ],
      ),
    );
  }
}
