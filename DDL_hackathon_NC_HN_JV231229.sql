use quanlybanhang;
#Tạo bảng
create table if not exists Customers
(
    customerId varchar(4) primary key not null,
    name       varchar(100)           not null,
    email      varchar(100)           not null unique,
    phone      varchar(25)            not null unique,
    address    varchar(255)           not null
);
create table if not exists Orders
(
    orderId     varchar(4) primary key not null,
    customerId  varchar(4)             not null,
    orderDate   date                   not null,
    totalAmount double                 not null
);
create table if not exists Products
(
    productId   varchar(4) primary key not null,
    name        varchar(255)           not null,
    description text,
    price       double                 not null,
    status      bit(1) default 1       not null
);
create table if not exists ordersDetail
(
    orderId   varchar(4) not null,
    productId varchar(4) not null,
    primary key (orderId, productId),
    quantity  int(11)    not null,
    price     double     not null
);

#Thêm khóa ngoại
alter table Orders
    add constraint order_customerId_fk foreign key (customerId) references Customers (customerId);
alter table ordersDetail
    add constraint OD_orderId_fk foreign key (orderId) references Orders (orderId),
    add constraint OD_productId_fk foreign key (productId) references Products (productId);

#Thêm dữ liệu
insert into customers(customerId, name, email, phone, address)
values ('C001', 'Nguyễn Hùng Mạnh', 'manhnt@gmail.com', '94756322', 'Cầu Giấy, Hà Nội'),
       ('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '9475926', 'Ba Vì, Hà Nội'),
       ('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '90472574', 'Mộc Châu, Sơn La'),
       ('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '94635365', 'Vinh, Nghệ An'),
       ('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989735624', 'Hai Bà Trưng, Hà Nội');

insert into Products(productId, name, description, price)
values ('P001', 'Iphone 13 ProMax', 'Bản 512GB, xanh lá', 22999999),
       ('P002', 'Dell Vostro V3510', 'Core i5, RAM GB', 14999999),
       ('P003', 'Macbook Pro M2', '8CPU 10GPU 8GB 256GB', 28999999),
       ('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 18999999),
       ('P005', 'Airpods 2 2022', 'Spatial Audio', 4090000);

insert into orders(orderId, customerId, orderDate, totalAmount)
values ('H001', 'C001', '2023-02-22', 52999997),
       ('H002', 'C001', '2023-03-11', 80999997),
       ('H003', 'C002', '2023-01-22', 54359998),
       ('H004', 'C003', '2023-03-14', 102999995),
       ('H005', 'C003', '2022-03-12', 80999997),
       ('H006', 'C004', '2023-02-01', 110449994),
       ('H007', 'C004', '2023-03-29', 79999996),
       ('H008', 'C005', '2023-02-14', 29999998),
       ('H009', 'C005', '2023-01-10', 28999999),
       ('H010', 'C005', '2023-04-01', 149999994);

insert into ordersDetail(orderId, productId, price,quantity)
values('H001', 'P002', 14999999, 1),
      ('H001', 'P004', 18999999, 2),
      ('H002', 'P001', 22999999, 1),
      ('H002', 'P003', 28999999, 2),
      ('H003', 'P004', 18999999, 2),
      ('H003', 'P005', 4090000, 4),
      ('H004', 'P002', 14999999, 3),
      ('H004', 'P003', 28999999, 2),
      ('H005', 'P001', 22999999, 1),
      ('H005', 'P003', 28999999, 2),
      ('H006', 'P005', 4090000, 5),
      ('H006', 'P002', 14999999, 6),
      ('H007', 'P004', 18999999, 3),
      ('H007', 'P001', 22999999, 1),
      ('H008', 'P002', 14999999, 2),
      ('H009', 'P003', 28999999, 1),
      ('H010', 'P003', 28999999, 2),
      ('H010', 'P001', 22999999, 4);

