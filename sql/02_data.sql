-- =====================================================================
--  База данных «Counter-Strike 2»
--  Файл 2 из 3: заполнение таблиц данными
--  (составы команд — примерно 2025 год; счёт матчей и цены — учебные)
-- =====================================================================

-- 1. Страны
INSERT INTO countries (name) VALUES
    ('France'),          --  1
    ('Ukraine'),         --  2
    ('Russia'),          --  3
    ('USA'),             --  4
    ('Estonia'),         --  5
    ('Israel'),          --  6
    ('United Kingdom'),  --  7
    ('Finland'),         --  8
    ('Romania'),         --  9
    ('Lithuania'),       -- 10
    ('Denmark'),         -- 11
    ('Norway'),          -- 12
    ('Slovakia'),        -- 13
    ('Latvia');          -- 14

-- 2. Команды
INSERT INTO teams (name, country_id) VALUES
    ('Team Vitality', 1),   -- 1
    ('Natus Vincere', 2),   -- 2
    ('Team Spirit',   3),   -- 3
    ('FaZe Clan',     4);   -- 4

-- 3. Игроки
INSERT INTO players (nickname, full_name, age, role, team_id, country_id) VALUES
    -- Team Vitality
    ('apEX',      'Dan Madesclaire',      32, 'IGL',    1,  1),   --  1
    ('ZywOo',     'Mathieu Herbaut',      25, 'AWPer',  1,  1),   --  2
    ('ropz',      'Robin Kool',           26, 'Rifler', 1,  5),   --  3
    ('flameZ',    'Shahar Shushan',       22, 'Rifler', 1,  6),   --  4
    ('mezii',     'William Merriman',     27, 'Rifler', 1,  7),   --  5
    -- Natus Vincere
    ('Aleksib',   'Aleksi Virolainen',    28, 'IGL',    2,  8),   --  6
    ('iM',        'Mihai Ivan',           25, 'Rifler', 2,  9),   --  7
    ('b1t',       'Valerii Vakhovskyi',   22, 'Rifler', 2,  2),   --  8
    ('jL',        'Justinas Lekavicius',  26, 'Rifler', 2, 10),   --  9
    ('w0nderful', 'Ihor Zhdanov',         21, 'AWPer',  2,  2),   -- 10
    -- Team Spirit
    ('chopper',   'Leonid Vishnyakov',    28, 'IGL',    3,  3),   -- 11
    ('donk',      'Danil Kryshkovets',    18, 'Rifler', 3,  3),   -- 12
    ('sh1ro',     'Dmitry Sokolov',       24, 'AWPer',  3,  3),   -- 13
    ('zont1x',    'Myroslav Plakhotja',   21, 'Rifler', 3,  2),   -- 14
    ('zweih',     'Ivan Gogin',           19, 'Rifler', 3,  3),   -- 15
    -- FaZe Clan
    ('karrigan',  'Finn Andersen',        35, 'IGL',    4, 11),   -- 16
    ('rain',      'Havard Nygaard',       31, 'Rifler', 4, 12),   -- 17
    ('frozen',    'David Cernansky',      23, 'Rifler', 4, 13),   -- 18
    ('broky',     'Helvijs Saukants',     24, 'AWPer',  4, 14),   -- 19
    ('EliGE',     'Jonathan Jablonowski', 28, 'Rifler', 4,  4),   -- 20
    -- Без команды
    ('s1mple',    'Oleksandr Kostyliev',  28, 'AWPer',  NULL, 2); -- 21

-- 4. Турниры
INSERT INTO tournaments (name, city, prize_pool) VALUES
    ('IEM Katowice 2025',          'Katowice', 1000000),  -- 1
    ('BLAST.tv Austin Major 2025', 'Austin',   1250000),  -- 2
    ('IEM Cologne 2025',           'Cologne',  1000000),  -- 3
    ('Baku CS2 Open 2026',         'Baku',       50000);  -- 4 (ещё не проводился)

