import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'apiservice.dart';
import 'profile.dart';
import 'adddata.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BuildContext context;
  ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return SafeArea(
      child: FutureBuilder(
        future: apiService.getProfiles(),
        builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Profile> profiles = snapshot.data;
            return _buildListView(profiles);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<Profile> profiles) {
    return Scaffold(
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
      Container(
        color: Colors.black,
        child: Image.asset(
          'images/1.png',
          fit: BoxFit.fitWidth,
        ),
      ),

      Container(
          margin: EdgeInsets.only(top: 30, left: 30, right: 30),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Data Pasien',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.add_box,
                      size: 35,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FormAddScreen()),
                      );
                    }),
              ])),
      Container(
          child: Column(children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            Profile profile = profiles[index];
            return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 30, right: 30, bottom: 15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 18,
                                        right: 18,
                                        top: 10,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Umur:',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        Text(profile.age.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30.0,
                                              fontWeight: FontWeight.w900,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(right: 20)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(profile.name,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w900,
                                          )),
                                      Text(
                                        profile.email,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ])),
                            Padding(padding: EdgeInsets.only(right: 30)),
                            Container(
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                titlePadding: EdgeInsets.only(left: 30,right: 30,top: 40),
                                                contentPadding: EdgeInsets.only(left: 30,right: 30,top: 20),
                                                actionsPadding: EdgeInsets.only(left: 30,right: 30,bottom: 10,top: 20),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                                title: Text("Peringatan"),
                                                content: Text(
                                                    "Apakah anda yakin akan menghapus data pasien atas nama ${profile.name}?"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text("Batal"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  FlatButton(
                                                    child: Text("Hapus"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      apiService
                                                          .deleteProfile(
                                                              profile.id)
                                                          .then((isSuccess) {
                                                        if (isSuccess) {
                                                          setState(() {});
                                                          Scaffold.of(
                                                                  this.context)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      "Delete data success")));
                                                        } else {
                                                          Scaffold.of(
                                                                  this.context)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      "Delete data failed")));
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FormAddScreen(
                                                    profile: profile,
                                                  )),
                                        );
                                      }),
                                ])),
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
          },
          itemCount: profiles.length,
        ),
      ])),
    ])));
  }
}
