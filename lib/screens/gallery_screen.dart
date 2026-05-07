import 'package:flutter/material.dart';
import 'package:habit_tracker/service/background_service.dart';

class GalleryScreen extends StatelessWidget {
  final BackgroundService backgroundService;
  const GalleryScreen({super.key, required this.backgroundService});

  final List<String> backgrounds = const [
    'assets/backgrounds/bg1.png',
    'assets/backgrounds/bg2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Gallery", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ValueListenableBuilder<String>(
        valueListenable: backgroundService,
        builder: (context, selectedBackground, _) {
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.7,
            ),
            itemCount: backgrounds.length,
            itemBuilder: (context, index) {
              final isSelected = selectedBackground == backgrounds[index];
              return GestureDetector(
                onTap: () => backgroundService.setBackground(backgrounds[index]),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          backgrounds[index],
                          fit: BoxFit.cover,
                        ),
                        if (isSelected)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 15,
                              child: Icon(
                                Icons.check,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
