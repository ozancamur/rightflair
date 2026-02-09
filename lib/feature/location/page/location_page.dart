import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/components/button/back_button.dart';
import 'package:rightflair/core/components/loading.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/location/widgets/location_list.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../../../core/components/text/appbar_title.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';
import '../widgets/location_empty.dart';
import '../../../core/components/text/error_message.dart';
import '../widgets/location_input.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearchChanged() {
    context.read<LocationCubit>().searchLocation(_searchController.text);
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: _appbar(context),
      body: _body(context),
    );
  }

  AppBarComponent _appbar(BuildContext context) {
    return AppBarComponent(
      leading: BackButtonComponent(onBack: () => context.pop()),
      title: AppbarTitleComponent(title: AppStrings.CREATE_POST_SELECT_LOCATION),
    );
  }

  Padding _body(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: context.height * 0.02,
        children: [
          LocationInputWidget(controller: _searchController),
          _list(),
        ],
      ),
    );
  }

  Expanded _list() {
    return Expanded(
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          if (state is LocationLoading) {
            return const LoadingComponent();
          } else if (state is LocationLoaded) {
            if (state.locations.isEmpty) {
              return const LocationEmptyWidget();
            }
            return LocationListWidget(list: state.locations);
          } else if (state is LocationError) {
            return ErrorMessageComponent(message: state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
