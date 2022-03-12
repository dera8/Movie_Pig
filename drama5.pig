--load from HDFS

films = LOAD '/pigInputCinema' using PigStorage (',') AS (movieId: chararray,title:chararray,genres:chararray);

ratings = LOAD '/pigInputRatings' using PigStorage (',') AS (userId:int,movieId: chararray,rating:float,timestamp:int);

--Equijoin between films and ratings

movie_orders = JOIN films by movieId, ratings by movieId;

--Show only title, rating and genres 

m_o_foreach = foreach movie_orders generate title,rating,genres;

--Show drama movies

filter_by_drama = filter m_o_foreach by genres == 'Drama';

--Show drama movies that have 5.0 rating

filter_by_drama_rating = filter filter_by_drama by rating >= 5.0;

--Delete duplicates

distinct_filter_by_drama_rating = distinct filter_by_drama_rating;

dump distinct_filter_by_drama_rating;

--Store in HDFS

store distinct_filter_by_drama_rating into 'DramaA5Stelle';





 
