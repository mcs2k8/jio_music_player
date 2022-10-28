import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:music_player/settings_screen/settings_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../managers/player_manager.dart';


class ReactionButton {
  String image;
  String name;
  Color color;
  String playlistKey;

  ReactionButton(this.image, this.name, this.playlistKey, {this.color = Colors.transparent});
}

class ReactionBar extends StatefulWidget {
  final List<ReactionButton> buttons;
  final String disabledButton;

  ReactionBar(this.buttons, this.disabledButton, {Key? key}) : super(key: key);

  @override
  createState() => ReactionBarState();
}

class ReactionBarState extends State<ReactionBar> with TickerProviderStateMixin {
  int durationAnimationBox = 500;
  int durationAnimationBtnLongPress = 150;
  int durationAnimationBtnShortPress = 500;
  int durationAnimationIconWhenDrag = 150;
  int durationAnimationIconWhenRelease = 200;


  var songListener;


  // For long press btn
  late AnimationController animControlBtnLongPress, animControlBox;
  late Animation zoomIconLikeInBtn, tiltIconLikeInBtn, zoomTextLikeInBtn;
  late Animation fadeInBox;
  late Animation moveRightGroupIcon;

  // late Animation pushIconLikeUp, pushIconLoveUp, pushIconHahaUp, pushIconWowUp, pushIconSadUp, pushIconAngryUp;
  // late Animation zoomIconLike, zoomIconLove, zoomIconHaha, zoomIconWow, zoomIconSad, zoomIconAngry;
  late List<Animation> zoomAnimations = [];
  late List<Animation> pushAnimations = [];

  // For short press btn
  late AnimationController animControlBtnShortPress;
  late Animation zoomIconLikeInBtn2, tiltIconLikeInBtn2;

  // For zoom icon when drag
  late AnimationController animControlIconWhenDrag;
  late AnimationController animControlIconWhenDragInside;
  late AnimationController animControlIconWhenDragOutside;
  late AnimationController animControlBoxWhenDragOutside;
  late Animation zoomIconChosen, zoomIconNotChosen;
  late Animation zoomIconWhenDragOutside;
  late Animation zoomIconWhenDragInside;
  late Animation zoomBoxWhenDragOutside;
  late Animation zoomBoxIcon;

  // For jump icon when release
  late AnimationController animControlIconWhenRelease;
  late Animation zoomIconWhenRelease, moveUpIconWhenRelease;
  // late Animation moveLeftIconLikeWhenRelease,
  //     moveLeftIconLoveWhenRelease,
  //     moveLeftIconHahaWhenRelease,
  //     moveLeftIconWowWhenRelease,
  //     moveLeftIconSadWhenRelease,
  //     moveLeftIconAngryWhenRelease;

  Duration durationLongPress = Duration(milliseconds: 250);
  late Timer holdTimer;
  bool isLongPress = false;
  bool isLiked = false;

  // 0 = nothing, 1 = favorite, 2 = energizing, 3 = relaxing, 4 = romance, 5 = sleep
  int whichIconUserChoose = 0;

  // 0 = nothing, 1 = favorite, 2 = energizing, 3 = relaxing, 4 = romance, 5 = sleep
  int currentIconFocus = 0;
  int previousIconFocus = 0;
  bool isDragging = false;
  bool isDraggingOutside = false;
  bool isJustDragInside = true;

  @override
  void initState() {
    super.initState();

    //print("REACTION: initState()");

    // Button Like
    initAnimationBtnLike();

    // Box and Icons
    initAnimationBoxAndIcons();

    // Icon when drag
    initAnimationIconWhenDrag();

    // Icon when drag outside
    initAnimationIconWhenDragOutside();

    // Box when drag outside
    initAnimationBoxWhenDragOutside();

    // Icon when first drag
    initAnimationIconWhenDragInside();

    // Icon when release
    initAnimationIconWhenRelease();

    setIconValue();

    if (mounted){
      songListener = () {
        setIconValue();
        if (mounted){
          setState(() {});
        }
      };
      PlayerManager.instance.currentSongNotifier.addListener(songListener);
    }
  }

