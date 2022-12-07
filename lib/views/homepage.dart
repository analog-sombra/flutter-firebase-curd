import 'package:fbasedbtuto/components/alerts.dart';
import 'package:fbasedbtuto/views/adduser.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../state/userstate.dart';
import 'edituser.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userstreamW = ref.watch(usersStream);

    return WillPopScope(
      onWillPop: () async {
        exitAlert(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffd1d5db),
        appBar: AppBar(
          backgroundColor: const Color(0xfff43f5e),
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
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff10b981),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddUser(),
              ),
            );
          },
          child: const Icon(Icons.person_add),
        ),
        body: SafeArea(
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
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              "No User Exist in database",
                              textScaleFactor: 1,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.size,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 6,
                          ),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.docs[index]["name"],
                                      textScaleFactor: 1,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      data.docs[index]["email"],
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black.withOpacity(0.65),
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
                                        id: data.docs[index].id,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit),
                                color: const Color(0xff06b6d4),
                              ),
                              IconButton(
                                onPressed: () {
                                  deleteAlert(
                                    context,
                                    ref,
                                    data.docs[index]["name"],
                                    data.docs[index].id,
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color(0xffef4444),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
              error: ((error, stackTrace) => const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Center(
                      child: Text(
                        "Something went wrong please try again",
                        textScaleFactor: 1,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )),
              loading: () => const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
