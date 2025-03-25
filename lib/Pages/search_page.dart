import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/football_field.dart';
import '../Models/dummy_data.dart';
import '../Models/field_type.dart';
import '../Widgets/custom_bottom_navigation_bar.dart'; // Thêm import
import '../Pages/booking_page.dart';

class SearchPage extends StatefulWidget {
  final int? initialTabIndex;
  final String? initialFieldType;

  const SearchPage({super.key, this.initialTabIndex, this.initialFieldType});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;

  // Dữ liệu các sân bóng
  List<FootballField> allFields = [];
  List<FootballField> filteredFields = [];
  List<FieldType> fieldTypes = DummyData.fieldTypes;

  // Biến cho thanh điều hướng - giữ trạng thái trang tìm kiếm
  final int _selectedIndex = 1; // Đặt là 1 cho trang tìm kiếm

  // Các tham số để lọc
  RangeValues _currentPriceRange = const RangeValues(100000, 500000);
  double _maxDistance = 10.0;
  double _minRating = 3.0;
  Set<String> _selectedFieldTypes = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex:
          widget.initialTabIndex ?? 0, // Use the initial tab index if provided
    );
    _searchController = TextEditingController();

    // If an initial field type was provided, set it in the search
    if (widget.initialFieldType != null) {
      _searchController.text = "Sân ${widget.initialFieldType}";
      // You might want to trigger the search here
      // _performSearch();
    }
    // Kết hợp cả sân nổi bật và sân gần đây
    allFields = [...DummyData.featuredFields, ...DummyData.nearbyFields];
    // Loại bỏ các sân trùng lặp (nếu có) bằng cách so sánh tên
    allFields = allFields.fold<List<FootballField>>([], (list, field) {
      if (!list.any((item) => item.name == field.name)) {
        list.add(field);
      }
      return list;
    });
    filteredFields = List.from(allFields);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Phương thức xử lý điều hướng
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Không làm gì nếu đã ở trang hiện tại

    if (index == 0) {
      // Quay về trang chủ
      Navigator.pop(context);
    } else if (index == 2) {
      // Chuyển đến trang đặt lịch (hiện tại chỉ pop và hiển thị thông báo)
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang phát triển tính năng Đặt lịch')),
      );
    } else if (index == 3) {
      // Chuyển đến trang tài khoản (hiện tại chỉ pop và hiển thị thông báo)
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang phát triển tính năng Tài khoản')),
      );
    }
  }

  // Chuyển chuỗi giá thành số (bỏ "đ/giờ" và dấu phẩy)
  int _extractPrice(String priceText) {
    return int.parse(priceText.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  // Chuyển chuỗi khoảng cách thành số (bỏ "km")
  double _extractDistance(String distanceText) {
    return double.parse(distanceText.replaceAll('km', ''));
  }

  // Lọc sân bóng
  void _filterFields() {
    setState(() {
      filteredFields = allFields.where((field) {
        // Lọc theo tên hoặc địa điểm
        final nameMatches = field.name
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        final locationMatches = field.location
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        final textMatches = nameMatches || locationMatches;

        // Lọc theo giá
        final price = _extractPrice(field.price);
        final priceMatches = price >= _currentPriceRange.start &&
            price <= _currentPriceRange.end;

        // Lọc theo khoảng cách
        final distance = _extractDistance(field.distance);
        final distanceMatches = distance <= _maxDistance;

        // Lọc theo đánh giá
        final ratingMatches = field.rating >= _minRating;

        // Lọc theo loại sân (nếu có chọn loại sân)
        bool fieldTypeMatches = true;
        if (_selectedFieldTypes.isNotEmpty) {
          // Giả sử mỗi sân có một trường loại sân không nhìn thấy
          // Ở đây bạn cần thêm trường fieldType vào model FootballField
          // Nhưng hiện tại chúng ta sẽ lọc theo kiểu ngẫu nhiên dựa trên tên sân
          fieldTypeMatches = _isFieldTypeMatch(field);
        }

        return textMatches &&
            priceMatches &&
            distanceMatches &&
            ratingMatches &&
            fieldTypeMatches;
      }).toList();
    });
  }

  // Hàm kiểm tra loại sân phù hợp (ví dụ: hiện tại chỉ để demo)
  bool _isFieldTypeMatch(FootballField field) {
    if (_selectedFieldTypes.isEmpty) return true;
    return _selectedFieldTypes.contains(field.fieldType);
  }

  // Hiển thị dialog để lọc
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Lọc tìm kiếm',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _currentPriceRange =
                                const RangeValues(100000, 500000);
                            _maxDistance = 10.0;
                            _minRating = 3.0;
                            _selectedFieldTypes = {};
                          });
                        },
                        child: const Text('Đặt lại'),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      children: [
                        // Lọc theo giá
                        const Text(
                          'Khoảng giá',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RangeSlider(
                          values: _currentPriceRange,
                          min: 100000,
                          max: 500000,
                          divisions: 8,
                          labels: RangeLabels(
                            '${(_currentPriceRange.start / 1000).round()}k',
                            '${(_currentPriceRange.end / 1000).round()}k',
                          ),
                          onChanged: (values) {
                            setModalState(() {
                              _currentPriceRange = values;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '${(_currentPriceRange.start / 1000).round()}k đ'),
                            Text(
                                '${(_currentPriceRange.end / 1000).round()}k đ'),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Lọc theo khoảng cách
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Khoảng cách tối đa',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('${_maxDistance.round()} km'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: _maxDistance,
                          min: 1,
                          max: 20,
                          divisions: 19,
                          label: '${_maxDistance.round()} km',
                          onChanged: (value) {
                            setModalState(() {
                              _maxDistance = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Lọc theo đánh giá
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Đánh giá tối thiểu',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 20),
                                Text(' $_minRating'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: _minRating,
                          min: 1,
                          max: 5,
                          divisions: 8,
                          label: '$_minRating',
                          onChanged: (value) {
                            setModalState(() {
                              _minRating = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Lọc theo loại sân
                        const Text(
                          'Loại sân',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: fieldTypes.map((type) {
                            final isSelected =
                                _selectedFieldTypes.contains(type.type);
                            return FilterChip(
                              label: Text(type.type),
                              selected: isSelected,
                              showCheckmark: false,
                              avatar: Icon(
                                type.icon,
                                color: isSelected ? Colors.white : type.color,
                                size: 16,
                              ),
                              selectedColor: type.color,
                              backgroundColor: type.color.withOpacity(0.1),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : type.color,
                                fontWeight: FontWeight.bold,
                              ),
                              onSelected: (selected) {
                                setModalState(() {
                                  if (selected) {
                                    _selectedFieldTypes.add(type.type);
                                  } else {
                                    _selectedFieldTypes.remove(type.type);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _filterFields();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Áp dụng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Phương thức hiển thị modal đặt sân
  void _showBookingDialog(FootballField field) {
    // Biến theo dõi ngày và giờ được chọn
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    String selectedTimeSlot = '18:00 - 20:00';
    int duration = 2; // giờ
    double totalPrice = _extractPrice(field.price).toDouble() * duration;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              // Thêm padding để tránh bàn phím ảo
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                // Sử dụng % chiều cao màn hình thay vì giá trị cố định
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Đặt sân bóng',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const Divider(),

                    // Sử dụng Expanded và SingleChildScrollView để làm cho nội dung có thể cuộn
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thông tin sân
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      field.image,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          field.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: 14,
                                              color: Colors.grey[700],
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                field.location,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700],
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${field.fieldType} • ${field.distance}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Chọn ngày
                            const SizedBox(height: 24),
                            const Text(
                              'Chọn ngày',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 90,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 14, // Hiển thị 14 ngày
                                itemBuilder: (context, index) {
                                  final date =
                                      DateTime.now().add(Duration(days: index));
                                  final isSelected =
                                      _isSameDay(date, selectedDate);

                                  return GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        selectedDate = date;
                                      });
                                    },
                                    child: Container(
                                      width: 65,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.green
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.green
                                              : Colors.grey.shade300,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _getDayName(date),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            date.day.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${date.month}/${date.year.toString().substring(2)}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Chọn khung giờ
                            const SizedBox(height: 24),
                            const Text(
                              'Chọn khung giờ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _buildTimeSlotChip(
                                    '06:00 - 08:00', selectedTimeSlot, (slot) {
                                  setModalState(() {
                                    selectedTimeSlot = slot;
                                    totalPrice =
                                        _extractPrice(field.price).toDouble() *
                                            duration;
                                  });
                                }),
                                _buildTimeSlotChip(
                                    '08:00 - 10:00', selectedTimeSlot, (slot) {
                                  setModalState(() {
                                    selectedTimeSlot = slot;
                                    totalPrice =
                                        _extractPrice(field.price).toDouble() *
                                            duration;
                                  });
                                }),
                                _buildTimeSlotChip(
                                    '10:00 - 12:00', selectedTimeSlot, (slot) {
                                  setModalState(() {
                                    selectedTimeSlot = slot;
                                    totalPrice =
                                        _extractPrice(field.price).toDouble() *
                                            duration;
                                  });
                                }),
                                _buildTimeSlotChip(
                                    '14:00 - 16:00', selectedTimeSlot, (slot) {
                                  setModalState(() {
                                    selectedTimeSlot = slot;
                                    totalPrice =
                                        _extractPrice(field.price).toDouble() *
                                            duration;
                                  });
                                }),
                                _buildTimeSlotChip(
                                    '16:00 - 18:00', selectedTimeSlot, (slot) {
                                  setModalState(() {
                                    selectedTimeSlot = slot;
                                    totalPrice =
                                        _extractPrice(field.price).toDouble() *
                                            duration;
                                  });
                                }),
                                _buildTimeSlotChip(
                                    '18:00 - 20:00', selectedTimeSlot, (slot) {
                                  setModalState(() {
                                    selectedTimeSlot = slot;
                                    totalPrice =
                                        _extractPrice(field.price).toDouble() *
                                            duration *
                                            1.2; // Tăng giá 20% giờ cao điểm
                                  });
                                }),
                                _buildTimeSlotChip(
                                    '20:00 - 22:00', selectedTimeSlot, (slot) {
                                  setModalState(() {
                                    selectedTimeSlot = slot;
                                    totalPrice =
                                        _extractPrice(field.price).toDouble() *
                                            duration *
                                            1.2; // Tăng giá 20% giờ cao điểm
                                  });
                                }),
                              ],
                            ),

                            // Chọn thời lượng
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Thời lượng',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: duration > 1
                                          ? () {
                                              setModalState(() {
                                                duration--;
                                                totalPrice =
                                                    _extractPrice(field.price)
                                                            .toDouble() *
                                                        duration;
                                                if (selectedTimeSlot ==
                                                        '18:00 - 20:00' ||
                                                    selectedTimeSlot ==
                                                        '20:00 - 22:00') {
                                                  totalPrice *=
                                                      1.2; // Tăng giá 20% giờ cao điểm
                                                }
                                              });
                                            }
                                          : null,
                                      icon: const Icon(
                                          Icons.remove_circle_outline),
                                      color: duration > 1
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    Text(
                                      '$duration giờ',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: duration < 3
                                          ? () {
                                              setModalState(() {
                                                duration++;
                                                totalPrice =
                                                    _extractPrice(field.price)
                                                            .toDouble() *
                                                        duration;
                                                if (selectedTimeSlot ==
                                                        '18:00 - 20:00' ||
                                                    selectedTimeSlot ==
                                                        '20:00 - 22:00') {
                                                  totalPrice *=
                                                      1.2; // Tăng giá 20% giờ cao điểm
                                                }
                                              });
                                            }
                                          : null,
                                      icon:
                                          const Icon(Icons.add_circle_outline),
                                      color: duration < 3
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Thông tin giá
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Giá thuê sân',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        field.price,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Thời gian thuê',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        '$duration giờ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Tổng tiền',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${NumberFormat('#,###').format(totalPrice.toInt())}đ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),

                    // Nút đặt sân - nút được đặt ngoài SingleChildScrollView
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _confirmBooking(context, field, selectedDate,
                              selectedTimeSlot, duration, totalPrice);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Xác nhận đặt sân',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Tạo widget chip thời gian
  Widget _buildTimeSlotChip(
      String timeSlot, String selectedTimeSlot, Function(String) onSelected) {
    final isSelected = timeSlot == selectedTimeSlot;
    return ChoiceChip(
      label: Text(timeSlot),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          onSelected(timeSlot);
        }
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.green,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.grey.shade300,
        ),
      ),
    );
  }

  // Kiểm tra 2 ngày có phải cùng ngày
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Lấy tên ngày trong tuần
  String _getDayName(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'T2';
      case 2:
        return 'T3';
      case 3:
        return 'T4';
      case 4:
        return 'T5';
      case 5:
        return 'T6';
      case 6:
        return 'T7';
      case 7:
        return 'CN';
      default:
        return '';
    }
  }

  // Xác nhận đặt sân
  void _confirmBooking(
      BuildContext context,
      FootballField field,
      DateTime selectedDate,
      String selectedTimeSlot,
      int duration,
      double totalPrice) {
    // Đóng hộp thoại đặt sân
    Navigator.pop(context);

    // Hiển thị hộp thoại xác nhận
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận đặt sân'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Sân: ${field.name}'),
              const SizedBox(height: 8),
              Text('Ngày: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
              const SizedBox(height: 8),
              Text('Giờ: $selectedTimeSlot'),
              const SizedBox(height: 8),
              Text('Thời lượng: $duration giờ'),
              const SizedBox(height: 8),
              Text(
                  'Tổng tiền: ${NumberFormat('#,###').format(totalPrice.toInt())}đ'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processBooking(
                  field, selectedDate, selectedTimeSlot, duration, totalPrice);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  // Xử lý đặt sân
  void _processBooking(FootballField field, DateTime selectedDate,
      String selectedTimeSlot, int duration, double totalPrice) {
    // Tạo mã đặt sân ngẫu nhiên
    final bookingId =
        'B${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    // Hiển thị thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đặt sân thành công! Mã đặt sân: $bookingId'),
        action: SnackBarAction(
          label: 'Xem lịch đặt',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookingPage()),
            );
          },
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Tìm kiếm sân bóng',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Tìm kiếm theo tên hoặc địa điểm...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onChanged: (value) {
                        _filterFields();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: _showFilterDialog,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Hiển thị các chip đã chọn
          if (_selectedFieldTypes.isNotEmpty ||
              _minRating > 3 ||
              _maxDistance < 10)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (_minRating > 3)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 16),
                              Text(' $_minRating+'),
                            ],
                          ),
                          onDeleted: () {
                            setState(() {
                              _minRating = 3;
                              _filterFields();
                            });
                          },
                          backgroundColor: Colors.white,
                        ),
                      ),
                    if (_maxDistance < 10)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text('≤ ${_maxDistance.round()} km'),
                          onDeleted: () {
                            setState(() {
                              _maxDistance = 10;
                              _filterFields();
                            });
                          },
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ..._selectedFieldTypes.map(
                      (type) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(type),
                          onDeleted: () {
                            setState(() {
                              _selectedFieldTypes.remove(type);
                              _filterFields();
                            });
                          },
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Kết quả tìm kiếm
          Expanded(
            child: filteredFields.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/no_results.png',
                          width: 120,
                          height: 120,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Không tìm thấy sân bóng phù hợp',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredFields.length,
                    itemBuilder: (context, index) {
                      final field = filteredFields[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Field image
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              child: Image.network(
                                field.image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Field info
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      field.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 14,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            '${field.location} (${field.distance})',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${field.rating}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          field.price,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Mở dialog đặt sân khi nhấn nút
                                            _showBookingDialog(field);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Đặt sân'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Add the CustomBottomNavWithFAB
      bottomNavigationBar: CustomBottomNavWithFAB(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        parentContext: context,
        onFabPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Chức năng đặt sân nhanh đang phát triển')),
          );
        },
      ),
    );
  }
}
