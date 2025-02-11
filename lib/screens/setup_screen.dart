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
  String _selectedProvider = 'claude'; // or 'chatgpt'
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Rephraser Setup'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Setup Instructions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildProviderSelection(),
            const SizedBox(height: 24),
            _buildApiKeyInput(),
            const SizedBox(height: 8),
            _buildGetApiKeyButton(),
            const SizedBox(height: 24),
            _buildInstructions(),
            const SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderSelection() {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(
          value: 'claude',
          label: Text('Claude'),
        ),
        ButtonSegment(
          value: 'chatgpt',
          label: Text('ChatGPT'),
        ),
      ],
      selected: {_selectedProvider},
      onSelectionChanged: (Set<String> newSelection) {
        setState(() {
          _selectedProvider = newSelection.first;
        });
      },
    );
  }

  Widget _buildApiKeyInput() {
    return TextField(
      controller: _apiKeyController,
      decoration: InputDecoration(
        labelText: '${_selectedProvider == 'claude' ? 'Claude' : 'ChatGPT'} API Key',
        border: const OutlineInputBorder(),
        helperText: 'Enter your API key',
      ),
      obscureText: true,
    );
  }

  Widget _buildGetApiKeyButton() {
    return TextButton(
      onPressed: () => _launchApiKeyUrl(),
      child: Text('Get ${_selectedProvider == 'claude' ? 'Claude' : 'ChatGPT'} API Key'),
    );
  }

  Widget _buildInstructions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How to use:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'iOS:\n'
              '1. Select text in any app\n'
              '2. Tap the share button\n'
              '3. Choose "Rephrase Text"\n'
              '4. Paste the rephrased text\n\n'
              'Android:\n'
              '1. Select text in any app\n'
              '2. Look for "Rephrase" in the menu\n'
              '3. Tap to rephrase the text',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _saveApiKey,
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('Save API Key'),
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
        const SnackBar(content: Text('Please enter an API key')),
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
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}