-- =====================================================================
--  Counter-Strike 2 — Kiberidman verilənlər bazası
--  Fayl 3/3: görünüşlər (VIEW) və nümunə sorğular
-- =====================================================================

-- ---------------------------------------------------------------------
-- VIEW 1. Matçların oxunaqlı nəticələri (seriya hesabı ilə, məs. 2:1)
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_match_results AS
SELECT m.match_id,
       t.name        AS tournament,
       m.stage,
       m.match_date,
       t1.name       AS team1,
       t2.name       AS team2,
       COUNT(mm.match_map_id) FILTER (WHERE mm.team1_score > mm.team2_score) || ':' ||
       COUNT(mm.match_map_id) FILTER (WHERE mm.team2_score > mm.team1_score) AS series_score,
       w.name        AS winner
FROM matches m
JOIN tournaments t   ON t.tournament_id = m.tournament_id
JOIN teams t1        ON t1.team_id = m.team1_id
JOIN teams t2        ON t2.team_id = m.team2_id
LEFT JOIN teams w    ON w.team_id  = m.winner_team_id
LEFT JOIN match_maps mm ON mm.match_id = m.match_id
GROUP BY m.match_id, t.name, t1.name, t2.name, w.name;

-- ---------------------------------------------------------------------
-- VIEW 2. Oyunçuların ümumi karyera statistikası
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_player_career_stats AS
SELECT p.player_id,
       p.nickname,
       tm.name                                                        AS team,
       p.role,
       COUNT(*)                                                       AS maps_played,
       SUM(s.kills)                                                   AS kills,
       SUM(s.deaths)                                                  AS deaths,
       SUM(s.assists)                                                 AS assists,
       ROUND(SUM(s.kills)::NUMERIC / NULLIF(SUM(s.deaths), 0), 2)     AS kd_ratio,
       ROUND(AVG(s.adr), 1)                                           AS avg_adr,
       ROUND(100.0 * SUM(s.headshots) / NULLIF(SUM(s.kills), 0), 1)   AS hs_percent
FROM players p
JOIN player_match_stats s ON s.player_id = p.player_id
LEFT JOIN teams tm        ON tm.team_id  = p.team_id
GROUP BY p.player_id, tm.name;


-- =====================================================================
--  SORĞULAR
-- =====================================================================

-- Q1. Bütün komandaların heyəti (JOIN, 3 cədvəl)
SELECT t.name      AS team,
       p.nickname,
       p.full_name,
       p.role,
       c.name      AS country
FROM players p
JOIN teams t     ON t.team_id    = p.team_id
JOIN countries c ON c.country_id = p.country_id
ORDER BY t.world_rank, p.nickname;

-- Q2. Komandası olmayan oyunçular — free agents (LEFT JOIN + IS NULL)
SELECT p.nickname, p.full_name, p.role, c.name AS country
FROM players p
LEFT JOIN teams t ON t.team_id = p.team_id
JOIN countries c  ON c.country_id = p.country_id
WHERE t.team_id IS NULL;

-- Q3. Bütün matçların nəticələri (VIEW-dan istifadə)
SELECT tournament, stage, match_date, team1, team2, series_score, winner
FROM v_match_results
ORDER BY match_date, match_id;

-- Q4. K/D göstəricisinə görə TOP-10 oyunçu (ən azı 5 xəritə oynayanlar)
SELECT nickname, team, role, maps_played, kills, deaths, kd_ratio, avg_adr, hs_percent
FROM v_player_career_stats
WHERE maps_played >= 5
ORDER BY kd_ratio DESC
LIMIT 10;

-- Q5. Hər komandanın ən yaxşı oyunçusu ADR-ə görə (pəncərə funksiyası ROW_NUMBER)
SELECT team, nickname, role, avg_adr
FROM (
    SELECT team, nickname, role, avg_adr,
           ROW_NUMBER() OVER (PARTITION BY team ORDER BY avg_adr DESC) AS rn
    FROM v_player_career_stats
) ranked
WHERE rn = 1
ORDER BY avg_adr DESC;

-- Q6. Komandaların matç statistikası: qələbə, məğlubiyyət, winrate (CTE + UNION ALL + FILTER)
WITH team_matches AS (
    SELECT team1_id AS team_id, winner_team_id FROM matches
    UNION ALL
    SELECT team2_id AS team_id, winner_team_id FROM matches
)
SELECT t.name                                                              AS team,
       COUNT(*)                                                            AS played,
       COUNT(*) FILTER (WHERE tm.winner_team_id =  tm.team_id)             AS wins,
       COUNT(*) FILTER (WHERE tm.winner_team_id <> tm.team_id)             AS losses,
       ROUND(100.0 * COUNT(*) FILTER (WHERE tm.winner_team_id = tm.team_id)
             / COUNT(*), 1)                                                AS winrate_pct
FROM team_matches tm
JOIN teams t ON t.team_id = tm.team_id
GROUP BY t.name
ORDER BY winrate_pct DESC, wins DESC;

