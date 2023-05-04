import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'inventory_repository.dart';

class InventoryViewModel extends ChangeNotifier {
  final InventoryRepository repo;
  final Size screenSize;

  InventoryViewModel(this.repo, this.screenSize) {
    fetchData();
  }

  Future<List<String>>? covers;

  void fetchData() {
    final imgSize = screenSize.width / 2;
    final size = (imgSize * 2.5).ceil();
    final length = ((screenSize.height ~/ imgSize)) * _numOfScreens * 2;

    covers = repo.fetchPets(length, size);
    notifyListeners();
  }
}

const _numOfScreens = 3;
