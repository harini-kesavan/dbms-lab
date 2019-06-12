


SQL> rem 1. The combination of Flavor and Food determines the product id. Hence, while
SQL> rem inserting a new instance into the Products relation, ensure that the same combination
SQL> rem of Flavor and Food is not already available.
SQL> 
SQL> create or replace trigger tr_unique_food
  2  before insert
  3  on products
  4  for each row
  5  declare
  6    pidp varchar2(30);
  7    cursor c1 is
  8     select pid
  9   from products
 10     where food = :new.food and flavor = :new.flavor;
 11  begin
 12    open c1;
 13    fetch c1 into pidp;
 14    if c1%found then
 15        RAISE_APPLICATION_ERROR( -20001, 'The Combination of Food and Flavor already exists' );
 16    end if;
 17    close c1;
 18  end;
 19  /

Trigger created.

SQL> savepoint a;

Savepoint created.

SQL> insert into products values('1-21-3','Chocolate','Cake',20.01);
insert into products values('1-21-3','Chocolate','Cake',20.01)
            *
ERROR at line 1:
ORA-20001: The Combination of Food and Flavor already exists 
ORA-06512: at "4046.TR_UNIQUE_FOOD", line 11 
ORA-04088: error during execution of trigger '4046.TR_UNIQUE_FOOD' 


SQL> insert into products values('1-21-4','Lemon','Eclair',10.21);
insert into products values('1-21-4','Lemon','Eclair',10.21)
            *
ERROR at line 1:
ORA-20001: The Combination of Food and Flavor already exists 
ORA-06512: at "4046.TR_UNIQUE_FOOD", line 11 
ORA-04088: error during execution of trigger '4046.TR_UNIQUE_FOOD' 


SQL> rollback to a;

Rollback complete.

SQL> 
SQL> rem 3. Implement the following constraints for Item_list relation:
SQL> 
SQL> rem a. A receipt can contain a maximum of five items only.
SQL> 
SQL> create or replace trigger tr_max_items
  2  before insert or update
  3  on item_list
  4  for each row
  5  declare
  6    counter number;
  7    cursor c1 is
  8     select count(*)
  9     from item_list
 10     where rno = :new.rno
 11     group by rno;
 12  begin
 13    open c1;
 14    fetch c1 into counter;
 15    if counter>=5 then
 16      RAISE_APPLICATION_ERROR( -20001, 'Can Order only 5 Items maximum' );
 17    end if;
 18    close c1;
 19  end;
 20  /

Trigger created.

SQL> 
SQL> savepoint s;

Savepoint created.

SQL> insert into receipts values(9999,'24-dec-1999',5);

1 row created.

SQL> insert into item_list values(9999,1,'26-8x10');

1 row created.

SQL> insert into item_list values(9999,2,'26-8x10');

1 row created.

SQL> insert into item_list values(9999,3,'90-APP-11');

1 row created.

SQL> insert into item_list values(9999,4,'70-LEM');

1 row created.

SQL> insert into item_list values(9999,5,'70-LEM');

1 row created.

SQL> insert into item_list values(9999,6,'70-LEM');
insert into item_list values(9999,6,'70-LEM')
            *
ERROR at line 1:
ORA-20001: Can Order only 5 Items maximum 
ORA-06512: at "4046.TR_MAX_ITEMS", line 12 
ORA-04088: error during execution of trigger '4046.TR_MAX_ITEMS' 


SQL> rollback to s;

Rollback complete.

SQL> 
SQL> rem b. A receipt should not allow an item to be purchased more than thrice.
SQL> 
SQL> create or replace trigger max_item
  2  before insert or update on item_list
  3  for each row
  4  declare
  5    counter number;
  6    cursor c1 is
  7     select count(*) from item_list
  8     where rno = :new.rno and item = :new.item
  9     group by (rno,item);
 10  begin
 11    open c1;
 12    fetch c1 into counter;
 13    if counter>=3 then
 14      RAISE_APPLICATION_ERROR( -20001, 'You have already bought this item 3 times ' );
 15    end if;
 16    close c1;
 17  end;
 18  /

Trigger created.

SQL> 
SQL> savepoint s1;

Savepoint created.

SQL> insert into receipts values(9999,'24-dec-1999',5);

1 row created.

SQL> insert into item_list values(9999,1,'26-8x10');

1 row created.

SQL> insert into item_list values(9999,2,'26-8x10');

1 row created.

SQL> insert into item_list values(9999,3,'26-8x10');

1 row created.

SQL> insert into item_list values(9999,4,'26-8x10');
insert into item_list values(9999,4,'26-8x10')
            *
ERROR at line 1:
ORA-20001: You have already bought this item 3 times 
ORA-06512: at "4046.MAX_ITEM", line 11 
ORA-04088: error during execution of trigger '4046.MAX_ITEM' 


SQL> rollback to s1;

Rollback complete.

SQL> spool off
