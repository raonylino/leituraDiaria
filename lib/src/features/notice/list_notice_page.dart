import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:oceans/main.dart';

class ListNoticePage extends StatelessWidget {

  const ListNoticePage({ super.key });

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar:PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Stack(
          children: [
            Lottie.asset(
              'assets/animations/borderAnimation.json', 
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            AppBar(
              leading:Image.asset(
                 'assets/images/logo_ad.png',
              ),
              toolbarHeight: 80,
              backgroundColor: Colors.transparent,
              title: const Text(
                'Avisos Oceans',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                ),
              ),
              centerTitle: true,
            ),
          ],
        ),
      ),
                  bottomNavigationBar: ConvexAppBar(
          style: TabStyle.titled,
          backgroundColor: const Color.fromRGBO(21, 39, 65, 1),
          items: const [
            TabItem(icon: Icons.logout_outlined, title: 'Sair'),
            TabItem(icon: Icons.auto_stories_rounded, title: 'Leituras'),
            TabItem(icon: Icons.notifications_none_rounded, title: 'Avisos'),
          ],
          initialActiveIndex: 2,
          onTap: (int i) async {
            if (i == 0) {
              Dialogs.materialDialog(
                  msg: 'Tem certeza que deseja sair do sistema?',
                  title: 'Logout',
                  context: context,
                  // ignore: deprecated_member_use
                  actions: [
                    IconsButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popAndPushNamed('/contact/list');
                      },
                      text: 'Não',
                      iconData: Icons.close_rounded,
                      textStyle: const TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                      color: Colors.red,
                    ),
                    IconsButton(
                      onPressed: () async {
                        await supabase.auth.signOut();
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      text: 'Sim',
                      iconData: Icons.check_rounded,
                      color: Colors.green,
                      textStyle: const TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                    ),
                  ]);
            } else if (i == 1) {
              Navigator.of(context).popAndPushNamed('/contact/list');
            } else if (i == 2) {
              Navigator.of(context).popAndPushNamed('/notice/list');
            }
          }),
           body: Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Lottie.asset(
                   'assets/animations/construction.json', 
                   fit: BoxFit.cover,
                   width: 200,
                 ),
                 const Text('Em Construção',
                   style: TextStyle(
                     color: Color.fromARGB(255, 0, 0, 0),
                     fontSize: 20,
                     fontFamily: 'Poppins',
                   ),
                 )
               ],
             ),
           ),
       );
  }
}