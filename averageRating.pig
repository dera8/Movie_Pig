films = LOAD '/pigInputMovies' using PigStorage (',') AS (movieId: int,title:chararray,genres:chararray);

ratings = LOAD '/pigInputRatings' using PigStorage (',') AS (userId:int,movieId:int,rating:float,timestamp:int);

--Equijoin between films and ratings

movie_orders = JOIN films by movieId, ratings by movieId;

--Only visualize movieId, title and rating;

m_o_foreach = foreach movie_orders generate ratings::movieId, title, rating;

--Only visualize every tuple that contains a rating of movie which has movieId 3508

filter_movieid = filter m_o_foreach by ratings::movieId == 3508;

--Group in one bag

grouped_by_movieid = group filter_movieid by title;

--Calculate the average rating for the movie "Outlaw Josey Wales"

grouped_by_movieid_avg = foreach grouped_by_movieid Generate group as title, AVG(filter_movieid.rating);

dump grouped_by_movieid_avg;
