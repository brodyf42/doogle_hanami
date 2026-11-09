CREATE TABLE `schema_migrations`(`filename` varchar(255) NOT NULL PRIMARY KEY);
CREATE TABLE `words`(
  `id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  `name` varchar(255) NOT NULL,
  `normalized_name` varchar(255) NOT NULL
);
CREATE UNIQUE INDEX `words_normalized_name_index` ON `words`(
  `normalized_name`
);
INSERT INTO schema_migrations (filename) VALUES
('20261108200631_create_words.rb');
