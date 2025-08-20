import 'package:aninder/core/utils/NetworkMonitor.dart';
import 'package:aninder/feature/ui/elements/FailureNetworkConnectionWidget.dart';
import 'package:aninder/feature/ui/elements/RowWithDropDown.dart';
import 'package:flutter/material.dart';

import '../../../graphql/get_media_list.graphql.dart';
import '../elements/AnimeCard.dart';
import '../elements/PaginatedSwappedCards.dart';
import '../viewmodels/FeedViewModel.dart';

class FeedScreen extends StatefulWidget {
  final List<String> selectedGenres;
  final List<String> selectedTags;
  final int selectedYear;
  FeedViewModel viewModel = FeedViewModel();

  FeedScreen(
      {required this.selectedGenres,
      required this.selectedTags,
      required this.selectedYear,
      super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  NetworkMonitor networkMonitor = NetworkMonitor();
  bool isNetworkConnected = true;

  List<Query$GetMediaListByYear$Page$media?> mediaList = [];
  bool isShowLoader = true;

  @override
  void initState() {
    super.initState();
    networkMonitor.networkStatus.listen((status) async {
      if (status) {
        widget.viewModel.selectYear(widget.selectedYear.toString());
        final media = await widget.viewModel.getMediaByYear(
            widget.selectedYear, widget.selectedGenres, widget.selectedTags);
        if (media != null) {
          setState(() {
            mediaList = media.Page!.media!;
            isShowLoader = false;
          });
        }
      }
      setState(() {
        isNetworkConnected = status;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isNetworkConnected
          ? Stack(
              children: [
                if (!isShowLoader)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(  //TODO fix when (currentYear + 1) like next year
                          'Get list by ${widget.selectedYear + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              isShowLoader = true;
                              mediaList.clear();
                              widget.viewModel
                                  .selectYear("${widget.selectedYear + 1}");
                              widget.viewModel.getMediaByYear(
                                  widget.selectedYear,
                                  widget.selectedGenres,
                                  widget.selectedTags);
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.grey, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('GO'),
                        ),
                      ],
                    ),
                  ),
                if (mediaList.isNotEmpty)
                  PaginatedSwappedCards(
                    items: mediaList.reversed.toList(),
                    onSwipeRight: (media) {},
                    onSwipeLeft: (media) {
                      //widget.viewModel.onEvent(OnMediaToListAdd(media));
                    },
                    content: (media) => AnimeCard(
                      anime: media,
                      animeFavouriteIconClick: (id) {
                        //  widget.viewModel.onEvent(OnMediaFavoriteChanged(media));
                      },
                      charFavouriteIconClick: (id) {
                        //  widget.viewModel.onEvent(OnCharacterFavoriteAdd(media));
                      },
                      goToAnimePageClick: (id) {
                        //   widget.onNavigate("MEDIA/${media.id}");
                      },
                    ),
                  ),
                if (mediaList.isNotEmpty)
                  Positioned(
                    bottom: 45,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.arrow_forward, color: Colors.white),
                            SizedBox(width: 8),
                            Text("SKIP",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w400)),
                          ],
                        ),
                        RowWithDropdown(
                            items: const [
                              "COMPLETED",
                              "SKIP"
                            ] /*widget.viewModel.statusList*/,
                            onSelected: (selectedText) {
                              //TODO
                            }),
                      ],
                    ),
                  ),
                if (isShowLoader)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                      strokeWidth: 5,
                    ),
                  ),
              ],
            )
          : FailureNetworkConnectionWidget(),
    );
  }
}
