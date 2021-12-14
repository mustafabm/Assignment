import 'package:flutter/material.dart';

class Option {
  String name;
  int id;
  bool selected;
  Widget icon;
  Facility facility;
  Option(this.name, this.id, this.selected, this.icon, this.facility);
}

class Facility {
  String name;
  int id;
  Facility(this.name, this.id);
}

Map<String, Widget> icons = {
  'apartment': const Icon(Icons.apartment),
  'condo': const Icon(Icons.house),
  'boat': const Icon(Icons.directions_boat),
  'land': const Icon(Icons.landscape),
  'rooms': const Icon(Icons.local_hotel),
  'no-room': const Icon(Icons.no_meeting_room),
  'swimming': const Icon(Icons.pool),
  'garden': const Icon(Icons.local_florist),
  'garage': const Icon(Icons.garage),
};
