-------------------------------------------
-- Jared Beach - CS 457-001 - Assignment 2
-------------------------------------------

-- 8.  List the lname, ssn of employees who work on either pno=1 or pno=10:
--         a) Write this using a single block query
					  select lname,ssn from employee where
						  ssn = 123456789 or ssn = 453453453
						  or ssn = 333445555 or ssn = 999887777
						  or ssn = 987987987;
--         b) Write this using the keyword ‘join’ in the FROM clause
					  select lname,ssn from employee inner join works_on
						  on employee.ssn = works_on.ESSN
						  where works_on.pno = 1 or
						    works_on.pno = 10;
--         c) Write this as a nested query using the ‘in’ predicate
					  select lname,ssn from employee where ssn in
						(
						  select essn from works_on
						    where pno = 1 or pno = 10
						)
--         d) Write this as a nested query using a quantified predicate containing '='   
					  select lname,ssn from employee
					  where ssn =
					    any(
					      select essn from works_on
					        where pno = 1 or pno = 10
					    )      
--         e) Write this as a correlated nested query using the ‘exists’ predicate
					  select lname,ssn from employee
					  where exists(
					      select 1 from works_on
					        where (ssn=works_on.ESSN
					          and pno=1) or
					          (ssn=works_on.ESSN and pno=10)
					    )
--         f) Write this using a set operation 
					  select lname,ssn from employee
					  intersect
					    select lname,ssn from employee
					      inner join works_on on
					        employee.ssn = works_on.essn
					          where pno = 1 or pno = 10
--         g) Write this using a nested query in the FROM clause
					  select lname,ssn from (
						  select * from employee
						    inner join works_on
						      on employee.ssn = works_on.essn
						        where pno = 1 or pno = 10
						)
-- 9.  a) List the lname, ssn of employees who work on both pno=1 and pno=10;
				  select lname,ssn
				  from employee where
				  ssn in (select essn from works_on where pno=1)
				  and ssn in (select essn from works_on where pno=10)
--      b) List the lname, ssn of employees who work on both pno=1 and pno=2: 
				  select lname,ssn
				  from employee where
				  ssn in (select essn from works_on where pno=1)
				  and ssn in (select essn from works_on where pno=2)
-- 10. List the lname, ssn of employees who do NOT work on pno=1 or pno=10
--         a)  Write this query using a set operation
					  select lname,ssn
					  from employee minus
					    select lname,ssn from employee
							inner join works_on on works_on.essn=employee.ssn
					      where pno=1 or pno=10
--         b)  Write this query without using a set operation
					  select lname,ssn
							  from employee where
							  ssn not in (select essn from works_on where pno=1)
					  and ssn not in (select essn from works_on where pno=10)
-- 11. List the fname, lname of employees, the dname of the department they work for, and the pnames of the projects they work on, for all projects located in 'Stafford'.
	  select employee.fname,employee.lname,d.dname, pname
	  from employee
	  inner join works_on on employee.ssn=works_on.essn
	  inner join project on project.pnumber = works_on.pno
	  inner join department d on d.dnumber = employee.dno
	  where project.plocation = 'Stafford'

-- 12. List the first names and last names of employees who have the same birthday. List both employee names with the same birthday on one row.
  select
	x.fname,
	x.lname,
	em.fname,
	em.lname,
	from employee x
	  inner join employee em on x.fname<>em.fname
	  where substr(em.bdate,6,5)=substr(x.bdate,6,5)

-- 13. Retrieve the average salary and the population variance in the salary of employees who work for the department 'Administration'. Use the standard SQL aggregate to compute the population variance which is available in MySQL and also can be found in Analytic Functions - Oracle Documentation. 
	select avg(salary),var_pop(salary)
	from employee
	inner join department
	on employee.dno=department.dnumber
	where department.dname='Administration'
-- 14. For each department, list the dno, the bdate of the youngest employee, the bdate of the oldest employee and the difference in the department's maximum employee salary and minimum employee salary. Label these columns Youngest, Oldest and Bernie, respectively.  Sort the results in descending order by Bernie.  NOTE:  even though the bdate is stored as character, you can easily identify the birthdate of the youngest and oldest employee without any type conversion.
	select dnumber,
		min(bdate) as youngest,
		max(bdate) as oldest,
		( max(salary) - min(salary) ) as bernie
		from department
		inner join employee on dno=dnumber
		group by dnumber

-- 15.   For each employee, list the lname of the employee, the name of the department they work for and the lname of any employee they supervise (rename Supervisee).  Include all employees, even those who are not supervisors and order the result by the Supervisor's name.
	• select supervisor.lname,dname,supervisee.lname as supervisee
	from employee supervisor
	left outer join employee supervisee on supervisor.superssn=supervisee.ssn
	inner join department on supervisor.dno=department.dnumber
-- 16.   Retrieve employee's fname, lname for employees who have more than 1 dependent child (e.g. a son or daughter, not a spouse).  Write using group by and having.
	• select fname,lname from employee
	inner join dependent on employee.ssn=dependent.essn
	where (dependent.relationship = 'Son'
	or dependent.relationship = 'Daughter')
	having(count(relationship)>1)
	group by (employee.fname,employee.lname,employee.ssn);
-- 17.  Write question 16. without using group by or having.
	with ranked as (
	select employee.fname fname,employee.lname lname,
	rank() over (partition by dep.essn
	order by dep.bdate) rdep
	from dependent dep
	inner join employee on employee.ssn=dep.essn
	where dep.relationship='Daughter' or
	dep.relationship='Son'
	) select fname,lname from ranked
where rdep=2
