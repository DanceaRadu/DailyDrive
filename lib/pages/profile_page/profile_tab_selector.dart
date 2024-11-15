import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../color_palette.dart';

class ProfileTabSelector extends StatelessWidget {
  const ProfileTabSelector({super.key, required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              onTap(0);
            },
            child: Container(
              width: 90,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selectedIndex == 0 ? ColorPalette.accent : ColorPalette.darkerSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flag, color: Colors.white),
                  SizedBox(height: 4),
                  Text("Goals", style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onTap(1);
            },
            child: Container(
              width: 90,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selectedIndex == 1 ? ColorPalette.accent : ColorPalette.darkerSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, color: Colors.white),
                  SizedBox(height: 4),
                  Text("History", style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}