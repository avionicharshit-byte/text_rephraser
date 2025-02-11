import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/storage_service.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _apiKeyController = TextEditingController();
  String _selectedProvider = 'claude';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0E21),
              const Color(0xFF0A0E21).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '< Text Rephraser />',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00FF9C),
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'AI-Powered Text Enhancement',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 40),
                _buildProviderSelection(),
                const SizedBox(height: 32),
                _buildApiKeyInput(),
                const SizedBox(height: 8),
                _buildGetApiKeyButton(),
                const SizedBox(height: 32),
                _buildInstructions(),
                const SizedBox(height: 32),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProviderSelection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1D1F3E),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF00FF9C)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select AI Provider',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00FF9C),
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'claude',
                label: Text('Claude'),
                icon: Icon(Icons.auto_awesome),
              ),
              ButtonSegment(
                value: 'chatgpt',
                label: Text('ChatGPT'),
                icon: Icon(Icons.psychology),
              ),
            ],
            selected: {_selectedProvider},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _selectedProvider = newSelection.first;
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return const Color(0xFF00FF9C);
                  }
                  return const Color(0xFF1D1F3E);
                },
              ),
              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.black;
                  }
                  return const Color(0xFF00FF9C);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApiKeyInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'API Key',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _apiKeyController,
          decoration: InputDecoration(
            hintText: 'Enter your ${_selectedProvider == 'claude' ? 'Claude' : 'ChatGPT'} API key',
            prefixIcon: const Icon(
              Icons.key,
              color: Color(0xFF00FF9C),
            ),
          ),
          obscureText: true,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildGetApiKeyButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: _launchApiKeyUrl,
        icon: const Icon(Icons.launch),
        label: Text(
          'Get ${_selectedProvider == 'claude' ? 'Claude' : 'ChatGPT'} API Key',
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.terminal,
                  color: Color(0xFF00FF9C),
                ),
                SizedBox(width: 8),
                Text(
                  'How to use',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00FF9C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInstructionStep(
              platform: 'iOS',
              steps: [
                'Select text in any app',
                'Tap the share button',
                'Choose "Rephrase Text"',
                'Paste the rephrased text',
              ],
            ),
            const SizedBox(height: 16),
            _buildInstructionStep(
              platform: 'Android',
              steps: [
                'Select text in any app',
                'Look for "Rephrase" in the menu',
                'Tap to rephrase the text',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep({
    required String platform,
    required List<String> steps,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          platform,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00D1FF),
          ),
        ),
        const SizedBox(height: 8),
        ...steps.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.key + 1}.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _saveApiKey,
      icon: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
          : const Icon(Icons.save),
      label: Text(
        _isLoading ? 'Saving...' : 'Save API Key',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Future<void> _launchApiKeyUrl() async {
    final url = _selectedProvider == 'claude'
        ? 'https://console.anthropic.com/account/keys'
        : 'https://platform.openai.com/api-keys';
    
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open URL')),
        );
      }
    }
  }

  Future<void> _saveApiKey() async {
    if (_apiKeyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an API key'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await StorageService.saveApiKey(
        _apiKeyController.text,
        _selectedProvider,
      );
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/test');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}