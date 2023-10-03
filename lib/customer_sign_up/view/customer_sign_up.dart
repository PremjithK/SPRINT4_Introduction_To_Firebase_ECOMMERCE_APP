import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:ecommerce/customer_login_page/view/login_page.dart';
import 'package:ecommerce/customer_sign_up/repo/signup_repo.dart';
import 'package:ecommerce/launch_page/view/launch_page.dart';
import 'package:ecommerce/seller_login_page/view/seller_login_page.dart';
import 'package:ecommerce/seller_sign_up_page/repo/signup_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerSignupPage extends StatelessWidget {
  CustomerSignupPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  heightSpacer(70),
                  mainHeading('Welcome, New Customer'),
                  heightSpacer(40),
                  TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter an Username';
                      }
                    },
                    decoration: InputDecoration(hintText: 'Username'),
                  ),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter an Email';
                      }
                    },
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                  TextFormField(
                    controller: _phoneController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a Phone Number';
                      }
                    },
                    decoration: InputDecoration(hintText: 'Phone No.'),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter an Password';
                      }
                    },
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(CustomerLoginPage());
                      },
                      child: Text('Already Have An Account? Click Here')),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (await checkIfEmailExists(_emailController.text, 'CustomerCollection')) {
                          await CustomerSignupRepo().createUser(
                            _usernameController.text,
                            _emailController.text,
                            _phoneController.text,
                            _passwordController.text,
                            context,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerLoginPage(),
                            ),
                          );
                        } else {
                          print('User with this email already exists');
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('User with this email already exists')));
                        }
                      }
                    },
                    child: const Text('Create Account'),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  Get.to(LaunchPage());
                },
                icon: Icon(Icons.arrow_back),
                label: Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> checkIfEmailExists(String email, String collectionName) async {
  final result = await FirebaseFirestore.instance
      .collection(collectionName)
      .where('email', isEqualTo: email)
      .get();

  return !result.docs.isNotEmpty;
}
