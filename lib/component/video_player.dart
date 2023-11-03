import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniproject/component/video_button.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  // ➊ 동영상 위젯 생성
  final XFile video;
  final GestureTapCallback onNewVideoPressed; // 새로운 동영상 선택시 실행할 함수

  const CustomVideoPlayer({
    required this.video,
    required this.onNewVideoPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  bool showControls = false;
  VideoPlayerController? videoController;

  @override // _CustomVideoPlayerState에 추가
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    // covariant 키워드는 CustomVideoPlayer 클래스의 상속된 값도 허가해줍니다.
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.path != widget.video.path) {
      // ➊ 새로 선택한 동영상이 같은 동영상인지 확인
      initializeController();
    }
  }

  @override
  void initState() {
    super.initState();

    initializeController(); // ➋ 컨트롤러 초기화
  }

  initializeController() async {
    // ➌ 선택한 동영상으로 컨트롤러 초기화
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await videoController.initialize();

    videoController
        .addListener(videoControllerListener); // ➊ 컨트롤러의 속성이 변경될 때마다 실행할 함수 등록

    setState(() {
      this.videoController = videoController;
    });
  }

  void videoControllerListener() {
    setState(() {});
  }

  @override
  void dispose() {
    videoController?.removeListener(videoControllerListener); // ➋ listener 삭제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      // ➍ 동영상 컨트롤러가 준비 중일 때 로딩표시
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: AspectRatio(
        aspectRatio: videoController!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(
              videoController!,
            ),
            Align(
              // ➊ 오른쪽 위에 새 동영상 아이콘 위치
              alignment: Alignment.topRight,
              child: CustomIconButton(
                onPressed: widget.onNewVideoPressed,
                // 카메라 아이콘 선택시 새로운 동영상 선택 함수 실행
                iconData: Icons.photo_camera_back,
              ),
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
                      videoController!.value.position,
                    ),
                    Expanded(
                      // Slider가 남는 공간을 모두 차지하도록 구현
                      child: Slider(
                        onChanged: (double val) {
                          videoController!.seekTo(
                            Duration(seconds: val.toInt()),
                          );
                        },
                        value: videoController!.value.position.inSeconds
                            .toDouble(),
                        min: 0,
                        max: videoController!.value.duration.inSeconds
                            .toDouble(),
                      ),
                    ),
                    renderTimeTextFromDuration(
                      // 동영상 총 길이
                      videoController!.value.duration,
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
                    iconData: videoController!.value.isPlaying
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
    );
  }

  Widget renderTimeTextFromDuration(Duration duration) {
    return Text(
      '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
    );
  }

  void onReversePressed() {
    // ➊ 되감기 버튼 눌렀을 때 실행할 함수
    final currentPosition = videoController!.value.position; // 현재 실행 중인 위치

    Duration position = Duration(); // 0초로 실행 위치 초기화

    if (currentPosition.inSeconds > 3) {
      // 현재 실행위치가 3초보다 길때만 3초 빼기
      position = currentPosition - Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  void onForwardPressed() {
    // ➋ 앞으로 감기 버튼 눌렀을 때 실행할 함수
    final maxPosition = videoController!.value.duration; // 동영상 길이
    final currentPosition = videoController!.value.position;

    Duration position = maxPosition; // 동영상 길이로 실행 위치 초기화

    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      // 동영상 길이에서 3초를 뺀 값보다 현재 위치가 짧을 때만 3초 더하기
      position = currentPosition + Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  void onPlayPressed() {
    // ➌ 재생 버튼을 눌렀을 때 실행할 함수
    if (videoController!.value.isPlaying) {
      videoController!.pause();
    } else {
      videoController!.play();
    }
  }
}
