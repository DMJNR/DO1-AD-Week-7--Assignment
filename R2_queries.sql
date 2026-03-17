-- ======================================================
-- Aston University
-- Database Development (Summative assessment 2)
-- Student: David I Moses
-- Database: software_pm
-- File: R2 SQL Operations and Reports
-- ======================================================

USE software_pm;

-- ------------------------------------------------------
-- R2.1: Query verifies lookup tables.
-- ------------------------------------------------------

SELECT * FROM lu_contact_method ORDER BY contact_method_id;
SELECT * FROM lu_project_phase ORDER BY phase_id;
SELECT * FROM lu_experience_level ORDER BY experience_level_id;

-- ------------------------------------------------------
-- R2.2: Query verifies predefined skills list.
-- ------------------------------------------------------

SELECT
  skill_id,
  skill_name,
  skill_type
FROM skill
ORDER BY skill_id;

-- ---------------------------------------------------------
-- R2.3: Query displays all pool members with their skills 
-- and experience.
-- ---------------------------------------------------------   

SELECT
  pm.pool_member_id,
  CONCAT(pm.first_name, ' ', pm.last_name) AS pool_member,
  s.skill_name,
  s.skill_type,
  el.level_name AS experience_level,
  pms.years_experience
FROM pool_member pm
JOIN pool_member_skill pms
  ON pms.pool_member_id = pm.pool_member_id
JOIN skill s
  ON s.skill_id = pms.skill_id
JOIN lu_experience_level el
  ON el.experience_level_id = pms.experience_level_id
ORDER BY pm.pool_member_id, s.skill_type, s.skill_name;

-- ------------------------------------------------------
-- R2.4: Query displays clients and their projects.
-- ------------------------------------------------------

SELECT
  c.client_id,
  c.organisation_name,
  CONCAT(c.contact_first_name, ' ', c.contact_last_name) AS contact_name,
  cm.method_name AS preferred_contact_method,
  p.project_id,
  p.title,
  pp.phase_name AS lifecycle_phase,
  p.start_date,
  p.end_date,
  p.budget
FROM client c
JOIN lu_contact_method cm
  ON cm.contact_method_id = c.contact_method_id
LEFT JOIN project p
  ON p.client_id = c.client_id
LEFT JOIN lu_project_phase pp
  ON pp.phase_id = p.phase_id
ORDER BY c.client_id, p.project_id;

-- ------------------------------------------------------
-- R2.5: Query displays all project skill requirements.
-- ------------------------------------------------------

SELECT
  p.project_id,
  p.title,
  s.skill_name,
  s.skill_type,
  el.level_name AS required_experience_level
FROM project p
JOIN project_required_skill prs
  ON prs.project_id = p.project_id
JOIN skill s
  ON s.skill_id = prs.skill_id
JOIN lu_experience_level el
  ON el.experience_level_id = prs.required_experience_level_id
ORDER BY p.project_id, s.skill_type, s.skill_name;

-- ------------------------------------------------------
-- R2.6: Query displays pool members who fully match all 
-- requirements for each project.
-- ------------------------------------------------------

SELECT
  p.project_id,
  p.title,
  pm.pool_member_id,
  CONCAT(pm.first_name, ' ', pm.last_name) AS pool_member,
  COUNT(DISTINCT prs.skill_id) AS matched_required_skills,
  req.required_skill_count
FROM project p
JOIN (
  SELECT
    project_id,
    COUNT(*) AS required_skill_count
  FROM project_required_skill
  GROUP BY project_id
) req
  ON req.project_id = p.project_id
JOIN project_required_skill prs
  ON prs.project_id = p.project_id
JOIN pool_member_skill pms
  ON pms.skill_id = prs.skill_id
JOIN pool_member pm
  ON pm.pool_member_id = pms.pool_member_id
WHERE pms.experience_level_id >= prs.required_experience_level_id
GROUP BY
  p.project_id,
  p.title,
  pm.pool_member_id,
  pool_member,
  req.required_skill_count
HAVING COUNT(DISTINCT prs.skill_id) = req.required_skill_count
ORDER BY p.project_id, pm.pool_member_id;

-- ------------------------------------------------------
-- R2.7: Query ranks all fully eligible pool members for
-- project 1, in the event that only one pool member can be
-- assigned to a project.
--
-- Ranking logic:
-- 1) highest experience surplus across required skills
-- 2) highest total years of experience across required skills
-- 3) lowest pool_member_id as final tie-breaker
-- ------------------------------------------------------

