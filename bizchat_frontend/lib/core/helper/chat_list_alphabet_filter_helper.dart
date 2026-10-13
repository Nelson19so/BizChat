// enum ChatListItemType {header, room}
//
// class ChatListAlphabetFilterHelper {
//   final ChatListItemType type;
//   final String? headerTitle;
//   final RoomListItem? roomListItem;
// }
//
// List<ChatListAlphabetFilterHelper> buildAlphabeticalChatList(List<RoomList> rooms) {
//   rooms.sort((a, b)) {
//     String nameA = a.participant?.firstName ?? '';
//     String nameB = b.participant?.firstName ?? '';
//     return nameA.compareTo(nameB);
//   }
// }
//
// List<ChatListAlphabetFilterHelper> displayList = [];
// String? currentLetter;
//
// for (var room in rooms) {
//  
// }