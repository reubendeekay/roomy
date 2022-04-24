import 'package:flutter/material.dart';
import 'package:roomy/admin/constants.dart';

class WithdrawWidget extends StatelessWidget {
  const WithdrawWidget({
    Key key,
    this.balance,
  }) : super(key: key);

  final double balance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
            onTap: () {},
            child: DraggableScrollableSheet(
                initialChildSize: 0.3,
                maxChildSize: 0.55,
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
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                  const SizedBox(height: 22),
                                  Text(
                                    'Withdraw Funds',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: kPrimary),
                                  ),
                                  Divider()
                                ],
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Enter amount',
                                  border: InputBorder.none,
                                  fillColor: Theme.of(context).cardColor,
                                  filled: true),
                            ),
                          ),
                          Container(
                              height: 45,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                color: kPrimary,
                                child: Text(
                                  'Withdraw',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              'The amount withdrawn will be credited to the phone number registered with the host provider account. Contact admin for any queries',
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    )))));
  }
}
