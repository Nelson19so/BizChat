import 'package:bizchat_frontend/core/theme.dart';
import 'package:bizchat_frontend/services/authService.dart';
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
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              errorText: firstNameError,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.secondaryGray4,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.secondaryGray4,
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
                                color: AppColors.secondaryGray5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: TextField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Second Name',
                              errorText: lastNameError,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.secondaryGray4,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.secondaryGray4,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              fillColor: AppColors.secondaryGray3,
                              filled: true,
                              labelStyle: TextStyle(
                                color: AppColors.secondaryGray5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    Container(
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email or Phone Number',
                          errorText: emailError,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.secondaryGray4,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.secondaryGray4,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          fillColor: AppColors.secondaryGray3,
                          filled: true,
                          labelStyle: TextStyle(
                            color: AppColors.secondaryGray5,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

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
                              controller: passwordController,
                              decoration: InputDecoration(
                                errorText: passwordError,
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

                          Container(
                            child: TextButton(
                              onPressed: () {
                                print('Hello show pwd');
                              },
                              child: Text(
                                'Show',
                                style: TextStyle(
                                  fontSize: 19,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: Checkbox(
                            activeColor: AppColors.secondaryGray3,
                            checkColor: AppColors.primaryColor,
                            // shape: CircleBorder(),
                            side: BorderSide(
                              color: AppColors.secondaryGray4,
                              width: 2,
                            ),
                            // Use fillColor to control the background independently of the border
                            fillColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors
                                    .secondaryGray3; // Color when checked
                              }
                            }),
                            value: isChecked,
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                isChecked = value;
                              });
                            },
                          ),
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
              ),

              Builder(
                builder: (scaffoldContext) {
                  return SizedBox(
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
}
