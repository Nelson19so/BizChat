import 'package:bizchat_frontend/core/theme.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    bool isChecked = false;

    return MaterialApp(
      home: Scaffold(
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
                              decoration: InputDecoration(
                                labelText: 'First Name',
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
                    onPressed: () => print('hello Register button pressed'),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: AppColors.secondaryWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
