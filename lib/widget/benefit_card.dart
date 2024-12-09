import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:streamly/model/profile_mo.dart';

import '../util/view_util.dart';
import 'hi_blur.dart';

class BenefitCard extends StatelessWidget {
  final List<String> computerCourses;

  BenefitCard(
      {Key? key,
      required this.computerCourses,
      required List<Benefit> benefitList})
      : super(key: key);

  final Map<String, String> courseLinks = {
    'Introduction to Programming':
        'https://ocw.mit.edu/courses/6-092-introduction-to-programming-in-java-january-iap-2010/',
    'Data Structures & Algorithms':
        'https://ocw.mit.edu/courses/6-851-advanced-data-structures-spring-2012/',
    'Machine Learning Fundamentals':
        'https://ocw.mit.edu/courses/6-867-machine-learning-fall-2006/',
    'Database Management Systems':
        'https://ocw.mit.edu/courses/6-830-database-systems-fall-2010/',
    'Cloud Computing': 'https://www.cs.cmu.edu/~msakr/15619-s24/',
    'Computer Networks': 'https://www.cs.cmu.edu/~prs/15-441-F17/syllabus.html',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 5, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildTitle(), _buildBenefit(context)],
      ),
    );
  }

  _buildTitle() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            'Professional Growth',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          hiSpace(width: 10),
          Flexible(
            child: Text(
              'Elevate Your Career',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  _buildCard(BuildContext context, String course, double width) {
    return InkWell(
      onTap: () async {
        final url = courseLinks[course];
        if (url != null) {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            print('Could not launch $url');
          }
        } else {
          print('No URL available for $course');
        }
      },
      child: Container(
        width: width,
        height: 80, // Adjust height as needed
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  course,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2, // Limit to 2 lines
                  overflow:
                      TextOverflow.ellipsis, // Add ellipsis if text is too long
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildBenefit(BuildContext context) {
    // Calculate the width of each card based on the number of courses
    var screenWidth = MediaQuery.of(context).size.width;
    var width =
        (screenWidth - 40) / 3; // 10 padding on left & right, 10 between cards

    return Wrap(
      spacing: 10.0, // Horizontal spacing between cards
      runSpacing: 10.0, // Vertical spacing between rows
      children: [
        ...computerCourses
            .map((course) => _buildCard(context, course, width))
            .toList(),
      ],
    );
  }
}
