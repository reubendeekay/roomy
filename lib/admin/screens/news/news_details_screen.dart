import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roomy/admin/screens/news/widget/pinned_news.dart';
import 'package:roomy/models/news_model.dart';

class NewsDetailsScreen extends StatelessWidget {
  final NewsModel news;
  final bool isTile;
  NewsDetailsScreen(this.news, {this.isTile = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Travely News',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2.5),
                    Text(
                      'by ${news.postedBy}',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    )
                  ],
                ),
                Spacer(),
                CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(news.posterProfile),
                ),
              ],
            ),
          ),
          PinnedNews(
            news,
            isTile: isTile,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: Text(news.content),
          )
        ],
      ),
    );
  }
}

const mNews =
    '''Planning a vacation gives you something to look forward to in the coming year. Whether it's an official family holiday, road trip, solo wellness retreat, or a last-minute long-weekend getaway with the girls, there's so many great places to visit. There are also dozens of awesome travel apps that'll help you not only channel wanderlust into an experience you'll never forget, but also, save you money.
First, you'll need to figure out where to go. Will you stay within the 50 states, or head somewhere internationally? (Hint: Scrolling Instagram travel accounts is a fun way to research). Once you've picked a destination and stocked up on travel dresses, there's still plenty to organize before the fun begins. That road trip itinerary isn't going to map itself. And what times are your connecting flights, again? Then there's managing the hotel or AirBNB reservation, and figuring out how to stay on budget when you're taking your kids out to eat every night. That's where free travel apps like TripIt, Kayak, and Hopper come in handy. With the help of the best travel apps, you'll actually enjoy the buildup to your next adventure. Or, at the very least, you'll be able to find cheap flights to get you there.

1 Best for Finding Cheap Flights: Hopper

One of the best travel apps for flights, Hopper analyzes billions of airfare and hotel prices a day—as well as its vast archive of historical data—to tell you whether to wait or book your trip.
Here’s how it works: Type in your destination and a color-coded calendar will show you the cheapest (and most expensive) dates to fly. Hopper will then recommend whether you should go ahead and buy now, or hold off until the rates get better.
If it tells you to stay tuned, you can set up a price watch and put your phone away. When the fare has dropped to its lowest point and it’s time for you to swipe, Hopper will send you a notification.

2 Best Travel Planner App: TripIt

TripIt organizes all of your itineraries in one place. Available for both iPhone and Android, users simply forward confirmation emails to plans@tripit.com, and the app will create you a *free* master doc for each trip. You can access the itinerary anywhere, even without an internet connection.
Their premium service, TripIt Pro (\$49/year) boosts your organizing power with additional features. These include real-time flight alerts, refund notifications, and the ability to track reward points and miles as well as a currency converter, a list of socket and plug requirements, and tipping advice for 180 countries.

3 Best for Road Trips: Roadtrippers

You have a considerable amount of flexibility on a road trip, but planning them requires effort. Try Roadtrippers the next time you're inspired to grab a car and go. The app allows you to map your route with up to 7 waypoints free of charge. After that, there's an option to upgrade to Roadtrippers Plus.
Along your route, the app will recommend local food options, roadside attractions, scenic stops and more. They even have pre-made guides for popular road trips.

4 Best for Finding Unexpected Destinations: Skyscanner

Skyscanner's "everywhere" feature allows you to look for surprising destinations simply by sorting by your budget and your travel timeframe. For example, you may think Europe will be out of your price-range, but this feature could make the trip possible.
Like Hopper and Kayak, it also helps you find the best airfare rates by alerting you when prices dip.

5 Best Travel Weather App for Road Trips: Drive Weather

The last thing you want is to get caught in a nasty, vision-obscuring storm when you're on a long stretch of highway with your family or friends. DriveWeather was designed to help road travelers avoid the worst weather conditions. The app lets you track your best (read: sunniest) departure time, providing radar views and routes from one point to another—with rain, freezing rain, ice, and snow icons that let you know when there's slippery roads ahead.
The free version offers 2 days of forecasts, city-to-city routing, and a 900-mile trip limit; the ad-free \$9.99 a year version offers 7 days of forecasts, wind direction info, specific address-to-address routing, and no cap on trip length.

6 Best Last-Minute Hotel Deals: HotelTonight

Booked that spontaneous flight, and now you're trying to figure out where you're going to sleep at night? In the middle of a road adventure and need to find lodging ASAP? Don't panic, there's an app for that. HotelTonight finds last-minute deals on hotels near your location, ranging from "basic" to "luxe" options, including unique boutique hotels.
The app allows you to filter for location, dates, the number of guests, pet-friendly options, and amenities like a gym.

7 Best for Navigating Traffic: Waze

Waze makes it easy for you to avoid congestion, blocked roads, police, accidents or other hazards that might increase your driving time—because starting off vacation by sitting in traffic is a major mood killer.
The app has a speedometer to help you make sure you're staying within the speed limit, and it updates your arrival time based on live traffic data.

8 Best for Filtering Airlines and Hotels: Kayak

The beauty of KAYAK is that it aggregates the best fares from most airlines, allowing you to filter flight options based on your airline preference and departure times, while easily changing dates and destinations. You can also find deals on car rentals and hotels.
Once you've booked, the app, available on iOS and Google Play, keeps your plans organized and updates you on flight status, airport terminals, and security wait times.

9 Best for Non-Hotel Lodgers: Airbnb

Whether you're looking to rent a room, a house, or an entire hacienda, you can search for accommodations in your desired location. The app (free on Google Play and iTunes) lets you filter through photos and reviews, as well as sort by amenities—like a pool or washing machine. Plus, a local host can provide insight about great dining spots.

10 Best for Preventing Jet Lag: Timeshifter

If you have an international trip in the works and you're hoping to fend off jet lag, give Timeshifter a try. The app was developed by scientists who used sleep and circadian neuroscience to help inform the personalized jet lag plans they craft for you. According to the app's website, even astronauts and elite athletes have used it to arrive at their destinations in tip-top shape.
The first "jet lag plan" is free, so try it out on your next adventure across the world.

11 Best for Connecting With Locals: Meetup

One way to fully immerse yourself in your travel destination is to meet and talk with locals. Meetup can help you connect with people who are interested in the same things as you, even while on vacation. Whether it's cooking, tech, sports, music, or photography, the app will help you make new friends all over the world.

12 Best Voice Controlled App: Hound From SoundHound

Free on iOS devices and Android, Hound from SoundHound is a voice assistant app that you can chat with like you would a travel agent. For instance, say, "Okay, Hound. Show me hotels in Chicago for this weekend that cost less than \$300 and are pet-friendly.”

13 Best App for International Travel: Rome2rio

With data from over 160 countries, Rome2rio is one of the best international travel apps. Simply enter any address, landmark, or city as your destination and the app displays info about accommodations and things to do.
Free on iOs and Android, Rome2rio also shows you how to get around, and compares costs, if, for example, you're debating flying from Florence to Rome versus taking the train.

14 Best for Frequent Flier Travel: App In The Air

This one's been placed on Apple’s coveted “Best App” list because it not only keeps track of itineraries, boarding passes, and frequent-flier programs, but it also tracks boarding and landing times, along with current waits for check-in, security and customs. Through augmented reality, it even helps you figure out if your carry-on is the right fit for your next flight.
For the best place to grab airport coffee, or where you can get a mimosa before 7 a.m. in a specific terminal, the app also pulls tips from fellow travelers. And, if you're the competitive type, you can keep "score" of all of the places you've been on the worldwide leaderboard.
The app is free on iOS and Google Play but also offers a paid upgraded version.

15 Best for Finding Recommendations: TripAdvisor

For the unacquainted, TripAdvisor has over 700 million reviews of 8 million destinations to peruse before booking your hotel, dinner reservation, or even planning a day at the museum. Free on both iOS and Google Play, the comprehensive app is available in 28 languages.
You can also follow friends and travel experts for advice that matches your interests, view travel videos, read articles for inspo— and write your own reviews, if you're so inclined.

16 Best for Budgeting: Trabee Pocket

Perfect for the business traveler who needs to track spending and receipts—or anyone who likes to stay on top of budgets—this app also boasts a helpful exchange rate calculator. It's free on iOS and Android with option to upgrade.

17 Best for Remembering Items: PackPoint

"Never Forget Your ______ Again!" is the slogan for PackPoint, which helps you build a packing list based on your trip. Input the dates, location, the type of travel, and the activities you plan on doing, and the app will conveniently generate a list of items you should bring. It even checks the weather to make sure you bring an umbrella or a heavier jacket depending on your destination.

18 Best for Refueling On Road Trips: GasBuddy

Despite the cost-saving benefits of a road trip, gas money can really start to add up if you're driving for days. Enter GasBuddy, which helps you find the best gas prices near you. With at 4.7/5 rating and over 300,000 reviews on Apple, the app has helpful features like a gas price map, outage tracker during natural disasters, a trip cost calculator, and useful search filters like brand, price location, available restrooms, and more.
Bonus, you can save 5¢/gal on every gallon if you use the app's free "Pay with GasBuddy" card.

19 Best For Nature Lovers: AllTrails

If you're like Oprah and think "hiking is so fun," you need to download this app. AllTrails is for nature lovers, hiking enthusiasts, and even those who just want to fit in a cardio workout while on vacation. The app has over 100,000 curated trails—which all but guarantee you'll find one near you—and lets you create and share custom maps with friends.

20 Best For Bathroom Breaks: Flush

When you gotta go, you gotta go, but finding a public toilet when you're traveling can be quite the task. The Flush Toilet Finder saves you time and helps you avoid an accident with the over 190,000 public bathrooms in its database. Flush will tell you which ones are free, accessible for the disabled, or require a key—and users can even rate and report a toilet.
The Flush app is available for free on iOS and Google Play.

21 Best for Urban Explorers: Citymapper

Citymapper helps you find the fastest, easiest way to get around major cities in the U.S., Canada, Asia, Australia, Europe, and Latin America. Offering up-to-the-minute info on mass transit, commuter trains, ferries, bike share, and car services, you'll know the second there's a service disruption or traffic jam (and how long it'll take you to walk instead).
With its directions and maps, the free app will have you zipping around like a true native in no time.

22 Best App for Fear of Flying: SOAR

Has an extreme fear of flying kept you from taking a plane ticket to your dream destination? Since 1982, therapist and former airline pilot Capt. Tom Bunn has offered his SOAR course to nervous fliers. The anxiety-soothing resource is now available on-the-go in this app, including fact-based plane info to start calming your brain down.
"The best feature for me is the Turbulence Tracker," raves O, the Oprah Magazine senior editor Molly Simms. "You hold it in your lap or put on the tray, and it shows you the g-force of the bumps you're experiencing in real time—it proves that they're actually not all that powerful (and not even close to what it would take to like, break a wing off)."

23 Best for Those with Long Layovers: Dayuse

Look, there's plenty of reasons why someone would want a hotel for just a few hours. The only thing Dayuse needs to know is what you're seeking from one of the 5,000 accommodations across 25 countries they can instantly connect you to, and when you need it (start times range from 6 a.m. to 8 a.m.) You'll find rooms marked down by as much as 75 percent for your 1 to 10-hour stay.
Bonus: You can use the hotel's amenities during your abbreviated stay, so take advantage of that pool, gym, or sauna before you head back out.

24 Best App for Happy Campers: RV Parks & Campgrounds

In this app, folks who are all about that RV life will find 40,000 stop-offs anyone on the open road will want to know about: Public and private RV parks and campgrounds, as well as rest areas, gas station, and stores.
The parks are sorted by rating with their amenities listed, and your options include photos so you know what to expect ahead of time. Unlike other RV park apps with similar search capacity, RV Parks & Campgrounds is both ad-free and actually free.

25 Best App for Finding Nightlife on Vacation: Yelp

No, Yelp isn't a travel app per se. But while you may think of it as something you use at home to pick a restaurant for date night, you're going to be the hero of the destination bachelorette party when you find the perfect salsa club spur-of-the-moment.
Search with Yelp's insanely detailed filters to find food, auto repair, and just about every service imaginable. They're all vetted with reviews from fellow users, and the photos of food can save you from a disappointing portion at a "\$\$\$" eatery.
This content is created and maintained by a third party, and imported onto this page to help users provide their email addresses. You may be able to find more information about this and similar content at piano.io
''';
