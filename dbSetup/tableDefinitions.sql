CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ENTITY SETS

CREATE TABLE actors (
    name text PRIMARY KEY
);

CREATE TABLE genres (
    genre varchar(50) PRIMARY KEY
);

CREATE TABLE users (
    name varchar(20) PRIMARY KEY,
    email varchar(320) NOT NULL,
    encoded_password varchar(255),
    CONSTRAINT unique_email UNIQUE (email)
);

CREATE TABLE documents (
    id varchar(15) PRIMARY KEY,
    copyright_year integer,
    studio text,
    title text,
    producer text,
    writer text,
    reel_count integer,
    series text,
    document_type text,
    uploaded_by varchar(20),
    uploaded_time timestamp,
    CONSTRAINT fk_uploaded_by FOREIGN KEY (uploaded_by) REFERENCES users(name)
);

CREATE TABLE transcripts (
    document_id varchar(15),
    page_number integer,
    content text,
    text_index_col tsvector GENERATED ALWAYS AS (to_tsvector('english', content)) STORED,
    CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES documents(id),
    PRIMARY KEY (document_id, page_number)
);

CREATE TABLE search_history (
    id BIGSERIAL PRIMARY KEY,
    user_name varchar(20) NOT NULL,
    "time" timestamp NOT NULL DEFAULT NOW(),
    start_year integer,
    end_year integer,
    min_reels integer,
    max_reels integer,
    studio text,
    actors text,
    genres text,
    tags text,
    search_text text,
    CONSTRAINT fk_user_name FOREIGN KEY (user_name) REFERENCES users(name)
);

CREATE TABLE error_locations (
    location varchar(20) PRIMARY KEY
);

-- RELATIONSHIPS

CREATE TABLE flagged_by (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id varchar(15) NOT NULL,
    user_name varchar(20) NOT NULL,
    error_location varchar(20) NOT NULL,
    error_description text,
    CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES documents(id),
    CONSTRAINT fk_user_name FOREIGN KEY (user_name) REFERENCES users(name),
    CONSTRAINT fk_error_location FOREIGN KEY (error_location) REFERENCES error_locations(location)
);

CREATE TABLE view_history (
    id BIGSERIAL PRIMARY KEY,
    document_id varchar(15) NOT NULL,
    user_name varchar(20) NOT NULL,
    viewed_at timestamp NOT NULL DEFAULT NOW(),
    search_id BIGINT,
    CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES documents(id),
    CONSTRAINT fk_user_name FOREIGN KEY (user_name) REFERENCES users(name),
    CONSTRAINT fk_view_history_search FOREIGN KEY (search_id) REFERENCES search_history(id) ON DELETE SET NULL
);

CREATE TABLE has_character (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id varchar(15),
    character_name text,
    actor_name text,
    character_description text,
    CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES documents(id),
    CONSTRAINT fk_actor_name FOREIGN KEY (actor_name) REFERENCES actors(name)
);

CREATE TABLE has_location (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id varchar(15),
    "location" text,
    "description" text,
    CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES documents(id)
);

CREATE TABLE has_genre (
    document_id varchar(15),
    genre varchar(50),
    CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES documents(id),
    CONSTRAINT fk_genre FOREIGN KEY (genre) REFERENCES genres(genre),
    PRIMARY KEY (document_id, genre)
);


-- OTHER

CREATE INDEX idx_studio ON documents(studio);
CREATE INDEX idx_copyright_year ON documents(copyright_year);
CREATE INDEX idx_title ON documents(title);
CREATE INDEX idx_actor ON has_character(actor_name);
CREATE INDEX idx_has_character_document_id ON has_character(document_id);
CREATE INDEX idx_has_location_document_id ON has_location(document_id);
CREATE INDEX idx_search_history_user_time ON search_history(user_name, "time" DESC);
CREATE INDEX idx_view_history_user_time ON view_history(user_name, viewed_at DESC);
CREATE INDEX idx_view_history_search_id ON view_history(search_id);

-- macro for complete transcript text
CREATE VIEW text_content_view AS (
    SELECT document_id, STRING_AGG(content, ' ') AS content
    FROM transcripts
    GROUP BY document_id
);

-- index for text searching
CREATE MATERIALIZED VIEW text_search_view AS (
    SELECT
        documents.id AS document_id,
        setweight(to_tsvector(coalesce(title,'')), 'A') ||
        setweight(to_tsvector(coalesce(text_content_view.content,'')), 'B') AS text_vector
    FROM documents, text_content_view
    WHERE documents.id = text_content_view.document_id
    GROUP BY id, text_content_view.content
) WITH NO DATA;
