// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sadhana_cart/core/common%20model/product/size_variant.dart';

class OrderModel {
  final int quantity;
  final String? userId;
  final double totalAmount;
  final String? address;
  final int phoneNumber;
  final double latitude;
  final double longitude;
  final String? orderStatus;
  final Timestamp orderDate;
  final String? orderId;
  final Timestamp createdAt;
  final int? shipmentId;
  final List<OrderProductModel> products;
  final String? paymentId;
  final double? shippingCharges;

  // Shiprocket fields
  final int? shiprocketOrderId;
  final String? shiprocketStatus;

  // Payment method: COD or Online
  final String? paymentMethod;

  OrderModel({
    required this.quantity,
    this.userId,
    required this.totalAmount,
    this.address,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    this.orderStatus,
    required this.orderDate,
    this.orderId,
    this.shipmentId,
    required this.createdAt,
    required this.products,
    this.shiprocketOrderId,
    this.shiprocketStatus,
    this.paymentMethod,
    this.paymentId,
    this.shippingCharges,
  });

  // copyWith for immutability
  OrderModel copyWith({
    int? quantity,
    String? userId,
    double? totalAmount,
    String? address,
    int? phoneNumber,
    double? latitude,
    double? longitude,
    String? orderStatus,
    Timestamp? orderDate,
    String? orderId,
    int? shipmentId,
    Timestamp? createdAt,
    List<OrderProductModel>? products,
    int? shiprocketOrderId,
    String? shiprocketStatus,
    String? paymentMethod,
    String? paymentId,
    double? shippingCharges,
  }) {
    return OrderModel(
      quantity: quantity ?? this.quantity,
      userId: userId ?? this.userId,
      totalAmount: totalAmount ?? this.totalAmount,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      latitude: latitude ?? this.latitude,
      shipmentId: shipmentId ?? this.shipmentId,
      longitude: longitude ?? this.longitude,
      orderStatus: orderStatus ?? this.orderStatus,
      orderDate: orderDate ?? this.orderDate,
      orderId: orderId ?? this.orderId,
      createdAt: createdAt ?? this.createdAt,
      products: products ?? this.products,
      shiprocketOrderId: shiprocketOrderId ?? this.shiprocketOrderId,
      shiprocketStatus: shiprocketStatus ?? this.shiprocketStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentId: paymentId ?? this.paymentId,
      shippingCharges: shippingCharges ?? this.shippingCharges,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'userId': userId,
      'totalAmount': totalAmount,
      'address': address,
      'phoneNumber': phoneNumber,
      'shipmentId': shipmentId,
      'latitude': latitude,
      'longitude': longitude,
      'orderStatus': orderStatus,
      'orderDate': orderDate,
      'orderId': orderId,
      'createdAt': createdAt,
      'products': products.map((x) => x.toMap()).toList(),
      'shiprocketOrderId': shiprocketOrderId,
      'shiprocketStatus': shiprocketStatus,
      'paymentMethod': paymentMethod,
      'paymentId': paymentId,
      'shippingCharges': shippingCharges,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      quantity: map['quantity'] != null ? (map['quantity'] as num).toInt() : 0,
      userId: map['userId']?.toString(),
      totalAmount: map['totalAmount'] != null
          ? (map['totalAmount'] as num).toDouble()
          : 0.0,
      address: map['address']?.toString(),
      phoneNumber: map['phoneNumber'] != null
          ? (map['phoneNumber'] as num).toInt()
          : 0,
      latitude: map['latitude'] != null
          ? (map['latitude'] as num).toDouble()
          : 0.0,
      shipmentId: map['shipmentId'] != null
          ? (map['shipmentId'] as num).toInt()
          : null,
      longitude: map['longitude'] != null
          ? (map['longitude'] as num).toDouble()
          : 0.0,
      orderStatus: map['orderStatus']?.toString(),
      orderDate: map['orderDate'] as Timestamp? ?? Timestamp.now(),
      orderId: map['orderId']?.toString(),
      createdAt: map['createdAt'] as Timestamp? ?? Timestamp.now(),
      products: map['products'] != null
          ? List<OrderProductModel>.from(
              (map['products'] as List<dynamic>).map(
                (x) => OrderProductModel.fromMap(x),
              ),
            )
          : [],
      shiprocketOrderId: map['shiprocketOrderId'] != null
          ? (map['shiprocketOrderId'] as num).toInt()
          : null,
      shiprocketStatus: map['shiprocketStatus']?.toString(),
      paymentMethod: map['paymentMethod']?.toString(),
      paymentId: map['paymentId']?.toString(),
      shippingCharges: map['shippingCharges'] != null
          ? (map['shippingCharges'] as num).toDouble()
          : 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderModel(quantity: $quantity, userId: $userId, totalAmount: $totalAmount, address: $address, phoneNumber: $phoneNumber, latitude: $latitude, longitude: $longitude, orderStatus: $orderStatus, orderDate: $orderDate, orderId: $orderId, createdAt: $createdAt, shipmentId: $shipmentId, products: $products, paymentId: $paymentId, shippingCharges: $shippingCharges, shiprocketOrderId: $shiprocketOrderId, shiprocketStatus: $shiprocketStatus, paymentMethod: $paymentMethod)';
  }
}

class OrderProductModel {
  final String? id;
  final String? productid;
  final String? name;
  final double? price;
  final int? stock;
  final int? quantity;
  final List<SizeVariant>? sizevariants;
  final String? sku;
  final String? hsn;
  final num? height;
  final num? width;
  final num? length;
  final num? weight;
  final List<String>? images;

