
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:instagram_clone/features/post/presentation/pages/views/search_user_view.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // AuthBloc authBloc = BlocProvider.of<AuthBloc>(context)..add(const SearchUsersEvent(keyword: ""));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Search",
          style: TextStyle(
              color: Colors.black, fontFamily: "Billabong", fontSize: 30),
        ),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // #search
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 5.0, horizontal: 20.0),
                child: TextField(
                  onChanged: (keyword) {
                    context.read<AuthBloc>().add(SearchUsersEvent(keyword: keyword));
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      hintText: "Search",
                      hintStyle: const TextStyle(color: Colors.grey)),
                ),
              ),

              // #users
              Expanded(
                child: BlocConsumer<AuthBloc, AuthOverviewState>(
                  listener: (context,state){
                    if(state.status == AuthOverviewStatus.following){
                      context.read<AuthBloc>().add(const SearchUsersEvent(keyword: ''));
                    }

                  },
                  builder: (context, state) {
                    return ListView.builder(
                        itemCount: state.users?.length,
                        itemBuilder: (context, index) {
                          if (state.users?.length != null) {
                            return ItemOfUser(user: state.users![index]);
                          } else {
                            return const SizedBox.shrink();
                          }
                        }

                    );
                  },
                ),
              )
            ],
          ),
          BlocBuilder<AuthBloc, AuthOverviewState>(
            builder: (context, state) {
              if (state.status == AuthOverviewStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          )
        ],
      ),
    );
  }


}