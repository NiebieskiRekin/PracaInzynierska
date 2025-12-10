-- 24 paź 21:38
CREATE SCHEMA "hodowlakoni";

CREATE TYPE "hodowlakoni"."plcie" AS ENUM('klacz', 'ogier', 'wałach');
CREATE TYPE "hodowlakoni"."rodzaje_koni" AS ENUM('Konie hodowlane', 'Konie rekreacyjne', 'Źrebaki', 'Konie sportowe');
CREATE TYPE "hodowlakoni"."rodzaje_notifications" AS ENUM('Podkucia', 'Odrobaczanie', 'Podanie suplementów', 'Szczepienie', 'Dentysta', 'Inne');
CREATE TYPE "hodowlakoni"."rodzaje_wysylania_notifications" AS ENUM('Push', 'Email', 'Oba');
CREATE TYPE "hodowlakoni"."rodzaje_zdarzen_profilaktycznych" AS ENUM('Odrobaczanie', 'Podanie suplementów', 'Szczepienie', 'Dentysta', 'Inne');
CREATE TYPE "hodowlakoni"."rodzaje_zdarzen_rozrodczych" AS ENUM('Inseminacja konia', 'Sprawdzenie źrebności', 'Wyźrebienie', 'Inne');
CREATE TYPE "hodowlakoni"."user_roles" AS ENUM('właściciel', 'członek', 'viewer');
CREATE TABLE "hodowlakoni"."choroby" (
        "id" serial PRIMARY KEY NOT NULL,
        "kon" integer NOT NULL,
        "data_rozpoczecia" date DEFAULT now() NOT NULL,
        "data_zakonczenia" date,
        "opis_zdarzenia" varchar
);

CREATE TABLE "hodowlakoni"."hodowcy_koni" (
        "id" serial PRIMARY KEY NOT NULL,
        "nazwa" varchar NOT NULL,
        "email" varchar NOT NULL,
        "numer_telefonu" varchar(15),
        "liczba_requestow" integer DEFAULT 0 NOT NULL
);

CREATE TABLE "hodowlakoni"."konie" (
        "id" serial PRIMARY KEY NOT NULL,
        "nazwa" varchar NOT NULL,
        "numer_przyzyciowy" varchar(15),
        "numer_chipa" varchar(15),
        "rocznik_urodzenia" integer DEFAULT extract(year from CURRENT_DATE),
        "data_przybycia_do_stajni" date DEFAULT now(),
        "data_odejscia_ze_stajni" date,
        "hodowla" integer NOT NULL,
        "rodzaj_konia" "hodowlakoni"."rodzaje_koni" NOT NULL,
        "plec" "hodowlakoni"."plcie",
        "active" boolean DEFAULT true NOT NULL,
        CONSTRAINT "odejscie_pozniej_niz_przybycie" CHECK ((data_odejscia_ze_stajni is null or data_przybycia_do_stajni is null) or data_przybycia_do_stajni <= data_odejscia_ze_stajni),
        CONSTRAINT "przybycie_nie_wczesniej_niz_rocznik_urodzenia" CHECK ((data_odejscia_ze_stajni is null or data_przybycia_do_stajni is null) or extract(year from data_przybycia_do_stajni) >= rocznik_urodzenia ),
        CONSTRAINT "data_przybycia_wymagana_przy_dacie_odejscia" CHECK (not (data_odejscia_ze_stajni is not null and data_przybycia_do_stajni is null))
);

CREATE TABLE "hodowlakoni"."kowale" (
        "id" serial PRIMARY KEY NOT NULL,
        "imie_i_nazwisko" varchar NOT NULL,
        "numer_telefonu" varchar(15),
        "hodowla" integer NOT NULL,
        "active" boolean DEFAULT true NOT NULL
);

CREATE TABLE "hodowlakoni"."leczenia" (
        "id" serial PRIMARY KEY NOT NULL,
        "kon" integer NOT NULL,
        "weterynarz" integer NOT NULL,
        "data_zdarzenia" date DEFAULT now() NOT NULL,
        "opis_zdarzenia" varchar,
        "choroba" integer
);

