-- =====================================================================
--  База данных «Counter-Strike 2»
--  Файл 1 из 3: создание таблиц
-- =====================================================================

-- Удаляем старые таблицы, чтобы скрипт можно было запускать повторно
DROP TABLE IF EXISTS player_skins, skins, weapons, matches,
                     maps, tournaments, players, teams, countries CASCADE;

-- 1. Страны
CREATE TABLE countries (
    country_id  SERIAL PRIMARY KEY,
    name        VARCHAR(50) NOT NULL UNIQUE
);

-- 2. Команды
CREATE TABLE teams (
    team_id     SERIAL PRIMARY KEY,
    name        VARCHAR(50) NOT NULL UNIQUE,
    country_id  INT REFERENCES countries(country_id)
);

-- 3. Игроки (team_id пустой = игрок без команды)
CREATE TABLE players (
    player_id   SERIAL PRIMARY KEY,
    nickname    VARCHAR(30) NOT NULL UNIQUE,
    full_name   VARCHAR(60) NOT NULL,
    age         INT CHECK (age > 0),
    role        VARCHAR(10),          -- IGL (капитан), AWPer (снайпер), Rifler
    team_id     INT REFERENCES teams(team_id),
    country_id  INT REFERENCES countries(country_id)
);

-- 4. Турниры
CREATE TABLE tournaments (
    tournament_id  SERIAL PRIMARY KEY,
    name           VARCHAR(50) NOT NULL UNIQUE,
    city           VARCHAR(30),
    prize_pool     INT CHECK (prize_pool >= 0)   -- призовой фонд в $
);

-- 5. Карты
CREATE TABLE maps (
    map_id  SERIAL PRIMARY KEY,
    name    VARCHAR(20) NOT NULL UNIQUE
);

-- 6. Матчи (одна карта, две команды, счёт и победитель)
CREATE TABLE matches (
    match_id       SERIAL PRIMARY KEY,
    tournament_id  INT NOT NULL REFERENCES tournaments(tournament_id),
    map_id         INT NOT NULL REFERENCES maps(map_id),
    team1_id       INT NOT NULL REFERENCES teams(team_id),
    team2_id       INT NOT NULL REFERENCES teams(team_id),
    team1_score    INT NOT NULL,
    team2_score    INT NOT NULL,
    winner_id      INT REFERENCES teams(team_id),
    match_date     DATE,
    CHECK (team1_id <> team2_id)      -- команда не может играть сама с собой
);

-- 7. Оружие
CREATE TABLE weapons (
    weapon_id  SERIAL PRIMARY KEY,
    name       VARCHAR(30) NOT NULL UNIQUE,
    type       VARCHAR(10),                 -- Pistol, SMG, Rifle, Sniper, Shotgun
    price      INT CHECK (price >= 0)       -- цена в игре, $
);

-- 8. Скины (раскраски для оружия)
CREATE TABLE skins (
    skin_id    SERIAL PRIMARY KEY,
    weapon_id  INT NOT NULL REFERENCES weapons(weapon_id),
    name       VARCHAR(30) NOT NULL,
    rarity     VARCHAR(20),                        -- редкость
    price      NUMERIC(10,2) CHECK (price >= 0)    -- цена на рынке Steam, $
);

-- 9. Инвентарь: какие скины есть у игроков (связь «многие-ко-многим»)
CREATE TABLE player_skins (
    player_id  INT REFERENCES players(player_id),
    skin_id    INT REFERENCES skins(skin_id),
    PRIMARY KEY (player_id, skin_id)
);
