import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';
import 'package:astrea_correct_app/api/grammar_api_service.dart';
import 'package:astrea_correct_app/login_screen.dart';
import 'package:astrea_correct_app/theme.dart';

class HomeScreen extends StatefulWidget {
  final bool isGuest;
  const HomeScreen({Key? key, this.isGuest = false}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  String _selectedLanguage = 'english';
  String _correctedText = '';
  bool _isLoading = false;
  int _guestCorrectionCount = 0;
  static const int _guestCorrectionLimit = 10;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, String>> _languages = [
    {'code': 'english', 'label': 'English', 'flag': '🇬🇧'},
    {'code': 'french', 'label': 'French', 'flag': '🇫🇷'},
    {'code': 'spanish', 'label': 'Spanish', 'flag': '🇪🇸'},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.05)
        .animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _inputController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _getCorrection() async {
    if (widget.isGuest &&
        _guestCorrectionCount >= _guestCorrectionLimit) {
      _showGuestLimitDialog();
      return;
    }
    if (_inputController.text.trim().isEmpty) return;
    setState(() { _isLoading = true; _correctedText = ''; });
    try {
      final result = await GrammarApiService.correctText(
          _inputController.text, _selectedLanguage);
      if (widget.isGuest) setState(() => _guestCorrectionCount++);
      setState(() => _correctedText = result);
    } catch (e) {
      setState(() => _correctedText = 'An error occurred. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false);
    }
  }

  void _showGuestLimitDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: kGlassDecoration(radius: 20),
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.lock_outline,
                    color: kAccentColor, size: 40),
                const SizedBox(height: 14),
                Text('Limit Reached', style: AppTextStyles.headline2),
                const SizedBox(height: 10),
                Text(
                  "You've used your 10 free corrections. Sign up to keep going!",
                  style: AppTextStyles.subtitle1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Later',
                        style:
                            AppTextStyles.labelText.copyWith(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _signOut,
                    child: Text('Sign Up', style: AppTextStyles.buttonText),
                  ),
                ]),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: kBackgroundGradient),
        child: Stack(
          children: [
            // Background orb top right
            Positioned(top: 40, right: -50,
              child: Container(width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    kPrimaryColor.withOpacity(0.2), Colors.transparent,
                  ]),
                ),
              ),
            ),
            SafeArea(
              child: Column(children: [
                _buildAppBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      FadeInDown(
                        delay: const Duration(milliseconds: 100),
                        child: _buildLanguageSelector(),
                      ),
                      const SizedBox(height: 14),
                      FadeInLeft(
                        delay: const Duration(milliseconds: 200),
                        child: _buildInputCard(),
                      ),
                      const SizedBox(height: 16),
                      FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        child: _buildCorrectButton(),
                      ),
                      if (widget.isGuest) ...[
                        const SizedBox(height: 10),
                        FadeIn(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: kGlassColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: kGlassBorder),
                              ),
                              child: Text(
                                '${_guestCorrectionLimit - _guestCorrectionCount} / $_guestCorrectionLimit corrections remaining',
                                style: AppTextStyles.labelText
                                    .copyWith(color: kAccentColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      if (_correctedText.isNotEmpty)
                        FadeInUp(
                          delay: const Duration(milliseconds: 100),
                          child: _buildOutputCard(),
                        )
                      else
                        _buildOutputPlaceholder(),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0x22FFFFFF),
            border: Border(
                bottom: BorderSide(color: kGlassBorder, width: 0.8)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                      colors: [kPrimaryColor, kSecondaryColor]),
                  boxShadow: [
                    BoxShadow(color: kPrimaryColor.withOpacity(0.5),
                        blurRadius: 10)
                  ],
                ),
                padding: const EdgeInsets.all(4),
                child: ClipOval(
                    child: Image.asset('assets/images/logo.png',
                        fit: BoxFit.cover)),
              ),
              const SizedBox(width: 10),
              Text('Astrea Correct',
                  style: AppTextStyles.headline2.copyWith(fontSize: 18)),
              const Spacer(),
              if (!widget.isGuest)
                IconButton(
                  icon: const Icon(Icons.logout_rounded,
                      color: kTextColorSecondary, size: 22),
                  onPressed: _signOut,
                  tooltip: 'Sign Out',
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Row(
      children: _languages.map((lang) {
        final bool selected = _selectedLanguage == lang['code'];
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedLanguage = lang['code']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: selected ? kButtonGradient : null,
                color: selected ? null : kGlassColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? kPrimaryColor : kGlassBorder,
                  width: selected ? 1.5 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                            color: kPrimaryColor.withOpacity(0.35),
                            blurRadius: 12)
                      ]
                    : [],
              ),
              child: Column(children: [
                Text(lang['flag']!, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                Text(lang['label']!,
                    style: AppTextStyles.labelText.copyWith(
                        color: selected ? Colors.white : kTextColorSecondary,
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 11)),
              ]),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInputCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: kGlassDecoration(radius: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Row(children: [
                  const Icon(Icons.edit_outlined,
                      color: kAccentColor, size: 16),
                  const SizedBox(width: 6),
                  Text('Input Text', style: AppTextStyles.labelText),
                ]),
              ),
              TextField(
                controller: _inputController,
                style: AppTextStyles.bodyText.copyWith(fontSize: 14, height: 1.6),
                maxLines: 7,
                minLines: 4,
                decoration: InputDecoration(
                  hintText: 'Paste or type your text here...',
                  hintStyle:
                      AppTextStyles.labelText.copyWith(color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCorrectButton() {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: kButtonGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: kPrimaryColor.withOpacity(0.45),
                blurRadius: 18,
                offset: const Offset(0, 6)),
          ],
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: _isLoading ? null : _getCorrection,
          icon: _isLoading
              ? const SizedBox(height: 18, width: 18,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : const Icon(Icons.auto_fix_high_rounded,
                  color: Colors.white, size: 20),
          label: Text(
            _isLoading ? 'Correcting...' : 'Correct with Astrea',
            style: AppTextStyles.buttonText,
          ),
        ),
      ),
    );
  }

  Widget _buildOutputCard() {
    final bool isError =
        _correctedText.startsWith('Error:') ||
        _correctedText.startsWith('An error');
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: kGlassDecoration(
            radius: 20,
            borderColor: isError
                ? Colors.redAccent.withOpacity(0.4)
                : kSuccessTextColor.withOpacity(0.3),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Icon(
                      isError
                          ? Icons.error_outline
                          : Icons.check_circle_outline,
                      color: isError ? Colors.redAccent : kSuccessTextColor,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(isError ? 'Error' : 'Corrected Output',
                        style: AppTextStyles.labelText.copyWith(
                            color: isError
                                ? Colors.redAccent
                                : kSuccessTextColor)),
                  ]),
                  if (!isError)
                    IconButton(
                      icon: const Icon(Icons.copy_rounded,
                          color: kAccentColor, size: 18),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: _correctedText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Copied!',
                                style: AppTextStyles.labelText),
                            backgroundColor: kCardColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      tooltip: 'Copy',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
              const Divider(color: kGlassBorder, height: 16),
              Text(
                _correctedText,
                style: AppTextStyles.bodyText.copyWith(
                    height: 1.7,
                    color: isError ? Colors.redAccent : kTextColorPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutputPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: kGlassDecoration(radius: 20),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          child: Column(children: [
            Icon(Icons.auto_awesome_outlined,
                color: kTextColorSecondary.withOpacity(0.4), size: 40),
            const SizedBox(height: 12),
            Text(
              'Corrected text will appear here.',
              style: AppTextStyles.subtitle1
                  .copyWith(color: kTextColorSecondary.withOpacity(0.5)),
              textAlign: TextAlign.center,
            ),
          ]),
        ),
      ),
    );
  }
}