  setIconValue() {
    //set value
    //print("REACTION: user chose 0");
    isLiked = false;
    whichIconUserChoose = 0;
    if (PlayerManager.instance.currentSongNotifier.value.song != null){
      if (LocalSongManager.instance.playlistListNotifier.value.favorites.any((element) => element.id == PlayerManager.instance.currentSongNotifier.value.song!.id)){
        whichIconUserChoose = 1;
        //print("REACTION: user chose 1");
        // onTapUpBtn(null);
      }
    }
    if (LocalSongManager.instance.playlistListNotifier.value.energizing != null && PlayerManager.instance.currentSongNotifier.value.song != null){
      if (LocalSongManager.instance.playlistListNotifier.value.energizing!.playlistSongs.any((element) => element.id == PlayerManager.instance.currentSongNotifier.value.song!.id)){
        whichIconUserChoose = 2;
        //print("REACTION: user chose 2");
        // onTapUpBtn(null);
      }
    }
    if (LocalSongManager.instance.playlistListNotifier.value.relaxing != null && PlayerManager.instance.currentSongNotifier.value.song != null){
      if (LocalSongManager.instance.playlistListNotifier.value.relaxing!.playlistSongs.any((element) => element.id == PlayerManager.instance.currentSongNotifier.value.song!.id)){
        whichIconUserChoose = 3;
        //print("REACTION: user chose 3");
        // onTapUpBtn(null);
      }
    }
    if (LocalSongManager.instance.playlistListNotifier.value.romance != null && PlayerManager.instance.currentSongNotifier.value.song != null){
      if (LocalSongManager.instance.playlistListNotifier.value.romance!.playlistSongs.any((element) => element.id == PlayerManager.instance.currentSongNotifier.value.song!.id)){
        whichIconUserChoose = 4;
        //print("REACTION: user chose 4");
        // onTapUpBtn(null);
      }
    }
    if (LocalSongManager.instance.playlistListNotifier.value.sleep != null && PlayerManager.instance.currentSongNotifier.value.song != null){
      if (LocalSongManager.instance.playlistListNotifier.value.sleep!.playlistSongs.any((element) => element.id == PlayerManager.instance.currentSongNotifier.value.song!.id)){
        whichIconUserChoose = 5;
        //print("REACTION: user chose 5");
        // onTapUpBtn(null);
      }
    }

  }

