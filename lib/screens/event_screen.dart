import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/models/event_detail.dart';
import 'package:events/models/favorite.dart';
import 'package:events/screens/login_screen.dart';
import 'package:events/shared/auth.dart';
import 'package:events/shared/firestore_helper.dart';
import 'package:flutter/material.dart';

final eventsRef = FirebaseFirestore.instance
    .collection('event_details')
    .withConverter<EventDetail>(
      fromFirestore: (snapshot, options) =>
          EventDetail.fromJson(snapshot.data()!),
      toFirestore: (eventDeatail, _) => eventDeatail.toJson(),
    );

class EventScreen extends StatelessWidget {
  EventScreen({super.key, required this.uid});

  final String uid;

  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event'),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((result) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                });
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: EventList(
        uid: uid,
      ),
    );
  }
}

class EventList extends StatefulWidget {
  const EventList({super.key, required this.uid});

  final String uid;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  List<EventDetail> eventDetails = [];
  List<Favorite> favs = [];

  final Auth auth = Auth();
  String? url;

  @override
  void initState() {
    if (mounted) {
      getEventData().then(
        (value) {
          setState(() {
            eventDetails = value;
          });
        },
      );
    }
    FirestoreHelper.getUserFavorites(widget.uid).then((data) {
      setState(() {
        favs = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: eventDetails.length,
            itemBuilder: (context, index) {
              Color starColor = isEventAFavorite(eventDetails[index].id!, favs)
                  ? Colors.amber
                  : Colors.grey;
              String sub =
                  'Date: ${eventDetails[index].date} - Start: ${eventDetails[index].startTime} - End: ${eventDetails[index].endTime}';
              return ListTile(
                title: Text(eventDetails[index].description),
                subtitle: Text(sub),
                trailing: IconButton(
                  icon: const Icon(Icons.star),
                  color: starColor,
                  onPressed: () {
                    toggleFavorite(eventDetails[index]);
                  },
                ),
              );
            },
          ),
        ),
        url == null
            ? const CircularProgressIndicator()
            : Image.network(
                url!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
        ElevatedButton(
            onPressed: () async {
              String? downloadUrl = await auth.downloadFile();
              setState(() {
                url = downloadUrl;
                print(url);
              });
            },
            child: const Text("Download me!")),
      ],
    );
  }

  Future<void> toggleFavorite(EventDetail ed) async {
    if (isEventAFavorite(ed.id!, favs)) {
      print("yes it is fav");
      Favorite favourite = favs.firstWhere((f) => (f.eventId == ed.id));
      String favId = favourite.id!;
      await FirestoreHelper.deleteFavorite(favId);
    } else {
      await FirestoreHelper.addFavorite(ed, widget.uid);
    }
    List<Favorite> updatedFavourites =
        await FirestoreHelper.getUserFavorites(widget.uid);
    print(updatedFavourites.length);
    setState(() {
      favs = updatedFavourites;
    });
  }

  bool isEventAFavorite(String eventId, List<Favorite> favorites) {
    return favorites.any((f) => f.eventId == eventId);
  }

  Future<List<EventDetail>> getEventData() async {
    var data =
        await FirebaseFirestore.instance.collection('event_details').get();
    eventDetails =
        data.docs.map((document) => EventDetail.fromJson(document)).toList();
    int i = 0;
    for (var detail in eventDetails) {
      detail.id = data.docs[i].id;
      i++;
    }
    return eventDetails;
  }
}
