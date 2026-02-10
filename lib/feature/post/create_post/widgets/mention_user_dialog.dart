import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/extensions/context.dart';
import '../cubit/create_post_cubit.dart';
import '../model/mention_user.dart';

class MentionUserDialog extends StatefulWidget {
  const MentionUserDialog({super.key});

  @override
  State<MentionUserDialog> createState() => _MentionUserDialogState();
}

class _MentionUserDialogState extends State<MentionUserDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<MentionUserModel> _searchResults = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    final results = await context.read<CreatePostCubit>().searchUsers(query);
    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.colors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.width * 0.04),
      ),
      child: Container(
        height: context.height * 0.6,
        padding: EdgeInsets.all(context.width * 0.04),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mention User',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: context.colors.primary,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: context.colors.primary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: context.height * 0.02),

            // Search bar
            TextField(
              controller: _searchController,
              autofocus: true,
              style: TextStyle(color: context.colors.primary),
              decoration: InputDecoration(
                hintText: 'Search users...',
                hintStyle: TextStyle(color: context.colors.onPrimary),
                prefixIcon: Icon(Icons.search, color: context.colors.primary),
                filled: true,
                fillColor: context.colors.shadow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.width * 0.02),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => _searchUsers(value),
            ),
            SizedBox(height: context.height * 0.02),

            // Results
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: context.colors.primary,
                      ),
                    )
                  : _searchResults.isEmpty
                  ? Center(
                      child: Text(
                        _searchController.text.isEmpty
                            ? 'Type to search users'
                            : 'No users found',
                        style: TextStyle(color: context.colors.onPrimary),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final user = _searchResults[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: context.colors.primaryFixedDim,
                            backgroundImage: user.profilePhotoUrl != null
                                ? NetworkImage(user.profilePhotoUrl!)
                                : null,
                            child: user.profilePhotoUrl == null
                                ? Icon(
                                    Icons.person,
                                    color: context.colors.primary,
                                  )
                                : null,
                          ),
                          title: Text(
                            user.fullName ?? 'Unknown',
                            style: TextStyle(
                              color: context.colors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            '@${user.username ?? ''}',
                            style: TextStyle(color: context.colors.onPrimary),
                          ),
                          onTap: () {
                            Navigator.of(context).pop(user);
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
