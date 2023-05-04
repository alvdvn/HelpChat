import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_view_model.dart';
import '../common/form_validators.dart';
import '../common/common_scaffold.dart';
import 'signup_view_model.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusScopeNode();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Sign Up',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ChangeNotifierProvider(
              create: (_) => SignUpViewModel(),
              child: Consumer2<AuthViewModel, SignUpViewModel>(
                builder: (ctx, authVM, signUpVM, ch) {
                  return _FormContent(
                    formKey: _formKey,
                    focusNode: _focusNode,
                    authVM: authVM,
                    signUpVM: signUpVM,
                  );
                },
              )),
        ),
      ),
    );
  }
}

class _FormContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final FocusNode focusNode;
  final AuthViewModel authVM;
  final SignUpViewModel signUpVM;

  const _FormContent({
    required this.formKey,
    required this.focusNode,
    required this.authVM,
    required this.signUpVM,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: signUpVM.validateMode,
      child: Focus(
        focusNode: focusNode,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(hintText: 'Full name'),
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => focusNode.nextFocus(),
              onSaved: (v) => signUpVM.updateForm(name: v),
              validator: FormValidators.empty,
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Email'),
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => focusNode.nextFocus(),
              onSaved: (v) => signUpVM.updateForm(email: v),
              validator: FormValidators.email,
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(hintText: 'Password'),
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.done,
              onEditingComplete: _validateInputs,
              onSaved: (v) => signUpVM.updateForm(password: v),
              validator: FormValidators.password,
            ),
            const SizedBox(height: 30),
            CheckboxListTile(
              value: signUpVM.formData.isAdmin,
              onChanged: (v) => signUpVM.updateForm(isAdmin: v),
              title: const Text('Admin'),
            ),
            const SizedBox(height: 20),
            if (authVM.loading)
              const CircularProgressIndicator.adaptive()
            else
              _AuthButtons(
                onSignUp: _validateInputs,
                onLogin: authVM.showLogin,
              ),
            const SizedBox(height: 20),
            if (authVM.error != null)
              Text(
                authVM.error!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.red),
              )
          ],
        ),
      ),
    );
  }

  void _validateInputs() {
    if (authVM.loading) return;

    final formState = formKey.currentState;
    if (formState?.validate() == true) {
      formState?.save();
      focusNode.unfocus();
      authVM.signUp(signUpVM.formData);
    } else {
      signUpVM.validateMode = AutovalidateMode.always;
    }
  }
}

class _AuthButtons extends StatelessWidget {
  final VoidCallback onSignUp;
  final VoidCallback onLogin;

  const _AuthButtons({required this.onSignUp, required this.onLogin, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onSignUp,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(40),
          ),
          child: const Text('Sign Up'),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: onLogin,
          child: const Text('Login'),
        )
      ],
    );
  }
}
