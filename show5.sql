SQL> REM 3. AN USER DESIRED TO BUY THE PRODUCT WITH THE SPECIFIC PRICE.
SQL> REM  ASK THE USER FOR A PRICE, FIND THE FOOD ITEM(S) THAT IS EQUAL OR CLOSEST TO THE DESIRED PRICE.
SQL> REM PRINT THE PRODUCT NUMBER, FOOD TYPE, FLAVOR AND PRICE.
SQL> REM ALSO PRINT THE NUMBER OF ITEMS THAT IS EQUAL OR CLOSEST TO THE DESIRED PRICE.
SQL> 
SQL> declare
  2  p products.price%type;
  3  pidp products.pid%type;
  4  flavorp products.flavor%type;
  5  foodp products.food%type;
  6  pricep products.price%type;
  7  rowcount number;
  8  begin
  9   p:=&p;
 10   declare
 11    cursor c_price is
 12    select pid, flavor, food, price
 13    from products
 14    where (abs(products.price-p))<=
 15     (select min(abs(products.price-p))
 16      from products);
 17   begin
 18    dbms_output.put_line ('PRODUCTID'|| rpad(' ',8,' ') ||'FLAVOR'|| rpad(' ',8,' ') ||'FOOD'|| rpad(' ',8,' ') ||'PRICE');
 19    dbms_output.put_line ('------------------------------------------------------------------');
 20    open c_price;
 21    loop
 22     fetch c_price into pidp, flavorp, foodp, pricep;
 23     exit when c_price%notfound;
 24     dbms_output.put_line (pidp|| rpad('  ',10,'  ') ||flavorp|| rpad('  ',9,'  ') ||foodp|| rpad('  ',8,'  ') ||pricep);
 25    end loop;
 26       dbms_output.put_line ('------------------------------------------------------------------');
 27    rowcount:=c_price%rowcount;
 28    dbms_output.put_line ('Product(s) found EQUAL/CLOSEST to given price: '||rowcount);
 29        close c_price;
 30   end;
 31  end;
 32  /
Enter value for p: 2.0
old   9:  p:=&p;
new   9:  p:=2.0;
PRODUCTID        FLAVOR        FOOD        PRICE                                
------------------------------------------------------------------              
51-BC          Almond         Bear Claw        1.95                             
------------------------------------------------------------------              
Product(s) found EQUAL/CLOSEST to given price: 1                                

PL/SQL procedure successfully completed.

SQL> /
Enter value for p: 3.25
old   9:  p:=&p;
new   9:  p:=3.25;
PRODUCTID        FLAVOR        FOOD        PRICE                                
------------------------------------------------------------------              
45-CH          Chocolate       Eclair      3.25                             
45-VA          Vanilla         Eclair      3.25                               
90-APP-11      Apple           Tart        3.25                               
90-APR-PF      Apricot         Tart        3.25                             
90-BER-11      Berry           Tart        3.25                               
90-BLK-PF      Blackberry      Tart        3.25                          
90-BLU-11      Blueberry       Tart        3.25                           
90-CHR-11      Cherry          Tart        3.25                              
90-LEM-11      Lemon           Tart        3.25                               
------------------------------------------------------------------              
Product(s) found EQUAL/CLOSEST to given price: 9                                

PL/SQL procedure successfully completed.

SQL> rem 4.Display the customer name along with the details of item and its quantity ordered for
SQL> rem the given order number. Also calculate the total quantity ordered as shown below:
SQL> declare
  2    counter number(2);
  3    rid receipts.rno%TYPE;
  4    food products.food%TYPE;
  5    flavor products.flavor%TYPE;
  6    fname customers.fname%TYPE;
  7    lname customers.lname%TYPE;
  8    qty number;
  9  
 10    cursor g_name is
 11    select c.fname,c.lname from receipts r
 12    join customers c on(r.cid = c.cid)
 13    where r.rno = rid;
 14  
 15    cursor c1 is
 16    select p.food,p.flavor,count(*) from receipts r
 17    join customers c on(r.cid = c.cid)
 18    join item_list i on(i.rno = r.rno)
 19    join products p on(p.pid = i.item)
 20    where r.rno = rid
 21    group by (p.food,p.flavor);
 22  begin
 23    rid:=&rno;
 24    counter:=0;
 25    open g_name;
 26    fetch g_name into fname,lname;
 27    dbms_output.put_line('Customer Name: '||fname||' '||lname);
 28    close g_name;
 29  
 30    dbms_output.put_line('FOOD        FLAVOR    QTY');
 31    open c1;
 32    fetch c1 into food,flavor,qty;
 33    while c1%Found loop
 34      counter:=counter+qty;
 35      dbms_output.put_line(food || '       ' || flavor || '    ' || to_char(qty));
 36      fetch c1 into food,flavor,qty;
 37      end loop;
 38    close c1;
 39    dbms_output.put_line('Total Quantity = '|| to_char(counter));
 40  end;
 41  /
Enter value for rno: 76667
old  23:   rid:=&rno;
new  23:   rid:=76667;
Customer Name: CALLENDAR  DAVID                                                 
FOOD        FLAVOR    QTY                                                       
Cookie       Gongolais    1                                                     
Tart       Lemon    1                                                           
Total Quantity = 2                                                              

PL/SQL procedure successfully completed.

SQL> spool off;
