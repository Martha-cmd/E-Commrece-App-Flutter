import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share/share.dart';
import 'package:zenith_stores/components/utils/show_snackBar.dart';
import 'package:zenith_stores/constants.dart';
import 'package:http/http.dart' as http;

class ImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height * 0.30);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.36,
      size.width * 0.70,
      size.height * 0.30,
    );
    path.lineTo(size.width, size.height * 0.25);

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = kSpiritedGreen;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.70);

    path.quadraticBezierTo(
      size.width * 0.40,
      size.height * 0.80,
      size.width * 0.75,
      size.height * 0.60,
    );
    path.quadraticBezierTo(
      size.width * 0.95,
      size.height * 0.48,
      size.width,
      size.height * 0.32,
    );

    path.lineTo(size.width, 20);
    path.quadraticBezierTo(size.width, 0, size.width - 20, 0);
    path.lineTo(20, 0);
    path.quadraticBezierTo(0, 0, 0, 20);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CurvePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CurvePainter oldDelegate) => false;
}

class ImageSliderScreen extends StatefulWidget {
  final List<dynamic> imageUrls;

  ImageSliderScreen({required this.imageUrls});

  @override
  _ImageSliderScreenState createState() => _ImageSliderScreenState();
}

class _ImageSliderScreenState extends State<ImageSliderScreen> {
  int _currentIndex = 0;

  void _shareImage(String imageUrl) {
    Share.share('Check out this image: $imageUrl');
  }

  Future<void> _saveImage(String imageUrl) async {
    try {
      var response = await http.get(Uri.parse(imageUrl));
      var filePath = await ImageGallerySaver.saveImage(Uint8List.fromList(response.bodyBytes));
      print('Image saved to: $filePath');
      return showSnack(context, 'Image saved');
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded( 
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(4),
                child: CarouselSlider(

                  items: widget.imageUrls.map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Center(
                                child: Image.network(
                                  url,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              Positioned(
                                top: 0.0,
                                right: 0.0,
                                child: Row(
                                  children: [
                                    IconButton(

                                      icon: Icon(Icons.download, color:kDarkGreenColor,),
                                      onPressed: () {
                                        _saveImage(url);

                                        // _shareImage(url);
                                      },
                                    ),
                                    SizedBox(width: 5,),
                                    IconButton(
                                      icon: Icon(Icons.share, color:kDarkGreenColor,),
                                      onPressed: () {
                                        _shareImage(url);
                                        // _shareImage(url);
                                      },

                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 1000,
                    aspectRatio: 5,
                    viewportFraction: 1,
                    autoPlay: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Text(
            '${_currentIndex + 1} /${widget.imageUrls.length}',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      );
  }

  // void _shareImage(String imageUrl) {
  //   Share.share('Check out this image: $imageUrl');
  // }
}
