SELECT *
FROM master..playerdata2


--collecting relevant data
SELECT p1.player1 AS player, p1.pos_x AS player_position, p1.squad_x AS team, p1._90s_x AS '90s', p1.Gls AS goals, p2.Ast AS assists, p1.Sh AS shots, p1.SoT, p1.SoT1 as shot_acc, p1.xG, p2.xA, p2.KP AS killer_balls, p2._1_3 AS passes_into_3rd, (p2.PPA + p2.CrsPA) AS balls_into_box, p2.Prog AS prog_passes, p1.Att_pen AS box_touches, p1.Succ AS successful_dribbles, p1.Succ1 AS drib_success
from master..playerdata p1
JOIN master..playerdata2 p2
ON p1.player1 = p2.player
WHERE p1.pos_x LIKE '%FW%' AND p1._90s_x > 7 OR p1.player1 LIKE 'Dominic Calvert-Lewin' OR p1.player1 LIKE 'Neal Maupay' OR p1.player1 LIKE 'Alex Iwobi'
ORDER BY p1.xG DESC


SELECT squad_x as squad, SUM(gls) as total_goals, SUM(sh) AS total_shots, SUM(gls)/SUM(sh) AS conversion
from master..playerdata
GROUP BY squad_x
ORDER BY conversion ASC


--total goals for each team so far 
SELECT squad_x AS squad, SUM(gls) as total_goals
from master..playerdata
GROUP BY squad_x
ORDER BY total_goals DESC

--pass completion of each midfielder with more than 5 games played
SELECT p2.player, p1.squad_x AS team, p2.cmp1 AS pass_completion
FROM master..playerdata p1
JOIN master..playerdata2 p2
ON p1.player1 = p2.player
WHERE p1._90s_x > 5
ORDER BY team, p2.cmp1 DESC


--Each squad's midfield pass completion average
SELECT p1.squad_x AS team, AVG(p2.cmp1) AS pass_completion_avg
FROM master..playerdata p1
JOIN master..playerdata2 p2
ON p1.player1 = p2.player
WHERE p1.pos_x LIKE '%MF%' AND p1._90s_x > 5
GROUP BY p1.squad_x
ORDER BY pass_completion_avg DESC


--Player specific defensive stats
SELECT *
FROM master..playerdefending
WHERE pos LIKE '%DF%'

--team total defensive actions ordered from busiest to quietest (surprise surprise!)
SELECT squad, SUM(TklW) AS total_tackles, SUM(Blocks) AS total_blocks, SUM(Clr) AS total_clearances, (SUM(TklW) + SUM(Blocks) + SUM(Clr)) AS total_defensive_actions
FROM master..playerdefending
WHERE pos LIKE '%DF%'
GROUP BY squad
ORDER BY total_defensive_actions DESC


--Possession AGAINST stats
SELECT opposs.squad1 AS squad, opposs.touches AS total_opp_touches, opposs.Att_3rd AS opp_att_3rd_touches, opposs.Att_pen AS opp_touches_in_box, opposs.succ1 AS opp_drib_success, opsh.gls AS goals_conceded, opsh.sh AS shots_conceded, opsh.sot AS SoT_conceded, opsh.G_Sot as goals_per_sot, opsh.dist AS shot_distance_avg, opsh.xG AS xGA
FROM master..opposingpossession opposs
JOIN master..opposingshooting opsh
ON opposs.squad1 = opsh.squad2
ORDER BY opposs.Att_pen DESC

--attacks conceded
SELECT squad2, gls AS goals_conceded, sh AS shots_conceded, sot AS SoT_conceded, G_Sot as goals_per_sot, dist AS shot_distance_avg, xG AS xGA
FROM master..opposingshooting
ORDER BY (gls/sh) DESC
