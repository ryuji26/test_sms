import 'package:test_sms/controllers/dropdown_button_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DropdownButtonPage extends ConsumerWidget {
  //StatelessWidgetからConsumerWidgetに変更
  const DropdownButtonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFruit = ref.watch(
        dropdownButtonPageProvider.select((state) => state.selectFruit)); //追加
    final selectedFood = ref.watch(
        dropdownButtonPageProvider.select((state) => state.selectFood)); //追加
    return Scaffold(
      appBar: AppBar(
        title: const Text('DropdownButton'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('未選択'),
                value: selectedFood, //追加
                style: const TextStyle(fontSize: 16, color: Colors.black),
                icon: const Icon(Icons.expand_more),
                onChanged: ref
                    .read(dropdownButtonPageProvider.notifier)
                    .selectedFood, //追加
                items: ['焼肉', '寿司', 'パンケーキ']
                    .map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int?>(
                isExpanded: true,
                hint: const Text('未選択'),
                value: selectedFruit, //追加
                style: const TextStyle(fontSize: 16, color: Colors.black),
                icon: const Icon(Icons.expand_more),
                onChanged: ref
                    .read(dropdownButtonPageProvider.notifier)
                    .selectedFruit, //追加
                items: kFruit.keys.map<DropdownMenuItem<int?>>((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(kFruit[value].toString()),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
