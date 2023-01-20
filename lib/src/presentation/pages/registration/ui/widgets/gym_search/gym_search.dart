import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/entities/entities.dart';
import '../../../../../widgets/styled/styled.dart';
import 'card.dart';

class _GymSearchState extends ChangeNotifier {
  GymEntity _gym;
  late final TextEditingController searchController = TextEditingController()
    ..addListener(notifyListeners);

  GymEntity get gym => _gym;

  set gym(GymEntity value) {
    _gym = value;
    notifyListeners();
  }

  _GymSearchState(this._gym);

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class GymSearchPage extends StatelessWidget {
  final List<GymEntity> gyms;
  final LocationEntity location;
  final GymEntity initialGym;

  const GymSearchPage({
    Key? key,
    required this.gyms,
    required this.location,
    required this.initialGym,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<_GymSearchState>(
        create: (context) => _GymSearchState(initialGym),
        builder: (context, child) => Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              40.verticalSpace,
              Container(
                padding: EdgeInsets.only(
                  left: 8.w,
                ),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: StyledBackButton(
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: Consumer<_GymSearchState>(
                  builder: (context, state, child) {
                    final cards = gyms
                        .where(
                          (gym) => gym.containsIgnoreCase(
                            state.searchController.text.trim(),
                          ),
                        )
                        .map(
                          (gym) => GymCard(
                            gym: gym,
                            distance: location.distanceTo(
                              gym.location,
                            ),
                            selected: state.gym == gym,
                            onPressed: () => state.gym = gym,
                          ),
                        )
                        .toList();
                    return CustomScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      slivers: <Widget>[
                        SliverAppBar(
                          leading: Container(),
                          elevation: 0,
                          leadingWidth: 0,
                          backgroundColor: Colors.white,
                          floating: true,
                          primary: false,
                          toolbarHeight: 50.h,
                          centerTitle: true,
                          title: Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: StyledTextField(
                              hint: 'Search',
                              maxLines: 1,
                              height: 70.h,
                              errorMaxLines: 0,
                              textInputAction: TextInputAction.search,
                              keyboardType: TextInputType.streetAddress,
                              width: 328.w,
                              controller: state.searchController,
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate(cards),
                        ),
                      ],
                    );
                  },
                ),
              ),
              StyledButton(
                text: 'CONFIRM',
                onPressed: () => Navigator.pop(
                  context,
                  Provider.of<_GymSearchState>(context, listen: false).gym,
                ),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      );
}
