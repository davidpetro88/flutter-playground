import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  const ListItemsBuilder({
    Key? key,
    required this.snapshot,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T>? items = snapshot.data;
      if (items != null && items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right noew',
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List<T> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index]),
    );
  }
}
