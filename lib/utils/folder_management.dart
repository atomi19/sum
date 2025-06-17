import 'package:sum/utils/calculator_utils.dart';

const String foldersKey = 'folders';

Map<String, dynamic> createFolder(List<Map<String,dynamic>> folders, String folderName) {
  return {
    'id': generateId(folders),
    'folderName': folderName,
  };
}

// add folder to folders in shared_preferences
void addFolder(List<Map<String,dynamic>> folders, String folderName) {
  if(folderName.trim().isNotEmpty) {
    folders.add(createFolder(folders, folderName));
    saveData(foldersKey, folders);
  }
}

// rename folder by its id
void renameFolder(List<Map<String, dynamic>> folders, int folderId, String newName) {
  final folder = folders.firstWhere((folder) => folder['id'] == folderId);
  folder['folderName'] = newName;
  saveData(foldersKey, folders);
}

// delete folder by folder id
void deleteFolder(List<Map<String, dynamic>> folders, int folderId) {
  folders.removeWhere((folder) => folder['id'] == folderId);
  saveData(foldersKey, folders);
}