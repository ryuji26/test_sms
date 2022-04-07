import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_sms/controllers/searchLogic.dart';

class SearchBar extends ConsumerWidget {
  // @override
  // void initState() {
  //   items.addAll(duplicateItems);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = ref.watch(searchControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  onChanged: (value) {
                    searchController.filterSearchResults(value);
                  },
                  controller: searchController.editingController,
                  decoration: const InputDecoration(
                      labelText: "Search",
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0))))),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: searchController.items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${searchController.items[index]}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
