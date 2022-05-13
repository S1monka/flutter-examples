import 'package:catchup/app/navigator.dart';
import 'package:catchup/app/theme_config.dart';
import 'package:catchup/core/index.dart';
import 'package:catchup/data/echo/pusher.dart';
import 'package:catchup/data/models/index.dart';
import 'package:catchup/data/notifications/firebase_notifications_service.dart';
import 'package:catchup/features/auth/bloc/auth_bloc.dart';
import 'package:catchup/features/gallery/bloc/gallery_bloc.dart';
import 'package:catchup/features/index.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catchup/data/notifications/bloc/firebase_messaging_bloc.dart';

import 'package:intl/date_symbol_data_local.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CupertinoTabController tabController =
      CupertinoTabController(initialIndex: 0);

  bool showChatBadge = false;

  final listOfKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final List<String> _bottomNavBarIcons = [
    'assets/images/navbar_svg/home_icon.svg',
    'assets/images/navbar_svg/bell_icon.svg',
    'assets/images/navbar_svg/chat_icon.svg',
    'assets/images/navbar_svg/calendar_icon.svg',
    'assets/images/icons/avatar.png',
  ];

  final List<Widget> _pages = [
    GalleryTabScreen(),
    NotificationTabScreen(),
    MessageTabScreen(),
    CalendarTabScreen(),
    UserTabScreen(),
  ];

  int currentIndex = 0;

  NavigatorState get currentNavigator => listOfKeys[currentIndex].currentState!;

  void handleLink(Uri deepLink) async {
    final imageId = deepLink.queryParameters['imageId'];
    if (imageId != null) {
      currentNavigator.pushNamed(
        PublicationDetailScreen.routeName,
        arguments: imageId,
      );
    } else {
      final userLink = deepLink.queryParameters['userId']?.split('?');
      final userId = userLink?.first;
      final userType = userLink?.last.split('=').last;
      if (userId != null && userType != null) {
        currentNavigator.pushNamed(
          OtherUserScreen.routeName,
          arguments: OtherUserArguments(
            userId,
            UserType.fromJsonString(userType),
          ),
        );
      }
    }
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) {
      final Uri? deepLink = dynamicLink.link;

      if (deepLink != null) {
        handleLink(deepLink);
      }
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      handleLink(deepLink);
    }
  }

  void initFirebase() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final pusherService = getIt<PusherService>();
      if (!pusherService.isActive) {
        FirebaseNotificationsService.showMessage(message);
        context.read<FirebaseMessagingBloc>().onMessage(message.data);
      }
    });
  }

  @override
  void initState() {
    initFirebase();
    initDynamicLinks();
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final isAuthed = authBloc.state is Authenticated;
    final user = authBloc.state.user;
    return MultiBlocProvider(
      providers: [
        SingleDataLoaderBlocProvider(
          lazy: !isAuthed,
          create: (context) => getIt<UserBloc>(),
        ),
        SingleDataLoaderBlocProvider(
          lazy: !isAuthed,
          create: (context) => getIt<SettingsBloc>(),
        ),
        SingleDataLoaderBlocProvider(
          lazy: !isAuthed,
          create: (context) => getIt<CalendarTabBloc>(),
        ),
        SingleDataLoaderBlocProvider(
          lazy: !isAuthed,
          create: (context) => getIt<MessageTabBloc>(),
        ),
        SingleDataLoaderBlocProvider(
          create: (context) => getIt<CommonGalleryBloc>(),
        ),
        SingleDataLoaderBlocProvider(
          lazy: !(isAuthed && user is Master),
          create: (context) => getIt<MasterGalleryBloc>(
            param1: user?.id,
          ),
        ),
        SingleDataLoaderBlocProvider(
          lazy: !isAuthed,
          create: (context) => getIt<NotificationsBloc>(),
        ),
      ],
      child: WillPopScope(
        onWillPop: () async {
          if (currentNavigator.canPop()) currentNavigator.pop();
          return false;
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<FirebaseMessagingBloc, FirebaseMessagingState>(
              listener: (context, state) {
                BlocProvider.of<MessageTabBloc>(context)
                    .add(UpdateChats(state.firebaseMessagesList));

                if (state.firebaseMessagesList.isNotEmpty) {
                  setState(() {
                    showChatBadge = true;
                  });
                } else {
                  setState(() {
                    showChatBadge = false;
                  });
                }
              },
            ),
            if (isAuthed)
              BlocListener<MessageTabBloc, MessageTabState>(
                listener: (context, state) {
                  if (state.newChatId != null) {
                    currentNavigator.pushNamed(
                      ChatScreen.routeName,
                      arguments: state.newChatId,
                    );
                  }
                },
              )
          ],
          child: CupertinoTabScaffold(
            controller: tabController,
            tabBar: CupertinoTabBar(
              onTap: (value) {
                if (currentIndex == tabController.index) {
                  if (currentNavigator.canPop()) {
                    currentNavigator.popUntil((route) => route.isFirst);
                  }
                }
                setState(() {
                  currentIndex = value;
                });
              },
              backgroundColor: Colors.white,
              items: _bottomNavBarIcons.map(
                (String iconImage) {
                  final index = _bottomNavBarIcons.indexOf(iconImage);
                  Widget icon = BottomNavigationBarIcon(
                    iconPath: iconImage,
                    isBadgeShow: index == 2 ? showChatBadge : false,
                  );
                  Widget activeIcon = BottomNavigationBarIcon(
                    iconPath: iconImage,
                    iconColor: AppColors.orange,
                    isBadgeShow: index == 2 ? showChatBadge : false,
                  );

                  if (index == 4) {
                    final userAvatar =
                        context.read<AuthBloc>().state.user?.image ?? '';
                    icon = BottomNavigationBarUserIcon(
                      iconImage: userAvatar,
                    );
                    activeIcon = BottomNavigationBarUserIcon(
                      iconImage: userAvatar,
                      isActive: true,
                    );
                  }

                  return BottomNavigationBarItem(
                    icon: icon,
                    activeIcon: activeIcon,
                  );
                },
              ).toList(),
            ),
            tabBuilder: (context, index) {
              return CupertinoTabView(
                navigatorKey: listOfKeys[index],
                onGenerateRoute: onGenerateRoute,
                builder: (context) {
                  if (!isAuthed) {
                    if (index != 0) {
                      return UnauthedScreen();
                    }
                  }
                  return _pages[index];
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
