import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/app_constants/patient_progress_status.dart';
import 'package:one/models/app_constants/visit_status.dart';
import 'package:one/models/app_constants/visit_type.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/providers/px_locale.dart';
import 'package:provider/provider.dart';

extension CalculateFees on Visit {
  num fees_for_bookkeeping(Clinic clinic) {
    late num fees;
    //check visit type
    if (visit_type == VisitTypeEnum.Consultation.en) {
      fees = clinic.consultation_fees;
    } else if (visit_type == VisitTypeEnum.FollowUp.en) {
      fees = clinic.followup_fees;
    } else {
      fees = clinic.procedure_fees;
    }
    //check visit status
    if (visit_status == VisitStatusEnum.NotAttended.en) {
      fees = 0;
    }

    return fees;
  }
}

extension WxColorsVisitType on VisitType {
  Color get getCardColor {
    return switch (name_en) {
      'Consultation' => Colors.blue.shade50,
      'Follow Up' => Colors.amber.shade50,
      'Procedure' => Colors.green.shade50,
      _ => Colors.transparent,
    };
  }
}

extension WxColorsVisitStatus on VisitStatus {
  Color get getCardColor {
    return switch (name_en) {
      'Attended' => Colors.blue.shade50,
      'Not Attended' => Colors.red.shade50,
      _ => Colors.transparent,
    };
  }
}

extension WxColorsPatientProgressStatus on PatientProgressStatus {
  Color get getCardColor {
    return switch (name_en) {
      'Has Not Attended Yet' => Colors.purple.shade50,
      'Done Consultation' => Colors.blue.shade50,
      'In Consultation' => Colors.green.shade50,
      'In Waiting' => Colors.amber.shade50,
      'Canceled' => Colors.red.shade50,
      _ => Colors.transparent,
    };
  }
}

extension FormattedVisitScheduleShift on Visit {
  String formattedShift(BuildContext context) {
    final _lx = context.read<PxLocale>();
    final _now = DateTime.now();
    final _start_time = _now.copyWith(
      hour: s_h.toInt(),
      minute: s_m.toInt(),
    );
    final _end_time = _now.copyWith(
      hour: e_h.toInt(),
      minute: e_m.toInt(),
    );
    final _formattedStart = DateFormat.jmv(_lx.lang).format(_start_time);
    final _formattedEnd = DateFormat.jmv(_lx.lang).format(_end_time);

    return '${context.loc.from} : $_formattedStart - ${context.loc.to} : $_formattedEnd';
  }
}
