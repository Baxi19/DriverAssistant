import 'package:driver_assistant/User/bloc/bloc_user.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import '../../../widgets/floating_action_button_profile.dart';
import 'profile_header.dart';

class Profile extends StatelessWidget {
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return  Stack(//un Stack permite colocar un elemento encima de otro
      children: [//En Stack tambien agregamos hijos
        ProfileHeader(),
        FloatingActionButtonProfile()
      ],
    );
  }
}
