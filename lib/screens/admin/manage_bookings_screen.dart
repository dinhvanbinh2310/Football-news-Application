import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/screens/admin/booking_details_screen.dart';

class ManageBookingsScreen extends StatefulWidget {
  const ManageBookingsScreen({Key? key}) : super(key: key);

  @override
  _ManageBookingsScreenState createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> {
  List<dynamic> bookings = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchBookings() async {
    try {
      final token = await _getToken();

      if (token == null) {
        setState(() {
          error = 'Không tìm thấy token đăng nhập';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('http://localhost:3000/bookings'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          bookings = json.decode(response.body);
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          error = 'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.';
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load bookings: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error connecting to server: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản lý đơn hàng',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(
                  child: Text(error, style: const TextStyle(color: Colors.red)),
                )
              : RefreshIndicator(
                  onRefresh: fetchBookings,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Đơn hàng #${booking['_id']}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(booking['status']),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      booking['status'] ?? 'Pending',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow('Tổng tiền:',
                                  '${booking['totalPrice'] ?? 0} VNĐ'),
                              _buildInfoRow('Trạng thái:',
                                  booking['status'] ?? 'Pending'),
                              _buildInfoRow('Địa chỉ giao hàng:',
                                  booking['shippingAddress'] ?? 'N/A'),
                              _buildInfoRow('Số điện thoại:',
                                  booking['phoneNumber'] ?? 'N/A'),
                              if (booking['note'] != null &&
                                  booking['note'].toString().isNotEmpty)
                                _buildInfoRow('Ghi chú:', booking['note']),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BookingDetailsScreen(
                                            booking: booking,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Xem chi tiết'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BookingDetailsScreen(
                                            booking: booking,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text('Cập nhật trạng thái'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
