import 'package:dream_tech_flutter/commonComponents/ImageFile.dart';
import 'package:dream_tech_flutter/components/LoadingScreen/LoadingViewModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../commonComponents/FontFamily.dart';
import '../../commonComponents/TextConstraints.dart';
import '../../model/DreamModel.dart';

class LoadingScreen extends StatefulWidget {
  final DreamModel dreamModel;

  const LoadingScreen({super.key, required this.dreamModel});

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  final LoadingViewModel viewModel = LoadingViewModel();
  @override
  void initState(){
    super.initState();
    viewModel.pushTitleAndContent(context,widget.dreamModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageFile.generateStory,
                width: 120,
                height: 120,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 50),
              Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: LinearProgressIndicator(
                  value: viewModel.progress.value,
                  borderRadius: BorderRadius.circular(16),
                  backgroundColor: Colors.grey,
                  color: Colors.blueAccent,
                  minHeight: 11,
                ),
              )),
              const SizedBox(height: 30),
              const Center(
                child: AnimatedLoadingText(
                  baseText: TextConstraints.generatingStory,
                  dotCount: 3,
                  animationDuration: Duration(milliseconds: 2000),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedLoadingText extends StatefulWidget {
  final String baseText;
  final int dotCount;
  final Duration animationDuration;

  const AnimatedLoadingText({
    super.key,
    this.baseText = TextConstraints.generatingStory,
    this.dotCount = 3,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  _AnimatedLoadingTextState createState() => _AnimatedLoadingTextState();
}

class _AnimatedLoadingTextState extends State<AnimatedLoadingText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dotAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration * widget.dotCount,
    )..repeat();

    _dotAnimation = IntTween(begin: 0, end: widget.dotCount).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dotAnimation,
      builder: (context, child) {
        String dots = '・' * _dotAnimation.value;
        return Text(
          '${widget.baseText}$dots',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            fontFamily: FontFamily.NotoSansJP
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}