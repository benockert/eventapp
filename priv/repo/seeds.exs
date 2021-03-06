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
alias Eventapp.Responses.Response
alias Eventapp.Comments.Comment

#adding photos
alias Eventapp.Pictures

silhouette = Pictures.hash("stock.jpg")
ben = Pictures.hash("ben.jpg")
aoun = Pictures.hash("aoun.jpg")

joseph = Repo.insert!(%User{username: "Joseph Aoun", email: "aoun.j@northeastern.edu", picture_hash: aoun})
andrade = Repo.insert!(%User{username: "Andrade Ferron", email: "ferron.a@northeastern.edu", picture_hash: silhouette})
nat = Repo.insert!(%User{username: "Nat Tuck", email: "tuck.n@northeastern.edu", picture_hash: silhouette})
benjamin = Repo.insert!(%User{username: "Benjamin Ockert", email: "ockert.b@northeastern.edu", picture_hash: ben})
steven = Repo.insert!(%User{username: "Steven Yoo", email: "yoo.s@northeastern.edu", picture_hash: silhouette})

commencement = Repo.insert!(%Post{user_id: joseph.id, name: "Commencement",
                                      date: "05/07/2021",
                                      description: "Graduation for the Class of 2021!",
                                      invitees: "ockert.b@northeastern.edu, yoo.s@northeastern.edu, ferron.a@northeastern.edu"})

dayoff = Repo.insert!(%Post{user_id: andrade.id, name: "Mental Health Day",
                                      date: "03/24/2021",
                                      description: "A day off for students during the Spring 2021 semester",
                                      invitees: "ockert.b@northeastern.edu"})

Repo.insert!(%Response{response: "YES", user_id: benjamin.id, post_id: commencement.id})
Repo.insert!(%Response{response: "NO", user_id: andrade.id, post_id: commencement.id})
Repo.insert!(%Response{response: "NO RESPONSE", user_id: steven.id, post_id: commencement.id})
Repo.insert!(%Response{response: "YES", user_id: benjamin.id, post_id: dayoff.id})

Repo.insert!(%Comment{content: "Yay this is amazing!", user_id: benjamin.id, post_id: dayoff.id})
Repo.insert!(%Comment{content: "I am looking forward to virtual commencement.", user_id: benjamin.id, post_id: commencement.id})
