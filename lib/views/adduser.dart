import 'package:fbasedbtuto/state/userstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddUser extends HookConsumerWidget {
  const AddUser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController name = useTextEditingController();
    TextEditingController email = useTextEditingController();
    final userStateW = ref.watch(userState);
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: const Color(0xfff43f5e),
        centerTitle: true,
        title: const Text(
          "Add User",
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6)
              ],
              gradient: const LinearGradient(
                colors: [
                  Color(0xff22d3ee),
                  Color(0xff0284c7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Add New User",
                      textScaleFactor: 1,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                TextField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  controller: name,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                    ),
                    hintText: "Enter Name...",
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.mail_outlined,
                      color: Colors.white,
                    ),
                    hintText: "Enter Email...",
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
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
                        onPressed: () {
                          userStateW.addUser(context, name.text, email.text);
                          name.clear();
                          email.clear();
                        },
                        child: const Text(
                          "ADD",
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
                        onPressed: () {
                          name.clear();
                          email.clear();
                        },
                        child: const Text(
                          "RESET",
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