import 'dart:math' show cos, sqrt, asin;
import 'package:osm_nominatim/osm_nominatim.dart';
import 'Item.dart';

class Calc {
  String radiusPreference;
  List<String> addresses = [];
  List<Item> items = [];
  List myCoor = [];

  Calc(this.radiusPreference, this.items, this.myCoor);

  Future<List<double>> getCordinate(adrrStr) async {
    try {
      final searchResult = await Nominatim.searchByName(
        query: adrrStr,
        limit: 1,
        addressDetails: true,
        extraTags: true,
        nameDetails: true,
      );
      var lat = searchResult.single.lat;
      var lon = searchResult.single.lon;
      return [lat, lon];
    } on Exception catch (e) {
      print('Caught error in getting distance: $e');
      return [];
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double numericalRadius() {
    // return radius_preference as double in km
    var rad;
    if (!radiusPreference.contains("km")) {
      rad = (double.parse(
              radiusPreference.substring(0, radiusPreference.indexOf('0')))) /
          10;
    } else {
      rad = (double.parse(
          radiusPreference.substring(0, radiusPreference.indexOf(' '))));
    }
    return rad;
  }

  Future<double> getDistance(List secAddrCoordinates) async {
    try {
      var dis;
      var lat1 = myCoor[0];
      var lon1 = myCoor[1];
      var lat2 = secAddrCoordinates[0];
      var lon2 = secAddrCoordinates[1];

      if (lat1 != null && lon1 != null && lat2 != null && lon2 != null) {
        dis = calculateDistance(lat1, lon1, lat2, lon2);
        return dis;
      } else {
        return -1;
      }
    } catch (err) {
      print('Caught error in getting distance: $err');
      rethrow;
    }
  }

  //origin function
  Future<List> itemsToAddr() async {
    List<Item> itemsByDistance = [];
    List<int> distances = [];
    var preferedRadius = numericalRadius();
    int disFromMeInMeters;
    double disFromMeInKM;
    for (var i = 0; i < items.length; i++) {
      disFromMeInKM = await getDistance(items[i]
          .uploaderCoordinates); 
      if ((disFromMeInKM != -1) && disFromMeInKM <= preferedRadius) {
        // distance valid & in range
        disFromMeInMeters = (1000 * disFromMeInKM).round();
        itemsByDistance.add(items[i]);
        distances.add(disFromMeInMeters);
      }
    }
    insertionSort(distances, itemsByDistance.length, itemsByDistance);
    return [itemsByDistance, distances];
  }

  void insertionSort(List<int> arr, int n, List<Item> secondArr) {
    if (n <= 1) //passes are done
    {
      return;
    }

    insertionSort(
        arr, n - 1, secondArr); //one element sorted, sort the remaining array

    int last = arr[n - 1]; //last element of the array
    var secondLast = secondArr[n - 1];
    int j = n - 2; //correct index of last element of the array

    while (j >= 0 && arr[j] > last) //find the correct index of the last element
    {
      arr[j + 1] = arr[
          j]; //shift section of sorted elements upwards by one element if correct index isn't found
      secondArr[j + 1] = secondArr[j];
      j--;
    }
    arr[j + 1] = last; //set the last element at its correct index
    secondArr[j + 1] = secondLast;
  }
}
