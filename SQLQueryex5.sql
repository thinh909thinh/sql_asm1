create database ex5 
USE ex5
GO
--> tạo bảng product(ds hàng)
CREATE TABLE product(
    productID int PRIMARY KEY,
    name  varchar(100),
    description  varchar(50),
	unit varchar,
    price money ,
    qty1 int ,
    status int
)
go
--> tạo bảng ds ng dùng 
CREATE TABLE custumer(
    custumerID int PRIMARY KEY,
    name  varchar(100),
    address  varchar(50),
    tel int ,

)
go
--> tạo bảng ds don hang order
CREATE TABLE orderlist (
    orderlistID int PRIMARY KEY,
	custumerID int,
    orderdate date,
    status  varchar(50),
)
go
--> tạo bảng chi tiet don hang
CREATE TABLE orderdentail  (
    orderlistID int ,
	 productID int,
    price2 money ,
    qty2 int ,
)
go
--> tạo khóa chính cho bảng orderdentail tạo thành từ 2 cột:
ALTER TABLE orderdentail
ALTER COLUMN orderlistID int NOT NULL;
ALTER TABLE orderdentail
ALTER COLUMN productID int NOT NULL;
ALTER TABLE orderdentail
ADD CONSTRAINT khoachinh4 PRIMARY KEY (orderlistID, productID);

-->ok
--> tạo khóa ngoại cho bảng orderlist để tham chiếu đến bảng custumer
ALTER TABLE orderlist
ADD FOREIGN KEY(custumerID) 
REFERENCES custumer (custumerID)
--> ok
--> tạo khóa ngoại cho bảng orderdentail để tham chiếu đến bảng orderlist
ALTER TABLE orderdentail
ADD FOREIGN KEY(orderlistID) 
REFERENCES orderlist (orderlistID)
--> ok
--> tạo khóa ngoại cho bảng orderdentail để tham chiếu đến bảng product
ALTER TABLE orderdentail
ADD FOREIGN KEY(productID) 
REFERENCES product (productID)
--> ok
--> đã tạo xong 4 bảng và link tới nhau
--> thêm value vào các bảng
--> bảng product :
insert into product(productID,name,description,price,qty1,status) values(101,'iphone','tonkho',1000,100,1)
insert into product(productID,name,description,price,qty1,status) values(102,'oppo','tonkho',1000,100,1)
insert into product(productID,name,description,price,qty1,status) values(103,'ss','tonkho',1000,100,1)
insert into product(productID,name,description,price,qty1,status) values(104,'iphone','tonkho',2000,100,1)
insert into product(productID,name,description,price,qty1,status) values(110,'oppo','tonkho',3000,100,1)
insert into product(productID,name,description,price,qty1,status) values(111,'ss','tonkho',4000,100,1)
select * from product
--> bảng ds ng dùng  custumer:
insert into custumer(custumerID,name,address,tel) values(1,'thinh','thanh hoa',0999999)
insert into custumer(custumerID,name,address,tel) values(2,'an','thanh hoa',098888)
insert into custumer(custumerID,name,address,tel) values(3,'linh','thanh hoa',0977777)
insert into custumer(custumerID,name,address,tel) values(4,'nguyen van an','indo',0999999)
select * from custumer
-->  bảng orderlist lưu ý  cột khóa ngoại custumerID link đến bảng custumer
insert into orderlist(orderlistID,custumerID,orderdate,status) values(1,3,'20201220',1)
insert into orderlist(orderlistID,custumerID,orderdate,status) values(2,2,'20211220',1)
insert into orderlist(orderlistID,custumerID,orderdate,status) values(3,3,'20221220',1)
insert into orderlist(orderlistID,custumerID,orderdate,status) values(4,1,'20191220',1)
insert into orderlist(orderlistID,custumerID,orderdate,status) values(5,4,'20181220',1)
--> thử th lỗi custumerID k tồn tại trong bảng custumer
insert into orderlist(orderlistID,custumerID,orderdate,status) values(5,6,'20191220',1)
--> ok lỗi!
--ok
-->-->  bảng Orderdentail  
--> lưu ý  cột khóa ngoại orderlistID link đến bảng orderlist
-->lưu ý  cột khóa ngoại productID link đến bảng product ,(qty2!=qty1:qty2 là số lượng hàng mua) (price2!=price:price2 là giá bán khi xuất hóa đơn,price :giá hiện tại  )
insert into orderdentail(orderlistID,productID,price2,qty2) values(2,102,900,1)
insert into orderdentail(orderlistID,productID,price2,qty2) values(3,111,1200,3)
insert into orderdentail(orderlistID,productID,price2,qty2) values(5,110,1500,3)
insert into orderdentail(orderlistID,productID,price2,qty2) values(6,110,1500,3)
--> thử th lỗi !orderlistID orderlistID không tồn tại trong bảng mẹ.
insert into orderdentail(orderlistID,orderlistID,price2,qty2) values(10,200,1200,3)
--> ok lỗi @@
--> kiem tra bảng
select * from product
select * from custumer
select * from orderlist
select * from orderdentail

--------------------------------------done------------------------------->
--------ds khách đã mua hàng---------------------
select custumer.custumerID ,custumer.name from custumer ,orderlist
where custumer.custumerID=orderlist.custumerID
------ok-----------
-----Liệt kê danh sách sản phẩm của của hàng----------
select productID, name,description from product
------ok----------
----------Liệt kê danh sách các đơn đặt hàng của cửa hàng.-----------
select orderlist.orderlistID,orderlist.orderdate,custumer.name from custumer ,orderlist
where custumer.custumerID=orderlist.custumerID
-----------Liệt kê danh sách khách hàng theo thứ thự alphabet.-------
Select * From product Order By productID Asc
---lộn bảng :)
Select * From custumer Order By custumerID Asc
---- lộn cột :)
---name mới đúng 
Select * From custumer Order By name Asc --ok--
------Liệt kê danh sách sản phẩm của cửa hàng theo thứ thự giá giảm dần DESC.---Asc 
Select * From product Order By price  DESC
------Liệt kê danh sách sản phẩm của cửa hàng theo thứ thự giá tăng dần .---Asc 
Select * From product Order By price  Asc 
---Liệt kê các sản phẩm mà khách hàng Nguyen Van An đã mua.----
select custumer.name,product.productID ,product.name from product,orderdentail,custumer,orderlist
where custumer.name='Nguyen Van An' and custumer.custumerID=orderlist.custumerID and 
orderlist.orderlistID=orderdentail.orderlistID and orderdentail.productID=product.productID
-----------------ok----------------------
-- Thay đổi ngày đặt hàng nhỏ hơn ngày hiện tại -- 
ALTER TABLE orderlist
ADD CONSTRAINT checkdate CHECK (orderdate < '20251010')
-------ok--------------
-- Thay đổi giá tiền từng mặt hàng là dương (>0) --
ALTER TABLE product
ADD CONSTRAINT checkgia CHECK (price > 0) 
----------check ----------
insert into product(productID,name,description,price,qty1,status) values(501,'iphones','tonkho',-200,100,1) ---loi---ok---
-- Thêm trường ngày xuất hiện trên thị trường của sản phẩm --
ALTER TABLE product
ADD AppearanceDay DATE-----------ok---------
-- Số khách hàng đã mua ở cửa hàng--
SELECT COUNT (custumerID) FROM orderlist WHERE Status = 1 ----- =5  ------
-- Số mặt hàng có trong cửa hàng --
SELECT COUNT (productID) FROM product --------- laf 6------
-- Tổng tiền từng đơn hàng !!!!!!!! -


