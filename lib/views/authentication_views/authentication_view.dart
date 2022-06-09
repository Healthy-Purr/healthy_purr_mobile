import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';

class GoToPage {
  static const int home = 0;
  static const int login = 1;
  static const int forgotPassword = 2;
}

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({Key? key}) : super(key: key);

  @override
  _AuthenticationViewState createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {

  final PageController _pageController = PageController(initialPage: GoToPage.home);

  void _switchPage(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: screenSize.height * 0.07,
              child: Image.asset(
                  'assets/images/ellipse.png',
                  height: screenSize.height * 0.6,
                  width: screenSize.width,
                  fit: BoxFit.fill
              ),
            ),
            Positioned(
              top: screenSize.height * 0.10,
              child: SizedBox(
                height: screenSize.height,
                width: screenSize.width,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Image.asset(
                      'assets/images/splash.png',
                      height: 105,
                      width: 105,
                    ),
                    SizedBox(
                      height: screenSize.height * 0.7,
                      width: screenSize.width,
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        children: [
                          SizedBox(
                            height: screenSize.height * 0.1,
                            width: screenSize.width,
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/cat_1.png',
                                  height: screenSize.height * 0.45,
                                  alignment: Alignment.centerLeft,
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                GoToLoginButton(
                                  goToLoginForm: () {
                                    _switchPage(GoToPage.login);
                                  }
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                const RegisterButton(),
                              ],
                            ),
                          ),
                          LoginView(
                            goToHomeView: () {
                              _switchPage(GoToPage.home);
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
