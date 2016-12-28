#define FONT_REGULAR @"Corbel"
#define FONT_BOLD @"Corbel-Bold"
#define FONT_LIGHT @"Corbel"

#define HEIGHT_IPHONE_4s 480
#define IS_IPHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width

#define NAVBARCLOLOR [UIColor colorWithRed:166.0/255 green:189.0/255 blue:23.0/255 alpha:1.0]
#define GREEN_THEMECOLOR [UIColor colorWithRed:166.0/255 green:189.0/255 blue:23.0/255 alpha:0.8]
#define GREEN_THEMECOLOR_LIGHT [UIColor colorWithRed:166.0/255 green:189.0/255 blue:23.0/255 alpha:0.4]

#define TEXT_COLOR [UIColor colorWithRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1.0]
#define BGCOLOR [UIColor colorWithRed:242.0/255 green:243.0/255 blue:245.0/255 alpha:1.0]

#define TAB_SELECTEDCOLOR [UIColor colorWithRed:122.0/255 green:181.0/255 blue:15.0/255 alpha:1.0]
#define TAB_NORMALCOLOR [UIColor colorWithRed:32.0/255 green:130.0/255 blue:19.0/255 alpha:1.0]

#define WEBSERVICE_URL @"[api_url]"

#define OPERATION @"_operation"


#define LOGIN @"loginAndFetchModules"
#define GET_MODULE_RECORD @"listModuleRecords"
#define GET_ALL_EVENTS @"eventRecords"
#define GET_ALL_DASHBOARDINFO @"dashboardAppointmentsRecords"
#define GET_FOLLOWUPDATE @"dashboardFollowUpDate"
#define GET_HISTORY_REC @"dashboardHistoryRecords"
#define GET_INFORMATION @"dashboardInformation"
#define GET_USER_DETAIL @"detailRecords"
#define GET_CLIENT_BIO @"dashboardAgentStrategistRecords"
#define GET_CLIENT_STRETEGISES @"dashboardStrategiesRecords"
#define GET_TOWNFEEDBACK @"dashboardTownFeedbackRecords"
#define FETCH_RECORD @"fetchRecord"
#define GET_ALL_FIELDS @"describe"
#define FETCH_MODILE_OWNERS @"fetchModuleOwners"
#define ADD_APPT_RECORD @"saveRecord"
#define GET_AVAILABLE_TIME @"availableRecords"
#define GET_AGENT_DETAIL @"selectAgentCityRecords"
#define GET_SUBURB_RECORDS @"getSuburbRecords"
#define GET_ALL_AGENT_RECORD @"agentRecords"
#define SAVE_AGENT_NOTES @"saveAgentNoteRecords"
#define SAVE_AGENT_RECORD @"saveAgentRankingRecords"
#define SAVE_AGENT_CLIENT_RECORD @"saveAgentClientRecords"
#define GETBOOKWITHRECORD @"appointmentTypeRecords"



#define FORGOTPWD @"forgotPassword"




#define SIGNUP @"customer-registration.php?"
#define CHECKSOCIALSIGNIN @"social-signin.php?"
#define SOCIALSIGNUP @"social-signup.php?"
#define FORGOT_PASSWORD @"forgotpassword.php?"

#define GET_NEARBYSTORE @"get-near-by-store.php?"
#define GET_SEARCH_STORE @"get-store-by-name.php?"
#define GET_NEARBYSTORE_AREA @"get-store-by-area.php?"
#define GET_OFFER_BY_STORE @"get-offer-by-store.php?"
#define ADD_TO_FAVOURITE @"add-favourite.php?"
#define GET_FAVOURITE @"favourite-list.php?"
#define GET_MY_POINTS @"get-points-by-branch.php?"
#define GET_MY_POINTS_BRANCH @"current-points.php?"

#define GET_VISIT_BRANCH @"visit-branch-list.php?"
#define GET_VISIT_HISTORY @"visit-history.php?"
#define TRANSACTION_HISTORY @"transaction-history.php?"
#define SCANCODE @"send_qr_code.php?"
#define GET_OFFER_DETAIL @"get-offer-detail.php?"
#define GET_PROFILE @"get-profile.php?"
#define UPDATE_PROFILE_PIC @"updateprofilepic.php?"
#define GET_COUNTRY @"get-country.php"
#define GET_STATE @"get-state.php?"
#define GET_CITY @"get-city.php?"
#define EDIT_PROFILE @"edit-profile.php?"


#define BLOCK_USER @"blockuser"
#define GET_BLOCK_USER @"getblockusers"
#define UNBLOCK_USER @"unblockuser"
#define SEND_MESSAGE @"sendsms"
#define UPDATE_TOKEN @"updatedevicetoken"
#define REQUEST_CONTACT @"requestaddcontact"

#define ALLOW_CONTACT @"allowaddcontact"


#define USER_ID [[NSUserDefaults standardUserDefaults] valueForKey:KEY_USER_ID]
#define TOKEN [[NSUserDefaults standardUserDefaults] valueForKey:KEY_TOKEN]
#define USERNAME [[NSUserDefaults standardUserDefaults] valueForKey:KEY_USERNAME]
#define PASSWORD [[NSUserDefaults standardUserDefaults] valueForKey:KEY_PASSWORD]
#define RADIUS [[NSUserDefaults standardUserDefaults] valueForKey:KEY_RADIUS]
#define ARRSIDEMENU [[NSUserDefaults standardUserDefaults] objectForKey:KEY_SIDEMENU]
#define ROLE [[NSUserDefaults standardUserDefaults] objectForKey:KEY_ROLE]


#define KEY_USER_ID @"USERID"
#define KEY_TOKEN @"TOKEN"
#define KEY_USERNAME @"USERNAME"
#define KEY_PASSWORD @"PASSWORD"
#define KEY_RADIUS @"RADIUS"
#define KEY_SIDEMENU @"SiDEMENUOPT"
#define KEY_ROLE @"ROLE"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define StarFillColor   [UIColor colorWithRed:238.0/255 green:166.0/255 blue:17.0/255 alpha:1.0]

#define REFRESHMESSAGENOTIFICATION @"REFRESHALLMESSAGES"
#define REFRESHDISCOVER @"REFRESHDISCOVER"



#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

