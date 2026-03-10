/* Query to create the table */

nmCREATE TABLE parts (
    item_no SERIAL,
    length NUMERIC (6, 2),
    width NUMERIC (6, 2),
    height NUMERIC(6, 2),
    operator TEXT
);