import 'package:flutter/material.dart';
import 'package:my_chat_app/pages/auth/login_page.dart';
import 'package:my_chat_app/pages/home_page.dart';
import 'package:my_chat_app/service/auth_service.dart';

import '../widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  ProfilePage({required this.userName, required this.email, Key? key})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            // Icon(
            //   Icons.account_circle,
            //   size: 150,
            //   color: Colors.grey[700],
            // ),
            DrawerHeader(
              child: CircleAvatar(
                radius: 30, // specify desired radius of the circular image
                backgroundImage: AssetImage(widget.userName == 'Jenny'
                        ? 'assets/maya.jpeg' // Set the profile picture asset path for 'Jenny'
                        : widget.userName == 'Ben'
                            ? 'assets/phoenixsm.jpeg' // Set the profile picture asset path for 'Ben'
                            : 'assets/${widget.userName.toLowerCase()}.jpeg'
                    // Set the profile picture asset path based on widget.userName for other values
                    ),
                backgroundColor: Colors.grey[700],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () async {
                nextScreen(context, const HomePage());
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: false,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {},
              selectedColor: Theme.of(context).primaryColor,
              selected: false,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.event),
              title: const Text(
                "Canlendar",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {},
              selectedColor: Theme.of(context).primaryColor,
              selected: false,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.celebration),
              title: const Text(
                "Events",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.account_circle),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: false,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.auto_awesome),
              title: const Text(
                "Party Tips",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {},
              selectedColor: Theme.of(context).primaryColor,
              selected: false,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.help),
              title: const Text(
                "Help & Support",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content:
                            const Text("Are you sure you want to log out?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.grey[700],
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authService.signOut();
                              nextScreenReplace(context, const LoginPage());
                              // Navigator.of(context).pushAndRemoveUntil(
                              //     MaterialPageRoute(
                              //         builder: (context) => const LoginPage()),
                              //     (route) => false);
                            },
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                          )
                        ],
                      );
                    });

                // authService.signOut().whenComplete(() {
                //   nextScreenReplace(context, const LoginPage());
                // });
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: false,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Log Out",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Icon(
            //   Icons.account_circle,
            //   size: 200,
            //   color: Colors.grey[700],
            // ),
            ClipOval(
              child: Image.asset(
                widget.userName == 'Jenny'
                    ? 'assets/maya.jpeg' // Set the profile picture asset path for 'Jenny'
                    : widget.userName == 'Ben'
                        ? 'assets/phoenix.jpeg' // Set the profile picture asset path for 'Ben'
                        : 'assets/${widget.userName.toLowerCase()}.jpeg', // Set the profile picture asset path based on widget.userName for other values
                width: 200, // specify desired width of the circular image
                height: 200, // specify desired height of the circular image
                fit: BoxFit
                    .cover, // specify the fit of the image within the circular shape
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // You can specify a custom error widget here in case the image fails to load
                  return Icon(
                    Icons.account_circle,
                    size: 200,
                    color: Colors.grey[700],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Name", style: TextStyle(fontSize: 17)),
                Text(widget.userName, style: const TextStyle(fontSize: 17)),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email", style: TextStyle(fontSize: 17)),
                Text(widget.email, style: const TextStyle(fontSize: 17)),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your button click logic here
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    // Set the color based on the button's state
                    if (states.contains(MaterialState.pressed)) {
                      // Set the color for pressed state
                      return Theme.of(context).primaryColor.withOpacity(0.5);
                    }
                    // Set the default color
                    return Theme.of(context).primaryColor;
                  },
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(double.infinity,
                      50), // Set the width of the button to fill the parent container horizontally
                ),
              ),
              child: const Text(
                'Edit My Profile',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ), // Set the text for the button
            ),
          ],
        ),
      ),
    );
  }
}
