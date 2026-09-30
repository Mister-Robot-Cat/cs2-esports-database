-- =====================================================================
--  База данных «Counter-Strike 2»
--  Файл 3 из 3: запросы
-- =====================================================================

-- 1. Все игроки
SELECT * FROM players;

-- 2. Игроки с названием команды и страны (JOIN)
SELECT p.nickname, p.full_name, p.role, t.name AS team, c.name AS country
FROM players p
JOIN teams t     ON p.team_id = t.team_id
JOIN countries c ON p.country_id = c.country_id
ORDER BY t.name;

-- 3. Состав одной команды (WHERE)
SELECT p.nickname, p.role, p.age
FROM players p
JOIN teams t ON p.team_id = t.team_id
WHERE t.name = 'Team Vitality';

-- 4. Игроки без команды (IS NULL)
SELECT nickname, full_name
FROM players
WHERE team_id IS NULL;

-- 5. Снайперы (AWPer) старше 22 лет (AND)
SELECT nickname, age
FROM players
WHERE role = 'AWPer' AND age > 22;

-- 6. Средний возраст игроков в каждой команде (GROUP BY + AVG)
SELECT t.name AS team, ROUND(AVG(p.age), 1) AS avg_age
FROM players p
JOIN teams t ON p.team_id = t.team_id
GROUP BY t.name
ORDER BY avg_age;

-- 7. Все матчи: турнир, карта, команды, счёт и победитель
SELECT tr.name AS tournament,
       m.name  AS map,
       t1.name AS team1,
       mt.team1_score || ' : ' || mt.team2_score AS score,
       t2.name AS team2,
       w.name  AS winner
FROM matches mt
JOIN tournaments tr ON mt.tournament_id = tr.tournament_id
JOIN maps m         ON mt.map_id   = m.map_id
JOIN teams t1       ON mt.team1_id = t1.team_id
JOIN teams t2       ON mt.team2_id = t2.team_id
JOIN teams w        ON mt.winner_id = w.team_id
ORDER BY mt.match_date;

-- 8. Сколько побед у каждой команды (GROUP BY + COUNT)
SELECT t.name AS team, COUNT(*) AS wins
FROM matches m
JOIN teams t ON m.winner_id = t.team_id
GROUP BY t.name
ORDER BY wins DESC;

-- 9. Сколько раз сыграна каждая карта (LEFT JOIN — видно и несыгранные карты)
SELECT mp.name AS map, COUNT(m.match_id) AS times_played
FROM maps mp
LEFT JOIN matches m ON m.map_id = mp.map_id
GROUP BY mp.name
ORDER BY times_played DESC;

-- 10. Турниры, в которых ещё не было матчей (LEFT JOIN + IS NULL)
SELECT tr.name, tr.city
FROM tournaments tr
LEFT JOIN matches m ON m.tournament_id = tr.tournament_id
WHERE m.match_id IS NULL;

-- 11. Все скины с названием оружия, от самых дорогих
SELECT w.name AS weapon, s.name AS skin, s.rarity, s.price
FROM skins s
JOIN weapons w ON s.weapon_id = w.weapon_id
ORDER BY s.price DESC;

-- 12. Стоимость инвентаря каждого игрока (связь многие-ко-многим + SUM)
SELECT p.nickname, COUNT(*) AS skins_count, SUM(s.price) AS total_price
FROM player_skins ps
JOIN players p ON ps.player_id = p.player_id
JOIN skins s   ON ps.skin_id   = s.skin_id
GROUP BY p.nickname
ORDER BY total_price DESC;

-- 13. Оружие дороже среднего (подзапрос)
SELECT name, type, price
FROM weapons
WHERE price > (SELECT AVG(price) FROM weapons)
ORDER BY price DESC;
