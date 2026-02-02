import 'package:bizchat_frontend/core/theme.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Email or Phone Number',
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
                    ],
                  ),
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
                        onPressed: () => print('hello Login button pressed'),
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: AppColors.secondaryWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    SizedBox(
                      child: TextButton(
                        onPressed: () {
                          print('hello Forgot password pressed');
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
      ),
    );
  }
}
