# Api Twitter Favorites

Api Twitter Favorites is responsible for providing a RESTful API of all a user's favorited tweets and allows users to categorize (bookmark) these favorited tweets to make it easy
to find them later.

The favorites list page on twitter isn't organized in any way and can make it difficult to find a tweet that was favorited a while back.

This can be useful when favoriting things you want to go back and look at later, like blog posts, tutorials, articles, cat gifs, etc..

## Todo

* rescue from rate limit errors when hitting /applicaiton/rate_limit_status endpoint
 and queue a job that'll start in 15 min.

* `SessionsController` Will need to Redirect user to Ember app, and tell Ember if it's a new user.

* Create API endpoint to read a user's favorites

* Don't make unnecessary calls to the db in FavoriteRunner#reset_trackers
and FavoriteRunner#set_trackers
