import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/event_detail.dart';
import '../models/favorite.dart';

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future addFavorite(EventDetail eventDetail, String uid) async {
    Favorite fav = Favorite(id: null, eventId: eventDetail.id!, userId: uid);
    final ref = await db.collection('favourites').add(fav.toMap1());
    fav.id = ref.id;
    await ref.update({'id': ref.id});
    return fav;
  }

  static Future deleteFavorite(String favId) async {
    await db.collection('favourites').doc(favId).delete();
  }

  static Future<List<Favorite>> getUserFavorites(String uid) async {
    List<Favorite> favs;
    var documents =
        await db.collection('favourites').where('userId', isEqualTo: uid).get();
    favs = documents.docs.map((data) => Favorite.fromMap(data)).toList();
    return favs;
  }
}
