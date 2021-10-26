//import 'package:blooddonation/percentage_widget.dart';
//import 'package:blooddonation/recent_update_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raktkhoj/Colors.dart';
import 'package:raktkhoj/model/request.dart';
import 'package:raktkhoj/model/user.dart';
import 'package:raktkhoj/screens/donate_here/percentage_widget.dart';
import 'package:raktkhoj/screens/donate_here/search_request.dart';
import 'package:raktkhoj/screens/donate_here/single_request_screen.dart';


class Admin extends StatefulWidget {
  Admin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  double bannerHeight, listHeight, listPaddingTop;
  double cardContainerHeight, cardContainerTopPadding;
  //String name="";
  int selectedSort;
  List<String> requestConditonList=["normal","critical"];

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RequestModel>> fetchAllRequests()  async {
    List<RequestModel> requestList = <RequestModel>[];

    QuerySnapshot querySnapshot =
    await _firestore.collection("Blood Request Details").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      requestList.add(RequestModel.fromMap(querySnapshot.docs[i].data()));

    }
    return requestList;
  }

  List<RequestModel> requestList;
  String query = "";
  TextEditingController searchController = TextEditingController();
  @override
  void initState()  {
    super.initState();
    selectedSort=0;

    //requestList=_firestore.collection("Blood Request Details").snapshots() as List<RequestModel>;

    fetchAllRequests().then((List<RequestModel> list) {
      setState(() {
        requestList = list;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    bannerHeight = MediaQuery.of(context).size.height * .14;
    listHeight = MediaQuery.of(context).size.height * .75;
    //cardContainerHeight = 200;

    cardContainerTopPadding = bannerHeight / 2;
    listPaddingTop = 20;
    return Scaffold(
      // https://flutter.io/docs/development/ui/layout#stack
      body: Stack(
        children: <Widget>[
          new Column(
            children: <Widget>[
              //searchButton(context),
              topBanner(context),
              Expanded(child: bodyBloodRequestList(context))
            ],
          ),
          bannerContainer(),
        ],
      ),
    );
  }

  Container bodyBloodRequestList(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey.shade300,
      padding:
      new EdgeInsets.only(top: listPaddingTop, right: 10.0, left: 10.0),
      child: Column(
        children: <Widget>[
          //searchButton(context),
          getScrollView(),
          Expanded(child: requests(context))
        ],
      ),
    );
  }


  Widget requests(BuildContext context) {
    return StreamBuilder(

      /*stream: FirebaseFirestore.instance
          .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
          .where('active',isEqualTo:true)
          .orderBy('dueDate').snapshots(),*/
      stream: getQuery().snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {

          return Center(child: CircularProgressIndicator());
        }



        return ListView.builder(

          padding: EdgeInsets.all(10),
          //reverse: true,


          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {

            return RequestItem(snapshot.data.docs[index], context );
          },
        );
      },
    );
  }






  Widget RequestItem(DocumentSnapshot snapshot, BuildContext context){


    String name="";
    RequestModel _req = RequestModel.fromMap(snapshot.data());
    // return StreamBuilder(
    //   stream: FirebaseFirestore.instance.collection('User Details').doc(_req.raiserUid).snapshots(),
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData)
    //       return Padding(
    //           padding: EdgeInsets.only(top: 50),
    //           child: Row(
    //             children: <Widget>[
    //               CircularProgressIndicator(
    //                 valueColor:
    //                 new AlwaysStoppedAnimation<Color>(
    //                     kMainRed),
    //               ),
    //               SizedBox(
    //                 width: 15,
    //               ),
    //               Text('Loading Requests...')
    //             ],
    //           ));
    //     try {
    //       name = snapshot.data['Name'];
    //     }catch(e){
    //       name= 'Loading';
    //     }
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // setState(() {
            //
            // });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 5),
            child: Column(
              children: <Widget>[Container(
              height: 160,
              width: MediaQuery
                  .of(context)
                  .size
                  .width ,
              decoration: BoxDecoration(
                  color: kBackgroundColor,
                  // borderRadius:
                  // BorderRadius.circular(15),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  border: Border.all(
                      color: kMainRed,
                      width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ]),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .center,
                      mainAxisAlignment: MainAxisAlignment
                          .center,
                      children: <Widget>[
                        Icon(Icons.bloodtype_sharp,color: kMainRed,),
                        Text(
                          _req.bloodGroup,
                          style: TextStyle(
                              fontSize: 22,
                              color: kMainRed,
                              fontWeight:
                              FontWeight.bold,
                              fontFamily:
                              'nunito'),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(
                              left: 5),
                          child: Text(
                            'Type',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontFamily:
                                'nunito'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //     height: 160,
                  //     child: VerticalDivider(
                  //       color: Colors.black,
                  //       thickness: 1,
                  //     )),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(child:
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(height: 8),
                      //                                     SizedBox(height: 12,),

                      Row(
                          children : <Widget>[
                            Icon(FontAwesomeIcons.hospitalUser,color: kMainRed,size: 12,),
                            SizedBox(width: 3,),
                            Text(
                              'Name: ${_req.patientName}',
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontFamily: 'nunito',
                                  color: Colors.black),
                            ),
                          ]

                      ),
                      SizedBox(height: 5,),
                      Row(
                          children : <Widget>[
                            Icon(FontAwesomeIcons.prescriptionBottle,color: kMainRed,size: 12,),
                            SizedBox(width: 3,),
                            Text(
                              'Quantity:  ${_req
                                  .qty
                                  .toString()} L',
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontFamily: 'nunito',
                                  color: Colors.black),
                            ),
                          ]
                      ),
                      SizedBox(height: 5,),
                      Row(
                          children : <Widget>[
                            Icon(FontAwesomeIcons.clock,color: kMainRed,size: 12,),
                            SizedBox(width: 3,),
                            Text(
                              'Due Date: ${_req.dueDate
                                  .toString()}',
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontFamily: 'nunito',
                                  color: kMainRed),
                            ),
                          ]
                      ),
                      Expanded(child:
                      Row(
                          children : <Widget>[
                            Icon(FontAwesomeIcons.mapMarkedAlt,color: kMainRed, size: 12),
                            SizedBox(width:3,),
                            Expanded(child:
                            Text(
                              '${_req.address}',
                              overflow: TextOverflow.ellipsis,
                              // maxLines: 2,
                              //softWrap: false,
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontFamily: 'nunito',
                                  color: Colors.black),

                            ),
                            ),
                          ]
                      ),
                      ),

                      Row(
                          children:<Widget> [
                            Icon(FontAwesomeIcons.ambulance,color: kMainRed,size: 15,),
                            SizedBox(width: 5),
                            Text('${_req.condition
                                .toString()}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  fontFamily: 'nunito',
                                  color: kMainRed),


                            ),
                          ]
                      ),
                      Row(
                        children:[
                          SizedBox(width:175),
                          IconButton(onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => SingleRequestScreen(request: _req),
                            ));
                          }, icon:
                          Icon(Icons.east_outlined,color: kMainRed,)),],
                      ),
                    ],
                  ),
                  ),

                ],
              ),


            ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.of(context).pop();
                                });
                                return AlertDialog(
                                  content: Text("Blood Request Permitted",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 17)),
                                );
                              });
                          FirebaseFirestore.instance.collection("Blood Request Details").doc(_req.reqid)
                              .update({"permission" : true});
                        },
                        child: Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  // bottomRight: Radius.circular(15),
                                ),
                                border:
                                Border.all(width: 1, color: kMainRed),
                                color: Colors.transparent),
                            child: Center(
                              child: Text('Approve'.tr,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: kMainRed,
                                  )),
                            )),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.of(context).pop();
                                });
                                return AlertDialog(
                                  content: Text("Deleted the request",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 17)),
                                );
                              });
                          FirebaseFirestore.instance.collection("Blood Request Details").doc(_req.reqid)
                              .update({"permission" : false, "active": false});
                        },
                        child: Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                // bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),

                              // border: Border.symmetric(horizontal: BorderSide.none),
                              //border: Border.all(width:1, color:Colors.white24),
                             border: Border.all(width: 1, color: kMainRed),
                              color: Colors.transparent,
                            ),
                            child: Center(
                              child: Text('Disapprove'.tr,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: kMainRed,
                                    //letterSpacing: 1
                                  )),
                            )),

                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
            ),
        ],
    );

    // }

    // );
  }





  Container topBanner(BuildContext context) {
    return Container(
        height: bannerHeight,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: kMainRed,
        )
    );
  }

  Container bannerContainer() {
    return
      Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 50.0, right: 10.0, left: 20.0),
          child: Row(
              children:[
                SizedBox(width: 70,),
                Text(
                  "ADMIN PANNEL \n New Requests",
                  style: TextStyle(
                      color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(width:40),
                // IconButton(icon: Icon(Icons.search),color:Colors.white,
                //     onPressed:() async{
                //       Navigator.of(context).push(MaterialPageRoute(
                //         builder: (_) => SearchRequest(),
                //       ));
                //     }         )
              ]
          ));


  }

  Widget getScrollView(){
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
          children: [
            ChoiceChip(
              selectedColor:
              kMainRed,
              //Theme.of(context).accentColor,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 0;
                });
              },
              label: Text('All',
                  style: TextStyle(
                      color: kDarkerGrey)),
              selected: selectedSort == 0,
            ),
            SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              //Theme.of(context).accentColor,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 1;
                });
              },
              label: Text('A+',
                  style: TextStyle(
                    color:kDarkerGrey,)),
              selected: selectedSort == 1,
            ),
            SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 2;
                });
              },
              label: Text('A-',
                  style: TextStyle(
                      color: kDarkerGrey)),
              selected: selectedSort == 2,
            ),
            SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 3;
                });
              },
              label: Text('B+',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 3,
            ),
            SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 4;
                });
              },
              label: Text('B-',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 4,
            ),
            SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 5;
                });
              },
              label: Text('AB+',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 5,
            ),SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 6;
                });
              },
              label: Text('AB-',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 6,
            ),SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 7;
                });
              },
              label: Text('O+',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 7,
            ),SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 8;
                });
              },
              label: Text('O-',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 8,
            ),
          ],
        ));
  }

  //get queries according to blood Group selected..
  /*
      0->all
      1->A+
      2->A-
      3->B+
      4->B-
      5->AB+
      6->AB-
      7->O+
      8->o-
  */
  //.where('bloodGroup',isEqualTo: "A+")

  Query getQuery() {
    switch (selectedSort) {
      case 0:
        return  FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo:false)
            .orderBy('dueDate');
        break;
      case 1:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo:false)
            .where('bloodGroup',isEqualTo: "A+")
            .orderBy('dueDate');
        break;
      case 2:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo:false)
            .where('bloodGroup',isEqualTo: "A-")
            .orderBy('dueDate');
        break;
      case 3:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('bloodGroup',isEqualTo: "B+")
            .orderBy('dueDate');
        break;
      case 4:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo:false)
            .where('permission', isEqualTo:false)
            .where('bloodGroup',isEqualTo: "B-")
            .orderBy('dueDate');
        break;
      case 5:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo:false)
            .where('bloodGroup',isEqualTo: "AB+")
            .orderBy('dueDate');
        break;
      case 6:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo:false)
            .where('bloodGroup',isEqualTo: "AB-")
            .orderBy('dueDate');
        break;
      case 7:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo:false)
            .where('bloodGroup',isEqualTo: "O+")
            .orderBy('dueDate');
        break;
      case 8:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo:false)
            .where('bloodGroup',isEqualTo: "O-")
            .orderBy('dueDate');
        break;
    }
    debugPrint('Unexpected sorting selected');
    return null;
  }
}





