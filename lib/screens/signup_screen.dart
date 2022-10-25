import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../const/const.dart';
import '../resources/auth_methods.dart';
import '../utils/text_widget.dart';
import '../utils/utils.dart';
import '../widgets/login_bottom_container.dart';
import '../widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Uint8List? _image;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  //Heading
                  kHeight50,
                  const TitleWidget(title: 'React Messenger'),
                  kHeight25,
                  //profile image
                  Stack(
                    children: <Widget>[
                      if (_image != null)
                        CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: Colors.red,
                        )
                      else
                        GestureDetector(
                          onTap: () async {
                            _image = await pickImage(ImageSource.gallery);
                            setState(() {});
                          },
                          child: const CircleAvatar(
                            radius: 64,
                            backgroundImage:
                                AssetImage('assets/images/defaultProfile.jpg'),
                            backgroundColor: Colors.red,
                          ),
                        ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                  kHeight25,
                  //text field input for email
                  TextFieldInput(
                      textEditingController: _emailController,
                      hintText: 'Enter your Email',
                      textInputType: TextInputType.emailAddress),
                  kHeight25,
                  TextFieldInput(
                      textEditingController: _fullnameController,
                      hintText: 'Full Name',
                      textInputType: TextInputType.text),
                  kHeight25,
                  TextFieldInput(
                      textEditingController: _usernameController,
                      hintText: 'Username',
                      textInputType: TextInputType.text),
                  kHeight25,
                  //text field input for password
                  TextFieldInput(
                    textEditingController: _passwordController,
                    hintText: 'Enter your Password',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                  kHeight25,
                  //button login
                  ElevatedButton(
                    onPressed: () async {
                      final String res = await AuthMethods().signUpUser(
                        email: _emailController.text,
                        fullname: _passwordController.text,
                        username: _fullnameController.text,
                        password: _passwordController.text,
                        file: _image!,
                      );
                      print(res);
                    },
                    style: buttonStyle,
                    child: const Text('SignUp'),
                  ),
                  kHeight25,
                  //transition to signing up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      LoginBottomContainer(
                          title:
                              'By signing up, you agree to our Terms,\n Privacy Policy and Cookies Policy.'),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
