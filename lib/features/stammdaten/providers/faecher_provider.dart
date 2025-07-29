import 'package:flutter/foundation.dart';

import '../models/fach.dart';

class FaecherProvider with ChangeNotifier {
  List<Fach> _faecher = [];
  bool _isLoading = false;

  List<Fach> get faecher => _faecher;
  bool get isLoading => _isLoading;

  // TODO: Implementierung folgt in TASK-005
  Future<void> loadFaecher() async {
    _isLoading = true;
    notifyListeners();
    
    // Mock delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    _faecher = [
      Fach(
        id: '1',
        name: 'Softwareentwicklung',
        klassenIds: ['1'],
        erstelltAm: DateTime.now(),
      ),
      Fach(
        id: '2',
        name: 'Netzwerktechnik',
        klassenIds: ['1', '2'],
        erstelltAm: DateTime.now(),
      ),
    ];
    
    _isLoading = false;
    notifyListeners();
  }
}
