import 'package:flutter/material.dart';

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
      time: '2023-06-01 09:00',
      location: '图书馆',
      category: '生活用品',
      claimStatus: '未认领',
      description: '黑色水壶，小黄鸭图案',
    ),
    LostItem(
      title: '钢笔',
      time: '2023-06-01 09:00',
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
        subtitle: Text('时间：${item.time}\n地点：${item.location}'),
        trailing: item.claimStatus == '未认领'
            ? IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            setState(() {
              item.claimStatus = '已认领';
              item.claimTime = DateTime.now().toString();
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
            ElevatedButton(
              child: Text('选择发现时间'),
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2030),
                );

                if (selectedDate != null) {
                  setState(() {
                    discoveryTime = selectedDate;
                  });
                }
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
              decoration: InputDecoration(labelText: '保存地点'),
              onChanged: (value) {
                setState(() {
                  saveLocation = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(labelText: '失物类别'),
              onChanged: (value) {
                setState(() {
                  category = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('提交'),
              onPressed: () {
                // 执行提交逻辑
                // 创建 LostItem 对象并提交到数据库
                // 可以使用相应的变量访问输入的值

                Navigator.pop(context); // 关闭登记界面
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
            Text('遗失时间：${item.time}'),
            Text('失物地点：${item.location}'),
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
  String time;
  String location;
  String category;
  String description;
  String claimStatus;
  String claimTime;

  LostItem({
    required this.title,
    required this.time,
    required this.location,
    required this.category,
    required this.description,
    required this.claimStatus,
    this.claimTime = '',
  });
}
