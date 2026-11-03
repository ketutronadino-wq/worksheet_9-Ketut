import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import 'home_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _nameC = TextEditingController();
  final _passC = TextEditingController();
  final _confirmC = TextEditingController();
  String _role = 'seeker';
  bool _loading = false;

  @override
  void dispose() { 
    _emailC.dispose(); _nameC.dispose(); _passC.dispose(); _confirmC.dispose(); 
    super.dispose(); 
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final res = await AuthService.instance.register(
        email: _emailC.text.trim(),
        password: _passC.text,
        name: _nameC.text.trim(),
        role: _role,
      );
      if (!mounted) return;

      if (res.session != null) {
        // Jika email confirmation mati, langsung masuk
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi berhasil. Silakan cek email atau login.')));
        Navigator.of(context).pop();
      }
    } on AuthException catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Terjadi kesalahan koneksi.')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun KosFinder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _nameC, decoration: const InputDecoration(labelText: 'Nama Lengkap'), validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _emailC, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress, validator: (v) => !v!.contains('@') ? 'Email tidak valid' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _passC, obscureText: true, decoration: const InputDecoration(labelText: 'Password'), validator: (v) => v!.length < 6 ? 'Minimal 6 karakter' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _confirmC, obscureText: true, decoration: const InputDecoration(labelText: 'Konfirmasi Password'), validator: (v) => v != _passC.text ? 'Password tidak sama' : null),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _role,
                decoration: const InputDecoration(labelText: 'Daftar Sebagai'),
                items: const [
                  DropdownMenuItem(value: 'seeker', child: Text('Pencari Kos (Seeker)')),
                  DropdownMenuItem(value: 'owner', child: Text('Pemilik Kos (Owner)')),
                ],
                onChanged: (v) => setState(() => _role = v!),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _loading ? null : _register,
                child: _loading ? const CircularProgressIndicator() : const Text('Register'),
              ),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Sudah punya akun? Login')),
            ],
          ),
        ),
      ),
    );
  }
}