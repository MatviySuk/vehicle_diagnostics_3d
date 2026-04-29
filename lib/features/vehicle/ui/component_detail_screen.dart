import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/vehicle_providers.dart';

class ComponentDetailScreen extends ConsumerStatefulWidget {
  final String componentId;

  const ComponentDetailScreen({super.key, required this.componentId});

  @override
  ConsumerState<ComponentDetailScreen> createState() => _ComponentDetailScreenState();
}

class _ComponentDetailScreenState extends ConsumerState<ComponentDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _selectedSeverity = 'low';

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      ref.read(diagnosticReportControllerProvider.notifier).submitReport(
            widget.componentId,
            _descriptionController.text,
            _selectedSeverity,
          );
      _descriptionController.clear();
      // Unfocus keyboard
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(diagnosticReportControllerProvider).isLoading;

    // Listen to success/error to show snackbars
    ref.listen<AsyncValue<void>>(
      diagnosticReportControllerProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to submit report: $error'), backgroundColor: Colors.red),
            );
          },
          data: (_) {
            if (previous?.isLoading == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Diagnostic report submitted successfully!'), backgroundColor: Colors.green),
              );
            }
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text('Component: ${widget.componentId}')),
      body: Column(
        children: [
          // AGOSTINHO'S 3D COMPONENT WIDGET
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[900],
              child: Center(
                child: Text(
                  '3D Rotating ${widget.componentId}\n(Agostinho\'s Flame Widget)',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
          // MAHMUD'S DIAGNOSTIC UI / FORM HANDLING
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text('Report Issue', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Issue Description',
                        border: OutlineInputBorder(),
                        hintText: 'Describe the problem in detail...',
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.trim().length < 10) {
                          return 'Description must be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedSeverity,
                      decoration: const InputDecoration(
                        labelText: 'Severity Level',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'low', child: Text('Low')),
                        DropdownMenuItem(value: 'medium', child: Text('Medium')),
                        DropdownMenuItem(value: 'high', child: Text('High')),
                        DropdownMenuItem(value: 'critical', child: Text('Critical')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedSeverity = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: isSubmitting
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.send),
                      label: Text(isSubmitting ? 'Submitting...' : 'Submit Diagnostic Report'),
                      onPressed: isSubmitting ? null : _submitReport,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
