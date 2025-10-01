import 'package:flutter/material.dart';
import 'package:sum/utils/folder_management.dart';
import 'package:sum/widgets/build_button.dart';
import 'package:sum/widgets/show_alert_dialog.dart';
import 'package:sum/widgets/show_bottom_sheet.dart';
import 'package:sum/widgets/top_bar.dart';

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
    showAlertDialog(
      context: context,
      title: title, 
      content: TextField(
        controller: _folderController,
        autofocus: true,
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          hoverColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).disabledColor,
              width: 1
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).disabledColor,
              width: 1
            )
          ),
          hintText: 'Folder Name',
          hintStyle: TextStyle(
            color: Theme.of(context).disabledColor
          ),
        ),
      ), 
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(25),
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                child: const Text('Cancel')
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onTap();
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(25),
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                child: Text(confirmButtonLabel)
              )
            ),
          ],
        )
      ]
    );
  }

  // showFolder for deleting folder 
  void _showDeleteFolderDialog(int folderId) {
    showAlertDialog(
      context: context,
      title: 'Delete Folder',
      content: const Text('The folder will be deleted, but its items will remain in All History'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context), 
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(25),
                  textStyle: Theme.of(context).textTheme.bodyMedium
                ),
                child: const Text('Cancel')
              ),
            ),
            SizedBox(width: 10),
            Expanded( 
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    deleteFolder(widget.folders, folderId);
                  });
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(25),
                  textStyle: Theme.of(context).textTheme.bodyMedium
                ),
                child: const Text('Delete', style: TextStyle(color: Colors.red))
              )
            ),
          ],
        )
      ]
    );
  }

  // show action for folder (rename, delete)
  void _showMoreFoldersSheet(int folderId) {
    showCustomBottomSheet(
      context: context,
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.drive_file_rename_outline),
            title: const Text('Rename'),
            onTap: () {
              Navigator.pop(context);
              _showFolderDialog(title: 'Rename Folder', confirmButtonLabel: 'Rename', onTap: () {
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

  Widget _buildFolderCard({
    int? index,
    required Function onTap,
    Function? onLongPress,
    }) {
    return Card(
      margin: EdgeInsets.only(bottom: 5),
      color: Theme.of(context).colorScheme.secondary,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: const Icon(Icons.folder_outlined),
        title: index != null ? Text(widget.folders[index]['folderName']) : const Text('All History'),
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
            // top bar
            topBar(
              context: context, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 48),
                  Text('Folders', style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                  buildIconButton(
                    context: context, 
                    onTap: () {
                      _showFolderDialog(
                        title: 'Create Folder', 
                        confirmButtonLabel: 'Create', 
                        onTap: () {
                          setState(() {
                            addFolder(widget.folders, _folderController.text);
                            _folderController.clear();
                          });
                        }
                      );
                    },
                    color: Theme.of(context).colorScheme.primary,
                    icon: Icons.create_new_folder_outlined
                  )
                ],
              ),
            ),
            // folders
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),      
              child: _buildFolderCard(
                onTap: () {
                  Navigator.pop(context);
                  widget.changeAppTitle('All History');
                  widget.changeCurrentFolderId(0);
                }
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
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
            )
          ],
        )
      )
    );
  }
}