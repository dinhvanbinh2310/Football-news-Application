import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/top_navbar.dart';
import 'package:flutter_application_1/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool isLoggedIn = false;
  String? _token;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _paymentMethod = 'Thanh toán khi nhận hàng';

  // Thông tin tài khoản ngân hàng
  final Map<String, String> _bankInfo = {
    'bankName': 'Ngân hàng Techcombank',
    'accountName': 'CÔNG TY FOOTBALL ARENA',
    'accountNumber': '19033366688888',
    'branch': 'Chi nhánh Hà Nội',
    'content': 'Thanh toan don hang',
  };

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      isLoggedIn = token != null;
      _token = token;
    });

    // Nếu chưa đăng nhập, hiển thị thông báo và điều hướng đến trang đăng nhập
    if (!isLoggedIn) {
      // Thực hiện sau khi build hoàn tất để tránh lỗi setState
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bạn cần đăng nhập để thanh toán'),
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ).then((_) {
          // Kiểm tra lại trạng thái đăng nhập sau khi quay lại từ trang đăng nhập
          _checkLoginStatus();
          if (!isLoggedIn) {
            // Nếu vẫn chưa đăng nhập, quay lại màn hình trước đó
            Navigator.of(context).pop();
          }
        });
      });
    }
  }

  void _onLoginSuccess() {
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Widget hiển thị QR code và thông tin tài khoản
  Widget _buildBankTransferInfo(double totalPrice) {
    return _paymentMethod == 'Chuyển khoản ngân hàng'
        ? Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin chuyển khoản',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // QR Code (giả lập - trong ứng dụng thực tế bạn sẽ sử dụng thư viện tạo QR)
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.network(
                      'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${Uri.encodeComponent("${_bankInfo['bankName']} - ${_bankInfo['accountNumber']} - ${_bankInfo['accountName']} - ${totalPrice} USD")}',
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => const Icon(
                            Icons.qr_code,
                            size: 80,
                            color: Colors.grey,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Thông tin chuyển khoản
                _buildBankInfoRow('Ngân hàng:', _bankInfo['bankName']!),
                _buildBankInfoRow('Tên tài khoản:', _bankInfo['accountName']!),
                _buildBankInfoRow('Số tài khoản:', _bankInfo['accountNumber']!),
                _buildBankInfoRow('Chi nhánh:', _bankInfo['branch']!),
                _buildBankInfoRow(
                  'Số tiền:',
                  '\$${totalPrice.toStringAsFixed(2)}',
                ),
                _buildBankInfoRow('Nội dung CK:', '${_bankInfo['content']}'),

                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),

                // Lưu ý
                const Text(
                  'Lưu ý: Vui lòng chuyển khoản đúng số tiền và nội dung để đơn hàng được xử lý nhanh chóng. Đơn hàng sẽ được xác nhận sau khi chúng tôi nhận được thanh toán.',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        )
        : const SizedBox.shrink();
  }

  // Helper widget để hiển thị từng dòng thông tin tài khoản
  Widget _buildBankInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    final totalPrice = cartProvider.totalPrice;

    return Scaffold(
      key: _scaffoldKey,
      appBar: TopNavbar(
        title: "Thanh toán",
        scaffoldKey: _scaffoldKey,
        onLoginSuccess: _onLoginSuccess,
      ),
      body:
          !isLoggedIn
              ? const Center(
                child: Text(
                  'Vui lòng đăng nhập để tiếp tục thanh toán',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : (cartItems.isEmpty
                  ? const Center(
                    child: Text(
                      'Giỏ hàng trống, không thể thanh toán',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                  : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Order Summary
                          Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Thông tin đơn hàng',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 150,
                                    child: ListView.builder(
                                      itemCount: cartItems.length,
                                      itemBuilder: (context, index) {
                                        final item = cartItems[index];
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(item['name']),
                                          subtitle: Text('\$${item['price']}'),
                                          leading: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  item['image'],
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Tổng cộng:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '\$${totalPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Customer Information
                          Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Thông tin giao hàng',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Họ tên',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập họ tên';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _addressController,
                                    decoration: const InputDecoration(
                                      labelText: 'Địa chỉ',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập địa chỉ';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _phoneController,
                                    decoration: const InputDecoration(
                                      labelText: 'Số điện thoại',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập số điện thoại';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập email';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Payment Method
                          Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Phương thức thanh toán',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  RadioListTile<String>(
                                    title: const Text(
                                      'Thanh toán khi nhận hàng',
                                    ),
                                    value: 'Thanh toán khi nhận hàng',
                                    groupValue: _paymentMethod,
                                    onChanged: (value) {
                                      setState(() {
                                        _paymentMethod = value!;
                                      });
                                    },
                                  ),
                                  RadioListTile<String>(
                                    title: const Text('Chuyển khoản ngân hàng'),
                                    value: 'Chuyển khoản ngân hàng',
                                    groupValue: _paymentMethod,
                                    onChanged: (value) {
                                      setState(() {
                                        _paymentMethod = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Bank Transfer Information (hiển thị khi chọn chuyển khoản)
                          _buildBankTransferInfo(totalPrice),

                          // Complete Order Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Process the order
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        _paymentMethod ==
                                                'Thanh toán khi nhận hàng'
                                            ? 'Đặt hàng thành công!'
                                            : 'Đặt hàng thành công! Vui lòng hoàn tất thanh toán để xử lý đơn hàng.',
                                      ),
                                    ),
                                  );

                                  // Clear cart
                                  cartProvider.clearCart();

                                  // Go back to home
                                  Navigator.popUntil(
                                    context,
                                    ModalRoute.withName('/'),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Hoàn tất đặt hàng',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
    );
  }
}
