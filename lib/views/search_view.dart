import 'package:flutter/material.dart';
import '../viewmodels/map_view_model.dart';

class SearchView extends StatelessWidget {
  final MapViewModel mapViewModel;

  SearchView({required this.mapViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigate to Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                } else {
                  return await mapViewModel
                      .autocompleteSuggestions(textEditingValue.text);
                }
              },
              onSelected: (String selection) {
                Navigator.pop(context, selection);
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    hintText: 'Search Location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search, color: Colors.orange,),
                  ),
                  onSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
