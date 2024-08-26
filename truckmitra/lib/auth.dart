// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:truckmitra/home.dart';
// import 'package:supabase_auth_ui/supabase_auth_ui.dart';
//
// class LoginScreen extends StatelessWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login' , style: TextStyle(color: Colors.black),),
//         backgroundColor: Colors.yellow[700],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(8.0,100.0,8.0,8.0),
//               child: Center(
//                 child: // Create a Email sign-in/sign-up form
//                 SupaEmailAuth(
//
//                   redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
//                   onSignInComplete: (response) {
//                     // do something, for example: navigate('home');
//                     Navigator.pushReplacement(context,
//                         MaterialPageRoute(builder: (context) => const HomeScreen()));
//
//
//                   },
//                   onSignUpComplete: (response) {
//                     // do something, for example: navigate("wait_for_email");
//                     Navigator.pushReplacement(context,
//                       MaterialPageRoute(builder: (context) => const HomeScreen()));
//                   },
//                   metadataFields: [
//                     MetaDataField(
//                       prefixIcon: const Icon(Icons.person),
//                       label: 'Username',
//                       key: 'username',
//                       validator: (val) {
//                         if (val == null || val.isEmpty) {
//                           return 'Please enter something';
//                         }
//
//                         return null;
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:truckmitra/home.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Truck Mitra',style: TextStyle(fontFamily: 'SAMAN___'),),
        backgroundColor: Colors.yellow[700],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Add the image at the top
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(
                        'assets/1.png', // Update the path to your image
                        height: 200.0, // Adjust the height as needed
                      ),
                    ),
                    SizedBox(height: 20.0), // Add some space between the image and the email auth form
                    Center(
                      child: SupaEmailAuth(
                        redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
                        onSignInComplete: (response) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        },
                        onSignUpComplete: (response) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        },
                        metadataFields: [
                          MetaDataField(
                            prefixIcon: const Icon(Icons.person),
                            label: 'Username',
                            key: 'username',
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter something';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}