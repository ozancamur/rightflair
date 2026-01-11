import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/components/text_field.dart';
import 'package:rightflair/core/constants/dark_color.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

class LocationSelectionDialog extends StatefulWidget {
  const LocationSelectionDialog({super.key});

  @override
  State<LocationSelectionDialog> createState() =>
      _LocationSelectionDialogState();
}

class _LocationSelectionDialogState extends State<LocationSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allLocations = [
    "New York, USA",
    "London, UK",
    "Paris, France",
    "Berlin, Germany",
    "Tokyo, Japan",
    "Istanbul, Turkey",
    "Moscow, Russia",
    "Sydney, Australia",
    "Dubai, UAE",
    "Toronto, Canada",
  ];
  List<String> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _filteredLocations = _allLocations;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredLocations = _allLocations
          .where(
            (location) => location.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppDarkColors.SECONDARY,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.width * 0.05),
      ),
      child: Container(
        height: context.height * 0.6,
        padding: EdgeInsets.all(context.width * 0.05),
        child: Column(
          children: [
            TextComponent(
              text: AppStrings.CREATE_POST_SELECT_LOCATION,
              size: const [20],
              weight: FontWeight.bold,
            ),
            SizedBox(height: context.height * 0.02),
            TextFieldComponent(
              controller: _searchController,
              hintText: AppStrings.CREATE_POST_SEARCH_LOCATION,
              regExp: RegExp(r'.*'),
              errorText: '',
            ),
            SizedBox(height: context.height * 0.02),
            Expanded(
              child: ListView.separated(
                itemCount: _filteredLocations.length,
                separatorBuilder: (context, index) =>
                    Divider(color: AppDarkColors.WHITE16),
                itemBuilder: (context, index) {
                  final location = _filteredLocations[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: TextComponent(text: location, size: const [16]),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppDarkColors.WHITE60,
                    ),
                    onTap: () {
                      Navigator.pop(context, location);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
