import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/reauthScreen/reauth_user_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AccountDetailsScreen extends StatefulWidget {
  final User user;

  AccountDetailsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _AccountDetailsScreenState createState() {
    return _AccountDetailsScreenState();
  }
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  late User user;
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? firstName, lastName, age, bio, school, email, mobile;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode(context) ? Colors.black : Colors.white,
          brightness: isDarkMode(context) ? Brightness.dark : Brightness.light,
          centerTitle: true,
          iconTheme: IconThemeData(
              color: isDarkMode(context) ? Colors.white : Colors.black),
          title: Text(
            'Account Details'.tr(),
            style: TextStyle(
                color: isDarkMode(context) ? Colors.white : Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _key,
            autovalidateMode: _validate,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
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
                  color: isDarkMode(context) ? Colors.black12 : Colors.white,
                  child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: ListTile.divideTiles(context: context, tiles: [
                        ListTile(
                          title: Text(
                            'First Name'.tr(),
                            style: TextStyle(
                              color: isDarkMode(context)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          trailing: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 100),
                            child: TextFormField(
                              onSaved: (String? val) {
                                firstName = val;
                              },
                              validator: validateName,
                              textInputAction: TextInputAction.next,
                              textAlign: TextAlign.end,
                              initialValue: user.firstName,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: isDarkMode(context)
                                      ? Colors.white
                                      : Colors.black),
                              cursorColor: Color(COLOR_ACCENT),
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'First name'.tr(),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5)),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Last Name'.tr(),
                            style: TextStyle(
                                color: isDarkMode(context)
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          trailing: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 100),
                            child: TextFormField(
                              onSaved: (String? val) {
                                lastName = val;
                              },
                              validator: validateName,
                              textInputAction: TextInputAction.next,
                              textAlign: TextAlign.end,
                              initialValue: user.lastName,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: isDarkMode(context)
                                      ? Colors.white
                                      : Colors.black),
                              cursorColor: Color(COLOR_ACCENT),
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Last name'.tr(),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5)),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Age'.tr(),
                            style: TextStyle(
                                color: isDarkMode(context)
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          trailing: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 100),
                            child: TextFormField(
                              onSaved: (String? val) {
                                age = val;
                              },
                              textInputAction: TextInputAction.next,
                              textAlign: TextAlign.end,
                              initialValue: user.age,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: isDarkMode(context)
                                      ? Colors.white
                                      : Colors.black),
                              cursorColor: Color(COLOR_ACCENT),
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Age'.tr(),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5)),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Bio'.tr(),
                            style: TextStyle(
                                color: isDarkMode(context)
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          trailing: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * .5),
                            child: TextFormField(
                              onSaved: (String? val) {
                                bio = val;
                              },
                              initialValue: user.bio,
                              minLines: 1,
                              maxLines: 3,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: isDarkMode(context)
                                      ? Colors.white
                                      : Colors.black),
                              cursorColor: Color(COLOR_ACCENT),
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Bio'.tr(),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5)),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'School'.tr(),
                            style: TextStyle(
                                color: isDarkMode(context)
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          trailing: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 100),
                            child: TextFormField(
                              onSaved: (String? val) {
                                school = val;
                              },
                              textAlign: TextAlign.end,
                              textInputAction: TextInputAction.next,
                              initialValue: user.school,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: isDarkMode(context)
                                      ? Colors.white
                                      : Colors.black),
                              cursorColor: Color(COLOR_ACCENT),
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'School'.tr(),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5)),
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
                color: isDarkMode(context) ? Colors.black12 : Colors.white,
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
                                color: isDarkMode(context)
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          trailing: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: TextFormField(
                              onSaved: (String? val) {
                                email = val;
                              },
                              validator: validateEmail,
                              textInputAction: TextInputAction.next,
                              initialValue: user.email,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: isDarkMode(context)
                                      ? Colors.white
                                      : Colors.black),
                              cursorColor: Color(COLOR_ACCENT),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email Address'.tr(),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5)),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Phone Number'.tr(),
                            style: TextStyle(
                                color: isDarkMode(context)
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          trailing: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 150),
                            child: TextFormField(
                              onSaved: (String? val) {
                                mobile = val;
                              },
                              validator: validateMobile,
                              textInputAction: TextInputAction.done,
                              initialValue: user.phoneNumber,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: isDarkMode(context)
                                      ? Colors.white
                                      : Colors.black),
                              cursorColor: Color(COLOR_ACCENT),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Phone Number'.tr(),
                                  contentPadding: EdgeInsets.only(bottom: 2)),
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
                      color:
                          isDarkMode(context) ? Colors.black12 : Colors.white,
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(12.0),
                        onPressed: () async {
                          _validateAndSave();
                        },
                        child: Text(
                          'Save'.tr(),
                          style: TextStyle(
                              fontSize: 18, color: Color(COLOR_PRIMARY)),
                        ),
                      ),
                    ),
                  )),
            ]),
          ),
        ));
  }

  _validateAndSave() async {
    if (_key.currentState?.validate() ?? false) {
      _key.currentState!.save();
      AuthProviders? authProvider;
      List<auth.UserInfo> userInfoList =
          auth.FirebaseAuth.instance.currentUser?.providerData ?? [];
      await Future.forEach(userInfoList, (auth.UserInfo info) {
        if (info.providerId == 'password') {
          authProvider = AuthProviders.PASSWORD;
        } else if (info.providerId == 'phone') {
          authProvider = AuthProviders.PHONE;
        }
      });
      bool? result = false;
      if (authProvider == AuthProviders.PHONE &&
          auth.FirebaseAuth.instance.currentUser!.phoneNumber != mobile) {
        result = await showDialog(
          context: context,
          builder: (context) => ReAuthUserScreen(
            provider: authProvider!,
            phoneNumber: mobile,
            deleteUser: false,
          ),
        );
        if (result != null && result) {
          await showProgress(context, 'Saving details...'.tr(), false);
          await _updateUser();
          await hideProgress();
        }
      } else if (authProvider == AuthProviders.PASSWORD &&
          auth.FirebaseAuth.instance.currentUser!.email != email) {
        result = await showDialog(
          context: context,
          builder: (context) => ReAuthUserScreen(
            provider: authProvider!,
            email: email,
            deleteUser: false,
          ),
        );
        if (result != null && result) {
          await showProgress(context, 'Saving details...'.tr(), false);
          await _updateUser();
          await hideProgress();
        }
      } else {
        showProgress(context, 'Saving details...'.tr(), false);
        await _updateUser();
        hideProgress();
      }
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  _updateUser() async {
    user.firstName = firstName!;
    user.lastName = lastName!;
    user.age = age!;
    user.bio = bio!;
    user.school = school!;
    user.email = email!;
    user.phoneNumber = mobile!;
    User? updatedUser = await FireStoreUtils.updateCurrentUser(user);
    if (updatedUser != null) {
      MyAppState.currentUser = user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Details saved successfully'.tr(),
            style: TextStyle(fontSize: 17),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Couldn\'t save details, Please try again.'.tr(),
            style: TextStyle(fontSize: 17),
          ),
        ),
      );
    }
  }
}
