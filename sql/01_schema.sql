-- =====================================================================
--  Counter-Strike 2 — Kiberidman verilənlər bazası
--  Fənn: Data mühəndisliyinə giriş
--  DBMS: PostgreSQL 14+
--  Fayl 1/3: cədvəllərin yaradılması (DDL)
-- =====================================================================

-- Skripti təkrar işə salmaq üçün köhnə cədvəlləri silirik
DROP VIEW  IF EXISTS v_player_career_stats, v_match_results CASCADE;
DROP TABLE IF EXISTS player_match_stats, match_maps, matches, tournaments,
                     player_skins, skins, rarities, weapons, maps,
                     players, teams, countries CASCADE;

-- ---------------------------------------------------------------------
-- 1. Ölkələr
-- ---------------------------------------------------------------------
CREATE TABLE countries (
    country_id  SERIAL       PRIMARY KEY,
    name        VARCHAR(60)  NOT NULL UNIQUE,
    iso_code    CHAR(2)      NOT NULL UNIQUE
);

-- ---------------------------------------------------------------------
-- 2. Komandalar
-- ---------------------------------------------------------------------
CREATE TABLE teams (
    team_id       SERIAL       PRIMARY KEY,
    name          VARCHAR(50)  NOT NULL UNIQUE,
    tag           VARCHAR(10)  NOT NULL,
    country_id    INT          REFERENCES countries(country_id),
    founded_year  SMALLINT     CHECK (founded_year BETWEEN 1999 AND 2030),
    world_rank    INT          UNIQUE CHECK (world_rank > 0)
);

-- ---------------------------------------------------------------------
-- 3. Oyunçular (team_id NULL = komandasız "free agent")
-- ---------------------------------------------------------------------
CREATE TABLE players (
    player_id   SERIAL       PRIMARY KEY,
    nickname    VARCHAR(30)  NOT NULL UNIQUE,
    full_name   VARCHAR(80)  NOT NULL,
    birth_year  SMALLINT     CHECK (birth_year BETWEEN 1980 AND 2012),
    country_id  INT          NOT NULL REFERENCES countries(country_id),
    team_id     INT          REFERENCES teams(team_id) ON DELETE SET NULL,
    role        VARCHAR(10)  NOT NULL
                CHECK (role IN ('IGL', 'AWPer', 'Entry', 'Rifler', 'Lurker', 'Support'))
);

-- ---------------------------------------------------------------------
-- 4. Xəritələr
-- ---------------------------------------------------------------------
CREATE TABLE maps (
    map_id          SERIAL       PRIMARY KEY,
    name            VARCHAR(30)  NOT NULL UNIQUE,
    code            VARCHAR(30)  NOT NULL UNIQUE,      -- məs. de_mirage
    is_active_duty  BOOLEAN      NOT NULL DEFAULT TRUE -- turnir pulunda varmı
);

-- ---------------------------------------------------------------------
-- 5. Silahlar
-- ---------------------------------------------------------------------
CREATE TABLE weapons (
    weapon_id      SERIAL       PRIMARY KEY,
    name           VARCHAR(30)  NOT NULL UNIQUE,
    category       VARCHAR(10)  NOT NULL
                   CHECK (category IN ('Pistol', 'SMG', 'Rifle', 'Sniper', 'Shotgun', 'Heavy')),
    side           VARCHAR(4)   NOT NULL CHECK (side IN ('T', 'CT', 'Both')),
    price          INT          NOT NULL CHECK (price >= 0),   -- oyundaxili qiymət ($)
    damage         INT          NOT NULL CHECK (damage > 0),
    magazine_size  INT          NOT NULL CHECK (magazine_size > 0)
);

-- ---------------------------------------------------------------------
-- 6. Skin nadirlik dərəcələri
-- ---------------------------------------------------------------------
CREATE TABLE rarities (
    rarity_id   SERIAL       PRIMARY KEY,
    name        VARCHAR(20)  NOT NULL UNIQUE,
    color_hex   CHAR(7)      NOT NULL CHECK (color_hex ~ '^#[0-9A-F]{6}$'),
    tier_order  SMALLINT     NOT NULL UNIQUE   -- 1 = ən adi, 7 = ən nadir
);

-- ---------------------------------------------------------------------
-- 7. Skinlər (hər skin bir silaha aiddir)
-- ---------------------------------------------------------------------
CREATE TABLE skins (
    skin_id       SERIAL         PRIMARY KEY,
    weapon_id     INT            NOT NULL REFERENCES weapons(weapon_id),
    rarity_id     INT            NOT NULL REFERENCES rarities(rarity_id),
    name          VARCHAR(40)    NOT NULL,
    market_price  NUMERIC(10,2)  NOT NULL CHECK (market_price >= 0),  -- Steam Market, USD
    UNIQUE (weapon_id, name)
);

