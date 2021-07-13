
import 'package:flutter/material.dart';

abstract class BlockContainer extends StatelessWidget { }

void push(BuildContext blocContext, BlockContainer container) {
  Navigator.of(blocContext).push(
    MaterialPageRoute(builder: (context) => container)
  );
}

