import 'package:aninder/core/utils/NetworkMonitor.dart';
import 'package:aninder/feature/ui/elements/FailureNetworkConnectionWidget.dart';
import 'package:flutter/material.dart';


import '../../data/models/Media.dart';
import '../elements/AnimeCard.dart';
import '../elements/PaginatedSwappedCards.dart';

class FeedScreen extends StatefulWidget {
  final List<String> selectedGenres;
  final List<String> selectedTags;
  final int currentYear;

  const FeedScreen({
    required this.selectedGenres,
    required this.selectedTags,
    required this.currentYear,
    super.key
  });

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  NetworkMonitor networkMonitor = NetworkMonitor();
  bool isNetworkConnected = true;

  final List<Media> mediaList = [];
  bool isShowLoader = true;

  @override
  void initState() {
    super.initState();
    networkMonitor.networkStatus.listen((status){
      setState(() {isNetworkConnected = status;});
    });
/*    if (widget.viewModel.isConnected) {
      widget.viewModel.getStatusList();
      widget.viewModel.getMediaByYear(
        widget.parentViewModel.currentYear,
        widget.parentViewModel.selectedGenres,
        widget.parentViewModel.selectedTags,
      );
    }

    widget.viewModel.feedEventStream.listen((event) {
      setState(() {
        if (event is OnMediaListSet) {
          mediaList.clear();
          mediaList.addAll(event.mediaList);
          isShowLoader = false;
        } else if (event is OnMediaToListAdd) {
          // handle accordingly
        }
        // Handle other events similarly
      });
    });*/
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
                        Text(
                          'Get list by ${widget.currentYear + 1}',
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
                            /*  widget.parentViewModel.setCurrentYear(
                                widget.parentViewModel.currentYear + 1,
                              );
                              widget.viewModel.getMediaByYear(
                                widget.parentViewModel.currentYear,
                                widget.parentViewModel.selectedGenres,
                                widget.parentViewModel.selectedTags,
                              );*/
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
                    bottom: 14,
                    left: 14,
                    right: 14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.arrow_forward, color: Colors.white),
                            SizedBox(width: 8),
                            Text("SKIP", style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        /*RowWithDropdown(
                          items: widget.viewModel.statusList,
                          onSelected: (selectedText) {
                          },
                        ),*/
                      ],
                    ),
                  ),
                if (isShowLoader && mediaList.isEmpty)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                      strokeWidth: 5,
                    ),
                  ),
              ],
            )
          :  FailureNetworkConnectionWidget(),
    );
  }
}

