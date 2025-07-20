import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wattsense/data/repositories/auth_repository.dart';
import 'package:wattsense/presentation/pages/auth_page/cubit/auth_cubit.dart';
import 'package:wattsense/presentation/pages/auth_page/forgot_password/forgot_password_page.dart';
import 'package:wattsense/presentation/pages/auth_page/signup/signup_page.dart';
import 'package:wattsense/presentation/widgets/custom_form_field.dart';
import 'package:wattsense/presentation/widgets/primary_action_button.dart';
import 'cubit/login_cubit.dart';

/// Entry point untuk halaman Login, menyediakan LoginCubit lokal.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(AuthRepository()),
      child: const LoginView(),
    );
  }
}

/// Widget yang membangun UI untuk halaman Login.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().login(
            _emailController.text, // Ini adalah argumen posisi pertama
            _passwordController.text, // Ini adalah argumen posisi kedua
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
      ),
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            // Memberi tahu AuthCubit global bahwa login berhasil.
            // AuthWrapper akan menangani navigasi ke halaman utama.
            context.read<AuthCubit>().userLoggedIn(state.user!);
          } else if (state.status == LoginStatus.failure) {
            // Logika untuk menampilkan error tetap di sini.
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'An error occurred.'),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        // DIUBAH: Menggunakan SingleChildScrollView kembali untuk mengatasi overflow
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                CustomFormField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  backgroundColor: Colors.grey[100],
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomFormField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  backgroundColor: Colors.grey[100],
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage()),
                      );
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    if (state.status == LoginStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return PrimaryActionButton(
                      text: 'Login',
                      onPressed: _submitLogin,
                      backgroundColor: const Color(0xFF0BC2E7),
                      foregroundColor: Colors.white,
                    );
                  },
                ),
                const SizedBox(
                    height: 24), // DIUBAH: Mengganti Spacer dengan SizedBox
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text('Sign up'),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Memberi sedikit jarak dari bawah
              ],
            ),
          ),
        ),
      ),
    );
  }
}
