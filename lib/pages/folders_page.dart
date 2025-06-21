import 'package:flutter/material.dart';
import 'package:sum/utils/folder_management.dart';

class FoldersPage extends StatefulWidget {
  final List<Map<String, dynamic>> folders;
  final void Function(int) changeCurrentFolderId;
  final void Function(String) changeAppTitle;

  const FoldersPage({
    super.key,
    required this.folders,
    required this.changeCurrentFolderId,
    required this.changeAppTitle,
  });

  @override
  State<FoldersPage> createState() => _FoldersPageState();
}

class _FoldersPageState extends State<FoldersPage> {
  final TextEditingController _folderController = TextEditingController();

  void _showFolderDialog({
    required String title,
    required String confirmButtonLabel,
    required Function() onTap,
  }) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(title),
        content: TextField(
          controller: _folderController,
          autofocus: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Theme.of(context).disabledColor)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Theme.of(context).disabledColor)),
            hintText: 'Folder name',
            hintStyle: TextStyle(
              color: Theme.of(context).disabledColor
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.bodyMedium,
            ),
            child: const Text('Cancel')
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onTap();
            },
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.bodyMedium,
            ),
            child: Text(confirmButtonLabel)
          )
        ],
      )
    );
  }

  // showFolder for deleting folder 
  void _showDeleteFolderDialog(int folderId) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text('Delete folder'),
        content: const Text('The folder will be deleted, but its items will stay in "All history"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.bodyMedium,
            ),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                deleteFolder(widget.folders, folderId);
              });
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              textStyle: Theme.of(context).textTheme.bodyMedium,
            ),
            child: const Text('OK'),
          ),
        ],
      )
    );
  }

  // show action for folder (rename, delete)
  void _showMoreFoldersSheet(int folderId) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.drive_file_rename_outline),
                title: const Text('Rename'),
                onTap: () {
                  Navigator.pop(context);
                  _showFolderDialog(title: 'Rename folder', confirmButtonLabel: 'Rename', onTap: () {
                    setState(() {
                      renameFolder(widget.folders, folderId, _folderController.text);
                    });
                    _folderController.clear();
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder_off_outlined, color: Colors.red),
                title: const Text('Delete folder', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteFolderDialog(folderId);
                },
              ),
            ],
          )
        );
      }
    );
  }

  Widget _buildFolderCard({
    int? index,
    required Function onTap,
    Function? onLongPress,
    }) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: const Icon(Icons.folder_outlined),
        title: index != null ? Text(widget.folders[index]['folderName']) : const Text('All history'),
        onTap: () => onTap(),
        onLongPress: onLongPress != null ? () => onLongPress() : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // app bar
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 1.0,
                  )
                )
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Folders', style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () => _showFolderDialog(title: 'Create folder', confirmButtonLabel: 'Create', onTap: () {
                      setState(() {
                        addFolder(widget.folders, _folderController.text);
                        _folderController.clear();
                      });
                    }),
                    child: const Icon(Icons.create_new_folder_outlined, size: 18)
                  ),
                ],
              ),
            ),
            // folders
            _buildFolderCard(
              onTap: () {
                Navigator.pop(context);
                widget.changeAppTitle('All history');
                widget.changeCurrentFolderId(0);
              }
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.folders.length,
                itemBuilder: (context, index) {
                  return _buildFolderCard(
                    index: index, 
                    onTap: () {
                      Navigator.pop(context);
                      widget.changeAppTitle(widget.folders[index]['folderName']);
                      widget.changeCurrentFolderId(widget.folders[index]['id']);
                    },
                    onLongPress: () {
                      final folderId = widget.folders[index]['id'];
                      _showMoreFoldersSheet(folderId);
                    }
                  );
                }
              )
            )
          ],
        )
      )
    );
  }
}