# This seeds file should create the database records required to run the app.
#
# The code should be idempotent so that it can be executed at any time.
#
# To load the seeds, run `hanami db seed`. Seeds are also loaded as part of `hanami db prepare`.

# For example, if you have appropriate repos available:
#
#   category_repo = Hanami.app["repos.category_repo"]
#   category_repo.create(title: "General")
#
# Alternatively, you can use relations directly:
#
#   categories = Hanami.app["relations.categories"]
#   categories.insert(title: "General")

word_repo = Hanami.app["repos.word_repo"]

[
  "École",
  "école",
  "Café",
  "cafe\u0301",
  "résumé",
  "RÉSUMÉ",
  "Naïve",
  "Zoë",
  "Über",
  "Ärger",
  "piñata",
  "mother-in-law",
  "Well-being",
  "x-ray",
  "o'clock",
  "ma'am",
  "rock 'n' roll",
  "  ice\u00A0cream  ",
  "ice    cream",
  "chair",
  "table",
  "book"
].each do |name|
  word_repo.find_or_create(name)
end
