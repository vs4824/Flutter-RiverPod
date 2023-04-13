import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/search_screen_repo.dart';
import 'food_main_page_provider.dart';

final fetchSearchDataNotifierProvider = StateNotifierProvider<FetchSearchDataNotifier, Map<String, dynamic>>((ref){
  SearchRepoService service = ref.read(searchAPIProvider);
  final id = ref.watch(fetchIdProvider);
  return FetchSearchDataNotifier(service,id);
});

final searchFromAPINotifierProvider = StateNotifierProvider<SearchFromAPINotifier, Map<String, dynamic>>((ref){
  SearchRepoService service = ref.read(searchAPIProvider);
  final id = ref.watch(fetchIdProvider);
  final value = ref.watch(valueProvider);
  return SearchFromAPINotifier(service,id,value);
});


final valueProvider = StateProvider<String>((ref)=> "");


class FetchSearchDataNotifier extends StateNotifier<Map<String, dynamic>> {
  FetchSearchDataNotifier(this.service,this.id) : super({}) {
    getCategory(id);
  }
  final SearchRepoService service;
  final String id;

  void getCategory(String id) async {
    state = await SearchRepoService.fetchSearchData(id: id);
  }
}

class SearchFromAPINotifier extends StateNotifier<Map<String, dynamic>> {
  SearchFromAPINotifier(this.service,this.id,this.value) : super({}) {
    getCategory(id,value);
  }
  final SearchRepoService service;
  final String id;
  final String value;

  void getCategory(String id, String value) async {
    state = await SearchRepoService.searchFromApi(id: id,value: value);
  }
}



