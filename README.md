# Tradernote

A simple web API for a note taking app.

## Setup

1. `git clone git@github.com:AlexVPopov/tradernote.git`
2. `bundle install`
3. `rake db:setup`
4. `rails s`

## Tests

`rspec spec`

## Endpoints

All endpoints, except **Register** and **Authenticate** require an authentication token, provided
in an `Authorization` request header, e.g.
`Authorization: Token token=2a12e96e6b302fbe045fcee4a15cc08a`

#### Register
 * url: `/users`
 * method: `POST`
 * params: `user[email]`, `user[password]`, `user[password_confirmation]`

#### Authenticate
  * url: `/authenticate`
  * method: `POST`
  * params: `email`, `password`

#### Notes
  * all standard REST endpoints
  * parameters for creating and updating:
    * title, body - required
    * tags - optional, in the form of a string, delimited with commas, e.g.
      "tag1,tag2,tag3"

#### Note querying
  * url: `/notes`
  * method: `GET`
  * parameters - `title`, `body`, `tag`, `any`
    * if parameter `any` is provided, endpoint will return any note, the body, title
      **or** tags of which match the query
    * if multiple parameters are provided, notes will be returned that have matches in
      **all** requested attributes

## To do

* Add request specs for querying the notes
