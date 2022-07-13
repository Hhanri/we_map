import 'package:fire_hydrant_mapper/blocs/main_bloc/main_bloc.dart';
import 'package:fire_hydrant_mapper/services/firebase_service.dart';
import 'package:fire_hydrant_mapper/widgets/add_location_floating_action_button_widget.dart';
import 'package:fire_hydrant_mapper/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(
        firebaseService: RepositoryProvider.of<FirebaseService>(context),
      )..add(MainInitializeEvent()),
      child: Scaffold(
        appBar: AppBar(),
        floatingActionButton: const AddLocationFloatingActionButtonWidget(),
        body: BlocBuilder<MainBloc, MainState>(
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