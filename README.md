# Api Twitter Favorites

Api Twitter Favorites is responsible for providing a RESTful API of all a user's favorited tweets and allows users to categorize (bookmark) these favorited tweets to make it easy
to find them later.

The favorites list page on twitter isn't organized in any way and can make it difficult to find a tweet that was favorited a while back.

This can be useful when favoriting things you want to go back and look at later, like blog posts, tutorials, articles, cat gifs, etc..

## Todo

1) `FavoriteRunner`: after the 15 requests, record the date/time so that future requests will have to wait until at least 15 mins have passed since this time.

2) rescue from rate limit errors and queue a job that'll start in 15 min.

3) if a user deletes a favorite, also delete it on twitter

4) `SessionsController` Will need to Redirect user to Ember app, and tell Ember if it's a new user.

5) Create API endpoint to read a user's favorites

6) Update README