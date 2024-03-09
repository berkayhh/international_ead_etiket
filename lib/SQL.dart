import 'package:mysql1/mysql1.dart';

//Server
//85.215.106.5
//DB
//admin_etiket
//user
//admn_etiketten
//password
//ci6D636z%

class Constants {
  var connection = MySqlConnection.connect(ConnectionSettings(
    host: '85.215.106.5',
    port: 3306,
    user: 'admin_etiket',
    password: 'ci6D636z%',
    db: 'admin_etiket',
  ));
}
