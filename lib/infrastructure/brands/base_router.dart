import 'package:shared_advisor_interface/configuration.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import './base_brand.dart';

// class BrandRouter extends RootStackRouter {
//   Map<String, PageFactory> brandPagesMap;
//   List<RouteConfig> brandRoutes;
//   BrandRouter(this.brandPagesMap, this.brandRoutes, [GlobalKey<NavigatorState>? navigatorKey])
//       : super(navigatorKey);
//
//   @override
//   Map<String, PageFactory> get pagesMap => brandPagesMap;
//
//   @override
//   List<RouteConfig> get routes => brandRoutes;
// }
//
// class BrandRouterManager {
//   final Map<String, PageFactory> pagesMap = {};
//   late List<RouteConfig> routes = [];
//
//   BrandRouterManager(RootStackRouter projectRouter) {
//     pagesMap.addAll(projectRouter.pagesMap);
//     routes = [...projectRouter.routes];
//   }
//
//   add(Brand brand) {
//     final RootStackRouter brandRouter = brand.getRouter;
//     pagesMap.addAll(brandRouter.pagesMap);
//     routes = [...routes, ...brandRouter.routes];
//   }
//
//   RootStackRouter getRouter() {
//     return BrandRouter(pagesMap, routes);
//   }
// }

