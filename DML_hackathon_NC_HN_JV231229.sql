use quanlybanhang;
#Truy vấn dữ liệu
# 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
select name Ten, email, phone SoDienThoai, address DiaChi
from customers;

# 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện
# thoại và địa chỉ khách hàng).
select name Ten, phone SDT, address DiaChi
from orders O
         join customers C on O.customerId = C.customerId
where month(orderDate) = 3
  and year(orderDate) = 2023;

# 3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm
# tháng và tổng doanh thu ).
select month(orderDate) Thang, sum(totalAmount) TongDoanhThu
from orders
where year(orderDate) = 2023
group by month(orderDate)
order by month(orderDate);

# 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách
# hàng, địa chỉ , email và số điên thoại).
select distinct name TenKH, address DiaChi, email, phone SDT
from orders O
         join customers C on O.customerId = C.customerId
where C.customerId not in (select C.customerId
                           from orders O
                                    join customers C on O.customerId = C.customerId
                           where month(orderDate) = 2
                             and year(orderDate) = 2023);

# 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
# sản phẩm, tên sản phẩm và số lượng bán ra).
select P.productId MaSP, P.name TenSP, sum(quantity) SoLuongBanRa
from ordersdetail OD
         join orders O on OD.orderId = O.orderId
         join products P on OD.productId = P.productId
where month(orderDate) = 3
  and year(orderDate) = 2023
group by P.productId, P.name;

# 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
# tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu).
select C.customerId MaKH, C.name TenKH, sum(totalAmount) MucChiTieu
from orders O
         join customers C on O.customerId = C.customerId
where year(orderDate) = 2023
group by C.customerId
order by MucChiTieu desc;

# 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
# tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) .
select C.name TenNguoiMua, totalAmount TongTien, orderDate NgayTaoHoaDon, sum(quantity) TongSLSP
from ordersdetail OD
         join orders O on OD.orderId = O.orderId
         join customers C on O.customerId = C.customerId
where quantity >= 5
group by C.name, totalAmount, orderDate;

#Tạo View, Procedure
# 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
# tiền và ngày tạo hoá đơn .
create view V_order_Info as
select C.name TenKH, C.phone SDT, C.address DiaChi, totalAmount TongTien, orderDate NgayTaoHoaDon
from orders O
         join customers C on O.customerId = C.customerId;
select *
from V_order_Info;

# 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
# số đơn đã đặt.
create view V_customer_info as
select C.name TenKH, C.address DiaChiKH, C.phone SDT, count(orderId) TongDonDaDat
from orders O
         join customers C on O.customerId = C.customerId
group by C.customerId;

select *
from V_customer_info;

# 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
# bán ra của mỗi sản phẩm.
create view V_product_info as
select P.name TenSP, P.description Mota, P.price Gia, sum(quantity) TongSLBR
from ordersdetail OD
         join products P on OD.productId = P.productId
group by P.productId;
select *
from V_product_info;

# 4. Đánh Index cho trường `phone` và `email` của bảng Customer.
create index idx_customer_phone on customers (phone);
create index idx_customer_email on customers (email);

# 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.
delimiter $$
create procedure PROC_CUS_INFO(id_IN varchar(4))
begin
    select *
    from customers
    where customerId = id_IN;
end $$;

call PROC_CUS_INFO('C001');

# 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm.
delimiter $$
create procedure PROC_GET_INFO_PRODUCTS()
begin
    select * from products;
end $$;
call PROC_GET_INFO_PRODUCTS();

# 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng.
delimiter $$
create procedure DISPLAY_ORDER_BY_ID(id_IN varchar(4))
begin
    select * from orders where customerId = id_IN;
end $$;
call DISPLAY_ORDER_BY_ID('C001');

# 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
# tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo.
delimiter $$
create procedure PROC_CREATE_ORDER(customerId_IN varchar(4), totalAmount_IN double, orderDate_IN date,
                                   orderId_IN varchar(4))
begin
    insert into orders(orderId, customerId, orderDate, totalAmount)
    values (orderId_IN, customerId_IN, orderDate_IN, totalAmount_IN);
    select orderId_IN;
end $$;
call PROC_CREATE_ORDER('C001', 2999999, '2024-05-01', 'H011');

# 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
# thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc.
delimiter $$
create procedure PROC_GET_TOTAL_SALE(start_date_IN date, end_date_IN date)
begin
    select P.productId MaSP, P.name TenSP, sum(quantity) SoLuongBanRa
    from ordersdetail OD
             join products P on OD.productId = P.productId
             join orders O on OD.orderId = O.orderId
    where orderDate between start_date_IN and end_date_IN
    group by P.productId, P.name;
end $$;

call PROC_GET_TOTAL_SALE('2022-09-09', '2023-11-11');

# 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
# giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê.
delimiter $$
create procedure PROC_GET_TOTAL_SALE_IN_MONTH(month_IN int, year_IN int)
begin
    select P.name TenSP, sum(quantity) SLBanRa
    from products P
             join ordersdetail OD on P.productId = OD.productId
             join orders O on OD.orderId = O.orderId
    where year(orderDate) = year_IN and month(orderDate) = month_IN
    group by name
    order by sum(quantity) desc ;
end $$;
delimiter $$;
call PROC_GET_TOTAL_SALE_IN_MONTH(3,2023)

