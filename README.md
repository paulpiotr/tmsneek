# tmsneek
PHP Developer – zadanie testowe

# Instalacja

#### Klonowanie projektu

- $> git clone https://github.com/paulpiotr/tmsneek.git

#### Instalacja bibliotek PHP

- $> composer update

#### Instalacja bibliotek JS

- $> yarn install

#### Instalacja bazy danych

- Trzeba utworzyć bazę danych PostgreSQL lub MySQL i utworzyć użytkownika, użytkownik powinien mieć uprawnienia do tworzenia tabel, funkcji, procedur, wyzwalaczy.
- Trzeba skonfigurować dostęp do bazy w pliku .env lub zakomentować/ odkomentować odpowiednie linie
- Trzeba skonfigurować config/packages/doctrine.yaml lub zakomentować/ odkomentować odpowiednie linie
- $> php bin/console app:install