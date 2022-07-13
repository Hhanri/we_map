
import 'package:we_map/blocs/map_bloc/map_bloc.dart';
import 'package:we_map/models/log_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLocationFloatingActionButtonWidget extends StatelessWidget {
  const AddLocationFloatingActionButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LogModel?>(
      stream: context.read<MapBloc>().tempLogStream.stream,
      builder: (context, localMarker) {
        if (localMarker.hasData) {
          return FloatingActionButton(
            onPressed: () {
              context.read<MapBloc>().add(AddLogEvent(context: context, log: localMarker.data!));
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
