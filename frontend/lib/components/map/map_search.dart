import 'package:flutter/material.dart';

String searchText = '';
List<String> items = ['item1', 'item2', 'item3', 'item4'];
List<String> itemContents = [
  'Item 1 Contents',
  'Item 2 Contents',
  'Item 3 Contents',
  'Item 4 Contents',
];

class MapSearch extends StatefulWidget {
  final Function(double, double) onLocationSelected;

  MapSearch({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  _MapSearchState createState() => _MapSearchState();
}

class _MapSearchState extends State<MapSearch> {
  final TextEditingController _controller = TextEditingController();

  void cardClickEvent(BuildContext context, int index) {
    String content = itemContents[index];
    print('다음 데이터를 받았다! $content');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: '검색어를 입력해주세요.',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              if (searchText.isNotEmpty &&
                  !items[index]
                      .toLowerCase()
                      .contains(searchText.toLowerCase())) {
                return SizedBox.shrink();
              } else {
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(20, 20))),
                  child: ListTile(
                    title: Text(items[index]),
                    onTap: () => cardClickEvent(context, index),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
