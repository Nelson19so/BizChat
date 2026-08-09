import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:bizchat_frontend/core/widget/buildErrorMessage.dart';
import 'package:bizchat_frontend/core/widget/scaffholdmessage.dart';
import 'package:bizchat_frontend/features/auth/controllers/auth_controller.dart';
import 'package:bizchat_frontend/features/auth/screens/widget/text_field_widget.dart';
import 'package:bizchat_frontend/features/chat/screens/home.dart';
import 'package:bizchat_frontend/features/provider/provders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  String? firstNameError;
  String? lastNameError;
  String? emailError;
  String? passwordError;

  bool isChecked = false;
  bool _canRegister = false;
  bool _handleRegister = false;

  void _validatePassword() {
    final password = passwordController.text.trim();
    final strongPasswordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$');

    setState(() {
      if (password.isEmpty) {
        passwordError = 'Password field is required';
      } else if (password.length < 8) {
        passwordError = 'Password must be at least 8 characters long';
      } else if (!strongPasswordRegex.hasMatch(password)) {
        passwordError = 'Requires uppercase, lowercase, number & symbol';
      } else {
        passwordError = null;
      }
    });
  }

  void _validateFirstName() {
    final firstName = firstNameController.text.trim();
    final letterRegEx = RegExp(r'^[a-zA-Z]+$');

    setState(() {
      if (firstName.isEmpty) {
        firstNameError = 'First Name is required';
      } else if (firstName.length <= 3) {
        firstNameError = 'First name is too short';
      } else if (!letterRegEx.hasMatch(firstName)) {
        firstNameError = 'First name must contain only letters';
      } else {
        firstNameError = null;
      }
    });
  }

  void _validateLastName() {
    final lastName = lastNameController.text.trim();
    final letterRegEx = RegExp(r'^[a-zA-Z]+$');

    setState(() {
      if (lastName.isEmpty) {
        lastNameError = 'Last Name is required';
      } else if (lastName.length <= 3) {
        lastNameError = 'Last name is too short';
      }  else if (!letterRegEx.hasMatch(lastName)) {
        lastNameError = 'Last name must contain only letters';
      } else {
        lastNameError = null;
      }
    });
  }

  void _validateEmail() {
    final email = emailController.text.trim();

    // Email format regular expression
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    setState(() {
      if (email.isEmpty) {
        emailError = 'Email address is required';
      } else if (!emailRegex.hasMatch(email)) {
        emailError = 'Please enter a valid email address format';
      } else if (email.length <= 5) {
        emailError = 'Email must be longer than 5 characters';
      } else {
        emailError = null;
      }
    });
  }

  void _validateBeforeRegister() {
    _validateFirstName();
    _validateLastName();
    _validateEmail();
    _validatePassword();

    setState(() {
      _canRegister =
        firstNameError == null
        && lastNameError == null
        && emailError == null
        && passwordError == null;
    });
  }

  late final ProviderSubscription<AuthState> _subscription;

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(_validateFirstName);
    lastNameController.addListener(_validateLastName);
    emailController.addListener(_validateEmail);
    passwordController.addListener(_validatePassword);

    Future.microtask(() => {
      ref.read(authControllerProvider.notifier).clearError()
    });

    _subscription = ref.listenManual<AuthState>(authControllerProvider, (previous, next) {
      if (!mounted) return;

      final justRegistered =
        previous?.isLoading == true &&
        next.isLoading == false &&
        next.success != null &&
        next.error == null &&
        next.isLoggedIn == true;

      if (justRegistered && !_handleRegister) {
        _handleRegister = true;

        scaffholdmessage(
          context: context,
          message: '${next.success}',
          type: ScaffHoldMessageType.successful
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    firstNameController.removeListener(_validateFirstName);
    lastNameController.removeListener(_validateLastName);
    emailController.removeListener(_validateEmail);
    passwordController.removeListener(_validatePassword);

    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    _subscription.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      // backgroundColor: AppColors.secondaryWhite,
      appBar: AppBar(
        title: const Text('Sign Up'),
        titleTextStyle: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: AppColors.secondaryBlack,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Text(
              'login',
              style: TextStyle(fontSize: 19, color: AppColors.primaryColor),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textFieldWidget(
                              hintLabelText: 'First Name',
                              textFieldController: firstNameController,
                              hasError: firstNameError == null ? false : true,
                            ),

                            buildErrorMessage(firstNameError),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textFieldWidget(
                              hintLabelText: 'Last Name',
                              textFieldController: lastNameController,
                              hasError: lastNameError == null ? false : true,
                            ),

                            buildErrorMessage(lastNameError),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textFieldWidget(
                        hintLabelText: 'Email Address',
                        textFieldController: emailController,
                        hasError: emailError == null ? false : true,
                      ),

                      buildErrorMessage(emailError),
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
                            // Toggle color: Red if there is an error, otherwise gray
                            color: passwordError != null
                                ? Colors.red
                                : AppColors.secondaryGray4,
                            width: passwordError != null
                                ? 1.0
                                : 1.0, // Optional: make it thicker on error
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: passwordController,
                                obscureText: obscurePassword,
                                decoration: InputDecoration(
                                  label: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    color: AppColors.secondaryGray3,
                                    child: Text(
                                      'Password',
                                      style: TextStyle(
                                        color: passwordError != null
                                            ? Colors.red
                                            : AppColors.secondaryGray5,
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
                                  obscurePassword = !obscurePassword;
                                });
                                if (kDebugMode) {
                                  print('Hello show pwd');
                                }
                              },
                              child: Text(
                                obscurePassword ? 'Show' : 'Hide',
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

                  const SizedBox(height: 32),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                        activeColor: AppColors.secondaryGray3,
                        checkColor: AppColors.primaryColor,
                        // shape: CircleBorder(),
                        side: BorderSide(
                          color: AppColors.secondaryGray4,
                          width: 2,
                        ),
                        // Use fillColor to control the background independently of the border
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors
                                .secondaryGray3; // Color when checked
                          }
                          return null;
                        }),
                        value: isChecked,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            isChecked = value;
                          });
                        },
                      ),

                      Expanded(
                        child: const Text(
                          'I would like to receive your newsletter and other promotional information.',
                          style: TextStyle(
                            color: AppColors.secondaryGray8,
                            fontSize: 16,
                          ),
                        ),
                      ),
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

              Builder(
                builder: (scaffoldContext) {
                  return SizedBox(
                    height: 51,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        minimumSize: const Size(200, 50),
                      ),
                      onPressed: authState.isLoading ? null : () {
                        _validateBeforeRegister();

                        if (!isChecked) {
                          scaffholdmessage(
                            context: context,
                            message: 'Please agree to receive newsletters to proceed.',
                            type: ScaffHoldMessageType.failed,
                          );
                          return;
                        }

                        /// Register provider
                        if (_canRegister) {
                          ref.read(authControllerProvider.notifier).register(
                              firstName: firstNameController.text.trim(),
                              lastName: lastNameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim()
                          );
                        }
                      },
                      child: authState.isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppColors.secondaryWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
