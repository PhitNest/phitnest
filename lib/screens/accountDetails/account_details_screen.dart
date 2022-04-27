import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/models.dart';
import '../../services/services.dart';
import '../screen_utils.dart';

class AccountDetailsScreen extends StatefulWidget {
  final UserModel user;

  AccountDetailsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _AccountDetailsScreenState createState() {
    return _AccountDetailsScreenState();
  }
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  late UserModel user;
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? firstName, lastName, age, bio, school, email, mobile;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  Color _getBackgroundColor(BuildContext context) =>
      DisplayUtils.isDarkMode ? Colors.black : Colors.white;

  Color _getForegroundColor(BuildContext context) =>
      DisplayUtils.isDarkMode ? Colors.white : Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  color:
                      DisplayUtils.isDarkMode ? Colors.black12 : Colors.white,
                  child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: ListTile.divideTiles(context: context, tiles: [
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
                                firstName = val;
                              },
                              validator: ValidationUtils.validateName,
                              textInputAction: TextInputAction.next,
                              textAlign: TextAlign.end,
                              initialValue: user.firstName,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: _getForegroundColor(context)),
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
                            style:
                                TextStyle(color: _getForegroundColor(context)),
                          ),
                          trailing: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 100),
                            child: TextFormField(
                              onSaved: (String? val) {
                                lastName = val;
                              },
                              validator: ValidationUtils.validateName,
                              textInputAction: TextInputAction.next,
                              textAlign: TextAlign.end,
                              initialValue: user.lastName,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: _getForegroundColor(context)),
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
                            style:
                                TextStyle(color: _getForegroundColor(context)),
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
                                  color: _getForegroundColor(context)),
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
                            style:
                                TextStyle(color: _getForegroundColor(context)),
                          ),
                          trailing: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * .5),
                            child: TextFormField(
                              onSaved: (String? val) {
                                bio = val;
                              },
                              textInputAction: TextInputAction.next,
                              initialValue: user.bio,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: _getForegroundColor(context)),
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
                            style:
                                TextStyle(color: _getForegroundColor(context)),
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
                                  color: _getForegroundColor(context)),
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
                color: DisplayUtils.isDarkMode ? Colors.black12 : Colors.white,
                child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                        ListTile(
                          title: Text(
                            'Email Address'.tr(),
                            style:
                                TextStyle(color: _getForegroundColor(context)),
                          ),
                          trailing: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: TextFormField(
                              onSaved: (String? val) {
                                email = val;
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
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5)),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Phone Number'.tr(),
                            style:
                                TextStyle(color: _getForegroundColor(context)),
                          ),
                          trailing: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 150),
                            child: TextFormField(
                              onSaved: (String? val) {
                                mobile = val;
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
                      color: DisplayUtils.isDarkMode
                          ? Colors.black12
                          : Colors.white,
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
      BackEndModel.getBackEnd(context).updateUserDetails(
          context, mobile!, email!, () async => await _updateUser());
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
    await BackEndModel.getBackEnd(context).updateCurrentUser(user: user);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Details saved successfully'.tr(),
          style: TextStyle(fontSize: 17),
        ),
      ),
    );
  }
}
