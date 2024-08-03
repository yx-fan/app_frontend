import 'package:flutter/material.dart';
import '../views/inbox_view.dart';
import '../views/trip_list_view.dart';
import '../views/profile_view.dart'; // 确保导入你实际的视图
import '../views/map_view.dart';

class NavigationService {
  static void navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TripListView()),
        );
        break;
      case 1:
      
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MapView(tripID: 'all')),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InboxView()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileView()),
        );
        break;
    }
  }
}
