import 'package:bloc/bloc.dart';
import 'package:restaurant_tour/view/cubit/restaurants/restaurants.dart';

import '../../../data/repositories/yelp_repository.dart';

class RestaurantsCubit extends Cubit<RestaurantsState> {
  RestaurantsCubit(this.yelpRepo) : super(RestaurantsState());

  final YelpRepository yelpRepo;

  Future<void> fetchRestaurants() async {
    emit(state.copyWith(status: RestaurantsStatus.loading));

    try {
      final result = await yelpRepo.getRestaurants();

      final isValidResult = result != null &&
          result.restaurants != null &&
          result.restaurants!.isNotEmpty;

      if (isValidResult) {
        emit(
          state.copyWith(
            status: RestaurantsStatus.success,
            restaurants: result.restaurants,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: RestaurantsStatus.failure,
            errorMessage: 'An unexpected error occurred',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: RestaurantsStatus.failure,
          errorMessage: 'Failed to fetch restaurants: $e',
        ),
      );
    }
  }
}