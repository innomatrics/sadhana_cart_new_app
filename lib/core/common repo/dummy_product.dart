// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
// // import 'package:sadhana_cart/core/common%20model/product/size_variant.dart';

// // // Category Model
// // class CategoryModel {
// //   final String categoryId;
// //   final String name;
// //   final String image;
// //   final List<SubCategoryModel> subcategories;

// //   CategoryModel({
// //     required this.categoryId,
// //     required this.name,
// //     required this.image,
// //     required this.subcategories,
// //   });
// // }

// // class SubCategoryModel {
// //   final String subcategoryId;
// //   final String name;
// //   final List<ProductModel> products;

// //   SubCategoryModel({
// //     required this.subcategoryId,
// //     required this.name,
// //     required this.products,
// //   });
// // }

// // final List<CategoryModel> categories = [
// //   // ---------------- ELECTRONICS ----------------
// //   CategoryModel(
// //     categoryId: "C001",
// //     name: "Electronics",
// //     image: "https://www.balajimultisales.in/images/E6.png",
// //     subcategories: [
// //       SubCategoryModel(
// //         subcategoryId: "SC001",
// //         name: "Mobiles",
// //         products: [
// //           ProductModel(
// //             productId: "P001",
// //             name: "Samsung Galaxy S23 Ultra",
// //             description:
// //                 "Flagship mobile with Snapdragon 8 Gen 2, 200MP camera, 5000mAh battery.",
// //             category: "Electronics",
// //             subcategory: "Mobiles",
// //             baseSku: "S23ULTRA",
// //             brand: "Samsung",
// //             price: 1199.99,
// //             offerPrice: 1099.99,
// //             rating: 4.9,
// //             timestamp: Timestamp.now(),
// //             images: [
// //               "https://m.media-amazon.com/images/I/71Sa3dqTqzL._SL1500_.jpg",
// //             ],
// //             cashOnDelivery: true,
// //             ram: "12GB",
// //             storage: "256GB",
// //             battery: "5000mAh",
// //             camera: "200MP + 12MP + 10MP",
// //             processor: "Snapdragon 8 Gen 2",
// //             display: "6.8-inch QHD+ AMOLED",
// //             os: "Android 13",
// //             connectivity: "5G, WiFi 6E, Bluetooth 5.3",
// //             warranty: "1 Year Manufacturer",
// //             sizeVariants: [],
// //           ),
// //         ],
// //       ),
// //       SubCategoryModel(
// //         subcategoryId: "SC002",
// //         name: "Laptops",
// //         products: [
// //           ProductModel(
// //             productId: "P002",
// //             name: "Apple MacBook Air M2",
// //             description:
// //                 "13.6-inch Liquid Retina Display, M2 Chip, 8GB RAM, 256GB SSD.",
// //             category: "Electronics",
// //             subcategory: "Laptops",
// //             baseSku: "MBA-M2",
// //             brand: "Apple",
// //             price: 1299.99,
// //             offerPrice: 1199.99,
// //             rating: 4.8,
// //             timestamp: Timestamp.now(),
// //             images: [
// //               "https://m.media-amazon.com/images/I/71vFKBpKakL._SL1500_.jpg",
// //             ],
// //             cashOnDelivery: false,
// //             graphics: "Integrated 10-core GPU",
// //             screenSize: "13.6-inch",
// //             operatingSystem: "macOS Ventura",
// //             weight: "1.24kg",
// //             resolution: "2560x1664",
// //             port: "MagSafe, Thunderbolt 4",
// //             sizeVariants: [],
// //           ),
// //         ],
// //       ),
// //     ],
// //   ),

