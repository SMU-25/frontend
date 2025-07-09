import 'package:flutter/material.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final GlobalKey _dropdownIconKey = GlobalKey();

  void _showFixedMenu() async {
    final RenderBox renderBox =
        _dropdownIconKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx - 80,
        offset.dy + size.height + 10,
        offset.dx + size.width,
        offset.dy,
      ),
      items: const [
        PopupMenuItem(value: '강민', child: Text('강민')),
        PopupMenuItem(value: '지환', child: Text('지환')),
      ],
    );

    if (selected != null) {
      print('선택한 메뉴: $selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            const Icon(Icons.account_circle, color: Colors.grey, size: 55),
            const SizedBox(width: 10),
            const Text(
              '준형',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              key: _dropdownIconKey,
              onTap: _showFixedMenu,
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
        const Icon(Icons.notifications_none_outlined, size: 28),
      ],
    );
  }
}
