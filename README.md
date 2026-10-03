# Stream Analytics - end-to-end система сбора и анализа потоковых данных

Учебный проект по дисциплине «Аналитика данных». Система генерирует поток заказов интернет-магазина, сохраняет его в ClickHouse, агрегирует через Materialized View и позволяет анализировать через Apache Superset и Jupyter Notebook.

## Архитектура


## Технологии

- Python 3.11 - генератор данных
- ClickHouse - аналитическая СУБД
- Apache Superset - BI-дашборд
- PostgreSQL - метаданные Superset
- Redis - кэш Superset
- Jupyter Notebook - ad-hoc анализ
- Docker Compose - оркестрация

## Структура репозитория
├── docker-compose.yml
├── .env.example
├── README.md
├── clickhouse/init/01_schema.sql
├── generator/Dockerfile
├── generator/requirements.txt
├── generator/main.py
├── superset/Dockerfile
├── superset/superset_config.py
├── superset/init.sh
└── notebooks/analysis.ipynb
cp .env.example .env
docker compose up -d --build

Сервис | URL | Логин / пароль
Superset | http://localhost:8088 | admin / admin
Jupyter | http://localhost:8888 | token из .env
ClickHouse | http://localhost:8123 | default / clickhouse_pass

- users - справочник пользователей (id, имя, город, сегмент, дата регистрации)
- orders - поток заказов (order_id, user_id, event_time, product, category, price, quantity, amount, city, is_anomaly)
- orders_by_minute - Materialized View: агрегаты по минутам, категориям и городам
Генератор

- Батчевая запись раз в GENERATOR_INTERVAL секунд
- Суточная сезонность, тренд, редкие аномалии
- Retry с backoff при недоступности ClickHouse
- Graceful shutdown
Авторы

- Участник Никитенко Георгий Валериевич
- Участник Вакуленко Владимир Евгеньевич