// <<<<<<< HEAD
//   // ---------------- ACCESSORIES ----------------
//   CategoryModel(
//     categoryId: "C002",
//     name: "Accessories",
//     image:
//         "https://img.freepik.com/free-photo/women-s-day-still-life-with-makeup-jewelry_23-2149263158.jpg",
//     subcategories: [
//       SubCategoryModel(
//         subcategoryId: "SC003",
//         name: "Jewelry",
//         products: [
//           ProductModel(
//             productId: "P003",
//             name: "Gold Chain for Men",
//             description:
//                 "22K pure gold chain ideal for festive and casual wear.",
//             category: "Accessories",
//             subcategory: "Jewelry",
//             baseSku: "GOLDCHAIN22K",
//             brand: "Tanishq",
//             price: 599.99,
//             offerPrice: 549.99,
//             rating: 4.6,
//             timestamp: Timestamp.now(),
//             images: [
//               "https://priyaasi.com/cdn/shop/products/BD-CH-10005.M_1800x1800.jpg",
//             ],
//             cashOnDelivery: true,
//             jewelleryMaterial: "Gold",
//             purity: "22K",
//             jewelleryWeight: "12g",
//             jewelleryColor: "Yellow Gold",
//             gender: "Men",
//             certification: "BIS Hallmark",
//             occasion: "Festive, Casual",
//             sizeVariants: [],
//           ),
//           ProductModel(
//             productId: "P004",
//             name: "Diamond Ring for Women",
//             description: "18K gold diamond ring with IGI certification.",
//             category: "Accessories",
//             subcategory: "Jewelry",
//             baseSku: "DIARING18K",
//             brand: "PC Jewellers",
//             price: 899.99,
//             offerPrice: 799.99,
//             rating: 4.7,
//             timestamp: Timestamp.now(),
//             images: [
//               "https://mohanjewellery.com/wp-content/uploads/2020/12/PR21119-D-P_1576173756.jpg",
//             ],
//             cashOnDelivery: false,
//             jewelleryMaterial: "Gold + Diamond",
//             purity: "18K",
//             jewelleryWeight: "6g",
//             jewelleryColor: "Rose Gold",
//             gender: "Women",
//             gemstone: "Diamond",
//             certification: "IGI Certified",
//             occasion: "Engagement, Wedding",
//             sizeVariants: [],
//           ),
//         ],
//       ),
//     ],
//   ),

//   // ---------------- HOME & KITCHEN ----------------
//   CategoryModel(
//     categoryId: "C003",
//     name: "Home & Kitchen",
//     image:
//         "https://www.shutterstock.com/image-photo/kitchen-utensils-cooking-tools-on-600nw-1735148546.jpg",
//     subcategories: [
//       // ---------------- Kitchen Items ----------------
//       SubCategoryModel(
//         subcategoryId: "SC004",
//         name: "Kitchen Items (Non-Electronic)",
//         products: [
//           ProductModel(
//             productId: "P005",
//             name: "Stainless Steel Cooking Pan",
//             description: "Durable stainless steel pan for frying and cooking.",
//             category: "Home & Kitchen",
//             subcategory: "Kitchen Items (Non-Electronic)",
//             baseSku: "PAN-SS-001",
//             brand: "KitchenPro",
//             price: 29.99,
//             offerPrice: 24.99,
//             rating: 4.5,
//             timestamp: Timestamp.now(),
//             images: [
//               "https://static.vecteezy.com/system/resources/thumbnails/011/912/571/small_2x/black-metal-frying-pan-chrome-plated-cast-iron-and-stainless-steel-cookware-for-frying-and-cooking-with-long-handle-vector.jpg",
//             ],
//             cashOnDelivery: true,
//             sizeVariants: [],
//           ),
//           ProductModel(
//             productId: "P006",
//             name: "Wooden Cutting Board",
//             description: "Premium quality wooden cutting board for daily use.",
//             category: "Home & Kitchen",
//             subcategory: "Kitchen Items (Non-Electronic)",
//             baseSku: "CUTBOARD-001",
//             brand: "HomeEssentials",
//             price: 19.99,
//             offerPrice: 14.99,
//             rating: 4.6,
//             timestamp: Timestamp.now(),
//             images: [
//               "https://www.shutterstock.com/image-photo/wooden-cutting-board-on-stone-600nw-2310133967.jpg",
//             ],
//             cashOnDelivery: true,
//             sizeVariants: [],
//           ),
//         ],
//       ),

