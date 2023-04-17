import 'package:flutter/material.dart';
import 'dart:math';


String greetings (user) {

  DateTime now = DateTime.now();
  TimeOfDay time = TimeOfDay.fromDateTime(now);



  String result = 'Good evening';

  if (time.hour >= 1 && time.hour <= 10) {
    result = 'Good morning';
  } else if (time.hour >= 11 && time.hour <= 17) {
    result = 'Good afternoon';
  }


  return "$result, $user";
}

List<String> plantingQuotes = [
  "The best time to plant a tree was 20 years ago. The second-best time is now. - Chinese Proverb",
  "A society grows great when old men plant trees whose shade they know they shall never sit in. - Greek Proverb",
  "To plant a garden is to believe in tomorrow. - Audrey Hepburn",
  "The greatest service which can be rendered any country is to add a useful plant to its culture. - Thomas Jefferson",
  "The glory of gardening: hands in the dirt, head in the sun, heart with nature. To nurture a garden is to feed not just the body, but the soul. - Alfred Austin",
  "Plant seeds of happiness, hope, success, and love; it will all come back to you in abundance. This is the law of nature. - Steve Maraboli",
  "Gardening requires lots of water - most of it in the form of perspiration. - Lou Erickson",
  "Gardening is not a rational act. What matters is the immersion of the hands in the earth, that ancient ceremony of which the Pope kissing the tarmac is merely a pallid vestigial remnant. - Margaret Atwood",
  "The earth laughs in flowers. - Ralph Waldo Emerson",
  "If you have a garden and a library, you have everything you need. - Marcus Tullius Cicero"
];

String getRandomPlantingQuote() {
  int randomIndex = Random().nextInt(plantingQuotes.length);
  return plantingQuotes[randomIndex];
}
