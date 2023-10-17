import 'package:bloc/bloc.dart';
import 'package:custome_mobile/data/models/offer_model.dart';
import 'package:custome_mobile/data/repositories/state_agency_repository.dart';
import 'package:equatable/equatable.dart';

part 'offer_event.dart';
part 'offer_state.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  late StateAgencyRepository stateAgencyRepository;
  OfferBloc({required this.stateAgencyRepository}) : super(OfferInitial()) {
    on<AddOfferEvent>((event, emit) async {
      emit(OfferLoadingProgress());
      try {
        var data = await stateAgencyRepository.postOffer(
          event.packageNum,
          event.tabalehNum,
          event.weight,
          event.price,
          event.taxes,
          event.expectedDate,
          event.notes,
          event.trader,
          event.costumeBroker,
          event.costumeAgency,
          event.costumeState,
          event.product,
          event.origin,
          event.packageType,
          event.attachments,
          event.rawMaterial,
          event.industrial,
        );
        if (data != null) {
          emit(OfferLoadedSuccess(data));
        } else {
          emit(OfferLoadedFailed("error"));
        }
      } catch (e) {
        emit(OfferLoadedFailed(e.toString()));
      }
    });

    on<OfferLoadEvent>(
      (event, emit) async {
        emit(OfferListLoadingProgress());
        try {
          var data = await stateAgencyRepository.getBrokerOffers();
          print('success');

          emit(OfferListLoadedSuccess(data));
        } catch (e) {
          print('offer-error');
          emit(OfferLoadedFailed(e.toString()));
        }
      },
    );

    on<OfferStatusUpdateEvent>(
      (event, emit) async {
        OfferListLoadedSuccess currentState = state as OfferListLoadedSuccess;
        emit(OfferListLoadingProgress());
        try {
          var data = await stateAgencyRepository.updateOfferState(
              event.state, event.offerId);
          if (data) {
            emit(OfferListLoadedSuccess(currentState.offers));
          } else {
            emit(OfferLoadedFailed("خطأ"));
          }
        } catch (e) {
          print('error');
          emit(OfferLoadedFailed(e.toString()));
        }
      },
    );

    on<AddAdditionalAttachmentEvent>(
      (event, emit) async {
        OfferListLoadedSuccess currentState = state as OfferListLoadedSuccess;
        emit(OfferListLoadingProgress());
        try {
          var data =
              await stateAgencyRepository.updateOfferAditionalAttachments(
                  event.additionalList, event.offerId);
          if (data) {
            emit(OfferListLoadedSuccess(currentState.offers));
          } else {
            emit(OfferLoadedFailed("خطأ"));
          }
        } catch (e) {
          print('error');
          emit(OfferLoadedFailed(e.toString()));
        }
      },
    );
  }
}
