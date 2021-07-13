import 'package:bytebank_06/components/container.dart';
import 'package:bytebank_06/components/localization/i18n_container.dart';
import 'package:bytebank_06/components/localization/i18n_messages.dart';
import 'package:bytebank_06/models/name.dart';
import 'package:bytebank_06/screens/dasboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_i18n.dart';

class DashboardContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NameCubit("David"),
      child: I18NLoadingContainer(
          viewKey: "dashboard",
          creator: (I18NMessages messages) =>
              DashboardView(DashboardViewLazyI18N(messages))),
    );
  }
}
