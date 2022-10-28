import 'package:flutter/material.dart';
import 'package:music_player/settings_screen/settings_screen.dart';

import '../managers/theme_manager.dart';

class AlbumStripe extends StatelessWidget {
  String title;
  Future future;
  bool shouldOverlap;
  GestureTapCallback onGeneralTap;
  Function onItemTap;

  AlbumStripe({required this.title, required this.future, this.shouldOverlap = false, required this.onGeneralTap, required this.onItemTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: shouldOverlap ? 110 : 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                EmptyCard(shouldOverlap: shouldOverlap,),
                EmptyCard(shouldOverlap: shouldOverlap,),
                EmptyCard(shouldOverlap: shouldOverlap,),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Container();
        } else {
          List albums = snapshot.data as List;
          return InkWell(
              onTap: onGeneralTap,
              child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "$title",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Text("more"),
                  Icon(Icons.keyboard_arrow_right_rounded)
                ],
              ),

              Padding(padding: EdgeInsets.only(top: 8.0)),
              Container(
                height: albums.isEmpty ? 80 : shouldOverlap ? 110 : 170,
                child:  albums.isEmpty ? Center(child: Text("Nothing here~"),) : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: albums.length,
                      itemBuilder: (context, index) {
                        //4 properties: cover_img_url, title, id, source_url
                        // return EmptyCard(shouldOverlap: shouldOverlap);
                        Widget column = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(

                              shadowColor: Colors.black,
                              color: Colors.transparent,
                              elevation: shouldOverlap ? 10 : 1,
                              child: Container(
                                width: shouldOverlap ? 90: 120,
                                height: shouldOverlap ? 90 : 120,
                                child: shouldOverlap ? ClipOval(child: Image.network(
                                  albums[index]['cover_img_url'],
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),) : ClipRRect(
                                    borderRadius: BorderRadius.circular(4.0),
                                    child: Image.network(
                                      albums[index]['cover_img_url'],
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                            Container(
                              width: 120,
                              child: shouldOverlap ? Container() : Text(
                                '${albums[index]['title']}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        );
                        if (shouldOverlap) {
                          return SizedOverflowBox(
                            alignment: Alignment.centerLeft,
                            size: const Size(30, 100),
                            child: column,
                          );
                        } else {
                          return InkWell(
                              onTap: () {
                                onItemTap(index);
                              },
                              child:column);
                        }
                      }),
              )
            ],
          ));
          // return ;
        }
      },
    );
  }
}

class EmptyCard extends StatelessWidget {
  bool shouldOverlap;

  EmptyCard({required this.shouldOverlap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorState state = ThemeManager.instance.themeNotifier.value;
    if (shouldOverlap){
     return SizedOverflowBox(
         alignment: Alignment.centerLeft,
         size: const Size(30, 100),
         child: ClipOval(
           child: Container(
             width: 120,
             height: 90,
             decoration: BoxDecoration(gradient: RadialGradient(colors: [lighten(state.darkMutedColor, 30), lighten(state.darkMutedColor, 10)], stops: [0.0, 1.0])),
           ),
         )
     );
    }
    return Column(
      children: [
        Card(
          color: lighten(
              ThemeManager.instance.themeNotifier.value.darkMutedColor, 10),
          child: Container(
            width: 120,
            height: 120,
          ),
        ),
        Container(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: 120,
            height: 32,
            color: lighten(
                ThemeManager.instance.themeNotifier.value.darkMutedColor, 10),
          ),
        ),
        Container(height: 10),
      ],
    );
  }
}
