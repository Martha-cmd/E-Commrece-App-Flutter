import 'package:flutter/material.dart';
import 'package:zenith_stores/constants.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    double widthC = MediaQuery.of(context).size.width * 100;
    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildHeader(context, widthC),

              SizedBox(height: 10.0),
              _buildInfo(context, widthC),
            ],
          ),
        ));
  }

  Widget _buildHeader(BuildContext context, double width) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 250,
          color: kDarkGreenColor,
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 50),
          child: Column(
            children: <Widget>[
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                color: kDarkGreenColor,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white,
                      width: 6.0,
                    ),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.network(
                          'https://i.picsum.photos/id/65/200/200.jpg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill)),
                ),
              ),
              _buildMainInfo(context, width)
            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 210),
            child: _buildInfoCard(context))
      ],
    );
  }

  Widget _buildInfoCard(context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Card(
            elevation: 5.0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, bottom: 16.0, right: 10.0, left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        'Photos',
                        style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: new Text(
                          '15',
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: kDarkGreenColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new Text(
                        'Followers',
                        style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: new Text(
                          '3.5k',
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: kDarkGreenColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new Text(
                        'Following',
                        style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: new Text(
                          '150',
                          style: new TextStyle(
                              fontSize: 18.0,
                              color:kDarkGreenColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainInfo(BuildContext context, double width) {
    return Container(
      width: width,
      margin: const EdgeInsets.all(10),
      alignment: AlignmentDirectional.center,
      child: Column(
        children: <Widget>[
          Text('Lorem Ipsum',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Flutter',
              style: TextStyle(
                  color: Colors.grey.shade50, fontStyle: FontStyle.italic))
        ],
      ),
    );
  }

  Widget _buildInfo(BuildContext context, double width) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Card(
            color: Colors.white,
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ListTile(
                        leading:
                        Icon(Icons.email, color: kDarkGreenColor),
                        title: Text("E-Mail",
                            style: TextStyle(fontSize: 18, color: Colors.black)),
                        subtitle: Text("email@gmailc.com",
                            style:
                            TextStyle(fontSize: 15, color: Colors.black54)),
                      ),
                      Divider(),
                      ListTile(
                        leading:
                        Icon(Icons.phone, color: kDarkGreenColor),
                        title: Text("Phone Number",
                            style: TextStyle(fontSize: 18, color: Colors.black)),
                        subtitle: Text("11-111111-11",
                            style:
                            TextStyle(fontSize: 15, color: Colors.black54)),
                      ),
                      Divider(),
                      ListTile(
                        leading:
                        Icon(Icons.person, color: kDarkGreenColor),
                        title: Text("About",
                            style: TextStyle(fontSize: 18, color: Colors.black)),
                        subtitle: Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                            style:
                            TextStyle(fontSize: 15, color: Colors.black54)),
                      ),
                      Divider(),
                      ListTile(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        leading: Icon(Icons.my_location,
                            color: kDarkGreenColor),
                        title: Text("Location",
                            style: TextStyle(fontSize: 18, color: Colors.black)),
                        subtitle: Text("Canada",
                            style:
                            TextStyle(fontSize: 15, color: Colors.black54)),
                      ),
                    ],
                  )
                ],
              ),
            ),
        )
    );
}
}