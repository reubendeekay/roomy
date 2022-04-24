import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/helpers/mpesa_helper.dart';
import 'package:roomy/models/booking_model.dart';
import 'package:roomy/models/notifications_model.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/auth_provider.dart';
import 'package:roomy/providers/booking_provider.dart';
import 'package:roomy/screens/booking/payment_summary.dart';
import 'package:roomy/widgets/done_icon.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = '/price-summary';

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final ScrollController _scrollController = ScrollController();
  int selectedPayment = 0;
  final phoneNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = Provider.of<BookingProvider>(context).booking;
    final property = ModalRoute.of(context).settings.arguments as PropertyModel;
    return Scaffold(
      appBar: ScrollAppBar(
        controller: _scrollController,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: kPrimary,
        title: const Text(
          'SUMMARY & PAYMENT',
          style: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w900),
        ),
      ),
      body: Stack(
        children: [
          Container(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  PriceSummary(booking),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 1,
                          groupValue: selectedPayment,
                          onChanged: (val) {
                            setState(() {
                              selectedPayment = 1;
                            });
                          }),
                      Text(
                        'Pay via Mpesa',
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 0,
                          groupValue: selectedPayment,
                          onChanged: (val) {
                            setState(() {
                              selectedPayment = 0;
                            });
                          }),
                      Text(
                        'Pay with Credit Card',
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  if (selectedPayment == 0) CreditCardInformation(),
                  if (selectedPayment == 1)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                            hintText: 'Enter your phone number',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                      ),
                    ),
                  Row(
                    children: [
                      Radio(
                          value: 2,
                          groupValue: selectedPayment,
                          onChanged: (val) {
                            setState(() {
                              selectedPayment = 2;
                            });
                          }),
                      Text(
                        'Pay with Paypal',
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 75,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    primary: kPrimary,
                  ),
                  child: const Text(
                    'Complete Booking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  onPressed: () async {
                    // if (formKey.currentState.validate()) {

                    String phone() {
                      if (phoneNumberController.text.startsWith('01')) {
                        return phoneNumberController.text
                            .replaceFirst('01', '2541', 0)
                            .trim();
                      } else if (phoneNumberController.text.startsWith('07')) {
                        return phoneNumberController.text
                            .replaceFirst('07', '2547', 0)
                            .trim();
                      }
                      return phoneNumberController.text;
                    }

                    if (selectedPayment == 1)
                      await mpesa
                          .lipaNaMpesa(
                        phoneNumber: phone(),
                        amount: booking.price * 100,
                        accountReference: 'TRAVELY',
                        businessShortCode: "174379",
                        callbackUrl: "https://google.com",
                      )
                          .catchError((error) {
                        print(error);
                      });
                    await Provider.of<BookingProvider>(context, listen: false)
                        .completeBooking(
                            property,
                            NotificationsModel(
                                body:
                                    'Your booking of ${booking.numOfRooms} rooms for ${booking.numOfGuests} guests at ${property.name} has successfully been booked for ${booking.numOfDays} days. Check in on ${DateFormat('dd MMMM yyyy').format(booking.checkIn)}. Have a lovely stay',
                                tag: 'BOOKING',
                                imageUrl: property.coverImage,
                                senderId: property.ownerId,
                                title: '${property.name} has been booked'));

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        content: DoneIcon(),
                      ),
                    );
                    Future.delayed(Duration(milliseconds: 5000)).then((value) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                      Navigator.of(context).pushReplacementNamed(
                          PaymentSummaryScreen.routeName,
                          arguments: property);
                    });
                    // } else {
                    print('invalid!');
                    // }
                  },
                ),
              ))
        ],
      ),
    );
  }
}

class PriceSummary extends StatelessWidget {
  final BookingModel booking;
  PriceSummary(this.booking);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0.4,
              blurRadius: 8,
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              '${booking.numOfDays} days, ${booking.numOfRooms} Room, ${booking.numOfGuests} Guests',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              Text(
                'KES ${booking.price}',
                style: const TextStyle(
                    fontSize: 16, color: kPrimary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payable now',
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              Text(
                'KES ${booking.price * 0.5}',
                style: const TextStyle(
                    fontSize: 16, color: kPrimary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CreditCardInformation extends StatefulWidget {
  @override
  _CreditCardInformationState createState() => _CreditCardInformationState();
}

class _CreditCardInformationState extends State<CreditCardInformation>
    with TickerProviderStateMixin {
  String cardNumber = '';

  String expiryDate = '';

  String cardHolderName = '';

  String cvvCode = '';

  bool isCvvFocused = false;

  AnimationController _controller;
  final formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onHorizontalDragStart: (details) {
              if (details.globalPosition.dx > 0) {
                setState(() {
                  isCvvFocused = !isCvvFocused;
                });
              }
            },
            child: CreditCardWidget(
              animationDuration: Duration(seconds: 1),
              cardBgColor: kPrimary,
              textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.inconsolata().fontFamily,
                  color: Colors.white),
              cardType: CardType.mastercard,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName.toUpperCase(),
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
            ),
          ),
          CreditCardForm(
            formKey: formKey,
            obscureCvv: true,
            textColor: Theme.of(context).textTheme.bodyText1.color,
            obscureNumber: true,
            cardNumber: cardNumber,
            cvvCode: cvvCode,
            cardHolderName: cardHolderName.toUpperCase(),
            expiryDate: expiryDate,
            themeColor: kPrimary,
            cardNumberDecoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).textTheme.bodyText1.color)),
              labelText: 'Credit Card No',
              hintStyle:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
              labelStyle:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
              hintText: 'XXXX XXXX XXXX XXXX',
            ),
            expiryDateDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Expiry Date',
              hintStyle:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
              labelStyle:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
              hintText: 'XX/XX',
            ),
            cvvCodeDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'CVV',
              hintText: 'XXX',
              hintStyle:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
              labelStyle:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
            ),
            cardHolderDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Card Holder',
              hintStyle:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
              labelStyle:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
            ),
            onCreditCardModelChange: onCreditCardModelChange,
          ),
        ],
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
