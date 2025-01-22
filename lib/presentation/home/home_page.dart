import 'package:flutter/material.dart';

import '../../widget/app_bar.dart';
import '../utils/index.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with StateTemplate<HomePage> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CustomAppBar(title: 'Quản lý');
  }

  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          SearchBar(
            enabled: false,
          ),
        ],
      ),
    );
  }
}
