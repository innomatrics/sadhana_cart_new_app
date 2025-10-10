// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
//please don't think about why this product model have so many things
//because client not willing to hire people to make changes in excel sheet
//also baapstore are not willing to create form based on our database structure
//i don't have choice now.. if any good developer see this this if you can optimize the model please do
//also explain about data structure to client... there some unused values are storing in the database
//i don't have choice now... sometime the stock count not showing in the product list
//when they upload the product with bulk upload option... that thing is waste until they strictly follow the data structure
//please explain and optimize the data structure to client
//i don't have choice now.. if any good developer see this this if you can optimize the model please do

//here import message
//we mention datetime, timestamp also string.... because of the bulk upload option.. it don't have any option
//if any developer see this means please don't curse us...
import 'dart:convert';

import 'package:sadhana_cart/core/common%20model/product/size_variant.dart';
import 'package:sadhana_cart/core/helper/avoid_null_values.dart';

class ProductModel {
  // Common Fields
  final String? productid;
  final String? name;
  final String? name_lower;
  final String? description;
  final String? category;
  final String? subcategory;
  final String? basesku;
  final String? brand;
  final num? price;
  final num? offerprice;
  final int? stock;
  final List<String>? images;
  final String? sellerid;
  final List<SizeVariant>? sizevariants;
  final String? timestamp;
  final String? date;
  final List<String>? searchkeywords;

  // Fashion / Clothing
  final String? material;
  final String? fit;
  final String? pattern;
  final String? sleevetype;
  final String? careinstruction;
  final List<String>? sizeoptions;
  final String? hsncode;
  final String? weight;
  final String? length;
  final String? width;
  final String? height;
  final String? fittype;
  final String? gender;
  final String? necktype;
  final String? occasion;
  final String? stitchtype;
  final String? vendor;
  final String? variantsku;
  final String? closuretype;
  final String? embroiderystyle;
  final String? lining;
  final String? model;
  final String? neckstyle;
  final String? padtype;
  final String? pockets;
  final String? printtype;
  final String? productlength;
  final String? producttype;
  final String? risestyle;
  final String? sidetype;
  final String? sleeve;
  final String? sleevestyle;
  final String? slittype;
  final String? specialfeatures;
  final String? straptype;
  final String? style;
  final String? transparent;
  final String? type;
  final String? worktype;
  final String? blouseavailability;
  final String? patterncoverage;
  final String? age;
  final String? agegroup;
  final String? waiststyle;

  // Mobile
  final String? mobilecolor;
  final String? ram;
  final String? storage;
  final String? battery;
  final String? camera;
  final String? processor;
  final String? display;
  final String? os;
  final String? connectivity;
  final String? warranty;
  final String? color;
  final String? designoptions;

  // Electronics
  final String? resolution;
  final String? displaytype;
  final String? smartfeatures;
  final String? energyrating;
  final String? powerconsumption;
  final DateTime? expdate;
  final String? mfgdate;
  final String? highlight;
  final String? otherhighlights;

  // Jewellery
  final String? jewellerymaterial;
  final String? purity;
  final String? jewelleryweight;
  final String? jewellerycolor;
  final String? jewellerysize;
  final String? gemstone;
  final String? certification;

  // Book
  final String? title;
  final String? author;
  final String? publisher;
  final String? edition;
  final String? language;
  final String? isbn;
  final int? pages;
  final String? binding;
  final String? genre;

  // Home & Kitchen
  final String? framematerial;
  final String? mountingtype;

  // Beauty
  final String? shadecolor;
  final String? beautytype;
  final List<String>? ingredients;
  final String? skinhairtype;
  final String? beautyweightvolume;
  final String? beautyexpirydate;
  final String? dermatologicallytested;

  // Furniture
  final String? dimension;
  final String? weightcapacity;
  final String? assembly;
  final String? roomtype;

  // Grocery
  final String? weightvolume;
  final String? quantity;
  final String? organic;
  final String? expirydate;
  final String? storageinstruction;
  final String? dietarypreference;

  // Laptop
  final String? graphics;
  final String? screensize;
  final String? operatingsystem;
  final String? port;

