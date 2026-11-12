DROP TABLE IF EXISTS nyc_taxi.trips;

-- payment_type - тип оплаты
-- CSH — наличные
-- CRE — кредитная карта
-- NOC — отсутствие оплаты (может означать отказ от оплаты, бесплатный проезд или ошибку)
-- DIS — скидка
-- UNK — неизвестный тип оплаты или неизвестное значение

-- NTA — это Neighborhood Tabulation Area, статистическая единица, используемая бюро
-- переписи населения США для более детального анализа данных по городам и районам

CREATE TABLE nyc_taxi.trips (
    trip_id             UInt32,
    pickup_datetime     DateTime, -- дата и время начала поездки
    dropoff_datetime    DateTime, -- дата и время окончания поездки
    pickup_longitude    Nullable(Float64), -- GPS-долгота точки начала поездки
    pickup_latitude     Nullable(Float64), -- GPS-широта точки начала поездки
    dropoff_longitude   Nullable(Float64), -- GPS-долгота точки окончания поездки
    dropoff_latitude    Nullable(Float64), -- GPS-широта точки окончания поездки
    passenger_count     UInt8, -- количество пассажиров
    trip_distance       Float32, -- длина поездки
    fare_amount         Float32, -- тариф поездки
    extra               Float32, -- дополнительно в час пик $0.5/миля, ночью $1/миля
    tip_amount          Float32, -- чаевые
    tolls_amount        Float32, -- дорожный сбор
    total_amount        Float32, -- полная сумма оплаты
    payment_type        Enum('CSH' = 1, 'CRE' = 2, 'NOC' = 3, 'DIS' = 4, 'UNK' = 5), -- тип оплаты
    pickup_ntaname      LowCardinality(String), -- район точки начала поездки
    dropoff_ntaname     LowCardinality(String)  -- район окончания поездки
)
ENGINE = MergeTree
PRIMARY KEY (pickup_datetime, dropoff_datetime);

SET input_format_skip_unknown_fields=1;

INSERT INTO nyc_taxi.trips
FROM INFILE '/docker-entrypoint-initdb.d/trips.tsv.gz'
FORMAT TSVWithNames;
