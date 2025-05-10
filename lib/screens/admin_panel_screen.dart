import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/top_navbar.dart';
import 'package:flutter_application_1/screens/admin/manage_products_screen.dart';
import 'package:flutter_application_1/screens/admin/manage_users_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TopNavbar(
        title: "Admin Panel",
        scaffoldKey: _scaffoldKey,
        onLoginSuccess: () {},
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Quản lý hệ thống",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Các chức năng quản lý
              _buildManagementSection(
                context,
                "Quản lý người dùng",
                Icons.people,
                Colors.blue,
                [
                  AdminFeature(
                    "Danh sách người dùng",
                    Icons.list,
                    () => _navigateToUserManagement(),
                  ),
                  AdminFeature(
                    "Cấp quyền admin",
                    Icons.admin_panel_settings,
                    () => _navigateToUserManagement(),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _buildManagementSection(
                context,
                "Quản lý sản phẩm",
                Icons.shopping_bag,
                Colors.orange,
                [
                  AdminFeature(
                    "Tạo sản phẩm mới",
                    Icons.add_circle,
                    () => _navigateToProductManagement(isCreating: true),
                  ),
                  AdminFeature(
                    "Danh sách sản phẩm",
                    Icons.list,
                    () => _navigateToProductManagement(),
                  ),
                  AdminFeature(
                    "Tìm kiếm theo danh mục",
                    Icons.category,
                    () => _navigateToProductManagement(
                      isFilteringByCategory: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _buildManagementSection(
                context,
                "Quản lý đơn hàng",
                Icons.shopping_cart_checkout,
                Colors.green,
                [
                  AdminFeature("Danh sách đơn hàng", Icons.receipt_long, () {}),
                  AdminFeature("Xác nhận đơn hàng", Icons.check_circle, () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget cho từng mục quản lý
  Widget _buildManagementSection(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<AdminFeature> features,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 28, color: color),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.5,
              ),
              itemCount: features.length,
              itemBuilder: (context, index) {
                return _buildFeatureButton(
                  features[index].title,
                  features[index].icon,
                  color,
                  features[index].onTap,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget cho từng chức năng
  Widget _buildFeatureButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToUserManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ManageUsersScreen()),
    );
  }

  void _navigateToProductManagement({
    bool isCreating = false,
    bool isFilteringByCategory = false,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ManageProductsScreen(
              isCreating: isCreating,
              isFilteringByCategory: isFilteringByCategory,
            ),
      ),
    );
  }
}

// Lớp để lưu trữ thông tin về các chức năng admin
class AdminFeature {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  AdminFeature(this.title, this.icon, this.onTap);
}
