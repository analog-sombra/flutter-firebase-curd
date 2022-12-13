import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final multiSelectState = ChangeNotifierProvider.autoDispose<MultiSelectState>(
  (ref) => MultiSelectState(),
);

class MultiSelectState extends ChangeNotifier {
  bool isMultiSelect = false;

  List userDelete = [];
  List<bool> selectedItem = [];
  void setMultSel(bool val) {
    isMultiSelect = val;
    notifyListeners();
  }

  void init(int val) {
    selectedItem = [];
    for (int i = 0; i < val; i++) {
      selectedItem.add(false);
    }
  }

  void setValue(int index, bool val, id, imageUrl) {
    selectedItem[index] = val;
    final user = {"id": id, "imageUrl": imageUrl};

    if (val) {
      userDelete.add(user);
    } else {
      userDelete.removeWhere((element) => element["id"] == id);
    }
    if (!selectedItem.contains(true)) {
      isMultiSelect = false;
    }

    notifyListeners();
  }
}
