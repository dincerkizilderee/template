import 'package:flutter/material.dart';
import '../../../../core/cache/cache_manager.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final box = await CacheManager.openBox<String>('authBox');
              await box.delete('access_token');
              await box.delete('refresh_token');
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: const Center(child: Text('Welcome to the Enterprise Template!')),
    );
  }
}
