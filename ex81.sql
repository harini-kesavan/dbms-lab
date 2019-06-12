
SQL> REM **1. For the given receipt number, if there are no rows then display as “No order with the given receipt <number>”.
SQL> REM If the receipt contains more than one item, REM display as “The given receipt <number> contains more than one item”.
SQL> REM If the receipt contains single item, display as “The given receipt <number> contains exactly
SQL> REM one item”. Use predefined exception handling**
SQL> 
SQL> declare
  2   receiptnumber item_list.rno%type;
  3   counts_item number(4);
  4   it_item item_list.item%type;
  5   my_exception1 EXCEPTION;
  6  
  7   Begin
  8    receiptnumber :=&Receipt_Number;
  9  
 10    Select count(item) into counts_item
 11                  from item_list
 12                  where rno = receiptnumber group by rno;
 13  
 14    Select item into it_item
 15                  from item_list
 16                  where rno = receiptnumber;
 17  
 18    dbms_output.put_line('Receipt Number : '||  receiptnumber);
 19  
 20    if counts_item = 1 then
 21     RAISE my_exception1;
 22    end if;
 23  
 24   Exception
 25    WHEN no_data_found THEN
 26     dbms_output.put_line('Item Count : '||  counts_item);
 27           dbms_output.put_line('No Order with the given receipt number '||receiptnumber);
 28    WHEN too_many_rows THEN
 29     dbms_output.put_line('Item Count : '||  counts_item);
 30     dbms_output.put_line('The given receipt number ' || receiptnumber || ' contains more than one item ');
 31    WHEN my_exception1 THEN
 32     dbms_output.put_line('Item Count : '||  counts_item);
 33     dbms_output.put_line('The given receipt number ' || receiptnumber || ' contains exactly one item ');
 34  
 35   End;
 36  /
Enter value for receipt_number: 51991
old   8:   receiptnumber :=&Receipt_Number;
new   8:   receiptnumber :=51991;
Item Count : 8                                                                  
The given receipt number 51991 contains more than one item                      

PL/SQL procedure successfully completed.

SQL> /
Enter value for receipt_number: 70723
old   8:   receiptnumber :=&Receipt_Number;
new   8:   receiptnumber :=70723;
Receipt Number : 70723                                                          
Item Count : 1                                                                  
The given receipt number 70723 contains exactly one item                        

PL/SQL procedure successfully completed.

SQL> /
Enter value for receipt_number: 10000
old   8:   receiptnumber :=&Receipt_Number;
new   8:   receiptnumber :=10000;
Item Count :                                                                    
No Order with the given receipt number 10000                                    

PL/SQL procedure successfully completed.

SQL> spool off
