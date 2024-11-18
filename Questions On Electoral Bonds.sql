-- 1. Find out how much donors spent on bonds --
SELECT SUM(Denomination) as 'Total Amount bought'
FROM donordata d  
JOIN bonddata b on d.Unique_key = b.Unique_key;

-- 2.Find out total fund politicians got  --
SELECT SUM(Denomination) as 'Total Recived Amount'
FROM receiverdata r 
JOIN bonddata b on r.Unique_key = b.Unique_key;

-- 3.Find out the total amount of unaccounted money recived by parties (Money without donors) 
SELECT SUM(Denomination) as 'Unaccounted Amount'
FROM donordata d 
RIGHT JOIN receiverdata r ON r.Unique_key = d.Unique_key
JOIN bonddata b ON r.Unique_key = b.Unique_key
WHERE purchaser IS NULL;

-- 4. Find year wise how much money is spent on bonds 
SELECT YEAR(d.PurchaseDate) AS `year`,SUM(Denomination) AS 'year wise bond spending'
FROM donordata d
JOIN bonddata b ON b.unique_key = d.unique_key
GROUP BY `year`
ORDER BY `year wise bond spending` DESC;

-- 5. In which month most amount is spent on bonds 
 WITH city_bond_spending_cte AS (
 SELECT MONTH(d.PurchaseDate) AS `Month`, SUM(b.Denomination) AS 'city_bond_spending'
 FROM donordata d
 JOIN bonddata b ON b.unique_key = d.unique_key
 GROUP BY `Month`
 )
 SELECT *
 FROM city_bond_spending_cte
 WHERE city_bond_spending = (
 SELECT MAX(city_bond_spending)
 FROM city_bond_spending_cte
 );

-- 6. Find out which company bought the highest number of bonds. 
WITH SpendingCounts AS (
 SELECT purchaser, COUNT(d.unique_key) AS company_bondcount
 FROM donordata d 
JOIN bonddata b ON d.Unique_key = b.Unique_key
 GROUP BY purchaser
 )
 SELECT purchaser, company_bondcount as 'Max bond bought'
 FROM SpendingCounts
 WHERE company_bondcount = (
 SELECT MAX(company_bondcount)
 FROM SpendingCounts
 );

-- 7. Find out which company spent the most on electoral bonds. (k)
 WITH SpendingCounts AS (
 SELECT purchaser, SUM(Denomination) as spending_count
 FROM donordata d 
JOIN bonddata b ON d.Unique_key = b.Unique_key
 GROUP BY purchaser
 )
 SELECT purchaser, spending_count as 'Company Spending'
 FROM SpendingCounts
 WHERE spending_count = (
 SELECT MAX(spending_count)
 FROM SpendingCounts
 );
 
 -- 8. List companies which paid the least to political parties. (k)
 WITH SpendingCounts AS (
 SELECT purchaser, SUM(Denomination) as spending_count
 FROM donordata d 
JOIN bonddata b ON d.Unique_key = b.Unique_key
 GROUP BY purchaser
 )
 SELECT purchaser, spending_count as 'Company Spending'
 FROM SpendingCounts
 WHERE spending_count = (
 SELECT MIN(spending_count)
 FROM SpendingCounts
 );
 
 -- 9. Which political party received the highest cash? (k)
  WITH SpendingCounts AS (
 SELECT partyname, SUM(Denomination) as Encashment
 FROM receiverdata r  
JOIN bonddata b ON r.Unique_key = b.Unique_key
 GROUP BY partyname
 )
 SELECT partyname, Encashment as 'Fund Received'
 FROM SpendingCounts
 WHERE Encashment = (
 SELECT MAX(Encashment)
 FROM SpendingCounts
 );
 
 -- 10. Which political party received the highest number of electoral bonds? (k)
WITH SpendingCounts AS (
 SELECT partyname, COUNT(Denomination) as Encashment_count
 FROM receiverdata r  
JOIN bonddata b ON r.Unique_key = b.Unique_key
 GROUP BY partyname
 )
 SELECT partyname, Encashment_count as 'Company Spending'
