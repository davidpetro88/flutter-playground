import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

class JobListTitle extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  const JobListTitle({
    Key? key,
    required this.job,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
