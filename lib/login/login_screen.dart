import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_view_model.dart';
import '../common/form_validators.dart';
import '../common/common_scaffold.dart';
import 'login_view_model.dart';

class LoginWidget extends StatelessWidget {
   LoginWidget({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusScopeNode();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Login',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ChangeNotifierProvider(
              create: (_) => LoginViewModel(),
              child: Consumer2<AuthViewModel, LoginViewModel>(
                builder: (ctx, authVM, loginVM, ch) {
                  return _FormContent(
                    formKey: _formKey,
                    focusNode: _focusNode,
                    authVM: authVM,
                    loginVM: loginVM,
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
  final LoginViewModel loginVM;

  const _FormContent({
    required this.formKey,
    required this.focusNode,
    required this.authVM,
    required this.loginVM,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: loginVM.validateMode,
      child: Focus(
        focusNode: focusNode,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Email'),
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => focusNode.nextFocus(),
              onSaved: (v) => loginVM.updateForm(username: v),

            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(hintText: 'Password'),
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.done,
              onEditingComplete: _validateInputs,
              onSaved: (v) => loginVM.updateForm(password: v),
              validator: FormValidators.password,
            ),
            const SizedBox(height: 20),
            if (authVM.loading)
              const CircularProgressIndicator.adaptive()
            else
              _AuthButtons(
                onLogin: _validateInputs,
                onSignUp: authVM.showSignUp,
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
      authVM.login(loginVM.formData);
    } else {
      loginVM.validateMode = AutovalidateMode.always;
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
          onPressed: onLogin,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(40),
          ),
          child: const Text('Login'),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: onSignUp,
          child: const Text('Sign Up'),
        )
      ],
    );
  }
}

