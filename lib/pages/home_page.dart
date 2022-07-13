import 'package:we_map/blocs/map_bloc/map_bloc.dart';
import 'package:we_map/services/firebase_service.dart';
import 'package:we_map/widgets/add_location_floating_action_button_widget.dart';
import 'package:we_map/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MapBloc>(
      create: (context) => MapBloc(
        firebaseService: RepositoryProvider.of<FirebaseService>(context),
      )..add(MainInitializeEvent()),
      child: Scaffold(
        appBar: AppBar(),
        floatingActionButton: const AddLocationFloatingActionButtonWidget(),
        body: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            if (state is MainInitializedState) {
              return const MapWidget();
            }
            return const Center(
              child: Text("Error"),
            );
          }
        ),
      ),
    );
  }
}