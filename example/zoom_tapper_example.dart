import 'package:flutter/material.dart';
import 'package:zoom_tapper/src/zoom_tapper.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ZoomTapper(
                child: FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Yay! A SnackBar!',
                        ),
                      ),
                    );
                  },
                  child: const Text('BUTTON'),
                ),
              ),
              const SizedBox(height: 50),
              ZoomTapper(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Yay! A SnackBar!',
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ZoomTapper(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'OnLongPressUp!',
                      ),
                    ),
                  );
                },
                onLongPressUp: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'OnLongPressUp!',
                      ),
                    ),
                  );
                },
                child: const Card(
                  margin: EdgeInsets.zero,
                  child: SizedBox(
                    height: 100,
                    width: 100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}