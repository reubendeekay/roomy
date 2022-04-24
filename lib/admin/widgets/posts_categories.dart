import 'package:flutter/material.dart';
import 'package:roomy/admin/constants.dart';

class PostsCategories extends StatelessWidget {
  const PostsCategories(
      {Key key, this.options, this.hintText, this.selectedOption})
      : super(key: key);
  final List<String> options;
  final String hintText;
  final Function(String option) selectedOption;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
            onTap: () {},
            child: DraggableScrollableSheet(
                initialChildSize: 0.3,
                maxChildSize: 0.8,
                minChildSize: 0.2,
                builder: (ctx, controller) => AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      child: ListView(
                        controller: controller,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                              ),
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              margin: const EdgeInsets.only(bottom: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 70,
                                      height: 5,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                  const SizedBox(height: 22),
                                  Text(
                                    hintText,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: kPrimary),
                                  ),
                                ],
                              )),
                          ListView(
                            shrinkWrap: true,
                            children: List.generate(
                              options.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  selectedOption(options[index]);
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  color: Theme.of(context).cardColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 18),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 1),
                                  child: Text(options[index]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )))));
  }
}
