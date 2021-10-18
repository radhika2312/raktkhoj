//import 'package:blooddonation/percentage_widget.dart';
//import 'package:blooddonation/recent_update_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:raktkhoj/Colors.dart';
import 'package:raktkhoj/model/request.dart';
import 'package:raktkhoj/model/user.dart';
import 'package:raktkhoj/screens/donate_here/percentage_widget.dart';
import 'package:raktkhoj/screens/donate_here/single_request_screen.dart';


class Donate extends StatefulWidget {
  Donate({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DonateState createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  double bannerHeight, listHeight, listPaddingTop;
  double cardContainerHeight, cardContainerTopPadding;
  String name="";
  int selectedSort;
  List<String> requestConditonList=["normal","critical"];

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = await _auth.currentUser;
    return currentUser;
  }

  Future<Null> getRaiserName(RequestModel req) async
  {
    final firestoreInstance =  FirebaseFirestore.instance;
    firestoreInstance.collection("User Details").doc(req.raiserUid).get().then((value) {

      setState(() {
        //print(value.data()['Name'].toString());
        name=value.data()["Name"].toString();
       // print('NAme $name');

      });
    });


  }

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
    bannerHeight = MediaQuery.of(context).size.height * .25;
    listHeight = MediaQuery.of(context).size.height * .75;
    cardContainerHeight = 200;

    cardContainerTopPadding = bannerHeight / 2;
    listPaddingTop = cardContainerHeight - (bannerHeight / 2);
    return Scaffold(
      // https://flutter.io/docs/development/ui/layout#stack
      body: Stack(
        children: <Widget>[
          new Column(
            children: <Widget>[
              topBanner(context),
              Expanded(child: bodyBloodRequestList(context))
            ],
          ),
          bannerContainer(),
          cardContainer(context),
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
          getScrollView(),
          rowRecentUpdates(),
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
            //String name=
            return RequestItem(snapshot.data.docs[index], context);
          },
        );
      },
    );
  }






  Widget RequestItem(DocumentSnapshot snapshot, BuildContext context){
    //Message _message = Message.fromMap(snapshot.data());
    RequestModel _req=RequestModel.fromMap(snapshot.data());
    getRaiserName(_req);

    //String name="";
    //print('Reqid: ${_req.raiserUid.toString()}');
    // FirebaseFirestore.instance.collection("User Details").doc(_req.raiserUid).get().then((value){
    //   setState(() {
    //   name=value.data()["Name"].toString();
    //     print(name);
    // });
    // });
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
                vertical: 8.0, horizontal: 5),
            child: Container(
                height: 150,
                width: MediaQuery
                    .of(context)
                    .size
                    .width ,
                decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius:
                    BorderRadius.circular(15),
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
                            SizedBox(
                                height: 40,
                                child: VerticalDivider(
                                  color: Colors.black,
                                  thickness: 1,
                                )),
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

                                SizedBox(height: 5,),
                                //                                     SizedBox(height: 12,),
                                Text(
                                  name,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontFamily: 'nunito',
                                      color: Colors.black),
                                ),
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
                                      Icon(Icons.location_on_sharp,color: kMainRed, size: 12),
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


                                SizedBox(height: 5,),

                                Container(
                                  alignment: Alignment.centerRight,
                                  /*width: MediaQuery
                                  .of(context)
                                  .size
                                  .width -250,*/

                                  child: Row(
                                      children:<Widget> [
                                        Icon(Icons.taxi_alert_sharp,color: kMainRed,size: 15,),
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

                                ),

                                Row(
                                  children:[
                                    SizedBox(width:175),
                                    IconButton(onPressed: (){
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) => SingleRequestScreen(request: _req,name: name,),
                                      ));
                                    }, icon:
                                        Icon(Icons.east_outlined,color: kMainRed,)),],
                                ),

                                //                                      Row(
                                //                                        //mainAxisAlignment: MainAxisAlignment.end,
                                //                                        crossAxisAlignment: CrossAxisAlignment.end,
                                //                                        children: [
                                //                                          SizedBox(width: 80,),
                                //                                          Text(
                                //                                            'Status: ${lists[index]["Status"].toString()}',
                                //                                            style: TextStyle(
                                //                                              fontWeight: FontWeight.w700,
                                //                                                fontSize: 12.5,
                                //                                                fontFamily: 'nunito',
                                //                                                color: kMainRed),
                                //                                          ),
                                //                                        ],
                                //                                      ),
                              ],
                            ),
                            ),

                          ],
                        ),


                    ),
            ),
          ),

      ],
    );
  }

  /*ListView listRecentUpdates() {

      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: false,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            //return RecentUpdateListWidget();
            return new ListView.builder(
                shrinkWrap: true,
                itemCount: requestList.length,
                // physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {

                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10),
                          child: Container(
                            height: 109,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 20,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(15),
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
                                  width: 75,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .center,
                                    children: <Widget>[
                                      Text(
                                        requestList[index].bloodGroup,
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
                                SizedBox(
                                    height: 35,
                                    child: VerticalDivider(
                                      color: Colors.black,
                                      thickness: 1,
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: 5,),
//                                     SizedBox(height: 12,),
                                    Text(
                                      'Hospital Name :  ${getRaiserName(
                                          requestList[index].raiserUid)
                                          .toString()}',
                                      style: TextStyle(
                                          fontSize: 12.5,
                                          fontFamily: 'nunito',
                                          color: Colors.black),
                                    ),
                                    Text(
                                      'Units Required :  ${requestList[index]
                                          .qty
                                          .toString()}',
                                      style: TextStyle(
                                          fontSize: 12.5,
                                          fontFamily: 'nunito',
                                          color: Colors.black),
                                    ),
                                    Text(
                                      'Deadline :  ${requestList[index].dueDate
                                          .toString()}',
                                      style: TextStyle(
                                          fontSize: 12.5,
                                          fontFamily: 'nunito',
                                          color: Colors.black),
                                    ),
                                    Text(
                                      'Contact Number :  ${requestList[index]
                                          .phone
                                          .toString()}',
                                      style: TextStyle(
                                          fontSize: 12.5,
                                          fontFamily: 'nunito',
                                          color: Colors.black),
                                    ),
                                    SizedBox(height: 5,),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width - 140,
                                      child: Text(
                                        'Status: ${requestList[index].condition
                                            .toString()}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                            fontFamily: 'nunito',
                                            color: kMainRed),
                                      ),
                                    ),
//                                      Row(
//                                        //mainAxisAlignment: MainAxisAlignment.end,
//                                        crossAxisAlignment: CrossAxisAlignment.end,
//                                        children: [
//                                          SizedBox(width: 80,),
//                                          Text(
//                                            'Status: ${lists[index]["Status"].toString()}',
//                                            style: TextStyle(
//                                              fontWeight: FontWeight.w700,
//                                                fontSize: 12.5,
//                                                fontFamily: 'nunito',
//                                                color: kMainRed),
//                                          ),
//                                        ],
//                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          });
    }*/



  Row rowRecentUpdates() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      children: <Widget>[
        InkWell(
          onTap: (){
            requestConditonList=["critical"];
          },
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Emergencies",
                style: TextStyle(color: kMainRed, fontSize: 17.0)),

          ),
        ),
        InkWell(
          onTap: (){
            requestConditonList=["critical","normal"];
          },
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("View All",
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0)),
          ),
        )
      ],
    );
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
    return Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0),
        child: Text(
          "Blood Requests",
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ));
  }

  Container cardContainer(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: new EdgeInsets.only(
          top: cardContainerTopPadding, right: 20.0, left: 20.0),
      child: Container(
        height: cardContainerHeight,
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                PercentageWidget(
                  size: 120.0,
                  title: 'Available',
                  count: 126,
                  percentage: 22,
                  countLeft: true,
                ),
                PercentageWidget(
                  size: 120.0,
                  title: 'Requests',
                  count: 248,
                  percentage: 56,
                  countLeft: false,
                ),
                SizedBox(
                  height: 60.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
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
            .orderBy('dueDate');
        break;
      case 1:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('bloodGroup',isEqualTo: "A+")
            .orderBy('dueDate');
        break;
      case 2:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
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
            .where('bloodGroup',isEqualTo: "B-")
            .orderBy('dueDate');
        break;
      case 5:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('bloodGroup',isEqualTo: "AB+")
            .orderBy('dueDate');
        break;
      case 6:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('bloodGroup',isEqualTo: "AB-")
            .orderBy('dueDate');
        break;
      case 7:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('bloodGroup',isEqualTo: "O+")
            .orderBy('dueDate');
        break;
      case 8:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('bloodGroup',isEqualTo: "O-")
            .orderBy('dueDate');
        break;
    }
    debugPrint('Unexpected sorting selected');
    return null;
  }
}





