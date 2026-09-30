-- =====================================================================
--  Counter-Strike 2 — Kiberidman verilənlər bazası
--  Fayl 2/3: nümunə məlumatların daxil edilməsi (DML)
--
--  Qeyd: heyətlər 2025-ci ilə yaxındır; matç nəticələri, statistika
--  və skin qiymətləri nümunə xarakterlidir (real məlumatlardan
--  fərqlənə bilər). "Baku CS2 Open 2026" uydurma turnirdir.
-- =====================================================================

-- 1. Ölkələr --------------------------------------------------------------
INSERT INTO countries (name, iso_code) VALUES
    ('France',         'FR'),  --  1
    ('Ukraine',        'UA'),  --  2
    ('Russia',         'RU'),  --  3
    ('Germany',        'DE'),  --  4
    ('United States',  'US'),  --  5
    ('Estonia',        'EE'),  --  6
    ('Israel',         'IL'),  --  7
    ('United Kingdom', 'GB'),  --  8
    ('Finland',        'FI'),  --  9
    ('Romania',        'RO'),  -- 10
    ('Lithuania',      'LT'),  -- 11
    ('Sweden',         'SE'),  -- 12
    ('Hungary',        'HU'),  -- 13
    ('Denmark',        'DK'),  -- 14
    ('Norway',         'NO'),  -- 15
    ('Slovakia',       'SK'),  -- 16
    ('Latvia',         'LV'),  -- 17
    ('Poland',         'PL'),  -- 18
    ('Kazakhstan',     'KZ'),  -- 19
    ('Azerbaijan',     'AZ');  -- 20

-- 2. Komandalar -----------------------------------------------------------
INSERT INTO teams (name, tag, country_id, founded_year, world_rank) VALUES
    ('Team Vitality', 'VIT',    1, 2013, 1),  -- 1
    ('Natus Vincere', 'NAVI',   2, 2009, 4),  -- 2
    ('Team Spirit',   'SPIRIT', 3, 2015, 3),  -- 3
    ('MOUZ',          'MOUZ',   4, 2002, 2),  -- 4
    ('FaZe Clan',     'FAZE',   5, 2010, 5);  -- 5

-- 3. Oyunçular ------------------------------------------------------------
INSERT INTO players (nickname, full_name, birth_year, country_id, team_id, role) VALUES
    -- Team Vitality
    ('apEX',       'Dan Madesclaire',       1993,  1, 1, 'IGL'),     --  1
    ('ZywOo',      'Mathieu Herbaut',       2000,  1, 1, 'AWPer'),   --  2
    ('ropz',       'Robin Kool',            1999,  6, 1, 'Lurker'),  --  3
    ('flameZ',     'Shahar Shushan',        2003,  7, 1, 'Entry'),   --  4
    ('mezii',      'William Merriman',      1998,  8, 1, 'Support'), --  5
    -- Natus Vincere
    ('Aleksib',    'Aleksi Virolainen',     1997,  9, 2, 'IGL'),     --  6
    ('iM',         'Mihai Ivan',            2000, 10, 2, 'Rifler'),  --  7
    ('b1t',        'Valerii Vakhovskyi',    2003,  2, 2, 'Rifler'),  --  8
    ('jL',         'Justinas Lekavičius',   1999, 11, 2, 'Entry'),   --  9
    ('w0nderful',  'Ihor Zhdanov',          2004,  2, 2, 'AWPer'),   -- 10
    -- Team Spirit
    ('chopper',    'Leonid Vishnyakov',     1997,  3, 3, 'IGL'),     -- 11
    ('donk',       'Danil Kryshkovets',     2007,  3, 3, 'Entry'),   -- 12
    ('sh1ro',      'Dmitry Sokolov',        2001,  3, 3, 'AWPer'),   -- 13
    ('zont1x',     'Myroslav Plakhotja',    2004,  2, 3, 'Rifler'),  -- 14
    ('zweih',      'Ivan Gogin',            2006,  3, 3, 'Support'), -- 15
    -- MOUZ
    ('Brollan',    'Ludvig Brolin',         2002, 12, 4, 'IGL'),     -- 16
    ('torzsi',     'Ádám Torzsás',          2002, 13, 4, 'AWPer'),   -- 17
    ('Spinx',      'Lotan Giladi',          2000,  7, 4, 'Lurker'),  -- 18
    ('Jimpphat',   'Jimi Salo',             2006,  9, 4, 'Support'), -- 19
    ('xertioN',    'Dorian Berman',         2004,  7, 4, 'Entry'),   -- 20
    -- FaZe Clan
    ('karrigan',   'Finn Andersen',         1990, 14, 5, 'IGL'),     -- 21
    ('rain',       'Håvard Nygaard',        1994, 15, 5, 'Entry'),   -- 22
    ('frozen',     'David Čerňanský',       2002, 16, 5, 'Rifler'),  -- 23
    ('broky',      'Helvijs Saukants',      2001, 17, 5, 'AWPer'),   -- 24
    ('EliGE',      'Jonathan Jablonowski',  1997,  5, 5, 'Rifler'),  -- 25
    -- Komandasız oyunçular (free agents)
    ('s1mple',     'Oleksandr Kostyliev',   1997,  2, NULL, 'AWPer'),  -- 26
    ('electroNic', 'Denis Sharipov',        1998,  3, NULL, 'Rifler'); -- 27

