import 'package:bytebank_06/components/container.dart';
import 'package:bytebank_06/components/localization/i18n_cubit.dart';
import 'package:bytebank_06/components/localization/i18n_loading_view.dart';
import 'package:bytebank_06/http/webclients/i18nwebclient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class I18NLoadingContainer extends BlocContainer {
  late String viewKey;
  late I18WidgetCreator creator;

  I18NLoadingContainer({
    required String viewKey,
    required I18WidgetCreator creator,
  }) {
    this.creator = creator;
    this.viewKey = viewKey;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<I18NMessageCubit>(
      create: (BuildContext context) {
        final cubit = I18NMessageCubit(this.viewKey);
        cubit.reload(I18WebClient(this.viewKey));
        return cubit;
      },
      child: I18NLoadingView(this.creator),
    );
  }
}