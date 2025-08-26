import 'package:flutter/material.dart';
import 'package:team_project_front/common/model/baby.dart';
import 'package:team_project_front/home/view/alert.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    super.key,
    required this.babies,
    required this.selectedBaby,
    required this.onBabySelected,
  });

  final List<Baby> babies;
  final Baby selectedBaby;
  final ValueChanged<Baby> onBabySelected;

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final GlobalKey _dropdownIconKey = GlobalKey();
  late Baby _currentBaby;

  @override
  void initState() {
    super.initState();
    _currentBaby = widget.selectedBaby;
  }

  void _showFixedMenu() async {
    final RenderBox renderBox =
        _dropdownIconKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final selected = await showMenu<Baby>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx - 80,
        offset.dy + size.height + 10,
        offset.dx + size.width,
        offset.dy,
      ),
      items:
          widget.babies
              .map(
                (baby) =>
                    PopupMenuItem<Baby>(value: baby, child: Text(baby.name)),
              )
              .toList(),
    );

    if (selected != null) {
      setState(() {
        _currentBaby = selected;
      });
      widget.onBabySelected(selected);
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
            _currentBaby.profileImage.isNotEmpty
                ? CircleAvatar(
                  radius: 27.5,
                  backgroundImage: NetworkImage(_currentBaby.profileImage),
                )
                : const Icon(
                  Icons.account_circle,
                  color: Colors.grey,
                  size: 65,
                ),

            const SizedBox(width: 10),
            Text(
              _currentBaby.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined, size: 28),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AlertScreen()),
            );
          },
        ),
      ],
    );
  }
}
