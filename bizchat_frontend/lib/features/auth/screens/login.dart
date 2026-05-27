import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:bizchat_frontend/core/widget/buildErrorMessage.dart';
import 'package:bizchat_frontend/features/auth/controllers/auth_controller.dart';
import 'package:bizchat_frontend/features/auth/screens/widget/text_field_widget.dart';
import 'package:bizchat_frontend/features/chat/screens/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailAddressController = TextEditingController();
  final _passwordController = TextEditingController();

  late final ProviderSubscription<AuthState> _subscription;
  bool _obsecurePassword = true;
  bool _canLogIn = false;

  String? emailAddressError;
  String? passwordError;

  void _validateLogin() {
    final email = _emailAddressController.text.trim();
    final password = _passwordController.text.trim();

    String? emailError;
    String? passError;

    if (email.isEmpty) {
      emailError = 'Email address required';
    }

    if (password.isEmpty) {
      passError = 'Password field is required';
    }

    setState(() {
      emailAddressError = emailError;
      passwordError = passError;
      _canLogIn = emailError == null && passError == null;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailAddressController.addListener(_validateLogin);
    _passwordController.addListener(_validateLogin);


    _subscription = ref.listenManual<AuthState>(authControllerProvider, (previous, next) {
      if (!mounted) return;

      if (previous?.isLoggedIn == false && next.isLoggedIn == true) {        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _emailAddressController.removeListener(_validateLogin);
    _passwordController.removeListener(_validateLogin);

    _emailAddressController.dispose();
    _passwordController.dispose();
    _subscription.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
        // backgroundColor: AppColors.secondaryWhite,
        appBar: AppBar(
          title: const Text('Log In'),
          titleTextStyle: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryBlack,
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 19, color: AppColors.primaryColor),
              ),
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.only(
            top: 24,
            left: 16,
            right: 16,
            bottom: 24,
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textFieldWidget(
                          hintLabelText: 'Email or Phone Number',
                          textFieldController: _emailAddressController
                        ),

                        buildErrorMessage(emailAddressError),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondaryGray3,
                            border: Border.all(
                              color: AppColors.secondaryGray4,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: _obsecurePassword,
                                  decoration: InputDecoration(
                                    label: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 4.0,
                                      ),
                                      color: AppColors.secondaryGray3,
                                      child: Text(
                                        'Password',
                                        style: TextStyle(
                                          color: AppColors.secondaryGray5,
                                        ),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.secondaryGray3,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.secondaryGray3,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    fillColor: Colors.white,
                                    filled: false,
                                  ),
                                ),
                              ),

                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _obsecurePassword = !_obsecurePassword;
                                  });
                                },
                                child: Text(
                                  _obsecurePassword ? 'Show' : 'hide',
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        buildErrorMessage(passwordError),
                      ],
                    ),

                    const SizedBox(height: 20,),

                    if (authState.error != null && authState.isLoading == false)
                      Text(
                        authState.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),

                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          minimumSize: const Size(200, 50),
                        ),
                        onPressed: authState.isLoading ? null : () async {
                          if (_canLogIn) {
                            await ref
                              .read(authControllerProvider.notifier)
                              .login(
                              _emailAddressController.text,
                              _passwordController.text
                            );
                          }
                        },
                        child: authState.isLoading ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ) : Text(
                          'Log In',
                          style: TextStyle(
                            color: AppColors.secondaryWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      child: TextButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('hello Forgot password pressed');
                          }
                        },
                        child: Text(
                          'Forgot your password?',
                          style: TextStyle(
                            fontSize: 19,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}
