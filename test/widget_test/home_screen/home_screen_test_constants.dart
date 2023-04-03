import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_types.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/market_total.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_market.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_meta.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_month.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_statistics.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_total.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_unit.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_year.dart';
import 'package:shared_advisor_interface/data/models/user_info/contracts.dart';
import 'package:shared_advisor_interface/data/models/user_info/freshchat_info.dart';
import 'package:shared_advisor_interface/data/models/user_info/localized_properties/localized_properties.dart';
import 'package:shared_advisor_interface/data/models/user_info/localized_properties/property_by_language.dart';
import 'package:shared_advisor_interface/data/models/user_info/my_details.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/data/network/responses/reports_response.dart';

class HomeScreenTestConstants {
  static UserInfo userInfo = UserInfo(
    contracts: const Contracts(updates: []),
    status: UserStatus(
        status: FortunicaUserStatus.live,
        messaging: 'ENABLED',
        calling: 'BLOCKED',
        profileUpdatedAt: DateTime.parse('2023-01-31 13:10:08.761Z'),
        cancelDuringOffline: true),
    profile: const UserProfile(
        rating: {
          MarketsType.de: 4.5,
          MarketsType.en: 5.0,
          MarketsType.es: 3.0,
          MarketsType.pt: 2.9
        },
        activeLanguages: [
          MarketsType.de,
          MarketsType.en,
          MarketsType.es,
          MarketsType.pt
        ],
        profilePictures: [],
        coverPictures: [],
        galleryPictures: [],
        rituals: [
          SessionsTypes.ritual,
          SessionsTypes.astrology,
          SessionsTypes.aurareading
        ],
        isTestAccount: false,
        localizedProperties: LocalizedProperties(
          de: PropertyByLanguage(
              statusMessage: 'Status DE', description: 'Description DE'),
          en: PropertyByLanguage(
              statusMessage: 'Status EN', description: 'Description EN'),
          es: PropertyByLanguage(
              statusMessage: 'Status ES', description: 'Description ES'),
          pt: PropertyByLanguage(
              statusMessage: 'Status PT', description: 'Description PT'),
        ),
        profileName: 'Test Account'),
    id: '39726a57734b49a530639cc8115eb863e3f064fc16c2955384770462efb5e44b',
    freshchatInfo: const FreshchatInfo(
      restoreId: '7b58ab34-6fd1-481e-8e2d-2bead40c2fda',
    ),
    pushNotificationsEnabled: true,
    emails: [],
  );

  static ReportsResponse reportsResponse = ReportsResponse(
    meta: ReportsMeta(
        payoutDate: DateTime.parse('2023-02-26 00:00:00.000Z'),
        expertId:
            '39726a57734b49a530639cc8115eb863e3f064fc16c2955384770462efb5e44b',
        currency: 'EUR',
        rates: {
          SessionsTypes.public: 0.3,
          SessionsTypes.private: 0.3,
          SessionsTypes.ritual: 10.0,
          SessionsTypes.tarot: 3.5,
          SessionsTypes.palmreading: 3.5,
          SessionsTypes.astrology: 10.0,
          SessionsTypes.reading360: 5.0,
          SessionsTypes.lovecrushreading: 3.5,
          SessionsTypes.aurareading: 3.5,
          SessionsTypes.tipsLow: 0.5,
          SessionsTypes.tipsMedium: 1.0,
          SessionsTypes.tipsHigh: 2.5
        }),
    dateRange: [
      ReportsYear(
        year: '2023',
        months: [
          ReportsMonth(
              monthName: 'February',
              monthDate: '2023-02',
              startDate: '2023-02-01',
              endDate: '2023-02-28',
              current: true,
              statistics: ReportsStatistics(
                total:
                    const ReportsTotal(marketTotal: MarketTotal(amount: 6.5)),
                meta: ReportsMeta(
                    payoutDate: DateTime.parse('2023-02-26 00:00:00.000Z'),
                    expertId:
                        '39726a57734b49a530639cc8115eb863e3f064fc16c2955384770462efb5e44b',
                    currency: 'EUR',
                    rates: {
                      SessionsTypes.public: 0.3,
                      SessionsTypes.private: 0.3,
                      SessionsTypes.ritual: 10.0,
                      SessionsTypes.tarot: 3.5,
                      SessionsTypes.palmreading: 3.5,
                      SessionsTypes.astrology: 10.0,
                      SessionsTypes.reading360: 5.0,
                      SessionsTypes.lovecrushreading: 3.5,
                      SessionsTypes.aurareading: 3.5,
                      SessionsTypes.tipsLow: 0.5,
                      SessionsTypes.tipsMedium: 1.0,
                      SessionsTypes.tipsHigh: 2.5
                    }),
                markets: [],
              ))
        ],
      )
    ],
  );
}
