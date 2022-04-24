import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:roomy/admin/providers/admin_booking_provider.dart';
import 'package:roomy/admin/providers/admin_property_provider.dart';
import 'package:roomy/admin/providers/admin_user_provider.dart';
import 'package:roomy/admin/screens/add_property/add_on_map.dart';
import 'package:roomy/admin/screens/add_property/add_property.dart';
import 'package:roomy/admin/screens/analytics/analytics_overview.dart';
import 'package:roomy/admin/screens/bookings/manage_bookings_screen.dart';
import 'package:roomy/admin/screens/home/widgets/admin_chat.dart';
import 'package:roomy/admin/screens/manage_property/edit_property_screen.dart';
import 'package:roomy/admin/screens/manage_property/manage_property_screen.dart';
import 'package:roomy/admin/screens/media/add_ad.dart';
import 'package:roomy/admin/screens/media/manage_ads.dart';
import 'package:roomy/admin/screens/property_review_details/admin_property_review.dart';
import 'package:roomy/admin/screens/users/all_users_screen.dart';
import 'package:roomy/bottom_nav.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:roomy/firebase_options.dart';
import 'package:roomy/helpers/push_notifications.dart';
import 'package:roomy/main_drawer.dart';
import 'package:roomy/providers/ads_provider.dart';
import 'package:roomy/providers/auth_provider.dart';
import 'package:roomy/providers/booking_provider.dart';
import 'package:roomy/providers/chat_provider.dart';
import 'package:roomy/providers/dark_mode_provider.dart';
import 'package:roomy/providers/location_provider.dart';
import 'package:roomy/providers/property_provider.dart';
import 'package:roomy/providers/search_provider.dart';
import 'package:roomy/screens/auth/auth_screen.dart';
import 'package:roomy/screens/booking/add_activity_screen.dart';
import 'package:roomy/screens/booking/booking_screen.dart';
import 'package:roomy/screens/booking/payment_screen.dart';
import 'package:roomy/screens/booking/payment_summary.dart';
import 'package:roomy/screens/bookings/check_in_thanks.dart';
import 'package:roomy/screens/bookings/my_booking_details.dart';
import 'package:roomy/screens/bookings/my_bookings.dart';
import 'package:roomy/screens/change_password/change_password.dart';
import 'package:roomy/screens/chat/chat_room.dart';
import 'package:roomy/screens/chat/chat_screen.dart';
import 'package:roomy/screens/chat/chat_screen_search.dart';
import 'package:roomy/screens/history/history_screen.dart';
import 'package:roomy/screens/home/view_all_screen.dart';
import 'package:roomy/screens/hotel_profile/hotel_profile_screen.dart';
import 'package:roomy/screens/notifications/notification_settings.dart';
import 'package:roomy/screens/notifications/notifications_screen.dart';
import 'package:roomy/screens/policies/privacy_policy.dart';
import 'package:roomy/screens/policies/terms_of_use.dart';
import 'package:roomy/screens/privacy_security/privacy_security.dart';
import 'package:roomy/screens/profile/user_profile.dart';
import 'package:roomy/screens/property_details/360_view.dart';
import 'package:roomy/screens/property_details/property_details_screen.dart';
import 'package:roomy/screens/property_details/widgets/details_fullscreen.dart';
import 'package:roomy/screens/search_screen/search_result_screen.dart';
import 'package:roomy/screens/welcome/welcome_screen.dart';
import 'package:roomy/screens/search_screen/search_screen.dart';
import 'package:roomy/screens/wishlist/wishlist_screen.dart';
import 'package:roomy/welcome_page/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF884DFF),
            ledColor: Colors.white)
      ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    registerNotification();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    AwesomeNotifications().actionStream.listen((receivedNotification) {
      // your page params. I recommend to you to pass all *receivedNotification* object
    });
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LocationProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => PropertyProvider()),
        ChangeNotifierProvider(create: (_) => AdminBookingProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => AdminUserProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => AdsProvider()),
        ChangeNotifierProvider(
          create: (_) => AdminPropertyProvider(),
        ),
        ChangeNotifierProvider(create: (_) {
          return themeChangeProvider;
        }),
      ],
      child: Consumer<DarkThemeProvider>(
          builder: (BuildContext context, value, Widget child) {
        return GetMaterialApp(
          title: 'Travely',
          debugShowCheckedModeBanner: false,
          theme: Styles.themeData(themeChangeProvider.darkTheme, context),
          builder: (context, child) {
            return MediaQuery(
              child: child,
              data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9),
            );
          },
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, snapshot) =>
                  snapshot.hasData ? MainDrawer() : WelcomePage()),
          // home: WelcomePage(),
          routes: {
            MyNav.routeName: (context) => MyNav(),
            MainDrawer.routeName: (context) => MainDrawer(),
            PropertyDetailsScreen.routeName: (context) =>
                PropertyDetailsScreen(),
            SearchScreen.routeName: (context) => SearchScreen(),
            DetailsFullScreen.routeName: (context) => DetailsFullScreen(),
            BookingScreen.routeName: (context) => BookingScreen(),
            NotificationsScreen.routeName: (context) => NotificationsScreen(),
            ViewAllScreen.routeName: (context) => ViewAllScreen(),
            // PaymentScreen.routeName: (context) => PaymentScreen(),
            AuthScreen.routeName: (context) => AuthScreen(),
            UserProfile.routeName: (context) => UserProfile(),
            PrivacyPolicy.routeName: (context) => PrivacyPolicy(),
            TermsofUse.routeName: (context) => TermsofUse(),
            NotificationSettings.routeName: (context) => NotificationSettings(),
            PrivacyAndSecurity.routeName: (context) => PrivacyAndSecurity(),
            ChatRoom.routeName: (context) => ChatRoom(),
            WishlistScreen.routeName: (context) => WishlistScreen(),
            HistoryScreen.routeName: (context) => HistoryScreen(),
            SearchResultScreen.routeName: (context) => SearchResultScreen(),
            ChatScreenSearch.routeName: (context) => ChatScreenSearch(),
            HotelProfileScreen.routeName: (context) => HotelProfileScreen(),
            PaymentSummaryScreen.routeName: (context) => PaymentSummaryScreen(),
            MyBookingsScreen.routeName: (context) => MyBookingsScreen(),
            ChatScreen.routeName: (context) => ChatScreen(),
            WelcomeScreen.routeName: (context) => WelcomeScreen(),
            AddActivityScreen.routeName: (context) => AddActivityScreen(),
            MyBookingDetails.routeName: (context) => MyBookingDetails(),
            CheckinThanks.routeName: (context) => CheckinThanks(),
            View360.routeName: (context) => View360(),
            ManageBookingsScreen.routeName: (context) => ManageBookingsScreen(),
            ManagePropertyScreen.routeName: (context) => ManagePropertyScreen(),
            AllUsersScreen.routeName: (context) => AllUsersScreen(),
            ManageAds.routeName: (context) => ManageAds(),
            AddAdScreen.routeName: (context) => AddAdScreen(),
            AdminChat.routeName: (context) => AdminChat(),
            EditPropertyScreen.routeName: (context) => EditPropertyScreen(),
            AddPropertyScreen.routeName: (context) => AddPropertyScreen(),
            AddOnMap.routeName: (context) => AddOnMap(),
            AdminPropertyReview.routeName: (context) => AdminPropertyReview(),
            AnalyticsOverViewScreen.routeName: (context) =>
                AnalyticsOverViewScreen(),
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case PaymentScreen.routeName:
                return PageTransition(
                  child: PaymentScreen(),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 200),
                  settings: settings,
                );
                break;
              case ChangePassword.routeName:
                return PageTransition(
                  child: ChangePassword(),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 200),
                  settings: settings,
                );
                break;
              default:
                return null;
            }
          },
        );
      }),
    );
  }
}
