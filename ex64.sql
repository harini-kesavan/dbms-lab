
SQL> @Z:/ex64.sql;
SQL> REM **4. Write a stored function to display the customer name who ordered maximum for the
SQL> REM given food and flavor.
SQL> 
SQL> create or replace function get_Customer(fd in varchar2,fl in varchar2) return varchar2
  2  is
  3  	 ans varchar2(100);
  4  	 f_name varchar2(30);
  5  	 l_name varchar2(30);
  6  	 c number;
  7  	 cursor maxcust is
  8  	     select fname,lname
  9  	     from customers
 10  	     where cid in (select c.cid from products p
 11  		     join item_list i on(p.pid = i.item)
 12  		     join Receipts r on(r.rno = i.rno)
 13  		     join customers c on(r.cid = c.cid)
 14  		     where food = fd and flavor = fl
 15  		     group by c.cid
 16  		     having count(*) = (select max(count(*))
 17  				     from products p
 18  				     join item_list i on(p.pid = i.item)
 19  				     join receipts r on(r.rno = i.rno)
 20  				     join customers c on(r.cid = c.cid)
 21  				     where food = fd and flavor = fl
 22  				     group by c.cid));
 23    begin
 24  	 open maxcust;
 25  	 c:=0;
 26  	 fetch maxcust into f_name,l_name;
 27  	 while maxcust%FOUND loop
 28  	   if c = 0 then
 29  	     ans:=f_name || ' ' || l_name;
 30  	   else
 31  	     ans:=ans||','||f_name || ' ' || l_name;
 32  	   end if;
 33  	   c:=c+1;
 34  	   fetch maxcust into f_name,l_name;
 35  	   end loop;
 36  	 return ans;
 37  	 close maxcust;
 38    end;
 39    /

Function created.

SQL> 
SQL> declare
  2    food varchar2(30);
  3    flavor varchar2(30);
  4  begin
  5    food := '&food';
  6    flavor := '&flavor';
  7    dbms_output.put_line('The customer(s) who bought the maximum number of '|| to_char(flavor)||' '||to_char(food));
  8    dbms_output.put_line(to_char(get_Customer(food,flavor)) );
  9  end;
 10  /
Enter value for food: Tart
old   5:   food := '&food';
new   5:   food := 'Tart';
Enter value for flavor: Lemon
old   6:   flavor := '&flavor';
new   6:   flavor := 'Lemon';
The customer(s) who bought the maximum number of Lemon Tart                     
HELING RUPERT                                                                   

PL/SQL procedure successfully completed.

SQL> spool off;
