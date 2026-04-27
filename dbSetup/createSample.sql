-- use this script on the populated testing database to reduce all documents to a subset of documents
-- DO NOT USE ON PRODUCTION DATABASE

CREATE TABLE sample_ids (
    id varchar(15) PRIMARY KEY
);

INSERT INTO sample_ids (id) SELECT id FROM documents ORDER BY RANDOM() LIMIT 20;

SET CONSTRAINTS ALL DEFERRED;

-- END SETUP --

-- DELETE ALL USER DATA
DELETE FROM users;
DELETE FROM search_history;
DELETE FROM view_history;
DELETE FROM flagged_by;
DELETE FROM error_locations;

-- DELETE DOCUMENT DATA
DELETE FROM documents WHERE id NOT IN ( SELECT id FROM sample_ids );
DELETE FROM transcripts WHERE document_id NOT IN ( SELECT id FROM sample_ids );
DELETE FROM has_character WHERE document_id NOT IN ( SELECT id FROM sample_ids );
DELETE FROM has_location WHERE document_id NOT IN ( SELECT id FROM sample_ids );
DELETE FROM has_genre WHERE document_id NOT IN ( SELECT id FROM sample_ids );

-- DELETE HANGING DATA
DELETE FROM actors WHERE name NOT IN ( SELECT actor_name FROM has_character );
DELETE FROM genres WHERE genre NOT IN ( SELECT genre FROM has_genre );

-- CLEAN UP --

DROP TABLE sample_ids;
