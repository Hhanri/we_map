import 'package:fire_hydrant_mapper/blocs/main_bloc/main_bloc.dart';
import 'package:fire_hydrant_mapper/models/log_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLocationFloatingActionButtonWidget extends StatelessWidget {
  const AddLocationFloatingActionButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LogModel?>(
      stream: context.read<MainBloc>().tempLogStream.stream,
      builder: (context, localMarker) {
        if (localMarker.hasData) {
          return FloatingActionButton(
            onPressed: () {
              context.read<MainBloc>().add(AddLogEvent(context: context, log: localMarker.data!));
            },
            child: const Icon(
              Icons.add_location_outlined
            ),
          );
        }
        return Container();
      }
    );
  }
}
