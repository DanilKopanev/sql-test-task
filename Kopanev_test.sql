-- Задание:
-- Есть таблица db со всеми сотрудниками фирмы.
-- user_id - id сотрудника (int32)
-- boss_user_id - user_id руководителя этого сотрудника (int32)
-- payment - зарплата сотрудника в рублях (double)


-- 1. Сколько в среднем прямых подчиненных у руководителей
-- (у которых есть хотя бы один подчинённый).
SELECT AVG(cnt_subordinates) AS avg_direct_reports
FROM (
    SELECT boss_user_id,
           COUNT(*) AS cnt_subordinates
    FROM db
    WHERE boss_user_id IS NOT NULL
    GROUP BY boss_user_id
) t;


-- 2. У каких сотрудников зарплата выше, чем у их руководителей
SELECT e.user_id AS employee_id,
       e.payment AS employee_payment,
       b.user_id AS boss_id,
       b.payment AS boss_payment
FROM db e
JOIN db b
  ON e.boss_user_id = b.user_id -- используем self join, чтобы связывать сотрудника с его руководителем
WHERE e.payment > b.payment;


-- 3. Разница между зарплатой сотрудника и средней зарплатой по отделу
-- Отдел = сотрудники с одинаковым boss_user_id
SELECT user_id,
       boss_user_id,
       payment,
       payment - AVG(payment) OVER (PARTITION BY boss_user_id) AS diff_from_dept_avg
FROM db;

