import 'package:we_map/blocs/auth_bloc/auth_bloc.dart';
import 'package:we_map/blocs/map_bloc/map_bloc.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/add_location_floating_action_button_widget.dart';
import 'package:we_map/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BlocProvider<MapBloc>(
        create: (context) => MapBloc(
          firebaseService: RepositoryProvider.of<FirebaseFirestoreService>(context),
        )..add(MainInitializeEvent()),
        child: Scaffold(
          appBar: const HomeAppBar(),
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
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget with PreferredSizeWidget{
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          context.read<AuthBloc>().authService.signOut();
        },
        icon: const Icon(Icons.logout),
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
