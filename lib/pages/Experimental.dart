import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class testPage extends StatefulWidget {
  const testPage({super.key});
  @override
  State<testPage> createState() => _testPageState();
}

class _testPageState extends State<testPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: const [
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: Tile(index: 0),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: Tile(index: 1),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: Tile(index: 2),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: Tile(index: 3),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 3,
              mainAxisCellCount: 2,
              child: Tile(index: 4),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 2,
              child: Tile(index: 4),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 4,
              mainAxisCellCount: 4,
              child: Tile(index: 4),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 4,
              mainAxisCellCount: 4,
              child: Tile(index: 4),
            ),
          ],
        ),
      )
    );
  }
}
class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: backgroundColor ?? Colors.green,
      height: extent,
      child: Center(
        child: CircleAvatar(
          minRadius: 20,
          maxRadius: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Text('$index', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}


