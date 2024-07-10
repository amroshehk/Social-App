import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/cubit/cubit.dart';
import 'package:social_app/layouts/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        var cubit = SocialCubit.get(context);
        var profileImage = SocialCubit.get(context).profileImage;
        var backgroundProfileImage = profileImage == null && userModel != null
            ? NetworkImage(userModel.image!)
            : FileImage(profileImage!);

        var coverImage = SocialCubit.get(context).coverImage;
        var backgroundCoverImage = coverImage == null && userModel != null
            ? NetworkImage(userModel.cover!)
            : FileImage(coverImage!);

        nameController.text = userModel?.name ?? "";
        phoneController.text = userModel?.phone ?? "";
        bioController.text = userModel?.bio ?? "";

        return Scaffold(
          appBar:
              defaultAppBar(context: context, title: "Edit Profile", actions: [
            defaultTextButton(
              title: "Update",
              function: () {
                SocialCubit.get(context).updateUser(
                    name: nameController.text,
                    phone: phoneController.text,
                    bio: bioController.text);
              },
            ),
            const SizedBox(
              width: 10.0,
            )
          ]),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is SocialUserUpdateLoadingState)
                    LinearProgressIndicator(),
                  if (state is SocialUserUpdateLoadingState)
                    SizedBox(
                      height: 10.0,
                    ),
                  Container(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 140.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      4.0,
                                    ),
                                    topRight: Radius.circular(
                                      4.0,
                                    ),
                                  ),
                                  image: DecorationImage(
                                    image: backgroundCoverImage as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    cubit.getCoverImage();
                                  },
                                  icon: CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                    child: Icon(
                                      IconBroken.Camera,
                                    ),
                                  ))
                            ],
                          ),
                          alignment: AlignmentDirectional.topCenter,
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64.0,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage:
                                    backgroundProfileImage as ImageProvider,
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  cubit.getProfileImage();
                                },
                                icon: CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  child: Icon(
                                    IconBroken.Camera,
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    Row(
                      children: [
                        if (SocialCubit.get(context).profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                    function: () {
                                      SocialCubit.get(context).uploadProfileImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text,
                                      );
                                    },
                                    title: 'upload profile',
                                    radius: 40.0),
                                if (state is SocialUserUpdateLoadingState)
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                if (state is SocialUserUpdateLoadingState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if (SocialCubit.get(context).coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                    function: () {
                                      SocialCubit.get(context).uploadCoverImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text,
                                      );
                                    },
                                    title: 'upload cover',
                                    radius: 40.0),
                                if (state is SocialUserUpdateLoadingState)
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                if (state is SocialUserUpdateLoadingState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  if (SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    SizedBox(
                      height: 20.0,
                    ),
                  defaultTextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Name enter valid email";
                        } else {
                          return null;
                        }
                      },
                      labelText: "Name",
                      prefixIcon: Icon(IconBroken.User),
                      type: TextInputType.name,
                      context: context),
                  const SizedBox(
                    height: 10,
                  ),
                  defaultTextFormField(
                      controller: bioController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Bio enter valid email";
                        } else {
                          return null;
                        }
                      },
                      labelText: "Bio",
                      prefixIcon: Icon(IconBroken.Info_Circle),
                      type: TextInputType.text,
                      context: context),
                  const SizedBox(
                    height: 10,
                  ),
                  defaultTextFormField(
                      controller: phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Phone enter valid email";
                        } else {
                          return null;
                        }
                      },
                      labelText: "Phone",
                      prefixIcon: Icon(IconBroken.Call),
                      type: TextInputType.phone,
                      context: context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
