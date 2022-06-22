import 'package:architect_app/constants/theme.dart';
import 'package:architect_app/models/forms/choose_project_form.dart';
import 'package:architect_app/models/preferences/auth_preference.dart';
import 'package:architect_app/models/repositories/repository.dart';
import 'package:architect_app/models/responses/get_cabangs_response.dart';
import 'package:architect_app/models/responses/login_response.dart';
import 'package:architect_app/models/responses/get_projects_response.dart';
import 'package:architect_app/utils/dimension.dart';
import 'package:architect_app/views/chat/chat_screen.dart';
import 'package:architect_app/views/home/choose_project.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:architect_app/utils/generals.dart';

class CabangDetail extends StatefulWidget {
  final Cabang cabang;

  CabangDetail({this.cabang});

  @override
  _CabangDetailState createState() => _CabangDetailState();
}

class _CabangDetailState extends State<CabangDetail> {
  User _user;
  AuthPreference _authPreference = AuthPreference();
  Repository _repository = Repository();
  bool isFavorite = false;
  bool isSave = false;
  final projectForm =
      new ChooseProjectForm(null, null, null, null, null, null, null, null);

  _initialize() async {
    var user = await _authPreference.getUserData();
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Dimension().init(context);
    final icon = isFavorite ? Icons.favorite : Icons.favorite_outline;
    final color = isFavorite ? Colors.red : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cabang.namaTim,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        backgroundColor: Colors.amber[300],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(children: [
        Column(children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Carousel(
              boxFit: BoxFit.cover,
              autoplay: false,
              dotSize: 3.0,
              dotBgColor: Colors.transparent,
              showIndicator: true,
              images: widget.cabang.images.map((e) => NetworkImage(
                  // "${'http://1803010.web.ti.polindra.ac.id/index.php/img/cabang/'}${e.image}"))
                  "${'${Generals.baseUrl}/img/cabang/profile/'}${e.image}")).toList(),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.cabang.namaTim,
                            style: blackFontStyle3.copyWith(fontSize: 18),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.cabang.kontraktor.user.name,
                            style: blackFontStyle2,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        icon: Icon(icon),
                        iconSize: Dimension.blockSizeVertical * 4,
                        color: color,
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                            // _saveFav();
                          });
                        }),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        _createRoomAndStartConversation(
                            widget.cabang.kontraktor.user.username);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.amber[100]),
                        child: Icon(
                          Icons.messenger_rounded,
                          color: Colors.amber,
                          size: Dimension.safeBlockHorizontal * 5,
                        ),
                      ),
                    ),
                    // ElevatedButton.icon(
                    //   label: Text("Pesan"),
                    //   icon: Icon(Icons.message),
                    //   onPressed: () {
                    //     _createRoomAndStartConversation(
                    //         widget.cabang.konsultan.user.username);
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //       primary: Colors.white,
                    //       onPrimary: Colors.amber,
                    //       side: BorderSide(color: Colors.amber)),
                    // )
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  widget.cabang.description,
                  style: blackFontStyle1,
                ),
                SizedBox(height: 20),
                Text(
                        "Alamat",
                        style: blackFontStyle3,
                      ),
                Text(
                  widget.cabang.alamatCabang,
                  style: blackFontStyle1,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Jumlah Teamwork",
                        style: blackFontStyle1,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        widget.cabang.jumlahTim.toString(),
                        style: blackFontStyle3,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Harga Kontrak",
                        style: blackFontStyle1,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        Generals.formatRupiah(widget.cabang.hargaKontrak),
                        style: blackFontStyle3,
                      ),
                    ),
                  ],
                ),
                
              ],
            ),
          )
        ]),
      ]),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // child: ElevatedButton(
          //   // onPressed: () {
          //   //   Navigator.push(
          //   //       context,
          //   //       // MaterialPageRoute(
          //   //       //     builder: (context) => ChooseProject(
          //   //       //         form: cabangForm, cabang: widget.cabang))
          //   //       );
          //   // },
          //   child: Text("Saya tertarik dengan desain ini"),
          //   style: ElevatedButton.styleFrom(primary: Colors.amber),
          // ),
        ),
      ),
    );
  }

  _createRoomAndStartConversation(String username) {
    String chatRoomId = _getChatRoomId(_user.username, username);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(
                chatRoomId, widget.cabang.kontraktor.user.username)));
  }

  _getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  _saveFav() {
    _repository.saveFavorite(_authPreference, widget.cabang.id);
  }
}
