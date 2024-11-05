import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key, required this.user});

  final User? user;

  Widget getProfileImageWidget(User? user) {
    if(user?.photoURL != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(user?.photoURL ?? ""),
        radius: 60,
      );
    }
    return const CircleAvatar(
      radius: 75,
      backgroundColor: Colors.transparent,
      child: Icon(
        Icons.account_circle,
        size: 150,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget userProfileImage = getProfileImageWidget(user);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        userProfileImage,
        const SizedBox(height: 16),
        Text(
            "${user?.displayName}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )
        ),
        Text("${user?.email}"),
      ],
    );
  }
}
