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
    bool isChecked = false;

    return MaterialApp(
      home: Scaffold(
        // backgroundColor: AppColors.secondaryWhite,
        appBar: AppBar(
          title: const Text('SignUp'),
          titleTextStyle: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryBlack,
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                print('hello');
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
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                enabledBorder: OutlineInputBorder(
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

                          const SizedBox(width: 12),

                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Second Name',
                                enabledBorder: OutlineInputBorder(
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
                          decoration: InputDecoration(
                            labelText: 'Email or Phone Number',
                            enabledBorder: OutlineInputBorder(
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
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Password',
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
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                  print(isChecked);
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
                    onPressed: () => print('hello world'),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: AppColors.secondaryWhite,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
