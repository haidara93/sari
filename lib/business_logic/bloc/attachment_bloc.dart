// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:custome_mobile/data/models/attachments_models.dart';
import 'package:custome_mobile/data/repositories/state_agency_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'attachment_event.dart';
part 'attachment_state.dart';

class AttachmentBloc extends Bloc<AttachmentEvent, AttachmentState> {
  late StateAgencyRepository stateAgencyRepository;
  AttachmentBloc({required this.stateAgencyRepository})
      : super(AttachmentInitial()) {
    on<AddAttachmentEvent>((event, emit) async {
      if (state is AttachmentInitial) {
        AttachmentInitial currentState = state as AttachmentInitial;
        emit(AttachmentLoadingProgress());
        try {
          var result = await stateAgencyRepository.postAttachment(
              event.image, event.type);
          List<Attachment> attachments = [];
          if (currentState != null) {
            attachments = [];
          }

          attachments.add(result!);
          emit(AttachmentLoadedSuccess(result, attachments));
        } catch (e) {
          emit(AttachmentLoadedFailed(e.toString()));
        }
      } else {
        AttachmentLoadedSuccess currentState = state as AttachmentLoadedSuccess;
        emit(AttachmentLoadingProgress());
        try {
          var result = await stateAgencyRepository.postAttachment(
              event.image, event.type);
          List<Attachment> attachments = [];
          if (currentState != null) {
            attachments = currentState.attachments;
          }

          attachments.add(result!);
          emit(AttachmentLoadedSuccess(result, attachments));
        } catch (e) {
          emit(AttachmentLoadedFailed(e.toString()));
        }
      }
    });
  }
}
