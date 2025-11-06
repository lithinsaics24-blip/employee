SELECT
    m.ename AS Manager_Name,
    COUNT(e.empno) AS Number_of_Employees
FROM
    employee e
JOIN
    employee m ON e.mgr_no = m.empno
GROUP BY
    m.empno, m.ename
HAVING
    COUNT(e.empno) = (
        SELECT
            MAX(employee_count)
        FROM
            (
                SELECT
                    COUNT(empno) AS employee_count
                FROM
                    employee
                WHERE
                    mgr_no IS NOT NULL
                GROUP BY
                    mgr_no
            ) AS subquery_counts
    );
 SELECT
    m.ename AS Manager_Name,
    m.sal AS Manager_Salary,
    AVG(e.sal) AS Avg_Employee_Salary
FROM
    employee e
JOIN
    employee m ON e.mgr_no = m.empno
GROUP BY
    m.empno, m.ename, m.sal
HAVING
    m.sal > AVG(e.sal);   
    
 WITH DeptTopManagers AS (
    -- Find the 'Top Manager' (who is not managed by anyone in the department)
    SELECT
        t1.deptno,
        t1.empno AS top_manager_empno
    FROM
        employee t1
    LEFT JOIN
        employee t2 ON t1.empno = t2.mgr_no
    WHERE
        t1.mgr_no IS NULL -- Top person is Arun (empno 1)
)
-- Then find the managers who report directly to the 'Top Manager'
SELECT DISTINCT
    m.ename AS Second_Top_Level_Manager,
    d.dname AS Department_Name
FROM
    employee m
JOIN
    DeptTopManagers dtm ON m.mgr_no = dtm.top_manager_empno
JOIN
    dept d ON m.deptno = d.deptno
WHERE
    m.mgr_no IS NOT NULL;   
    
    WITH RankedIncentives AS (
    SELECT
        empno,
        incentive_amount,
        incentive_date,
        -- Rank incentives for January 2024, descending
        DENSE_RANK() OVER (ORDER BY incentive_amount DESC) as rnk
    FROM
        incentives
    WHERE
       DATE_FORMAT(incentive_date, '%Y-%m') = '2024-01' -- Use correct date function for your SQL dialect
)
SELECT
    e.empno,
    e.ename,
    r.incentive_amount,
    r.incentive_date
FROM
    RankedIncentives r
JOIN
    employee e ON r.empno = e.empno
WHERE
    r.rnk = 2;
    
    SELECT
    e.ename AS Employee_Name,
    e.deptno AS Employee_Dept_No,
    m.ename AS Manager_Name,
    m.deptno AS Manager_Dept_No
FROM
    employee e
JOIN
    employee m ON e.mgr_no = m.empno
WHERE
    e.deptno = m.deptno;
