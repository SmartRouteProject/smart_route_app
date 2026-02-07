import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class CreatePackageForm extends ConsumerWidget {
  final Stop stop;
  final Package? initialPackage;
  final int? packageIndex;

  const CreatePackageForm({
    super.key,
    required this.stop,
    this.initialPackage,
    this.packageIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formArgs = PackageFormArgs(
      stop: stop,
      initialPackage: initialPackage,
      packageIndex: packageIndex,
    );
    final formState = ref.watch(packageFormProvider(formArgs));
    final formNotifier = ref.read(packageFormProvider(formArgs).notifier);
    final isEditing = packageIndex != null;

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
                  title: const Text('Elegir de la galeria'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await formNotifier.pickFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Tomar una foto'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await formNotifier.pickFromCamera();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar paquete' : 'Nuevo paquete'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10,
                      children: [
                        CustomTextFormField(
                          label: 'Descripcion',
                          initialValue: formState.description,
                          onChanged: formNotifier.onDescriptionChanged,
                        ),
                        CustomDropdownButtonFormField<PackageWeightType>(
                          label: 'Peso',
                          value: formState.weight,
                          items: PackageWeightType.values
                              .map(
                                (weight) => DropdownMenuItem(
                                  value: weight,
                                  child: Text(weight.label),
                                ),
                              )
                              .toList(),
                          onChanged: formNotifier.onWeightChanged,
                        ),
                        InkWell(
                          onTap: chooseImageSource,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            height: 160,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.outline.withValues(alpha: 0.3),
                              ),
                            ),
                            child: formState.picture != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      formState.picture!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      cacheWidth: 1024,
                                      cacheHeight: 1024,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 32,
                                      ),
                                      SizedBox(height: 8),
                                      Text('Agregar foto del paquete'),
                                    ],
                                  ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        SizedBox(
                          width: double.infinity,
                          child: LoadingFloatingActionButton(
                            label: isEditing
                                ? 'Guardar cambios'
                                : 'Agregar paquete',
                            loader: formState.isPosting,
                            onPressed: () async {
                              final created = await formNotifier.onFormSubmit();
                              if (created && context.mounted) {
                                context.pop();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
