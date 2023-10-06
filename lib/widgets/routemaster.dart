import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/screens/open_post_screen.dart';
import 'package:routemaster/routemaster.dart';

import '../models/post.dart';

const String postRoute = '/post';

final routemaster = RoutemasterDelegate(
  routesBuilder: (context) {
    // ModelPost post = ModelPost.fromSnap(snapshot.data!.docs[index]);
    // QuerySnapshot snap = await FirebaseFirestore.instance
    //       .collection('posts')
    //       .get();
    return RouteMap(
      onUnknownRoute: (_) => const Redirect('/404'),
      routes: {
        // postRoute: (_) => MaterialPage(child: OpenPost(postId: post.postId,
        //                       profileUid: post.profileUid,
        //                       username: post.username,)),
      },
    );
  },
);