-- 4. Xəritələr ------------------------------------------------------------
INSERT INTO maps (name, code, is_active_duty) VALUES
    ('Ancient',  'de_ancient',  TRUE),   -- 1
    ('Anubis',   'de_anubis',   TRUE),   -- 2
    ('Dust II',  'de_dust2',    TRUE),   -- 3
    ('Inferno',  'de_inferno',  TRUE),   -- 4
    ('Mirage',   'de_mirage',   TRUE),   -- 5
    ('Nuke',     'de_nuke',     TRUE),   -- 6
    ('Train',    'de_train',    TRUE),   -- 7
    ('Vertigo',  'de_vertigo',  FALSE),  -- 8
    ('Overpass', 'de_overpass', FALSE);  -- 9

-- 5. Silahlar -------------------------------------------------------------
INSERT INTO weapons (name, category, side, price, damage, magazine_size) VALUES
    ('Glock-18',     'Pistol',  'T',    200,  30,  20),  --  1
    ('USP-S',        'Pistol',  'CT',   200,  35,  12),  --  2
    ('P2000',        'Pistol',  'CT',   200,  35,  13),  --  3
    ('P250',         'Pistol',  'Both', 300,  38,  13),  --  4
    ('Five-SeveN',   'Pistol',  'CT',   500,  32,  20),  --  5
    ('Tec-9',        'Pistol',  'T',    500,  33,  18),  --  6
    ('Desert Eagle', 'Pistol',  'Both', 700,  53,   7),  --  7
    ('MAC-10',       'SMG',     'T',    1050, 29,  30),  --  8
    ('MP9',          'SMG',     'CT',   1250, 26,  30),  --  9
    ('UMP-45',       'SMG',     'Both', 1200, 35,  25),  -- 10
    ('P90',          'SMG',     'Both', 2350, 26,  50),  -- 11
    ('Galil AR',     'Rifle',   'T',    1800, 30,  35),  -- 12
    ('FAMAS',        'Rifle',   'CT',   2050, 30,  25),  -- 13
    ('AK-47',        'Rifle',   'T',    2700, 36,  30),  -- 14
    ('M4A4',         'Rifle',   'CT',   3100, 33,  30),  -- 15
    ('M4A1-S',       'Rifle',   'CT',   2900, 38,  20),  -- 16
    ('SSG 08',       'Sniper',  'Both', 1700, 88,  10),  -- 17
    ('AWP',          'Sniper',  'Both', 4750, 115,  5),  -- 18
    ('Nova',         'Shotgun', 'Both', 1050, 26,   8),  -- 19
    ('XM1014',       'Shotgun', 'Both', 2000, 20,   7),  -- 20
    ('Negev',        'Heavy',   'Both', 1700, 35, 150);  -- 21

-- 6. Nadirlik dərəcələri --------------------------------------------------
INSERT INTO rarities (name, color_hex, tier_order) VALUES
    ('Consumer Grade',   '#B0C3D9', 1),  -- 1
    ('Industrial Grade', '#5E98D9', 2),  -- 2
    ('Mil-Spec',         '#4B69FF', 3),  -- 3
    ('Restricted',       '#8847FF', 4),  -- 4
    ('Classified',       '#D32CE6', 5),  -- 5
    ('Covert',           '#EB4B4B', 6),  -- 6
    ('Contraband',       '#E4AE39', 7);  -- 7

