import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'single_data_loader_bloc.dart';

///Use this BlocProvider to add GetSingleData event on creation of SingleDataLoaderBloc
///Don't use it to pass SingleDataLoaderBloc to navigated screens
class SingleDataLoaderBlocProvider<
    B extends SingleDataLoaderBloc<SingleDataLoaderEvent,
        SingleDataLoaderState<Object>, Object>> extends BlocProvider<B> {
  SingleDataLoaderBlocProvider({
    Key? key,
    required B Function(BuildContext context) create,
    Widget? child,
    bool? lazy,
  }) : super(
          key: key,
          create: (context) {
            return create(context)..add(GetSingleData());
          },
          child: child,
          lazy: lazy,
        );
}
