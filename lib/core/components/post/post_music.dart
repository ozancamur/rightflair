import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/extensions/context.dart';

class PostMusicComponent extends StatefulWidget {
  final String? musicAudioUrl;
  final String? musicArtist;
  final String? musicTitle;
  const PostMusicComponent({
    super.key,
    this.musicAudioUrl,
    this.musicArtist,
    this.musicTitle,
  });

  @override
  State<PostMusicComponent> createState() => _PostMusicComponentState();
}

class _PostMusicComponentState extends State<PostMusicComponent> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _playAudio();
  }

  Future<void> _playAudio() async {
    final url = widget.musicAudioUrl;
    if (url == null || url.isEmpty) return;
    await _audioPlayer.play(UrlSource(url));
    setState(() => _isPlaying = true);
  }

  Future<void> _toggleAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.resume();
      setState(() => _isPlaying = true);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.musicAudioUrl == null || widget.musicAudioUrl == "")
        ? SizedBox.shrink()
        : Positioned(
            bottom: context.height * .1,
            left: context.width * .03,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.width * .03,
                vertical: context.width * .025,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.12),
                border: Border.all(color: Colors.white.withOpacity(.24)),
                borderRadius: BorderRadius.circular(36),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: context.width * .02,
                children: [
                  TextComponent(
                    text:
                        "${widget.musicTitle ?? "Song"} • ${widget.musicArtist ?? "Artist"}",
                    color: Colors.white,
                    size: FontSizeConstants.SMALL,
                    tr: false,
                  ),
                  GestureDetector(
                    onTap: _toggleAudio,
                    child: SvgPicture.asset(
                      _isPlaying ? AppIcons.SOUND_ON : AppIcons.SOUND_OFF,
                      color: Colors.white.withOpacity(.75),
                      height: context.height * .0175,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
