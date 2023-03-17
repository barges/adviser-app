import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:fortunica/generated/l10n.dart';

class SeeMoreWidget extends StatelessWidget {
  const SeeMoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          height: 96.0,
          margin: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalScreenPadding,
            vertical: 24.0,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(
              AppConstants.buttonRadius,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    14.0,
                    12.0,
                    10.0,
                    8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SFortunica
                            .of(context)
                            .notEnoughConversationsCheckOurProfileGuideFortunica,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        SFortunica.of(context).seeMoreFortunica,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline),
                      )
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(AppConstants.buttonRadius),
                    bottomRight: Radius.circular(AppConstants.buttonRadius)),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Assets.images.conversations.image(
                    fit: BoxFit.cover,
                    height: 96.0,
                    width: 124.0,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
