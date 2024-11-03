import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String hinTtext;
  final TextEditingController textEditingController;
  final String type;
  final bool obscure;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.hinTtext,
    required this.textEditingController,
    required this.type,
    required this.obscure,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool? isObsure;

  @override
  void initState() {
    super.initState();
    isObsure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      child: TextField(
        cursorColor: Colors.cyan,
        obscureText: isObsure!,
        controller: widget.textEditingController,
        obscuringCharacter: '*',
        decoration: InputDecoration(
          suffixIcon: widget.type == 'password'
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObsure = !isObsure!;
                    });
                  },
                  icon: const Icon(Icons.remove_red_eye),
                )
              : null,
          hintText: widget.hinTtext,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
