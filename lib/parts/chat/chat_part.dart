library chat_part;

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:tada_team_chat/parts/login/login_part.dart';
import 'package:tada_team_chat/parts/rooms/rooms_part.dart';
import 'package:tada_team_chat/services/connectivity_check.dart';
import 'package:tada_team_chat/services/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tada_team_chat/l10n/l10n.dart';

part 'bloc/chat_bloc.dart';

part 'bloc/chat_event.dart';

part 'bloc/chat_state.dart';

part 'data_provider/chat_data_provider.dart';

part 'models/message.dart';

part 'repository/chat_repository.dart';

part 'screens/chat.dart';

part 'screens/chat_log.dart';

part 'screens/chat_main.dart';

part 'widgets/message_bubble.dart';

part 'widgets/message_input.dart';