-- Q7. Xəritə statistikası: neçə dəfə oynanılıb, seçilib, decider olub, overtime
--     (LEFT JOIN — heç oynanılmayan xəritələr də görünür)
SELECT mp.name                                                        AS map,
       mp.is_active_duty,
       COUNT(mm.match_map_id)                                         AS times_played,
       COUNT(mm.picked_by_team_id)                                    AS times_picked,
       COUNT(mm.match_map_id) FILTER (WHERE mm.picked_by_team_id IS NULL) AS as_decider,
       ROUND(AVG(mm.team1_score + mm.team2_score), 1)                 AS avg_rounds,
       COUNT(*) FILTER (WHERE GREATEST(mm.team1_score, mm.team2_score) > 13) AS overtimes
FROM maps mp
LEFT JOIN match_maps mm ON mm.map_id = mp.map_id
GROUP BY mp.map_id
ORDER BY times_played DESC, mp.name;

-- Q8. Hər komandanın ən güclü xəritəsi (CTE-lər zənciri + RANK)
WITH team_maps AS (
    SELECT m.team1_id AS team_id, mm.map_id, mm.team1_score > mm.team2_score AS won
    FROM match_maps mm JOIN matches m ON m.match_id = mm.match_id
    UNION ALL
    SELECT m.team2_id AS team_id, mm.map_id, mm.team2_score > mm.team1_score AS won
    FROM match_maps mm JOIN matches m ON m.match_id = mm.match_id
),
agg AS (
    SELECT team_id, map_id,
           COUNT(*)                     AS played,
           COUNT(*) FILTER (WHERE won)  AS wins
    FROM team_maps
    GROUP BY team_id, map_id
),
ranked AS (
    SELECT agg.*,
           RANK() OVER (PARTITION BY team_id
                        ORDER BY wins::NUMERIC / played DESC, played DESC) AS rnk
    FROM agg
)
SELECT t.name AS team, mp.name AS best_map, r.played, r.wins,
       ROUND(100.0 * r.wins / r.played) AS winrate_pct
FROM ranked r
JOIN teams t ON t.team_id = r.team_id
JOIN maps mp ON mp.map_id = r.map_id
WHERE r.rnk = 1
ORDER BY t.name, mp.name;

-- Q9. Turnirlər və onların çempionları (final matçının qalibi)
SELECT tr.name       AS tournament,
       tr.city,
       c.name        AS country,
       tr.tier,
       tr.is_major,
       tr.prize_pool,
       COALESCE(w.name, '— hələ məlum deyil —') AS champion
FROM tournaments tr
JOIN countries c     ON c.country_id = tr.country_id
LEFT JOIN matches f  ON f.tournament_id = tr.tournament_id AND f.stage = 'Final'
LEFT JOIN teams w    ON w.team_id = f.winner_team_id
ORDER BY tr.start_date;

-- Q10. Final matçlarının MVP-si — seriyada ən çox kill edən oyunçu
WITH final_stats AS (
    SELECT tr.name         AS tournament,
           p.nickname,
           tm.name         AS team,
           SUM(s.kills)    AS kills,
           SUM(s.deaths)   AS deaths,
           ROW_NUMBER() OVER (PARTITION BY m.match_id
                              ORDER BY SUM(s.kills) DESC, SUM(s.deaths)) AS rn
    FROM matches m
    JOIN tournaments tr         ON tr.tournament_id = m.tournament_id
    JOIN match_maps mm          ON mm.match_id      = m.match_id
    JOIN player_match_stats s   ON s.match_map_id   = mm.match_map_id
    JOIN players p              ON p.player_id      = s.player_id
    JOIN teams tm               ON tm.team_id       = s.team_id
    WHERE m.stage = 'Final'
    GROUP BY m.match_id, tr.name, p.player_id, tm.name
)
SELECT tournament, nickname AS mvp, team, kills, deaths
FROM final_stats
WHERE rn = 1;

-- Q11. Bir xəritədə ən yaxşı 5 fərdi oyun (rəqib komanda ilə birlikdə)
SELECT p.nickname,
       own.name     AS team,
       opp.name     AS opponent,
       mp.name      AS map,
       tr.name      AS tournament,
       s.kills, s.deaths, s.adr
FROM player_match_stats s
JOIN players p      ON p.player_id      = s.player_id
JOIN match_maps mm  ON mm.match_map_id  = s.match_map_id
JOIN maps mp        ON mp.map_id        = mm.map_id
JOIN matches m      ON m.match_id       = mm.match_id
JOIN tournaments tr ON tr.tournament_id = m.tournament_id
JOIN teams own      ON own.team_id      = s.team_id
JOIN teams opp      ON opp.team_id      = CASE WHEN s.team_id = m.team1_id
                                               THEN m.team2_id ELSE m.team1_id END
ORDER BY s.kills DESC, s.adr DESC
LIMIT 5;

