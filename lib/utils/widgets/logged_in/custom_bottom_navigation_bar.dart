import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      notchMargin: 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildAppBarItem(
            index: 0,
            icon: 'assets/icons/home.svg',
          ),
          buildAppBarItem(
            index: 1,
            icon: 'assets/icons/cat.svg',
          ),
          const Opacity(
            opacity: 0,
            child: IconButton(icon: Icon(Icons.no_cell), onPressed: null),
          ),
          buildAppBarItem(
            index: 2,
            icon: 'assets/icons/calendar.svg',
          ),
          buildAppBarItem(
            index: 3,
            icon: 'assets/icons/folder.svg',
          ),
        ],
      ),
    );
  }

  Widget buildAppBarItem({required int index, required String icon}){
    final isSelected = index == widget.index;
    return IconTheme(
      data: IconThemeData(
        color: isSelected? Colors.white : Colors.black26,
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          icon, width: 20, color: isSelected ? Colors.white : Colors.black26,),
        highlightColor: Colors.white.withOpacity(0.2),
        splashColor: Colors.white.withOpacity(0.2),
        onPressed: () { widget.onChangedTab(index);},
      ),
    );
  }
}
