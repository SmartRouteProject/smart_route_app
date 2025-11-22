import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_route_app/presentation/providers/profile_form_provider.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class ProfileForm extends ConsumerWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    File? image = ref.watch(profileFormProvider);
    final controller = ref.read(profileFormProvider.notifier);

    Future<void> chooseImageSource() async {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text("Elegir de la galería"),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await controller.pickFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Tomar una foto"),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await controller.pickFromCamera();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              // ------------------------------------------
              // AVATAR + LÁPIZ
              // ------------------------------------------
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: image != null ? FileImage(image) : null,
                      child: image == null
                          ? const Icon(Icons.person, size: 48)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: chooseImageSource,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              CustomTextFormField(label: 'Nombre'),
              CustomTextFormField(label: 'Apellido'),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
