import 'dart:math'; // Thư viện Dart cho các hàm toán học và tạo số ngẫu nhiên
import 'package:flutter/material.dart'; // Thư viện Flutter để xây dựng giao diện người dùng theo Material Design
import 'package:firebase_core/firebase_core.dart'; // Thư viện để khởi tạo Firebase
import 'firebase_options.dart'; // Cấu hình Firebase được tạo tự động bởi Firebase CLI

// Hàm chính khởi chạy ứng dụng
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Khởi tạo Flutter binding
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Khởi tạo Firebase với cấu hình
  );
  runApp(MyApp()); // Chạy ứng dụng với MyApp làm widget gốc
}

// Lớp đại diện cho một mục với ID và tên
class SampleItem {
  String id; // ID của mục
  ValueNotifier<String> name; // Tên mục có thể thông báo khi thay đổi

  // Constructor của lớp SampleItem
  SampleItem({String? id, required String name})
      : id = id ?? generateUuid(), // Tạo ID nếu không có
        name = ValueNotifier(name); // Gán tên cho mục

  // Phương thức tạo ID duy nhất
  static String generateUuid() {
    return int.parse(
            '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(100000)}') // Kết hợp thời gian và số ngẫu nhiên
        .toRadixString(35) // Chuyển thành chuỗi với cơ số 35
        .substring(0, 9); // Lấy 9 ký tự đầu tiên
  }
}

// Lớp quản lý danh sách các mục và thông báo thay đổi
class SampleItemViewModel extends ChangeNotifier {
  SampleItemViewModel._(); // Constructor riêng tư
  factory SampleItemViewModel() => _instance; // Factory để lấy instance duy nhất
  static final _instance = SampleItemViewModel._(); // Instance duy nhất

  final List<SampleItem> items = []; // Danh sách các mục

  // Thêm mục mới
  void addItem(String name) {
    items.add(SampleItem(name: name)); // Thêm mục vào danh sách
    notifyListeners(); // Thông báo thay đổi
  }

  // Xóa mục theo ID
  void removeItem(String id) {
    items.removeWhere((item) => item.id == id); // Xóa mục khỏi danh sách
    notifyListeners(); // Thông báo thay đổi
  }

  // Cập nhật tên mục
  void updateItem(String id, String newName) {
    try {
      final item = items.firstWhere((item) => item.id == id); // Tìm mục theo ID
      item.name.value = newName; // Cập nhật tên
    } catch (e) {
      debugPrint("Không tìm thấy mục với ID $id"); // Xử lý lỗi nếu không tìm thấy
    }
  }

  // Tìm kiếm mục theo tên
  List<SampleItem> searchItems(String keyword) {
    return items
        .where((item) =>
            item.name.value.toLowerCase().contains(keyword.toLowerCase())) // Lọc mục theo từ khóa
        .toList();
  }
}

// Widget cho việc thêm và chỉnh sửa mục
class SampleItemUpdate extends StatefulWidget {
  final String? initialName; // Tên ban đầu của mục

  const SampleItemUpdate({Key? key, this.initialName}) : super(key: key);

  @override
  State<SampleItemUpdate> createState() => _SampleItemUpdateState();
}

class _SampleItemUpdateState extends State<SampleItemUpdate> {
  late TextEditingController textEditingController; // Controller cho TextFormField

  @override
  void initState() {
    super.initState();
    textEditingController =
        TextEditingController(text: widget.initialName ?? ''); // Khởi tạo với tên ban đầu
  }

  @override
  void dispose() {
    textEditingController.dispose(); // Giải phóng tài nguyên khi không sử dụng nữa
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialName != null ? 'Chỉnh sửa' : 'Thêm mới'), // Tiêu đề dựa trên trạng thái
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(textEditingController.text); // Đóng và trả về giá trị mới
            },
            child: Text(widget.initialName != null ? 'Chỉnh sửa' : 'Thêm mới'), // Nút hành động
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: textEditingController, // Kết nối TextFormField với controller
              decoration: InputDecoration(
                labelText: 'Tên mục',
                border: OutlineInputBorder(), // Giao diện cho TextFormField
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(textEditingController.text); // Đóng và trả về giá trị mới
              },
              child: Text(widget.initialName != null ? 'Cập nhật' : 'Thêm mới'), // Nút hành động
            ),
          ],
        ),
      ),
    );
  }
}

// Widget hiển thị chi tiết một mục
class SampleItemWidget extends StatelessWidget {
  final SampleItem item; // Mục được hiển thị
  final VoidCallback? onTap; // Hàm gọi khi người dùng nhấn vào

  const SampleItemWidget({Key? key, required this.item, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: item.name, // Theo dõi thay đổi tên
      builder: (context, name, child) {
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            title: Text(name), // Hiển thị tên mục
            subtitle: Text(item.id), // Hiển thị ID của mục
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/flutter_logo.png'), // Avatar với logo Flutter
            ),
            onTap: onTap, // Gọi hàm khi nhấn vào mục
            trailing: const Icon(Icons.keyboard_arrow_right), // Biểu tượng mũi tên
          ),
        );
      },
    );
  }
}

// Widget hiển thị chi tiết một mục và cho phép chỉnh sửa hoặc xóa
class SampleItemDetailsView extends StatefulWidget {
  final SampleItem item; // Mục cần hiển thị chi tiết

