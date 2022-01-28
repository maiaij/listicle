// ignore_for_file: file_names, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listicle/globals.dart' as globals;
import 'package:listicle/helpers/List_Tile.dart';
import 'package:listicle/models/CustomUser.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/services/db_service.dart';
import 'package:provider/provider.dart';

// MAKE NOT STATEFUL
// the update can happen in add list page, no set state needed because the homepage reloads
// this object

class List_View extends StatefulWidget {
  const List_View({ Key? key }) : super(key: key);

  @override
  _List_ViewState createState() => _List_ViewState();
}

class _List_ViewState extends State<List_View> {
  final DBService dbService = DBService();

  bool loading = false;
  
  @override
  Widget build(BuildContext context) {

    final lists = Provider.of<List<Lists>>(context);

    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: lists.length,
      itemBuilder: (BuildContext context, int index){
        return List_Tile(mainList: lists[index], index: index);
      }, 
    );
  }
}