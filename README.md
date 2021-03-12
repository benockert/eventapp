*This repository, mainly ```lib/eventapp_web/templates``` includes code from and based on Nat Tuck's
in-class PhotoBlog example.*

# HW8 Design
- When a post is created with invitee emails that are not associated with an account, a user entry is made with that email; upon logging in with that email, the user will be prompted to complete their account with a username and picture
- A user cannot edit their email once their account has been created
- When a new comment is added, the user is redirected to the post, rather than the Show Comment page 

# HW7 Design
- Anyone can view an event, logged-in or not
- Only a registered and logged-in user can create/edit events and view users
- A user can only edit their own information
- The datepicker is confined to only dates in the future.

# Eventapp

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
