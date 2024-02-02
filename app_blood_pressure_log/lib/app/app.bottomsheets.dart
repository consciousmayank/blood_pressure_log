// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedBottomsheetGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/bottom_sheets/add_record/add_record_sheet.dart';
import '../ui/bottom_sheets/errors/errors_sheet.dart';
import '../ui/bottom_sheets/notice/notice_sheet.dart';
import '../ui/bottom_sheets/view_record/view_record_sheet.dart';

enum BottomSheetType {
  notice,
  viewRecord,
  errors,
  addRecord,
}

void setupBottomSheetUi() {
  final bottomsheetService = locator<BottomSheetService>();

  final Map<BottomSheetType, SheetBuilder> builders = {
    BottomSheetType.notice: (context, request, completer) =>
        NoticeSheet(request: request, completer: completer),
    BottomSheetType.viewRecord: (context, request, completer) =>
        ViewRecordSheet(request: request, completer: completer),
    BottomSheetType.errors: (context, request, completer) =>
        ErrorsSheet(request: request, completer: completer),
    BottomSheetType.addRecord: (context, request, completer) =>
        AddRecordSheet(request: request, completer: completer),
  };

  bottomsheetService.setCustomSheetBuilders(builders);
}
