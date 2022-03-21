import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatefulWidget {

  final int index;
  final ValueChanged<int> onChangedTab;

  const CustomBottomNavigationBar({
    required this.index,
    required this.onChangedTab,
    Key? key
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xffFFD98E),
      shape: const CircularNotchedRectangle(),
      notchMargin: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildAppBarItem(
            index: 0,
            icon: const FaIcon(FontAwesomeIcons.home),
          ),
          buildAppBarItem(
            index: 1,
            icon: const FaIcon(FontAwesomeIcons.cat),
          ),
          const Opacity(
            opacity: 0,
            child: IconButton(icon: Icon(Icons.no_cell), onPressed: null),
          ),
          buildAppBarItem(
            index: 2,
            icon: const FaIcon(FontAwesomeIcons.calendarAlt),
          ),
          buildAppBarItem(
            index: 3,
            icon: const FaIcon(FontAwesomeIcons.history),
          ),
        ],
      ),
    );
  }

  Widget buildAppBarItem({required int index, required FaIcon icon}){
    final isSelected = index == widget.index;
    return IconTheme(
      data: IconThemeData(
        color: isSelected? Colors.black38 : Colors.white,
      ),
      child: IconButton(
        icon: icon,
        highlightColor: Colors.white.withOpacity(0.2),
        splashColor: Colors.white.withOpacity(0.2),
        onPressed: () { widget.onChangedTab(index);},
      ),
    );
  }
}
