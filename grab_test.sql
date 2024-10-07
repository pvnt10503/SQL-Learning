--Create Schema Grab;
CREATE TABLE Candidates
(
    employee_id INT NOT NULL PRIMARY KEY,
    -- primary key column
    experience varchar (50) NOT NULL,
    salary int NOT NULL
);
insert into Candidates VALUES
  --Test case 1
  (1, 'Senior', 10000),  -- Acceptable
    (2, 'Senior', 40000),  -- Acceptable
    (3, 'Senior', 30000),  -- Exceeds budget
    (4, 'Junior', 20000),  -- Remaining budget is low, can't hire this junior
    (5, 'Junior', 5000),   -- Acceptable (depending on the remaining budget after seniors)
    (6, 'Junior', 5000);
--Main case
    (1, 'Junior', 10000),
    (9, 'Junior', 10000),
    (2, 'Senior', 20000),
    (11, 'Senior', 20000),
    (13, 'Senior', 50000),
    (4, 'Junior', 40000);
--Test case 2
 (1, 'Senior', 10000),
    (2, 'Senior', 30000),
    (3, 'Senior', 30000),
    (4, 'Junior', 5000),
    (5, 'Junior', 5000),
    (6, 'Junior', 15000);
--Test case 3
   (1, 'Senior', 25000),
    (2, 'Senior', 25000),
    (3, 'Senior', 30000),
    (4, 'Junior', 15000),
    (5, 'Junior', 15000),
    (6, 'Junior', 10000);
select * from candidates

truncate table candidates

with senior as(
    select experience,
    sum(salary) over(
        order by salary
        ) as senior_salary,
    row_number() over(
        PARTITION BY experience order by salary
        ) as rn
    from Candidates
    where experience = 'Senior'
    ),
    junior as(
        select experience,sum(salary) over(
        order by salary
        ) as junior_salary,
    row_number() over(
    order by salary
        ) as rn1
    from Candidates
    where experience = 'Junior'
    )
select experience, max(rn) as accepted_candidates from senior
where senior_salary <= 70000
group by experience
union
select experience, max(rn1) as accepted_cadidates from junior
where junior_salary <= coalesce(70000 - (
    select max(senior_salary) from senior where senior_salary <= 70000
    ),0)
group by experience

/* Recommended Query from ChatGPT
WITH SeniorCandidates AS (
    SELECT employee_id, experience, salary,
           SUM(salary) OVER (ORDER BY salary) AS running_total
    FROM Candidates
    WHERE experience = 'Senior'
),
HiredSeniors AS (
    SELECT employee_id, experience, salary
    FROM SeniorCandidates
    WHERE running_total <= 70000
),
RemainingBudget AS (
    SELECT 70000 - COALESCE(SUM(salary), 0) AS remaining_budget
    FROM HiredSeniors
),
JuniorCandidates AS (
    SELECT employee_id, experience, salary,
           SUM(salary) OVER (ORDER BY salary) AS running_total
    FROM Candidates
    WHERE experience = 'Junior'
),
HiredJuniors AS (
    SELECT jc.employee_id, jc.experience, jc.salary
    FROM JuniorCandidates jc
    CROSS JOIN RemainingBudget rb
    WHERE jc.running_total <= rb.remaining_budget
)
SELECT experience, COUNT(employee_id) AS accepted_candidates
FROM (
    SELECT * FROM HiredSeniors
    UNION ALL
    SELECT * FROM HiredJuniors
) AS AllHires
GROUP BY experience;