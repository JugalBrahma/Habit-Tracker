import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/config/theme/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BackgroundGalleryScreen extends StatefulWidget {
  const BackgroundGalleryScreen({super.key});

  @override
  State<BackgroundGalleryScreen> createState() => _BackgroundGalleryScreenState();
}

class _BackgroundGalleryScreenState extends State<BackgroundGalleryScreen> {
  List<String> _backgroundImages = [
    'assets/backgrounds/bg1.jpg',
    'assets/backgrounds/bg2.jpg',
    'assets/backgrounds/bg3.jpg',
    'assets/backgrounds/bg4.jpg',
    'assets/backgrounds/bg5.jpg',
    'assets/backgrounds/bg6.jpg',
    'assets/backgrounds/bg7.jpg',
    'assets/backgrounds/bg8.jpg',
  ];
  
  String? _selectedBackground;
  bool _useCustomBackground = false;

  @override
  void initState() {
    super.initState();
    _loadBackgroundSettings();
  }

  Future<void> _loadBackgroundSettings() async {
    setState(() {
      _selectedBackground = ThemeCubit.getSelectedBackground();
      _useCustomBackground = ThemeCubit.getUseCustomBackground();
    });
  }

  Future<void> _saveBackgroundSettings() async {
    if (_selectedBackground != null) {
      context.read<ThemeCubit>().setBackgroundImage(_selectedBackground!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Background Gallery',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Toggle for custom background
          Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              color: Theme.of(context).cardTheme.color,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Switch(
                      value: _useCustomBackground,
                      onChanged: (value) {
                        setState(() {
                          _useCustomBackground = value;
                        });
                        _saveBackgroundSettings();
                        context.read<ThemeCubit>().toggleBackgroundImage(value);
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Use Custom Background Image',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Background images grid
          if (_useCustomBackground) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Select Background Image',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 16 / 9,
                  ),
                  itemCount: _backgroundImages.length,
                  itemBuilder: (context, index) {
                    final imagePath = _backgroundImages[index];
                    final isSelected = _selectedBackground == imagePath;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedBackground = imagePath;
                        });
                        _saveBackgroundSettings();
                        context.read<ThemeCubit>().setBackgroundImage(imagePath);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected 
                                ? Theme.of(context).colorScheme.primary 
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Placeholder for background image
                              Container(
                                color: Theme.of(context).colorScheme.surfaceContainer,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: 40,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Background ${index + 1}',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Enable custom background to select images',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
