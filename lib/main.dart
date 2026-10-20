

    
          import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';

void main() { runApp(const FileNestApp()); }

class FileNestApp extends StatelessWidget {
  const FileNestApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, title: 'FileNest', theme: ThemeData(useMaterial3: true), home: const HomeScreen());
  }
}

class VideoFile { String name; String path; File file; VideoFile({required this.name, required this.path, required this.file}); }

class HomeScreen extends StatefulWidget { const HomeScreen({super.key}); @override State<HomeScreen> createState() => _HomeScreenState(); }

class _HomeScreenState extends State<HomeScreen> {
  List<VideoFile> videos = [];
  @override
  void initState() { super.initState(); requestPermission(); }
  Future<void> requestPermission() async { await Permission.videos.request(); await Permission.storage.request(); }
  Future<void> pickVideos() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video, allowMultiple: true);
    if (result != null) { setState(() { for (var f in result.files) { if (f.path != null) { videos.add(VideoFile(name: f.name, path: f.path!, file: File(f.path!))); } } }); }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text('FileNest', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true, backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(16), child: InkWell(onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => VideoListScreen(videos: videos, onAdd: pickVideos))); }, child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0,4))]), child: Row(children: [Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.red.withOpacity(0.15), shape: BoxShape.circle), child: const Icon(Icons.video_library, size: 32, color: Colors.red)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('My Videos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text('${videos.length} Videos - Click to open', style: const TextStyle(color: Colors.grey))])), const Icon(Icons.arrow_forward_ios, size: 18)])))),
        if (videos.isEmpty) const Expanded(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.video_collection, size: 80, color: Colors.grey), SizedBox(height: 16), Text('Mazal ma zedti hta video'), Text('Click + bach tzid video')]))),
        if (videos.isNotEmpty) Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: videos.length, itemBuilder: (context, i) { return Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(leading: const Icon(Icons.movie, color: Colors.red), title: Text(videos[i].name, maxLines: 1, overflow: TextOverflow.ellipsis), subtitle: Text(videos[i].path, maxLines: 1, overflow: TextOverflow.ellipsis), trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.grey), onPressed: (){setState(()=>videos.removeAt(i));}), onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_) => VideoPlayerScreen(videoFile: videos[i])));})); }))
      ]),
      floatingActionButton: FloatingActionButton.extended(backgroundColor: Colors.blue, foregroundColor: Colors.white, onPressed: pickVideos, icon: const Icon(Icons.add), label: const Text('Add Video')),
    );
  }
}

class VideoListScreen extends StatelessWidget {
  final List<VideoFile> videos; final VoidCallback onAdd; const VideoListScreen({super.key, required this.videos, required this.onAdd});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('My Videos'), backgroundColor: Colors.red, foregroundColor: Colors.white), body: videos.isEmpty ? const Center(child: Text('No videos yet')) : ListView.builder(itemCount: videos.length, itemBuilder: (context, i){ return ListTile(leading: const Icon(Icons.play_circle_fill, color: Colors.red, size: 40), title: Text(videos[i].name), onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_) => VideoPlayerScreen(videoFile: videos[i])));});}), floatingActionButton: FloatingActionButton(backgroundColor: Colors.red, child: const Icon(Icons.add), onPressed: onAdd));
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final VideoFile videoFile; const VideoPlayerScreen({super.key, required this.videoFile}); @override State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller; bool _init = false;
  @override
  void initState() { super.initState(); _controller = VideoPlayerController.file(widget.videoFile.file)..initialize().then((_) { setState(()=>_init=true); _controller.play(); }); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, appBar: AppBar(title: Text(widget.videoFile.name), backgroundColor: Colors.black, foregroundColor: Colors.white), body: Center(child: _init ? AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller)) : const CircularProgressIndicator()), floatingActionButton: _init ? FloatingActionButton(backgroundColor: Colors.red, onPressed: (){setState((){_controller.value.isPlaying ? _controller.pause() : _controller.play();});}, child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow)) : null);
  }
}
 
