# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Platform.Repo.insert!(%Platform.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Platform.Accounts
alias Platform.Products

# Players

Accounts.create_player(%{display_name: "Jose Valim", username: "josevalim", password: "josevalim", score: 1000})
Accounts.create_player(%{display_name: "Angelo Birrer", username: "angelobirrer", password: "angelobirrer", score: 3000})

# Games

Products.create_game(%{title: "Platformer", description: "Platform game example.", thumbnail: "http://via.placeholder.com/300x200", featured: true})