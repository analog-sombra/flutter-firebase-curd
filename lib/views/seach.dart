import 'package:cached_network_image/cached_network_image.dart';
import 'package:fbasedbtuto/components/alerts.dart';
import 'package:fbasedbtuto/views/adduser.dart';
import 'package:fbasedbtuto/views/userinfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../state/multiseclectstate.dart';
import '../state/userstate.dart';
import '../theme.dart';
import 'edituser.dart';

class SeachPage extends HookConsumerWidget {
  const SeachPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeW = ref.watch(appTheme);
    final userStateW = ref.watch(userState);
    TextEditingController search = useTextEditingController();
    ValueNotifier<bool> isLoading = useState(true);
    void init() async {
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
          "Search User",
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading.value
          ? const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            )
          : SafeArea(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                // if (userStateW.seachList.isEmpty) ...[
                //   Padding(
                //     padding: const EdgeInsets.all(15.0),
                //     child: Center(
                //       child: Text(
                //         "No User Exist in database",
                //         textScaleFactor: 1,
                //         style: TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.w400,
                //           color: themeW.textColor,
                //         ),
                //       ),
                //     ),
                //   ),
                // ] else ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: TextFormField(
                      maxLength: 20,
                      style: TextStyle(
                        color: themeW.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (value) async {
                        await userStateW.search(value);
                      },
                      controller: search,
                      decoration: InputDecoration(
                        counterText: "",
                        prefixIcon: Icon(
                          Icons.search,
                          color: themeW.textColor,
                        ),
                        hintText: "Start typing to search...",
                        hintStyle: TextStyle(
                          color: themeW.textColor,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: themeW.secondryBackgroundColor,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                // ],
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: userStateW.seachList.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserInto(
                            id: userStateW.seachList[index].id,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 6,
                              ),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: themeW.secondryBackgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      onTap: () {
                                        imageAlert(
                                          context,
                                          userStateW.seachList[index]["avatar"]
                                              .toString(),
                                        );
                                      },
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CachedNetworkImage(
                                          imageUrl: userStateW.seachList[index]
                                                  ["avatar"]
                                              .toString(),
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            "assets/images/avatar.png",
                                            fit: BoxFit.cover,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          userStateW.seachList[index]["name"],
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: themeW.textColor,
                                          ),
                                        ),
                                        Text(
                                          userStateW.seachList[index]["email"],
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: themeW.textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditUser(
                                            id: userStateW.seachList[index].id,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                    color: themeW.primaryColor,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      deleteAlert(
                                          context,
                                          ref,
                                          userStateW.seachList[index]["name"],
                                          userStateW.seachList[index].id,
                                          userStateW.seachList[index]
                                              ["avatar"]);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: themeW.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
    );
  }
}
