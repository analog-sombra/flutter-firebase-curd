import 'package:fbasedbtuto/components/buttons.dart';
import 'package:fbasedbtuto/state/userstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../theme.dart';

class AddUser extends HookConsumerWidget {
  const AddUser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> formKey =
        useMemoized(() => GlobalKey<FormState>());
    TextEditingController name = useTextEditingController();
    TextEditingController email = useTextEditingController();
    ValueNotifier<bool> isLoading = useState(false);
    final userStateW = ref.watch(userState);
    final themeW = ref.watch(appTheme);

    return Scaffold(
      backgroundColor: themeW.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeW.primaryColor,
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
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
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
                          Center(
                            child: InkWell(
                              onTap: () {
                                userStateW.pickImage(context);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: (userStateW.imageFile == null)
                                      ? Image.asset(
                                          "assets/images/avatar.png",
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
                          if (userStateW.imageFile != null) ...[
                            const SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Text(
                                userStateW.imageFile!.path
                                    .toString()
                                    .split("/")
                                    .last,
                                textScaleFactor: 1,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == "") {
                                return "Please enter the name";
                              } else if (value.toString().length < 2) {
                                return "Name should be more then 3 letters";
                              } else if (value.toString().length > 10) {
                                return "Name should be less then 10 letters";
                              } else if (!RegExp(r"^[a-zA-Z0-9]+$")
                                  .hasMatch(value)) {
                                return "Name should not contain special characters";
                              }
                              return null;
                            },
                            maxLength: 10,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            controller: name,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.red.withOpacity(0.85),
                                fontWeight: FontWeight.w500,
                              ),
                              counterText: "",
                              prefixIcon: const Icon(
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
                          TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == "") {
                                return "Please enter the email";
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                  .hasMatch(value)) {
                                return "Your email is not valid, Try again...";
                              }
                              return null;
                            },
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            controller: email,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.mail_outlined,
                                color: Colors.white,
                              ),
                              errorStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.red.withOpacity(0.85),
                                fontWeight: FontWeight.w500,
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
                                child: CusBtn(
                                  btnColor: const Color(0xff22c55e),
                                  btnText: "ADD",
                                  textSize: 16,
                                  btnFunction: () async {
                                    if (formKey.currentState!.validate()) {
                                      isLoading.value = true;
                                      await userStateW.addUser(
                                          context, name.text, email.text);
                                      isLoading.value = false;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: CusBtn(
                                  btnColor: const Color(0xfff43f5e),
                                  btnText: "RESET",
                                  textSize: 16,
                                  btnFunction: () {
                                    name.clear();
                                    email.clear();
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
