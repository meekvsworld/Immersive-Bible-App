create table bible_verses (
  id serial primary key,
  book text not null,         -- e.g., 'Matthew'
  chapter int not null,       -- e.g., 1
  verse int not null,         -- e.g., 1
  text text not null,         -- actual verse text
  version text default 'KJV'  -- default to King James Version
);