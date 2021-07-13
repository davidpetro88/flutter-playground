import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);

  Stream<List<Job>> jobsStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabse implements Database {
  final String uid;
  final _service = FirestoreService.instance;

  FirestoreDatabse({required this.uid});

  @override
  Future<void> setJob(Job job) => _service.setData(
      path: ApiPath.job(uid, job.id), data: job.toMap());

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: ApiPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

/*
    @override
    Stream<List<Job>> jobsStream() {
      final path = ApiPath.jobs(uid);
      final reference = FirebaseFirestore.instance.collection(path);
      final snapshots = reference.snapshots();
      // snapshots.listen((snapshot) {
      //   snapshot.docs.forEach((value) => print(value.data()));
      // });
      return snapshots.map((snapshot) => snapshot.docs
          .map(
            (value) => Job.fromMap(value.data()),
          )
          .toList());
    }
   */

}
