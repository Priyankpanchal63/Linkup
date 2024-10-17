import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkup/utils/colors.dart';
import 'package:linkup/utils/gloable_variable.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose(); // Dispose correctly
    super.dispose();
  }

  void navigationTapped(int page) {
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), // Animation duration
        curve: Curves.easeInOut); // Animation curve
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white, // Background color for the tab bar
        items: [
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300), // Animation duration
              curve: Curves.easeInOut,
              child: Icon(
                Icons.home,
                color: (_page == 0) ? Colors.black : Colors.grey, // Change icon color to black
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.search,
                color: (_page == 1) ? Colors.black : Colors.grey,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.add_circle,
                color: (_page == 2) ? Colors.black : Colors.grey,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.favorite,
                color: (_page == 3) ? Colors.black : Colors.grey,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.person,
                color: (_page == 4) ? Colors.black : Colors.grey,
              ),
            ),
            label: '',
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
