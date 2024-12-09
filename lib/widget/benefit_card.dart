import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamly/model/profile_mo.dart';

import '../util/view_util.dart';
import 'hi_blur.dart';

class BenefitCard extends StatelessWidget {
  final List<String> computerCourses;

  const BenefitCard(
      {Key? key,
      required this.computerCourses,
      required List<Benefit> benefitList})
      : super(key: key);

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
      onTap: () {
        print('Selected course: $course');
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