//       // ---------------- Home Items ----------------
//       SubCategoryModel(
//         subcategoryId: "SC005",
//         name: "Home Items (Non-Electronic)",
//         products: [
//           ProductModel(
//             productId: "P007",
//             name: "Ceramic Plate Set",
//             description: "Set of 6 ceramic plates for everyday use.",
//             category: "Home & Kitchen",
//             subcategory: "Home Items (Non-Electronic)",
//             baseSku: "PLATESET-001",
//             brand: "HomeEssentials",
//             price: 39.99,
//             offerPrice: 34.99,
//             rating: 4.4,
//             timestamp: Timestamp.now(),
//             images: [
//               "https://m.media-amazon.com/images/I/61IB1-VlOSL._UF894,1000_QL80_.jpg",
//             ],
//             cashOnDelivery: true,
//             sizeVariants: [],
//           ),
//           ProductModel(
//             productId: "P008",
//             name: "Decorative Vase",
//             description: "Elegant glass vase to enhance your home decor.",
//             category: "Home & Kitchen",
//             subcategory: "Home Items (Non-Electronic)",
//             baseSku: "VASE-001",
//             brand: "DecoStyle",
//             price: 24.99,
//             offerPrice: 19.99,
//             rating: 4.3,
//             timestamp: Timestamp.now(),
//             images: [
//               "https://m.media-amazon.com/images/I/71FyVIny7RL._UF894,1000_QL80_.jpg",
//             ],
//             cashOnDelivery: true,
//             sizeVariants: [],
//           ),
//         ],
//       ),
//     ],
//   ),
// =======
// //   // ---------------- ACCESSORIES ----------------
// //   CategoryModel(
// //     categoryId: "C002",
// //     name: "Accessories",
// //     image:
// //         "https://img.freepik.com/free-photo/women-s-day-still-life-with-makeup-jewelry_23-2149263158.jpg",
// //     subcategories: [
// //       SubCategoryModel(
// //         subcategoryId: "SC003",
// //         name: "Jewelry",
// //         products: [
// //           ProductModel(
// //             productId: "P003",
// //             name: "Gold Chain for Men",
// //             description:
// //                 "22K pure gold chain ideal for festive and casual wear.",
// //             category: "Accessories",
// //             subcategory: "Jewelry",
// //             baseSku: "GOLDCHAIN22K",
// //             brand: "Tanishq",
// //             price: 599.99,
// //             offerPrice: 549.99,
// //             rating: 4.6,
// //             timestamp: Timestamp.now(),
// //             images: [
// //               "https://m.media-amazon.com/images/I/71hV7V0ecJL._UL1500_.jpg",
// //             ],
// //             cashOnDelivery: true,
// //             jewelleryMaterial: "Gold",
// //             purity: "22K",
// //             jewelleryWeight: "12g",
// //             jewelleryColor: "Yellow Gold",
// //             gender: "Men",
// //             certification: "BIS Hallmark",
// //             occasion: "Festive, Casual",
// //             sizeVariants: [],
// //           ),
// //           ProductModel(
// //             productId: "P004",
// //             name: "Diamond Ring for Women",
// //             description: "18K gold diamond ring with IGI certification.",
// //             category: "Accessories",
// //             subcategory: "Jewelry",
// //             baseSku: "DIARING18K",
// //             brand: "PC Jewellers",
// //             price: 899.99,
// //             offerPrice: 799.99,
// //             rating: 4.7,
// //             timestamp: Timestamp.now(),
// //             images: [
// //               "https://m.media-amazon.com/images/I/71t6kG47M-L._UL1500_.jpg",
// //             ],
// //             cashOnDelivery: false,
// //             jewelleryMaterial: "Gold + Diamond",
// //             purity: "18K",
// //             jewelleryWeight: "6g",
// //             jewelleryColor: "Rose Gold",
// //             gender: "Women",
// //             gemstone: "Diamond",
// //             certification: "IGI Certified",
// //             occasion: "Engagement, Wedding",
// //             sizeVariants: [],
// //           ),
// //         ],
// //       ),
// //     ],
// //   ),

