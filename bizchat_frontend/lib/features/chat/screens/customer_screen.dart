import 'package:bizchat_frontend/app_layout.dart';
import 'package:bizchat_frontend/core/helper/bottom_nav_helper.dart';
import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:bizchat_frontend/features/chat/widget/chat_list_widget.dart';
import 'package:bizchat_frontend/features/provider/provders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomerScreen extends ConsumerStatefulWidget {
  const CustomerScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ConsumerState<CustomerScreen> {
  final _phoneSearchFieldController = TextEditingController();

  final FocusNode _phoneSearchFieldFocusNode = FocusNode();

  bool isSearching = false;
  bool isAddingUserNo = false;
  bool phoneFieldIsEmpty = true;

  void _searchCustomerController() {
    setState(() {
      isSearching != isSearching;
    });
  }

  void _addUserController() {
    setState(() {
      isAddingUserNo = true;
    });
  }

  bool _loaded = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(chatRoomsControllerProvider.notifier).clearError();

      if (_loaded) return;
      _loaded = true;

      ref.read(authControllerProvider.notifier).getUser();
      ref.read(chatRoomsControllerProvider.notifier).getUserChatListRooms();
    });
  }

  void _searchUserByPhoneNumberListener() {
    if (_phoneSearchFieldController.text.isNotEmpty) {
      setState(() {
        phoneFieldIsEmpty == false;
      });
    } else {
      setState(() {
        phoneFieldIsEmpty == true;
      });
    }

    if (
      _phoneSearchFieldController.text.isNotEmpty &&
      _phoneSearchFieldController.text.length == 11 &&
      isAddingUserNo == true
    ) {
      ref.read(
        chatRoomsControllerProvider.notifier
      ).searchUserByPhoneNo(_phoneSearchFieldController.text);
    }
  }

  @override
  void dispose() {
    _phoneSearchFieldFocusNode.dispose();
    _phoneSearchFieldController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final chatRooms = ref.watch(chatRoomsControllerProvider);

    return isAddingUserNo ?
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              _phoneSearchFieldController.clear();
              ref.read(chatRoomsControllerProvider.notifier).clearPhoneSearch();

              setState(() {
                isAddingUserNo = false;
              });
            },
            icon: SvgPicture.asset(
              'assets/svgs/Back.svg',
              color: Colors.black,
            ),
          ),
          title: Text(
            "Search & Chat Customer",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 17, vertical: 24),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.circular(8.0),
                  color: AppColors.secondaryGray4,
                  child: InkWell(
                    onTap: () => FocusScope.of(context).requestFocus(_phoneSearchFieldFocusNode),
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 44,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: AppColors.secondaryGray4,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/Search.svg',
                            height: 24,
                            width: 24,
                            color: AppColors.secondaryBlack,
                          ),

                          const SizedBox(
                            width: 20,
                          ),

                          /// User input
                          Expanded(
                            child: TextField(
                              controller: _phoneSearchFieldController,
                              focusNode: _phoneSearchFieldFocusNode,
                              onChanged: (value) => _searchUserByPhoneNumberListener(),
                              maxLength: 11,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.secondaryBlack,
                              ),
                              decoration: InputDecoration(
                                filled: false,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 0),
                                counterText: "",
                                hintText: "Search number...",
                                hintStyle: TextStyle(
                                  color: AppColors.secondaryWhiteGrey
                                )
                              ),
                            ),
                          ),
                          /// User input ends

                          const SizedBox(
                            width: 20,
                          ),

                          GestureDetector(
                            onTap: () => _phoneSearchFieldController.clear(),
                            child: SvgPicture.asset(
                              'assets/svgs/remove.svg',
                              height: 24,
                              width: 24,
                              color: AppColors.secondaryBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20,),

                /// content
                if (chatRooms.simpleUser != null && _phoneSearchFieldController.text.isNotEmpty)
                  ChatListWidget(
                    userId: chatRooms.simpleUser!.id,
                    userName: '${chatRooms.simpleUser?.firstName} ${chatRooms.simpleUser?.lastName}',
                    userProfilePic: (chatRooms.simpleUser!.profilePicture != null
                      && chatRooms.simpleUser!.profilePicture!.isNotEmpty)
                      ? NetworkImage("${chatRooms.simpleUser?.profilePicture}") as ImageProvider
                      : const AssetImage('assets/images/ph_user-light.png') as ImageProvider,
                  ),

                if (chatRooms.simpleUser == null && _phoneSearchFieldController.text.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text("___ No user found yet ___"),
                    ),
                  )
              ],
            ),
          )
        ),
      )
    : AppLayout(
      useBottomNav: true,
      currentIndex: 1,
      onTabSelected: (index) {
        BottomNavHelper.navigate(context, index);
      },
      header: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _searchCustomerController,
            child: Container(
              padding: EdgeInsets.all(11),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.secondaryWhiteGrey
                  ),
                  borderRadius: BorderRadius.circular(100)
              ),
              child: SvgPicture.asset('assets/svgs/Search.svg', height: 24, width: 24,),
            ),
          ),

          const Text(
            'Customers',
            style: TextStyle(
              color: AppColors.secondaryWhite,
              fontSize: 20,
              fontWeight: FontWeight.w500
            ),
          ),

          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _addUserController,
            child: Container(
              padding: EdgeInsets.all(11),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.secondaryWhiteGrey
                  ),
                  borderRadius: BorderRadius.circular(100)
              ),
              child: SvgPicture.asset('assets/svgs/user-add.svg', height: 24, width: 24,),
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            width: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFE6E6E6),
              borderRadius: BorderRadius.circular(100),
            ),
          ),

          const SizedBox(height: 24,),

          (chatRooms.rooms == null || chatRooms.rooms!.isEmpty)
              ? const Expanded(
            child: Center(
              child: Text(
                'No chats yet',
                style: TextStyle(
                  color: AppColors.secondaryBlack2,
                  fontSize: 16,
                ),
              ),
            ),
          )

              : Expanded(
            child: ListView.separated(
              itemCount: chatRooms.isLoadingRooms == false ? chatRooms.rooms!.length : 10,
              separatorBuilder: (context, index) => const SizedBox(height: 30,),
              itemBuilder: (context, index) {
                if (chatRooms.isLoadingRooms) {
                  return ChatListWidget(isLoadingItem: chatRooms.isLoadingRooms, userName: '', userProfilePic: null, userId: null,);
                }

                final room = chatRooms.rooms![index];
                final chatUser = room.participant;

                final ImageProvider profileImage = (chatUser?.profilePicture != null && chatUser!.profilePicture!.isNotEmpty)
                    ? NetworkImage(chatUser.profilePicture!)
                    : const AssetImage('assets/images/ph_user-light.png');

                return ChatListWidget(
                  isLoadingItem: chatRooms.isLoadingRooms,
                  userId: chatUser!.id,
                  userName: '${chatUser.firstName} ${chatUser.lastName}',
                  userLastMessage: room.lastMessage,
                  userProfilePic: profileImage,
                  userLastMessageTimeOrDate: "${room.lastMessageTime}",
                );
              },
            ),
          ),
        ],
      )
    );
  }
}
