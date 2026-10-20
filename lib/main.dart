import 'package:flutter/material.dart';

void main() {
  runApp(FileNestApp());
}

class FileNestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FileNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFF5F7FB),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'title': 'My Videos', 'icon': Icons.video_library, 'color': Colors.red, 'count': '12 Videos'},
    {'title': 'Images', 'icon': Icons.image, 'color': Colors.green, 'count': '45 Images'},
    {'title': 'Documents', 'icon': Icons.description, 'color': Colors.blue, 'count': '8 Docs'},
    {'title': 'Audio', 'icon': Icons.music_note, 'color': Colors.orange, 'count': '20 Songs'},
    {'title': 'Downloads', 'icon': Icons.download, 'color': Colors.purple, 'count': '15 Files'},
    {'title': 'APKs', 'icon': Icons.android, 'color': Colors.teal, 'count': '5 APKs'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FileNest', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            var cat = categories[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryScreen(
                      title: cat['title'],
                      icon: cat['icon'],
                      color: cat['color'],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cat['color'].withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(cat['icon'], size: 40, color: cat['color']),
                    ),
                    SizedBox(height: 12),
                    Text(cat['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 4),
                    Text(cat['count'], style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  CategoryScreen({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              title: Text('$title File ${index + 1}'),
              subtitle: Text('12.5 MB • Today'),
              trailing: Icon(Icons.more_vert),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening $title File ${index + 1}')),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: color,
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

 
