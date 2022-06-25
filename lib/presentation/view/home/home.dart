import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:mvideo/business_login/auth_cubit/auth_cubit.dart';
import 'package:mvideo/business_login/home_cubit/home_cubit.dart';
import 'package:mvideo/presentation/view/home/home_widgets/home_drawer.dart';
import 'package:mvideo/presentation/view/home/home_widgets/video_bottom_nav.dart';
import 'package:mvideo/presentation/view/home/home_widgets/video_item.dart';
import 'package:mvideo/presentation/view/profile/profie.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  HomeCubit? homeCubit;

  @override
  void initState() {
    secureScreen();
    WidgetsBinding.instance?.addObserver(this);
    Future.delayed(const Duration(milliseconds: 100), () {
      homeCubit = BlocProvider.of<HomeCubit>(context);
      homeCubit?.videoLoad();
      homeCubit?.requestStoragePermission();
      BlocProvider.of<AuthCubit>(context).getProfile();
    });

    super.initState();
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> secureScreenClear() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}

    if (state == AppLifecycleState.inactive) {
      homeCubit?.deleteDecDir();
    }

    if (state == AppLifecycleState.detached) {
      homeCubit?.deleteDecDir();
    }

    if (state == AppLifecycleState.paused) {
      homeCubit?.deleteDecDir();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    secureScreenClear();
    homeCubit?.onClose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu));
          }),
          title: const Text("Mvideo"),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Profile()));
              },
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: size.height * 0.018,
                    width: size.width * 0.1,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image:
                                NetworkImage('${state.userModel!.imageLink}'),
                            fit: BoxFit.cover)),
                  );
                },
              ),
            )
          ],
        ),
        drawer: homeDrawer(size: size, context: context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // video box
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    SizedBox(
                      height: size.height * 0.27,
                      child:
                          FlickVideoPlayer(flickManager: state.flickManager!),
                    ),
                    state.isLoading!
                        ? Container(
                            height: size.height * 0.27,
                            width: size.width,
                            color: Colors.black,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                );
              },
            ),

            videoBottomNav(context, size),

            // video list

            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return Expanded(
                    child: ListView.builder(
                        itemCount: state.videos?.length,
                        itemBuilder: (context, index) {
                          return videoItem(context,
                              size: size,
                              videoModel: state.videos![index],
                              active: (index == state.activeVideo), onTap: () {
                            homeCubit?.videoItemPlay(index: index);
                          });
                        }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
