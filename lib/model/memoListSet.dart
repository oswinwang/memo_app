import 'package:flutter/material.dart';
import 'package:memorize/model/memo.dart';
import 'package:memorize/model/memolist.dart';

class Memolistset extends ChangeNotifier{
  

  List<Memolist> Memolist_1 = [
    Memolist(
      listname: 'F R U I T',
      memolist: [
        Memo(vocabulary: 'apple', explain: '蘋果'),
        Memo(vocabulary: 'banana', explain: '香蕉'),
      ]
    ),

    Memolist(
      listname: 'N U M B E R',
      memolist: [
        Memo(vocabulary: '1', explain: '1'),
        Memo(vocabulary: '2', explain: '2'),
        Memo(vocabulary: '3', explain: '3'),
        Memo(vocabulary: '4', explain: '4'),
        Memo(vocabulary: '5', explain: '5'),
        Memo(vocabulary: '6', explain: '6'),
        Memo(vocabulary: '7', explain: '7'),
        Memo(vocabulary: '8', explain: '8'),
        Memo(vocabulary: '9', explain: '9'),
        Memo(vocabulary: '10', explain: '10'),
      ]
    ),
  ];

  String getListName(int index){
    return Memolist_1[index].listname;
  }
}