SHOW DATABASES;
-- 데이터 베이스 월드의 테이블 조회

show table status;
-- 시티 테이블에 무슨 열이 있는지 확인

describe city;
-- desc = 테이블 정보보기
desc country;
desc countrylanguage;

-- select .. from
-- 요구하는 데이터를 가져오는 구문
-- 일반적으로 가장 많이 사용되는 구문
-- 데이터 베이스 내 테이블에서 원하는 정보 추출
-- 셀렉트의 구문 형식  	select_ expr
-- 					from table_references
-- 					where_condition
--                  group by{col_name | expr | position}
--                  having where_condition  --	 				order by{col_name | expr | position}

select * from city;  
-- 시티 전체 데이터보기

-- select 열이름
-- 테이블에서 필요로하는 열만 가져오기 가능
-- 여러개의 열을 가져오고 싶을 때는 콤마로 구분
-- 열 이름의 순서는 출력하고 싶은 순서대로 배열
	
select name, Population from city  -- 도시의 이름과 인구만 보겠다

-- 기본적인 where절 
-- 조회하는 결과에 특정한 조건으로 원하는 데이터만 보고싶을때 사용
-- select 필드이름 from 테이블 이름 where 조건식;

where  Population <= 80000 -- 인구가 80000이상인 곳만 보기
and population > 70000; -- 관계연산자를 사용하여 인구 80000과 70000사이의 도시를 볼수있다
-- where  Population between 70000 and 80000 위와 같은 의미


-- 한국에 있는 도시만 보기
select * from city where countrycode = 'KOR'
and population >= 1000000; -- 한국의 인구수가 백만 이상인 도시만 보기

-- 이산적인 값의 조건에서는 IN()사용가능
select * from city where name in('seoul', 'new york','tokyo'); -- 세개의 나라에 대해서만 보고싶을때
select * from city where CountryCode in('KOR', 'USA','JPN'); -- 세개의 나라의 도시에 대해서만 보고싶을때

-- 문자열의 내용 검색하기 위해 like 연산자사용
-- 문자 뒤에 %-무엇이든 (%)허용
-- 한글자와 매치하기 위해서는 '_' 사용
select * from city where CountryCode like 'ko_'; -- ko_와 매치되는 정보 출력
select * from city where name like 'tel%'; -- tel 뒤에 무엇이든 허용 됨 tel들어간 정보 출력

-- subquery 쿼리문안에 쿼리문이 들어있는 것(서브쿼리의 결과가 둘 이상이 되면 에러 발생)
select * from city where CountryCode = ( select CountryCode from city where name = 'seoul'); -- 서울이라는 도시이름을 가진 나라 코드를 출력


-- 서브쿼리의 여러개의 결과 중 한가지만 만족해도 가능
-- some은 any와 동일한 의미로 사용
-- =any 구문은 IN 과 동일한 의미
select * from city where Population > any ( select Population from city where District = 'new york');
 
-- 결과가 출력되는 순서를 조절하는 구문
-- 기본적으로 오름차순 ascending정렬
-- asc(오름차순)는 default이므로 생략가능 
select * from city order by Population asc; -- 인구수가 가장 낮은순에서 높은순으로 출력(asc생략가능)

select * from city order by Population desc; -- 인구수가 가장 높은순에서 낮은순으로 출력
-- 내림차순 descending으로 정렬(열이름 뒤에 desc적어 줄것)

-- order by 구문을 혼합해서 사용하는 구문도 가능
select * from city order by countrycode asc, Population desc;

-- 인구수로 내림차순하여 한국에 있는 도시보기
select * from city where countrycode = 'KOR' order by Population desc;

-- 국가 면적크기로 내림차순하여 나라보기
select * from country order by SurfaceArea desc;


-- distinct
-- 중복되는 것은 제외하고 1개씩만 보여주며 출력
select distinct countrycode from city;

-- limit
-- 출력개수를 제한
-- 상위 N개만 출력하는 'limit'구문
select * from city order by Population desc limit 10; -- 상위10개에 대한 인구수 내림차순 결과 출력


