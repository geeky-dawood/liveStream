import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:lottie/lottie.dart';

Widget buildEmojiPreviewIcon(String path) {
  return Lottie.asset(path);
}

Widget buildReactionsIcon(String path) {
  return Lottie.asset(path, height: 20);
}

Widget buildEmojiTitle(String title) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(.75),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 8,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

final List<Reaction<String>> reactions = [
  Reaction<String>(
    value: 'Happy',
    title: buildEmojiTitle(
      'Happy',
    ),
    previewIcon: buildEmojiPreviewIcon(
      'assets/animations/haha.json',
    ),
    icon: buildReactionsIcon(
      'assets/animations/haha.json',
      // const Text(
      //   'Happy',
      //   style: TextStyle(
      //     color: Color(0XFF3b5998),
      //   ),
      // ),
    ),
  ),
  Reaction<String>(
    value: 'In love',
    title: buildEmojiTitle(
      'In love',
    ),
    previewIcon: buildEmojiPreviewIcon(
      'assets/animations/love_emoji.json',
    ),
    icon: buildReactionsIcon(
      'assets/animations/love_emoji.json',
      // const Text(
      //   'In love',
      //   style: TextStyle(
      //     color: Color(0XFFffda6b),
      //   ),
      // ),
    ),
  ),
  Reaction<String>(
    value: 'Angry',
    title: buildEmojiTitle(
      'Angry',
    ),
    previewIcon: buildEmojiPreviewIcon(
      'assets/animations/angry.json',
    ),
    icon: buildReactionsIcon(
      'assets/animations/angry.json',
      // const Text(
      //   'Sad',
      //   style: TextStyle(
      //     color: Color(0XFFffda6b),
      //   ),
      // ),
    ),
  ),
  Reaction<String>(
    value: 'Heart',
    title: buildEmojiTitle(
      'Heart',
    ),
    previewIcon: buildEmojiPreviewIcon(
      'assets/animations/heart.json',
    ),
    icon: buildReactionsIcon(
      'assets/animations/heart.json',
      // const Text(
      //   'Surprised',
      //   style: TextStyle(
      //     color: Color(0XFFffda6b),
      //   ),
      // ),
    ),
  ),
  Reaction<String>(
    value: 'Fire',
    title: buildEmojiTitle(
      'Fire',
    ),
    previewIcon: buildEmojiPreviewIcon(
      'assets/animations/fire.json',
    ),
    icon: buildReactionsIcon(
      'assets/animations/fire.json',
      // const Text(
      //   'Angry',
      //   style: TextStyle(
      //     color: Color(0XFFed5168),
      //   ),
      // ),
    ),
  ),
];
