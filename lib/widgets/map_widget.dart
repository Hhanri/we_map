import 'package:we_map/blocs/map_bloc/map_bloc.dart';
import 'package:we_map/models/log_model.dart';
import 'package:we_map/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    const CameraPosition initialCamera = CameraPosition(
      target: LatLng(48.88888737849572, 2.34311714079882),
      zoom: 12
    );

    //local temporary marker stream
    return StreamBuilder<LogModel?>(
      stream: context.read<MapBloc>().tempLogStream.stream,
      builder: (context, tempLog) {

        //server markers stream
        return StreamBuilder<List<LogModel>>(
          stream: context.read<MapBloc>().logsController.stream,
          builder: (context, serverLogs) {
            if (serverLogs.hasData) {

              Set<Marker> markers = LogModel.getMarkers(context: context, logs: serverLogs.data!);
              if (tempLog.hasData) {
                markers.add(LogModel.getTempMarker(context: context, log: tempLog.data!));
              }

              return GoogleMap(
                markers: markers,
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  context.read<MapBloc>().add(LoadMapControllerEvent(controller: controller));
                },
                initialCameraPosition: initialCamera,
                onTap: (LatLng point) {
                  context.read<MapBloc>().add(AddTemporaryMarker(point: point));
                },
              );
            }
            print(serverLogs.data );
            return const LoadingWidget();
          }
        );
      },
    );
  }
}