-- 5. Карты
INSERT INTO maps (name) VALUES
    ('Mirage'),   -- 1
    ('Inferno'),  -- 2
    ('Dust II'),  -- 3
    ('Nuke'),     -- 4
    ('Ancient'),  -- 5
    ('Anubis'),   -- 6
    ('Train');    -- 7

-- 6. Матчи
-- Команды: 1 Vitality, 2 NaVi, 3 Spirit, 4 FaZe
INSERT INTO matches (tournament_id, map_id, team1_id, team2_id, team1_score, team2_score, winner_id, match_date) VALUES
    (1, 1, 1, 4, 13,  9, 1, '2025-02-08'),  -- 1 Vitality - FaZe
    (1, 3, 3, 2, 13, 11, 3, '2025-02-08'),  -- 2 Spirit - NaVi
    (1, 2, 1, 3, 13, 10, 1, '2025-02-09'),  -- 3 Vitality - Spirit (финал)
    (2, 4, 2, 4, 13,  7, 2, '2025-06-19'),  -- 4 NaVi - FaZe
    (2, 5, 3, 4, 11, 13, 4, '2025-06-19'),  -- 5 Spirit - FaZe
    (2, 1, 1, 2, 13,  5, 1, '2025-06-21'),  -- 6 Vitality - NaVi
    (2, 6, 1, 4, 16, 14, 1, '2025-06-22'),  -- 7 Vitality - FaZe (финал, овертайм)
    (3, 3, 3, 1, 13,  8, 3, '2025-08-09'),  -- 8 Spirit - Vitality
    (3, 2, 2, 3,  9, 13, 3, '2025-08-10');  -- 9 NaVi - Spirit (финал)

-- 7. Оружие
INSERT INTO weapons (name, type, price) VALUES
    ('Glock-18',     'Pistol',  200),   --  1
    ('USP-S',        'Pistol',  200),   --  2
    ('Desert Eagle', 'Pistol',  700),   --  3
    ('MAC-10',       'SMG',     1050),  --  4
    ('MP9',          'SMG',     1250),  --  5
    ('AK-47',        'Rifle',   2700),  --  6
    ('M4A4',         'Rifle',   3100),  --  7
    ('M4A1-S',       'Rifle',   2900),  --  8
    ('AWP',          'Sniper',  4750),  --  9
    ('Nova',         'Shotgun', 1050);  -- 10

-- 8. Скины
INSERT INTO skins (weapon_id, name, rarity, price) VALUES
    (6, 'Redline',        'Classified',          45.00),  --  1 AK-47
    (6, 'Asiimov',        'Covert',             110.00),  --  2 AK-47
    (6, 'Fire Serpent',   'Covert',            1400.00),  --  3 AK-47
    (9, 'Dragon Lore',    'Covert',           11000.00),  --  4 AWP
    (9, 'Asiimov',        'Covert',             160.00),  --  5 AWP
    (9, 'Safari Mesh',    'Industrial Grade',     0.25),  --  6 AWP
    (7, 'Howl',           'Contraband',        5200.00),  --  7 M4A4
    (8, 'Printstream',    'Covert',             160.00),  --  8 M4A1-S
    (3, 'Blaze',          'Restricted',         750.00),  --  9 Desert Eagle
    (2, 'Kill Confirmed', 'Covert',              95.00),  -- 10 USP-S
    (1, 'Fade',           'Restricted',        1600.00);  -- 11 Glock-18

-- 9. Инвентарь игроков
INSERT INTO player_skins (player_id, skin_id) VALUES
    ( 2,  4), ( 2,  8),           -- ZywOo:  AWP Dragon Lore, M4A1-S Printstream
    (12,  1), (12, 11),           -- donk:   AK-47 Redline, Glock-18 Fade
    (21,  4), (21,  7), (21,  9), -- s1mple: AWP Dragon Lore, M4A4 Howl, Deagle Blaze
    ( 8,  3),                     -- b1t:    AK-47 Fire Serpent
    (13,  5),                     -- sh1ro:  AWP Asiimov
    (19,  6),                     -- broky:  AWP Safari Mesh
    (17,  2),                     -- rain:   AK-47 Asiimov
    ( 1, 10);                     -- apEX:   USP-S Kill Confirmed
