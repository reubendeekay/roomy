import 'package:flutter/material.dart';
import 'package:roomy/admin/widgets/posts_categories.dart';

class MyDropDown extends StatefulWidget {
  const MyDropDown(
      {Key key, this.hintText, @required this.selectedOption, this.options})
      : super(key: key);
  final String hintText;
  final List<String> options;
  final Function(String option) selectedOption;

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  String optionSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (ctx) {
              widget.options.sort();
              return PostsCategories(
                options: widget.options,
                hintText: widget.hintText,
                selectedOption: (val) {
                  setState(() {
                    optionSelected = val;
                    widget.selectedOption(val);
                  });
                },
              );
            });
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                optionSelected ?? widget.hintText,
                style: TextStyle(
                    color: optionSelected == null
                        ? Colors.grey[700]
                        : Colors.black,
                    fontSize: 15),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              )
            ],
          )),
    );
  }
}
