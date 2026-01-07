import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class CreateReturnAdressForm extends ConsumerStatefulWidget {
  const CreateReturnAdressForm({super.key});

  @override
  ConsumerState<CreateReturnAdressForm> createState() =>
      _CreateReturnAdressFormState();
}

class _CreateReturnAdressFormState
    extends ConsumerState<CreateReturnAdressForm> {
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(returnAddressFormProvider);
    final formNotifier = ref.read(returnAddressFormProvider.notifier);
    ref.listen<ReturnAddressFormState>(returnAddressFormProvider, (
      previous,
      next,
    ) {
      if (_addressController.text == next.address) return;
      _addressController.text = next.address;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar direccion de retorno"),
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
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    TextFormField(
                      controller: _addressController,
                      readOnly: true,
                      onTap: () async {
                        await showSearch<String?>(
                          context: context,
                          delegate: AddressSearchDelegate(
                            onSelectedResult: formNotifier.onAddressSelected,
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        label: const Text('Direccion'),
                        hintText: 'Buscar direccion',
                        suffixIcon: const Icon(Icons.search),
                        errorText: formState.addressErrorMessage,
                      ),
                    ),
                    CustomTextFormField(
                      label: 'Nombre',
                      initialValue: formState.nickname,
                      errorMessage: formState.nicknameErrorMessage,
                      onChanged: formNotifier.onNicknameChanged,
                    ),
                    Expanded(child: SizedBox()),
                    SizedBox(
                      width: double.infinity,
                      child: LoadingFloatingActionButton(
                        label: 'Guardar',
                        loader: formState.isPosting,
                        onPressed: () async {
                          final saved = await formNotifier.onFormSubmit();
                          if (saved && context.mounted) {
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
    );
  }
}
