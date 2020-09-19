import 'package:flutter/material.dart';
import 'package:memory_game/data/data.dart';
import 'package:memory_game/model/tile_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    pairs = getPairs();
    pairs.shuffle();
    visiblePairs = pairs;
    selected = true;

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        visiblePairs = getQuestions();
        selected = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //appBar: AppBar(title: Text("Memory Game"),),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$points",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue),
                  ),
                  Text(
                    "/800",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text("Points"),
              SizedBox(
                height: 20,
              ),
              points != 800
                  ? GridView(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisSpacing: 0.0,
                        maxCrossAxisExtent: 100,
                      ),
                      children: List.generate(visiblePairs.length, (index) {
                        return Tile(
                          imageAssetPath:
                              visiblePairs[index].getImageAssetPath(),
                          parent: this,
                          tileIndex: index,
                        );
                      }),
                    )
                  : Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Replay",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  String imageAssetPath;
  int tileIndex;
  _HomePageState parent;
  Tile({this.imageAssetPath, this.parent, this.tileIndex});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!selected) {
          if (selectedImageAssetPath != "") {
            if (selectedImageAssetPath ==
                pairs[widget.tileIndex].getImageAssetPath()) {
              //correct
              print("correct");
              selected = true;
              Future.delayed(const Duration(seconds: 1), () {
                points = points + 100;
                setState(() {});
                selected = false;
                widget.parent.setState(() {
                  pairs[selectedTileIndex].setImageAssetPath("");
                  pairs[widget.tileIndex].setImageAssetPath("");
                });
                selectedImageAssetPath = "";
              });
            } else {
              //wrong
              print("wrong");
              selected = true;
              Future.delayed(const Duration(seconds: 1), () {
                selected = false;
                widget.parent.setState(() {
                  pairs[selectedTileIndex].setIsSelected(false);
                  pairs[widget.tileIndex].setIsSelected(false);
                });
                selectedImageAssetPath = "";
              });
            }
          } else {
            selectedTileIndex = widget.tileIndex;
            selectedImageAssetPath =
                pairs[widget.tileIndex].getImageAssetPath();
          }
          setState(() {
            pairs[widget.tileIndex].setIsSelected(true);
          });
          //print("clicked me");
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: pairs[widget.tileIndex].getImageAssetPath() != ""
            ? Image.asset(pairs[widget.tileIndex].getIsSelected()
                ? pairs[widget.tileIndex].getImageAssetPath()
                : widget.imageAssetPath)
            : Image.asset("assets/correct.png"),
      ),
    );
  }
}