  OrderProductModel({
    this.id,
    this.productid,
    this.name,
    this.price,
    this.stock,
    this.quantity,
    this.sizevariants,
    this.sku,
    this.hsn,
    this.height,
    this.width,
    this.length,
    this.weight,
    this.images,
  });

  OrderProductModel copyWith({
    String? id,
    String? productid,
    String? name,
    double? price,
    int? stock,
    int? quantity,
    List<SizeVariant>? sizevariants,
    String? sku,
    String? hsn,
    num? height,
    num? width,
    num? length,
    num? weight,
    List<String>? images,
  }) {
    return OrderProductModel(
      id: id ?? this.id,
      productid: productid ?? this.productid,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      quantity: quantity ?? this.quantity,
      sizevariants: sizevariants ?? this.sizevariants,
      sku: sku ?? this.sku,
      hsn: hsn ?? this.hsn,
      height: height ?? this.height,
      width: width ?? this.width,
      length: length ?? this.length,
      weight: weight ?? this.weight,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productid': productid,
      'name': name,
      'price': price,
      'stock': stock,
      'quantity': quantity,
      'sizevariants': sizevariants?.map((x) => x.toMap()).toList(),
      'sku': sku,
      'hsn': hsn,
      'height': height,
      'width': width,
      'length': length,
      'weight': weight,
      'images': images,
    };
  }

  factory OrderProductModel.fromMap(Map<String, dynamic> map) {
    return OrderProductModel(
      id: map['id'] != null ? map['id'] as String : null,
      productid: map['productid'] != null ? map['productid'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      price: map['price'] != null ? map['price'] as double : null,
      stock: map['stock'] != null ? map['stock'] as int : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      sizevariants: map['sizevariants'] != null
          ? List<SizeVariant>.from(
              (map['sizevariants'] as List<dynamic>).map<SizeVariant?>(
                (x) => SizeVariant.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,

      sku: map['sku'] != null ? map['sku'] as String : null,
      hsn: map['hsn'] != null ? map['hsn'] as String : null,
      height: map['height'] != null ? map['height'] as num : null,
      width: map['width'] != null ? map['width'] as num : null,
      length: map['length'] != null ? map['length'] as num : null,
      weight: map['weight'] != null ? map['weight'] as num : null,
      images: map['images'] != null
          ? List<String>.from(
              (map['images'] as List<dynamic>).map((x) => x.toString()),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderProductModel.fromJson(String source) =>
      OrderProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderProductModel(id: $id, productid: $productid, name: $name, price: $price, stock: $stock, quantity: $quantity, sizevariants: $sizevariants, sku: $sku, hsn: $hsn, height: $height, width: $width, length: $length, weight: $weight, images: $images)';
  }
}
