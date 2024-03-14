import 'package:mobx/mobx.dart';
import 'package:oneanime/bean/anime/anime_info.dart';
import 'package:oneanime/request/list.dart';
import 'package:oneanime/request/video.dart';
import 'package:oneanime/pages/video/video_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'popular_controller.g.dart';

class PopularController = _PopularController with _$PopularController;

abstract class _PopularController with Store {
  @observable
  List<AnimeInfo> list = [];

  Future getAnimeList() async {
    list = await ListRequest.getAnimeList();
  }

  Future getFullLink(String url) async {
    return await VideoRequest.getFullLink(url);
  }

  Future getPageTitle(String url) async {
    var result = await VideoRequest.getPageTitle(url); 
    final VideoController videoController = Modular.get<VideoController>();
    videoController.title = result;
  }

  Future getVideoLink(String url, {int episode = 1}) async {
    final VideoController videoController = Modular.get<VideoController>(); 
    videoController.token = await VideoRequest.getVideoToken(url);
    var result = await VideoRequest.getVideoLink(videoController.token[videoController.token.length - episode]);
    videoController.videoUrl = result['link']; 
    videoController.videoCookie = result['cookie'];
  }
}