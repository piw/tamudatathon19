USE _peng;

DROP TABLE IF EXISTS datathon_gs;
CREATE TABLE datathon_gs (
    id VARCHAR(20) NOT NULL,
    address VARCHAR(100) NOT NULL,
    categories TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    cuisines TEXT,
    dateAdded VARCHAR(100) NOT NULL,
    dateUpdated VARCHAR(100) NOT NULL,
    `keys` VARCHAR(100) NOT NULL,
    latitude VARCHAR(100),
    longitude VARCHAR(100),
    menuPageURL TEXT,
    `menus.amountMax` VARCHAR(100),
    `menus.amountMin` VARCHAR(100),
    `menus.category` TEXT,
    `menus.currency` VARCHAR(100),
    `menus.dateSeen` TEXT NOT NULL,
    `menus.description` TEXT,
    `menus.name` TEXT NOT NULL,
    name VARCHAR(100),
    postalCode VARCHAR(100),
    priceRangeCurrency VARCHAR(100),
    priceRangeMin VARCHAR(100),
    priceRangeMax VARCHAR(100),
    province VARCHAR(100),
    websites TEXT
);

UPDATE datathon_gs SET postalCode = LEFT(postalCode, 5) WHERE LENGTH(postalCode) > 5;
UPDATE datathon_gs SET postalCode = LPAD(postalCode, 5, '0') WHERE LENGTH(postalCode) < 5;
SELECT * FROM datathon_gs as dg WHERE postalCode LIKE '0%';
ALTER TABLE datathon_gs MODIFY COLUMN postalCode VARCHAR(5);

ALTER TABLE reports.DICT_county ADD INDEX zip (`ZIP Code`);
ALTER TABLE datathon_gs ADD INDEX zip (postalCode);

SELECT DISTINCT postalCode FROM datathon_gs as dg
LEFT JOIN reports.DICT_county as dict ON dg.postalCode = dict.`ZIP Code`
LEFT JOIN address.postal as addr ON dg.postalCode = addr.zip
WHERE dict.`ZIP Code` IS NULL AND addr.zip IS NULL AND postalCode IS NOT NULL;

ALTER TABLE datathon_gs DROP COLUMN IF EXISTS real_state;
ALTER TABLE datathon_gs ADD COLUMN real_state TEXT;
ALTER TABLE datathon_gs DROP COLUMN IF EXISTS real_latitude;
ALTER TABLE datathon_gs ADD COLUMN real_latitude TEXT;
ALTER TABLE datathon_gs DROP COLUMN IF EXISTS real_longitude;
ALTER TABLE datathon_gs ADD COLUMN real_longitude TEXT;

UPDATE datathon_gs AS dg
    LEFT JOIN reports.DICT_county AS dict ON dg.postalCode = dict.`ZIP Code`
    LEFT JOIN address.postal AS addr1 ON dg.postalCode = addr1.zip
    LEFT JOIN address.postal_to_state AS addr2 ON dg.postalCode = addr2.zip
SET dg.real_state = COALESCE(dict.`State Code`, addr1.state_abbreviation, addr2.state, dg.province)
WHERE 1 = 1;

UPDATE datathon_gs SET real_state = 'CA' WHERE real_state IS NULL;
SELECT DISTINCT real_state FROM datathon_gs;

SELECT dg.postalCode, dg.latitude, COALESCE(addr1.latitude, addr2.latitude, dg.latitude)
FROM datathon_gs AS dg
    LEFT JOIN reports.DICT_county AS dict ON dg.postalCode = dict.`ZIP Code`
    LEFT JOIN address.postal AS addr1 ON dg.postalCode = addr1.zip
    LEFT JOIN address.postal_to_state AS addr2 ON dg.postalCode = addr2.zip
WHERE dg.latitude IS NULL;

UPDATE datathon_gs AS dg
    LEFT JOIN address.postal AS addr1 ON dg.postalCode = addr1.zip
    LEFT JOIN address.postal_to_state AS addr2 ON dg.postalCode = addr2.zip
SET dg.real_latitude = COALESCE(addr1.latitude, addr2.latitude, dg.latitude),
    dg.real_longitude = COALESCE(addr1.longitude, addr2.longitude, dg.longitude)
WHERE 1 = 1;

SELECT DISTINCT cuisines FROM datathon_gs;

SELECT priceRangeMin, COUNT(1) FROM datathon_gs GROUP BY priceRangeMin;
SELECT priceRangeMax, COUNT(1) FROM datathon_gs GROUP BY priceRangeMax;
SELECT priceRangeMin, priceRangeMax, COUNT(1) FROM datathon_gs GROUP BY priceRangeMin, priceRangeMax;

SELECT * FROM datathon_gs GROUP BY id;
SELECT * FROM (SELECT * FROM datathon_gs WHERE LOWER(`menus.name`) REGEXP 'taco') T GROUP BY id;
SELECT * FROM (SELECT * FROM datathon_gs WHERE LOWER(`menus.name`) REGEXP 'burrito') T GROUP BY id;

SELECT city, COUNT(DISTINCT id) AS cnt_shop
FROM datathon_gs
WHERE real_state IN ('CA', 'TX', 'FL', 'NY', 'IL')
  AND categories REGEXP 'Mexican'
GROUP BY city
ORDER BY cnt_shop DESC;
