create table bible_verses (
  id serial primary key,
  book text not null,
  chapter int not null,
  verse int not null,
  text text not null,
  version text default 'KJV'
);
