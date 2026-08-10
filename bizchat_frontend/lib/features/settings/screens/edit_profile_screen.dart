import 'dart:io';

import 'package:bizchat_frontend/app_layout.dart';
import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:bizchat_frontend/core/widget/full_screen_image_viewer.dart';
import 'package:bizchat_frontend/core/widget/scaffholdmessage.dart';
import 'package:bizchat_frontend/core/widget/screen_loader.dart';
import 'package:bizchat_frontend/core/widget/show_dialog.dart';
import 'package:bizchat_frontend/features/provider/provders.dart';
import 'package:bizchat_frontend/features/settings/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthDate = TextEditingController();
  final _profileState = TextEditingController();
  final _zipCode = TextEditingController();
  final _profileCountry = TextEditingController();
  final _profileEmail = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _address = TextEditingController();

  late final ProviderSubscription<ProfileControllerState> _subscription;

  @override
  void initState() {
    Future.microtask(() async {
      final authController = ref.read(authControllerProvider.notifier);
      await authController.getUser();

      final user = ref.read(authControllerProvider).user;

      if (user != null) {
        _firstNameController.text = user.firstName;
        _lastNameController.text = user.lastName;
        _birthDate.text = user.profile.dateOfBirth.toString();
        _profileState.text = user.profile.state ?? '';
        _zipCode.text = user.profile.zipCode ?? '';
        _profileCountry.text = user.profile.country ?? '';
        _profileEmail.text = user.email;
        _phoneNumber.text = user.profile.phoneNumber ?? '';
        _address.text = user.profile.address ?? '';
      }
    });

    _subscription = ref.listenManual<ProfileControllerState>(profileControllerProvider, (previous, next) async {
      if (!mounted) return;

      if (next.success != null) {

        scaffholdmessage(
            context: context,
            message: '${next.success}',
            type: ScaffHoldMessageType.successful
        );
      }
    });

    super.initState();
  }

  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDate.dispose();
    _profileState.dispose();
    _zipCode.dispose();
    _profileCountry.dispose();
    _profileEmail.dispose();
    _phoneNumber.dispose();
    _address.dispose();

    _subscription.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    final profileState = ref.watch(profileControllerProvider);

    if (authState.isLoading || profileState.isLoading) {
      return const ScreenLoader();
    }

    final profilePic = user?.profile.profilePicture;

    return AppLayout(
      header: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  if (_selectedImage != null) {
                    final confirmed = await showAppDialog(
                      context: context,
                      message: 'Do you want to exit without saving your data?',
                      confirmText: 'Exit',
                    );

                    if (confirmed == true) Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: SvgPicture.asset('assets/svgs/Back.svg'),
              ),

              Text(
                'Profile',
                style: TextStyle(
                  color: AppColors.secondaryWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(),
            ],
          ),

          const SizedBox(height: 20,),
        ],
      ),

      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    final ImageProvider targetImage;

                    if (profilePic != null && profilePic!.contains('http')) {
                      targetImage = NetworkImage(profilePic!);
                    } else {
                      targetImage = const AssetImage('assets/images/ph_user-light.png');
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImageViewer(imageProvider: targetImage),
                      ),
                    );
                  },
                  child: Container(
                    height: 151,
                    width: 151,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1E1E1),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _selectedImage != null
                            ? FileImage(_selectedImage!) as ImageProvider
                            : profilePic != null
                            ? NetworkImage(profilePic)
                            : const AssetImage('assets/images/ph_user-light.png'),
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  bottom: 0,
                  right: 10,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _pickImage,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryWhite,
                        borderRadius: BorderRadius.circular(100)
                      ),
                      child: SvgPicture.asset('assets/svgs/IoCamera.svg'),
                    ),
                  )
                )
              ],
            ),

            const SizedBox(height: 34,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: _editProfileTextField(
                      controller: _firstNameController,
                      hinText: 'First Name',
                      leftRowField: true,
                    )
                ),

                const SizedBox(width: 13,),

                Expanded(
                  child: _editProfileTextField(
                    controller: _lastNameController,
                    hinText: 'Last Name',
                    rightRowField: true,
                  )
                ),
              ],
            ),

            const SizedBox(height: 19,),

            _editProfileTextField(
              controller: _birthDate,
              hinText: 'Birth Date'
            ),

            const SizedBox(height: 19,),

            _editProfileTextField(
              controller: _address,
              hinText: 'Address'
            ),

            const SizedBox(height: 19,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: _editProfileTextField(
                      controller: _profileState,
                      hinText: 'State',
                      leftRowField: true,
                    )
                ),

                const SizedBox(width: 13,),

                Expanded(
                    child: _editProfileTextField(
                      controller: _zipCode,
                      hinText: 'Zip Code',
                      rightRowField: true,
                      maxLength: 4
                    )
                ),
              ],
            ),

            const SizedBox(height: 19,),

            _editProfileTextField(
                controller: _profileCountry,
                hinText: 'Country'
            ),

            const SizedBox(height: 19,),

            _editProfileTextField(
                controller: _profileEmail,
                hinText: 'Email Address'
            ),

            const SizedBox(height: 19,),

            _editProfileTextField(
              controller: _phoneNumber,
              hinText: 'Phone Number',
              maxLength: 11,
              readOnly: _phoneNumber.text.isNotEmpty,
            ),

            const SizedBox(height: 39,),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(200, 50),
                ),
                onPressed: profileState.isLoading ? null : () async {
                  await ref.read(profileControllerProvider.notifier).updateProfile(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    birthDate: _birthDate.text,
                    profileState: _profileState.text,
                    zipCode: _zipCode.text,
                    profileEmail: _profileEmail.text,
                    phoneNumber: _phoneNumber.text,
                    address: _address.text,
                    profileCountry: _profileCountry.text,
                    imagePath: _selectedImage?.path,
                  );
                },
                child: authState.isLoading ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ) :  Text(
                  'Save',
                  style: TextStyle(
                    color: AppColors.secondaryWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25,),
          ],
        ),
      )
    );
  }

  Widget _editProfileTextField({
    required TextEditingController controller,
    required String hinText,
    bool leftRowField = false,
    bool rightRowField = false,
    int? maxLength,
    bool readOnly = false
  }) {
    return TextField(
      controller: controller,
      maxLength: maxLength ?? 244,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hinText,
        counterText: "",
        contentPadding: EdgeInsets.symmetric(
          horizontal: 24, vertical: 15
        ),
        filled: true,
        fillColor: const Color(0xFFE1E1E1),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: rightRowField ? BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20)
          ) : leftRowField ? BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20)
          ) : BorderRadius.circular(20),
        ),

        focusedBorder:OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: rightRowField ? BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20)
          ) : leftRowField ? BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20)
          ) : BorderRadius.circular(20),
        )
      ),
    );
  }
}
