import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/models/new_model.dart';
import 'package:flutter_application_1/services/new_service.dart';

class ManageNewsScreen extends StatefulWidget {
  final bool isCreating;
  final bool isFilteringByCategory;

  const ManageNewsScreen({
    Key? key,
    this.isCreating = false,
    this.isFilteringByCategory = false,
  }) : super(key: key);


  @override
  State<ManageNewsScreen> createState() => _ManageNewsScreenState();
}

class _ManageNewsScreenState extends State<ManageNewsScreen> {
  final NewsService _newsService = NewsService();
  List<News> _newsList = [];
  bool _isLoading = true;
  String _selectedCategory = "All"; // for filter

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();


  @override
  void initState() {
    super.initState();
    if (!widget.isCreating) _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      final allNews = await _newsService.fetchNews();
      setState(() {
        _newsList = allNews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error loading news: $e");
    }
  }

  Future<void> _createNews() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập tiêu đề và nội dung")),
      );
      return;
    }

    // Tạm thời dùng ảnh URL mặc định nếu chưa upload ảnh lên server
    final imageUrl = _selectedImage != null ? "http://example.com/image.jpg" : null;

    try {
      final newNews = News(
        title: _titleController.text,
        content: _contentController.text,
        description: _descriptionController.text,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
      );

      await _newsService.createNews(newNews);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Thêm bài viết thành công")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print("Error creating news: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    if (widget.isCreating) return _buildCreateForm();
    if (widget.isFilteringByCategory) return _buildFilteredNews();
    return _buildNewsList();
  }

  // ----------- UI Hiển thị danh sách tin ----------
  Widget _buildNewsList() {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Danh sách tin")),
      body: ListView.builder(
        itemCount: _newsList.length,
        itemBuilder: (context, index) {
          final news = _newsList[index];
          return ListTile(
            title: Text(news.title),
            subtitle: Text(news.description ?? ''),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(news.id!),
            ),
          );
        },
      ),
    );
  }

  // ----------- UI Form tạo tin mới ----------
  Widget _buildCreateForm() {
    return Scaffold(
      appBar: AppBar(title: const Text("Tạo bài viết mới")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Tiêu đề"),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: "Nội dung"),
              maxLines: 5,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Mô tả ngắn"),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Ảnh minh hoạ (chọn từ thư viện):"),
                const SizedBox(height: 8),
                _selectedImage != null
                    ? Image.file(_selectedImage!, height: 150)
                    : const Text("Chưa chọn ảnh"),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Chọn ảnh"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createNews,
              child: const Text("Đăng bài"),
            ),
          ],
        ),
      ),
    );
  }


  // ----------- UI Lọc tin theo danh mục ----------
  Widget _buildFilteredNews() {
    final filtered = _selectedCategory == "All"
        ? _newsList
        : _newsList.where((n) => n.description == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lọc theo danh mục"),
        actions: [
          DropdownButton<String>(
            value: _selectedCategory,
            items: const [
              DropdownMenuItem(value: "All", child: Text("Tất cả")),
              DropdownMenuItem(value: "Thể thao", child: Text("Thể thao")),
              DropdownMenuItem(value: "Giải trí", child: Text("Giải trí")),
              DropdownMenuItem(value: "Chính trị", child: Text("Chính trị")),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedCategory = value);
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final news = filtered[index];
          return ListTile(
            title: Text(news.title),
            subtitle: Text(news.description ?? ''),
          );
        },
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _confirmDelete(String id) async {
    final confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xóa tin?"),
        content: const Text("Bạn có chắc muốn xóa không?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Hủy")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Xóa")),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _newsService.deleteNews(id);
        _loadNews();
      } catch (e) {
        print("Delete error: $e");
      }
    }
  }
}
