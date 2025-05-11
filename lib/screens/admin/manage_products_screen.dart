import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_application_1/components/top_navbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ManageProductsScreen extends StatefulWidget {
  final bool isCreating;
  final bool isFilteringByCategory;

  const ManageProductsScreen({
    Key? key,
    this.isCreating = false,
    this.isFilteringByCategory = false,
  }) : super(key: key);

  @override
  _ManageProductsScreenState createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  String? selectedCategory;
  final ImagePicker _imagePicker = ImagePicker();

  // Thêm các biến cho Web
  Uint8List? webImage;

  // Thay thế danh sách sản phẩm mẫu bằng danh sách động
  List<Map<String, dynamic>> _products = [];

  final List<String> _categories = [
    'Áo đấu',
    'Giày đá bóng',
    'Phụ kiện',
    'Vé xem bóng đá',
  ];

  List<Map<String, dynamic>> get filteredProducts {
    if (selectedCategory == null) {
      return _products;
    }
    return _products
        .where((product) => product['category'] == selectedCategory)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();

    // Nếu màn hình được mở với cờ isCreating, hiển thị form tạo sản phẩm ngay lập tức
    if (widget.isCreating) {
      // Chờ build xong mới hiển thị dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddEditProductDialog();
      });
    }

    // Nếu màn hình được mở với cờ isFilteringByCategory, hiển thị dialog chọn danh mục
    if (widget.isFilteringByCategory) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCategoryFilterDialog();
      });
    }
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng đăng nhập lại!')),
        );
        return;
      }

      final url = Uri.parse('http://localhost:3000/merchandise');
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _products =
              data
                  .map<Map<String, dynamic>>(
                    (item) => {
                      ...item,
                      'name': item['name'] ?? 'Không rõ tên',
                      'category': item['category'] ?? 'Không rõ danh mục',
                      'price': item['price'] ?? 0,
                      'stock': item['stock'] ?? 0,
                      'description': item['description'] ?? '',
                      'imageUrl':
                          (item['image'] is List &&
                                  item['image'] != null &&
                                  item['image'].isNotEmpty)
                              ? item['image'][0]
                              : 'assets/images/product_placeholder.jpg',
                    },
                  )
                  .toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải danh sách sản phẩm: ${response.body}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải danh sách sản phẩm: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Phương thức để chọn ảnh từ gallery
  Future<void> _pickImage(
    Function(File? file, Uint8List? webBytes, String fileName) onPicked,
  ) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      if (kIsWeb) {
        // Xử lý trên Web
        final bytes = await pickedFile.readAsBytes();
        onPicked(null, bytes, pickedFile.name);
      } else {
        // Xử lý trên Mobile
        onPicked(File(pickedFile.path), null, pickedFile.name);
      }
    }
  }

  // Phương thức để lưu hình ảnh vào thư mục ứng dụng (đối với ứng dụng thực tế)
  Future<String> _saveImageToAppDirectory(File imageFile) async {
    // Trong ứng dụng thực tế, bạn sẽ lưu ảnh vào thư mục của ứng dụng
    // và có thể upload lên server. Ở đây chỉ mô phỏng.
    final appDir = await getApplicationDocumentsDirectory();
    final fileName =
        'product_${DateTime.now().millisecondsSinceEpoch}.${path.extension(imageFile.path)}';
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');

    // Trả về đường dẫn tương đối (trong ứng dụng thực tế,
    // đây có thể là URL từ server sau khi upload)
    return savedImage.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TopNavbar(
        title: "Quản lý sản phẩm",
        scaffoldKey: _scaffoldKey,
        onLoginSuccess: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Danh sách sản phẩm",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    if (selectedCategory != null)
                      Chip(
                        label: Text(selectedCategory!),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          setState(() {
                            selectedCategory = null;
                          });
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: _showCategoryFilterDialog,
                      tooltip: 'Lọc theo danh mục',
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _fetchProducts,
                      tooltip: 'Làm mới danh sách',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                // Filter products
              },
            ),

            const SizedBox(height: 16),

            // Products list
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredProducts.isEmpty
                      ? Center(
                        child: Text(
                          'Không có sản phẩm nào${selectedCategory != null ? ' trong danh mục $selectedCategory' : ''}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                      : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return _buildProductCard(product);
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _showAddEditProductDialog,
        child: const Icon(Icons.add),
        tooltip: 'Thêm sản phẩm mới',
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: _buildProductImage(product['imageUrl'] as String?),
                ),
              ),
              // Product Info
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] ?? 'Không rõ tên',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${product['price'] ?? 0}',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product['category'] ?? 'Không rõ danh mục',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Còn ${product['stock'] ?? 0} sản phẩm',
                        style: TextStyle(
                          color:
                              (product['stock'] ?? 0) > 0
                                  ? Colors.green
                                  : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Action buttons
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                _buildActionButton(
                  Icons.edit,
                  Colors.blue,
                  () => _showAddEditProductDialog(product: product),
                ),
                const SizedBox(width: 4),
                _buildActionButton(
                  Icons.delete,
                  Colors.red,
                  () => _showDeleteProductDialog(product),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Phương thức mới để hiển thị hình ảnh sản phẩm (xử lý cả đường dẫn tương đối và đường dẫn File)
  Widget _buildProductImage(String? imageUrl) {
    final url = imageUrl ?? 'assets/images/product_placeholder.jpg';
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImageErrorWidget(),
      );
    } else if (url.startsWith('/') && !kIsWeb) {
      return Image.file(
        File(url),
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImageErrorWidget(),
      );
    } else if (url.startsWith('data:')) {
      return Image.network(
        url,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImageErrorWidget(),
      );
    } else {
      return Image.network(
        url,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImageErrorWidget(),
      );
    }
  }

  Widget _buildImageErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.9),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }

  void _showCategoryFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Lọc theo danh mục'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  _categories.map((category) {
                    return ListTile(
                      title: Text(category),
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = null;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Hiển thị tất cả'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
            ],
          ),
    );
  }

  void _showAddEditProductDialog({Map<String, dynamic>? product}) {
    final nameController = TextEditingController(text: product?['name'] ?? '');
    final priceController = TextEditingController(
      text: product != null ? product['price'].toString() : '',
    );
    final descriptionController = TextEditingController(
      text: product?['description'] ?? '',
    );
    final stockController = TextEditingController(
      text: product != null ? product['stock'].toString() : '',
    );

    String? category = product?['category'];
    File? selectedImage;
    Uint8List? selectedWebImage;
    String? imagePath = product?['imageUrl'];
    String? imageFileName;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  title: Text(
                    product == null
                        ? 'Thêm sản phẩm mới'
                        : 'Chỉnh sửa sản phẩm',
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Hiển thị ảnh đã chọn hoặc ảnh sản phẩm hiện tại
                        Container(
                          height: 120,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Builder(
                            builder: (context) {
                              if (selectedWebImage != null && kIsWeb) {
                                // Hiển thị ảnh cho web
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    selectedWebImage!,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else if (selectedImage != null && !kIsWeb) {
                                // Hiển thị ảnh cho mobile
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else if (imagePath != null &&
                                  imagePath!.isNotEmpty) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: _buildProductImage(imagePath!),
                                );
                              } else {
                                return const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                );
                              }
                            },
                          ),
                        ),

                        // Nút chọn hình ảnh
                        ElevatedButton.icon(
                          onPressed: () async {
                            await _pickImage((file, webBytes, fileName) {
                              setDialogState(() {
                                selectedImage = file;
                                selectedWebImage = webBytes;
                                imageFileName = fileName;

                                if (kIsWeb && webBytes != null) {
                                  // Tạo data URL cho web
                                  final base64 =
                                      Uri.dataFromBytes(webBytes).toString();
                                  imagePath = base64;
                                } else if (file != null) {
                                  imagePath = file.path;
                                }
                              });
                            });
                          },
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Chọn ảnh từ thư viện'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Tên sản phẩm*',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: priceController,
                          decoration: const InputDecoration(
                            labelText: 'Giá (USD)*',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Danh mục*',
                          ),
                          value: category,
                          items:
                              _categories.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              category = value;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: stockController,
                          decoration: const InputDecoration(
                            labelText: 'Số lượng*',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: descriptionController,
                          decoration: const InputDecoration(labelText: 'Mô tả'),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Hủy'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isEmpty ||
                            priceController.text.isEmpty ||
                            category == null ||
                            stockController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vui lòng điền đầy đủ thông tin'),
                            ),
                          );
                          return;
                        }

                        try {
                          final price = double.parse(priceController.text);
                          final stock = int.parse(stockController.text);
                          String finalImagePath =
                              'assets/images/product_placeholder.jpg';
                          if (imagePath != null && imagePath!.isNotEmpty) {
                            finalImagePath = imagePath!;
                          }

                          // Chuẩn hóa dữ liệu sản phẩm
                          final newProduct = {
                            "name": nameController.text,
                            "description": descriptionController.text,
                            "price": price,
                            "size": [
                              "S",
                              "M",
                              "L",
                              "XL",
                            ], // Có thể cho chọn động nếu muốn
                            "color": [
                              "Đỏ",
                              "Trắng",
                              "Đen",
                            ], // Có thể cho chọn động nếu muốn
                            "category": category,
                            "stock": stock,
                            "image": [
                              finalImagePath,
                            ], // Có thể cho chọn nhiều ảnh nếu muốn
                            "isAvailable": true,
                          };

                          await _createProductApi(newProduct);
                          Navigator.pop(context);
                        } catch (e, stackTrace) {
                          print('Lỗi khi gửi API: $e');
                          print('StackTrace: $stackTrace');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã xảy ra lỗi khi tạo sản phẩm'),
                            ),
                          );
                        }
                      },
                      child: Text(product == null ? 'Thêm' : 'Lưu'),
                    ),
                  ],
                ),
          ),
    );
  }

  void _showDeleteProductDialog(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: Text(
              'Bạn có chắc chắn muốn xóa sản phẩm ${product['name']}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  // Delete product logic
                  setState(() {
                    _products.removeWhere(
                      (item) => item['id'] == product['id'],
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã xóa sản phẩm ${product['name']}'),
                    ),
                  );
                },
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }

  Future<void> _createProductApi(Map<String, dynamic> product) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng đăng nhập lại!')));
      return;
    }

    final url = Uri.parse('http://localhost:3000/merchandise');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(product),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      // Thành công
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tạo sản phẩm thành công!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tạo sản phẩm thất bại: ${response.body}')),
      );
    }
  }
}
