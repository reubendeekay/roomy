import 'package:flutter/material.dart';

class SecurityTile extends StatelessWidget {
  final Color colors;
  final String title;
  final IconData icon;
  final String routeName;
  SecurityTile({this.colors, this.title, this.icon, this.routeName});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          child: Icon(
            icon,
            color: colors,
          ),
          backgroundColor: colors.withOpacity(0.2),
        ),
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        title: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
