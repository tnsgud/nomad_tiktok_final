import 'package:final_project/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNavigation extends StatefulWidget {
  const CustomNavigation({super.key});

  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class _CustomNavigationState extends State<CustomNavigation> {
  int _currentIndex = 0;
  final List<String> _path = ['/', '/post'];

  void _onTap(int index) {
    context.go(_path[index]);

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
            label: 'home',
            icon: Icon(
              _currentIndex == 0 ? Icons.home : Icons.home_outlined,
              size: Sizes.size40,
            ),
          ),
          BottomNavigationBarItem(
            label: 'post',
            icon: Icon(
              _currentIndex == 1 ? Icons.edit : Icons.edit_outlined,
              size: Sizes.size32,
            ),
          )
        ],
      ),
    );
  }
}
