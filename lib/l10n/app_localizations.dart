import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('ko'),
    Locale('vi'),
  ];

  /// No description provided for @starting.
  ///
  /// In en, this message translates to:
  /// **'Starting'**
  String get starting;

  /// No description provided for @checkingVersion.
  ///
  /// In en, this message translates to:
  /// **'Checking Version..'**
  String get checkingVersion;

  /// No description provided for @newVersionAvailable.
  ///
  /// In en, this message translates to:
  /// **'New version available (version %s). Please update to new version.'**
  String get newVersionAvailable;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @uptodate.
  ///
  /// In en, this message translates to:
  /// **'Great! Your app is up to date!'**
  String get uptodate;

  /// No description provided for @somethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWrong;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get downloading;

  /// No description provided for @downloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get downloaded;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @init.
  ///
  /// In en, this message translates to:
  /// **'Initialize'**
  String get init;

  /// No description provided for @cameraGranted.
  ///
  /// In en, this message translates to:
  /// **'Camera permission granted'**
  String get cameraGranted;

  /// No description provided for @cameraDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission denied'**
  String get cameraDenied;

  /// No description provided for @cameraDeniedPermanent.
  ///
  /// In en, this message translates to:
  /// **'Camera permission permanently denied'**
  String get cameraDeniedPermanent;

  /// No description provided for @cameraNotGrant.
  ///
  /// In en, this message translates to:
  /// **'The user did not grant the camera permission!'**
  String get cameraNotGrant;

  /// No description provided for @micGranted.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission granted'**
  String get micGranted;

  /// No description provided for @micDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission denied'**
  String get micDenied;

  /// No description provided for @micDeniedPermanent.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission permanently denied'**
  String get micDeniedPermanent;

  /// No description provided for @errorPemission.
  ///
  /// In en, this message translates to:
  /// **'Error requesting permissions: %s'**
  String get errorPemission;

  /// No description provided for @connectionGone.
  ///
  /// In en, this message translates to:
  /// **'Connection was gone. Please check your internet connection!.'**
  String get connectionGone;

  /// No description provided for @cantReach.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach your website.'**
  String get cantReach;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @loginState.
  ///
  /// In en, this message translates to:
  /// **'Login to start your session'**
  String get loginState;

  /// No description provided for @employeeId.
  ///
  /// In en, this message translates to:
  /// **'Employee ID'**
  String get employeeId;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?\nPlease contact IT Team.'**
  String get noAccount;

  /// No description provided for @todayReport.
  ///
  /// In en, this message translates to:
  /// **'Today Report'**
  String get todayReport;

  /// No description provided for @mainMenu.
  ///
  /// In en, this message translates to:
  /// **'Main Menu'**
  String get mainMenu;

  /// No description provided for @building.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get building;

  /// No description provided for @incomingItem.
  ///
  /// In en, this message translates to:
  /// **'Incoming Items'**
  String get incomingItem;

  /// No description provided for @outgoingItem.
  ///
  /// In en, this message translates to:
  /// **'Outgoing Items'**
  String get outgoingItem;

  /// No description provided for @rack.
  ///
  /// In en, this message translates to:
  /// **'Rack'**
  String get rack;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @stockOnHand.
  ///
  /// In en, this message translates to:
  /// **'Stock On Hand'**
  String get stockOnHand;

  /// No description provided for @rackMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Rack Monitoring'**
  String get rackMonitoring;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @returnItem.
  ///
  /// In en, this message translates to:
  /// **'Return Items'**
  String get returnItem;

  /// No description provided for @barcodeInfo.
  ///
  /// In en, this message translates to:
  /// **'Barcode Information'**
  String get barcodeInfo;

  /// No description provided for @destroyItem.
  ///
  /// In en, this message translates to:
  /// **'Destroy Items'**
  String get destroyItem;

  /// No description provided for @stockOpname.
  ///
  /// In en, this message translates to:
  /// **'Stock Opname'**
  String get stockOpname;

  /// No description provided for @allData.
  ///
  /// In en, this message translates to:
  /// **'All Data'**
  String get allData;

  /// No description provided for @inProcess.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get inProcess;

  /// No description provided for @outProcess.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get outProcess;

  /// No description provided for @returnProcess.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnProcess;

  /// No description provided for @outgoingTransc.
  ///
  /// In en, this message translates to:
  /// **'Outgoing Transaction'**
  String get outgoingTransc;

  /// No description provided for @handOver.
  ///
  /// In en, this message translates to:
  /// **'Hand Over'**
  String get handOver;

  /// No description provided for @outDate.
  ///
  /// In en, this message translates to:
  /// **'Out Date'**
  String get outDate;

  /// No description provided for @senderId.
  ///
  /// In en, this message translates to:
  /// **'Sender ID'**
  String get senderId;

  /// No description provided for @receiverId.
  ///
  /// In en, this message translates to:
  /// **'Receiver ID'**
  String get receiverId;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @scanBox.
  ///
  /// In en, this message translates to:
  /// **'Scan Box'**
  String get scanBox;

  /// No description provided for @scanItem.
  ///
  /// In en, this message translates to:
  /// **'Scan Item'**
  String get scanItem;

  /// No description provided for @scanRack.
  ///
  /// In en, this message translates to:
  /// **'Scan Rack'**
  String get scanRack;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @moveTransc.
  ///
  /// In en, this message translates to:
  /// **'Move Transaction'**
  String get moveTransc;

  /// No description provided for @box.
  ///
  /// In en, this message translates to:
  /// **'Box'**
  String get box;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @labelId.
  ///
  /// In en, this message translates to:
  /// **'Label ID'**
  String get labelId;

  /// No description provided for @desc.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get desc;

  /// No description provided for @boxName.
  ///
  /// In en, this message translates to:
  /// **'Box Name'**
  String get boxName;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @rackName.
  ///
  /// In en, this message translates to:
  /// **'Rack Name'**
  String get rackName;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @cell.
  ///
  /// In en, this message translates to:
  /// **'Cell'**
  String get cell;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @oldLocationBoxId.
  ///
  /// In en, this message translates to:
  /// **'Old Location Box ID'**
  String get oldLocationBoxId;

  /// No description provided for @newLocationBoxId.
  ///
  /// In en, this message translates to:
  /// **'New Location Box ID'**
  String get newLocationBoxId;

  /// No description provided for @returnTransc.
  ///
  /// In en, this message translates to:
  /// **'Return Transaction'**
  String get returnTransc;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @returnType.
  ///
  /// In en, this message translates to:
  /// **'Return Type'**
  String get returnType;

  /// No description provided for @broken.
  ///
  /// In en, this message translates to:
  /// **'Broken'**
  String get broken;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @part.
  ///
  /// In en, this message translates to:
  /// **'Part'**
  String get part;

  /// No description provided for @tooling.
  ///
  /// In en, this message translates to:
  /// **'Tooling'**
  String get tooling;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @lastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last Update'**
  String get lastUpdate;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @totalItems.
  ///
  /// In en, this message translates to:
  /// **'Total Items'**
  String get totalItems;

  /// No description provided for @destroy.
  ///
  /// In en, this message translates to:
  /// **'Destroy'**
  String get destroy;

  /// No description provided for @destroyTransc.
  ///
  /// In en, this message translates to:
  /// **'Destroy Transaction'**
  String get destroyTransc;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @dateTransc.
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get dateTransc;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get fieldRequired;

  /// No description provided for @invalidLength.
  ///
  /// In en, this message translates to:
  /// **'Invalid length'**
  String get invalidLength;

  /// No description provided for @loginFail.
  ///
  /// In en, this message translates to:
  /// **'User not found or invalid Password!'**
  String get loginFail;

  /// No description provided for @monitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get monitoring;

  /// No description provided for @sewing.
  ///
  /// In en, this message translates to:
  /// **'Sewing'**
  String get sewing;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionType;

  /// No description provided for @transactionId.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transactionId;

  /// No description provided for @newLocation.
  ///
  /// In en, this message translates to:
  /// **'New Location'**
  String get newLocation;

  /// No description provided for @tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get tools;

  /// No description provided for @createdBy.
  ///
  /// In en, this message translates to:
  /// **'Created By'**
  String get createdBy;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @deviceDiscovery.
  ///
  /// In en, this message translates to:
  /// **'Device Discovery'**
  String get deviceDiscovery;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning'**
  String get scanning;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @scanDevices.
  ///
  /// In en, this message translates to:
  /// **'Scan devices'**
  String get scanDevices;

  /// No description provided for @foundDevice.
  ///
  /// In en, this message translates to:
  /// **'Found devices'**
  String get foundDevice;

  /// No description provided for @pairedDevice.
  ///
  /// In en, this message translates to:
  /// **'Show paired devices'**
  String get pairedDevice;

  /// No description provided for @unknownDevice.
  ///
  /// In en, this message translates to:
  /// **'Unknown device'**
  String get unknownDevice;

  /// No description provided for @transactionDate.
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get transactionDate;

  /// No description provided for @sender.
  ///
  /// In en, this message translates to:
  /// **'Sender'**
  String get sender;

  /// No description provided for @receiver.
  ///
  /// In en, this message translates to:
  /// **'Receiver'**
  String get receiver;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcode;

  /// No description provided for @cancelScan.
  ///
  /// In en, this message translates to:
  /// **'Cancel Scan'**
  String get cancelScan;

  /// No description provided for @lineRemark.
  ///
  /// In en, this message translates to:
  /// **'Line / Remark'**
  String get lineRemark;

  /// No description provided for @woNumber.
  ///
  /// In en, this message translates to:
  /// **'Work Order Number'**
  String get woNumber;

  /// No description provided for @brokenDate.
  ///
  /// In en, this message translates to:
  /// **'Broken Date'**
  String get brokenDate;

  /// No description provided for @returnDate.
  ///
  /// In en, this message translates to:
  /// **'Stop Used Date'**
  String get returnDate;

  /// No description provided for @fixedDate.
  ///
  /// In en, this message translates to:
  /// **'Fixed Date'**
  String get fixedDate;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @ofItem.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofItem;

  /// No description provided for @maxItems.
  ///
  /// In en, this message translates to:
  /// **'Max Items'**
  String get maxItems;

  /// No description provided for @maxBoxes.
  ///
  /// In en, this message translates to:
  /// **'Max Boxes'**
  String get maxBoxes;

  /// No description provided for @updatedBy.
  ///
  /// In en, this message translates to:
  /// **'Updated By'**
  String get updatedBy;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get updatedAt;

  /// No description provided for @rackLocation.
  ///
  /// In en, this message translates to:
  /// **'Rack Location'**
  String get rackLocation;

  /// No description provided for @cellNo.
  ///
  /// In en, this message translates to:
  /// **'Cell Number'**
  String get cellNo;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @onHand.
  ///
  /// In en, this message translates to:
  /// **'On Hand Data'**
  String get onHand;

  /// No description provided for @moveIn.
  ///
  /// In en, this message translates to:
  /// **'Move In'**
  String get moveIn;

  /// No description provided for @moveOut.
  ///
  /// In en, this message translates to:
  /// **'Move Out'**
  String get moveOut;

  /// No description provided for @kukdong.
  ///
  /// In en, this message translates to:
  /// **'Kukdong'**
  String get kukdong;

  /// No description provided for @scanMode.
  ///
  /// In en, this message translates to:
  /// **'Scan Mode'**
  String get scanMode;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @bluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get bluetooth;

  /// No description provided for @scanSenderId.
  ///
  /// In en, this message translates to:
  /// **'Scan Sender ID'**
  String get scanSenderId;

  /// No description provided for @cancelScanSenderId.
  ///
  /// In en, this message translates to:
  /// **'Cancel Scan Sender ID'**
  String get cancelScanSenderId;

  /// No description provided for @scanReceiverId.
  ///
  /// In en, this message translates to:
  /// **'Scan Receiver ID'**
  String get scanReceiverId;

  /// No description provided for @cancelscanReceiverId.
  ///
  /// In en, this message translates to:
  /// **'Cancel Scan Receiver ID'**
  String get cancelscanReceiverId;

  /// No description provided for @scanItemId.
  ///
  /// In en, this message translates to:
  /// **'Scan Item ID'**
  String get scanItemId;

  /// No description provided for @scanBoxId.
  ///
  /// In en, this message translates to:
  /// **'Scan Box ID'**
  String get scanBoxId;

  /// No description provided for @scanRackId.
  ///
  /// In en, this message translates to:
  /// **'Scan Rack ID'**
  String get scanRackId;

  /// No description provided for @flashOn.
  ///
  /// In en, this message translates to:
  /// **'Flash ON'**
  String get flashOn;

  /// No description provided for @flashOff.
  ///
  /// In en, this message translates to:
  /// **'Flash OFF'**
  String get flashOff;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @clearList.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to change?\nYour Items List will be cleared.'**
  String get clearList;

  /// No description provided for @labelItemNotFound.
  ///
  /// In en, this message translates to:
  /// **'Label item not found!'**
  String get labelItemNotFound;

  /// No description provided for @itemOutgoing.
  ///
  /// In en, this message translates to:
  /// **'Item already outgoing!'**
  String get itemOutgoing;

  /// No description provided for @itemNotGood.
  ///
  /// In en, this message translates to:
  /// **'Item not in good condition!\nCannot be Fixed!'**
  String get itemNotGood;

  /// No description provided for @itemGood.
  ///
  /// In en, this message translates to:
  /// **'Item in good condition!\nCannot be Fixed!'**
  String get itemGood;

  /// No description provided for @itemInhouse.
  ///
  /// In en, this message translates to:
  /// **'Item in House!'**
  String get itemInhouse;

  /// No description provided for @itemDestroy.
  ///
  /// In en, this message translates to:
  /// **'Item was already destroyed!'**
  String get itemDestroy;

  /// No description provided for @rackFull.
  ///
  /// In en, this message translates to:
  /// **'Rack was full!'**
  String get rackFull;

  /// No description provided for @boxFull.
  ///
  /// In en, this message translates to:
  /// **'Box was full!'**
  String get boxFull;

  /// No description provided for @boxOverload.
  ///
  /// In en, this message translates to:
  /// **'Destination Box overload!'**
  String get boxOverload;

  /// No description provided for @barcodeAlreadyIn.
  ///
  /// In en, this message translates to:
  /// **'Barcode already added to the list!'**
  String get barcodeAlreadyIn;

  /// No description provided for @barcodeAlreadyScan.
  ///
  /// In en, this message translates to:
  /// **'Barcode already scanned!'**
  String get barcodeAlreadyScan;

  /// No description provided for @labelBoxNotFound.
  ///
  /// In en, this message translates to:
  /// **'Label Box not found!'**
  String get labelBoxNotFound;

  /// No description provided for @labelRackNotFound.
  ///
  /// In en, this message translates to:
  /// **'Label Rack not found!'**
  String get labelRackNotFound;

  /// No description provided for @allItemSaved.
  ///
  /// In en, this message translates to:
  /// **'All items saved successfully.'**
  String get allItemSaved;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @confirmRemove.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to remove %s data?'**
  String get confirmRemove;

  /// No description provided for @confirmSubmit.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to save this transaction?'**
  String get confirmSubmit;

  /// No description provided for @cancelSubmit.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this transaction?'**
  String get cancelSubmit;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get confirmLogout;

  /// No description provided for @boxes.
  ///
  /// In en, this message translates to:
  /// **'Boxes'**
  String get boxes;

  /// No description provided for @sameID.
  ///
  /// In en, this message translates to:
  /// **'ID Same, please use another Employe ID!'**
  String get sameID;

  /// No description provided for @employeeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Employee not found!'**
  String get employeeNotFound;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @style.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get style;

  /// No description provided for @itemCode.
  ///
  /// In en, this message translates to:
  /// **'Item Code'**
  String get itemCode;

  /// No description provided for @container.
  ///
  /// In en, this message translates to:
  /// **'Container'**
  String get container;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get from;

  /// No description provided for @requestId.
  ///
  /// In en, this message translates to:
  /// **'Request ID'**
  String get requestId;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @filterOptions.
  ///
  /// In en, this message translates to:
  /// **'Filter Options'**
  String get filterOptions;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @item2Box.
  ///
  /// In en, this message translates to:
  /// **'Item to Box'**
  String get item2Box;

  /// No description provided for @box2Rack.
  ///
  /// In en, this message translates to:
  /// **'Box to Rack'**
  String get box2Rack;

  /// No description provided for @box2Box.
  ///
  /// In en, this message translates to:
  /// **'Box to Box'**
  String get box2Box;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'You\'re connected to Server.'**
  String get connected;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'You\'re not connected to Server.'**
  String get notConnected;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear List'**
  String get clear;

  /// No description provided for @cancelBoxId.
  ///
  /// In en, this message translates to:
  /// **'Cancel Scan Box ID'**
  String get cancelBoxId;

  /// No description provided for @cancelRackId.
  ///
  /// In en, this message translates to:
  /// **'Cancel Scan Rack ID'**
  String get cancelRackId;

  /// No description provided for @scanSenderID.
  ///
  /// In en, this message translates to:
  /// **'Scanning Sender ID'**
  String get scanSenderID;

  /// No description provided for @scanReceiverID.
  ///
  /// In en, this message translates to:
  /// **'Scanning Receiver ID'**
  String get scanReceiverID;

  /// No description provided for @scanItemID.
  ///
  /// In en, this message translates to:
  /// **'Scanning Item ID'**
  String get scanItemID;

  /// No description provided for @scanBoxID.
  ///
  /// In en, this message translates to:
  /// **'Scanning Box ID'**
  String get scanBoxID;

  /// No description provided for @scanRackID.
  ///
  /// In en, this message translates to:
  /// **'Scanning Rack ID'**
  String get scanRackID;

  /// No description provided for @waitScan.
  ///
  /// In en, this message translates to:
  /// **'Waiting scanner'**
  String get waitScan;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Internet connection lost. Please check your network and try again.'**
  String get connectionError;

  /// No description provided for @receiveTimeout.
  ///
  /// In en, this message translates to:
  /// **'Server is not responding. Please try again in a few moments.'**
  String get receiveTimeout;

  /// No description provided for @sendTimeout.
  ///
  /// In en, this message translates to:
  /// **'Failed to send data. Please check your connection and try again.'**
  String get sendTimeout;

  /// No description provided for @connectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. The network is slow or the server is busy.'**
  String get connectionTimeout;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id', 'ko', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'ko':
      return AppLocalizationsKo();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
