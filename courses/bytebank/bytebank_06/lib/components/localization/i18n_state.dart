import 'package:bytebank_06/components/localization/i18n_messages.dart';
import 'package:flutter/material.dart';

@immutable
abstract class I18NMessageState {
  const I18NMessageState();
}

@immutable
class LoadingI18NMessageState extends I18NMessageState {
  const LoadingI18NMessageState();
}

@immutable
class IniI18NMessageState extends I18NMessageState {
  const IniI18NMessageState();
}

@immutable
class LoadedI18NMessageState extends I18NMessageState {
  final I18NMessages messages;

  const LoadedI18NMessageState(this.messages);
}

@immutable
class FatalErrorI18NMessageState extends I18NMessageState {
  final String _message;

  const FatalErrorI18NMessageState(this._message);
}
