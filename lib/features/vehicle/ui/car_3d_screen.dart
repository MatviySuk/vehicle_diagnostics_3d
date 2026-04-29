import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Car3DScreen extends StatelessWidget {
  const Car3DScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3D Vehicle View')),
      body: Stack(
        children: [
          // AGOSTINHO'S FLAME 3D WIDGET GOES HERE
          Container(
            color: Colors.grey[800],
            child: const Center(
              child: Text(
                'Interactive 3D Car Model (Agostinho)\nClicking a headlight navigates to /component/headlight',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          // OVERLAY UI (Mahmud)
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () => context.push('/component/headlight_left'),
              child: const Text('Simulate Clicking Headlight'),
            ),
          ),
        ],
      ),
    );
  }
}
