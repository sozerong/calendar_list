import 'package:flutter/material.dart';
import 'package:miniproject/component/video_button.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoSheet extends StatefulWidget {
  const VideoSheet({Key? key}) : super(key: key);

  @override
  State<VideoSheet> createState() => _VideoSheetState();
}

class _VideoSheetState extends State<VideoSheet> {
  late VideoPlayerController _controller;


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('asset/video/sample1.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown and dispose it
        setState(() {});
      });
  }
  initializeController() async {
    // ➌ 선택한 동영상으로 컨트롤러 초기화
    final videoController = VideoPlayerController.file(
      File(_controller as String),
    );

    await videoController.initialize();

    videoController
        .addListener(videoControllerListener); // ➊ 컨트롤러의 속성이 변경될 때마다 실행할 함수 등록

    setState(() {
      this._controller = videoController;
    });
  }
  void videoControllerListener() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: Stack(
            children: [
              VideoPlayer(
                _controller,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      renderTimeTextFromDuration(
                        // 동영상 현재 위치
                        _controller!.value.position,
                      ),
                      Expanded(
                        // Slider가 남는 공간을 모두 차지하도록 구현
                        child: Slider(
                          onChanged: (double val) {
                            _controller!.seekTo(
                              Duration(seconds: val.toInt()),
                            );
                          },
                          value: _controller!.value.position.inSeconds
                              .toDouble(),
                          min: 0,
                          max: _controller!.value.duration.inSeconds
                              .toDouble(),
                        ),
                      ),
                      renderTimeTextFromDuration(
                        // 동영상 총 길이
                        _controller!.value.duration,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                // ➋ 동영상 재생관련 아이콘 중앙에 위치
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(
                      onPressed: onReversePressed,
                      iconData: Icons.rotate_left,
                    ),
                    CustomIconButton(
                      onPressed: onPlayPressed,
                      iconData: _controller!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    CustomIconButton(
                      onPressed: onForwardPressed,
                      iconData: Icons.rotate_right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderTimeTextFromDuration(Duration duration) {
    return Text(
      '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
    );
  }


  void onReversePressed() {
    // ➊ 되감기 버튼 눌렀을 때 실행할 함수
    final currentPosition = _controller!.value.position; // 현재 실행 중인 위치

    Duration position = Duration(); // 0초로 실행 위치 초기화

    if (currentPosition.inSeconds > 3) {
      // 현재 실행위치가 3초보다 길때만 3초 빼기
      position = currentPosition - Duration(seconds: 3);
    }

    _controller!.seekTo(position);
  }

  void onForwardPressed() {
    // ➋ 앞으로 감기 버튼 눌렀을 때 실행할 함수
    final maxPosition = _controller!.value.duration; // 동영상 길이
    final currentPosition = _controller!.value.position;

    Duration position = maxPosition; // 동영상 길이로 실행 위치 초기화

    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      // 동영상 길이에서 3초를 뺀 값보다 현재 위치가 짧을 때만 3초 더하기
      position = currentPosition + Duration(seconds: 3);
    }

    _controller!.seekTo(position);
  }

  void onPlayPressed() {
    // ➌ 재생 버튼을 눌렀을 때 실행할 함수
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
  }
}
