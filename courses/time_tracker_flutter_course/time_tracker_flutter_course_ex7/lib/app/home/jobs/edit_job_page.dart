import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EditJobPage extends StatefulWidget {
  final Database database;
  final Job? job;

  const EditJobPage({Key? key, required this.database, this.job})
      : super(key: key);

  static Future<void> show(BuildContext context, {Job? job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  int? _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      if (widget.job?.name != null) {
        _name = widget.job!.name;
        _ratePerHour = widget.job!.ratePerHour;
      }
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form == null) return false;
    form.save(); //Execute onSaved from TextFormField
    if (form.validate())
      return true; //form.validate execute the validate from TextFormField
    form.save();
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        //enable name to edit
        if (widget.job != null) allNames.remove(_name);
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id, name: _name!, ratePerHour: _ratePerHour!);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: 'Operation failed', exception: e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job': 'Edit Job'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job name'),
        initialValue: _name,
        onSaved: (String? value) => _name = value,
        validator: (String? value) =>
            (value != null && value.isNotEmpty) ? null : 'Name can\'t be empty',
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = _raterPerHourCheck(value),
      ),
    ];
  }

  int? _raterPerHourCheck(String? value) {
    if (value == null) return 0;
    return int.tryParse(value);
  }

// Future<void> _createJob(BuildContext context) async {
//   try {
//     final database = Provider.of<Database>(context, listen: false);
//     await database.createJob(Job(name: 'Blogging', ratePerHour: 10));
//   } on FirebaseException catch (e) {
//     if (e.code == 'permission-denied') {}
//     showExceptionAlertDialog(
//       context,
//       title: 'Operation failed',
//       exception: e,
//     );
//   }
// }

}
