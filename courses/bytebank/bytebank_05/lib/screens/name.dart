import 'package:bytebank_03/components/container.dart';
import 'package:bytebank_03/models/name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameContainer extends BlockContainer {
  @override
  Widget build(BuildContext context) {
    return NameView();
  }
}

class NameView extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  // BlocBuilder<NameCubit, String>
  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    _nameController.text = context.read<NameCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change name'),
      ),
      body: Column(
        children: [
          TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "desired name",
              ),
              style: TextStyle(
                fontSize: 24.0,
              )),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                child: Text("Change"),
                onPressed: () {
                  final name = _nameController.text;
                  context.read<NameCubit>().change(name);
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
