# MySQL 必知必会



## 用正则表达式进行搜索

```mysql
SELECT prod_name FROM products WHERE prod_name REGEXP '1000';

# 区分大小写
SELECT prod_name FROM products WHERE prod_name REGEXP BINARY 'JetPack .000';
```



## 创建计算字段

```mysql
# 删除数据右边的空格
select RTrim(vend_name) from vendors;
```



## 使用子查询

```mysql
# 作为计算字段使用子查询
select cust_name, 
			 cust_state, 
	     (select count(*) 
        from orders 
        where orders.cust_id = customers.cust_id) as order_num 
from customers
order by cust_name;
```



## 全文搜索

```mysql
# 创建全文索引
CREATE TABLE `productnotes` (
  `note_id` int(11) NOT NULL AUTO_INCREMENT,
  `prod_id` char(10) NOT NULL,
  `note_date` datetime NOT NULL,
  `note_text` text,
  PRIMARY KEY (`note_id`),
  FULLTEXT KEY `note_text` (`note_text`)
);

# 全文搜索
select note_text from productnotes where match(note_text) against('rabbit');
```



# 插入数据

```mysql
# 插入检索出的数据
insert into customers_new(cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country, cust_contact, cust_email)
select cust_name,
       cust_address,
       cust_city,
       cust_state,
       cust_zip,
       cust_country,
       cust_contact,
       cust_email
from customers;
```

