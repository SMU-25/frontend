import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedBabyIdProvider =
    StateNotifierProvider<SelectedBabyIdNotifier, int?>(
      (ref) => SelectedBabyIdNotifier(),
    );

class SelectedBabyIdNotifier extends StateNotifier<int?> {
  SelectedBabyIdNotifier() : super(null);
  void set(int? id) => state = id;
}