CREATE TABLE "hodowlakoni"."notifications" (
        "id" serial PRIMARY KEY NOT NULL,
        "user_id" integer NOT NULL,
        "rodzaje_notifications" "hodowlakoni"."rodzaje_notifications" NOT NULL,
        "days" integer NOT NULL,
        "time" time(6) with time zone NOT NULL,
        "active" boolean DEFAULT true NOT NULL,
        "rodzaje_wysylania_notifications" "hodowlakoni"."rodzaje_wysylania_notifications" NOT NULL
);

CREATE TABLE "hodowlakoni"."podkucia" (
        "id" serial PRIMARY KEY NOT NULL,
        "data_zdarzenia" date DEFAULT now() NOT NULL,
        "data_waznosci" date,
        "kon" integer NOT NULL,
        "kowal" integer NOT NULL
);

CREATE TABLE "hodowlakoni"."rozrody" (
        "id" serial PRIMARY KEY NOT NULL,
        "kon" integer NOT NULL,
        "weterynarz" integer NOT NULL,
        "data_zdarzenia" date DEFAULT now() NOT NULL,
        "rodzaj_zdarzenia" "hodowlakoni"."rodzaje_zdarzen_rozrodczych" NOT NULL,
        "opis_zdarzenia" varchar
);

CREATE TABLE "hodowlakoni"."user_permissions" (
        "id" serial PRIMARY KEY NOT NULL,
        "user_id" integer NOT NULL,
        "role" "hodowlakoni"."user_roles" NOT NULL
);

CREATE TABLE "hodowlakoni"."users" (
        "id" serial PRIMARY KEY NOT NULL,
        "email" varchar(255) NOT NULL,
        "password" varchar(255) NOT NULL,
        "created_at" date DEFAULT now() NOT NULL,
        "refresh_token_version" integer DEFAULT 1 NOT NULL,
        "hodowla" integer NOT NULL,
        CONSTRAINT "users_email_unique" UNIQUE("email")
);

CREATE TABLE "hodowlakoni"."weterynarze" (
        "id" serial PRIMARY KEY NOT NULL,
        "imie_i_nazwisko" varchar NOT NULL,
        "numer_telefonu" varchar(15),
        "hodowla" integer NOT NULL,
        "active" boolean DEFAULT true NOT NULL
);

CREATE TABLE "hodowlakoni"."zdarzenia_profilaktyczne" (
        "id" serial PRIMARY KEY NOT NULL,
        "kon" integer NOT NULL,
        "weterynarz" integer NOT NULL,
        "data_zdarzenia" date DEFAULT now() NOT NULL,
        "data_waznosci" date,
        "rodzaj_zdarzenia" "hodowlakoni"."rodzaje_zdarzen_profilaktycznych" NOT NULL,
        "opis_zdarzenia" varchar
);

CREATE TABLE "hodowlakoni"."zdjecia_koni" (
        "id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
        "kon" integer NOT NULL,
        "default" boolean NOT NULL
);

