import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class _FormContent extends StatefulWidget {
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
  State<_FormContent> createState() => _FormContentState();
}

class _FormContentState extends State<_FormContent> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: widget.loginVM.validateMode,
      child: Focus(
        focusNode: widget.focusNode,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                height: 100,
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Username',
                border: OutlineInputBorder(
                  borderSide: Divider.createBorderSide(context),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: Divider.createBorderSide(context),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: Divider.createBorderSide(context),
                ),
              ),
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => widget.focusNode.nextFocus(),
              onSaved: (v) => widget.loginVM.updateForm(username: v),
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderSide: Divider.createBorderSide(context),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: Divider.createBorderSide(context),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: Divider.createBorderSide(context),
                ),
              ),
              obscureText: true,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.done,
              onEditingComplete: _validateInputs,
              onSaved: (v) => widget.loginVM.updateForm(password: v),
              validator: FormValidators.password,
            ),
            const SizedBox(height: 20),
            if (widget.authVM.loading)
              const CircularProgressIndicator.adaptive()
            else
              _AuthButtons(
                onLogin: _validateInputs,
                // onSignUp: authVM.showSignUp,
              ),
            const SizedBox(height: 20),
            if (widget.authVM.error != null)
              Text(
                widget.authVM.error!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.red),
              ),
            const SizedBox(
              height: 170,
            ),
            Column(
              children: const [
                Text(
                  'Raihomes cung cấp cho bạn thông tin về BDS',
                  style: TextStyle(
                    color: Color(0xffcd323a),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Nhanh chóng - Trung thực - Pháp lý rõ ràng!',
                  style: TextStyle(
                    color: Color(0xffcd323a),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _validateInputs() {
    if (widget.authVM.loading) return;
    final formState = widget.formKey.currentState;
    if (formState?.validate() == true) {
      formState?.save();
      widget.focusNode.unfocus();
      widget.authVM.login(widget.loginVM.formData);
    } else {
      widget.loginVM.validateMode = AutovalidateMode.always;
    }
  }
}


class _AuthButtons extends StatelessWidget {
  // final VoidCallback onSignUp;
  final VoidCallback onLogin;

  const _AuthButtons({required this.onLogin, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onLogin,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              primary: const Color(0xffcd323a),
            ),
            child: const Text(
              'LOGIN',
              style: TextStyle(
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
