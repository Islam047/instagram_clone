import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/service/service_locator.dart';
import 'package:instagram_clone/core/util/utility.dart';
import 'package:instagram_clone/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/pages/views/sign_in_view.dart';
import 'package:instagram_clone/features/post/presentation/pages/home_page.dart';
import 'signup_page.dart';

class SignInPage extends StatelessWidget {
   SignInPage({Key? key}) : super(key: key);
  static const String id = "signin_page";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthBloc bloc = locator<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF833AB4),
                      Color(0xFFC13584),
                    ],
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // #app_name
                          const Text(
                            "Instagram",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontFamily: "Billabong"),
                          ),
                          const SizedBox(height: 20),

                          // #email
                          TextFieldSignIn(
                              hintText: "Email", controller: emailController),
                          const SizedBox(height: 10),

                          // #password
                          TextFieldSignIn(
                              hintText: "Password",
                              controller: passwordController),
                          const SizedBox(height: 10),

                          // #signin
                          ButtonSignIn(
                              title: "Sign In",
                              onPressed: () {
                                bloc.add(SignInUserEvent(
                                    email: emailController.text,
                                    password: passwordController.text));
                              }),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, SignUpPage.id);
                                },
                            )
                          ]),
                    )
                  ],
                ),
              ),
            ),
            BlocConsumer<AuthBloc, AuthOverviewState>(
              listener: (context, state) {
                if (state.status == AuthOverviewStatus.success) {
                  Utils.fireSnackBar("Successfully Sign In", context);
                  Navigator.pushReplacementNamed(context, HomePage.id);
                }
                if(state.status == AuthOverviewStatus.failure){
                  Utils.fireSnackBar(state.error!, context);
                }
              },

              builder: (context, state) {
                if (state.status == AuthOverviewStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
