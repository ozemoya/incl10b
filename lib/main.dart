import 'package:flutter/material.dart';

void main() => runApp(const OrbitGuildApp());

const pageColor = Color(0xFFF0E9FF);
const purple = Color(0xFF56348D);
const deepPurple = Color(0xFF32185F);
const palePurple = Color(0xFFE2D1FF);

class OrbitGuildApp extends StatelessWidget {
  const OrbitGuildApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orbit Guild',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pageColor,
        colorScheme: ColorScheme.fromSeed(seedColor: purple),
        fontFamily: 'Roboto',
      ),
      home: const SignupPage(),
    );
  }
}

enum TipStatus { idle, loading, ready, error }

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  static const category = 'password_help';
  static const tips = <String>[
    'Use a long, unique password for each account. A password manager can help you remember it.',
    'Avoid names and birthdays in passwords. Choose a phrase that is hard for someone else to guess.',
    'Turn on two-factor authentication when it is available. A password alone should not be your only protection.',
  ];

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  TipStatus tipStatus = TipStatus.idle;
  String? tip;
  int nextTip = 0;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> getTip({bool simulateFailure = false}) async {
    if (tipStatus == TipStatus.loading) return;

    setState(() {
      tipStatus = TipStatus.loading;
      tip = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    if (simulateFailure) {
      setState(() => tipStatus = TipStatus.error);
      return;
    }

    setState(() {
      tip = tips[nextTip % tips.length];
      nextTip++;
      tipStatus = TipStatus.ready;
    });
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo signup complete — your form passed validation!'),
      ),
    );
  }

  InputDecoration fieldStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: purple),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFD8C9F2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: purple, width: 2),
      ),
    );
  }

  Widget buildTip() {
    switch (tipStatus) {
      case TipStatus.idle:
        return const Text(
          'Get a quick password tip before you join. Your form stays private.',
        );
      case TipStatus.loading:
        return const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text('Choosing a preset tip...'),
          ],
        );
      case TipStatus.ready:
        return Text(tip!);
      case TipStatus.error:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('The demo tip could not load. Your form is unaffected.'),
            TextButton.icon(
              onPressed: getTip,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry tip'),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: deepPurple,
                        child: Icon(Icons.auto_awesome, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'orbit guild',
                        style: TextStyle(
                          color: deepPurple,
                          fontWeight: FontWeight.w800,
                          fontSize: 19,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'JOIN THE CREW',
                          style: TextStyle(
                            color: purple,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const HeroCard(),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F6FF),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1D56348D),
                          blurRadius: 24,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Create your profile',
                            style: TextStyle(
                              color: deepPurple,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'A few details and you are ready to go.',
                            style: TextStyle(color: Color(0xFF716583)),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: nameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: fieldStyle(
                              'Full name',
                              Icons.person_outline,
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Please enter your name'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: fieldStyle(
                              'Email address',
                              Icons.mail_outline,
                            ),
                            validator: (value) {
                              final email = value?.trim() ?? '';
                              if (email.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                                  .hasMatch(email)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: fieldStyle(
                              'Password',
                              Icons.lock_outline,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Use at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            height: 52,
                            child: FilledButton(
                              onPressed: submit,
                              style: FilledButton.styleFrom(
                                backgroundColor: deepPurple,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Join the guild'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: palePurple,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: deepPurple),
                            SizedBox(width: 8),
                            Text(
                              'Signup tip',
                              style: TextStyle(
                                color: deepPurple,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        DefaultTextStyle(
                          style: const TextStyle(
                            color: deepPurple,
                            fontSize: 14,
                            height: 1.4,
                          ),
                          child: buildTip(),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            OutlinedButton(
                              onPressed: tipStatus == TipStatus.loading
                                  ? null
                                  : getTip,
                              child: const Text('Get a signup tip'),
                            ),
                            TextButton(
                              onPressed: tipStatus == TipStatus.loading
                                  ? null
                                  : () => getTip(simulateFailure: true),
                              child: const Text('Test error'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Preset demo tip, not live AI. No form data is used.',
                          style: TextStyle(
                            color: Color(0xFF716583),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Local category: $category',
                          style: TextStyle(
                            color: Color(0xFF716583),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeroCard extends StatelessWidget {
  const HeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF402474), Color(0xFF8B65C9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -35,
            top: -55,
            child: CircleAvatar(
              radius: 115,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            right: 18,
            top: 28,
            child: Transform.rotate(
              angle: -0.24,
              child: const _FloatingPiece(
                icon: Icons.sports_esports_rounded,
                size: 115,
              ),
            ),
          ),
          Positioned(
            right: 95,
            bottom: 18,
            child: Transform.rotate(
              angle: 0.28,
              child: const _FloatingPiece(
                icon: Icons.headphones_rounded,
                size: 70,
              ),
            ),
          ),
          const Positioned(
            left: 22,
            top: 20,
            child: Text(
              'NEW CONNECTIONS ✦',
              style: TextStyle(
                color: Color(0xFFE7D9FF),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const Positioned(
            left: 22,
            bottom: 25,
            child: Text(
              'Find your\nnext crew.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 37,
                height: 0.98,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingPiece extends StatelessWidget {
  const _FloatingPiece({required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF4EFFF),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x6631185C),
            blurRadius: 18,
            offset: Offset(8, 12),
          ),
        ],
      ),
      child: Icon(icon, color: purple, size: size * 0.58),
    );
  }
}
