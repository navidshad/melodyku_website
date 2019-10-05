/// {@nodoc}
library types;

enum ClickType {switchable, trigger}
enum ArchiveTypes {song, album, artist, playlist}
enum MessageType {player, modal, appshell, toast}
enum Direction {ltr, rtl}

enum ItemMenuAction {like, share}

enum MenuPosition {mainMenuDrawer, profileDrawer, none}

enum PermissionType{
  anonymous_access,
  customer_access,
  archive_manager,
  categorizing,
  user_manager,
  quality_management,
  advanced_settings,
}