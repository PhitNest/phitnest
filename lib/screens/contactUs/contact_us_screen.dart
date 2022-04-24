import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app.dart';

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
          color: DisplayUtils.isDarkMode ? Colors.black : Colors.white,
        ),
      ),
      appBar: AppBar(
        systemOverlayStyle: DisplayUtils.isDarkMode
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        backgroundColor: DisplayUtils.isDarkMode ? Colors.black : Colors.white,
        iconTheme: IconThemeData(
            color: DisplayUtils.isDarkMode ? Colors.white : Colors.black),
        title: Text(
          'Contact Us'.tr(),
          style: TextStyle(
              color: DisplayUtils.isDarkMode ? Colors.white : Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(children: <Widget>[
        Material(
            elevation: 2,
            color: DisplayUtils.isDarkMode ? Colors.black12 : Colors.white,
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
                          color: DisplayUtils.isDarkMode
                              ? Colors.white
                              : Colors.black,
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
                        DialogUtils.showAlertDialog(
                            context,
                            'Couldn\'t send email'.tr(),
                            'There is no mailing app installed'.tr());
                      }
                    },
                    title: Text(
                      'E-mail us'.tr(),
                      style: TextStyle(
                          color: DisplayUtils.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('support@instamobile.zendesk.com'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: DisplayUtils.isDarkMode
                          ? Colors.white54
                          : Colors.black54,
                    ),
                  )
                ]))
      ]),
    );
  }
}
