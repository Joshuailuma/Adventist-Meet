import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SecondUserImage extends StatefulWidget {
  final String secondUserImageUrl;

  const SecondUserImage({required this.secondUserImageUrl});

  @override
  State<SecondUserImage> createState() => _SecondUserImageState();
}

class _SecondUserImageState extends State<SecondUserImage>
    with SingleTickerProviderStateMixin {
  late TransformationController transformationController;

  late AnimationController animationController;

  Animation<Matrix4>? animation;

  @override
  void initState() {
    super.initState();
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

  void resetAnimation() {
    animation = Matrix4Tween(
      begin: transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.ease));
    animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
      ),
      body: InteractiveViewer(
        transformationController: transformationController,
        clipBehavior: Clip.none,
        onInteractionEnd: (details) {
          resetAnimation();
        },
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
          color: Colors.black,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      '${widget.secondUserImageUrl}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
