import 'package:flutter/material.dart';
void main() => runApp(FileNestApp());
class FileNestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xFF121212)),
      home: HomePage(),
    );
  }
}
class Folder { String name; Folder({required this.name}); }
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  List<Folder> folders = [Folder(name: 'My Videos'), Folder(name: 'Documents')];
  bool isAdmin = false;
  void _createFolder() {
    var c = TextEditingController();
    showDialog(context: context, builder: (x) => AlertDialog(
      title: Text('Smi l-folder'),
      content: TextField(controller: c),
      actions: [TextButton(onPressed: (){ if(c.text.isNotEmpty){ setState(()=>folders.add(Folder(name: c.text))); Navigator.pop(context);} }, child: Text('Dir'))],
    ));
  }
  void _adminLogin() {
    var c = TextEditingController();
    showDialog(context: context, builder: (x) => AlertDialog(
      title: Text('Code: 1234'),
      content: TextField(controller: c, obscureText: true),
      actions: [TextButton(onPressed: (){ if(c.text=='1234'){ setState(()=>isAdmin=true); Navigator.pop(context);} }, child: Text('Dkhol'))],
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FileNest'), actions: [IconButton(onPressed: _adminLogin, icon: Icon(Icons.person))]),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: folders.length,
        itemBuilder: (context, i) => Container(
          decoration: BoxDecoration(color: Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFFFF6B2B), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.folder)),
            Spacer(),
            Text(folders[i].name, style: TextStyle(fontWeight: FontWeight.bold)),
          ]),
        ),
      ),
      floatingActionButton: isAdmin ? FloatingActionButton(backgroundColor: Color(0xFFFF6B2B), onPressed: _createFolder, child: Icon(Icons.add)) : null,
    );
  }
}
