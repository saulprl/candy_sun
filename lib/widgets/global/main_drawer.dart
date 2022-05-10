import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  Widget _buildListTile(
    BuildContext ctx,
    String title,
    IconData icon,
    VoidCallback tapHandler,
  ) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            size: 26,
            color: Theme.of(ctx).colorScheme.primary,
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          onTap: tapHandler,
        ),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Candy Sun'),
            automaticallyImplyLeading: false,
          ),
          const SizedBox(
            height: 10.0,
          ),
          _buildListTile(
            context,
            'Log out',
            Icons.logout,
            () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}