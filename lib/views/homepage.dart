import 'package:cached_network_image/cached_network_image.dart';
import 'package:fbasedbtuto/components/alerts.dart';
import 'package:fbasedbtuto/views/adduser.dart';
import 'package:fbasedbtuto/views/seach.dart';
import 'package:fbasedbtuto/views/userinfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../state/multiseclectstate.dart';
import '../state/userstate.dart';
import '../theme.dart';
import 'edituser.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userstreamW = ref.watch(usersStream);
    final themeW = ref.watch(appTheme);
    final userStateW = ref.watch(userState);
    final multiSelectStateW = ref.watch(multiSelectState);
    TextEditingController search = useTextEditingController();
    ValueNotifier<bool> isLoading = useState(true);
    void init() async {
      await themeW.loadTheme();
      final usercount = await userStateW.getUserCount();
      multiSelectStateW.init(usercount);
      isLoading.value = false;
    }

    useEffect(() {
      init();
      return null;
    }, []);

    return WillPopScope(
      onWillPop: () async {
        exitAlert(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: themeW.backgroundColor,
        appBar: AppBar(
          leading: InkWell(
            onTap: () async {
              if (themeW.isLight) {
                await themeW.setDarkTheme();
              } else {
                await themeW.setLightTheme();
              }
            },
            child: themeW.isLight
                ? Icon(
                    CupertinoIcons.sun_max_fill,
                    color: themeW.iconColor,
                  )
                : Icon(
                    CupertinoIcons.moon_fill,
                    color: themeW.iconColor,
                  ),
          ),
          backgroundColor: themeW.primaryColor,
          centerTitle: true,
          title: const Text(
            "Flutter Firebase CURD",
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          actions: [
            if (multiSelectStateW.isMultiSelect) ...[
              IconButton(
                onPressed: () async {
                  multiSelectStateW
                      .clearSelection(await userStateW.getUserCount());
                },
                icon: Icon(
                  Icons.cancel_outlined,
                  color: themeW.iconColor,
                ),
              )
            ] else ...[
              IconButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SeachPage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.search,
                  color: themeW.iconColor,
                ),
              )
            ]
          ],
        ),
        floatingActionButton: isLoading.value
            ? null
            : FloatingActionButton(
                backgroundColor: themeW.primaryColor,
                onPressed: () async {
                  if (multiSelectStateW.isMultiSelect) {
                    deleteMulAlert(context, ref, isLoading);
                    isLoading.value = false;
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddUser(),
                      ),
                    );
                  }
                },
                child: Icon(
                  multiSelectStateW.isMultiSelect
                      ? Icons.delete
                      : Icons.person_add,
                  color: Colors.white,
                ),
              ),
        body: isLoading.value
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: CircularProgressIndicator()),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: userstreamW.when(
                    data: ((data) => Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            if (data.docs.isEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                  child: Text(
                                    "No User Exist in database",
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: themeW.textColor,
                                    ),
                                  ),
                                ),
                              ),
                            ] else
                              ...[],
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.size,
                              itemBuilder: (context, index) => InkWell(
                                onLongPress: () {
                                  if (!multiSelectStateW.isMultiSelect) {
                                    multiSelectStateW.setMultSel(true);
                                    multiSelectStateW.setValue(
                                      index,
                                      true,
                                      data.docs[index].id,
                                      data.docs[index]["avatar"].toString(),
                                    );
                                  }
                                },
                                onTap: () {
                                  if (multiSelectStateW.isMultiSelect) {
                                    multiSelectStateW.setValue(
                                      index,
                                      !multiSelectStateW.selectedItem[index],
                                      data.docs[index].id,
                                      data.docs[index]["avatar"].toString(),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserInto(
                                          id: data.docs[index].id,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      if (multiSelectStateW.isMultiSelect) ...[
                                        SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: Checkbox(
                                            value: multiSelectStateW
                                                .selectedItem[index],
                                            onChanged: ((value) {
                                              multiSelectStateW.setValue(
                                                index,
                                                !multiSelectStateW
                                                    .selectedItem[index],
                                                data.docs[index].id,
                                                data.docs[index]["avatar"]
                                                    .toString(),
                                              );
                                            }),
                                          ),
                                        ),
                                      ],
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal:
                                                multiSelectStateW.isMultiSelect
                                                    ? 5
                                                    : 15,
                                            vertical: 6,
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color:
                                                themeW.secondryBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Hero(
                                                tag: "avatar",
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: InkWell(
                                                    onTap: () {
                                                      imageAlert(
                                                        context,
                                                        data.docs[index]
                                                                ["avatar"]
                                                            .toString(),
                                                      );
                                                    },
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child: CachedNetworkImage(
                                                        imageUrl: data
                                                            .docs[index]
                                                                ["avatar"]
                                                            .toString(),
                                                        progressIndicatorBuilder:
                                                            (context, url,
                                                                    downloadProgress) =>
                                                                Center(
                                                          child: CircularProgressIndicator(
                                                              value:
                                                                  downloadProgress
                                                                      .progress),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          "assets/images/avatar.png",
                                                          fit: BoxFit.cover,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Hero(
                                                      tag: "name",
                                                      child: Text(
                                                        data.docs[index]
                                                            ["name"],
                                                        textScaleFactor: 1,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              themeW.textColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Hero(
                                                      tag: "email",
                                                      child: Text(
                                                        data.docs[index]
                                                            ["email"],
                                                        textScaleFactor: 1,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              themeW.textColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (!multiSelectStateW
                                                  .isMultiSelect) ...[
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditUser(
                                                          id: data
                                                              .docs[index].id,
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
                                                        data.docs[index]
                                                            ["name"],
                                                        data.docs[index].id,
                                                        data.docs[index]
                                                            ["avatar"]);
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: themeW.primaryColor,
                                                  ),
                                                ),
                                              ],
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
                    error: ((error, stackTrace) => Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              "Something went wrong please try again",
                              textScaleFactor: 1,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: themeW.primaryColor,
                              ),
                            ),
                          ),
                        )),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
