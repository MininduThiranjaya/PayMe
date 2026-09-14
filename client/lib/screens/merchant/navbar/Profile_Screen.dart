import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:client/providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:client/widget/common/DashboardCard_Widget.dart';

class Profile_Screen extends StatefulWidget {
  const Profile_Screen({super.key});

  @override
  State<Profile_Screen> createState() => _Profile_Screen_State();
}

class _Profile_Screen_State extends State<Profile_Screen> {
  // ---- Mock data (swap with real user model later) ----
  String userName = 'Minindu Perera';
  final String joinDate = 'Member since Jan 2024';
  String profileImageUrl = 'https://i.pravatar.cc/150?img=12';
  String currentRole = 'Customer';
  List<String> userRoles = ['Customer', 'Merchant'];

  // Saved cards — initialized as an empty growable list, never null.
  List<Map<String, String>> savedCards = [
    {'id': '1', 'name': 'Minindu Perera', 'number': '**** **** **** 4521'},
    {'id': '2', 'name': 'Minindu Perera', 'number': '**** **** **** 4521'},
    {'id': '3', 'name': 'Minindu Perera', 'number': '**** **** **** 4521'},
    {'id': '4', 'name': 'Minindu Perera', 'number': '**** **** **** 4521'},
    {'id': '5', 'name': 'M. Perera', 'number': '**** **** **** 8890'},
  ];

  bool _showDeleteWarning = false;

  // Card pending deletion — non-null shows the confirmation overlay.
  Map<String, String>? _cardPendingDelete;

  // Fixed width used for the wider dialogs (edit details, remove role, edit card, add card).
  static const double _wideDialogWidth = 420;

  // ---- Edit details (name + password) ----
  void _editDetails() {
    final nameController = TextEditingController(text: userName);
    final currentPwController = TextEditingController();
    final newPwController = TextEditingController();
    final confirmPwController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool obscureCurrent = true, obscureNew = true, obscureConfirm = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: const Text('Edit Details'),
              content: SizedBox(
                width: _wideDialogWidth,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full name',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Name cannot be empty'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: currentPwController,
                          obscureText: obscureCurrent,
                          decoration: InputDecoration(
                            labelText: 'Current password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureCurrent
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 19,
                              ),
                              onPressed: () => setDialogState(
                                () => obscureCurrent = !obscureCurrent,
                              ),
                            ),
                          ),
                          validator: (v) {
                            final wantsChange =
                                newPwController.text.isNotEmpty ||
                                confirmPwController.text.isNotEmpty;
                            if (wantsChange && (v == null || v.isEmpty)) {
                              return 'Enter current password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: newPwController,
                          obscureText: obscureNew,
                          decoration: InputDecoration(
                            labelText: 'New password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureNew
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 19,
                              ),
                              onPressed: () => setDialogState(
                                () => obscureNew = !obscureNew,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v != null && v.isNotEmpty && v.length < 6) {
                              return 'Minimum 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: confirmPwController,
                          obscureText: obscureConfirm,
                          decoration: InputDecoration(
                            labelText: 'Confirm new password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureConfirm
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 19,
                              ),
                              onPressed: () => setDialogState(
                                () => obscureConfirm = !obscureConfirm,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (newPwController.text.isNotEmpty &&
                                v != newPwController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    final payload = {
                      'name': nameController.text.trim(),
                      if (newPwController.text.isNotEmpty)
                        'currentPassword': currentPwController.text,
                      if (newPwController.text.isNotEmpty)
                        'newPassword': newPwController.text,
                    };

                    // TODO: send `payload` to backend (e.g. authService.updateProfile(payload))

                    setState(() {
                      userName = nameController.text.trim();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _changePic() {
    // TODO: hook up image_picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change picture flow goes here')),
    );
  }

  void _registerAnotherRole() {
    // TODO: navigate to role registration flow
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Register for another role flow goes here')),
    );
  }

  // ---- Remove role ----
  void _removeRole() {
    if (userRoles.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must keep at least one role')),
      );
      return;
    }

    String? selectedRole;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: const Text('Remove Role'),
              content: SizedBox(
                width: _wideDialogWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select the role you want to remove:'),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedRole,
                      hint: const Text('Choose role'),
                      items: userRoles
                          .map(
                            (role) => DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setDialogState(() => selectedRole = value),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red[400],
                  ),
                  onPressed: selectedRole == null
                      ? null
                      : () {
                          // TODO: call backend to remove `selectedRole` from account
                          setState(() {
                            userRoles.remove(selectedRole);
                            if (currentRole == selectedRole) {
                              currentRole = userRoles.first;
                            }
                          });
                          Navigator.pop(context);
                        },
                  child: const Text('Remove'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _logout() {
    // TODO: hook into AuthProvider logout
    context.read<AuthProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final isLoging = context.watch<AuthProvider>().isLoging;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ---- Fixed profile details card (no page scroll) ----
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: DashboardCard_Widget(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 48,
                                backgroundImage: NetworkImage(profileImageUrl),
                              ),
                              Positioned(
                                bottom: -4,
                                right: -4,
                                child: GestureDetector(
                                  onTap: _changePic,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Center(
                          child: Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 13,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 5),
                              Text(
                                joinDate,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Chip(
                            visualDensity: VisualDensity.compact,
                            avatar: const Icon(
                              Icons.verified_user_outlined,
                              size: 15,
                            ),
                            label: Text('Logged in as $currentRole'),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondaryContainer,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _editDetails,
                                icon: const Icon(Icons.edit_outlined, size: 17),
                                label: const Text('Edit Details'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.deepPurple,
                                  side: const BorderSide(
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: _registerAnotherRole,
                                icon: const Icon(
                                  Icons.add_moderator_outlined,
                                  size: 17,
                                ),
                                label: const Text('Add Role'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _removeRole,
                            icon: Icon(
                              Icons.remove_moderator_outlined,
                              size: 17,
                              color: Colors.red[400],
                            ),
                            label: Text(
                              'Remove Role',
                              style: TextStyle(color: Colors.red[400]),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.red[400]!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ---- Logout / Delete account — pinned to bottom of the tab ----
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _logout,
                          icon: const Icon(Icons.logout_rounded, size: 18),
                          label: const Text('Log Out'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.deepPurple,
                            side: const BorderSide(color: Colors.deepPurple),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          onPressed: () =>
                              setState(() => _showDeleteWarning = true),
                          icon: Icon(
                            Icons.delete_forever_outlined,
                            size: 18,
                            color: Colors.red[400],
                          ),
                          label: Text(
                            'Delete Account',
                            style: TextStyle(color: Colors.red[400]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ---- Delete account warning overlay ----
            if (_showDeleteWarning)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() => _showDeleteWarning = false),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.35),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap:
                            () {}, // absorb taps so it doesn't dismiss on card tap
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 40,
                                color: Colors.red[400],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Delete Account?',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'This will permanently delete your account and all associated data. This action cannot be undone.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => setState(
                                        () => _showDeleteWarning = false,
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: () {
                                        // TODO: hook up account deletion
                                        setState(
                                          () => _showDeleteWarning = false,
                                        );
                                      },
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.red[400],
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text('Delete'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
