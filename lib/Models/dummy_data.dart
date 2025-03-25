import 'package:flutter/material.dart';
import 'football_field.dart';
import 'promo_time.dart';
import 'field_type.dart';

class DummyData {
  // Danh sách các sân bóng nổi bật
  static List<FootballField> featuredFields = [
    FootballField(
      name: 'Sân Thống Nhất',
      location: 'Quận 10, TP.HCM',
      rating: 4.8,
      price: '300,000đ/giờ',
      image:
          "https://tphcm.cdnchinhphu.vn/334895287454388224/2024/9/19/0lwfy-17267546743321279892517.jpg",
      distance: '2.5km',
      fieldType: 'Sân 11',
    ),
    FootballField(
      name: 'Sân Phú Thọ',
      location: 'Quận 11, TP.HCM',
      rating: 4.5,
      price: '350,000đ/giờ',
      image:
          'https://file3.qdnd.vn/data/images/0/2022/04/13/vuhuyen/seagames.jpg?dpi=150&quality=100&w=870',
      distance: '3.2km',
      fieldType: 'Sân 7',
    ),
    FootballField(
      name: 'Sân Mỹ Đình',
      location: 'Nam Từ Liêm, Hà Nội',
      rating: 4.9,
      price: '400,000đ/giờ',
      image:
          'https://danviet.mediacdn.vn/296231569849192448/2022/12/27/san-my-dinh-0-16721356777861285610527.jpg',
      distance: '5.1km',
      fieldType: 'Sân 11',
    ),
  ];

  // Danh sách các sân bóng gần đây
  static List<FootballField> nearbyFields = [
    FootballField(
      name: 'Sân Bóng KTX',
      location: 'Thủ Đức, TP.HCM',
      rating: 4.3,
      price: '250,000đ/giờ',
      image:
          'https://cdn.bongdaplus.vn/Assets/Media/2023/12/13/38/san-thien-truong.jpeg',
      distance: '1.2km',
      fieldType: 'Sân 5',
    ),
    FootballField(
      name: 'Sân Bóng Hoa Lư',
      location: 'Quận 1, TP.HCM',
      rating: 4.7,
      price: '450,000đ/giờ',
      image:
          'https://rozaco.vn/wp-content/uploads/2021/06/san-bong-thanh-do-400x400.jpg',
      distance: '1.8km',
      fieldType: 'Futsal',
    ),
    FootballField(
      name: 'Sân Bóng Rạch Miễu',
      location: 'Phú Nhuận, TP.HCM',
      rating: 4.2,
      price: '280,000đ/giờ',
      image:
          'https://image.plo.vn/Uploaded/2025/xqeioxrsxr/2024_11_08/can-canh-san-viet-tri-san-sang-lam-san-nha-dt-viet-nam-tai-aff-cup-2024-6-4632.jpg',
      distance: '2.0km',
      fieldType: 'Sân 5',
    ),
  ];

  // Thời gian khuyến mãi
  static List<PromoTime> promoTimes = [
    PromoTime(
      time: 'Sáng sớm',
      hours: '05:00 - 09:00',
      discount: '20%',
      color: Colors.orange,
      icon: Icons.wb_sunny_outlined,
    ),
    PromoTime(
      time: 'Giữa trưa',
      hours: '11:00 - 14:00',
      discount: '15%',
      color: Colors.red,
      icon: Icons.wb_sunny,
    ),
    PromoTime(
      time: 'Đêm khuya',
      hours: '22:00 - 24:00',
      discount: '25%',
      color: Colors.indigo,
      icon: Icons.nightlight_round,
    ),
  ];

  // Loại sân bóng
  static List<FieldType> fieldTypes = [
    FieldType(
      type: 'Sân 5',
      icon: Icons.looks_5_outlined,
      color: Colors.green,
    ),
    FieldType(
      type: 'Sân 7',
      icon: Icons.looks_6_outlined,
      color: Colors.blue,
    ),
    FieldType(
      type: 'Sân 11',
      icon: Icons.stadium_outlined,
      color: Colors.purple,
    ),
    FieldType(
      type: 'Futsal',
      icon: Icons.sports_soccer,
      color: Colors.amber,
    ),
  ];
}
