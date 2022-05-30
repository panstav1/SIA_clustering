DECLARE top_cust_number INT64 DEFAULT 10;

--SET ...

WITH orders_per_city AS
  -- Step 1: Get count of orders and distinct users per city
  (SELECT city,
          count(order_id) orders,
          count(DISTINCT user_id) dst_users
   -- main source table. rename to the real name if changed
   FROM `efood2022-351411.main_assessment.orders`
   GROUP BY city)
SELECT topX_tbl.city,
       topXordersum/orders order_10perc,
       dst_users
FROM
  -- Step 3: Get only the 10 first user_ids and compute their contribution through sum
  (SELECT city,
          sum(orders) topXordersum
   FROM
   -- Step 2: Get count of orders and row number of each user id with order in orders 
     (SELECT city,
             user_id,
             count(order_id) orders,
             ROW_NUMBER() OVER (PARTITION BY city
                                ORDER BY count(order_id) DESC) AS seqnum,
      -- main source table. rename to the real name if changed
      FROM `efood2022-351411.main_assessment.orders`
      GROUP BY city,
               user_id)
   WHERE seqnum <= top_cust_number
   GROUP BY city) topX_tbl
-- Step 4: Inner join to fetch the distinct users also, so as to check if they are below 10 users in city (so that not including the results)
INNER JOIN orders_per_city ON orders_per_city.city = topX_tbl.city
ORDER BY orders_per_city.dst_users DESC