import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/models/notification.dart';
import 'package:pets_social/providers/notification/notification_provider.dart';
import 'package:pets_social/providers/post/post_provider.dart';
import 'package:pets_social/providers/profile/profile_provider.dart';
import 'package:pets_social/providers/user/user_provider.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';

import 'package:timeago/timeago.dart' as timeago;
import '../features/app_router.dart';
import '../models/profile.dart';

class PrizesScreen extends ConsumerStatefulWidget {
  const PrizesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrizesScreenState();
}

class _PrizesScreenState extends ConsumerState<PrizesScreen> {
  var notificationData = [];
  var userData = {};
  int postLen = 0;
  int likes = 0;
  int fish = 0;
  int bones = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final ModelProfile profile = ref.watch(userProvider)!;
    final ThemeData theme = Theme.of(context);
    final ScrollController scrollController = ScrollController();
    final profileData = ref.watch(getProfileDataProvider(profile.profileUid));
    final profilePosts = ref.watch(getProfilePostsProvider(profile.profileUid));
    final notificationData = ref.watch(getNotificationsProvider(profile.profileUid));
    final int followers = profile.followers.length;
    final int following = profile.following.length;

    return profileData.when(
        error: (error, stackTrace) => Text('Error: $error'),
        loading: () => Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.secondary,
              ),
            ),
        data: (profileData) {
          return Scaffold(
              body: SingleChildScrollView(
            padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                //HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(15),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Hello ${profile.username}\n',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text: 'How are you feeling today?',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: CircleAvatar(
                        backgroundImage: (profile.photoUrl != null) ? NetworkImage(profile.photoUrl!) : const AssetImage('assets/default_pic') as ImageProvider<Object>,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                //NOTIFICATIONS
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 157, 110, 157), // Start color
                        Color.fromARGB(255, 240, 177, 136), // End color
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Notifications',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.notification_add)
                        ],
                      ),
                      const Divider(
                        color: Colors.white,
                      ),
                      notificationData.when(
                          error: (error, stacktrace) => Text('error: $error'),
                          loading: () => Container(),
                          data: (notificationData) {
                            return Expanded(
                              child: Scrollbar(
                                controller: scrollController,
                                thumbVisibility: true,
                                child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: notificationData.length,
                                    itemBuilder: (context, index) {
                                      ModelNotification notification = ModelNotification.fromSnap(notificationData[index]);
                                      final DateTime timeAgo = notification.datePublished;

                                      return GestureDetector(
                                        onTap: () {
                                          notification.postId == ""
                                              ? context.goNamed(AppRouter.profileFromPrizes.name, pathParameters: {'profileUid': notification.sender})
                                              : context.goNamed(
                                                  AppRouter.openPostFromPrizes.name,
                                                  pathParameters: {
                                                    'postId': notification.postId!,
                                                    'profileUid': notification.receiver,
                                                    'username': profile.username,
                                                  },
                                                );
                                        },
                                        child: ListTile(
                                          leading: Text(
                                            notification.body,
                                            style: const TextStyle(fontSize: 15),
                                          ),
                                          trailing: Text(timeago.format(timeAgo).toString()),
                                        ),
                                      );
                                    }),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //STATS
                Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 157, 110, 157), // Start color
                          Color.fromARGB(255, 240, 177, 136), // End color
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Stats',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.query_stats)
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              Text('$followers followers', style: const TextStyle(fontSize: 15)),
                              Text('$following following', style: const TextStyle(fontSize: 15)),
                            ],
                          ),
                        )
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                //PRIZES
                Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 157, 110, 157), // Start color
                          Color.fromARGB(255, 240, 177, 136), // End color
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Prizes',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.emoji_events)
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        profilePosts.when(
                            loading: () => Container(),
                            error: (error, stackTrace) => Text('Error: $error'),
                            data: (profilePosts) {
                              int likes = 0;
                              int fish = 0;
                              int bones = 0;

                              for (var post in profilePosts.docs) {
                                likes += post.data()['likes'].length as int;
                                fish += post.data()['fish'].length as int;
                                bones += post.data()['bones'].length as int;
                              }
                              return SingleChildScrollView(
                                child: Container(
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: const Color.fromARGB(100, 0, 0, 0),
                                  ),
                                  child: Row(
                                    children: [
                                      //ARROW LEFT SWIPE
                                      InkWell(
                                        onTap: () {
                                          _controller.previousPage();
                                        },
                                        child: Icon(Icons.arrow_left, color: theme.colorScheme.primary),
                                      ),

                                      Expanded(
                                        child: CarouselSlider(
                                          carouselController: _controller,
                                          options: CarouselOptions(
                                            viewportFraction: 0.4,
                                            aspectRatio: 2,
                                            enableInfiniteScroll: true,
                                            initialPage: 1,
                                            enlargeCenterPage: true,
                                            enlargeFactor: 0.5,
                                            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                                          ),
                                          items: [
                                            // FISH
                                            Column(
                                              children: [
                                                Image.asset(
                                                  (fish > 0) ? 'assets/fish.png' : 'assets/fish_border.png',
                                                  width: 100,
                                                  height: 100,
                                                ),
                                                Text('$fish fish')
                                              ],
                                            ),

                                            //LIKES
                                            Column(
                                              children: [
                                                Image.asset(
                                                  (likes > 0) ? 'assets/like.png' : 'assets/like_border.png',
                                                  width: 100,
                                                  height: 100,
                                                ),
                                                Text((likes == 1) ? '$likes like' : '$likes likes')
                                              ],
                                            ),

                                            //BONES
                                            Column(
                                              children: [
                                                Image.asset(
                                                  (bones > 0) ? 'assets/bone.png' : 'assets/bone_border.png',
                                                  width: 100,
                                                  height: 100,
                                                ),
                                                Text((bones == 1) ? '$bones bone' : '$bones bones')
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      //ARROW RIGHT SWIPE
                                      InkWell(
                                        onTap: () {
                                          _controller.nextPage();
                                        },
                                        child: Icon(Icons.arrow_right, color: theme.colorScheme.primary),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ],
                    ))
              ],
            ),
          ));
        });
  }
}
