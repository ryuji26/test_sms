import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchControllerProvider =
    ChangeNotifierProvider((ref) => SearchController());

class SearchController extends ChangeNotifier {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  var items = <String>[];

  void filterSearchResults(String query) {
    List<String> dummySearchList = <String>[];
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });

      items.clear();
      items.addAll(dummyListData);
      notifyListeners();
      return;
    } else {
      items.clear();
      items.addAll(duplicateItems);
      notifyListeners();
    }
  }
}
