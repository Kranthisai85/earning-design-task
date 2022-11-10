import 'dart:async';
import 'package:earningproject/data/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo_db;
import 'models/photos_model.dart';
import 'widget/widget.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> categories = ["All", "Trending", "Mountains", "Birds", "Bikes"];
  int noOfImageToLoad = 30;
  List<PhotosModel> photos = [];
  List isSelected = [true, false, false, false, false];
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<bool> keyboardSubscription;
  bool isKeyboard = false;

  getAllImages() async {
    var db = await mongo_db.Db.create(
        "mongodb+srv://username:qazwsxedc@cluster0.k4qilwf.mongodb.net/images?retryWrites=true&w=majority");
    await db.open();
    var coll = db.collection('all');
    collection = db.collection('all');
    allPhotos = await coll.find().toList();
    setState(() {});
  }

  filterCategory(String category) async {
    if (category == "All") {
      allPhotos = await collection.find().toList();
    } else {
      allPhotos =
          await collection.find({'category': category.toLowerCase()}).toList();
    }
    setState(() {});
  }

  searchFilter(String searchValue) async {
    allPhotos = await collection.find({
      'category': {r'$regex': searchValue.trim().toLowerCase()},
    }).toList();
    allPhotos += await collection.find({
      'keyword': {r'$regex': searchValue.trim().toLowerCase()}
    }).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllImages();
    var keyboardVisibilityController = KeyboardVisibilityController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        noOfImageToLoad = noOfImageToLoad + 30;
        getAllImages();
      }
    });
    keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboard = visible;
      setState(() {});
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 50,
                width: 100,
                child: Image.network("https://i.ibb.co/S3mrJFG/1.png"))
          ],
        ),
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xfff5f8fd).withOpacity(0.1),
                    border: Border.all(color: Colors.black, width: 0.3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        focusNode: searchNode,
                        controller: searchController,
                        onChanged: (value) {
                          if (value != "" || searchController.text != "") {
                            searchFilter(value);
                          } else {
                            getAllImages();
                          }
                        },
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.black26),
                            hintText: "Search keywords...",
                            border: InputBorder.none),
                      )),
                      const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 22)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 40,
                  child: KeyboardDismissOnTap(
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              searchNode.unfocus();
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                filterCategory(categories[index]);
                                isSelected = [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false
                                ];
                                isSelected[index] = true;
                              });
                            },
                            child: CategoriesTile(
                              selected: isSelected,
                              index: index,
                              categorie: categories[index],
                            ),
                          );
                        }),
                  ),
                ),
                const Divider(color: Colors.black, height: 1, thickness: 0.05),
                const SizedBox(
                  height: 20,
                ),
                allPhotos.isNotEmpty
                    ? KeyboardDismissOnTap(
                        child: GestureDetector(
                          onTap: () {
                            searchNode.unfocus();
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: ValueListenableBuilder(
                              valueListenable: refreshImages,
                              builder: (BuildContext context, bool refresh,
                                  Widget child) {
                                if (refresh == true) {
                                  print("refresh photos");
                                  refreshImages.value = false;
                                }
                                return images(allPhotos, context);
                              }),
                        ),
                      )
                    : const CircularProgressIndicator(),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
          !isKeyboard
              ? Positioned(
                  bottom: 0,
                  child: Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width,
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white12,
                          Colors.white24,
                          Colors.white30,
                          Colors.white38,
                          Colors.white54,
                          Colors.white60,
                          Colors.white70,
                          Colors.white.withOpacity(0.8),
                          Colors.white.withOpacity(0.9)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [
                          0,
                          0.1,
                          0.2,
                          0.3,
                          0.4,
                          0.5,
                          0.6,
                          0.7,
                          0.8
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String categorie;
  final List selected;
  final int index;

  const CategoriesTile(
      {Key key, @required this.categorie, this.index, this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: SizedBox(
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),
              Text(
                categorie ?? "Yo Yo",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Overpass'),
              ),
              const Spacer(),
              selected[index]
                  ? const Divider(
                      height: 1,
                      thickness: 3,
                      color: Colors.greenAccent,
                      indent: 10,
                      endIndent: 10,
                    )
                  : const SizedBox.shrink()
            ],
          )),
    );
  }
}
