import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/util/utility.dart';
import 'package:instagram_clone/features/post/presentation/blocs/post_bloc.dart';
import 'image_picker/image_picker.dart';

class UploadPage extends StatelessWidget {
  final PageController pageController;

  UploadPage({Key? key, required this.pageController}) : super(key: key);
  final TextEditingController captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PostBloc bloc = context.read<PostBloc>();
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Upload",
            style: TextStyle(
                color: Colors.black, fontFamily: "Billabong", fontSize: 30),
          ),
          centerTitle: true,
          actions: [
            BlocConsumer<PostBloc, PostOverviewState>(
              listener: (context,state){
                if(state.status == PostOverviewStatus.done){
                  pageController.jumpToPage(0);
                }
                if(state.status == PostOverviewStatus.failure){
                  Utils.fireSnackBar("Some error occurred", context);
                }
              },
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    if (captionController.text.isNotEmpty && state.image != null) {
                      bloc.add(
                        StorePostEvent(
                            image: state.image!,
                            caption: captionController.text),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.post_add,
                    color: Colors.purple,
                    size: 27.5,
                  ),
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            BlocBuilder<PostBloc, PostOverviewState>(
              builder: (context, state) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // #image
                        InkWell(
                            onTap: () {
                              showPicker(context, bloc);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey.shade300,
                              child: state.image != null
                                  ? Stack(
                                      children: [
                                        Image.file(
                                          state.image!,
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                          width: double.infinity,
                                        ),
                                        Container(
                                          height: double.infinity,
                                          width: double.infinity,
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            onPressed: () {
                                              bloc.add(CancelImageEvent());
                                            },
                                            icon: const Icon(
                                              Icons.cancel_outlined,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.add_a_photo,
                                        size: 60,
                                        color: Colors.grey,
                                      ),
                                    ),
                            )),

                        // #caption
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10.0),
                          child: TextField(
                            controller: captionController,
                            decoration: const InputDecoration(
                              hintText: "Caption",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            keyboardType: TextInputType.multiline,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),

            BlocBuilder<PostBloc, PostOverviewState>(
              builder: (context, state) {
                if (state.status == PostOverviewStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const SizedBox.shrink();
                }
              },
            )
          ],
        ));
  }
}
