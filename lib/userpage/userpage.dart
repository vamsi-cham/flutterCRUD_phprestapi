import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:getwidget/getwidget.dart';
import 'package:phprestapi/model/usermodal.dart';
import 'package:phprestapi/services/userservice.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DataTableDemo extends StatefulWidget {
  //
  DataTableDemo() : super();

  final String title = 'USER PHP REST API 2.1';

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  List<User> _users;
  var sort = "ASC";
  final _scaffoldresKey = GlobalKey<ScaffoldState>();
  UserServices _userServices = new UserServices();
  // controller for the First Name TextField we are going to create.
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController email = TextEditingController();

  String _titleProgress;

  bool loading;

  @override
  void initState() {
    super.initState();
    _users = [];
    _titleProgress = widget.title;
    _getUsers(sort);

    name.text = "";
    email.text = "";
    mobile.text = "";
    age.text = "";
  }

  _displayresSnackbar(value) {
    // ignore: deprecated_member_use
    return _scaffoldresKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      duration: Duration(seconds: 1),
      content: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          value,
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ));
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  // Now lets add an Employee
  _addUser() {
    UserServices.addUser(name.text, age.text, mobile.text, email.text)
        .then((result) {
      if (result == 'success') {
        _displayresSnackbar('New User Added Successfully');
        _getUsers(sort);
      } else {
        print('Update Service Returned an error');
      }
    });
  }

  _getUsers(sort) {
    loading = true;
    _showProgress('Loading Users...');

    EasyDebounce.debounce(
        'getuser-debounce', // <-- An ID for this particular debouncer
        Duration(milliseconds: 2000), // <-- The debounce duration
        () {
      UserServices.getUsers(sort).then((users) {
        setState(() {
          _users = users;
          loading = false;
        });
        _showProgress(widget.title); // Reset the title...
        // print("Length ${employees.length}");
      });
    });

    return true;
  }

  _updateUser(var id, var name, var age, var mobile, var email) {
    UserServices.updateUser(id, name, age, mobile, email).then((result) {
      if (result == 'success') {
        _displayresSnackbar('Record Updated Successfully');
        _getUsers(sort);
      } else {
        print('Update Service Returned an error');
      }
    });
  }

  _deleteUser(var id) {
    UserServices.deleteUser(id).then((value) {
      if (value == 'success') {
        _displayresSnackbar('User Deleted Successfully');
        _getUsers(sort);
      } else {
        print('Delete Service Returned an error');
      }
    });
  }

  // Let's create a DataTable and show the employee list in it.
  SingleChildScrollView _dataBody() {
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showBottomBorder: true,
          columns: [
            DataColumn(
              label: Text('ID'),
            ),
            DataColumn(
              label: Text('NAME'),
            ),
            DataColumn(
              label: Text('AGE'),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('MOBILE'),
            ),
            DataColumn(
              label: Text('EMAIL'),
            ),
            DataColumn(
              label: Text('Edit'),
            ),
            DataColumn(
              label: Text('DELETE'),
            )
          ],
          rows: _users
              .map(
                (user) => DataRow(cells: [
                  DataCell(
                    Text(user.id.toString()),
                    // Add tap in the row and populate the
                    // textfields with the corresponding values to update
                  ),
                  DataCell(
                    Text(
                      user.name,
                    ),
                  ),
                  DataCell(
                    Text(
                      user.age.toString(),
                    ),
                  ),
                  DataCell(
                    Text(
                      '+91 ' + user.mobile,
                    ),
                  ),
                  DataCell(
                    Text(
                      user.email,
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          name.text = user.name;
                          age.text = user.age;
                          email.text = user.email;
                          mobile.text = user.mobile;
                        });
                        _updateALert(user.id, 'update');
                        print('edit button clicked');
                        // _updateUser(user.id, 'Updated', user.age, user.mobile,
                        //     user.email);
                      },
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        print('delete button clicked');
                        _deleteUser(user.id);
                      },
                    ),
                  )
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldresKey,
      appBar: AppBar(
        title: Text(_titleProgress), // we show the progress in the title...
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getUsers(sort);
            },
          ),
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.format_list_numbered_outlined),
            onPressed: () {
              if (sort == 'ASC') {
                setState(() {
                  sort = 'DESC';
                });
              } else {
                setState(() {
                  sort = "ASC";
                });
              }

              _getUsers(sort);
            },
          )
        ],
      ),
      body: loading
          ? ShimmerEffect()
          : RefreshIndicator(
              color: Colors.red,
              backgroundColor: Colors.black,
              onRefresh: () => _getUsers(sort),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: _dataBody(),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            name.clear();
            age.clear();
            mobile.clear();
            email.clear();
          });
          _updateALert(0, 'add');
        },
      ),
    );
  }

  _updateALert(var id, action) {
    var updateButton = DialogButton(
      color: Colors.blue,
      onPressed: () {
        _updateUser(id, name.text, age.text, mobile.text, email.text);
        Navigator.pop(context);
      },
      child: Text(
        "Update",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );

    var addButton = DialogButton(
      color: Colors.blue,
      onPressed: () {
        _addUser();
        Navigator.pop(context);
      },
      child: Text(
        "ADD",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );

    var button;
    var title;
    if (action == "update") {
      button = updateButton;
      title = "Update User Detail";
    } else {
      title = "Add New User";
      button = addButton;
    }
    return Alert(
        onWillPopActive: true,
        closeIcon: Icon(Icons.close),
        context: context,
        title: title,
        content: Column(
          children: <Widget>[
            TextField(
              controller: name,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: age,
              decoration: InputDecoration(
                labelText: 'Age',
              ),
            ),
            TextField(
              controller: mobile,
              decoration: InputDecoration(
                labelText: 'Mobile No.',
              ),
            ),
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'Email Id.',
              ),
            ),
          ],
        ),
        buttons: [
          button,
        ]).show();
  }
}

class ShimmerEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: 20,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return GFShimmer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 60,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 8,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 8,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 8,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