  // Footwear
  final String? footwearmaterial;
  final String? footweartype;
  final String? shoesize;
  final String? heelheight;
  final String? solematerial;
  final String? toeshape;
  ProductModel({
    this.productid,
    this.name,
    this.name_lower,
    this.description,
    this.category,
    this.subcategory,
    this.basesku,
    this.brand,
    this.price,
    this.offerprice,
    this.stock,
    this.searchkeywords,
    this.images,
    this.sellerid,
    this.sizevariants,
    this.timestamp,
    this.date,
    this.material,
    this.fit,
    this.pattern,
    this.sleevetype,
    this.careinstruction,
    this.sizeoptions,
    this.hsncode,
    this.weight,
    this.length,
    this.width,
    this.height,
    this.fittype,
    this.gender,
    this.necktype,
    this.occasion,
    this.stitchtype,
    this.vendor,
    this.variantsku,
    this.closuretype,
    this.embroiderystyle,
    this.lining,
    this.model,
    this.neckstyle,
    this.padtype,
    this.pockets,
    this.printtype,
    this.productlength,
    this.producttype,
    this.risestyle,
    this.sidetype,
    this.sleeve,
    this.sleevestyle,
    this.slittype,
    this.specialfeatures,
    this.straptype,
    this.style,
    this.transparent,
    this.type,
    this.worktype,
    this.blouseavailability,
    this.patterncoverage,
    this.age,
    this.agegroup,
    this.waiststyle,
    this.mobilecolor,
    this.ram,
    this.storage,
    this.battery,
    this.camera,
    this.processor,
    this.display,
    this.os,
    this.connectivity,
    this.warranty,
    this.color,
    this.designoptions,
    this.resolution,
    this.displaytype,
    this.smartfeatures,
    this.energyrating,
    this.powerconsumption,
    this.expdate,
    this.mfgdate,
    this.highlight,
    this.otherhighlights,
    this.jewellerymaterial,
    this.purity,
    this.jewelleryweight,
    this.jewellerycolor,
    this.jewellerysize,
    this.gemstone,
    this.certification,
    this.title,
    this.author,
    this.publisher,
    this.edition,
    this.language,
    this.isbn,
    this.pages,
    this.binding,
    this.genre,
    this.framematerial,
    this.mountingtype,
    this.shadecolor,
    this.beautytype,
    this.ingredients,
    this.skinhairtype,
    this.beautyweightvolume,
    this.beautyexpirydate,
    this.dermatologicallytested,
    this.dimension,
    this.weightcapacity,
    this.assembly,
    this.roomtype,
    this.weightvolume,
    this.quantity,
    this.organic,
    this.expirydate,
    this.storageinstruction,
    this.dietarypreference,
    this.graphics,
    this.screensize,
    this.operatingsystem,
    this.port,
    this.footwearmaterial,
    this.footweartype,
    this.shoesize,
    this.heelheight,
    this.solematerial,
    this.toeshape,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productid': productid,
      'name': name,
      'name_lower': name_lower,
      'description': description,
      'category': category,
      'subcategory': subcategory,
      'basesku': basesku,
      'brand': brand,
      'price': price,
      'offerprice': offerprice,
      'stock': stock,
      'images': images,
      'sellerid': sellerid,
      'sizevariants': sizevariants?.map((x) => x.toMap()).toList(),
      'timestamp': timestamp,
      'date': date,
      'material': material,
      'searchkeywords': searchkeywords,
      'fit': fit,
      'pattern': pattern,
      'sleevetype': sleevetype,
      'careinstruction': careinstruction,
      'sizeoptions': sizeoptions,
      'hsncode': hsncode,
      'weight': weight,
      'length': length,
      'width': width,
      'height': height,
      'fittype': fittype,
      'gender': gender,
      'necktype': necktype,
      'occasion': occasion,
      'stitchtype': stitchtype,
      'vendor': vendor,
      'variantsku': variantsku,
      'closuretype': closuretype,
      'embroiderystyle': embroiderystyle,
      'lining': lining,
      'model': model,
      'neckstyle': neckstyle,
      'padtype': padtype,
      'pockets': pockets,
      'printtype': printtype,
      'productlength': productlength,
      'producttype': producttype,
      'risestyle': risestyle,
      'sidetype': sidetype,
      'sleeve': sleeve,
      'sleevestyle': sleevestyle,
      'slittype': slittype,
      'specialfeatures': specialfeatures,
      'straptype': straptype,
      'style': style,
      'transparent': transparent,
      'type': type,
      'worktype': worktype,
      'blouseavailability': blouseavailability,
      'patterncoverage': patterncoverage,
      'age': age,
      'agegroup': agegroup,
      'waiststyle': waiststyle,
      'mobilecolor': mobilecolor,
      'ram': ram,
      'storage': storage,
      'battery': battery,
      'camera': camera,
      'processor': processor,
      'display': display,
      'os': os,
      'connectivity': connectivity,
      'warranty': warranty,
      'color': color,
      'designoptions': designoptions,
      'resolution': resolution,
      'displaytype': displaytype,
      'smartfeatures': smartfeatures,
      'energyrating': energyrating,
      'powerconsumption': powerconsumption,
      'expdate': expdate?.millisecondsSinceEpoch,
      'mfgdate': mfgdate,
      'highlight': highlight,
      'otherhighlights': otherhighlights,
      'jewellerymaterial': jewellerymaterial,
      'purity': purity,
      'jewelleryweight': jewelleryweight,
      'jewellerycolor': jewellerycolor,
      'jewellerysize': jewellerysize,
      'gemstone': gemstone,
      'certification': certification,
      'title': title,
      'author': author,
      'publisher': publisher,
      'edition': edition,
      'language': language,
      'isbn': isbn,
      'pages': pages,
      'binding': binding,
      'genre': genre,
      'framematerial': framematerial,
      'mountingtype': mountingtype,
      'shadecolor': shadecolor,
      'beautytype': beautytype,
      'ingredients': ingredients,
      'skinhairtype': skinhairtype,
      'beautyweightvolume': beautyweightvolume,
      'beautyexpirydate': beautyexpirydate,
      'dermatologicallytested': dermatologicallytested,
      'dimension': dimension,
      'weightcapacity': weightcapacity,
      'assembly': assembly,
      'roomtype': roomtype,
      'weightvolume': weightvolume,
      'quantity': quantity,
      'organic': organic,
      'expirydate': expirydate,
      'storageinstruction': storageinstruction,
      'dietarypreference': dietarypreference,
      'graphics': graphics,
      'screensize': screensize,
      'operatingsystem': operatingsystem,
      'port': port,
      'footwearmaterial': footwearmaterial,
      'footweartype': footweartype,
      'shoesize': shoesize,
      'heelheight': heelheight,
      'solamaterial': solematerial,
      'toeshape': toeshape,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productid: map['productid'],
      searchkeywords: map['searchkeywords'] != null
          ? List.from(map['searchkeywords'])
          : null,
      name_lower: map['name_lower'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      subcategory: map['subcategory'],
      basesku: map['basesku'],
      brand: map['brand'],
      price: map['price'],
      offerprice: map['offerprice'],
      stock: map['stock'],
      images: map['images'] != null ? List.from(map['images']) : null,
      sellerid: map['sellerid'],
      sizevariants: map['sizevariants'] != null
          ? List.from(
              map['sizevariants'],
            ).map((x) => SizeVariant.fromMap(x)).toList()
          : null,
      timestamp: map['timestamp'],
      date: map['date'],
      material: map['material'],
      fit: map['fit'],
      pattern: map['pattern'],
      sleevetype: map['sleevetype'],
      careinstruction: map['careinstruction'],
      sizeoptions: map['sizeoptions'] != null
          ? List.from(map['sizeoptions'])
          : null,
      hsncode: map['hsncode'],
      weight: map['weight'],
      length: map['length'],
      width: map['width'],
      height: map['height'],
      fittype: map['fittype'],
      gender: map['gender'],
      necktype: map['necktype'],
      occasion: map['occasion'],
      stitchtype: map['stitchtype'],
      vendor: map['vendor'],
      variantsku: map['variantsku'],
      closuretype: map['closuretype'],
      embroiderystyle: map['embroiderystyle'],
      lining: map['lining'],
      model: map['model'],
      neckstyle: map['neckstyle'],
      padtype: map['padtype'],
      pockets: map['pockets'],
      printtype: map['printtype'],
      productlength: map['productlength'],
      producttype: map['producttype'],
      risestyle: map['risestyle'],
      sidetype: map['sidetype'],
      sleeve: map['sleeve'],
      sleevestyle: map['sleevestyle'],
      slittype: map['slittype'],
      specialfeatures: map['specialfeatures'],
      straptype: map['straptype'],
      style: map['style'],
      transparent: map['transparent'],
      type: map['type'],
      worktype: map['worktype'],
      blouseavailability: map['blouseavailability'],
      patterncoverage: map['patterncoverage'],
      age: map['age'],
      agegroup: map['agegroup'],
      waiststyle: map['waiststyle'],
      mobilecolor: map['mobilecolor'],
      ram: map['ram'],
      storage: map['storage'],
      battery: map['battery'],
      camera: map['camera'],
      processor: map['processor'],
      display: map['display'],
      os: map['os'],
      connectivity: map['connectivity'],
      warranty: map['warranty'],
      color: map['color'],
      designoptions: map['designoptions'],
      resolution: map['resolution'],
      displaytype: map['displaytype'],
      smartfeatures: map['smartfeatures'],
      energyrating: map['energyrating'],
      powerconsumption: map['powerconsumption'],
      expdate: map['expdate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['expdate'])
          : null,
      mfgdate: map['mfgdate'],
      highlight: map['highlight'],
      otherhighlights: map['otherhighlights'],
      jewellerymaterial: map['jewellerymaterial'],
      purity: map['purity'],
      jewelleryweight: map['jewelleryweight'],
      jewellerycolor: map['jewellerycolor'],
      jewellerysize: map['jewellerysize'],
      gemstone: map['gemstone'],
      certification: map['certification'],
      title: map['title'],
      author: map['author'],
      publisher: map['publisher'],
      edition: map['edition'],
      language: map['language'],
      isbn: map['isbn'],
      pages: map['pages'],
      binding: map['binding'],
      genre: map['genre'],
      framematerial: map['framematerial'],
      mountingtype: map['mountingtype'],
      shadecolor: map['shadecolor'],
      beautytype: map['beautytype'],
      ingredients: map['ingredients'] != null
          ? List.from(map['ingredients'])
          : null,
      skinhairtype: map['skinhairtype'],
      beautyweightvolume: map['beautyweightvolume'],
      beautyexpirydate: map['beautyexpirydate'],
      dermatologicallytested: map['dermatologicallytested'],
      dimension: map['dimension'],
      weightcapacity: map['weightcapacity'],
      assembly: map['assembly'],
      roomtype: map['roomtype'],
      weightvolume: map['weightvolume'],
      quantity: map['quantity'],
      organic: map['organic'],
      expirydate: map['expirydate'],
      storageinstruction: map['storageinstruction'],
      dietarypreference: map['dietarypreference'],
      graphics: map['graphics'],
      screensize: map['screensize'],
      operatingsystem: map['operatingsystem'],
      port: map['port'],
      footwearmaterial: map['footwearmaterial'],
      footweartype: map['footweartype'],
      shoesize: map['shoesize'],
      heelheight: map['heelheight'],
      solematerial: map['solematerial'],
      toeshape: map['toeshape'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  //this is the code will help you by getting products attributes by category
  Map<String, dynamic> getDetailsByCategory() {
    final allDetails = {
      'material': material,
      'fit': fit,
      'pattern': pattern,
      'sleevetype': sleevetype,
      'careinstruction': careinstruction,
      'sizeoptions': sizeoptions,
      'hsncode': hsncode,
      'weight': weight,
      'length': length,
      'width': width,
      'height': height,
      'fittype': fittype,
      'gender': gender,
      'necktype': necktype,
      'occasion': occasion,
      'stitchtype': stitchtype,
      'vendor': vendor,
      'variantsku': variantsku,
      'closuretype': closuretype,
      'embroiderystyle': embroiderystyle,
      'lining': lining,
      'model': model,
      'neckstyle': neckstyle,
      'padtype': padtype,
      'pockets': pockets,
      'printtype': printtype,
      'productlength': productlength,
      'producttype': producttype,
      'risestyle': risestyle,
      'sidetype': sidetype,
      'sleeve': sleeve,
      'sleevestyle': sleevestyle,
      'slittype': slittype,
      'specialfeatures': specialfeatures,
      'straptype': straptype,
      'style': style,
      'transparent': transparent,
      'type': type,
      'worktype': worktype,
      'blouseavailability': blouseavailability,
      'patterncoverage': patterncoverage,
      'age': age,
      'agegroup': agegroup,
      'waiststyle': waiststyle,
      'mobilecolor': mobilecolor,
      'ram': ram,
      'storage': storage,
      'battery': battery,
      'camera': camera,
      'processor': processor,
      'display': display,
      'os': os,
      'connectivity': connectivity,
      'warranty': warranty,
      'color': color,
      'designoptions': designoptions,
      'resolution': resolution,
      'displaytype': displaytype,
      'smartfeatures': smartfeatures,
      'energyrating': energyrating,
      'powerconsumption': powerconsumption,
      'expdate': expdate,
      'mfgdate': mfgdate,
      'highlight': highlight,
      'otherhighlights': otherhighlights,
      'jewellerymaterial': jewellerymaterial,
      'purity': purity,
      'jewelleryweight': jewelleryweight,
      'jewellerycolor': jewellerycolor,
      'jewellerysize': jewellerysize,
      'gemstone': gemstone,
      'certification': certification,
      'title': title,
      'author': author,
      'publisher': publisher,
      'edition': edition,
      'language': language,
      'isbn': isbn,
      'pages': pages,
      'binding': binding,
      'genre': genre,
      'framematerial': framematerial,
      'mountingtype': mountingtype,
      'shadecolor': shadecolor,
      'beautytype': beautytype,
      'ingredients': ingredients,
      'skinhairtype': skinhairtype,
      'beautyweightvolume': beautyweightvolume,
      'beautyexpirydate': beautyexpirydate,
      'dermatologicallytested': dermatologicallytested,
      'dimension': dimension,
      'weightcapacity': weightcapacity,
      'assembly': assembly,
      'roomtype': roomtype,
      'weightvolume': weightvolume,
      'quantity': quantity,
      'organic': organic,
      'expirydate': expirydate,
      'storageinstruction': storageinstruction,
      'dietarypreference': dietarypreference,
      'graphics': graphics,
      'screensize': screensize,
      'operatingsystem': operatingsystem,
      'port': port,
      'footwearmaterial': footwearmaterial,
      'footweartype': footweartype,
      'shoesize': shoesize,
      'heelheight': heelheight,
      'solematerial': solematerial,
      'toeshape': toeshape,
    };

    final details = AvoidNullValues.removeNullValuesDeep(allDetails);

    return details;
  }

  @override
  String toString() {
    return 'ProductModel(productid: $productid, name: $name, description: $description, category: $category, subcategory: $subcategory, basesku: $basesku, brand: $brand, price: $price, offerprice: $offerprice, stock: $stock, images: $images, sellerid: $sellerid, sizevariants: $sizevariants, timestamp: $timestamp, date: $date, material: $material, fit: $fit, pattern: $pattern, sleevetype: $sleevetype, careinstruction: $careinstruction, sizeoptions: $sizeoptions, hsncode: $hsncode, weight: $weight, length: $length, width: $width, height: $height, fittype: $fittype, gender: $gender, necktype: $necktype, occasion: $occasion, stitchtype: $stitchtype, vendor: $vendor, variantsku: $variantsku, closuretype: $closuretype, embroiderystyle: $embroiderystyle, lining: $lining, model: $model, neckstyle: $neckstyle, padtype: $padtype, pockets: $pockets, printtype: $printtype, productlength: $productlength, producttype: $producttype, risestyle: $risestyle, sidetype: $sidetype, sleeve: $sleeve, sleevestyle: $sleevestyle, slittype: $slittype, specialfeatures: $specialfeatures, straptype: $straptype, style: $style, transparent: $transparent, type: $type, worktype: $worktype, blouseavailability: $blouseavailability, patterncoverage: $patterncoverage, age: $age, agegroup: $agegroup, waiststyle: $waiststyle, mobilecolor: $mobilecolor, ram: $ram, storage: $storage, battery: $battery, camera: $camera, processor: $processor, display: $display, os: $os, connectivity: $connectivity, warranty: $warranty, color: $color, designoptions: $designoptions, resolution: $resolution, displaytype: $displaytype, smartfeatures: $smartfeatures, energyrating: $energyrating, powerconsumption: $powerconsumption, expdate: $expdate, mfgdate: $mfgdate, highlight: $highlight, otherhighlights: $otherhighlights, jewellerymaterial: $jewellerymaterial, purity: $purity, jewelleryweight: $jewelleryweight, jewellerycolor: $jewellerycolor, jewellerysize: $jewellerysize, gemstone: $gemstone, certification: $certification, title: $title, author: $author, publisher: $publisher, edition: $edition, language: $language, isbn: $isbn, pages: $pages, binding: $binding, genre: $genre, framematerial: $framematerial, mountingtype: $mountingtype, shadecolor: $shadecolor, beautytype: $beautytype, ingredients: $ingredients, skinhairtype: $skinhairtype, beautyweightvolume: $beautyweightvolume, beautyexpirydate: $beautyexpirydate, dermatologicallytested: $dermatologicallytested, dimension: $dimension, weightcapacity: $weightcapacity, assembly: $assembly, roomtype: $roomtype, weightvolume: $weightvolume, quantity: $quantity, organic: $organic, expirydate: $expirydate, storageinstruction: $storageinstruction, dietarypreference: $dietarypreference, graphics: $graphics, screensize: $screensize, operatingsystem: $operatingsystem, port: $port, footwearmaterial: $footwearmaterial, footweartype: $footweartype, shoesize: $shoesize, heelheight: $heelheight, solematerial: $solematerial, toeshape: $toeshape)';
  }
}