// //   // ---------------- HOME & KITCHEN ----------------
// //   CategoryModel(
// //     categoryId: "C003",
// //     name: "Home & Kitchen",
// //     image:
// //         "https://blog.servicemarket.com/wp-content/uploads/2024/03/home-appliances-dubai-1.jpg",
// //     subcategories: [
// //       SubCategoryModel(
// //         subcategoryId: "SC004",
// //         name: "Appliances",
// //         products: [
// //           ProductModel(
// //             productId: "P005",
// //             name: "LG 1.5 Ton Inverter AC",
// //             description:
// //                 "Energy-efficient split AC with 5-star rating and dual inverter compressor.",
// //             category: "Home & Kitchen",
// //             subcategory: "Appliances",
// //             baseSku: "LGAC15",
// //             brand: "LG",
// //             price: 699.99,
// //             offerPrice: 649.99,
// //             rating: 4.4,
// //             timestamp: Timestamp.now(),
// //             images: [
// //               "https://m.media-amazon.com/images/I/71ILwY6UScL._SL1500_.jpg",
// //             ],
// //             cashOnDelivery: true,
// //             smartFeatures: "WiFi Enabled, Voice Control",
// //             energyRating: "5 Star",
// //             powerConsumption: "1450W",
// //             warranty: "1 Year Comprehensive + 5 Years Compressor",
// //             sizeVariants: [],
// //           ),
// //         ],
// //       ),
// //       SubCategoryModel(
// //         subcategoryId: "SC005",
// //         name: "Furniture",
// //         products: [
// //           ProductModel(
// //             productId: "P006",
// //             name: "Sheesham Wood King Size Bed",
// //             description: "Solid wood bed frame with storage drawers.",
// //             category: "Home & Kitchen",
// //             subcategory: "Furniture",
// //             baseSku: "WOODBEDK",
// //             brand: "Urban Ladder",
// //             price: 899.00,
// //             offerPrice: 799.00,
// //             rating: 4.3,
// //             timestamp: Timestamp.now(),
// //             images: [
// //               "https://m.media-amazon.com/images/I/81pF9xX9VhL._SL1500_.jpg",
// //             ],
// //             cashOnDelivery: false,
// //             dimension: "82 x 74 x 40 inches",
// //             weightCapacity: "300kg",
// //             assembly: "DIY Assembly Required",
// //             style: "Modern",
// //             roomType: "Bedroom",
// //             sizeVariants: [],
// //           ),
// //         ],
// //       ),
// //     ],
// //   ),
// >>>>>>> 765a30664c52cb183c2304584bf5a6dcc740c6f6

// //   // ---------------- BOOKS ----------------
// //   CategoryModel(
// //     categoryId: "C004",
// //     name: "Books",
// //     image:
// //         "https://t4.ftcdn.net/jpg/02/59/13/05/360_F_259130513_dM3XdZB7cznmJo8UW29O64DV6ivuSGCw.jpg",
// //     subcategories: [
// //       SubCategoryModel(
// //         subcategoryId: "SC006",
// //         name: "Fiction",
// //         products: [
// //           ProductModel(
// //             productId: "P007",
// //             name: "Harry Potter and the Philosopher’s Stone",
// //             description:
// //                 "First book in the legendary Harry Potter series by J.K. Rowling.",
// //             category: "Books",
// //             subcategory: "Fiction",
// //             baseSku: "HP-BOOK1",
// //             brand: "Bloomsbury",
// //             price: 19.99,
// //             offerPrice: 14.99,
// //             rating: 4.9,
// //             timestamp: Timestamp.now(),
// //             images: [
// //               "https://m.media-amazon.com/images/I/81YOuOGFCJL._SL1500_.jpg",
// //             ],
// //             cashOnDelivery: true,
// //             title: "Harry Potter and the Philosopher’s Stone",
// //             author: "J.K. Rowling",
// //             publisher: "Bloomsbury",
// //             edition: "First Edition",
// //             language: "English",
// //             isbn: "978-0747532699",
// //             pages: "352",
// //             binding: "Paperback",
// //             genre: "Fantasy",
// //             sizeVariants: [],
// //           ),
// //         ],
// //       ),
// //     ],
// //   ),
// // ];

// // // Dummy data
// // final List<ProductModel> productModel = [
// //   ProductModel(
// //     productId: 'P001',
// //     name: 'Cotton T-Shirt',
// //     description: 'Comfortable cotton t-shirt for everyday wear.',
// //     category: 'Clothing',
// //     subcategory: 'T-Shirts',
// //     baseSku: 'TSHIRT001',
// //     brand: 'ComfortWear',
// //     price: 499.0,
// //     offerPrice: 399.0,
// //     rating: 4.5,
// //     timestamp: Timestamp.now(),
// //     images: [
// //       "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?q=80&w=688&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
// //       "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
// //     ],
// //     sellerId: 'SELLER001',
// //     cashOnDelivery: true,

