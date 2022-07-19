import 'package:we_map/blocs/auth_bloc/auth_bloc.dart';
import 'package:we_map/blocs/map_bloc/map_bloc.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/screens/loading/loading_screen.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/add_location_floating_action_button_widget.dart';
import 'package:we_map/widgets/loading_widget.dart';
import 'package:we_map/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/widgets/root_page_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RootPageWidget(
      child: BlocProvider<MapBloc>(
        create: (context) => MapBloc(
          firebaseService: RepositoryProvider.of<FirebaseFirestoreService>(context),
          authService: RepositoryProvider.of<FirebaseAuthService>(context)
        )..add(RequestPermissionEvent()),
        child: Scaffold(
          appBar: const HomeAppBar(),
          floatingActionButton: const AddLocationFloatingActionButtonWidget(),
          body: BlocConsumer<MapBloc, MapState>(
            listener: (context, state) {
              if (state.isLoading) {
                LoadingScreen.instance().show(context: context, text: 'loading...');
              } else {
                LoadingScreen.instance().hide();
              }
              if (state.errorMessage != null) {
                showErrorMessage(errorMessage: state.errorMessage!, context: context);
              }
            },
            builder: (context, state) {
              if (state is MainInitializedState) {
                return const MapWidget();
              }
              if (state is NoLocationPermissionState) {
                return const NoLocationPermissionView();
              }
              return const LoadingWidget();
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

class NoLocationPermissionView extends StatelessWidget {
  const NoLocationPermissionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Location permission was denied"),
          TextButton(onPressed: () => context.read<MapBloc>().add(RequestPermissionEvent()), child: const Text("Grant Permission"))
        ],
      ),
    );
  }
}