FROM SpendingCounts
 WHERE Encashment_count = (
 SELECT MAX(Encashment_count)
 FROM SpendingCounts
 );
 
 -- 11. Which political party received the least cash? (k)
WITH SpendingCounts AS (
 SELECT partyname, SUM(Denomination) as Encashment
 FROM receiverdata r  
JOIN bonddata b ON r.Unique_key = b.Unique_key
 GROUP BY partyname
 )
 SELECT partyname, Encashment as 'Fund Received'
 FROM SpendingCounts
 WHERE Encashment = (
 SELECT MIN(Encashment)
 FROM SpendingCounts
 );
 
 -- 12. Which political party received the least number of electoral bonds? (k)
  WITH SpendingCounts AS (
 SELECT partyname, COUNT(Denomination) as Encashment_count
 FROM receiverdata r  
JOIN bonddata b ON r.Unique_key = b.Unique_key
 GROUP BY partyname
 )
 SELECT partyname, Encashment_count as 'Company Spending'
 FROM SpendingCounts
 WHERE Encashment_count = (
 SELECT MIN(Encashment_count)
 FROM SpendingCounts
 );

-- 13. Find the 2nd higest donor in terms of amount he paid?
SELECT purchaser, SUM(Denomination) as 'purchaser total donation'
 FROM donordata d
 JOIN bonddata b ON d.Unique_key = b.Unique_key
 GROUP BY purchaser 
HAVING `purchaser total donation` = (SELECT DISTINCT(SUM(Denomination)) as 'purchaser total donation'FROM donordata d
JOIN bonddata b ON d.Unique_key = b.Unique_key 
GROUP BY purchaser
ORDER BY `purchaser total donation` DESC
LIMIT 1
OFFSET 1) ;

-- 14. Find the party which recived the second highest donations?
 SELECT PartyName, SUM(Denomination) as 'party received'
 FROM receiverdata r
 JOIN bonddata b ON r.Unique_key = b.Unique_key
 GROUP BY PartyName 
HAVING `party received` = (
 SELECT DISTINCT(SUM(Denomination)) as 'party received'
 FROM receiverdata r
 JOIN bonddata b ON r.Unique_key = b.Unique_key
 GROUP BY PartyName
 ORDER BY `party received` DESC
 LIMIT 1
 OFFSET 1) ;
 
 -- 15. Find the party which recived the second highest number of bonds?
 SELECT PartyName, COUNT(r.Unique_key) as 'party received'
 FROM receiverdata r
 JOIN bonddata b ON r.Unique_key = b.Unique_key
 GROUP BY PartyName
 HAVING `party received` = (
SELECT DISTINCT(COUNT(r.Unique_key)) as 'party received'
 FROM receiverdata r
 JOIN bonddata b ON r.Unique_key = b.Unique_key
 GROUP BY PartyName
 ORDER BY `party received` DESC
 LIMIT 1
 OFFSET 1);
 
 -- 16. In which city were the most number of bonds purchased? (k)
  WITH city_bond_count as ( SELECT b.city, COUNT(c.Denomination) as 'city bond spending'
 FROM donordata d
 JOIN bankdata b ON d.paybranchcode = b.branchcodeNo
 JOIN bonddata c ON c.unique_key = d.unique_key
 GROUP BY b.city
 ORDER BY `city bond spending` DESC)
 SELECT *
 FROM city_bond_count 
WHERE `city bond spending` = ( SELECT MAX(`city bond spending`)
 FROM city_bond_count);
 
 -- 17. In which city was the highest amount spent on electoral bonds? (k)
 WITH city_bond_amt as ( SELECT b.city, SUM(c.Denomination) as 'city bond spending'
 FROM donordata d
 JOIN bankdata b ON d.paybranchcode = b.branchcodeNo
 JOIN bonddata c ON c.unique_key = d.unique_key
 GROUP BY b.city
 ORDER BY `city bond spending` DESC)
 SELECT *
 FROM city_bond_amt
 WHERE `city bond spending` = ( SELECT MAX(`city bond spending`)
 FROM city_bond_amt);
 
 -- 18. In which city were the least number of bonds purchased? (k)
 WITH city_bond_count as ( SELECT b.city, COUNT(c.Denomination) as 'city bond spending'
 FROM donordata d
 JOIN bankdata b ON d.paybranchcode = b.branchcodeNo
 JOIN bonddata c ON c.unique_key = d.unique_key
 GROUP BY b.city
 ORDER BY `city bond spending` DESC)
 SELECT *
 FROM city_bond_count 
