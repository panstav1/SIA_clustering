DECLARE min_orders_per_city INT64 DEFAULT 1000;
DECLARE min_orders_cust_freq INT64 DEFAULT 3;

--SET ...

with tbl_above_1korders as
-- Step 1: compute orders per city to filter above 1k orders and cluster the Breakfast cuisine
  (select *,
          case
              when cuisine != "Breakfast" then "efood_Total"
              else cuisine
          end as updated_cuisine,
          count(order_id) over (partition by city) as city_orders
	-- this might vary, it is the source tbl
   from `efood2022-351411.main_assessment.orders`),
     orders_above_x_tbl as
	 -- Step 2: filter out < 1k order cities and get customers above 3 
  (select city,
          updated_cuisine,
          count(order_above_3_tbl.orders_above_3) cust_above_3
   from
     (select city,
             updated_cuisine,
             user_id,
             count(order_id) orders_above_3
      from tbl_above_1korders
      where tbl_above_1korders.city_orders > min_orders_per_city
      group by city,
               updated_cuisine,
               user_id
      having orders_above_3 > min_orders_cust_freq) order_above_3_tbl
   group by city,
            updated_cuisine)
	-- Step 5: Fetch only desired results in correct order
select city,
       amount_Breakfast,
       amount_efood_Total,
       frequency_Breakfast,
       frequency_efood_Total,
       users3freq_per_Breakfast,
       users3freq_per_efood_Total
from
  (select main_tbl.city,
          main_tbl.updated_cuisine,
          main_tbl.amount,
          main_tbl.orders,
          orders_above_x_tbl.cust_above_3/main_tbl.num_users users3freq_per,
          main_tbl.frequency
   from
   -- Step 3: Get avg amount and several attributes into main table
     (select city,
             updated_cuisine,
             avg(amount) amount,
             count(distinct user_id) num_users,
             count(distinct order_id) orders,
             count(distinct order_id)/count(distinct user_id) frequency,
      from tbl_above_1korders
      group by city,
               updated_cuisine) main_tbl
   -- Step 4: Inner join on main table with info from the customers above 3 orders and pivot to create 
   -- each column for each city
   inner join orders_above_x_tbl on orders_above_x_tbl.city = main_tbl.city
   and orders_above_x_tbl.updated_cuisine = main_tbl.updated_cuisine) PIVOT (sum(orders) as orders, sum(amount) as amount, sum(frequency) as frequency, sum(users3freq_per) as users3freq_per
                                                                              for updated_cuisine IN ('Breakfast', "efood_Total"))
-- Step 6: Order with breakfast orders and limit 5 first
order by orders_Breakfast desc
limit 5;
