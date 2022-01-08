import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String url = 'tel:12345678';
          launch(url);
        },
        backgroundColor: Color(COLOR_ACCENT),
        child: Icon(
          Icons.call,
          color: isDarkMode(context) ? Colors.black : Colors.white,
        ),
      ),
      appBar: AppBar(
        brightness: isDarkMode(context) ? Brightness.dark : Brightness.light,
        backgroundColor: isDarkMode(context) ? Colors.black : Colors.white,
        iconTheme: IconThemeData(
            color: isDarkMode(context) ? Colors.white : Colors.black),
        title: Text(
          'Contact Us'.tr(),
          style: TextStyle(
              color: isDarkMode(context) ? Colors.white : Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(children: <Widget>[
        Material(
            elevation: 2,
            color: isDarkMode(context) ? Colors.black12 : Colors.white,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 16.0, left: 16, top: 16),
                    child: Text(
                      'Our Address'.tr(),
                      style: TextStyle(
                          color:
                              isDarkMode(context) ? Colors.white : Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 16.0, left: 16, top: 16, bottom: 16),
                    child:
                        Text('1412 Steiner Street, San Francisco, CA, 94115'),
                  ),
                  ListTile(
                    onTap: () async {
                      var url =
                          'mailto:support@instamobile.zendesk.com?subject=Instaflutter-contact-ticket';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        showAlertDialog(context, 'Couldn\'t send email'.tr(),
                            'There is no mailing app installed'.tr());
                      }
                    },
                    title: Text(
                      'E-mail us'.tr(),
                      style: TextStyle(
                          color:
                              isDarkMode(context) ? Colors.white : Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('support@instamobile.zendesk.com'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color:
                          isDarkMode(context) ? Colors.white54 : Colors.black54,
                    ),
                  )
                ]))
      ]),
    );
  }
}
