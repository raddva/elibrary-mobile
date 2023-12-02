// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:elibrary/dashboard/appbar.dart';
import 'package:elibrary/modules/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          MyAppBar(btitle: "Profile"),
          ProfilePage(),
        ],
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Profile> profileData;
  TextEditingController userIdController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    profileData = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: profileData,
      builder: (context, AsyncSnapshot<Profile> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return SliverFillRemaining(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          Profile user = snapshot.data!;
          userIdController.text = user.idUser;
          usernameController.text = user.username!;
          nameController.text = user.name!;
          emailController.text = user.email!;
          passwordController.text = user.password!;
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Icon(
                        CupertinoIcons.person_alt_circle,
                        size: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: <Widget>[
                            makeInput(
                                label: "User ID",
                                controller: userIdController,
                                readOnly: false),
                            makeInput(
                                label: "Username",
                                controller: usernameController),
                            makeInput(
                                label: "Name", controller: nameController),
                            makeInput(
                                label: "E-mail", controller: emailController),
                            makeInput(
                                label: "Password",
                                obscureText: true,
                                controller: passwordController),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          padding: const EdgeInsets.only(left: 2, top: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: const Border(
                              bottom: BorderSide(color: Colors.white),
                              top: BorderSide(color: Colors.white),
                              left: BorderSide(color: Colors.white),
                              right: BorderSide(color: Colors.white),
                            ),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              saveUserData(
                                  userIdController,
                                  usernameController,
                                  nameController,
                                  emailController,
                                  passwordController,
                                  context);
                            },
                            height: 60,
                            minWidth: double.infinity,
                            color: Colors.deepPurpleAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.floppy_disk),
                                SizedBox(width: 5),
                                Text(
                                  "Save Data",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Manrope",
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: 1,
            ),
          );
        }
      },
    );
  }

  Widget makeInput(
      {label,
      obscureText = false,
      controller,
      readOnly = true,
      String? initialValue}) {
    TextEditingController textController =
        TextEditingController(text: initialValue);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          enabled: readOnly,
          obscureText: obscureText,
          style: const TextStyle(fontFamily: "Manrope"),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Future<void> saveUserData(
    TextEditingController userIdController,
    TextEditingController usernameController,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    BuildContext context,
  ) async {
    const String apiUrl =
        'https://cc52-2001-448a-50a0-9aef-45cc-735f-6459-dda9.ngrok-free.app/api/elibrary/update.php';
    final bool confirm = await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Confirm Update'),
          content:
              const Text('Are you sure you want to update your user data?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'id_user': userIdController.text,
            'username': usernameController.text,
            'name': nameController.text,
            'email': emailController.text,
            'password': passwordController.text,
          }),
        );
        // print(response.body);
        if (response.statusCode == 200) {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('Success'),
                content: const Text('User data updated successfully'),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('Error'),
                content:
                    Text('Error updating user data: ${response.statusCode}'),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print('Exception during API call: $e');
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Error'),
              content: const Text('Error updating user data'),
              actions: [
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
