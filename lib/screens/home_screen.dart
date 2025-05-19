import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Awesome Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            OutlinedButton(
              onPressed: () async {
                await NotificationService.createNotification(
                  id: 1,
                  title: 'Default Notification',
                  body: 'This is the body of the notification',
                  summary: 'Small summary',
                );
              },
              child: const Text('Default Notification'),
            ),
            OutlinedButton(
              onPressed: () async {
                await NotificationService.createNotification(
                  id: 2,
                  title: 'Notification with Summary',
                  body: 'This is the body of the notification',
                  summary: 'Small summary',
                  notificationLayout: NotificationLayout.Inbox,
                );
              },
              child: const Text('Notification with Summary'),
            ),
            OutlinedButton(
              onPressed: () async {
                await NotificationService.createNotification(
                  id: 3,
                  title: 'Progress Bar Notification',
                  body: 'This is the body of the notification',
                  summary: 'Small summary',
                  notificationLayout: NotificationLayout.ProgressBar,
                );
              },
              child: const Text('Progress Bar Notification'),
            ),
            OutlinedButton(
              onPressed: () async {
                await NotificationService.createNotification(
                  id: 4,
                  title: 'Message Notification',
                  body: 'This is the body of the notification',
                  summary: 'Small summary',
                  notificationLayout: NotificationLayout.Messaging,
                );
              },
              child: const Text('Message Notification'),
            ),
            OutlinedButton(
              onPressed: () async {
                await NotificationService.createNotification(
                  id: 5,
                  title: 'Big Image Notification',
                  body: 'This is the body of the notification',
                  summary: 'Small summary',
                  notificationLayout: NotificationLayout.BigPicture,
                  bigPicture: 'https://picsum.photos/300/200',
                );
              },
              child: const Text('Big Image Notification'),
            ),
            OutlinedButton(
              onPressed: () async {
                await NotificationService.createNotification(
                  id: 6,
                  title: 'Action Button Notification',
                  body: 'This is the body of the notification',
                  payload: {'navigate': 'true'},
                  actionButtons: [
                    NotificationActionButton(
                      key: 'action_button',
                      label: 'Click me',
                      actionType: ActionType.Default,
                    )
                  ],
                );
              },
              child: const Text('Action Button Notification'),
            ),
            OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final TextEditingController titleController = TextEditingController();
                    final TextEditingController contentController = TextEditingController();

                    return AlertDialog(
                      title: const Text('Tambah Note'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              labelText: 'Judul',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: contentController,
                            decoration: const InputDecoration(
                              labelText: 'Isi Catatan',
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final title = titleController.text.trim();
                            final content = contentController.text.trim();

                            if (title.isNotEmpty && content.isNotEmpty) {
                              try {
                                final doc = await FirebaseFirestore.instance
                                    .collection('notes')
                                    .add({
                                  'title': title,
                                  'content': content,
                                  'created_at': FieldValue.serverTimestamp(),
                                });

                                await NotificationService.createNotification(
                                  id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
                                  title: 'Catatan Tersimpan',
                                  body: 'Judul: $title',
                                  summary: 'Note ID: ${doc.id}',
                                );

                                Navigator.pop(context);
                              } catch (e) {
                                await NotificationService.createNotification(
                                  id: 999,
                                  title: 'Gagal Menyimpan',
                                  body: 'Terjadi kesalahan: $e',
                                );
                              }
                            }
                          },
                          child: const Text('Simpan'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Tambah Catatan (modal + notif)'),
            ),
          ],
        ),
      ),
    );
  }
}