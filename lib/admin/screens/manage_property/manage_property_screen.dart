import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomy/admin/screens/add_property/add_property.dart';
import 'package:roomy/admin/screens/manage_property/admin_properties.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/providers/location_provider.dart';

class ManagePropertyScreen extends StatelessWidget {
  static const routeName = '/manage-property';
  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Manage Travelies', style: TextStyle(color: Colors.white)),
        actions: [
          GestureDetector(
            child: Row(
              children: [
                Text(
                  'Post',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 2,
                ),
                Icon(Icons.add),
                SizedBox(
                  width: 15,
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).pushNamed(AddPropertyScreen.routeName);
            },
          )
        ],
        elevation: 0.0,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            decoration:
                BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 0),
              ),
            ]),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.blueGrey[300],
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Search',
                  style: TextStyle(color: Colors.blueGrey[300]),
                )
              ],
            ),
          ),

          // Container(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 15,
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: const [
          //       ManagePropertyOption(
          //         color: Colors.green,
          //         icon: Icons.add,
          //         title: 'New',
          //         routeName: AddPropertyScreen.routeName,
          //       ),
          //       ManagePropertyOption(
          //         color: Colors.blue,
          //         icon: Icons.graphic_eq,
          //         title: 'Analytics',
          //         routeName: AnalyticsScreen.routeName,
          //       ),
          //       ManagePropertyOption(
          //         color: Colors.red,
          //         icon: Icons.add,
          //         title: 'More',
          //         routeName: AddPropertyScreen.routeName,
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   margin: const EdgeInsets.only(top: 10),
          //   width: double.infinity,
          //   height: 1,
          //   color: Colors.grey[300],
          // ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 10),
              children: [
                AdminProperties(),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class ManagePropertyOption extends StatelessWidget {
  final Color color;
  final String title;
  final IconData icon;
  final String routeName;

  const ManagePropertyOption(
      {Key key, this.color, this.title, this.icon, this.routeName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            CircleAvatar(
              radius: 19,
              backgroundColor: color,
              child: Icon(
                icon,
                color: Colors.white,
                size: 16,
              ),
            ),
            if (title != null)
              const SizedBox(
                height: 1,
              ),
            if (title != null)
              FittedBox(
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[800], fontSize: 13)),
              ),
          ],
        ),
      ),
    );
  }
}
