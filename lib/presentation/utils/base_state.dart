import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit_utils.dart';
import 'scaffold_utils.dart';

/// BaseState is a template for creating a stateful Scaffold widget with cubit
abstract class BaseState<T extends StatefulWidget, S, C extends Cubit<S>> extends State<T>
    with StateTemplate<T>, BlocListenerMixin<T, S, C>, BlocProviderMixin<T, C>, LoadingState<T> {}