ALTER TABLE "hodowlakoni"."choroby" ADD CONSTRAINT "choroby_kon_konie_id_fk" FOREIGN KEY ("kon") REFERENCES "hodowlakoni"."konie"("id") ON DELETE no action ON UPDATE no action;
ALTER TABLE "hodowlakoni"."konie" ADD CONSTRAINT "konie_hodowla_hodowcy_koni_id_fk" FOREIGN KEY ("hodowla") REFERENCES "hodowlakoni"."hodowcy_koni"("id") ON DELETE no action ON UPDATE no action;
ALTER TABLE "hodowlakoni"."kowale" ADD CONSTRAINT "kowale_hodowla_hodowcy_koni_id_fk" FOREIGN KEY ("hodowla") REFERENCES "hodowlakoni"."hodowcy_koni"("id") ON DELETE no action ON UPDATE no action;
ALTER TABLE "hodowlakoni"."leczenia" ADD CONSTRAINT "leczenia_kon_konie_id_fk" FOREIGN KEY ("kon") REFERENCES "hodowlakoni"."konie"("id") ON DELETE no action ON UPDATE no action;
ALTER TABLE "hodowlakoni"."leczenia" ADD CONSTRAINT "leczenia_weterynarz_weterynarze_id_fk" FOREIGN KEY ("weterynarz") REFERENCES "hodowlakoni"."weterynarze"("id") ON DELETE no action ON UPDATE no action;
ALTER TABLE "hodowlakoni"."leczenia" ADD CONSTRAINT "leczenia_choroba_choroby_id_fk" FOREIGN KEY ("choroba") REFERENCES "hodowlakoni"."choroby"("id") ON DELETE no action ON UPDATE no action;
ALTER TABLE "hodowlakoni"."notifications" ADD CONSTRAINT "notifications_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "hodowlakoni"."users"("id") ON DELETE no action ON UPDATE no action;
ALTER TABLE "hodowlakoni"."podkucia" ADD CONSTRAINT "podkucia_kon_konie_id_fk" FOREIGN KEY ("kon") REFERENCES "hodowlakoni"."konie"("id") ON DELETE no action ON UPDATE no action;
ALTER TABLE "hodowlakoni"."podkucia" ADD CONSTRAINT "podkucia_kowal_kowale_id_fk" FOREIGN KEY ("kowal") REFERENCES "hodowlakoni"."kowale"("id") ON DELETE no action ON UPDATE no action;
ALTER TABLE "hodowlakoni"."rozrody" ADD CONSTRAINT "rozrody_kon_konie_id_fk" FOREIGN KEY ("kon") REFERENCES "hodowlakoni"."konie"("id") ON DELETE no action ON UPDATE no action;
ALTER TABLE "hodowlakoni"."rozrody" ADD CONSTRAINT "rozrody_weterynarz_weterynarze_id_fk" FOREIGN KEY ("weterynarz") REFERENCES "hodowlakoni"."weterynarze"("id") ON DELETE no action ON UPDATE no action;
ALTER TABLE "hodowlakoni"."user_permissions" ADD CONSTRAINT "user_permissions_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "hodowlakoni"."users"("id") ON DELETE no action ON UPDATE no action;
ALTER TABLE "hodowlakoni"."users" ADD CONSTRAINT "users_hodowla_hodowcy_koni_id_fk" FOREIGN KEY ("hodowla") REFERENCES "hodowlakoni"."hodowcy_koni"("id") ON DELETE no action ON UPDATE no action;
ALTER TABLE "hodowlakoni"."weterynarze" ADD CONSTRAINT "weterynarze_hodowla_hodowcy_koni_id_fk" FOREIGN KEY ("hodowla") REFERENCES "hodowlakoni"."hodowcy_koni"("id") ON DELETE no action ON UPDATE no action;
ALTER TABLE "hodowlakoni"."zdarzenia_profilaktyczne" ADD CONSTRAINT "zdarzenia_profilaktyczne_kon_konie_id_fk" FOREIGN KEY ("kon") REFERENCES "hodowlakoni"."konie"("id") ON DELETE no action ON UPDATE no action;
ALTER TABLE "hodowlakoni"."zdarzenia_profilaktyczne" ADD CONSTRAINT "zdarzenia_profilaktyczne_weterynarz_weterynarze_id_fk" FOREIGN KEY ("weterynarz") REFERENCES "hodowlakoni"."weterynarze"("id") ON DELETE no action ON UPDATE no action;
ALTER TABLE "hodowlakoni"."zdjecia_koni" ADD CONSTRAINT "zdjecia_koni_kon_konie_id_fk" FOREIGN KEY ("kon") REFERENCES "hodowlakoni"."konie"("id") ON DELETE no action ON UPDATE no action;