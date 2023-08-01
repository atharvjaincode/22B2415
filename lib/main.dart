

import 'object.dart';
import 'model.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

//void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ) return 'Please enter your email';
                  return null;
                },
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null ) return 'Please enter a password';
                  return null;
                },
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registerUser(context);
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerUser(BuildContext context) {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Perform null checks on email and password
    if (email.isEmpty || password.isEmpty) {
      print('Email and password cannot be empty.');
      return;
    }

    // Save the user data to Firebase Firestore
    FirebaseFirestore.instance.collection('users').add({
      'email': email,
      'password': password,
    }).then((docRef) {
      print('User data saved with ID: ${docRef.id}');
      // You can add any further logic here, like navigating to a different screen after registration.
    }).catchError((error) {
      print('Error saving user data: $error');
    });
  }
}







// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase Login',
//       home: LoginPage(),
//     );
//   }
// }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _loginWithEmailAndPassword(),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loginWithEmailAndPassword() async {
    try {
      final String username = _usernameController.text.trim();
      final String password = _passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        _showErrorDialog('Please enter both username and password.');
        return;
      }

      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      if (userCredential.user != null) {
        // Login successful, do something here
        //_showSuccessDialog('Login successful!');
        Navigator.push(context, MaterialPageRoute(builder: (context) => budget()));
      } else {
        _showErrorDialog('Invalid credentials. Please try again.');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog('An error occurred. Please try again later.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

//
// void main() {
//   runApp(MaterialApp(
//     home:budget(),
//   ));
// }
class budget extends StatefulWidget {
  const budget({super.key});

  @override
  State<budget> createState() => _budgetState();
}

class _budgetState extends State<budget> {
  int expense=26700;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budget Tracker',
        ),
        centerTitle: true,
        backgroundColor: Colors.purple[400],
      )
      ,body:Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Icon(Icons.person_3_rounded, size:50),
          ),
          SizedBox(height:30),
          Text(
            'Welcome Back !!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          SizedBox(height:20),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => budget()));
            },
            child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Expense  :',
                      style: TextStyle(
                        fontSize:20,
                      ),
                    ),
                    SizedBox(width:10),
                    Text(
                        '$expense',
                        style: TextStyle(
                          fontSize: 20,
                        )
                    ),
                    Icon(Icons.arrow_drop_down,size:30),

                  ],
                )
            ),
          ),
        ],
      ),
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.purpleAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}

class page2 extends StatefulWidget {
  const page2({super.key});

  @override
  State<page2> createState() => _page2State();
}

class _page2State extends State<page2> {
  String category='';
  late TextEditingController controller1;
  @override
  void initState() {
    super.initState();
    controller1 = TextEditingController();
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  @override
  Future openDialog() => showDialog(
      context: context,
      builder: (context)=>AlertDialog(
        title: Text( ' New Entry'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(hintText: 'Category'),
              controller: controller1,
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Amount'),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).pop(controller1);
                controller1.clear();
              },
              icon: Icon(Icons.add))
        ],
      ));
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budget Tracker',
        ),
        centerTitle: true,
        backgroundColor: Colors.purple[400],
      ),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.map((item)=>Text('${item.category} :  ${item.amount}')).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        child: Icon(Icons.add),
        onPressed: ()async{
          final category = await openDialog();
          setState(() {
            this.category = category as String;
          }
          );
        },
      ),   );
  }
}