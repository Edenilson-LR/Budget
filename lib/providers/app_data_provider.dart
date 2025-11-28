import 'package:flutter/foundation.dart';
import '../models/app_data.dart';
import '../services/storage_service.dart';

class AppDataProvider extends ChangeNotifier {
  AppData _appData = StorageService.getInitialData();
  bool _isLoading = true;

  AppData get appData => _appData;
  bool get isLoading => _isLoading;

  AppDataProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();
    _appData = await StorageService.loadData();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveData() async {
    await StorageService.saveData(_appData);
    notifyListeners();
  }

  Future<void> updateData(AppData newData) async {
    _appData = newData;
    await saveData();
  }
}

