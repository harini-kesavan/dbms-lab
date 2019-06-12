rem 1. Display the food details that is not purchased by any of customers.

select * 
from products
where pid not in(select distinct item
				 from item_list);

rem 2. Show the customer details who had placed more than 2 orders on the same date.

select *
from customers
where cid in(select cid 
			 from Receipts 
			 group by rdate,cid
			 having count(*)>2);

rem 3: Display the products details that has been ordered maximum by the customers. (use
rem ALL)

select * 
from products
where pid in (select item
			  from item_list
			  group by item
			  having count(*)>= all(select count(*)
									from item_list
									group by item));

rem 4. Show the number of receipts that contain the product whose price is more than the
average price of its food type.

select count(count(*)) 
from item_list 
where item in (select pid 
			   from products p1 
			   where price > (select avg(price) 
							  from products p2 
							  group by food 
                              having p1.food = p2.food))
group by rno;

rem Write the following using JOIN: (Use sub­query if required)
rem 5. Display the customer details along with receipt number and date for the receipts that
rem are dated on the last day of the receipt month.

select c.*,r.rno,r.rdate
from customers c join Receipts r on(c.cid=r.cid)
where r.rdate=last_day(r.rdate);

rem 6. Display the receipt number(s) and its total price for the receipt(s) that contain Twist as one among five items. Include only the receipts with total price more than $25

select i.rno, sum(p.price) 
from item_list i join products p on(i.item = p.pid)
where i.rno in(select i.rno 
			   from item_list i join products p on(i.item = p.pid) 
			   where p.food = 'Twist' 
			   group by i.rno)
group by i.rno 
having sum(p.price) > 25 and count(*) = 5;


 REM 7. Display the details (customer details, receipt number, item) for the product that was purchased by the least number of customers.
 
 select c.*,r.rno,i.item
 from customers c join Receipts r on(c.cid=r.cid) join item_list i on(r.rno=i.rno)
 where i.item in(select p.pid 
			     from products p join item_list i on(p.pid = i.item)
				 group by p.pid 
				 having count(*) <= all(select count(*) 
										from products p join item_list i on(p.pid = i.item) 
										group by p.pid));


REM 8.Display the customer details along with the receipt number who ordered all the flavors of Meringue in the same receipt.


select c.*,r1.rno 
from customers c join Receipts r1 on(c.cid=r1.cid)
where r1.rno=(select r2.rno 
			  from Receipts r2 join item_list i on(r2.rno=i.rno) join products p on(p.pid=i.item)
			  where p.food='Meringue'
			  group by r2.rno
			  having count(distinct flavor)=(select count(flavor)
											 from products
											 where food='Meringue'));
											 
											 
											 
rem Write the following using Set Operations:

rem 9. Display the product details of both Pie and Bear Claw.

select *
from products
where food='Pie'
union
select *
from products
where food='Bear Claw';

REM 10. Display the customers details who havent placed any orders.


select *
from customers
where cid in(select cid 
			 from customers
			 minus
			 select cid
			 from Receipts);
			 
REM 11. Display food with flavor common to Meringue and Tart

select food 
from products 
where flavor = ((select flavor 
				from products 
				where food='Meringue') 
				intersect
				(select flavor 
				 from products 
				 where food='Tart')) and food not in('Meringue', 'Tart');
			 
											 