SELECT
  pm.pool_member_id,
  CONCAT(pm.first_name, ' ', pm.last_name) AS pool_member,
  COUNT(DISTINCT prs.skill_id) AS matched_required_skills,
  req.required_skill_count,
  SUM(pms.years_experience) AS total_years_experience,
  SUM(pms.experience_level_id - prs.required_experience_level_id) AS experience_surplus
FROM pool_member pm
JOIN pool_member_skill pms
  ON pms.pool_member_id = pm.pool_member_id
JOIN project_required_skill prs
  ON prs.skill_id = pms.skill_id
JOIN (
  SELECT
    project_id,
    COUNT(*) AS required_skill_count
  FROM project_required_skill
  WHERE project_id = 1
  GROUP BY project_id
) req
  ON req.project_id = prs.project_id
LEFT JOIN project_assignment pa
  ON pa.pool_member_id = pm.pool_member_id
WHERE prs.project_id = 1
  AND pms.experience_level_id >= prs.required_experience_level_id
  AND pa.pool_member_id IS NULL
GROUP BY
  pm.pool_member_id,
  pool_member,
  req.required_skill_count
HAVING COUNT(DISTINCT prs.skill_id) = req.required_skill_count
ORDER BY
  experience_surplus DESC,
  total_years_experience DESC,
  pm.pool_member_id ASC;

-- -------------------------------------------------------
-- R2.8: Query assigns only the top candidate to Project 1
-- -------------------------------------------------------

INSERT INTO project_assignment (project_id, pool_member_id)
SELECT
  1 AS project_id,
  best_candidate.pool_member_id
FROM (
  SELECT
    pm.pool_member_id,
    COUNT(DISTINCT prs.skill_id) AS matched_required_skills,
    req.required_skill_count,
    SUM(pms.years_experience) AS total_years_experience,
    SUM(pms.experience_level_id - prs.required_experience_level_id) AS experience_surplus
  FROM pool_member pm
  JOIN pool_member_skill pms
    ON pms.pool_member_id = pm.pool_member_id
  JOIN project_required_skill prs
    ON prs.skill_id = pms.skill_id
  JOIN (
    SELECT
      project_id,
      COUNT(*) AS required_skill_count
    FROM project_required_skill
    WHERE project_id = 1
    GROUP BY project_id
  ) req
    ON req.project_id = prs.project_id
  LEFT JOIN project_assignment pa
    ON pa.pool_member_id = pm.pool_member_id
  WHERE prs.project_id = 1
    AND pms.experience_level_id >= prs.required_experience_level_id
    AND pa.pool_member_id IS NULL
  GROUP BY
    pm.pool_member_id,
    req.required_skill_count
  HAVING COUNT(DISTINCT prs.skill_id) = req.required_skill_count
  ORDER BY
    experience_surplus DESC,
    total_years_experience DESC,
    pm.pool_member_id ASC
  LIMIT 1
) AS best_candidate;

-- -------------------------------------------------------
-- R2.9: Query confirms assignment for project 1
-- -------------------------------------------------------

SELECT
  pa.assignment_id,
  p.project_id,
  p.title,
  CONCAT(pm.first_name, ' ', pm.last_name) AS assigned_member,
  pa.assigned_on
FROM project_assignment pa
JOIN project p
  ON p.project_id = pa.project_id
JOIN pool_member pm
  ON pm.pool_member_id = pa.pool_member_id
WHERE p.project_id = 1
ORDER BY pa.assignment_id;

-- -------------------------------------------------------
-- R2.10: Query assigns best match for project 2
-- -------------------------------------------------------

INSERT INTO project_assignment (project_id, pool_member_id)
SELECT
  2 AS project_id,
  eligible.pool_member_id
FROM (
  SELECT
    pm.pool_member_id
  FROM pool_member pm
  JOIN pool_member_skill pms
    ON pms.pool_member_id = pm.pool_member_id
  JOIN project_required_skill prs
    ON prs.skill_id = pms.skill_id
  JOIN (
    SELECT
      project_id,
      COUNT(*) AS required_skill_count
    FROM project_required_skill
    WHERE project_id = 2
    GROUP BY project_id
  ) req
    ON req.project_id = prs.project_id
  WHERE prs.project_id = 2
    AND pms.experience_level_id >= prs.required_experience_level_id
  GROUP BY pm.pool_member_id, req.required_skill_count
  HAVING COUNT(DISTINCT prs.skill_id) = req.required_skill_count
) AS eligible
LEFT JOIN project_assignment pa
  ON pa.pool_member_id = eligible.pool_member_id
WHERE pa.pool_member_id IS NULL;

-- -------------------------------------------------------
-- R2.11: Query confirms assignment for project 2
-- -------------------------------------------------------

