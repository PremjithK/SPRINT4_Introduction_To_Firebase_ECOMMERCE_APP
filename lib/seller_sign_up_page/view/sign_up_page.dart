import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:ecommerce/seller_login_page/view/seller_login_page.dart';
import 'package:ecommerce/seller_sign_up_page/repo/signup_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerSignupPage extends StatelessWidget {
  SellerSignupPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Row(
        children: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back'),
          ),
          heightSpacer(10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              heightSpacer(1),
              Column(
                children: [
                  mainHeading('Become A Seller'),
                  heightSpacer(10),
                  TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter an Username';
                      }
                    },
                    decoration: const InputDecoration(hintText: 'Merchant Name'),
                  ),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter an Email';
                      }
                    },
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                  TextFormField(
                    controller: _phoneController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a Phone Number';
                      }
                    },
                    decoration: const InputDecoration(hintText: 'Phone No.'),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter an Password';
                      }
                    },
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(SellerLoginPage());
                      },
                      child: const Text('Already Have An Account? Click Here')),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (await checkIfEmailExists(_emailController.text, 'SellerCollection')) {
                          await SellerSignupRepo().createUser(
                            _usernameController.text,
                            _emailController.text,
                            _phoneController.text,
                            _passwordController.text,
                          );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => SellerLoginPage(),
                          //   ),
                          // );

                          await Get.to(SellerLoginPage());
                        } else {
                          print('Seller with this email already exists');
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('User with this email already exists'),
                            backgroundColor: Colors.red,
                          ));
                        }
                      }
                    },
                    child: const Text('Create Account'),
                  )
                ],
              ),
              heightSpacer(10),
            ],
          ),
        ),
      ),
    );
  }
}

//
Future<bool> checkIfEmailExists(String email, String collectionName) async {
  final result = await FirebaseFirestore.instance
      .collection(collectionName)
      .where('email', isEqualTo: email)
      .get();

  return !result.docs.isNotEmpty;
}
