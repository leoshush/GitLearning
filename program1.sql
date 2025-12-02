create database project1;
use project1;

create table Customer(
 customerId  int auto_increment primary key,
 customerName varchar(30) not null,
 address varchar(50) not null,
 phoneNo long not null,
 emailId varchar(50) unique 
);

insert into Customer values 
(1, 'Ravi Kumar', '123 MG Road', '9876543210', 'ravi@email.com'),
(2, 'Priya Singh', '45 Park Avenue', '9123456789', 'priya@email.com'),
(3, 'John Doe', '78 Lake View', '9988776655', 'john@email.com'),
(4, 'Anil Mehra', '56 Hill Road', '9001122334', 'anil@email.com'),
(5, 'Sunita Rao', '89 River Street', '9112233445', 'sunita@email.com'),
(6, 'Meena Patel', '12 Green Lane', '9223344556', 'meena@email.com'),
(7, 'Rajesh Shah', '34 Blue Street', '9334455667', 'rajesh@email.com'),
(8, 'Kavita Joshi', '67 Red Road', '9445566778', 'kavita@email.com'),
(9, 'Amit Verma', '90 White Field', '9556677889', 'amit@email.com'),
(10, 'Neha Gupta', '21 Yellow Lane', '9667788990', 'neha@email.com');
insert into Customer values
(11, 'abhishek sharma', '36 New block', '9892788990', 'abhi@email.com');



create table Metertable(
  meterId int primary key,
  customerId int ,
  installDate Date not null,
  lastreadDate Date not null,
  foreign key (customerId) references Customer(customerId) on delete cascade
);
select * from Metertable;
insert into Metertable values(101, 1, '2024-01-15', '2024-03-01'),
(102, 2, '2024-02-10', '2024-03-05'),
(103, 3, '2023-12-20', '2024-03-03'),
(104, 4, '2024-01-25', '2024-03-02'),
(105, 5, '2024-02-15', '2024-03-04'),
(106, 6, '2024-03-01', '2024-03-06'),
(107, 7, '2024-01-10', '2024-03-01'),
(108, 8, '2024-02-20', '2024-03-05'),
(109, 9, '2024-01-30', '2024-03-03'),
(110, 10, '2024-03-02', '2024-03-06');
insert into Metertable values(111,11,'2022-09-12','2023-01-27');

create table electricusagetable(
   usageId int primary key,
   meterId int,
   usageUnit int check (usageUnit>0),
   readingDate date not null,
   foreign key (meterId) references Metertable(meterId) on delete cascade
);

insert into electricusagetable values (201, 101,150,'2024-03-01'),
(202, 102, 220, '2024-03-05'),
(203, 103, 180, '2024-03-03'),
(204, 104, 210, '2024-03-02' ),
(205, 105, 90, '2024-03-04'),
(206, 106, 250,'2024-03-06'),
(207, 107, 130,'2024-03-01'),
(208, 108, 300,'2024-03-05'),
(209, 109, 170,'2024-03-03'),
(210, 110, 200,'2024-03-06');
insert into electricusagetable values (211, 101,170,'2025-03-01');
insert into electricusagetable values (212, 101,170,'2025-06-01');



create table billtable(
  billId int primary key,
  meterId int,
  billDate date not null,
  amountDue int check (amountDue>0),
  dueDate date not null,
  paid bool not null default 0,
  foreign key (meterId) references Metertable(meterId) on delete cascade
);
insert into billtable values
(301, 101, '2024-03-02', 1200, '2024-03-20', 0),
(302, 102, '2024-03-06', 1800, '2024-03-25', 1),
(303, 103, '2024-03-04', 1500, '2024-03-22', 0),
(304, 104, '2024-03-03', 1700, '2024-03-21', 1),
(305, 105, '2024-03-05', 800, '2024-03-23', 0),
(306, 106, '2024-03-07', 2000, '2024-03-26', 1),
(307, 107, '2024-03-02', 1100, '2024-03-20', 0),
(308, 108, '2024-03-06', 2200, '2024-03-25', 1),
(309, 109, '2024-03-04', 1300, '2024-03-22', 0),
(310, 110, '2024-03-07', 1600, '2024-03-26', 1);

create table payment(
  paymentId int primary key,
  billId int ,
  paymentDate date not null,
  amountPaid int check (amountPaid>=0),
  foreign key (billId) references billtable(billId) on delete cascade
);

insert into payment values(401, 302, '2024-03-10', 1800),
(402, 304, '2024-03-12', 1700),
(403, 306, '2024-03-15', 2000),
(404, 308, '2024-03-18', 2200),
(405, 310, '2024-03-20', 1600),
(406, 302, '2024-03-11', 0),
(407, 304, '2024-03-13', 0),
(408, 306, '2024-03-16', 0),
(409, 308, '2024-03-19', 0),
(410, 310, '2024-03-21', 0);


select * from Customer;
select * from Metertable;
select * from electricusagetable;
select * from billtable;
select * from payment;

  select sum(usageUnit) totalUsage ,meterId from electricusagetable  group by meterId having sum(usageUnit)>200;

 select a.customerName,b.meterId,c.amountDue from Customer a inner join Metertable b on (a.customerId=b.customerId) inner join billtable c on (b.meterId = c.meterId) where c.paid =0  order by amountDue desc ;

  select billId , if(paid=1,"bill paid","bill not paid") paymentstatus ,billDate from billtable order by billDate asc ; 

 select a.customerName ,a.customerId, b.meterId ,b.installDate from Customer a join Metertable b on (a.customerId = b.customerId) where b.installDate > '2023-12-31'; 

 select  a.meterId , a.lastreadDate, sum(b.usageUnit)  totalUsage  from Metertable a inner join electricusagetable b on (a.meterId = b.meterId) group by meterId order by sum(b.usageUnit) desc; 

-- trigger to change the lastreading date whenever we add new row for a particular meter -- 

delimiter $$
CREATE TRIGGER update_lastreadDate
AFTER INSERT ON electricusagetable
FOR EACH ROW
BEGIN
    UPDATE Metertable
    SET lastreadDate = NEW.readingDate
    WHERE meterId = NEW.meterId;
END$$
DELIMITER ;


-- trigger to update the bill amountDue and paid flag based on the payment made 

DELIMITER $$

CREATE TRIGGER trg_payment_after_insert
AFTER INSERT ON payment
FOR EACH ROW
BEGIN
    UPDATE billtable
    SET 
        amountDue = CASE 
                      WHEN amountDue - NEW.amountPaid <= 0 THEN 0
                      ELSE amountDue - NEW.amountPaid
                    END,
        paid = CASE 
                 WHEN amountDue - NEW.amountPaid <= 0 THEN 1
                 ELSE 0
               END
    WHERE billId = NEW.billId;
END$$
DELIMITER ;

