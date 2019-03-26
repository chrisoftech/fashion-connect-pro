import 'package:fashion_connect/blocs/blocs.dart';
import 'package:fashion_connect/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);

    Widget _buildDrawerAppBar() {
      return AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'MENU',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(210.0),
          child: DrawerProfile(),
        ),
      );
    }

    Widget _buildDrawerListTile(
        {@required IconData icon,
        @required String title,
        @required String route,
        bool signout = false,
        bool addDivider = false,
        bool navigatorPushReplacement = false}) {
      return Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
                child: Icon(icon, color: Theme.of(context).accentColor)),
            title: Text(
              '$title',
              style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              if (signout) {
                Navigator.of(context).pop();
                _authBloc.onLoggedOut();
              } else {
                if (route.isEmpty) {
                  return;
                }
                navigatorPushReplacement
                    ? Navigator.of(context).pushReplacementNamed('$route')
                    : Navigator.of(context).pushNamed('$route');
              }
            },
          ),
          addDivider ? Divider(height: 20.0) : Container(),
        ],
      );
    }

    return Drawer(
      child: SafeArea(
        child: Scaffold(
          appBar: _buildDrawerAppBar(),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: <Widget>[
                        _buildDrawerListTile(
                            icon: Icons.timeline,
                            title: 'Timeline',
                            route: '',
                            addDivider: true),
                        _buildDrawerListTile(
                            icon: Icons.dashboard,
                            title: 'Admin Dashboard',
                            route: '/admin-dashboard',
                            navigatorPushReplacement: true),
                        _buildDrawerListTile(
                            icon: Icons.graphic_eq,
                            title: 'Statistics',
                            route: '',
                            addDivider: true,
                            navigatorPushReplacement: true),
                        _buildDrawerListTile(
                            icon: Icons.exit_to_app,
                            title: 'Signout',
                            route: '',
                            signout: true),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
