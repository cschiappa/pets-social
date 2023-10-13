import 'package:flutter/material.dart';
import 'package:pets_social/screens/open_post_screen.dart';
import 'package:routemaster/routemaster.dart';

const String postRoute = '/post/:postId/:profileUid/:username';

final routemaster = RoutemasterDelegate(
  routesBuilder: (context) {
    return RouteMap(
      onUnknownRoute: (_) => const Redirect('/404'),
      routes: {
        postRoute: (info) => MaterialPage(
              child: OpenPost(
                postId: info.pathParameters['postId']!,
                profileUid: info.pathParameters['profileUid']!,
                username: info.pathParameters['username']!,
              ),
            ),
      },
    );
  },
);
