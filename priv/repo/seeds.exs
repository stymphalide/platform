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

Accounts.create_player(%{display_name: "José Valim", username: "josevalim", password: "josevalim", score: 1000})
Accounts.create_player(%{display_name: "Evan Czaplicki", username: "evancz", password: "evancz", score: 2000})
Accounts.create_player(%{display_name: "Angelo Birrer", username: "angelobirrer", password: "angelobirrer", score: 3000})
