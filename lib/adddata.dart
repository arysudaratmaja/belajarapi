import 'package:flutter/material.dart';
import 'apiservice.dart';
import 'profile.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  Profile profile;

  FormAddScreen({this.profile});

  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;
  ApiService _apiService = ApiService();
  bool _isFieldNameValid;
  bool _isFieldEmailValid;
  bool _isFieldAgeValid;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerAge = TextEditingController();

  @override
  void initState() {
    if (widget.profile != null) {
      _isFieldNameValid = true;
      _controllerName.text = widget.profile.name;
      _isFieldEmailValid = true;
      _controllerEmail.text = widget.profile.email;
      _isFieldAgeValid = true;
      _controllerAge.text = widget.profile.age.toString();
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldState,
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
          Container(
            color: Colors.black,
            child: Image.asset(
              'images/2.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 50, left: 30, right: 30),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.profile == null
                          ? "Tambah Data Pasien"
                          : "Ubah Data Pasien",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ])),
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 50,right: 50,top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildTextFieldName(),
                      _buildTextFieldEmail(),
                      _buildTextFieldAge(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            color: Colors.black,
                            child: Text(
                              widget.profile == null
                                  ? "Tambah".toUpperCase()
                                  : "Perbaharui".toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              if (_isFieldNameValid == null ||
                                  _isFieldEmailValid == null ||
                                  _isFieldAgeValid == null ||
                                  !_isFieldNameValid ||
                                  !_isFieldEmailValid ||
                                  !_isFieldAgeValid) {
                                _scaffoldState.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text("Tolong diisi semua!"),
                                  ),
                                );
                                return;
                              }
                              setState(() => _isLoading = true);
                              String name = _controllerName.text.toString();
                              String email = _controllerEmail.text.toString();
                              int age =
                                  int.parse(_controllerAge.text.toString());
                              Profile profile =
                                  Profile(name: name, email: email, age: age);
                              if (widget.profile == null) {
                                _apiService
                                    .createProfile(profile)
                                    .then((isSuccess) {
                                  setState(() => _isLoading = false);
                                  if (isSuccess) {
                                    Navigator.pop(
                                        _scaffoldState.currentState.context);
                                  } else {
                                    _scaffoldState.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text("Submit data gagal"),
                                    ));
                                  }
                                });
                              } else {
                                profile.id = widget.profile.id;
                                _apiService
                                    .updateProfile(profile)
                                    .then((isSuccess) {
                                  setState(() => _isLoading = false);
                                  if (isSuccess) {
                                    Navigator.pop(
                                        _scaffoldState.currentState.context);
                                  } else {
                                    _scaffoldState.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text("Update data gagal"),
                                    ));
                                  }
                                });
                              }
                            }),
                      )
                    ],
                  ),
                ),
                _isLoading
                    ? Stack(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.3,
                            child: ModalBarrier(
                              dismissible: false,
                              color: Colors.grey,
                            ),
                          ),
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          )
        ])));
  }

  Widget _buildTextFieldName() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Nama",
        errorText: _isFieldNameValid == null || _isFieldNameValid
            ? null
            : "Nama harus diisi",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNameValid) {
          setState(() => _isFieldNameValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldEmail() {
    return TextField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Alamat",
        errorText: _isFieldEmailValid == null || _isFieldEmailValid
            ? null
            : "Alamat harus diisi",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldEmailValid) {
          setState(() => _isFieldEmailValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldAge() {
    return TextField(
            controller: _controllerAge,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Umur",
              errorText: _isFieldAgeValid == null || _isFieldAgeValid
                  ? null
                  : "Umur harus diisi",
            ),
            onChanged: (value) {
              bool isFieldValid = value.trim().isNotEmpty;
              if (isFieldValid != _isFieldAgeValid) {
                setState(() => _isFieldAgeValid = isFieldValid);
              }
            },
          );
  }
}
