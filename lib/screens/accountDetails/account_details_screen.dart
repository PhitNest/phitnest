import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:display/display_utils.dart';
import 'package:validation/validation_utils.dart';

import '../../models/models.dart';
import '../screen_utils.dart';
import 'provider/account_details_provider.dart';

class AccountDetailsScreen extends StatefulWidget {
  final UserModel user;

  AccountDetailsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _AccountDetailsScreenState createState() {
    return _AccountDetailsScreenState();
  }
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  Color _getBackgroundColor(BuildContext context) =>
      DisplayUtils.isDarkMode ? Colors.black : Colors.white;

  Color _getForegroundColor(BuildContext context) =>
      DisplayUtils.isDarkMode ? Colors.white : Colors.black;

  @override
  Widget build(BuildContext context) {
    return AccountDetailsProvider(
        builder: (context, user, model, functions, child) => Scaffold(
            appBar: AppBar(
              backgroundColor: _getBackgroundColor(context),
              systemOverlayStyle: DisplayUtils.isDarkMode
                  ? SystemUiOverlayStyle.dark
                  : SystemUiOverlayStyle.light,
              centerTitle: true,
              iconTheme: IconThemeData(color: _getForegroundColor(context)),
              title: Text(
                'Account Details'.tr(),
                style: TextStyle(color: _getForegroundColor(context)),
              ),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: model.key,
                autovalidateMode: model.validate,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, bottom: 8, top: 24),
                        child: Text(
                          'PUBLIC INFO'.tr(),
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                      Material(
                          elevation: 2,
                          color: DisplayUtils.isDarkMode
                              ? Colors.black12
                              : Colors.white,
                          child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: ListTile
                                  .divideTiles(context: context, tiles: [
                                ListTile(
                                  title: Text(
                                    'First Name'.tr(),
                                    style: TextStyle(
                                      color: _getForegroundColor(context),
                                    ),
                                  ),
                                  trailing: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 100),
                                    child: TextFormField(
                                      onSaved: (String? val) {
                                        model.firstName = val;
                                      },
                                      validator: ValidationUtils.validateName,
                                      textInputAction: TextInputAction.next,
                                      textAlign: TextAlign.end,
                                      initialValue: user.firstName,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: _getForegroundColor(context)),
                                      cursorColor: Color(COLOR_ACCENT),
                                      textCapitalization:
                                          TextCapitalization.words,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'First name'.tr(),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5)),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Last Name'.tr(),
                                    style: TextStyle(
                                        color: _getForegroundColor(context)),
                                  ),
                                  trailing: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 100),
                                    child: TextFormField(
                                      onSaved: (String? val) {
                                        model.lastName = val;
                                      },
                                      validator: ValidationUtils.validateName,
                                      textInputAction: TextInputAction.next,
                                      textAlign: TextAlign.end,
                                      initialValue: user.lastName,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: _getForegroundColor(context)),
                                      cursorColor: Color(COLOR_ACCENT),
                                      textCapitalization:
                                          TextCapitalization.words,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Last name'.tr(),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5)),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Age'.tr(),
                                    style: TextStyle(
                                        color: _getForegroundColor(context)),
                                  ),
                                  trailing: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 100),
                                    child: TextFormField(
                                      onSaved: (String? val) {
                                        model.age = val;
                                      },
                                      textInputAction: TextInputAction.next,
                                      textAlign: TextAlign.end,
                                      initialValue: user.age,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: _getForegroundColor(context)),
                                      cursorColor: Color(COLOR_ACCENT),
                                      textCapitalization:
                                          TextCapitalization.words,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Age'.tr(),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5)),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Bio'.tr(),
                                    style: TextStyle(
                                        color: _getForegroundColor(context)),
                                  ),
                                  trailing: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                .5),
                                    child: TextFormField(
                                      onSaved: (String? val) {
                                        model.bio = val;
                                      },
                                      textInputAction: TextInputAction.next,
                                      initialValue: user.bio,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: _getForegroundColor(context)),
                                      cursorColor: Color(COLOR_ACCENT),
                                      textCapitalization:
                                          TextCapitalization.words,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Bio'.tr(),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5)),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'School'.tr(),
                                    style: TextStyle(
                                        color: _getForegroundColor(context)),
                                  ),
                                  trailing: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 100),
                                    child: TextFormField(
                                      onSaved: (String? val) {
                                        model.school = val;
                                      },
                                      textAlign: TextAlign.end,
                                      textInputAction: TextInputAction.next,
                                      initialValue: user.school,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: _getForegroundColor(context)),
                                      cursorColor: Color(COLOR_ACCENT),
                                      textCapitalization:
                                          TextCapitalization.words,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'School'.tr(),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5)),
                                    ),
                                  ),
                                ),
                              ]).toList())),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, bottom: 8, top: 24),
                        child: Text(
                          'PRIVATE DETAILS'.tr(),
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                      Material(
                        elevation: 2,
                        color: DisplayUtils.isDarkMode
                            ? Colors.black12
                            : Colors.white,
                        child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: ListTile.divideTiles(
                              context: context,
                              tiles: [
                                ListTile(
                                  title: Text(
                                    'Email Address'.tr(),
                                    style: TextStyle(
                                        color: _getForegroundColor(context)),
                                  ),
                                  trailing: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 200),
                                    child: TextFormField(
                                      onSaved: (String? val) {
                                        model.email = val;
                                      },
                                      validator: ValidationUtils.validateEmail,
                                      textInputAction: TextInputAction.next,
                                      initialValue: user.email,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: _getForegroundColor(context)),
                                      cursorColor: Color(COLOR_ACCENT),
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Email Address'.tr(),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5)),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Phone Number'.tr(),
                                    style: TextStyle(
                                        color: _getForegroundColor(context)),
                                  ),
                                  trailing: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 150),
                                    child: TextFormField(
                                      onSaved: (String? val) {
                                        model.mobile = val;
                                      },
                                      validator: ValidationUtils.validateMobile,
                                      textInputAction: TextInputAction.done,
                                      initialValue: user.phoneNumber,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: _getForegroundColor(context)),
                                      cursorColor: Color(COLOR_ACCENT),
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Phone Number'.tr(),
                                          contentPadding:
                                              EdgeInsets.only(bottom: 2)),
                                    ),
                                  ),
                                ),
                              ],
                            ).toList()),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 32.0, bottom: 16),
                          child: ConstrainedBox(
                            constraints:
                                const BoxConstraints(minWidth: double.infinity),
                            child: Material(
                              elevation: 2,
                              color: DisplayUtils.isDarkMode
                                  ? Colors.black12
                                  : Colors.white,
                              child: CupertinoButton(
                                padding: const EdgeInsets.all(12.0),
                                onPressed: () async {
                                  functions.validateAndSave();
                                },
                                child: Text(
                                  'Save'.tr(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(COLOR_PRIMARY)),
                                ),
                              ),
                            ),
                          )),
                    ]),
              ),
            )));
  }
}
