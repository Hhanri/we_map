
import 'package:we_map/blocs/map_bloc/map_bloc.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/models/topic_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLocationFloatingActionButtonWidget extends StatelessWidget {
  const AddLocationFloatingActionButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TopicModel?>(
      stream: context.read<MapBloc>().tempTopicStream.stream,
      builder: (context, localMarker) {
        if (localMarker.hasData) {
          return FloatingActionButton(
            onPressed: () {
              context.read<MapBloc>().add(AddTopicEvent(context: context, topic: localMarker.data!));
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.linearGradient
              ),
              child: const Icon(
                Icons.add_location_outlined,
                size: 30,
              ),
            ),
          );
        }
        return Container();
      }
    );
  }
}
