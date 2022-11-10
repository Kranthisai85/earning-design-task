import 'package:flutter/material.dart';

import '../data/constants.dart';
import '../view/image_view.dart';

Widget images(List listPhotos, BuildContext context) {
  return GestureDetector(
    onTap: () {
      searchNode.unfocus();
      FocusScope.of(context).requestFocus(FocusNode());
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1,
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(4.0),
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 6.0,
          children: listPhotos.map((photoModel) {
            return GridTile(
                child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageView(
                              imgPath: photoModel['imagePath'],
                            )));
              },
              child: Hero(
                tag: photoModel['imagePath'],
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      photoModel['imagePath'],
                      height: 50,
                      width: 100,
                      fit: BoxFit.cover,
                    )),
              ),
            ));
          }).toList()),
    ),
  );
}