// //     material: 'Cotton',
// //     fit: 'Regular',
// //     pattern: 'Solid',
// //     sleeveType: 'Short Sleeve',
// //     careInstruction: 'Machine Wash',
// //     sizeOptions: ['S', 'M', 'L', 'XL'],
// //     sizeVariants: [
// //       SizeVariant(size: 'S', stock: 10),
// //       SizeVariant(size: 'M', stock: 15),
// //       SizeVariant(size: 'L', stock: 5),
// //     ],
// //   ),
// //   ProductModel(
// //     productId: 'P002',
// //     name: 'Denim Jeans',
// //     description: 'Stylish and durable denim jeans.',
// //     category: 'Clothing',
// //     subcategory: 'Jeans',
// //     baseSku: 'JEANS001',
// //     brand: 'UrbanStyle',
// //     price: 1299.0,
// //     offerPrice: 1099.0,
// //     rating: 4.2,
// //     timestamp: Timestamp.now(),
// //     images: [
// //       "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?q=80&w=688&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
// //       "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
// //     ],
// //     sellerId: 'SELLER002',
// //     cashOnDelivery: true,
// //     colorOptions: ['Blue', 'Black'],
// //     material: 'Denim',
// //     fit: 'Slim',
// //     pattern: 'Faded',
// //     sleeveType: null,
// //     careInstruction: 'Wash Inside Out',
// //     sizeOptions: ['30', '32', '34', '36'],
// //     sizeVariants: [
// //       SizeVariant(size: '30', stock: 8),
// //       SizeVariant(size: '32', stock: 12),
// //     ],
// //   ),
// //   ProductModel(
// //     productId: 'P003',
// //     name: 'Running Shoes',
// //     description: 'Lightweight running shoes for everyday fitness.',
// //     category: 'Footwear',
// //     subcategory: 'Sports Shoes',
// //     baseSku: 'SHOES001',
// //     brand: 'FitRun',
// //     price: 1999.0,
// //     offerPrice: 1799.0,
// //     rating: 4.8,
// //     timestamp: Timestamp.now(),
// //     images: [
// //       "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?q=80&w=688&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
// //       "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
// //     ],
// //     sellerId: 'SELLER003',
// //     cashOnDelivery: false,
// //     colorOptions: ['Grey', 'White'],
// //     material: 'Mesh',
// //     fit: null,
// //     pattern: 'Textured',
// //     sleeveType: null,
// //     careInstruction: 'Hand Wash',
// //     sizeOptions: ['7', '8', '9', '10'],
// //     sizeVariants: [
// //       SizeVariant(size: '8', stock: 20),
// //       SizeVariant(size: '9', stock: 18),
// //     ],
// //   ),
// //   ProductModel(
// //     productId: 'P004',
// //     name: 'Woolen Sweater',
// //     description: 'Warm and cozy woolen sweater for winter.',
// //     category: 'Clothing',
// //     subcategory: 'Sweaters',
// //     baseSku: 'SWTR001',
// //     brand: 'WinterWear',
// //     price: 1499.0,
// //     offerPrice: 1299.0,
// //     rating: 4.3,
// //     timestamp: Timestamp.now(),
// //     images: [
// //       "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?q=80&w=688&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
// //       "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
// //     ],
// //     sellerId: 'SELLER004',
// //     cashOnDelivery: true,
// //     colorOptions: ['Grey', 'Maroon'],
// //     material: 'Wool',
// //     fit: 'Slim',
// //     pattern: 'Knitted',
// //     sleeveType: 'Full Sleeve',
// //     careInstruction: 'Dry Clean Only',
// //     sizeOptions: ['M', 'L', 'XL'],
// //     sizeVariants: [
// //       SizeVariant(size: 'M', stock: 7),
// //       SizeVariant(size: 'L', stock: 10),
// //     ],
// //   ),
// //   ProductModel(
// //     productId: 'P005',
// //     name: 'Leather Wallet',
// //     description: 'Premium quality leather wallet for men.',
// //     category: 'Accessories',
// //     subcategory: 'Wallets',
// //     baseSku: 'WALLET001',
// //     brand: 'EliteLeather',
// //     price: 899.0,
// //     offerPrice: 799.0,
// //     rating: 4.6,
// //     timestamp: Timestamp.now(),
// //     images: [
// //       "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?q=80&w=688&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
// //       "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
// //     ],
// //     sellerId: 'SELLER005',
// //     cashOnDelivery: true,
// //     colorOptions: ['Brown', 'Black'],
// //     material: 'Leather',
// //     fit: null,
// //     pattern: 'Solid',
// //     sleeveType: null,
// //     careInstruction: 'Wipe with clean cloth',
// //     sizeOptions: null,
// //     sizeVariants: [],
// //   ),
// // ];
