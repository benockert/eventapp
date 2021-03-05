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

joseph = Repo.insert!(%User{username: "Joseph Aoun", email: "aoun.j@northeastern.edu"})
andrade = Repo.insert!(%User{username: "Andrade Ferron", email: "ferron.a@northeastern.edu"})

Repo.insert!(%Post{user_id: joseph.id, name: "Commencement",
                                      date: "05/07/2021",
                                      description: "Graduation for the Class of 2021!",
                                      invitees: "No in person attendance"})

Repo.insert!(%Post{user_id: andrade.id, name: "CSI Budgets Due",
                                      date: "05/04/2021",
                                      description: "All CSI organization's budget requests are due",
                                      invitees: "aoun.j@northeastern.edu"})
