import 'package:hive/hive.dart';
import 'package:sadhana_cart/core/common%20model/banner/banner_model.dart';
import 'package:sadhana_cart/core/common%20model/brand/brand_model.dart';
import 'package:sadhana_cart/core/common%20model/cart/cart_model.dart';
import 'package:sadhana_cart/core/common%20model/category/category_model.dart';
import 'package:sadhana_cart/core/common%20model/favorite/favorite_model.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20model/search%20field/search_field_model.dart';
import 'package:sadhana_cart/core/common%20model/subcategory/subcategory_model.dart';

class HiveHelper {
  static const String bannerBox = 'bannerBox';
  static const String categoryBox = 'categoryBox';
  static const String searchBox = 'searchBox';
  static const String subcategoryBox = 'subcategoryBox';
  static const String productBox = 'productBox';
  static const String favoriteBox = 'favoriteBox';
  static const String cartBox = 'cartBox';
  static const String brandBox = 'brandBox';
  static const String localData = 'localDataBox';

  //store local things
  static Future<void> storeLocalData<E>({
    required String key,
    required E value,
  }) async {
    final box = Hive.box(localData);
    await box.put(key, value);
  }

  static E? getLocalData<E>({required String key}) {
    final box = Hive.box(localData);
    return box.get(key) as E?;
  }

  //banners
  static Future<void> addBanners({required BannerModel banner}) async {
    final box = Hive.box<BannerModel>(bannerBox);
    await box.put(banner.bannerId, banner);
  }

  static List<BannerModel> getBannerModel() {
    final box = Hive.box<BannerModel>(bannerBox);
    return box.values.toList();
  }

  //categories
  static Future<void> addCategories({required CategoryModel category}) async {
    final box = Hive.box<CategoryModel>(categoryBox);
    await box.put(category.id, category);
  }

  static List<CategoryModel> getCategoryModel() {
    final box = Hive.box<CategoryModel>(categoryBox);
    return box.values.toList();
  }

  //search field
  static Future<void> addSearchField({required SearchFieldModel search}) async {
    final box = Hive.box<SearchFieldModel>(searchBox);
    await box.put(search.searchField, search);
  }

  //subcategory
  static Future<void> addSubcategory({
    required SubcategoryModel subcategory,
  }) async {
    final box = Hive.box<SubcategoryModel>(subcategoryBox);
    await box.put(subcategory.id, subcategory);
  }

  static List<SubcategoryModel> getSubcategory() {
    final box = Hive.box<SubcategoryModel>(subcategoryBox);
    return box.values.toList();
  }
  //cart

  static Future<void> addCart({required CartModel cart}) async {
    final box = Hive.box<CartModel>(cartBox);
    box.put(cart.productid, cart);
  }

  static Set<CartModel> getCart() {
    final box = Hive.box<CartModel>(cartBox);
    return box.values.toSet();
  }

  static Future<void> deleteCart({required String key}) async {
    final box = Hive.box<CartModel>(cartBox);
    await box.delete(key);
  }

  //favorite
  static Future<void> addFavorites({required FavoriteModel favorite}) async {
    final box = Hive.box<FavoriteModel>(favoriteBox);
    await box.put(favorite.productid, favorite);
  }

  static Set<ProductModel> getFavorite() {
    final box = Hive.box<ProductModel>(favoriteBox);
    return box.values.toSet();
  }

  static Future<void> deleteFavorite({required String key}) async {
    final box = Hive.box<FavoriteModel>(favoriteBox);
    await box.delete(key);
  }

  //brand

  static Future<void> addBrand({required BrandModel brand}) async {
    final box = Hive.box<BrandModel>(brandBox);
    await box.put(brand.id, brand);
  }

  static List<BrandModel> getBrands() {
    final box = Hive.box<BrandModel>(brandBox);
    return box.values.toList();
  }
}
