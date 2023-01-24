const String kColoredLogoPath = 'assets/images/logo_color.png';

const String kLogoPath = 'assets/images/logo.png';

const String kDarkLogoPath = 'assets/images/logo_reversed.png';

const String kProfilePictureMeme = 'assets/images/pfp_meme.png';

const String kProfilePictureMask = 'assets/images/profile_picture_mask.png';

const String kBackButton = 'assets/images/back_button.png';

const String kDropDownButton = 'assets/images/dropdown_icon.png';

enum Assets {
  coloredLogo,
  logo,
  darkLogo,
  profilePictureMeme,
  profilePictureMask,
  backButton,
  dropDownButton,
}

extension Paths on Assets {
  String get path {
    switch (this) {
      case Assets.coloredLogo:
        return kColoredLogoPath;
      case Assets.logo:
        return kLogoPath;
      case Assets.darkLogo:
        return kDarkLogoPath;
      case Assets.profilePictureMeme:
        return kProfilePictureMeme;
      case Assets.profilePictureMask:
        return kProfilePictureMask;
      case Assets.backButton:
        return kBackButton;
      case Assets.dropDownButton:
        return kDropDownButton;
    }
  }
}
