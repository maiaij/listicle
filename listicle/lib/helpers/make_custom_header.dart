// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:listicle/models/ListItem.dart';
import 'package:listicle/globals.dart' as globals;
import 'dart:math' as math;

class makeCustomHeader extends StatefulWidget {
  TabController controller;
  bool stateChanged;
  makeCustomHeader(this.controller, this.stateChanged,{ Key? key }) : super(key: key);

  @override
  _makeCustomHeaderState createState() => _makeCustomHeaderState();
}

class _makeCustomHeaderState extends State<makeCustomHeader> {

  @override
  Widget build(BuildContext context) {
    if(widget.stateChanged) {
      setState(() {
        globals.testLists[globals.selectedIndex].updateListLen();
      });
    }

    return SliverPersistentHeader(
      pinned: true,
      delegate: CustomHeader(
        top: Container(
          alignment: AlignmentDirectional.topStart,
            height: 150,
            padding: const EdgeInsets.all(20.0),
            child: Text.rich(
              TextSpan(
                
                children: <TextSpan>[
                  TextSpan(
                    text: globals.testLists[globals.selectedIndex].title,
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)
                  ),

                  TextSpan(
                    text: '\n${globals.testLists[globals.selectedIndex].listLen} Items\n\n',
                    style: const TextStyle(fontSize: 18)
                  ),

                  TextSpan(
                    text: globals.testLists[globals.selectedIndex].description,
                    style: const TextStyle(fontSize: 14)
                  ),
                ]
              ),
            ),
          ),
        bottom: TabBar(
          controller: widget.controller,
          isScrollable: true,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          labelColor: Colors.black,
          tabs: const <Tab>[
            Tab(text: 'ONGOING'),
            Tab(text: 'NOT STARTED'),
            Tab(text: 'BACKBURNER'),
            Tab(text: 'COMPLETED'),
            Tab(text: 'DROPPED'),
          ]
        )
      ),
    );
  }
}

class CustomHeader extends SliverPersistentHeaderDelegate {
  final TabBar bottom;
  final Widget top;

  CustomHeader({required this.bottom, required this.top});


  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      height: math.max(minExtent, maxExtent - shrinkOffset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 150, child: top),
          bottom,
       ]
      )
    );
  }

 @override
  double get maxExtent => kToolbarHeight + 150;

  @override
  double get minExtent => kToolbarHeight + 150;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}