WHERE `city bond spending` = ( SELECT MIN(`city bond spending`) FROM city_bond_count);
 
 -- 19. In which city were the most number of bonds encashed? (k)
  WITH city_bond_amt as ( SELECT b.city, COUNT(r.unique_key) as 'city bond encashment'
 FROM receiverdata r
 JOIN bankdata b ON r.paybranchcode = b.branchcodeNo
 JOIN bonddata c ON c.unique_key = r.unique_key
 GROUP BY b.city
 ORDER BY `city bond encashment` DESC)
 SELECT *
 FROM city_bond_amt
 WHERE `city bond encashment` = ( SELECT MAX(`city bond encashment`)
 FROM city_bond_amt);
 
 -- 20. In which city least amount is encashed in bond forms? 
  WITH city_bond_amt as ( SELECT b.city, SUM(c.Denomination) as 'city bond encashment'
 FROM receiverdata r
 JOIN bankdata b ON r.paybranchcode = b.branchcodeNo
 JOIN bonddata c ON c.unique_key = r.unique_key
 GROUP BY b.city
 ORDER BY `city bond encashment` DESC)
 SELECT *
 FROM city_bond_amt
 WHERE `city bond encashment` = ( SELECT MIN(`city bond encashment`)
 FROM city_bond_amt);
 
 
 -- 21. List the branches where no electoral bonds were bought; if none, mention it as null.--
SELECT bd.Address 
FROM bankdata as bd
left join receiverdata as r
on bd.branchcodeno = r.paybranchcode
LEFT JOIN donordata d 
ON r.Unique_key = d.Unique_key
LEFT JOIN bonddata b 
ON r.Unique_key = b.Unique_key
WHERE d.Unique_key IS NULL
group by bd.Address;

 -- 22. Break down how much money is spent on electoral bonds for each year. 
  SELECT YEAR(d.PurchaseDate) AS `year` ,SUM(c.Denomination) AS 'year wise bond spending'
 FROM donordata d
 JOIN bankdata b ON d.paybranchcode = b.branchcodeNo
 JOIN bonddata c ON c.unique_key = d.unique_key
 GROUP BY `year`
 ORDER BY `year wise bond spending` DESC;
 
 -- 23. Find out how many donors bought the bonds but not donated to any political party? 
 SELECT COUNT(*)
 FROM donordata d
 LEFT JOIN receiverdata r ON r.Unique_key = d.Unique_key
 WHERE r.partyname is NULL;
 
 -- 24.Find out the money that could have gone to the PM Office, assuming the above question assumption (Domain Knowledge) 
  SELECT SUM(Denomination)
 FROM donordata d
 LEFT JOIN receiverdata r ON r.Unique_key = d.Unique_key
 JOIN bonddata b ON b.Unique_key = d.Unique_key
 WHERE partyname is NULL;
 
 
 -- 25. Find out how many bonds don't have donars associated with it.
 SELECT COUNT(*)
 FROM donordata d
 RIGHT JOIN receiverdata r ON r.Unique_key = d.Unique_key
 WHERE purchaser is NULL;
 
-- 26. Pay Teller is the employee ID who either created the bond or redeemed it. So find the employee ID who issued the highest number of bonds.--

