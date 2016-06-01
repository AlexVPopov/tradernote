# Tradernote

A simple web API for a note taking app.

## Setup

1. `git clone git@github.com:AlexVPopov/tradernote.git`
2. `bundle install`
3. `rake db:setup`
4. `rails s`

## Tests

#### Rspec

`rspec spec`

#### Postman

Import `spec/support/postman/Tradernote.postman_collection.json` in
[Postman](https://www.getpostman.com/):

  * in folder REST ENDPOINTS, change the authentication token of the requests after you have
    registered/authenticated and received a token
  * in folder NOTE QUERYING the request uses the authentication token of the user from
    the seed data

## Versioning

To request a particular version of the API, an `Accept` header is required in the format
`Accept: application/vnd.tradernote.v1+json`. If no header is provided, the latest version
is returned.

## Authentication

All endpoints, except **Register** and **Authenticate**, require an authentication token,
provided in an `Authorization` request header, e.g.
`Authorization: Token token=2a12e96e6b302fbe045fcee4a15cc08a`.

## Endpoints

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
    * note[title], note[body] - required
    * note[tags] - optional, in the form of a string, delimited with commas, e.g.
      "tag1,tag2,tag3". To remove a tag, send the same string, which doesn't contain the
      tag, e.g. to remove "tag2", send note[tags] = "tag1,tag3". To remove all tags, send
      an empty tags parameter, e.g. `note[tags] = ''` or `note[tags] = `

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
