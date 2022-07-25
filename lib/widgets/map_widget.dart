import 'package:we_map/blocs/map_bloc/map_bloc.dart';
import 'package:we_map/models/topic_model.dart';
import 'package:we_map/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //local temporary marker stream
    return StreamBuilder<TopicModel?>(
      stream: context.read<MapBloc>().tempTopicStream.stream,
      builder: (context, tempTopic) {

        //server markers stream
        return StreamBuilder<List<TopicModel>>(
            stream: context.read<MapBloc>().topicsController.stream,
            initialData: const [],
            builder: (context, serverTopics) {
              if (serverTopics.hasData) {

                Set<Marker> markers = TopicModel.getMarkers(
                  context: context,
                  topics: serverTopics.data!,
                  uid: context.read<MapBloc>().authService.getUserId
                );
                print("MARKERS = ${markers.length}");
                if (tempTopic.hasData) {
                  markers.add(TopicModel.getTempMarker(context: context, topic: tempTopic.data!));
                }

                return GoogleMap(
                  markers: markers,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  tiltGesturesEnabled: false,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    context.read<MapBloc>().add(LoadMapControllerEvent(controller: controller));
                  },
                  initialCameraPosition: (context.read<MapBloc>().state as MainInitializedState).camera,
                  onTap: (LatLng point) {
                    context.read<MapBloc>().add(AddTemporaryMarker(point: point));
                  },
                  onCameraMove: (camera) {
                    context.read<MapBloc>().add(CameraMoveEvent(center: camera.target));
                  },
                  onCameraIdle: () {
                    context.read<MapBloc>().add(CameraStopEvent());
                  },
                );
              }
              return const LoadingWidget();
            }
        );
      },
    );
  }
}