-- 7. Skinlər --------------------------------------------------------------
INSERT INTO skins (weapon_id, rarity_id, name, market_price) VALUES
    (14, 5, 'Redline',          45.00),  --  1  AK-47
    (14, 6, 'Asiimov',         110.00),  --  2  AK-47
    (14, 6, 'Fire Serpent',   1400.00),  --  3  AK-47
    (14, 6, 'Vulcan',          260.00),  --  4  AK-47
    (14, 5, 'Case Hardened',   180.00),  --  5  AK-47
    (18, 6, 'Dragon Lore',   11000.00),  --  6  AWP
    (18, 6, 'Asiimov',         160.00),  --  7  AWP
    (18, 6, 'Lightning Strike',420.00),  --  8  AWP
    (18, 6, 'Hyper Beast',      65.00),  --  9  AWP
    (18, 2, 'Safari Mesh',       0.25),  -- 10  AWP
    (15, 7, 'Howl',           5200.00),  -- 11  M4A4
    (15, 6, 'Asiimov',         170.00),  -- 12  M4A4
    (16, 6, 'Printstream',     160.00),  -- 13  M4A1-S
    (16, 6, 'Hyper Beast',      30.00),  -- 14  M4A1-S
    ( 7, 4, 'Blaze',           750.00),  -- 15  Desert Eagle
    ( 7, 6, 'Printstream',      70.00),  -- 16  Desert Eagle
    ( 2, 6, 'Kill Confirmed',   95.00),  -- 17  USP-S
    ( 2, 5, 'Orion',            18.00),  -- 18  USP-S
    ( 1, 4, 'Fade',           1600.00),  -- 19  Glock-18
    ( 1, 5, 'Water Elemental',   9.00),  -- 20  Glock-18
    ( 4, 1, 'Sand Dune',         0.05);  -- 21  P250

-- 8. Oyunçu inventarı -----------------------------------------------------
INSERT INTO player_skins (player_id, skin_id, float_value, is_stattrak, acquired_on) VALUES
    ( 2,  6, 0.01234, FALSE, '2023-05-12'),  -- ZywOo: AWP Dragon Lore
    ( 2, 13, 0.00870, TRUE,  '2024-02-01'),
    ( 2, 17, 0.15500, TRUE,  '2024-03-10'),
    (12,  1, 0.16012, TRUE,  '2024-01-20'),  -- donk
    (12, 19, 0.02100, FALSE, '2024-06-05'),
    (12, 20, 0.07500, FALSE, '2024-06-05'),
    (13,  7, 0.24600, TRUE,  '2022-11-11'),  -- sh1ro
    (13, 18, 0.03300, FALSE, '2023-01-15'),
    (26,  6, 0.06900, FALSE, '2021-10-31'),  -- s1mple
    (26, 11, 0.12000, TRUE,  '2020-08-08'),
    (26, 15, 0.00800, FALSE, '2019-12-24'),
    (17,  8, 0.05500, FALSE, '2024-07-07'),  -- torzsi
    (24,  9, 0.39000, TRUE,  '2023-09-09'),  -- broky
    (24, 10, 0.55000, FALSE, '2022-02-02'),
    ( 8,  3, 0.28100, FALSE, '2024-04-04'),  -- b1t
    ( 8, 16, 0.02800, TRUE,  '2024-05-05'),
    (10,  7, 0.19000, FALSE, '2024-08-18'),  -- w0nderful
    (21,  5, 0.09900, FALSE, '2020-04-14'),  -- karrigan
    (22,  4, 0.11000, TRUE,  '2023-03-03'),  -- rain
    ( 1, 12, 0.35000, FALSE, '2022-06-06'),  -- apEX
    (16, 14, 0.07200, TRUE,  '2024-10-10'),  -- Brollan
    ( 9, 21, 0.99000, FALSE, '2025-01-01');  -- jL

-- 9. Turnirlər ------------------------------------------------------------
INSERT INTO tournaments (name, organizer, city, country_id, tier, is_major,
                         start_date, end_date, prize_pool) VALUES
    ('IEM Katowice 2025',          'ESL',          'Katowice', 18, 'S', FALSE, '2025-01-29', '2025-02-09', 1000000),  -- 1
    ('PGL Astana 2025',            'PGL',          'Astana',   19, 'A', FALSE, '2025-05-10', '2025-05-18',  625000),  -- 2
    ('BLAST.tv Austin Major 2025', 'BLAST',        'Austin',    5, 'S', TRUE,  '2025-06-03', '2025-06-22', 1250000),  -- 3
    ('IEM Cologne 2025',           'ESL',          'Cologne',   4, 'S', FALSE, '2025-07-23', '2025-08-10', 1000000),  -- 4
    ('Baku CS2 Open 2026',         'Baku Esports', 'Baku',     20, 'B', FALSE, '2026-11-14', '2026-11-16',   50000);  -- 5 (hələ keçirilməyib)

