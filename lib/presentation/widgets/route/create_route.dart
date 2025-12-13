import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class CreateRoute extends ConsumerWidget {
  const CreateRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(routeFormProvider);
    final formNotifier = ref.read(routeFormProvider.notifier);
    final user = ref.watch(authProvider).user;
    final returnAddresses = user?.returnAddresses ?? const <ReturnAddress>[];

    final dateLabel = MaterialLocalizations.of(context).formatMediumDate(
      formState.date.value,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva Ruta"),
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
                          label: 'Nombre de la ruta',
                          initialValue: formState.name,
                          onChanged: formNotifier.onNameChange,
                        ),
                        InkWell(
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: formState.date.value,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365 * 5),
                              ),
                            );
                            if (pickedDate != null) {
                              formNotifier.onDateChanged(pickedDate);
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Fecha',
                              border: const OutlineInputBorder(),
                              errorText: formState.isFormPosted
                                  ? formState.date.errorMessage
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(dateLabel),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                        CustomDropdownButtonFormField<ReturnAddress?>(
                          label: 'Direccion de retorno',
                          hint: 'Seleccione una direccion',
                          value: formState.returnAddress,
                          items: [
                            const DropdownMenuItem<ReturnAddress?>(
                              value: null,
                              child: Text('Sin direccion de retorno'),
                            ),
                            ...returnAddresses.map(
                              (address) => DropdownMenuItem<ReturnAddress?>(
                                value: address,
                                child: Text(
                                  address.nickname.isNotEmpty
                                      ? address.nickname
                                      : address.address,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: formNotifier.onReturnAddressChanged,
                        ),
                        const Expanded(child: SizedBox()),
                        SizedBox(
                          width: double.infinity,
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: formState.isPosting
                                ? null
                                : () async {
                                    final created =
                                        await formNotifier.onFormSubmit();
                                    if (created && context.mounted) {
                                      context.pop();
                                    }
                                  },
                            child: formState.isPosting
                                ? const CircularProgressIndicator()
                                : const Text('Crear ruta'),
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
