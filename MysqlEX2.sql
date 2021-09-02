-- 고객의 지불정보를 총지불금액 내림차순, 다음과 같이 출력하시오
-- 고객의 customer_id, first_name, last_name, 총지불금액, 고객의 주소 address, address2, district, city, country

-- select CS.customer_id, CS.first_name, CS.last_name,sum(PA.amount), 
--        AD.address, AD.address2, AD.district, CT.city, CU.country	   
-- from payment PA join customer CS on PA.customer_id = CS.customer_id
-- join address AD on AD.address_id = CS.address_id
-- join city CT on CT.city_id = AD.city_id
-- join country CU on CT.country_id = CU.country_id
-- group by CS.customer_id, CS.first_name, 
-- 	     CS.last_name,AD.address, AD.address2, AD.district, CT.city, CU.country
-- order by sum(PA.amount) asc;


select CS.customer_id, CS.first_name, CS.last_name, 
	sum(PM.amount), AD.address, AD.address2, AD.district
	, CT.city, CU.country
from payment PM join customer CS 
	on PM.customer_id = CS.customer_id
	join address AD on CS.address_id = AD.address_id
	join city CT on AD.city_id = CT.city_id
	join country CU on CT.country_id = CU.country_id
group by CS.customer_id, CS.first_name, CS.last_name, 
	AD.address, AD.address2, AD.district, CT.city, CU.country
order by sum(PM.amount) desc;

-- 14. 총 지불 금액별 고객 등급을 출력하고자 한다. 등급 구분과 출력 컬럼은 다음과 같다.(case 문 사용)
-- 'A' : 총 지불금액이 200 이상
-- 'B' : 총 지불금액이 200 미만 100 이상
-- 'C' : 총 지불금액이 100 미만 고객
-- 고객의 customer_id, firs_name, last_name, 총 지불금액, 등급
-- 출력 순서는 총 지불금액이 많은 고객부터 출력

select sum(PA.amount) > 200 as 'A', sum(PA.amount) < 199 as 'B', sum(PA.amount) < 99 as 'C', 
	   CS.customer_id, CS.first_name, CS.last_name, sum(PA.amount), FL.rationg
from payment PA join customer CS on PA.customer_id = CS.customer_id
join rental RT on RT.rental_id = PA.rental_id
join inventory IV on IV.inventory_id = RT.inventory_id
join film FL on IV.film_id = FL.film_id
group by CS.customer_id, CS.first_name, CS.last_name,FL.rationg 
order by sum(PA.amount) > 200 as 'A', sum(PA.amount) < 199 as 'B', 
         sum(PA.amount) < 99 as 'C',sum(PA.amount), sum(PA.amount) desc
         



         
         
--  15. DVD 대여 후 아직 반납하지 않은 고객정보를 다음의 정보로 출력한다.
-- 영화타이틀, 인벤토리ID, 매장ID, 고객의 first_name, last_name, 대여일자, 고객등급  

select FL.title, IV.inventory_id, ST.store_id, CS.first_name, CS.last_name
	   RT.rental_date,CS.customer_id
from rental RT join inventory IV on IV.rental_id = RT.inventory_id
join customer CS on CS.customer_id = RT.customer_id
join film FL on IV.film_id = FL.film_id
join store ST on IV.store_id = ST.store_id
where RT.return_date is null

select FL.title, IV.inventory_id, IV.store_id, CS.first_name, CS.last_name
, RT.rental_date, case when (sum(PM.amount) >= 200) then 'A'
	when (sum(PM.amount) >= 100) then 'B'
                    else 'C' end as customer_grade
from rental RT join customer CS on RT.customer_id = CS.customer_id
join inventory IV on RT.inventory_id = IV.inventory_id
join film FL on IV.film_id = FL.film_id
join store ST on IV.store_id = ST.store_id
join payment PM on CS.customer_id = PM.customer_id
where RT.return_date is null
group by FL.title, IV.inventory_id, IV.store_id, CS.first_name, CS.last_name
, RT.rental_date;



-- 16. '2005-08-01' 부터 '2005-08-15' 사이,
-- Canada, Alberta 주에서 대여한 영화의 타이틀 정보를 아래와 같이 출력하시오
-- 대여일, 영화 타이틀, 인벤토리ID, 매장ID, 매장 전체 주소

select RT.rental_date, FL.title, IV.inventory_id, IV.store_id, AD.address, AD.address2, AD.district, CT.city, CU.country
from rental RT join inventory IV on RT.inventory_id = IV.inventory_id
join store ST on IV.store_id = ST.store_id
join address AD on ST.address_id = AD.address_id
join city CT on AD.city_id = CT.city_id
join country CU on CT.country_id = CU.country_id
join film FL on IV.film_id = FL.film_id
where rental_date between '2005-08-01' and '2005-08-15'
and AD.district = 'Alberta'
and CU.country = 'Canada';

-- 17. 도시별 'Horror' 영화 대여정보를 알고자 한다.
-- 도시와 대여수를 출력하라.
-- 대여수 내림차순, 도시명 오름차순으로 정렬하시오

select CT.city, count(FL.title)
from film FL join film_category FC on FL.film_id = FC.film_id
join category CG on FC.category_id = CG.category_id
join inventory IV on FL.film_id = IV.film_id
join rental RT on IV.inventory_id = RT.inventory_id
join customer CS on RT.customer_id = CS.customer_id
join address AD on CS.address_id = AD.address_id
join city CT on AD.city_id = CT.city_id
join country CU on CT.country_id = CU.country_id
where CG.name = 'Horror'
group by CT.city
order by count(FL.title) desc, CT.city;




-- 18. 대여된 영화 중 대여기간이 연체된 건을 다음의 정보로 조회하시오.
-- 영화타이틀. inventory_id, 대여일, 반납일, 기준대여기간, 실제대여기간
-- ** 아직 반납이 되지 않은 경우, 실제대여기간 컬럼에 'Unknown' 출력



