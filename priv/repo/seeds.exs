# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Eventapp.Repo.insert!(%Eventapp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Eventapp.Repo
alias Eventapp.Users.User
alias Eventapp.Posts.Post

#adding photos
alias Eventapp.Pictures

silhouette = Pictures.hash("stock.jpg")

joseph = Repo.insert!(%User{username: "Joseph Aoun", email: "aoun.j@northeastern.edu", picture_hash: silhouette})
andrade = Repo.insert!(%User{username: "Andrade Ferron", email: "ferron.a@northeastern.edu", picture_hash: silhouette})
nat = Repo.insert!(%User{username: "Nat Tuck", email: "tuck.n@northeastern.edu", picture_hash: silhouette})
benjamin = Repo.insert!(%User{username: "Benjamin Ockert", email: "ockert.b@northeastern.edu", picture_hash: silhouette})
steven = Repo.insert!(%User{username: "Steven Yoo", email: "yoo.s@northeastern.edu", picture_hash: silhouette})

Repo.insert!(%Post{user_id: joseph.id, name: "Commencement",
                                      date: "05/07/2021",
                                      description: "Graduation for the Class of 2021!",
                                      invitees: "ockert.b@northeastern.edu, yoo.s@northeastern.edu, ferron.a@northeastern.edu"})

Repo.insert!(%Post{user_id: andrade.id, name: "CSI Budgets Due",
                                      date: "05/04/2021",
                                      description: "All CSI organization's budget requests are due",
                                      invitees: "ockert.b@northeastern.edu"})
