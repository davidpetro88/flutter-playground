
import 'package:bytebank_06/components/error_view.dart';
import 'package:bytebank_06/components/localization/i18n_cubit.dart';
import 'package:bytebank_06/components/localization/i18n_state.dart';
import 'package:bytebank_06/components/progress/progress.dart';
import 'package:bytebank_06/components/progress/progress_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'i18n_messages.dart';

typedef Widget I18WidgetCreator(I18NMessages messages);


class I18NLoadingView extends StatelessWidget {
  final I18WidgetCreator _creator;

  I18NLoadingView(this._creator);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<I18NMessageCubit, I18NMessageState>(
        builder: (context, state) {
      if (state is IniI18NMessageState || state is LoadingI18NMessageState) {
        return ProgressView(message: "Loading..");
      }
      if (state is LoadedI18NMessageState) {
        final messages = state.messages;
        return _creator.call(messages);
      }
      return ErrorView("Error loaded language");
    });
  }
}

