require 'open-uri'
require 'json'

# TMDB API proxy URL for top-rated movies
API_URL = 'https://tmdb.lewagon.com/movie/top_rated'

puts "Fetching movies from the API..."

# Fetch and parse the JSON data from the API
response = URI.open(API_URL).read
movies = JSON.parse(response)['results']

# Create Lists (only if they don't already exist)
puts "Creating lists..."

lists = [
  { name: "Top Rated Movies" },
  { name: "Action Movies" },
  { name: "Sci-Fi Classics" },
  { name: "Comedy Hits" },
  { name: "Drama Masterpieces" }
]

# Create lists only if they don't exist already
list_objects = lists.map do |list_data|
  List.find_or_create_by!(name: list_data[:name])
end

# Seed movies into the database (only if they don't exist already)
puts "Seeding movies..."

movies.each do |movie|
  # Find or create a movie by title to prevent duplicates
  Movie.find_or_create_by!(title: movie['title']) do |m|
    m.overview = movie['overview']
    m.poster_url = "https://image.tmdb.org/t/p/w500#{movie['poster_path']}"
    m.rating = movie['vote_average']
  end
end

# Now, let's create bookmarks (associating movies with lists) only if they don't already exist
puts "Creating bookmarks..."

# Fetch all movies and lists from the database
movie_records = Movie.all
list_records = List.all

# Associate each movie with every list (creating bookmarks if they don't already exist)
movie_records.each do |movie|
  list_records.each do |list|
    # Check if a bookmark already exists for this movie/list combination
    unless Bookmark.exists?(movie_id: movie.id, list_id: list.id)
      comment = "This is a great movie in the #{list.name} list!"
      Bookmark.create!(
        movie_id: movie.id,
        list_id: list.id,
        comment: comment
      )
    end
  end
end

puts "Seed data created successfully!"
