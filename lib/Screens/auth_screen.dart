import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../Exception/http_exception.dart';
import 'package:toast/toast.dart';
import '../provider/auth.dart';

import '../Widgets/signIn_image_slider.dart';
import 'home_screen.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SizedBox(
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: SignInImageSlider()),
              SingleChildScrollView(
                child: SizedBox(
                  height: deviceSize.height,
                  width: deviceSize.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 50),
                          transform: Matrix4.rotationZ(-8 * pi / 180)
                            ..translate(-10.0),
                          // ..translate(-10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black.withOpacity(.30),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8,
                                color: Colors.black.withOpacity(.10),
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Text(
                            'SHOPZ',
                            style: TextStyle(
                                color: Colors.white.withOpacity(.85),
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: deviceSize.width > 600 ? 2 : 1,
                        child: const AuthCard(),
                      ),
                      const Text(
                        'Shop with ease:\n Your ultimate shopping destination',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  bool isForgotPass = false;

  final forgotPassControler = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  late AnimationController _animationController;

  late Animation<Offset> _slidAnimation;

  late Animation<double> _opacityAnimation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _slidAnimation =
        Tween<Offset>(begin: const Offset(0, -1.5), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _animationController, curve: Curves.fastOutSlowIn));

    // _hieghtAnimation.addListener(() => setState(() {}));

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
  }

  void _errorSnackbar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // Log user in

        await Provider.of<Auth>(context, listen: false)
            .signIn(_authData['email']!, _authData['password']!)
            .then((value) => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen())));
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email']!, _authData['password']!)
            .then((value) => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen())));
      }
    } on HttpExceptions catch (error) {
      var errorMessage = 'Authentication faild,please try again !';

      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email adress.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This is password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'The email address not found';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _errorSnackbar(errorMessage);
    } catch (error) {
      var errorMessage = 'Something wrong,try again!';
      _errorSnackbar(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _animationController.reverse();
    }
  }

  _forgotPassword(BuildContext ctx) async {
    final auth = Provider.of<Auth>(ctx, listen: false);
    setState(() => _isLoading = true);

    final _response = await auth
        .forgotPassword(
      forgotPassControler.text.trim(),
    )
        .then((_) {
      setState(() {
        _isLoading = false;
        isForgotPass = false;
      });
    });
    Toast.show(_response);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 340 : 300,

        // height: _hieghtAnimation.value.height,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Signup ? 320 : 270,
        ),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: isForgotPass
            ?
            //forgot password formfield
            Column(
                children: [
                  Text(
                    'Forgot Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Please enter your email address.We will send you an link to your email.Please check your email and click the link for  Rest your passsword!',
                    textAlign: TextAlign.center,
                  ),
                  TextFormField(
                    controller: forgotPassControler,
                    decoration: const InputDecoration(
                        hintText: 'Enter your email address'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () => _forgotPassword(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.email_outlined,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Send Email',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white),
                            )
                          ]),
                    ),
                  )
                ],
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'E-Mail'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['email'] = value!.trim();
                        },
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 5) {
                            return 'Password is too short!';
                          }
                        },
                        onSaved: (value) {
                          _authData['password'] = value!;
                        },
                      ),
                      // if (_authMode == AuthMode.Signup)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        constraints: BoxConstraints(
                          minHeight: _authMode == AuthMode.Signup ? 70 : 0,
                          maxHeight: _authMode == AuthMode.Signup ? 130 : 0,
                        ),
                        curve: Curves.easeIn,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: SlideTransition(
                            position: _slidAnimation,
                            child: TextFormField(
                              enabled: _authMode == AuthMode.Signup,
                              decoration: const InputDecoration(
                                  labelText: 'Confirm Password'),
                              obscureText: true,
                              validator: _authMode == AuthMode.Signup
                                  ? (value) {
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match!';
                                      }
                                    }
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (_isLoading)
                        LoadingAnimationWidget.hexagonDots(
                          color: Colors.black87,
                          size: 40,
                        )
                      else
                        Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              color: Colors.black.withOpacity(.85)),
                          child: InkWell(
                              onTap: () => _submit(),
                              child: Center(
                                child: Text(
                                  _authMode == AuthMode.Login
                                      ? 'LOGIN'
                                      : 'SIGN UP',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(.90),
                                      letterSpacing: 1),
                                ),
                              )),
                        ),

                      //forgot password section
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isForgotPass = true;
                          });
                        },
                        child: const Text('Forgot password'),
                      ),

                      TextButton(
                        onPressed: _switchAuthMode,
                        child: Text(
                          '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} ',
                          style: TextStyle(
                              color: Colors.black.withOpacity(.85),
                              letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
