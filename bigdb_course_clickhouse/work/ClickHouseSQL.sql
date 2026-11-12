-- 01 Получите список районов Нью-Йорка, при поездке из которых суммарная оплата наличными за всё время наблюдения составила более $500000. При суммировании учитывайте только положительные суммы оплаты поездки.

-- Ваш код:
SELECT
    pickup_ntaname,
    SUM(total_amount) AS total_cash
FROM nyc_taxi.trips
WHERE payment_type = 'CSH'
    AND total_amount > 0
GROUP BY pickup_ntaname
HAVING total_cash > 500000
ORDER BY total_cash DESC

-- 02 В какое время суток предпочитают расплачиваться картой и в какое время наличными? Постройте два запроса со средней суммой оплаты в зависимости от времени суток для оплат картой и наличными. При суммировании учитывайте только положительные суммы оплаты поездки.

-- Ваш код:
SELECT 
    CASE 
        WHEN toHour(pickup_datetime) BETWEEN 0 AND 5  THEN 'Ночь (00-05)'
        WHEN toHour(pickup_datetime) BETWEEN 6 AND 11 THEN 'Утро (06-11)'
        WHEN toHour(pickup_datetime) BETWEEN 12 AND 17 THEN 'День (12-17)'
        ELSE 'Вечер (18-23)'
    END AS time_of_day,
    AVG(total_amount) AS avg_amount,
    count() AS cnt
FROM nyc_taxi.trips
WHERE payment_type = 'CSH'
  AND total_amount > 0
GROUP BY time_of_day
ORDER BY time_of_day


SELECT
    multiIf(
        toHour(pickup_datetime) BETWEEN 0 AND 5, 'Ночь (00-05)'
        toHour(pickup_datetime) BETWEEN 6 AND 11, 'Утро (06-11)'
        toHour(pickup_datetime) BETWEEN 12 AND 17, 'День (12-17)'
        'Вечер (18-23)'
    ) AS time_of_day,
    AVG(total_amount) AS avg_amount,
    count() AS cnt
FROM nyc_taxi.trips
WHERE payment_type = 'CRE'
  AND total_amount > 0
GROUP BY time_of_day
ORDER BY time_of_day

-- 03 Какие виды оплаты предпочитают компании из нескольких пассажиров? Получите списки вариантов оплаты, используемых пассажирами, в зависимости от их количества. Исключите случаи, когда число пассажиров меньше 2. Компании из скольки человек предпочитают оплату наличными?

-- Ваш код:
SELECT 
    passenger_count,
    payment_type,
    count() AS trip_count
FROM nyc_taxi.trips
WHERE passenger_count >= 2
  AND total_amount > 0
GROUP BY passenger_count, payment_type
ORDER BY passenger_count, trip_count DESC

-- 04 Постройте граф поездок - в первой колонке выведите район отправления, а во второй - список районов прибытия. Исключите из рассмотрения записи, в который районы отправления или прибытия не указаны. Таблицу отсортируй по убыванию длины списка прибытия.

-- Ваш код:
SELECT 
    pickup_ntaname AS from_district,
    groupUniqArray(dropoff_ntaname) AS to_districts,
    length(groupUniqArray(dropoff_ntaname)) AS destinations_count
FROM nyc_taxi.trips
WHERE pickup_ntaname != '' 
  AND dropoff_ntaname != ''
GROUP BY pickup_ntaname
ORDER BY destinations_count DESC

-- 05 Для каждого района отправление найдите три наиболее частых района прибытия. Исключите из рассмотрения записи, в который районы отправления или прибытия не указаны. Используйте функцию topK.

-- Ваш код:
SELECT 
    pickup_ntaname AS from_district,
    topK(3)(dropoff_ntaname) AS top3_destinations
FROM nyc_taxi.trips
WHERE pickup_ntaname != '' 
  AND dropoff_ntaname != ''
GROUP BY pickup_ntaname
ORDER BY from_district DESC

-- 06 Вычислите квантили уровней 0.25, 0.5, 0.75 и 1  для полной суммы оплаты поездки используя приближенную функцию quantiles и точную quantilesExact. Используя только стандартный SQL (без расширенных возможностей ClickHouse), вычислите квантиль уровня 1. Сравните результаты трёх созданных запросов. Оцените насколько приближённые квантили отличаются от точных. Проанализируйте, почему это происходит. Возможно, в этом поможет изучение упорядоченных значений суммы оплаты поездки и точных квантилей вблизи единицы.

-- Ваш код:
SELECT 
    quantiles(0.25, 0.5, 0.75, 1)(total_amount) AS approx_quantiles
FROM nyc_taxi.trips

SELECT
    quantilesExact(0.25, 0.5, 0.75)(total_amount) AS exact_quantiles
FROM nyc_taxi.trips

SELECT
    MAX(total_amount) AS quantile_1
FROM nyc_taxi.trips

-- 07 Создайте запрос, который вычисляет гистограмму из 10 ячеек для значений из столбца полной суммы оплаты поездки Исключите из рассмотрения отрицательные значения. Какие суммы оплаты встречаются чаще всего?

-- Ваш код:
SELECT 
    bin.1 AS lower,
    bin.2 AS upper,
    bin.3 AS count
FROM (
    SELECT histogram(10)(total_amount) AS bins
    FROM nyc_taxi.trips
    WHERE total_amount > 0
)
ARRAY JOIN bins AS bin
ORDER BY lower

-- 08 В поле полной суммы оплаты поездки есть отрицательные значения. Проанализируйте связь этих отрицательных значений с другими данным в таблице. Например, выясните как положительные и отрицательные оплаты связаны с временем суток поездок и районами начала и окончания. Ответьте на вопрос - можно ли считать это потерями таксистов, например, вследствие ограблений, или вероятнее всего это просто ошибочные данные.
SELECT 
    payment_type,
    toHour(pickup_datetime) AS hour,
    pickup_ntaname,
    dropoff_ntaname,
    count() AS cnt,
    avg(total_amount) AS avg_amount,
    min(total_amount) AS min_amount,
    max(total_amount) AS max_amount
FROM nyc_taxi.trips
WHERE total_amount < 0
GROUP BY payment_type, hour, pickup_ntaname, dropoff_ntaname
ORDER BY cnt DESC
LIMIT 50

SELECT 
    payment_type,
    count() AS negative_count,
    avg(total_amount) AS avg_negative,
    min(total_amount) AS worst_negative
FROM nyc_taxi.trips
WHERE total_amount < 0
GROUP BY payment_type
ORDER BY negative_count DESC

-- Ваш код:
