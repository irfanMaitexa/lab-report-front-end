import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_report/user/doctordetails.dart';
import 'package:translator/translator.dart';

class ResultScreen extends StatefulWidget {
  final Map<String, dynamic> resultData;

  ResultScreen({required this.resultData});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isAnimated = false;
  bool isTranslate = false;
  final translator = GoogleTranslator();
  late Future<Map<String, dynamic>> _resultFuture;

  @override
  void initState() {
    super.initState();
    _resultFuture = Future.delayed(Duration(milliseconds: 500),
        () => widget.resultData); // Mimic delay for loading
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimated = true;
      });
    });
  }

  // Translate the given text to Malayalam
  Future<String> translateMalayalam(String input) async {
    var translation = await translator.translate(input, to: 'ml');
    return translation.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: ElevatedButton(
        style: ElevatedButton.styleFrom(


          fixedSize: Size(MediaQuery.of(context).size.width, 50),
          
          backgroundColor: Colors.teal,

          

        ),
        onPressed:() {

          Navigator.push(context, MaterialPageRoute(builder:(context) => DoctorsListScreen() ,));

        
      }, child: Text("book",style: TextStyle(color: Colors.white),)),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.resultData['anemia_detected']
              ? 'Anemia Detected'
              : 'No Anemia Detected',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        actions: [
          Switch(
            value: isTranslate,
            thumbIcon: WidgetStatePropertyAll(Icon(Icons.translate)),
            activeColor: Colors.teal,
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white,
            onChanged: (value) {
              setState(() {
                isTranslate = value;
              });
            },
          ),
        ],
        backgroundColor: Colors.teal,
        elevation: 6,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _resultFuture,
        builder: (context, snapshot) {
          // Show a single loading indicator when data is loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data.'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final bool anemiaDetected = data['anemia_detected'];
            final additionalInfo = data['additional_info'];

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: !anemiaDetected
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          _buildSectionHeading('No Anemia Detected'),
                          _buildSectionContainer(
                            content: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: FutureBuilder<String>(
                                  future: isTranslate
                                      ? translateMalayalam(
                                          additionalInfo['message'])
                                      : Future.value(additionalInfo['message']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(); // No need to show multiple indicators here
                                    } else {
                                      return Text(
                                        snapshot.data ?? '',
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.black87),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                            backgroundColor: Colors.white,
                          ),
                          Spacer(),
                          Center(
                            child: AnimatedScale(
                              scale: _isAnimated ? 1.5 : 1.0,
                              duration: Duration(seconds: 1),
                              curve: Curves.easeInOut,
                              child: Image.asset(
                                'asset/healthcare.png',
                                height: 110,
                                width: 110,
                              ),
                            ),
                          ),
                          SizedBox(height: 70),
                          Text(
                            'Great Job! Keep up the\n good health!',
                            style: GoogleFonts.roboto(
                                fontSize: 24,
                                color: Colors.teal,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                        ],
                      ),
                    )
                  : ListView(
                      children: [
                        if (anemiaDetected) ...[
                          _buildSectionContainer(
                            content: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: FutureBuilder<String>(
                                  future: isTranslate
                                      ? translateMalayalam(
                                          additionalInfo['advice'])
                                      : Future.value(additionalInfo['advice']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(); // No need to show multiple indicators here
                                    } else {
                                      return Text(
                                        snapshot.data ?? '',
                                        style: GoogleFonts.roboto(
                                            fontSize: 16, color: Colors.white),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                            backgroundColor: Colors.teal,
                          ),
                          _buildSectionHeading('Symptoms'),
                          _buildSectionContainer(
                            content: additionalInfo['symptoms']
                                .map<Widget>((symptom) {
                              return FutureBuilder<String>(
                                future: isTranslate
                                    ? translateMalayalam(symptom)
                                    : Future.value(symptom),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(); // No need to show multiple indicators here
                                  } else {
                                    return _buildListItem(snapshot.data ?? '');
                                  }
                                },
                              );
                            }).toList(),
                            backgroundColor: Colors.white,
                          ),
                          _buildSectionHeading('Treatment'),
                          _buildSectionContainer(
                            content: additionalInfo['treatment']
                                .map<Widget>((treatment) {
                              return FutureBuilder<String>(
                                future: isTranslate
                                    ? translateMalayalam(treatment)
                                    : Future.value(treatment),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(); // No need to show multiple indicators here
                                  } else {
                                    return _buildListItem(snapshot.data ?? '');
                                  }
                                },
                              );
                            }).toList(),
                            backgroundColor: Colors.white,
                          ),
                          _buildSectionHeading('Diet Recommendations'),
                          _buildSectionContainer(
                            content: additionalInfo['diet'].map<Widget>((diet) {
                              return FutureBuilder<String>(
                                future: isTranslate
                                    ? translateMalayalam(diet)
                                    : Future.value(diet),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(); // No need to show multiple indicators here
                                  } else {
                                    return _buildListItem(snapshot.data ?? '');
                                  }
                                },
                              );
                            }).toList(),
                            backgroundColor: Colors.white,
                          ),
                          _buildSectionHeading('Exercise Recommendations'),
                          _buildSectionContainer(
                            content: additionalInfo['exercise']
                                .map<Widget>((exercise) {
                              return FutureBuilder<String>(
                                future: isTranslate
                                    ? translateMalayalam(exercise)
                                    : Future.value(exercise),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(); // No need to show multiple indicators here
                                  } else {
                                    return _buildListItem(snapshot.data ?? '');
                                  }
                                },
                              );
                            }).toList(),
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ],
                    ),
            );
          } else {
            return Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }

  // Widget for the section heading
  Widget _buildSectionHeading(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Text(
            '$title :',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({
    required List<Widget> content,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...content,
        ],
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 22,
            color: Colors.teal,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
