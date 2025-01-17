import 'package:flutter/material.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:lottie/lottie.dart';

import '../widget/loading_container.dart';

/// Base tab state for pages with pagination, refresh, and Lottie loading animation
/// M: Data model returned by the DAO
/// L: List data type
/// T: Widget type
abstract class HiBaseTabState<M, L, T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  List<L> dataList = []; // Holds the list data
  int pageIndex = 1; // Tracks the current page index
  bool loading = false; // Indicates if data is being loaded
  final ScrollController scrollController = ScrollController();

  /// Override to define the page's content
  Widget get contentChild;

  /// Lottie loading animation view
  Widget get _loadingView {
    return LoadingContainer(
      isLoading: loading && dataList.isEmpty,
      child: contentChild, // Displays content when not loading
      cover: false, // No overlay during initial load
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      var distanceToBottom = scrollController.position.maxScrollExtent -
          scrollController.position.pixels;
      if (distanceToBottom < 300 &&
          !loading &&
          scrollController.position.maxScrollExtent != 0) {
        loadData(loadMore: true);
      }
    });
    loadData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: loadData,
      color: Theme.of(context).primaryColor,
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: _loadingView,
      ),
    );
  }

  /// Fetch data for the current page
  Future<M> getData(int pageIndex);

  /// Parse list data from the response model
  List<L> parseList(M result);

  /// Loads data for the page
  Future<void> loadData({bool loadMore = false}) async {
    if (loading) return;

    setState(() {
      loading = true;
    });

    if (!loadMore) {
      pageIndex = 1;
    }

    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    try {
      var result = await getData(currentIndex);
      setState(() {
        if (loadMore) {
          // Append new data to the existing list
          dataList = [...dataList, ...parseList(result)];
          if (parseList(result).isNotEmpty) {
            pageIndex++;
          }
        } else {
          // Replace data for fresh load
          dataList = parseList(result);
        }
      });
    } catch (e) {
      _handleError(e);
    } finally {
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          loading = false;
        });
      });
    }
  }

  /// Handle data loading errors
  void _handleError(dynamic error) {
    if (error is NeedAuth) {
      showWarnToast("Authentication required: ${error.message}");
    } else if (error is TypeError) {
      showWarnToast("Type error: ${error.toString()}");
    } else {
      showWarnToast("An error occurred: ${error.toString()}");
    }
  }

  @override
  bool get wantKeepAlive => true;
}

/// Toast for warning messages
void showWarnToast(String text) {
  final context = navigatorKey.currentContext;
  if (context != null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.redAccent,
    ));
  } else {
    print(
        "Warning: $text"); // Fallback: Log the warning message if no context is available
  }
}

/// Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
