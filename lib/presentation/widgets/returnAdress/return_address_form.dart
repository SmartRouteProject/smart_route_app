import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class CreateReturnAdressForm extends ConsumerStatefulWidget {
  final ReturnAddress? returnAddress;
  final int? returnAddressIndex;

  const CreateReturnAdressForm({
    super.key,
    this.returnAddress,
    this.returnAddressIndex,
  });

  @override
  ConsumerState<CreateReturnAdressForm> createState() =>
      _CreateReturnAdressFormState();
}

class _CreateReturnAdressFormState
    extends ConsumerState<CreateReturnAdressForm> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initialAddress = widget.returnAddress;
    final initialIndex = widget.returnAddressIndex;
    if (initialAddress != null && initialIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref
            .read(returnAddressFormProvider.notifier)
            .initializeForEdit(initialAddress, initialIndex);
      });
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _nicknameController.dispose();
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
      if (_nicknameController.text != next.nickname) {
        _nicknameController.text = next.nickname;
      }
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
                    TextFormField(
                      controller: _nicknameController,
                      onChanged: formNotifier.onNicknameChanged,
                      decoration: InputDecoration(
                        label: const Text('Nombre'),
                        errorText: formState.nicknameErrorMessage,
                      ),
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
