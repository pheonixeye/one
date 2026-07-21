import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/progress_notes_api.dart';
import 'package:one/models/patient_progress_note.dart';

class PxProgressNotes extends ChangeNotifier {
  final ProgressNotesApi api;

  PxProgressNotes({required this.api}) {
    _init();
  }

  ApiResult<List<PatientProgressNote>>? _result;
  ApiResult<List<PatientProgressNote>>? get result => _result;

  List<PatientProgressNote> _notes = [];
  List<PatientProgressNote> get notes => _notes;

  int _page = 1;
  int get page => _page;

  static const _perPage = 10;

  Future<void> retry() async => await _init();

  Future<void> _init() async {
    _result = await api.fetchPaginatedProgressNotes(
      page: page,
      perPage: _perPage,
    );
    if (_result != null) {
      _notes = [
        ..._notes,
        ...(_result as ApiDataResult<List<PatientProgressNote>>).data,
      ];
      notifyListeners();
    }
  }

  Future<void> fetchNextBatch() async {
    if (_result != null &&
        (_result! as ApiDataResult<List<PatientProgressNote>>).data.length ==
            _perPage) {
      _page++;
      await _init();
    }
  }

  Future<void> createNote(PatientProgressNote note) async {
    final _result = await api.createProgressNote(note);
    if (_result is ApiDataResult<PatientProgressNote>) {
      final _data = _result.data;
      _notes.add(_data);
      notifyListeners();
      _notes.sort((a, b) => a.time_of_note.isBefore(b.time_of_note) ? 1 : 0);
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    final _isSuccess = await api.deleteProgressNote(id);
    if (_isSuccess) {
      _notes.removeWhere((e) => e.id == id);
      notifyListeners();
    }
  }

  Future<void> updateNote(String id, Map<String, dynamic> update) async {
    final _index = _notes.indexWhere((e) => e.id == id);
    final _updatedResult = await api.updateProgressNote(id, update);
    final _note = (_updatedResult as ApiDataResult<PatientProgressNote>).data;
    // ignore: unnecessary_type_check
    if (_updatedResult is ApiDataResult<PatientProgressNote>) {
      _notes[_index] = _note;
      notifyListeners();
    }
  }
}
