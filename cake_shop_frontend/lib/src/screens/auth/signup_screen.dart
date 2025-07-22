import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '', _email = '', _password = '';
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    _formKey.currentState!.save();
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .signup(_username, _email, _password);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false);
    } catch (e) {
      setState(() => _error = 'Signup failed');
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: SizedBox(
          width: 370,
          child: Card(
            color: Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.all(32),
            elevation: 0.5,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cake, size: 47),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Username', prefixIcon: Icon(Icons.person)),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? "Enter username" : null,
                      onSaved: (v) => _username = v?.trim() ?? '',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Email', prefixIcon: Icon(Icons.email)),
                      validator: (v) =>
                          (v == null || !v.contains('@')) ? "Enter email" : null,
                      onSaved: (v) => _email = v?.trim() ?? '',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Password', prefixIcon: Icon(Icons.lock)),
                      obscureText: true,
                      validator: (v) =>
                          (v == null || v.isEmpty || v.length < 6) ? "Password min 6 chars" : null,
                      onSaved: (v) => _password = v ?? '',
                    ),
                    const SizedBox(height: 18),
                    if (_loading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Sign Up'),
                      ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: Text(_error!,
                            style: const TextStyle(color: Colors.redAccent)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