-- ---------------------------------------------------------------------
-- 8. Oyunçu inventarı (M:N — oyunçu <-> skin)
-- ---------------------------------------------------------------------
CREATE TABLE player_skins (
    player_id    INT           NOT NULL REFERENCES players(player_id) ON DELETE CASCADE,
    skin_id      INT           NOT NULL REFERENCES skins(skin_id),
    float_value  NUMERIC(6,5)  NOT NULL CHECK (float_value >= 0 AND float_value < 1),
    is_stattrak  BOOLEAN       NOT NULL DEFAULT FALSE,
    acquired_on  DATE          NOT NULL,
    PRIMARY KEY (player_id, skin_id)
);

-- ---------------------------------------------------------------------
-- 9. Turnirlər
-- ---------------------------------------------------------------------
CREATE TABLE tournaments (
    tournament_id  SERIAL         PRIMARY KEY,
    name           VARCHAR(60)    NOT NULL UNIQUE,
    organizer      VARCHAR(30)    NOT NULL,
    city           VARCHAR(40)    NOT NULL,
    country_id     INT            NOT NULL REFERENCES countries(country_id),
    tier           CHAR(1)        NOT NULL CHECK (tier IN ('S', 'A', 'B')),
    is_major       BOOLEAN        NOT NULL DEFAULT FALSE,
    start_date     DATE           NOT NULL,
    end_date       DATE           NOT NULL,
    prize_pool     NUMERIC(12,2)  NOT NULL CHECK (prize_pool >= 0),
    CHECK (end_date >= start_date)
);

-- ---------------------------------------------------------------------
-- 10. Matçlar (iki komanda arasında seriya: BO1 / BO3 / BO5)
-- ---------------------------------------------------------------------
CREATE TABLE matches (
    match_id        SERIAL       PRIMARY KEY,
    tournament_id   INT          NOT NULL REFERENCES tournaments(tournament_id),
    stage           VARCHAR(20)  NOT NULL
                    CHECK (stage IN ('Group', 'Quarter-final', 'Semi-final', 'Final')),
    match_date      DATE         NOT NULL,
    best_of         SMALLINT     NOT NULL CHECK (best_of IN (1, 3, 5)),
    team1_id        INT          NOT NULL REFERENCES teams(team_id),
    team2_id        INT          NOT NULL REFERENCES teams(team_id),
    winner_team_id  INT          REFERENCES teams(team_id),   -- NULL = hələ oynanılmayıb
    CHECK (team1_id <> team2_id),
    CHECK (winner_team_id IN (team1_id, team2_id))
);

-- ---------------------------------------------------------------------
-- 11. Matçda oynanılan xəritələr (M:N — matç <-> xəritə, əlavə atributlarla)
-- ---------------------------------------------------------------------
CREATE TABLE match_maps (
    match_map_id       SERIAL    PRIMARY KEY,
    match_id           INT       NOT NULL REFERENCES matches(match_id) ON DELETE CASCADE,
    map_id             INT       NOT NULL REFERENCES maps(map_id),
    map_number         SMALLINT  NOT NULL CHECK (map_number BETWEEN 1 AND 5),
    picked_by_team_id  INT       REFERENCES teams(team_id),   -- NULL = decider xəritə
    team1_score        SMALLINT  NOT NULL CHECK (team1_score >= 0),
    team2_score        SMALLINT  NOT NULL CHECK (team2_score >= 0),
    UNIQUE (match_id, map_number),
    UNIQUE (match_id, map_id),
    -- CS2 (MR12): xəritədə qalib ən azı 13 raund qazanır, heç-heçə yoxdur
    CHECK (team1_score <> team2_score),
    CHECK (GREATEST(team1_score, team2_score) >= 13)
);

-- ---------------------------------------------------------------------
-- 12. Oyunçunun hər xəritədəki statistikası (M:N — oyunçu <-> match_map)
-- ---------------------------------------------------------------------
CREATE TABLE player_match_stats (
    match_map_id  INT           NOT NULL REFERENCES match_maps(match_map_id) ON DELETE CASCADE,
    player_id     INT           NOT NULL REFERENCES players(player_id),
    team_id       INT           NOT NULL REFERENCES teams(team_id),
    kills         SMALLINT      NOT NULL CHECK (kills   >= 0),
    deaths        SMALLINT      NOT NULL CHECK (deaths  >= 0),
    assists       SMALLINT      NOT NULL CHECK (assists >= 0),
    headshots     SMALLINT      NOT NULL CHECK (headshots >= 0),
    adr           NUMERIC(5,1)  NOT NULL CHECK (adr >= 0),   -- Average Damage per Round
    PRIMARY KEY (match_map_id, player_id),
    CHECK (headshots <= kills)
);

-- ---------------------------------------------------------------------
-- İndekslər (tez-tez JOIN olunan xarici açarlar üçün)
-- ---------------------------------------------------------------------
CREATE INDEX idx_players_team        ON players(team_id);
CREATE INDEX idx_skins_weapon        ON skins(weapon_id);
CREATE INDEX idx_matches_tournament  ON matches(tournament_id);
CREATE INDEX idx_match_maps_match    ON match_maps(match_id);
CREATE INDEX idx_pms_player          ON player_match_stats(player_id);
