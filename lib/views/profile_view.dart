import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_view_model.dart';
import '../widgets/theme_button_large.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/navigation.dart';
import '../services/navigation_service.dart';

class ProfileView extends StatelessWidget {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

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
          title: Text('Profile'),
        ),
        body: Consumer<ProfileViewModel>(
          builder: (context, model, child) {
            if (model.user == null) {
              return Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/login_icon.png'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    model.user!.nickname,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    model.user!.email,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  SwitchListTile(
                    title: Text('Receive Inbox Message'),
                    value: model.receiveInboxMessage,
                    onChanged: (value) {
                      model.toggleReceiveInboxMessage(value);
                    },
                  ),
                  Spacer(),
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
        bottomNavigationBar: Consumer<ProfileViewModel>(
          builder: (context, model, child) {
            return Navigation(
              currentIndex: model.currentIndex,
              onTap: (index) {
                model.changeTab(index);
                // 这里可以添加导航逻辑，例如：
                NavigationService.navigateToPage(context, index);
              },
            );
          },
        ),
      ),
    );
  }
}
