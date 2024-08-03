import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_view_model.dart';
import '../widgets/theme_button_large.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileView extends StatelessWidget {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  const ProfileView({super.key});

  Future<void> _signOut(BuildContext context) async {
    // 清除存储的token
    await _storage.delete(key: 'token');
    // 导航回登录页面
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Consumer<ProfileViewModel>(
          builder: (context, model, child) {
            if (model.user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/login_icon.png'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    model.user!.nickname,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    model.user!.email,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Receive Inbox Message'),
                    value: model.receiveInboxMessage,
                    onChanged: (value) {
                      model.toggleReceiveInboxMessage(value);
                    },
                  ),
                  const Spacer(),
                  ThemeButtonLarge(
                    text: 'Sign Out',
                    onPressed: () async {
                      await _signOut(context);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
