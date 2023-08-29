CREATE TYPE club_type AS ENUM ('club', 'national', 'university', 'school', 'pro');
CREATE TYPE field_type AS ENUM ('grass', 'beach', 'indoor');
CREATE TYPE division AS ENUM ('M', 'W', 'X', 'O');
CREATE TYPE round_type AS ENUM ('pool', 'power pool', 'bracket', 'round robin', 'swiss draw');

CREATE TABLE tournaments (
    id          serial          PRIMARY KEY,
    name        VARCHAR (50)    UNIQUE NOT NULL,
    field_type  field_type      NOT NULL DEFAULT 'grass',
    club_type   club_type       NOT NULL DEFAULT 'club'
);

CREATE TABLE tournament_events (
    id              serial          PRIMARY KEY,
    tournament_id   INTEGER         REFERENCES tournaments ON DELETE CASCADE NOT NULL,
    division        division        NOT NULL,
    starts_at       date            NOT NULL,
    ends_at         date            NOT NULL,
    location        VARCHAR (50)
);

CREATE TABLE games (
    id                      serial      PRIMARY KEY,
    tournament_event_id     INTEGER     REFERENCES tournament_events ON DELETE CASCADE NOT NULL,
    round                   round_type,
    starts_at               TIMESTAMP WITH TIME ZONE
);

CREATE TABLE clubs (
    id          serial          PRIMARY KEY,
    name        VARCHAR (50)    UNIQUE NOT NULL,
    location    VARCHAR (50),
    club_type   club_type       NOT NULL DEFAULT 'club'
);

CREATE TABLE teams (
    id              serial          PRIMARY KEY,
    club_id         INTEGER         REFERENCES clubs ON DELETE CASCADE NOT NULL,
    name            VARCHAR (50)    NOT NULL,
    division        division        NOT NULL,
    team_number     INTEGER
);

CREATE TABLE game_scores (
    id          serial      PRIMARY KEY,
    game_id     INTEGER     REFERENCES games ON DELETE CASCADE NOT NULL,
    team_id     INTEGER     REFERENCES teams ON DELETE CASCADE NOT NULL,
    score       INTEGER     NOT NULL,
    seed        INTEGER     NOT NULL,
    unique (game_id, team_id)
);

CREATE TABLE tournament_placings (
    id                      serial      PRIMARY KEY,
    tournament_event_id     INTEGER     REFERENCES tournament_events ON DELETE CASCADE NOT NULL,
    team_id                 INTEGER     REFERENCES teams ON DELETE CASCADE NOT NULL,
    final_placement         INTEGER     NOT NULL,
    initial_seed            INTEGER     NOT NULL,
    unique (tournament_event_id, team_id)
);
