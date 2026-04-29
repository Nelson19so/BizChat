import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:bizchat_frontend/services/authService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final authservice = Authservice();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  String? firstNameError;
  String? lastNameError;
  String? emailError;
  String? passwordError;

  bool isLoading = false;
  bool isChecked = false;

  Future<void> handleRegister() async {
    setState(() {
      isLoading = true;
      emailError = null;
      firstNameError = null;
      lastNameError = null;
      passwordError = null;
    });

    if (kDebugMode) {
      print('Attempting registration with:');
      print('First Name: ${firstNameController.text}');
      print('Last Name: ${lastNameController.text}');
      print('Email: ${emailController.text}');
      print('Password: ${passwordController.text}');
    }

    final result = await authservice.register(
      first_name: firstNameController.text.trim(),
      last_name: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    final statusCode = result['statusCode'];
    final data = result['data'];

    if (statusCode == 201) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data["message"])));

      // Navigate to chat/home screen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      /// DISPLAY FIELD ERRORS
      setState(() {
        emailError = data["email"]?.join(", ");
        firstNameError = data["first_name"]?.join(", ");
        lastNameError = data["last_name"]?.join(", ");
        passwordError = data["password"]?.join(", ");
        print(data);
      });
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            TextField(
                              controller: firstNameController,
                              onChanged: (value) {
                                setState(() {
                                  firstNameError = null;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                labelStyle: TextStyle(
                                  color: firstNameError != null
                                      ? Colors.red
                                      : AppColors.secondaryGray5,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    // Toggle color: Red if there is an error, otherwise gray
                                    color: firstNameError != null
                                        ? Colors.red
                                        : AppColors.secondaryGray4,
                                    width: firstNameError != null
                                        ? 1.0
                                        : 1.0, // Optional: make it thicker on error
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: firstNameError != null
                                        ? Colors.red
                                        : AppColors.secondaryGray4,
                                    width: firstNameError != null ? 1.0 : 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                fillColor: WidgetStateColor.resolveWith((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.focused)) {
                                    return AppColors.secondaryGray3;
                                  }
                                  return AppColors.secondaryGray3;
                                }),
                                filled: true,
                              ),
                            ),

                            _buildErrorMessage(firstNameError),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: lastNameController,
                              onChanged: (value) {
                                setState(() {
                                  lastNameError = null;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    // Toggle color: Red if there is an error, otherwise gray
                                    color: lastNameError != null
                                        ? Colors.red
                                        : AppColors.secondaryGray4,
                                    width: lastNameError != null
                                        ? 1.0
                                        : 1.0, // Optional: make it thicker on error
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: lastNameError != null
                                        ? Colors.red
                                        : AppColors.secondaryGray4,
                                    width: lastNameError != null ? 1.0 : 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                fillColor: WidgetStateColor.resolveWith((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.focused)) {
                                    return AppColors.secondaryGray3;
                                  }
                                  return AppColors.secondaryGray3;
                                }),
                                filled: true,
                                labelStyle: TextStyle(
                                  color: lastNameError != null
                                      ? Colors.red
                                      : AppColors.secondaryGray5,
                                ),
                              ),
                            ),

                            _buildErrorMessage(lastNameError),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: emailController,
                        onChanged: (value) {
                          setState(() {
                            emailError = null;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              // Toggle color: Red if there is an error, otherwise gray
                              color: emailError != null
                                  ? Colors.red
                                  : AppColors.secondaryGray4,
                              width: emailError != null
                                  ? 1.0
                                  : 1.0, // Optional: make it thicker on error
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: emailError != null
                                  ? Colors.red
                                  : AppColors.secondaryGray4,
                              width: emailError != null ? 1.0 : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          fillColor: WidgetStateColor.resolveWith((states) {
                            if (states.contains(WidgetState.focused)) {
                              return AppColors.secondaryGray3;
                            }
                            return AppColors.secondaryGray3;
                          }),
                          filled: true,
                          labelStyle: TextStyle(
                            color: emailError != null
                                ? Colors.red
                                : AppColors.secondaryGray5,
                          ),
                        ),
                      ),

                      _buildErrorMessage(emailError),
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
                                onChanged: (value) {
                                  setState(() {
                                    passwordError = null;
                                  });
                                },
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

                      _buildErrorMessage(passwordError),
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
                      onPressed: () {
                        if (!isChecked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please agree to receive newsletters to proceed.',
                              ),
                            ),
                          );
                          return;
                        }
                        handleRegister();
                      },
                      child: isLoading
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

  Widget _buildErrorMessage(String? error) {
    if (error == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 8),
      child: Text(
        '*$error',
        style: TextStyle(
          color: Colors.red, // Your custom color
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
