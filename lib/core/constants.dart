import 'package:skeletonizer/skeletonizer.dart';

const TextStyle kHintTextStyle =
    TextStyle(color: Color.fromARGB(255, 125, 125, 125));
const TextStyle kPlainTextStyle = TextStyle();
const TextStyle kDateTimeTextStyle = TextStyle(
  fontSize: 10,
  fontStyle: FontStyle.italic,
);
const TextStyle kHeading2TextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);
const TextStyle kHeading1TextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w800,
);

const TextStyle kHeadingTextStyle = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w800, fontFamily: "CheesyCats");

const Color kPrimaryColor = Color.fromARGB(255, 0, 199, 253);
const Color kSecondaryColor = Color.fromARGB(255, 32, 61, 224);

const LinearGradient kPrimaryGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [kPrimaryColor, kSecondaryColor],
);

const LinearGradient kDisabledGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color.fromARGB(255, 125, 125, 125),
    Color.fromARGB(255, 125, 125, 125)
  ],
);

const LinearGradient kErrorGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [Color.fromARGB(255, 253, 118, 0), Color.fromARGB(255, 224, 32, 32)],
);

const LinearGradient kSuccessGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [Color.fromARGB(255, 169, 253, 0), Color.fromARGB(255, 32, 224, 38)],
);

const ShimmerEffect kDarkModeShimmer = ShimmerEffect(
    baseColor: Color.fromARGB(255, 0, 13, 27), highlightColor: kSecondaryColor);

const ShimmerEffect kLightModeShimmer = ShimmerEffect(
    baseColor: Color.fromARGB(255, 230, 237, 255),
    highlightColor: Color.fromARGB(57, 125, 227, 255));
