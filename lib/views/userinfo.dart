import 'package:cached_network_image/cached_network_image.dart';
import 'package:fbasedbtuto/theme.dart';
import 'package:fbasedbtuto/views/edituser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/alerts.dart';
import '../state/userstate.dart';

class UserInto extends HookConsumerWidget {
  const UserInto({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeW = ref.watch(appTheme);

    final userStateW = ref.watch(userState);
    ValueNotifier<bool> isLoading = useState(true);
    ValueNotifier<dynamic> user = useState<dynamic>(null);

    void init() async {
      final userdata = await userStateW.getUserById(context, id);
      user.value = userdata.data();

      isLoading.value = false;
    }

    useEffect(() {
      init();
      return null;
    }, []);
    return Scaffold(
      backgroundColor: themeW.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeW.primaryColor,
        centerTitle: true,
        title: const Text(
          "User Info",
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading.value
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          : SafeArea(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        themeW.isLight ? null : themeW.secondryBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2), blurRadius: 6)
                    ],
                    gradient: themeW.isLight
                        ? const LinearGradient(
                            colors: [
                              Color(0xff0284c7),
                              Color(0xff22d3ee),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Hero(
                        tag: "avatar",
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: (userStateW.imageFile == null)
                                  ? CachedNetworkImage(
                                      imageUrl: user.value["avatar"].toString(),
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Center(
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        "assets/images/avatar.png",
                                        fit: BoxFit.cover,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      userStateW.imageFile!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Hero(
                        tag: "name",
                        child: Center(
                          child: Text(
                            user.value["name"],
                            textScaleFactor: 1,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Hero(
                        tag: "email",
                        child: Center(
                          child: Text(
                            user.value["email"],
                            textScaleFactor: 1,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff22c55e)),
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditUser(
                                      id: id,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "UPDATE",
                                textScaleFactor: 1,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xfff43f5e)),
                              onPressed: () async {
                                deleteAlert(
                                  context,
                                  ref,
                                  user.value["name"],
                                  id,
                                  user.value["avatar"],
                                );
                              },
                              child: const Text(
                                "Delete",
                                textScaleFactor: 1,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
