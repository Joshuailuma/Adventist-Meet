import 'package:adventist_meet/components/constants.dart';
import 'package:adventist_meet/components/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:adventist_meet/chat_screens/sign_in_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

class ProfilePicture extends StatefulWidget {
  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

enum AppState { free, picked, cropped }

class _ProfilePictureState extends State<ProfilePicture>
    with SingleTickerProviderStateMixin {
  late AppState state;
  late TransformationController transformationController;
  late AnimationController animationController;
  Animation<Matrix4>? animation;

  XFile? _file;
  String imageId = Uuid().v4();
  bool isUploading = false;
  File? filee;
  String? idFromSP;
  String? sharedPreferencePhotoUrl;

  final storageRef = FirebaseStorage.instance.ref();

  @override
  void initState() {
    super.initState();
    getDetailsFromSP();
    state = AppState.free;
    transformationController = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    )..addListener(() => transformationController.value = animation!.value);
  }

  @override
  void dispose() {
    transformationController.dispose();
    animationController.dispose();
    super.dispose();
  }

  getDetailsFromSP() async {
    idFromSP = await MySharedPreferences().getId();
    sharedPreferencePhotoUrl = await MySharedPreferences().getPhotoUrl();
    setState(() {});
  }

  void resetAnimation() {
    animation = Matrix4Tween(
      begin: transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.ease));
    animationController.forward(from: 0);
  }

  cropImage() async {
    File? file = File(_file!
        .path); //Saving the file to our phone Dir. Solving file conflict issue on line 351 FileImage(file)

    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        cropStyle: CropStyle.circle,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: kPrimaryColor,
          toolbarWidgetColor: Colors.white,
          showCropGrid: true,
        ));
    if (croppedFile != null) {
      setState(() {
        filee = croppedFile;
        state = AppState.cropped;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_file == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: 18.75.sp,
            ),
          ),
          // title: Text('${provider.first.username}'),
          actions: [
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        title: Text(
                          'Change Profile picture',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.wavy,
                            color: Colors.blue,
                            fontSize: 14.5.sp,
                          ),
                        ),
                        // titleTextStyle: TextStyle(
                        //   color: Colors.black,
                        // ),
                        children: [
                          SimpleDialogOption(
                            child: Text(
                              'Image from Gallery',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10.7.sp,
                              ),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              XFile? _file = await ImagePicker().pickImage(
                                  source: ImageSource.gallery,
                                  maxHeight: 3000,
                                  maxWidth: 4000,
                                  imageQuality: 80);

                              setState(() {
                                this._file = _file;
                                state = AppState.picked;
                              });
                              cropImage();
                            },
                          ),
                          SizedBox(height: 0.8.h),
                          SimpleDialogOption(
                            child: Text(
                              'Photo from Camera',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10.7.sp,
                              ),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              XFile? _file = await ImagePicker().pickImage(
                                  source: ImageSource.camera,
                                  maxHeight: 675,
                                  maxWidth: 960,
                                  imageQuality: 100);

                              setState(() {
                                this._file = _file;
                              });

                              cropImage();
                            },
                          ),
                          SizedBox(height: 0.8.h),
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10.7.sp,
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: Padding(
                padding: EdgeInsets.only(right: 1.8.w),
                child: Icon(
                  Icons.edit,
                  size: 17.sp,
                ),
              ),
            ),
          ],
        ),
        body: InteractiveViewer(
          transformationController: transformationController,
          clipBehavior: Clip.none,
          onInteractionEnd: (details) {
            resetAnimation();
          },
          child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
            color: Colors.black,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        '${sharedPreferencePhotoUrl}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else if (_file != null && state == AppState.cropped) {
      File file = File(filee!
          .path); //Saving the file to our phone Dir. Solving file conflict issue on line 351 FileImage(file)

      return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 4.0.h, bottom: 12.0.h),
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: 4.0.h,
              ),
              isUploading //To show circular progress
                  ? Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: 1.0 / 1.0,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: FileImage(file),
                                  fit: BoxFit.cover,
                                )),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0.h),
                          child: Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ],
                    )
                  : InteractiveViewer(
                      transformationController: transformationController,
                      clipBehavior: Clip.none,
                      onInteractionEnd: (details) {
                        resetAnimation();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1.0 / 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: FileImage(file),
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                height: 3.0.h,
              ),
              Container(
                child: ElevatedButton(
                  // style: ButtonStyle(
                  //   shadowColor: Colors.accents,
                  // ),
                  onPressed: isUploading
                      ? null
                      : () async {
                          setState(() {
                            isUploading = true;
                          });
                          final tempDir =
                              await getTemporaryDirectory(); //get temporary directory as you can see
                          final tempDirPath =
                              tempDir.path; //The temporary directory path
                          Im.Image? decodedImage = Im.decodeImage(file
                              .readAsBytesSync()); //To ecode the image using image.dart package
                          final compressedImageFile = File(
                              '$tempDirPath/img_imageId.jpg')
                            ..writeAsBytesSync(Im.encodeJpg(decodedImage!,
                                quality:
                                    70)); //To decodedImagecompress the immage
                          setState(() {
                            file =
                                compressedImageFile; //Make our file in state to be the compressed file
                          });
                          Reference ref =
                              storageRef.child("tempDirPath/img_imageId.jpg");
                          UploadTask uploadTask = ref.putFile(
                              file); //To upload a file to firebase storage
                          TaskSnapshot storageSnapshot =
                              uploadTask.snapshot; //To get storage snapshot
                          var mediaUrl = await storageSnapshot.ref
                              .getDownloadURL()
                              .onError((error, stackTrace) {
                            print(error);
                            return 'There was an error';
                          });

                          setState(() {
                            usersRef.doc(idFromSP).update({
                              "photoUrl":
                                  mediaUrl, //To update photoUrl in firestore
                            });
                            isUploading = false;
                            state = AppState.free;
                            Navigator.pop(context);
                          });

                          await MySharedPreferences.setPhotoUrl(mediaUrl);
                        },
                  child: Text(
                    'Upload',
                    style: TextStyle(
                      fontSize: 12.6.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 6.0.h),
        child: Center(
          child: Text('Please go back'),
        ),
      ),
    );
  }
}