-- group by 
-- 그룹으로 묶어주는 역할
-- 집계함수 aggregate function를 함께 사용
-- avg():평균
-- min():최소
-- max():최대
-- count():행의 개수
-- count(distinct):중복 제외된 행의 개수
-- stdev():표준편차
-- variance():분산
-- 효율적인 데이터 그룹화 grouping
-- 읽기좋게 하기 위해 별칭사용 alias
select countrycode, max(population) from city group by CountryCode; -- 코드를 그룹으로 묶어준다(인구수가 가장 큰 도시만)

-- 도시는 몇개인가 
-- lab
select count(*) from city;
-- city table의 전체의 개수를 구하면 도시가몇개인지 나온다
select avg(population) from city;
-- 도시들의 평균 인구수

--  having -> where과 비슷한 개념으로 조건 제한 
-- 집계함수에 대해서 조건 제한하는 편리한 개념
-- having 절은 반드시 group by절 다음에 나와야 한다
select countrycode, max(population) from city group by CountryCode having max(population) > 8000000; -- 인구수가 팔백만 초과된 것만 그룹바이 형태로출력alter

-- rollup
-- 총합 또는 중간합계가 필요한 경우 사용
-- group by 절과 함께 withrollup문 사용
select countrycode , name, sum(population) from city group by CountryCode, name with rollup;
-- 같은나라의 각 도시 인구합계 중간값 출력

-- join( 데이터베이스 내의 여러 테이블에서 가져온 레코드를 조합하여 하나의 테이블이나 결과 집합으로 표현
select * from city join country on city.CountryCode = country.code; -- 시티와 나라 두개의 테이블이 합쳐지려면 조건이 있어야함(같은 국가코드끼리 조인한 값 출력)

select * from city 
join country on city.CountryCode = country.code
join countrylanguage on city.CountryCode = countrylanguage.CountryCode; -- 3개의 테이블 조인




-- 내장함수
-- length 전달받은 문자열의 길이를 반환
select length('abcdef');


-- 전달받은 문자열을 모두 결합하여 하나의 문자열로 반환
-- 전달받은 문자열 하나라도 null이존재하면 null을 반환
select concat('My','sql','open source'),
concat('my',null,'sql'); -- 문자열 결합돼서 출력

-- 문자열에서 찾는 문자열이 처음으로 나타나는 위치를 찾아서 해당 위치를 반환
-- 찾는 문자열이 문자열 내에 존재하지 않으면 0을 반환
-- mysql에서는 문자열의 시작 인덱스를 1부터 계산
select locate('abd','ababababdabaabc');

-- left(): 문자열의 왼쪽부터 지정한 개수만큼의 문자를 반환
-- right(): 문자열의 오른쪽부터 지정한 개수만큼의 문자를 반환
select left('My sql is an open source relational database management system',5),
	   right('My sql is an open source relational database management system',6);


select lower('My sql is an open source relational database management system'),
	   upper('My sql is an open source relational database management system');
       
-- replace 문자열에서 특정 문자열을 대체 문자열로 교체
select replace('MSSQL','MS','MY');

-- trim() 문자열의 앞이나 뒤 또는 양쪽모두에 있는 특정 문자를 제거
-- 제거할 문자를 명시하지 않으면, 자동으로 공백을 제거
select trim(               'mysql'                      );
select trim(leading '#' from '###mysql###');
select trim(trailing '#' from '###mysql###');


select format(123645528846669.488484849,3);

select floor(10.95),ceil(10.95),round(10.95); -- 내림,올림,반올림

select sqrt(4),pow(2,3),exp(3),log(3); 

select sin(pi()/2),cos(pi()),tan(pi()/4);

select abs(3),rand(),round(rand()*100,0);
-- abs 절대값 반환, rand() 0.0보다 크거나 같고1.0보다 작은 하나의 실수 무작위로 생성

select now(),curdate(),curtime();
-- 현재날짜와시간, 현재 날짜, 현재시각