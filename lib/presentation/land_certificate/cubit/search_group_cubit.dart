import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/index.dart';

@injectable
class SearchGroupCubit extends Cubit<SearchGroupState> {
  SearchGroupCubit(this.repository) : super(SearchGroupState());

  final SearchGroupCertificateRepository repository;

  void search(String query) {
    repository.search(query).then((list) {
      emit(state.copyWith(query: query, list: list));
    });
  }
}

class SearchGroupState extends Equatable {
  final String query;
  final List<ProvinceCountEntity> list;

  SearchGroupState({this.query = '', this.list = const []});

  SearchGroupState copyWith({
    String? query,
    List<ProvinceCountEntity>? list,
  }) {
    return SearchGroupState(
      query: query ?? this.query,
      list: list ?? this.list,
    );
  }

  @override
  List<Object?> get props => [
        query,
        list.hashCode,
      ];
}
