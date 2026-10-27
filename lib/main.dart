import 'package:flutter/material.dart';

void main() => runApp(const OrbitGuildApp());

class OrbitGuildApp extends StatelessWidget {
  const OrbitGuildApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Orbit Guild',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF0C1222),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFA8F25C),
        brightness: Brightness.dark,
      ),
    ),
    home: const SignupPage(),
  );
}

enum TipStatus { idle, loading, ready, error }

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  static const ink = Color(0xFF0C1222),
      card = Color(0xFF182137),
      lime = Color(0xFFA8F25C),
      muted = Color(0xFFADB8D0);
  static const category = 'password_help';
  static const tips = <String>[
    'Use a long, unique password for each account. A password manager can help you remember it.',
    'Avoid names and birthdays in passwords. Choose a phrase that is hard for someone else to guess.',
    'Turn on two-factor authentication when it is available. A password alone should not be your only protection.',
  ];
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController();
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
    if (simulateFailure || tips.isEmpty) {
      setState(() => tipStatus = TipStatus.error);
      return;
    }
    // Fixed category only; no form controller value enters this feature.
    final selected = tips[nextTip % tips.length];
    nextTip++;
    setState(() {
      tip = selected;
      tipStatus = TipStatus.ready;
    });
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo signup complete — your form passed validation!'),
        backgroundColor: Color(0xFF36794F),
      ),
    );
  }

  InputDecoration decoration(String label, IconData icon, String hint) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: lime),
        filled: true,
        fillColor: const Color(0xFF101A2D),
        labelStyle: const TextStyle(color: muted),
        hintStyle: const TextStyle(color: Color(0xFF68768F)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF35425D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: lime, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      );

  Widget tipContent() => switch (tipStatus) {
    TipStatus.idle => const Text(
      'Get a quick password tip before you join. This demo never reads your form.',
      style: TextStyle(color: muted, height: 1.4),
    ),
    TipStatus.loading => const Row(
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2, color: lime),
        ),
        SizedBox(width: 12),
        Text('Choosing a preset tip...', style: TextStyle(color: muted)),
      ],
    ),
    TipStatus.ready => Text(
      tip!,
      style: const TextStyle(fontSize: 15, height: 1.45),
    ),
    TipStatus.error => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'The demo tip could not load. Your form is unaffected.',
          style: TextStyle(color: Color(0xFFFFB4A8)),
        ),
        TextButton.icon(
          onPressed: getTip,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry tip'),
        ),
      ],
    ),
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: lime,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.public, color: ink),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'ORBIT GUILD',
                      style: TextStyle(
                        color: lime,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.2,
                      ),
                    ),
                    const Spacer(),
                    const Text('01 / JOIN', style: TextStyle(color: muted)),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Find your\nnext crew.',
                  style: TextStyle(
                    fontSize: 42,
                    height: 1.02,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'A demo signup for players who like building things together.',
                  style: TextStyle(color: muted, fontSize: 16, height: 1.4),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF2A3852)),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'CREATE YOUR PROFILE',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            letterSpacing: 1.6,
                            color: muted,
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: decoration(
                            'Full name',
                            Icons.person_outline,
                            'Your name',
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Please enter your name'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: decoration(
                            'Email address',
                            Icons.alternate_email,
                            'you@example.com',
                          ),
                          validator: (v) {
                            final e = v?.trim() ?? '';
                            if (e.isEmpty) return 'Please enter your email';
                            if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                                .hasMatch(e)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: decoration(
                            'Password',
                            Icons.lock_outline,
                            'At least 6 characters',
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (v.length < 6) {
                              return 'Use at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 52,
                          child: FilledButton.icon(
                            onPressed: submit,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Join the guild'),
                            style: FilledButton.styleFrom(
                              backgroundColor: lime,
                              foregroundColor: ink,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF172B36),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF2F5360)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: lime),
                          SizedBox(width: 8),
                          Text(
                            'SIGNUP COACH',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'Preset demo tip—not live AI.',
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                      const SizedBox(height: 14),
                      tipContent(),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: tipStatus == TipStatus.loading
                                ? null
                                : getTip,
                            icon: const Icon(Icons.auto_awesome_outlined),
                            label: const Text('Get a signup tip'),
                          ),
                          TextButton(
                            onPressed: tipStatus == TipStatus.loading
                                ? null
                                : () => getTip(simulateFailure: true),
                            child: const Text('Test error'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Local category: $category · No form data is used.',
                        style: const TextStyle(color: muted, fontSize: 11),
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