  initAnimationBtnLike() {
    // long press
    animControlBtnLongPress = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationBtnLongPress));
    zoomIconLikeInBtn =
        Tween(begin: 1.0, end: 0.85).animate(animControlBtnLongPress);
    tiltIconLikeInBtn =
        Tween(begin: 0.0, end: 0.2).animate(animControlBtnLongPress);
    zoomTextLikeInBtn =
        Tween(begin: 1.0, end: 0.85).animate(animControlBtnLongPress);

    zoomIconLikeInBtn.addListener(() {
      setState(() {});
    });
    tiltIconLikeInBtn.addListener(() {
      setState(() {});
    });
    zoomTextLikeInBtn.addListener(() {
      setState(() {});
    });

    // short press
    animControlBtnShortPress = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationBtnShortPress));
    zoomIconLikeInBtn2 =
        Tween(begin: 1.0, end: 0.2).animate(animControlBtnShortPress);
    tiltIconLikeInBtn2 =
        Tween(begin: 0.0, end: 0.8).animate(animControlBtnShortPress);

    zoomIconLikeInBtn2.addListener(() {
      setState(() {});
    });
    tiltIconLikeInBtn2.addListener(() {
      setState(() {});
    });
  }

  initAnimationBoxAndIcons() {
    animControlBox = AnimationController(
        vsync: this, duration: Duration(milliseconds: durationAnimationBox));

    // General
    moveRightGroupIcon = Tween(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 1.0)),
    );
    moveRightGroupIcon.addListener(() {
      setState(() {});
    });

    // Box
    fadeInBox = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.5)),
    );
    fadeInBox.addListener(() {
      setState(() {});
    });

    // Icons
    for (var button in widget.buttons) {
      pushAnimations.add(Tween(begin: 30.0, end: 60.0).animate(
        CurvedAnimation(
            parent: animControlBox,
            curve: Interval(0.0 + 0.1 * widget.buttons.indexOf(button),
                0.2 + 0.1 * widget.buttons.indexOf(button))),
      ));
      zoomAnimations.add(Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animControlBox,
            curve: Interval(0.0 + 0.1 * widget.buttons.indexOf(button),
                0.2 + 0.1 * widget.buttons.indexOf(button))),
      ));
    }
    for (var anim in pushAnimations) {
      anim.addListener(() {
        setState(() {});
      });
    }
    for (var anim in zoomAnimations) {
      anim.addListener(() {
        setState(() {});
      });
    }
  }

  initAnimationIconWhenDrag() {
    animControlIconWhenDrag = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));

    zoomIconChosen =
        Tween(begin: 1.0, end: 1.8).animate(animControlIconWhenDrag);
    zoomIconNotChosen =
        Tween(begin: 1.0, end: 0.8).animate(animControlIconWhenDrag);
    zoomBoxIcon =
        Tween(begin: 50.0, end: 40.0).animate(animControlIconWhenDrag);

    zoomIconChosen.addListener(() {
      setState(() {});
    });
    zoomIconNotChosen.addListener(() {
      setState(() {});
    });
    zoomBoxIcon.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDragOutside() {
    animControlIconWhenDragOutside = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomIconWhenDragOutside =
        Tween(begin: 0.8, end: 1.0).animate(animControlIconWhenDragOutside);
    zoomIconWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  initAnimationBoxWhenDragOutside() {
    animControlBoxWhenDragOutside = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomBoxWhenDragOutside =
        Tween(begin: 40.0, end: 50.0).animate(animControlBoxWhenDragOutside);
    zoomBoxWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDragInside() {
    animControlIconWhenDragInside = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomIconWhenDragInside =
        Tween(begin: 1.0, end: 0.8).animate(animControlIconWhenDragInside);
    zoomIconWhenDragInside.addListener(() {
      setState(() {});
    });
    animControlIconWhenDragInside.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isJustDragInside = false;
      }
    });
  }

  initAnimationIconWhenRelease() {
    animControlIconWhenRelease = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenRelease));

    zoomIconWhenRelease = Tween(begin: 1.8, end: 0.0).animate(CurvedAnimation(
        parent: animControlIconWhenRelease, curve: Curves.decelerate));

    moveUpIconWhenRelease = Tween(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));

    // moveLeftIconLikeWhenRelease = Tween(begin: 20.0, end: 10.0).animate(
    //     CurvedAnimation(
    //         parent: animControlIconWhenRelease, curve: Curves.decelerate));
    // moveLeftIconLoveWhenRelease = Tween(begin: 68.0, end: 10.0).animate(
    //     CurvedAnimation(
    //         parent: animControlIconWhenRelease, curve: Curves.decelerate));
    // moveLeftIconHahaWhenRelease = Tween(begin: 116.0, end: 10.0).animate(
    //     CurvedAnimation(
    //         parent: animControlIconWhenRelease, curve: Curves.decelerate));
    // moveLeftIconWowWhenRelease = Tween(begin: 164.0, end: 10.0).animate(
    //     CurvedAnimation(
    //         parent: animControlIconWhenRelease, curve: Curves.decelerate));
    // moveLeftIconSadWhenRelease = Tween(begin: 212.0, end: 10.0).animate(
    //     CurvedAnimation(
    //         parent: animControlIconWhenRelease, curve: Curves.decelerate));
    // moveLeftIconAngryWhenRelease = Tween(begin: 260.0, end: 10.0).animate(
    //     CurvedAnimation(
    //         parent: animControlIconWhenRelease, curve: Curves.decelerate));

    zoomIconWhenRelease.addListener(() {
      setState(() {});
    });
    moveUpIconWhenRelease.addListener(() {
      setState(() {});
    });

    // moveLeftIconLikeWhenRelease.addListener(() {
    //   setState(() {});
    // });
    // moveLeftIconLoveWhenRelease.addListener(() {
    //   setState(() {});
    // });
    // moveLeftIconHahaWhenRelease.addListener(() {
    //   setState(() {});
    // });
    // moveLeftIconWowWhenRelease.addListener(() {
    //   setState(() {});
    // });
    // moveLeftIconSadWhenRelease.addListener(() {
    //   setState(() {});
    // });
    // moveLeftIconAngryWhenRelease.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    //print("REACTION: called dispose()");
    animControlBtnLongPress.dispose();
    animControlBox.dispose();
    animControlIconWhenDrag.dispose();
    animControlIconWhenDragInside.dispose();
    animControlIconWhenDragOutside.dispose();
    animControlBoxWhenDragOutside.dispose();
    animControlIconWhenRelease.dispose();
    PlayerManager.instance.currentSongNotifier.removeListener(songListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> icons = [];
    for (var button in widget.buttons) {
      var index = widget.buttons.indexOf(button) + 1;
      icons.add(Container(
        child: whichIconUserChoose == index && !isDragging
            ? Container(
                child: Transform.scale(
                  child: Image.asset(
                    button.image,
                    width: 40.0,
                    height: 40.0,
                  ),
                  scale: this.zoomIconWhenRelease.value,
                ),
                margin: EdgeInsets.only(
                  top: processTopPosition(this.moveUpIconWhenRelease.value),
                  left: this.moveUpIconWhenRelease.value,
                ),
              )
            : Container(),
      ));
    }
    List<Widget> structure = [
      Stack(
        children: <Widget>[
          // Box
          renderBox(),

          // Icons
          renderIcons(),
        ],
        alignment: Alignment.bottomCenter,
      ),

      // Button like
      renderBtnLike(),
    ];
    // structure.addAll(icons);
    return GestureDetector(
      child: Column(
        children: <Widget>[
          // Just a top space
          Container(
            width: 100,
            height: 100.0,
          ),

          // main content
          Container(
            child: Stack(
              children: structure,
            ),
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            // Area of the content can drag
            // decoration:  BoxDecoration(border: Border.all(color: Colors.grey)),
            width: 300,
            height: 350.0,
          ),
        ],
      ),
      onHorizontalDragEnd: onHorizontalDragEndBoxIcon,
      onHorizontalDragUpdate: onHorizontalDragUpdateBoxIcon,
    );
  }

  Widget renderBox() {
    return Opacity(
      child: Container(
        decoration: BoxDecoration(
          color: ThemeManager.instance.themeNotifier.value.mutedColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30.0),
          // border: Border.all(color: ThemeManager.instance.themeNotifier.value.lightMutedColor, width: 0.3),
          // boxShadow: [
          //   BoxShadow(
          //       color: Colors.black,
          //       blurRadius: 5.0,
          //       // LTRB
          //       offset: Offset.lerp(Offset(0.0, 0.0), Offset(0.0, 0.5), 10.0)!),
          // ],
        ),
        width: 60.0 + 50.0 * widget.buttons.length,
        height: isDragging
            ? (previousIconFocus == 0 ? this.zoomBoxIcon.value : 40.0)
            : isDraggingOutside
                ? this.zoomBoxWhenDragOutside.value
                : 50.0,
        margin: EdgeInsets.only(bottom: 130.0, left: 10.0),
      ),
      opacity: this.fadeInBox.value,
    );
  }

  Widget renderIcons() {
    List<Widget> icons = [];
    for (ReactionButton button in widget.buttons) {
      int index = widget.buttons.indexOf(button) + 1;
      int indexwithoutOneAdded = widget.buttons.indexOf(button);
      icons.add(Transform.scale(
        child: Container(
          child: Column(
            children: <Widget>[
              currentIconFocus == index
                  ? Container(
                      child: Text(
                        button.name,
                        style: TextStyle(fontSize: 8.0, color: ThemeManager.instance.themeNotifier.value.lightMutedColor),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: ThemeManager.instance.themeNotifier.value.darkMutedColor.withOpacity(0.9),
                      ),
                      padding: EdgeInsets.only(
                          left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                      margin: EdgeInsets.only(bottom: 8.0),
                    )
                  : Container(),
              Image.asset(
                button.image,
                width: 40.0,
                height: 40.0,
                fit: BoxFit.contain,
              ),
            ],
          ),
          margin: EdgeInsets.only(
              bottom: pushAnimations[indexwithoutOneAdded].value),
          // width: 40.0,
          height: currentIconFocus == index ? 70.0 : 40.0,
        ),
        scale: isDragging
            ? (currentIconFocus == index
                ? this.zoomIconChosen.value
                : (previousIconFocus == index
                    ? this.zoomIconNotChosen.value
                    : isJustDragInside
                        ? this.zoomIconWhenDragInside.value
                        : 0.8))
            : isDraggingOutside
                ? this.zoomIconWhenDragOutside.value
                : this.zoomAnimations[indexwithoutOneAdded].value,
      ));
    }
    return Container(
      child: Row(
        children: icons,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      width: 60.0 + 50.0 * widget.buttons.length,
      height: 250.0,
      margin: EdgeInsets.only(left: this.moveRightGroupIcon.value, top: 50.0),
      // uncomment here to see area of draggable
      // color: Colors.amber.withOpacity(0.5),
    );
  }

  Widget renderBtnLike() {
    return Container(
      child: GestureDetector(
        onTapDown: onTapDownBtn,
        onTapUp: onTapUpBtn,
        onTap: onTapBtn,
        child: Container(
          child: Row(
            children: <Widget>[
              // Icon like
              Transform.scale(
                child: Transform.rotate(
                  child: ValueListenableBuilder<ColorsState>(valueListenable: PlayerManager.instance.colorNotifier, builder: (_, colorState, __){
                    return Image.asset(
                      getImageIconBtn(),
                      width: 25.0,
                      height: 25.0,
                      fit: BoxFit.contain,
                      color: getTintColorIconBtn(colorState),
                      colorBlendMode: BlendMode.srcIn,
                    );
                  }),
                  angle: !isLongPress
                      ? handleOutputRangeTiltIconLike(tiltIconLikeInBtn2.value)
                      : tiltIconLikeInBtn.value,
                ),
                scale: !isLongPress
                    ? handleOutputRangeZoomInIconLike(zoomIconLikeInBtn2.value)
                    : zoomIconLikeInBtn.value,
              ),

            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ),
          padding: EdgeInsets.all(10.0),
          color: Colors.transparent,
        ),
      ),
      margin: EdgeInsets.only(top: 190.0),
    );
  }

  String getTextBtn() {
    if (isDragging) {
      return widget.buttons[0].name;
    }
    return widget.buttons[whichIconUserChoose - 1].name;
  }

  Color getColorTextBtn() {
    if ((!isLongPress && isLiked)) {
      return Color(0xff3b5998);
    } else if (!isDragging) {
      switch (whichIconUserChoose) {
        case 1:
          return Color(0xff3b5998);
        case 2:
          return Color(0xffED5167);
        case 3:
        case 4:
        case 5:
          return Color(0xffFFD96A);
        case 6:
          return Color(0xffF6876B);
        default:
          return Colors.grey;
      }
    } else {
      return Colors.grey;
    }
  }

  String getImageIconBtn() {
    if (!isLongPress && isLiked) {
      return widget.buttons[0].image;
      // return 'images/ic_like_fill.png';
    } else if (!isDragging) {
      if (whichIconUserChoose == 0) return widget.disabledButton;
      return widget.buttons[whichIconUserChoose - 1].image;
    } else {
      return widget.disabledButton;
      // return 'images/ic_like.png';
    }
  }

  Color? getTintColorIconBtn(ColorsState state) {
    // if (!isLongPress && isLiked) {
    //     return ThemeManager.instance.themeNotifier.value.lightVibrantColor;
    //   }
    // return null;
    if (!isLongPress && isLiked) {
      return null;
    } else if (!isDragging && whichIconUserChoose != 0) {
      return null;
    } else {
      return state.lightVibrantColor;
    }
  }

  double processTopPosition(double value) {
    // margin top 100 -> 40 -> 160 (value from 180 -> 0)
    if (value >= 120.0) {
      return value - 80.0;
    } else {
      return 160.0 - value;
    }
  }

  Color getColorBorderBtn() {
    return Colors.transparent;
  }

  void onHorizontalDragEndBoxIcon(DragEndDetails dragEndDetail) {
    isDragging = false;
    isDraggingOutside = false;
    isJustDragInside = true;
    previousIconFocus = 0;
    currentIconFocus = 0;

    onTapUpBtn(null);
  }

  void onHorizontalDragUpdateBoxIcon(DragUpdateDetails dragUpdateDetail) {
    // return if the drag is drag without press button
    if (!isLongPress) return;

    // the margin top the box is 150
    // and plus the height of toolbar and the status bar
    // so the range we check is about 200 -> 500

    if (dragUpdateDetail.globalPosition.dy >= 200 &&
        dragUpdateDetail.globalPosition.dy <= 500) {
      isDragging = true;
      isDraggingOutside = false;

      if (isJustDragInside && !animControlIconWhenDragInside.isAnimating) {
        animControlIconWhenDragInside.reset();
        animControlIconWhenDragInside.forward();
      }
      int item = math.min(
          ((dragUpdateDetail.globalPosition.dx - 30) / 340 * widget.buttons.length)
              .floor(),
          widget.buttons.length - 1) + 1;
      if (currentIconFocus != item){
        handleWhenDragBetweenIcon(item);
      }
    } else {
      whichIconUserChoose = 0;
      previousIconFocus = 0;
      currentIconFocus = 0;
      isJustDragInside = true;

      if (isDragging && !isDraggingOutside) {
        isDragging = false;
        isDraggingOutside = true;
        animControlIconWhenDragOutside.reset();
        animControlIconWhenDragOutside.forward();
        animControlBoxWhenDragOutside.reset();
        animControlBoxWhenDragOutside.forward();
      }
    }
  }

  void handleWhenDragBetweenIcon(int currentIcon) {
    playSound('icon_focus.mp3');
    whichIconUserChoose = currentIcon;
    previousIconFocus = currentIconFocus;
    currentIconFocus = currentIcon;
    animControlIconWhenDrag.reset();
    animControlIconWhenDrag.forward();
  }

  void onTapDownBtn(TapDownDetails tapDownDetail) {
    holdTimer = Timer(durationLongPress, showBox);
  }

  void onTapUpBtn(TapUpDetails? tapUpDetail) {
    if (isLongPress) {
      AudioModel? song = PlayerManager.instance.currentSongNotifier.value.song;
      if (whichIconUserChoose == 0) {
        playSound('box_down.mp3');
      } else {
        playSound('icon_choose.mp3');
      }
      switch (whichIconUserChoose){
        case 0:
          Fluttertoast.showToast(msg: "Nothing chosen");
          if (song != null) LocalSongManager.instance.removeFromAllFavourites(song.id);
          break;
        case 1:
          Fluttertoast.showToast(msg: "Add to favourites");
          if (song != null) LocalSongManager.instance.addToFavoritesPlaylist(song, "favorites");
          break;
        case 2:
          Fluttertoast.showToast(msg: "Add to energizing");
          if (song != null) LocalSongManager.instance.addToFavoritesPlaylist(song, "energizing");
          break;
        case 3:
          Fluttertoast.showToast(msg: "Add to relaxing");
          if (song != null) LocalSongManager.instance.addToFavoritesPlaylist(song, "relaxing");
          break;
        case 4:
          Fluttertoast.showToast(msg: "Add to romance");
          if (song != null) LocalSongManager.instance.addToFavoritesPlaylist(song, "romance");
          break;
        case 5:
          Fluttertoast.showToast(msg: "Add to sleeping");
          if (song != null) LocalSongManager.instance.addToFavoritesPlaylist(song, "sleep");
          break;
      }
    }

    Timer(Duration(milliseconds: durationAnimationBox), () {
      isLongPress = false;
    });

    holdTimer.cancel();

    animControlBtnLongPress.reverse();

    setReverseValue();
    animControlBox.reverse();

    animControlIconWhenRelease.reset();
    animControlIconWhenRelease.forward();
  }

  // when user short press the button
  void onTapBtn() {
    if (!isLongPress) {
      AudioModel? song = PlayerManager.instance.currentSongNotifier.value.song;
      if (whichIconUserChoose == 0) {
        isLiked = !isLiked;
      } else {
        whichIconUserChoose = 0;
        Fluttertoast.showToast(msg: "Cancelled choice");
        if (song != null) LocalSongManager.instance.removeFromAllFavourites(song.id);
      }
      if (isLiked) {
        Fluttertoast.showToast(msg: "Add to favourites");
        if (song != null) LocalSongManager.instance.addToFavoritesPlaylist(song, "favorites");
        playSound('short_press_like.mp3');
        animControlBtnShortPress.forward();
      } else {
        Fluttertoast.showToast(msg: "Cancelled choice");
        if (song != null) LocalSongManager.instance.removeFromAllFavourites(song.id);
        animControlBtnShortPress.reverse();
      }
    }
  }

  double handleOutputRangeZoomInIconLike(double value) {
    if (value >= 0.8) {
      return value;
    } else if (value >= 0.4) {
      return 1.6 - value;
    } else {
      return 0.8 + value;
    }
  }

  double handleOutputRangeTiltIconLike(double value) {
    if (value <= 0.2) {
      return value;
    } else if (value <= 0.6) {
      return 0.4 - value;
    } else {
      return -(0.8 - value);
    }
  }

  void showBox() {
    playSound('box_up.mp3');
    isLongPress = true;

    animControlBtnLongPress.forward();

    setForwardValue();
    animControlBox.forward();
  }

  // We need to set the value for reverse because if not
  // the angry-icon will be pulled down first, not the like-icon
  void setReverseValue() {
    // Icons
    for (var button in widget.buttons) {
      pushAnimations.add(Tween(begin: 30.0, end: 60.0).animate(
        CurvedAnimation(
            parent: animControlBox,
            curve: Interval(
                0.0 +
                    0.1 *
                        (widget.buttons.length -
                            widget.buttons.indexOf(button)),
                0.2 +
                    0.1 *
                        (widget.buttons.length -
                            widget.buttons.indexOf(button)))),
      ));
      zoomAnimations.add(Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animControlBox,
            curve: Interval(
                0.0 +
                    0.1 *
                        (widget.buttons.length -
                            widget.buttons.indexOf(button)),
                0.2 +
                    0.1 *
                        (widget.buttons.length -
                            widget.buttons.indexOf(button)))),
      ));
    }
  }

  // When set the reverse value, we need set value to normal for the forward
  void setForwardValue() {
    // Icons
    for (var button in widget.buttons) {
      pushAnimations.add(Tween(begin: 30.0, end: 60.0).animate(
        CurvedAnimation(
            parent: animControlBox,
            curve: Interval(0.0 + 0.1 * widget.buttons.indexOf(button),
                0.2 + 0.1 * widget.buttons.indexOf(button))),
      ));
      zoomAnimations.add(Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animControlBox,
            curve: Interval(0.0 + 0.1 * widget.buttons.indexOf(button),
                0.2 + 0.1 * widget.buttons.indexOf(button))),
      ));
    }
  }

  Future playSound(String nameSound) async {
    // Sometimes multiple sound will play the same time, so we'll stop all before play the newest
    // await audioPlayer.stop();
    // final file = File('${(await getTemporaryDirectory()).path}/$nameSound');
    // await file.writeAsBytes((await loadAsset(nameSound)).buffer.asUint8List());
    // await audioPlayer.play(file.path, isLocal: true);
  }

  Future loadAsset(String nameSound) async {
    return await rootBundle.load('sounds/$nameSound');
  }
}
