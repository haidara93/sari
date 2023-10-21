import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:custome_mobile/data/models/attachments_models.dart';
import 'package:custome_mobile/data/repositories/state_agency_repository.dart';
import 'package:equatable/equatable.dart';

part 'additional_attachment_event.dart';
part 'additional_attachment_state.dart';

class AdditionalAttachmentBloc
    extends Bloc<AdditionalAttachmentEvent, AdditionalAttachmentState> {
  late StateAgencyRepository stateAgencyRepository;
  AdditionalAttachmentBloc({required this.stateAgencyRepository})
      : super(AdditionalAttachmentInitial()) {
    on<AddAdditionalAttachmentEvent>((event, emit) async {
      if (state is AdditionalAttachmentInitial) {
        AdditionalAttachmentInitial currentState =
            state as AdditionalAttachmentInitial;
        emit(AdditionalAttachmentLoadingProgress());
        try {
          var result = await stateAgencyRepository.postAttachment(
              event.image, event.type);
          List<Attachment> attachments = [];
          if (currentState != null) {
            attachments = [];
          }
          attachments.add(result!);
          List<int> newattachments = event.attachments;
          newattachments.add(result.id!);

          List<int> newaddattachments = [];
          for (var element in event.additionalattachments) {
            newaddattachments.add(element.id!);
          }
          newaddattachments.remove(event.type);

          var offer =
              await stateAgencyRepository.updateOfferAditionalAttachments(
                  newattachments, newaddattachments, event.offerId);
          List<AttachmentType> newAdditional = event.additionalattachments;
          for (var element in newAdditional) {
            if (element.id! == event.type) {
              newAdditional.remove(element);
              break;
            }
          }
          emit(AdditionalAttachmentLoadedSuccess(
              result, attachments, newAdditional));
        } catch (e) {
          emit(AdditionalAttachmentLoadedFailed(e.toString()));
        }
      } else {
        AdditionalAttachmentLoadedSuccess currentState =
            state as AdditionalAttachmentLoadedSuccess;
        emit(AdditionalAttachmentLoadingProgress());
        try {
          var result = await stateAgencyRepository.postAttachment(
              event.image, event.type);
          List<Attachment> attachments = [];
          if (currentState != null) {
            attachments = currentState.attachments;
          }

          attachments.add(result!);
          List<int> newattachments = event.attachments;
          newattachments.add(result.id!);

          List<int> newaddattachments = [];
          for (var element in event.additionalattachments) {
            newaddattachments.add(element.id!);
          }
          newaddattachments.remove(event.type);

          var offer =
              await stateAgencyRepository.updateOfferAditionalAttachments(
                  newattachments, newaddattachments, event.offerId);
          List<AttachmentType> newAdditional = event.additionalattachments;
          for (var element in newAdditional) {
            if (element.id! == event.type) {
              newAdditional.remove(element);
              break;
            }
          }
          emit(AdditionalAttachmentLoadedSuccess(
              result, attachments, newAdditional));
        } catch (e) {
          emit(AdditionalAttachmentLoadedFailed(e.toString()));
        }
      }
    });
  }
}
