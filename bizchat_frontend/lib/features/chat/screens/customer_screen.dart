import 'package:bizchat_frontend/app_layout.dart';
import 'package:bizchat_frontend/core/helper/bottom_nav_helper.dart';
import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:bizchat_frontend/core/widget/scaffholdmessage.dart';
import 'package:bizchat_frontend/features/chat/chat_state/chat_rooms_state.dart';
import 'package:bizchat_frontend/features/chat/widget/chat_list_widget.dart';
import 'package:bizchat_frontend/features/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/grouped_list.dart';

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
  bool _loaded = false;
  bool _loadedError = false;
  bool _canShowSearchMessage = true;
  String _error = "";

  late final ProviderSubscription<ChatRoomsState> _subscription;

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

  void _searchPhoneNumberListener() {
    final phoneField = _phoneSearchFieldController.text.trim();

    if (phoneField.isEmpty) {
      setState(() {
        _canShowSearchMessage = true;
      });
    } else {
      setState(() {
        _canShowSearchMessage = false;
      });
    }
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

    if (_phoneSearchFieldController.text.isNotEmpty &&
        _phoneSearchFieldController.text.length == 11 &&
        isAddingUserNo == true) {
      ref
          .read(chatRoomsControllerProvider.notifier)
          .searchUserByPhoneNo(_phoneSearchFieldController.text);

      setState(() {
        _loadedError = false;
      });
    }
  }

  void _clearSearchPhoneAddAppBar() {
    _phoneSearchFieldController.clear();
    final chatRoomController = ref.read(chatRoomsControllerProvider.notifier);

    chatRoomController.clearPhoneSearch();
    chatRoomController.clearError();

    setState(() {
      isAddingUserNo = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _phoneSearchFieldController.addListener(_searchPhoneNumberListener);

    Future.microtask(() {
      final chatRoomController = ref.read(chatRoomsControllerProvider.notifier);

      if (_loaded) return;
      _loaded = true;

      ref.read(authControllerProvider.notifier).getUser();
      ref.read(chatRoomsControllerProvider.notifier).getUserChatListRooms();

      chatRoomController.clearPhoneSearch();
      chatRoomController.clearError();
    });

    _subscription = ref.listenManual<ChatRoomsState>(
      chatRoomsControllerProvider,
      (prev, next) async {
        if (!mounted) return;

        if (_loadedError) return;
        _loadedError = true;

        if (next.isLoadingRooms == false && next.error != null) {
          _error = next.error!;

          scaffholdmessage(
            context: context,
            message: _error,
            type: ScaffHoldMessageType.failed,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _phoneSearchFieldFocusNode.dispose();
    _phoneSearchFieldController.dispose();

    _phoneSearchFieldController.removeListener(_searchPhoneNumberListener);

    _subscription.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatRooms = ref.watch(chatRoomsControllerProvider);

    return isAddingUserNo
        ? _addUserPhoneNumberWidget(
            phoneSearchFieldController: _phoneSearchFieldController,
            ref: ref,
            clearSearchPhoneAddAppBar: _clearSearchPhoneAddAppBar,
            textFieldClick: () =>
                FocusScope.of(context).requestFocus(_phoneSearchFieldFocusNode),
            phoneSearchFieldFocusNode: _phoneSearchFieldFocusNode,
            searchUserByPhoneNumberListener: _searchUserByPhoneNumberListener,
            chatRooms: chatRooms,
            canShowSearchMessage: _canShowSearchMessage,
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
                      border: Border.all(color: AppColors.secondaryWhiteGrey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: SvgPicture.asset(
                      'assets/svgs/Search.svg',
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),

                const Text(
                  'Customers',
                  style: TextStyle(
                    color: AppColors.secondaryWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _addUserController,
                  child: Container(
                    padding: EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.secondaryWhiteGrey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: SvgPicture.asset(
                      'assets/svgs/user-add.svg',
                      height: 24,
                      width: 24,
                    ),
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

                const SizedBox(height: 24),

                (chatRooms.rooms == null || chatRooms.rooms!.isEmpty)
                    ? const Expanded(
                        child: Center(
                          child: Text(
                            'No Message found yet',
                            style: TextStyle(
                                color: AppColors.secondaryWhiteGrey,
                                fontSize: 12,
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ),
                      )
                    : chatRooms.isLoadingRooms
                    ? Expanded(
                        child: ListView.separated(
                            separatorBuilder: (context, index) => const Divider(height: 12, thickness: 0.5, indent: 80, color: Colors.transparent,),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return ChatListWidget(
                                isLoadingItem: chatRooms.isLoadingRooms,
                                userName: '',
                                userProfilePic: null,
                                userId: null,
                              );
                            }
                        ),
                      )
                    : Expanded(
                        child: GroupedListView<dynamic, String>(
                          elements: chatRooms.rooms ?? [],
                          groupBy: (room) {
                            final chatUser = room.participant;
                            final name = chatUser != null
                                ? '${chatUser.firstName}'
                                : 'Other';
                            return name.isNotEmpty
                                ? name[0].toUpperCase()
                                : '#';
                          },

                          useStickyGroupSeparators: false,

                          groupComparator: (value1, value2) =>
                              value1.compareTo(value2),

                          itemComparator: (room1, room2) {
                            final name1 = room1.participant?.firstName ?? '';
                            final name2 = room2.participant?.firstName ?? '';
                            return name1.compareTo(name2);
                          },

                          groupSeparatorBuilder: (String firstLetter) => Container(
                            color: Colors.transparent,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: Text(
                                firstLetter,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),

                          itemBuilder: (context, room) {
                            final chatUser = room.participant;

                            final ImageProvider profileImage =
                                (chatUser?.profilePicture != null &&
                                    chatUser!.profilePicture!.isNotEmpty)
                                ? NetworkImage(chatUser.profilePicture!)
                                : const AssetImage(
                                    'assets/images/ph_user-light.png',
                                  );

                            return Column(
                              children: [
                                ChatListWidget(
                                  isLoadingItem: chatRooms.isLoadingRooms,
                                  userId: chatUser!.id,
                                  userName: '${chatUser.firstName} ${chatUser.lastName}',
                                  userLastMessage: "",
                                  userProfilePic: profileImage,
                                  userLastMessageTimeOrDate: "",
                               ),

                                const Divider(height: 12, thickness: 0.5, indent: 80, color: Colors.transparent,),                              ],
                            );
                          },
                        ),
                      ),
              ],
            ),
          );
  }
}

Widget _addUserPhoneNumberWidget({
  required TextEditingController phoneSearchFieldController,
  required FocusNode phoneSearchFieldFocusNode,
  required ref,
  required dynamic clearSearchPhoneAddAppBar,
  required dynamic textFieldClick,
  required dynamic searchUserByPhoneNumberListener,
  required ChatRoomsState chatRooms,
  required bool canShowSearchMessage,
}) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: clearSearchPhoneAddAppBar,
        icon: SvgPicture.asset('assets/svgs/Back.svg', color: Colors.black),
      ),
      title: Text("Search & Chat Customer", style: TextStyle(fontSize: 16)),
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
                onTap: textFieldClick,
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

                      const SizedBox(width: 20),

                      /// User input
                      Expanded(
                        child: TextField(
                          controller: phoneSearchFieldController,
                          focusNode: phoneSearchFieldFocusNode,
                          onChanged: (value) =>
                              searchUserByPhoneNumberListener(),
                          maxLength: 11,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
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
                              color: AppColors.secondaryWhiteGrey,
                            ),
                          ),
                        ),
                      ),

                      /// User input ends
                      const SizedBox(width: 20),

                      GestureDetector(
                        onTap: () => phoneSearchFieldController.clear(),
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

            const SizedBox(height: 20),

            /// content
            if (phoneSearchFieldController.text.isNotEmpty && phoneSearchFieldController.text.length == 11)
              ChatListWidget(
                userId: chatRooms.simpleUser?.id,
                isLoadingItem: chatRooms.isLoadingRooms,
                userName:
                    '${chatRooms.simpleUser?.firstName} ${chatRooms.simpleUser?.lastName}',
                userProfilePic: (
                    chatRooms.simpleUser?.profilePicture != null
                )
                    ? NetworkImage("${chatRooms.simpleUser?.profilePicture}")
                          as ImageProvider
                    : const AssetImage('assets/images/ph_user-light.png')
                          as ImageProvider,
              ),

            if (chatRooms.simpleUser == null && canShowSearchMessage)
              Expanded(child: Center(child: Text("Search is Empty"))),
          ],
        ),
      ),
    ),
  );
}
