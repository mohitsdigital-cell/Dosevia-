import 'dart:ui';

/// Localised app strings (Blueprint Part 12.1 - English + Hindi at launch).
class AppStrings {
  static const appName = 'Dosevia';

  static const supportedLocales = [Locale('en'), Locale('hi')];

  static String greetingMorning(Locale l) =>
      l.languageCode == 'hi' ? 'सुप्रभात' : 'Good morning';
  static String greetingAfternoon(Locale l) =>
      l.languageCode == 'hi' ? 'नमस्ते' : 'Good afternoon';
  static String greetingEvening(Locale l) =>
      l.languageCode == 'hi' ? 'शुभ संध्या' : 'Good evening';
  static String greetingNight(Locale l) =>
      l.languageCode == 'hi' ? 'शुभ रात्रि' : 'Good night';

  static String tabHome(Locale l) => l.languageCode == 'hi' ? 'होम' : 'Home';
  static String tabMedicines(Locale l) =>
      l.languageCode == 'hi' ? 'दवाइयाँ' : 'Medicines';
  static String tabHealth(Locale l) =>
      l.languageCode == 'hi' ? 'स्वास्थ्य' : 'Health';
  static String tabCareCircle(Locale l) =>
      l.languageCode == 'hi' ? 'केयर सर्कल' : 'Care Circle';
  static String tabProfile(Locale l) =>
      l.languageCode == 'hi' ? 'प्रोफ़ाइल' : 'Profile';

  static String todaySchedule(Locale l) => l.languageCode == 'hi'
      ? 'आज की दवा अनुसूची'
      : "Today's medicine schedule";
  static String addMedicine(Locale l) =>
      l.languageCode == 'hi' ? 'दवाई जोड़ें' : 'Add medicine';
  static String taken(Locale l) => l.languageCode == 'hi' ? 'ली गई' : 'Taken';
  static String skip(Locale l) => l.languageCode == 'hi' ? 'छोड़ें' : 'Skip';
  static String snooze(Locale l) => l.languageCode == 'hi' ? 'टालें' : 'Snooze';
  static String skipped(Locale l) =>
      l.languageCode == 'hi' ? 'छोड़ी गई' : 'Skipped';
  static String upcoming(Locale l) =>
      l.languageCode == 'hi' ? 'आने वाली' : 'Upcoming';
  static String missed(Locale l) => l.languageCode == 'hi' ? 'छूटी हुई' : 'Missed';
  static String doseHistory(Locale l) =>
      l.languageCode == 'hi' ? 'खुराक इतिहास' : 'Dose history';
  static String adherence(Locale l) =>
      l.languageCode == 'hi' ? 'नियमितता' : 'Adherence';
  static String nextDose(Locale l) =>
      l.languageCode == 'hi' ? 'अगली खुराक' : 'Next dose';
  static String noMedicines(Locale l) => l.languageCode == 'hi'
      ? 'कोई दवाई नहीं है। पहली दवाई जोड़ें।'
      : 'No medicines yet. Add your first medicine.';
  static String medicineName(Locale l) =>
      l.languageCode == 'hi' ? 'दवा का नाम' : 'Medicine name';
  static String strength(Locale l) =>
      l.languageCode == 'hi' ? 'मात्रा (जैसे 500mg)' : 'Strength (e.g. 500mg)';
  static String doseTimes(Locale l) =>
      l.languageCode == 'hi' ? 'खुराक समय' : 'Dose times';
  static String morning(Locale l) => l.languageCode == 'hi' ? 'सुबह' : 'Morning';
  static String afternoon(Locale l) =>
      l.languageCode == 'hi' ? 'दोपहर' : 'Afternoon';
  static String evening(Locale l) =>
      l.languageCode == 'hi' ? 'शाम' : 'Evening';
  static String night(Locale l) => l.languageCode == 'hi' ? 'रात' : 'Night';
  static String save(Locale l) => l.languageCode == 'hi' ? 'सुरक्षित करें' : 'Save';
  static String cancel(Locale l) => l.languageCode == 'hi' ? 'रद्द करें' : 'Cancel';
  static String delete(Locale l) => l.languageCode == 'hi' ? 'हटाएँ' : 'Delete';
  static String edit(Locale l) => l.languageCode == 'hi' ? 'संपादित करें' : 'Edit';

  static String vitals(Locale l) => l.languageCode == 'hi' ? 'वाइटल्स' : 'Vitals';
  static String addVital(Locale l) =>
      l.languageCode == 'hi' ? 'वाइटल जोड़ें' : 'Add vital';
  static String medicalId(Locale l) =>
      l.languageCode == 'hi' ? 'मेडिकल ID' : 'Medical ID';
  static String emergencyContacts(Locale l) =>
      l.languageCode == 'hi' ? 'आपातकालीन संपर्क' : 'Emergency contacts';
  static String emergencyCall112(Locale l) => l.languageCode == 'hi'
      ? 'आपातकाल में 112 पर कॉल करें'
      : 'Emergency: call 112';

  static String careCircleSubtitle(Locale l) => l.languageCode == 'hi'
      ? 'परिवार के सदस्य जोड़ें और उनकी देखभाल करें'
      : 'Manage and care for family members';

  static String aiDisclaimer(Locale l) => l.languageCode == 'hi'
      ? 'Dosevia एक स्वास्थ्य संगठन उपकरण है, डॉक्टर नहीं। आपातकाल में 112 पर कॉल करें।'
      : 'Dosevia is a health organisation tool, not a doctor. In an emergency, call 112.';
}
