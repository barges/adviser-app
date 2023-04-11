import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:url_launcher/url_launcher.dart';

const String _articleIdKey = 'aid';
const String _linkKey = 'link';
const String _opponentIdKey = 'opponent_id';

enum DeepLinkAction {
  openArticle,
  showNewWindow,
  showMainPage,
  showSupport,
  showTechsupport,
  showConversation,
  unknown;

  factory DeepLinkAction.fromAlias(alias) {
    switch (alias) {
      case 'open-article':
        return DeepLinkAction.openArticle;
      case 'show-new-window':
        return DeepLinkAction.showNewWindow;
      case 'show-main-page':
        return DeepLinkAction.showMainPage;
      case 'show-support':
        return DeepLinkAction.showSupport;
      case 'show-techsupport':
        return DeepLinkAction.showTechsupport;
      case 'show-conversation':
        return DeepLinkAction.showConversation;
      default:
        return DeepLinkAction.unknown;
    }
  }

  void redirectToScreen(BuildContext context, Map<String, String> parameters) {
    switch (this) {
      case DeepLinkAction.openArticle:
        final String? articleId = parameters[_articleIdKey];
        if (articleId != null) {
          try {
            context.push(
              route: ZodiacArticleDetails(
                articleId: int.parse(articleId),
              ),
            );
          } catch (e) {
            logger.d(e);
          }
        }
        break;
      case DeepLinkAction.showNewWindow:
        final String? link = parameters[_linkKey];
        if (link != null) {
          launchUrl(
            Uri.parse(link),
            mode: LaunchMode.externalApplication,
          );
        }
        break;
      case DeepLinkAction.showMainPage:
        context.replaceAll([const ZodiacAuth()]);
        break;
      case DeepLinkAction.showSupport:
        context.push(route: const ZodiacSupport());
        break;
      case DeepLinkAction.showTechsupport:
        context.push(route: const ZodiacSupport());
        break;
      case DeepLinkAction.showConversation:
        final String? opponentId = parameters[_opponentIdKey];
        if (opponentId != null) {
          // TODO: Add redirect to chat screen
        }
        break;
      case DeepLinkAction.unknown:
        break;
    }
  }
}
