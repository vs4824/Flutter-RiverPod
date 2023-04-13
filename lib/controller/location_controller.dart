import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_geocoder/location_geocoder.dart' as geocoders;
import 'package:riverpod_examples/keys/api_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model_class/address_model.dart';
import '../utils/shared_pref_keys.dart';


final locationProvider = Provider<LocationController>((ref) => LocationController());


class LocationController extends StatelessWidget{
  var lat = 0.0;
  var long = 0.0;
  bool getCurrentLocation = true;
  bool toShowEnableLocationDialog = true;
  // late Address addressModel;
  String address = "";
  String fullAddress = "";
  String city = "";
  String state = "";
  String zipCode = "";
  String addressLine1 = "";
  var addressModel = Address();


  @override
  Widget build(BuildContext context) {
    initializeAddress();
    return Container();
  }

  Future initializeAddress({Position? position}) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString(saveAddressKey)?.isNotEmpty ?? false) {
      lat = prefs.getDouble(latitudeKey) ?? 0.0;
      long = prefs.getDouble(longitudeKey) ?? 0.0;

      fullAddress = prefs.getString(fullAddressKey) ?? "";
      address = fullAddress;
      print(address);
      addressModel = Address.decode(prefs.getString(saveAddressKey) ?? "");
    }
    else {
      final geocoders.LocatitonGeocoder geocoder = geocoders.LocatitonGeocoder(APIKey.mapsApiKey);
      if(position != null){
        print(position);
        final loc = await geocoder
            .findAddressesFromCoordinates(geocoders.Coordinates(position.latitude, position.longitude));
        address = loc[0].addressLine.toString();
      }
      else{
        print(position);
        Position positions = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        final loc = await geocoder
            .findAddressesFromCoordinates(geocoders.Coordinates(positions.latitude, positions.longitude));
        address = loc[0].addressLine.toString();
      }
    }
    return address;
  }

  void saveLatLong(
    double lat,
    double long,
    String city,
    String state,
    String zipCode,
    String addressLine1,
    String address,
  ) async {
    this.lat = lat;
    this.long = long;
    this.city = city;
    this.state = state;
    this.zipCode = zipCode;
    this.address = address;
    fullAddress = address;
    addressModel.addressId = "";
    addressModel.city = city;
    addressModel.fullAddress = address;
    addressModel.lat = lat.toString();
    addressModel.lng = long.toString();
    addressModel.zipCode = zipCode;
    addressModel.addressLine1 = addressLine1;
    addressModel.state = state;

    print(address);
    print(lat);
    print(long);
    await saveDataToPrefs();
    // update();
  }

  Future<void> saveDataToPrefs() async {
    addressModel.city = city;
    addressModel.fullAddress = fullAddress;
    addressModel.lat = lat.toString();
    addressModel.lng = long.toString();
    addressModel.addressLine1 = addressLine1;
    addressModel.state = state;
    addressModel.zipCode = zipCode;
    addressModel.addressId = "";

    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(latitudeKey, lat);
    await prefs.setDouble(longitudeKey, long);
    await prefs.setString(fullAddressKey, fullAddress);
    await prefs.setString(saveAddressKey, Address.encode(addressModel));
  }

  void updateLocationToggleStatus(bool toggle) {
    getCurrentLocation = toggle;
    // update();
  }
}