CREATE VIEW donor_employee_performance AS (
 SELECT Payteller, COUNT(b.unique_key) AS 'employee_bond_count', SUM(Denomination) AS 'employee_bond_amount'
 FROM donordata d
 JOIN bonddata b ON d.unique_key = b.unique_key
 GROUP BY Payteller
 ORDER BY `employee_bond_count`, `employee_bond_amount`);
 
 SELECT * FROM donor_employee_performance;
 
 -- 27. Find the employee ID who issued the least number of bonds--
 SELECT Payteller
 FROM donor_employee_performance
 WHERE `employee_bond_count` = (SELECT MAX(`employee_bond_count`)
 FROM donor_employee_performance);
 
 -- 28. Find the employee ID who assisted in redeeming or enchasing bonds the most--
 SELECT Payteller
 FROM donor_employee_performance
 WHERE `employee_bond_amount` = (SELECT MAX(`employee_bond_amount`)FROM donor_employee_performance);
 
 -- 30. Find the employee ID who assisted in redeeming or enchasing bonds the least --
 SELECT Payteller
 FROM donor_employee_performance
 WHERE `employee_bond_count` = (SELECT MIN(`employee_bond_count`)
 FROM donor_employee_performance);
 
 
-- 1. Tell me total how many bonds are created?-- 
 SELECT COUNT(Unique_key) as 'All Bonds Count'
 FROM bonddata;
 
 -- 2. Find the count of Unique Denominations provided by SBI? -- 
 SELECT COUNT(DISTINCT Denomination) AS 'Unique count of amonut denominations'
 FROM bonddata;
 
 -- 3. List all the unique denominations that are available?
SELECT DISTINCT Denomination AS 'Unique denominations'
FROM bonddata;

-- 4. Total money recived by the bank for selling bonds
SELECT SUM(Denomination) AS 'Total Amount Received by Bank'
FROM bonddata;

-- 5. Find the count of bonds for each denominations that are created. --
 SELECT Denomination, COUNT(Denomination) as 'count of Denominations'
 FROM bonddata
 GROUP BY Denomination
 ORDER BY Denomination;
 
 -- 6. Find the count and Amount or Valuation of electoral bonds for each denominations --
SELECT Denomination,
COUNT(Denomination) as `count of Denominations`,
Denomination * COUNT(Denomination) as `Total Value`
FROM bonddata
GROUP BY Denomination
ORDER BY Denomination;

-- 7. Number of unique bank branches where we can buy electroal bond? --
SELECT COUNT(branchcodeno)
FROM bankdata;

-- 8. How many companies bought electoral bonds -- 
SELECT COUNT(DISTINCT purchaser) AS 'No of Political Donors'
FROM donordata;
 
-- 9. How many companies made political donations --
 SELECT COUNT(DISTINCT purchaser) AS 'No of Political Donors'
 FROM donordata d
 JOIN receiverdata r on r.Unique_key = d.Unique_key;
 
 -- 10. How many number of parties recived donations --
 SELECT COUNT(DISTINCT Partyname) AS 'No of Political Parties'
 FROM receiverdata;
 
 -- 11. List all the political parties that received donations --
SELECT DISTINCT Partyname AS 'List of political parties'
FROM receiverdata;

-- 12. What is the average amount that each political party recived --
SELECT Partyname, SUM(Denomination)/COUNT(Denomination) AS 'Average Amount Received by political party'
FROM receiverdata r 
JOIN bonddata b on b.Unique_key = r.Unique_key
GROUP BY Partyname;

-- 13. What is the average bond value produced by bank
SELECT AVG(Denomination) as 'Average bond value'
FROM bonddata;

-- 14 . List the political parties which have enchased bonds in different cities?
 SELECT Partyname
 FROM (SELECT Partyname, CITY, COUNT(Unique_key) AS PartyCount
 FROM receiverdata r 
JOIN bankdata b ON r.PayBranchCode = b.branchcodeno 
GROUP BY Partyname, CITY) as d
 GROUP BY Partyname
 HAVING COUNT(CITY) > 1
 ORDER BY Partyname;
 
 -- 15 . List the political parties which have enchased bonds in different cities and list the cities in which the bonds have encashed as well?
  WITH PartyCityCounts AS (
 SELECT Partyname, CITY, COUNT(Unique_key) AS PartyCount
 FROM receiverdata r 
JOIN bankdata b ON r.PayBranchCode = b.branchcodeno 
GROUP BY Partyname, CITY
 )
 SELECT Partyname, CITY
 FROM PartyCityCounts
 WHERE Partyname IN (
 SELECT Partyname
 FROM PartyCityCounts
 GROUP BY Partyname
 HAVING COUNT(CITY) > 1
 )
 ORDER BY Partyname;