-- Q12. Komandasının orta K/D göstəricisindən yüksək oynayanlar (korrelyasiyalı alt sorğu)
SELECT v.team, v.nickname, v.kd_ratio
FROM v_player_career_stats v
WHERE v.kd_ratio > (SELECT AVG(v2.kd_ratio)
                    FROM v_player_career_stats v2
                    WHERE v2.team = v.team)
ORDER BY v.team, v.kd_ratio DESC;

-- Q13. Komandaların yaş statistikası (STRING_AGG)
SELECT COALESCE(t.name, 'Free agents')                                   AS team,
       ROUND(AVG(EXTRACT(YEAR FROM CURRENT_DATE) - p.birth_year), 1)      AS avg_age,
       MIN(EXTRACT(YEAR FROM CURRENT_DATE) - p.birth_year)                AS youngest,
       MAX(EXTRACT(YEAR FROM CURRENT_DATE) - p.birth_year)                AS oldest,
       STRING_AGG(p.nickname, ', ' ORDER BY p.birth_year DESC)            AS players_young_to_old
FROM players p
LEFT JOIN teams t ON t.team_id = p.team_id
GROUP BY t.name
ORDER BY avg_age;

-- Q14. Oyunçuların inventarı: tam skin adı və float-a görə vəziyyəti (CASE)
SELECT p.nickname,
       CASE WHEN ps.is_stattrak THEN 'StatTrak™ ' ELSE '' END
           || w.name || ' | ' || s.name                   AS item,
       r.name                                             AS rarity,
       ps.float_value,
       CASE
           WHEN ps.float_value < 0.07 THEN 'Factory New'
           WHEN ps.float_value < 0.15 THEN 'Minimal Wear'
           WHEN ps.float_value < 0.38 THEN 'Field-Tested'
           WHEN ps.float_value < 0.45 THEN 'Well-Worn'
           ELSE 'Battle-Scarred'
       END                                                AS exterior,
       s.market_price
FROM player_skins ps
JOIN players p  ON p.player_id  = ps.player_id
JOIN skins s    ON s.skin_id    = ps.skin_id
JOIN weapons w  ON w.weapon_id  = s.weapon_id
JOIN rarities r ON r.rarity_id  = s.rarity_id
ORDER BY r.tier_order DESC, s.market_price DESC;

-- Q15. Ən bahalı inventar reytinqi (GROUP BY + DENSE_RANK)
SELECT DENSE_RANK() OVER (ORDER BY SUM(s.market_price) DESC) AS place,
       p.nickname,
       COALESCE(t.name, 'Free agent')                       AS team,
       COUNT(*)                                             AS skins_owned,
       SUM(s.market_price)                                  AS inventory_value_usd,
       MAX(s.market_price)                                  AS most_expensive_skin
FROM player_skins ps
JOIN players p     ON p.player_id = ps.player_id
JOIN skins s       ON s.skin_id   = ps.skin_id
LEFT JOIN teams t  ON t.team_id   = p.team_id
GROUP BY p.player_id, t.name
ORDER BY place;

-- Q16. Nadirlik dərəcələrinə görə skin sayı və orta qiymət (skin olmayan dərəcələr də)
SELECT r.tier_order,
       r.name                          AS rarity,
       r.color_hex,
       COUNT(s.skin_id)                AS skins_count,
       ROUND(AVG(s.market_price), 2)   AS avg_price_usd
FROM rarities r
LEFT JOIN skins s ON s.rarity_id = r.rarity_id
GROUP BY r.rarity_id
ORDER BY r.tier_order;

-- Q17. Bazada heç bir skini olmayan silahlar (NOT EXISTS)
SELECT w.name, w.category, w.price
FROM weapons w
WHERE NOT EXISTS (SELECT 1 FROM skins s WHERE s.weapon_id = w.weapon_id)
ORDER BY w.category, w.price;

-- Q18. Silahın qiyməti öz kateqoriyasının ortası ilə müqayisədə
--      və kateqoriya daxilində zərərə görə yeri (pəncərə funksiyaları AVG, RANK)
SELECT name,
       category,
       price,
       ROUND(AVG(price) OVER (PARTITION BY category))          AS category_avg_price,
       price - ROUND(AVG(price) OVER (PARTITION BY category))  AS diff_from_avg,
       damage,
       RANK() OVER (PARTITION BY category ORDER BY damage DESC) AS damage_rank
FROM weapons
ORDER BY category, price;

-- Q19. Tranzaksiya nümunəsi: transfer — s1mple FaZe Clan-a keçir.
--      ROLLBACK ilə ləğv olunur, baza dəyişmir.
BEGIN;
UPDATE players
SET team_id = (SELECT team_id FROM teams WHERE name = 'FaZe Clan')
WHERE nickname = 's1mple';

SELECT p.nickname, t.name AS new_team
FROM players p JOIN teams t ON t.team_id = p.team_id
WHERE p.nickname = 's1mple';
ROLLBACK;