SELECT
  pa.assignment_id,
  p.project_id,
  p.title,
  CONCAT(pm.first_name, ' ', pm.last_name) AS assigned_member,
  pa.assigned_on
FROM project_assignment pa
JOIN project p
  ON p.project_id = pa.project_id
JOIN pool_member pm
  ON pm.pool_member_id = pa.pool_member_id
WHERE p.project_id = 1
ORDER BY pa.assignment_id;

-- ------------------------------------------------------------
-- R2.12: BEST MATCH PER PROJECT
--
-- Query returns the top-ranked candidate(s) for each project.
-- The best candidate for project 4 does not meet all requirements.
-- This highlights the need for training or recruitment to fill skill gaps.
-- ------------------------------------------------------------

SELECT *
FROM (
  SELECT
    p.project_id,
    p.title,
    pm.pool_member_id,
    CONCAT(pm.first_name, ' ', pm.last_name) AS pool_member,
    COUNT(DISTINCT CASE
      WHEN pms.experience_level_id >= prs.required_experience_level_id
      THEN prs.skill_id
    END) AS matched_required_skills,
    req.required_skill_count,
    SUM(CASE
      WHEN pms.experience_level_id >= prs.required_experience_level_id
      THEN (pms.experience_level_id - prs.required_experience_level_id)
      ELSE 0
    END) AS experience_surplus,
    ROUND(
      COUNT(DISTINCT CASE
        WHEN pms.experience_level_id >= prs.required_experience_level_id
        THEN prs.skill_id
      END) * 100.0 / req.required_skill_count,
      2
    ) AS match_percentage,
    DENSE_RANK() OVER (
      PARTITION BY p.project_id
      ORDER BY
        COUNT(DISTINCT CASE
          WHEN pms.experience_level_id >= prs.required_experience_level_id
          THEN prs.skill_id
        END) DESC,
        SUM(CASE
          WHEN pms.experience_level_id >= prs.required_experience_level_id
          THEN (pms.experience_level_id - prs.required_experience_level_id)
          ELSE 0
        END) DESC,
        pm.pool_member_id
    ) AS candidate_rank
  FROM project p
  JOIN (
    SELECT
      project_id,
      COUNT(*) AS required_skill_count
    FROM project_required_skill
    GROUP BY project_id
  ) req
    ON req.project_id = p.project_id
  CROSS JOIN pool_member pm
  LEFT JOIN project_required_skill prs
    ON prs.project_id = p.project_id
  LEFT JOIN pool_member_skill pms
    ON pms.pool_member_id = pm.pool_member_id
    AND pms.skill_id = prs.skill_id
  GROUP BY
    p.project_id,
    p.title,
    pm.pool_member_id,
    pool_member,
    req.required_skill_count
) ranked_candidates
WHERE candidate_rank = 1
ORDER BY project_id, pool_member_id;

-- ------------------------------------------------------
-- R2.13: Additional management reports
-- ------------------------------------------------------

-- Report 1: All projects with client and lifecycle phase
SELECT
  p.project_id,
  p.title,
  c.organisation_name AS client,
  pp.phase_name,
  p.start_date,
  p.end_date,
  p.budget
FROM project p
JOIN client c
  ON c.client_id = p.client_id
JOIN lu_project_phase pp
  ON pp.phase_id = p.phase_id
ORDER BY p.project_id;

-- Report 2: Assigned pool members per project (including unassigned projects)
SELECT
  p.project_id,
  p.title,
  c.organisation_name AS client,
  CONCAT(pm.first_name, ' ', pm.last_name) AS assigned_member,
  pa.assigned_on
FROM project p
JOIN client c
  ON c.client_id = p.client_id
LEFT JOIN project_assignment pa
  ON pa.project_id = p.project_id
LEFT JOIN pool_member pm
  ON pm.pool_member_id = pa.pool_member_id
ORDER BY p.project_id, pm.pool_member_id;

-- Report 4: Unassigned pool members
SELECT
  pm.pool_member_id,
  CONCAT(pm.first_name, ' ', pm.last_name) AS pool_member,
  pm.email
FROM pool_member pm
LEFT JOIN project_assignment pa
  ON pa.pool_member_id = pm.pool_member_id
WHERE pa.pool_member_id IS NULL
ORDER BY pm.pool_member_id;

-- Report 5: Skills coverage across pool members
SELECT
  s.skill_name,
  s.skill_type,
  COUNT(pms.pool_member_id) AS number_of_pool_members
FROM skill s
LEFT JOIN pool_member_skill pms
  ON pms.skill_id = s.skill_id
GROUP BY s.skill_id, s.skill_name, s.skill_type
ORDER BY number_of_pool_members DESC, s.skill_type, s.skill_name;
