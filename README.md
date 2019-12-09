# tmsneek
PHP Developer – zadanie testowe
# Instalacja
#### Klonowanie projektu
###### $ git clone https://github.com/paulpiotr/tmsneek.git && cd tmsneek
#### Instalacja bibliotek PHP
###### $ composer install
#### Instalacja bibliotek JS
###### $ yarn install
#### Instalacja bazy danych
- trzeba utworzyć bazę danych PostgreSQL lub MySQL i utworzyć użytkownika, użytkownik powinien mieć uprawnienia do tworzenia tabel, funkcji, procedur, wyzwalaczy.
- trzeba skonfigurować dostęp do bazy w pliku .env lub za komentować / od komentować odpowiednie linie
- trzeba skonfigurować config/packages/doctrine.yaml lub za komentować / od komentować odpowiednie linie
- instalacja schematu i danych z komendy
###### $ php bin/console app:install
- lub
- jeśli potrzebna ręczna instalacja bazy danych utworzyłem odpowiednie pliki w katalogach
- data/mysql/schema-and-data.sql - struktura i dane MySQL 
- data/mysql/schema-only.sql - tylko struktura MySQL
- data/postgresql/schema-and-data.sql - struktura i dane PostgreSQL 
- data/postgresql/schema-only.sql - tylko struktura PostgreSQL
- jeśli trzeba utworzyć przykładowe dane można zainstalować tylko schemat odpowiedniej bazy danych i uruchomić polecenie:
###### $ php bin/console doctrine:fixtures:load
- tworzenie bazy danych za pomocą doctrine:migrations
###### $ php bin/console doctrine:migrations:execute --up 20191207082243
- czyszczenia bazy danych
###### $ php bin/console doctrine:migrations:execute --down 20191207082243
