import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

import '../model/profile_mo.dart';

class CourseCard extends StatelessWidget {
  final List<Course> courseList;

  const CourseCard({Key? key, required this.courseList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Update course covers dynamically
    _replaceCoverUrls();

    return Container(
      padding: EdgeInsets.only(left: 10, right: 5, top: 15),
      child: Column(
        children: [_buildTitle(), ..._buildCardList(context)],
      ),
    );
  }

  _buildTitle() {
    return Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Text('Everyday Magic',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            hiSpace(width: 10),
            Text(
              'Life’s a canvas—paint it with wonder',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            )
          ],
        ));
  }

  /// Dynamic layout
  _buildCardList(BuildContext context) {
    var courseGroup = <String, List<Course>>{};

    // Group courses by their group property
    courseList.forEach((mo) {
      String groupKey = mo.group.toString(); // Convert int to String
      if (!courseGroup.containsKey(groupKey)) {
        courseGroup[groupKey] = [];
      }
      courseGroup[groupKey]!.add(mo);
    });

    return courseGroup.entries.map((e) {
      List<Course> list = e.value;
      // Calculate the width and height of each card
      var width =
          (MediaQuery.of(context).size.width - 20 - (list.length - 1) * 5) /
              list.length;
      var height = width / 16 * 6;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...list.map((mo) => _buildCard(context, mo, width, height)).toSet()
        ],
      );
    }).toList();
  }

  _buildCard(BuildContext context, Course mo, double width, double height) {
    return InkWell(
      onTap: () {
        // Show the image in a full-screen dialog
        showDialog(
          context: context,
          builder: (context) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog on tap
              },
              child: Container(
                color: Colors.black,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Optional styling
                    child: cachedImage(
                      mo.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.only(right: 5, bottom: 7),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: cachedImage(mo.cover, width: width, height: height),
        ),
      ),
    );
  }

  /// Replace cover URLs dynamically
  void _replaceCoverUrls() {
    List<String> newCovers = [
      'https://images.unsplash.com/photo-1531981462953-7cea7af328e0?q=80&w=2342&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1531970227416-f0cddeb1f748?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1546638008-efbe0b62c730?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1549955034-7f8d860866e2?q=80&w=2990&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1488274319148-051ed60a9404?q=80&w=2934&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    ];

    for (int i = 0; i < courseList.length; i++) {
      if (i < newCovers.length) {
        courseList[i].cover = newCovers[i];
      }
    }
  }
}