-- 10. Matçlar -------------------------------------------------------------
-- Komandalar: 1 Vitality, 2 NaVi, 3 Spirit, 4 MOUZ, 5 FaZe
INSERT INTO matches (tournament_id, stage, match_date, best_of, team1_id, team2_id, winner_team_id) VALUES
    (1, 'Semi-final',    '2025-02-08', 3, 1, 5, 1),  --  1 Vitality vs FaZe
    (1, 'Semi-final',    '2025-02-08', 3, 3, 4, 3),  --  2 Spirit vs MOUZ
    (1, 'Final',         '2025-02-09', 5, 1, 3, 1),  --  3 Vitality vs Spirit
    (2, 'Semi-final',    '2025-05-17', 3, 2, 5, 2),  --  4 NaVi vs FaZe
    (2, 'Final',         '2025-05-18', 3, 2, 4, 4),  --  5 NaVi vs MOUZ
    (3, 'Quarter-final', '2025-06-19', 3, 1, 2, 1),  --  6 Vitality vs NaVi
    (3, 'Quarter-final', '2025-06-19', 3, 3, 5, 5),  --  7 Spirit vs FaZe
    (3, 'Semi-final',    '2025-06-21', 3, 4, 5, 4),  --  8 MOUZ vs FaZe
    (3, 'Final',         '2025-06-22', 3, 1, 4, 1),  --  9 Vitality vs MOUZ
    (4, 'Final',         '2025-08-10', 5, 3, 2, 3);  -- 10 Spirit vs NaVi

-- 11. Matçlarda oynanılan xəritələr ----------------------------------------
-- Xəritələr: 1 Ancient, 2 Anubis, 3 Dust II, 4 Inferno, 5 Mirage, 6 Nuke, 7 Train
INSERT INTO match_maps (match_id, map_id, map_number, picked_by_team_id, team1_score, team2_score) VALUES
    ( 1, 5, 1, 1,    13,  9),
    ( 1, 6, 2, 5,    11, 13),
    ( 1, 4, 3, NULL, 13,  7),
    ( 2, 3, 1, 3,    13, 10),
    ( 2, 1, 2, 4,    13, 11),
    ( 3, 5, 1, 1,    13,  6),
    ( 3, 3, 2, 3,    10, 13),
    ( 3, 2, 3, 1,    16, 14),   -- overtime
    ( 3, 4, 4, 3,    13, 11),
    ( 4, 6, 1, 2,    13,  8),
    ( 4, 1, 2, 5,     9, 13),
    ( 4, 2, 3, NULL, 13,  5),
    ( 5, 4, 1, 4,     7, 13),
    ( 5, 5, 2, 2,    13, 11),
    ( 5, 6, 3, NULL, 10, 13),
    ( 6, 4, 1, 1,    13,  4),
    ( 6, 7, 2, 2,    13, 10),
    ( 7, 3, 1, 3,    13, 11),
    ( 7, 5, 2, 5,     8, 13),
    ( 7, 1, 3, NULL, 14, 16),   -- overtime
    ( 8, 6, 1, 4,    13,  3),
    ( 8, 2, 2, 5,    13,  9),
    ( 9, 5, 1, 1,    13, 11),
    ( 9, 7, 2, 4,     9, 13),
    ( 9, 4, 3, NULL, 13, 10),
    (10, 3, 1, 3,    13,  9),
    (10, 1, 2, 2,    13, 10),
    (10, 5, 3, 3,    11, 13),
    (10, 6, 4, 2,    13,  7);

-- 12. Oyunçu statistikası ---------------------------------------------------
-- 29 xəritə x 10 oyunçu = 290 sətir. Əl ilə yazmaq əvəzinə INSERT ... SELECT
-- ilə generasiya olunur (deterministik düstur: hər dəfə eyni nəticə).
-- Xəritəni qazanan komandanın oyunçuları daha çox kill, daha az ölüm alır.
WITH base AS (
    SELECT mm.match_map_id,
           p.player_id,
           p.team_id,
           p.nickname,
           mm.team1_score + mm.team2_score AS rounds,
           (p.team_id = m.team1_id AND mm.team1_score > mm.team2_score) OR
           (p.team_id = m.team2_id AND mm.team2_score > mm.team1_score) AS won
    FROM match_maps mm
    JOIN matches m ON m.match_id = mm.match_id
    JOIN players p ON p.team_id IN (m.team1_id, m.team2_id)
),
calc AS (
    SELECT b.*,
           (ROUND(rounds * (0.50 + ((player_id * 37 + match_map_id * 17) % 40) / 100.0))
              + CASE WHEN won THEN 3 ELSE -2 END
              + CASE WHEN nickname IN ('ZywOo', 'donk') THEN 4 ELSE 0 END)::INT AS kills,
           (ROUND(rounds * (0.55 + ((player_id * 23 + match_map_id * 11) % 30) / 100.0))
              + CASE WHEN won THEN -3 ELSE 3 END)::INT                           AS deaths,
           (player_id * 7 + match_map_id * 5) % 8 + 1                            AS assists,
           35 + (player_id * 13) % 30                                            AS hs_pct
    FROM base b
)
INSERT INTO player_match_stats (match_map_id, player_id, team_id,
                                kills, deaths, assists, headshots, adr)
SELECT match_map_id,
       player_id,
       team_id,
       kills,
       deaths,
       assists,
       kills * hs_pct / 100,
       ROUND(kills * 110.0 / rounds + (player_id + match_map_id) % 15, 1)
FROM calc;
