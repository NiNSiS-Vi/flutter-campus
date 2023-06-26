import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';


class CampusApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '失物招领',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CampusHomePage(),
    );
  }
}

class CampusHomePage extends StatefulWidget {
  @override
  _CampusHomePageState createState() => _CampusHomePageState();
}

class _CampusHomePageState extends State<CampusHomePage> {
  List<LostItem> lostItems = [
    LostItem(
      title: '水壶',
      time: DateTime.parse('2023-06-01 09:00'), // 转换成DateTime对象
      saveLocation: '宿舍一栋',
      location: '图书馆',
      category: '生活用品',
      claimStatus: '未认领',
      description: '黑色水壶，小黄鸭图案',
    ),
    LostItem(
      title: '钢笔',
      time: DateTime.parse('2023-06-01 09:00'), // 转换成DateTime对象
      saveLocation: '宿舍二栋',
      location: '操场',
      category: '生活用品',
      claimStatus: '未认领',
      description: '蓝色钢笔',
    ),
    // 添加更多失物对象
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('失物登记寻找系统'),
      ),
      body: ListView.builder(
        itemCount: lostItems.length,
        itemBuilder: (context, index) {
          return buildLostItemCard(lostItems[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterItemScreen()),
          ).then((newItem) {
            if (newItem != null) {
              setState(() {
                lostItems.add(newItem);
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildLostItemCard(LostItem item) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.category),
        title: Text(item.title),
        subtitle: Text('拾取时间：${item.time}\n拾取地点：${item.location}'),
        trailing: item.claimStatus == '未认领'
            ? IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            setState(() {
              item.claimStatus = '已认领';
              item.claimTime = DateTime.now();
            });
          },
        )
            : Text('认领'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LostItemDetailsScreen(item: item)),
          );
        },
      ),
    );
  }
}

class RegisterItemScreen extends StatefulWidget {
  @override
  _RegisterItemScreenState createState() => _RegisterItemScreenState();
}

class _RegisterItemScreenState extends State<RegisterItemScreen> {
  String title = '';
  DateTime? discoveryTime;
  String location = '';
  String description = '';
  String saveLocation = '';
  String category = '';
  List<String> categories = ['生活用品', '电子产品', '书籍资料', '证件卡片', '其他'];
  String? selectedCategory;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('失物登记'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(labelText: '失物名称'),
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            DateTimePicker(
              type: DateTimePickerType.dateTime,
              dateMask: 'yyyy-MM-dd HH:mm',
              initialValue: DateTime.now().toString(),
              firstDate: DateTime(2022),
              lastDate: DateTime(2030),
              icon: Icon(Icons.event),
              dateLabelText: '拾取时间',
              onChanged: (value) {
                setState(() {
                  discoveryTime = DateTime.parse(value);
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(labelText: '失物地点'),
              onChanged: (value) {
                setState(() {
                  location = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(labelText: '失物说明'),
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(labelText: '拾取地点'),
              onChanged: (value) {
                setState(() {
                  saveLocation = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(labelText: '保存地点'),
              onChanged: (value) {
                setState(() {
                  saveLocation = value;
                });
              },
            ),
            DropdownButton<String>(
              value: selectedCategory,
              hint: Text('请选择失物类别'),
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('提交'),
              onPressed: () {
                if (title.isNotEmpty && discoveryTime != null && location.isNotEmpty && description.isNotEmpty && saveLocation.isNotEmpty && selectedCategory != null) {
                  LostItem newItem = LostItem(
                    title: title,
                    time: discoveryTime!, // 直接赋值
                    location: location,
                    description: description,
                    saveLocation: saveLocation,
                    category: selectedCategory!,
                    claimStatus: '未认领',
                  );
                  Navigator.pop(context, newItem);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LostItemDetailsScreen extends StatelessWidget {
  final LostItem item;

  LostItemDetailsScreen({required this.item});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('失物详情'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('失物名称：${item.title}'),
            Text('拾取时间：${item.time}'),
            Text('拾取地点：${item.location}'),
            Text('保存地点: ${item.saveLocation}'),
            Text('失物类别：${item.category}'),
            Text('失物说明：${item.description}'),
            Text('认领状态：${item.claimStatus}'),
            if (item.claimStatus == '已认领')
              Text('认领时间：${item.claimTime}'),
          ],
        ),
      ),
    );
  }
}

class LostItem {
  String title;
  DateTime time;
  String location;
  String category;
  String description;
  String claimStatus;
  DateTime? claimTime;
  String saveLocation;

  LostItem({
    required this.title,
    required this.time,
    required this.location,
    required this.category,
    required this.description,
    required this.claimStatus,
    required this.saveLocation,
    this.claimTime,
  });
}
