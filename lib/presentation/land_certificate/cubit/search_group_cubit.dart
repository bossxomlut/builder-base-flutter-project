import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entity/filter_land_certificate_entity.dart';
import '../../../domain/index.dart';
import '../../utils/index.dart';

@injectable
class SearchGroupCubit extends Cubit<SearchGroupState> with SafeEmit<SearchGroupState> {
  SearchGroupCubit(this.repository, this._landCertificateObserverData) : super(SearchGroupState()) {
    startListen();
  }

  final SearchGroupCertificateRepository repository;
  final LandCertificateObserverData _landCertificateObserverData;

  void startListen() {
    _landCertificateObserverData.listener(
      (void value) {
        search(state.query);
      },
    );
  }

  @override
  Future<void> close() {
    _landCertificateObserverData.cancelListen();
    return super.close();
  }

  void search(String query) {
    // repository.search(query).then((list) {
    //   emit(state.copyWith(query: query, list: list));
    // });
    searchAndFilter(query);
  }

  void searchAndFilter(String query) {
    repository.searchAndFilter(query, state.filter).then((list) {
      emit(state.copyWith(query: query, list: list));
    });
  }

  void setFilter(FilterLandCertificateEntity? filter) {
    emit(SearchGroupState(query: state.query, list: state.list, filter: filter));
    searchAndFilter(state.query);
  }
}

class SearchGroupState extends Equatable {
  final String query;
  final FilterLandCertificateEntity? filter;
  final List<ProvinceCountEntity> list;

  SearchGroupState({
    this.query = '',
    this.list = const [],
    this.filter,
  });

  SearchGroupState copyWith({
    String? query,
    List<ProvinceCountEntity>? list,
    FilterLandCertificateEntity? filter,
  }) {
    return SearchGroupState(
      query: query ?? this.query,
      list: list ?? this.list,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [
        query,
        list.hashCode,
        filter,
      ];
}
