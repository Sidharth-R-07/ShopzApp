import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SignInImageSlider extends StatefulWidget {
  const SignInImageSlider({super.key});

  @override
  State<SignInImageSlider> createState() => _SignInImageSliderState();
}

class _SignInImageSliderState extends State<SignInImageSlider> {
  int activeIndex = 0;

  final List singInImages = [
    "Asset/image/login_image_1.jpg",
    "Asset/image/login_image_2.jpg",
    "Asset/image/login_image_3.jpg"
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height,
            autoPlay: true,
            viewportFraction: 1,
            autoPlayAnimationDuration: const Duration(seconds: 2),
            onPageChanged: (index, reason) =>
                setState(() => activeIndex = index),
          ),
          itemCount: singInImages.length,
          itemBuilder: (context, index, realIndex) {
            final image = singInImages[index];

            return Stack(children: [
              Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height * .95,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black],
                        begin: Alignment.center,
                        end: Alignment.bottomCenter)),
              )
            ]);
          },
        ),
      
      ],
    );
  }
}
