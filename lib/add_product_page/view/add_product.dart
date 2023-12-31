import 'package:ecommerce/add_product_page/repo/add_product_repo.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:ecommerce/dashboard_page/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatelessWidget {
  AddProductPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productDetailsController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productStockController = TextEditingController();

  List<XFile>? productImages;

  //Picking Image From Device Storage
  Future<dynamic> pickImage() async {
    final imagePicker = ImagePicker();
    productImages = await imagePicker.pickMultiImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add A Product'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              heightSpacer(20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  heightSpacer(20),
                  TextFormField(
                    controller: _productNameController,
                    decoration: const InputDecoration(
                      hintText: 'Product Name',
                    ),
                  ),
                  TextFormField(
                    maxLines: 2,
                    controller: _productDetailsController,
                    decoration: const InputDecoration(
                      hintText: 'ProductDetails',
                    ),
                  ),
                  TextFormField(
                    controller: _productPriceController,
                    decoration: const InputDecoration(
                      hintText: 'Price',
                    ),
                  ),
                  TextFormField(
                    controller: _productStockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Initial Stock',
                    ),
                  ),
                  heightSpacer(10),
                  TextButton(
                    onPressed: pickImage,
                    child: const Text(
                      'Upload Image',
                      style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // heightSpacer(10),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        //
                        await AddProductRepo().addProduct(
                          _productNameController.text,
                          _productDetailsController.text,
                          _productPriceController.text,
                          _productStockController.text,
                          productImages!,
                        );
                        // clearing fields on submit
                        _productNameController.clear();
                        _productDetailsController.clear();
                        _productPriceController.clear();
                        _productStockController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.green, content: Text('Product Added!')));
                      }
                    },
                    child: const Text('Add Product'),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
