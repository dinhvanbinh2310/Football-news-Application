import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/top_navbar.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({Key? key}) : super(key: key);

  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  // Dữ liệu mẫu cho danh sách người dùng
  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'Nguyễn Văn A',
      'email': 'nguyenvana@gmail.com',
      'role': 'user',
      'phone': '0901234567',
      'created_at': '12/01/2023',
    },
    {
      'id': '2',
      'name': 'Trần Thị B',
      'email': 'tranthib@gmail.com',
      'role': 'admin',
      'phone': '0907654321',
      'created_at': '10/11/2023',
    },
    {
      'id': '3',
      'name': 'Lê Văn C',
      'email': 'levanc@gmail.com',
      'role': 'user',
      'phone': '0905551234',
      'created_at': '05/02/2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TopNavbar(
        title: "Quản lý người dùng",
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
                  "Danh sách người dùng",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    // Reload users list
                    setState(() {
                      isLoading = true;
                    });

                    // Simulate API call
                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm người dùng...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                // Filter users
              },
            ),

            const SizedBox(height: 16),

            // Users list
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          final user = _users[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                backgroundColor:
                                    user['role'] == 'admin'
                                        ? Colors.blue.shade100
                                        : Colors.grey.shade200,
                                child: Icon(
                                  Icons.person,
                                  color:
                                      user['role'] == 'admin'
                                          ? Colors.blue
                                          : Colors.grey.shade700,
                                ),
                              ),
                              title: Text(
                                user['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(user['email']),
                                  Text(
                                    user['role'] == 'admin'
                                        ? 'Quản trị viên'
                                        : 'Người dùng',
                                    style: TextStyle(
                                      color:
                                          user['role'] == 'admin'
                                              ? Colors.blue
                                              : Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showEditUserDialog(user);
                                  } else if (value == 'delete') {
                                    _showDeleteUserDialog(user);
                                  } else if (value == 'changeRole') {
                                    _changeUserRole(user);
                                  }
                                },
                                itemBuilder:
                                    (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit),
                                            SizedBox(width: 8),
                                            Text('Chỉnh sửa'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'changeRole',
                                        child: Row(
                                          children: [
                                            Icon(Icons.admin_panel_settings),
                                            SizedBox(width: 8),
                                            Text(
                                              user['role'] == 'admin'
                                                  ? 'Hủy quyền admin'
                                                  : 'Cấp quyền admin',
                                            ),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Xóa',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _showAddUserDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddUserDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Thêm người dùng mới'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Họ tên'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Số điện thoại',
                    ),
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
                onPressed: () {
                  // Add user logic
                  Navigator.pop(context);
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }

  void _showEditUserDialog(Map<String, dynamic> user) {
    final nameController = TextEditingController(text: user['name']);
    final emailController = TextEditingController(text: user['email']);
    final phoneController = TextEditingController(text: user['phone']);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Chỉnh sửa thông tin người dùng'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Họ tên'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Số điện thoại',
                    ),
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
                onPressed: () {
                  // Update user logic
                  Navigator.pop(context);
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
    );
  }

  void _showDeleteUserDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: Text(
              'Bạn có chắc chắn muốn xóa người dùng ${user['name']}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  // Delete user logic
                  setState(() {
                    _users.removeWhere((item) => item['id'] == user['id']);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã xóa người dùng ${user['name']}'),
                    ),
                  );
                },
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }

  void _changeUserRole(Map<String, dynamic> user) {
    setState(() {
      if (user['role'] == 'admin') {
        user['role'] = 'user';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã hủy quyền admin của ${user['name']}')),
        );
      } else {
        user['role'] = 'admin';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã cấp quyền admin cho ${user['name']}')),
        );
      }
    });
  }
}
