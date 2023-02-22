part of constants;

enum Assets {
  coloredLogo,
  logo,
  darkLogo,
  profilePictureMeme,
  profilePictureMask,
  backButton,
  dropDownButton,
}

extension Path on Assets {
  String get path {
    switch (this) {
      case Assets.coloredLogo:
        return 'assets/images/logo_color.png';
      case Assets.logo:
        return 'assets/images/logo.png';
      case Assets.darkLogo:
        return 'assets/images/logo_reversed.png';
      case Assets.profilePictureMeme:
        return 'assets/images/pfp_meme.png';
      case Assets.profilePictureMask:
        return 'assets/images/profile_picture_mask.png';
      case Assets.backButton:
        return 'assets/images/back_button.png';
      case Assets.dropDownButton:
        return 'assets/images/dropdown_icon.png';
    }
  }
}
