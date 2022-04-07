import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
part 'dropdown_button_controller.freezed.dart';

@freezed
class DropdownButtonPageState with _$DropdownButtonPageState {
  const factory DropdownButtonPageState({
    int? selectFruit,
    String? selectFood,
  }) = _DropdownButtonPageState;
}

final dropdownButtonPageProvider = StateNotifierProvider.autoDispose<
    DropdownButtonPageController, DropdownButtonPageState>((ref) {
  return DropdownButtonPageController();
});

class DropdownButtonPageController
    extends StateNotifier<DropdownButtonPageState> {
  DropdownButtonPageController() : super(const DropdownButtonPageState());

  void selectedFruit(int? selectFruit) {
    state = state.copyWith(selectFruit: selectFruit);
  }

  void selectedFood(String? selectFood) {
    state = state.copyWith(selectFood: selectFood);
  }
}

const kFruit = {
  1: 'りんご',
  2: 'ぶどう',
  3: 'もも',
};
