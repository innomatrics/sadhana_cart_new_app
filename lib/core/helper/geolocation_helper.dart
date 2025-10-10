import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sadhana_cart/core/helper/permission_helper.dart';
import 'package:sadhana_cart/features/profile/widget/address/model/address_model.dart';

class GeolocationHelper {
  static Future<LatLng> getCurrrentLocation() async {
    final Permission locationPermission = Permission.location;

    if (await locationPermission.isDenied) {
      await locationPermission.request().isGranted;
    } else {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
      return LatLng(position.latitude, position.longitude);
    }
    return const LatLng(0, 0);
  }

  static Future<AddressModel?> getCurrentLocationAndFillAddressDetails() async {
    try {
      final bool permissionGranted =
          await PermissionHelper.checkLocationPermission();
      if (permissionGranted) {
        final LatLng position = await GeolocationHelper.getCurrrentLocation();
        final List<Placemark> placeMark = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        final address = placeMark.first;
        final AddressModel addressModel = AddressModel(
          streetName: "${address.street}, ${address.subLocality},",
          city: "${address.locality}",
          state: "${address.administrativeArea}",
          pinCode: address.postalCode != null
              ? int.tryParse(address.postalCode!) ?? 0
              : 0,
          lattitude: position.latitude,
          longitude: position.longitude,
        );

        return addressModel;
      } else {
        log("Location permission not granted");
        return null;
      }
    } catch (e) {
      log("address service error $e");
      return null;
    }
  }

  static Future<AddressModel?> initialize() async {
    final AddressModel? address =
        await GeolocationHelper.getCurrentLocationAndFillAddressDetails();
    return address;
  }
}
