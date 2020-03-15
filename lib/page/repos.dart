import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lisky_player/model/repo.dart';
import 'package:time_ago_provider/time_ago_provider.dart';

class ReposPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('repos').listenable(),
        builder: (context, Box box, child) {
          print('REBUILD');
          return Scrollbar(
            child: ListView(
              //physics: BouncingScrollPhysics(),
              children: <Widget>[
                for (Repo repo in box.values)
                  ListTile(
                    title: Text(repo.name),
                    subtitle:
                        Text('Updated ${TimeAgo.getTimeAgo(repo.updatedAt)}'),
                    trailing: Text('${repo.collections.length} Coll.'),
                  )
              ],

              // physics: BouncingScrollPhysics(),
            ),
          );
        });
    ;
  }
}