  const SampleItemDetailsView({Key? key, required this.item}) : super(key: key);

  @override
  State<SampleItemDetailsView> createState() => _SampleItemDetailsViewState();
}

class _SampleItemDetailsViewState extends State<SampleItemDetailsView> {
  final viewModel = SampleItemViewModel(); // ViewModel quản lý trạng thái

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết mục'), // Tiêu đề
        actions: [
          TextButton(
            onPressed: () {
              showModalBottomSheet<String?>(
                context: context,
                builder: (context) => SampleItemUpdate(
                  initialName: widget.item.name.value, // Cập nhật tên mục
                ),
              ).then((value) {
                if (value != null) {
                  viewModel.updateItem(widget.item.id, value); // Cập nhật mục trong ViewModel
                }
              });
            },
            child: const Text('Cập nhật'),
          ),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Xác nhận xóa"), // Xác nhận xóa mục
                    content: const Text("Bạn có chắc muốn xóa mục này?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(), // Hủy xóa
                        child: const Text("Hủy"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          viewModel.removeItem(widget.item.id); // Xóa mục khỏi ViewModel
                          Navigator.of(context).pop(); // Quay lại màn hình trước
                        },
                        child: const Text("Xóa"),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tên: ${widget.item.name.value}', // Hiển thị tên mục
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'ID: ${widget.item.id}', // Hiển thị ID mục
                            style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget hiển thị danh sách các mục
class SampleItemListView extends StatefulWidget {
  const SampleItemListView({Key? key}) : super(key: key);

  @override
  State<SampleItemListView> createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  final viewModel = SampleItemViewModel(); // ViewModel quản lý danh sách mục
  late TextEditingController searchController; // Controller cho ô tìm kiếm

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(); // Khởi tạo controller cho ô tìm kiếm
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Mục'), // Tiêu đề của AppBar
        actions: [
          TextButton(
            onPressed: () {
              // Hiển thị màn hình thêm mới hoặc chỉnh sửa mục
              showModalBottomSheet<String?>(
                context: context,
                builder: (context) => const SampleItemUpdate(), // Widget thêm mới mục
              ).then((value) {
                if (value != null) {
                  viewModel.addItem(value); // Thêm mục mới vào danh sách
                }
              });
            },
            child: const Text('Thêm mới'), // Nút thêm mới mục
          ),
          TextButton(
            onPressed: () {
              // Mở giao diện tìm kiếm
              showSearch(
                context: context,
                delegate: SampleItemSearchDelegate(viewModel), // Delegate cho tìm kiếm
              );
            },
            child: const Text('Tìm kiếm'), // Nút tìm kiếm
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel, // Theo dõi thay đổi từ ViewModel
        builder: (context, _) {
          return ListView.builder(
            itemCount: viewModel.items.length, // Số lượng mục trong danh sách
            itemBuilder: (context, index) {
              final item = viewModel.items[index]; // Lấy mục tại vị trí index
              return SampleItemWidget(
                item: item, // Widget hiển thị chi tiết mục
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SampleItemDetailsView(item: item), // Mở màn hình chi tiết mục
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// Delegate cho tìm kiếm mục
class SampleItemSearchDelegate extends SearchDelegate<String> {
  final SampleItemViewModel viewModel; // ViewModel chứa các mục

  SampleItemSearchDelegate(this.viewModel);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear), // Biểu tượng xóa tìm kiếm
        onPressed: () {
          query = ''; // Xóa nội dung tìm kiếm
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back), // Biểu tượng quay lại
      onPressed: () {
        close(context, ''); // Đóng giao diện tìm kiếm
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchResults = viewModel.searchItems(query); // Kết quả tìm kiếm dựa trên query
    return ListView.builder(
      itemCount: searchResults.length, // Số lượng kết quả tìm kiếm
      itemBuilder: (context, index) {
        final item = searchResults[index]; // Lấy mục tại vị trí index
        return ListTile(
          title: Text(item.name.value), // Hiển thị tên của mục
          subtitle: Text(item.id), // Hiển thị ID của mục
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SampleItemDetailsView(item: item), // Mở màn hình chi tiết mục
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchResults = viewModel.searchItems(query); // Kết quả gợi ý tìm kiếm dựa trên query
    return ListView.builder(
      itemCount: searchResults.length, // Số lượng kết quả gợi ý
      itemBuilder: (context, index) {
        final item = searchResults[index]; // Lấy mục tại vị trí index
        return ListTile(
          title: Text(item.name.value), // Hiển thị tên của mục
          subtitle: Text(item.id), // Hiển thị ID của mục
          onTap: () {
            query = item.name.value; // Gán giá trị tìm kiếm vào query
            showResults(context); // Hiển thị kết quả
          },
        );
      },
    );
  }
}

// Widget gốc của ứng dụng
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App', // Tiêu đề ứng dụng
      theme: ThemeData(
        primarySwatch: Colors.blue, // Màu chính của ứng dụng
        visualDensity: VisualDensity.adaptivePlatformDensity, // Độ dày của các phần tử giao diện
      ),
      home: SampleItemListView(), // Màn hình chính của ứng dụng
    );
  }
}
