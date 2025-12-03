-- ENTITY SETS

CREATE TABLE actors (
    name varchar(100) PRIMARY KEY
);

CREATE TABLE genres (
    genre varchar(50) PRIMARY KEY
);

CREATE TABLE tags (
    tag varchar(50) PRIMARY KEY
);

CREATE TABLE users (
    name varchar(20) PRIMARY KEY,
    encoded_password char(20)
);

CREATE TABLE documents (
    id varchar(15) PRIMARY KEY,
    copyright_year integer,
    studio varchar(50),
    image_path path,
    reel_count integer,
    uploaded_by varchar(20),
    uploaded_time timestamp,
    CONSTRAINT fk_uploaded_by FOREIGN KEY (uploaded_by) REFERENCES users(name)
);

CREATE TABLE transcripts (
    document_id varchar(15),
    page_number integer,
    content text,
    CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES documents(id),
    PRIMARY KEY (document_id, page_number)
);

CREATE TABLE queries (
    user_name varchar(20),
    time timestamp,
    start_year integer,
    end_year integer,
    start_runtime integer,
    end_runtime integer,
    studio varchar(50),
    actors text,
    genres text,
    tags text,
    CONSTRAINT fk_user_name FOREIGN KEY (user_name) REFERENCES users(name),
    PRIMARY KEY (user_name, time)
);

CREATE TABLE error_locations (
    location varchar(20) PRIMARY KEY
);

-- RELATIONSHIPS

CREATE TABLE flagged_by (
    document_id varchar(15),
    user_name varchar(20),
    error_location varchar(20),
    error_description text,
    CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES documents(id),
    CONSTRAINT fk_user_name FOREIGN KEY (user_name) REFERENCES users(name),
    CONSTRAINT fk_error_location FOREIGN KEY (error_location) REFERENCES error_locations(location),
    PRIMARY KEY (document_id, user_name)
);

CREATE TABLE document_viewed (
    document_id varchar(15),
    user_name varchar(20),
    query_time timestamp,
    CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES documents(id),
    CONSTRAINT fk_user_name FOREIGN KEY (user_name) REFERENCES users(name),
    CONSTRAINT fk_query_time FOREIGN KEY (user_name, query_time) REFERENCES queries(user_name, time),
    PRIMARY KEY (document_id, user_name, query_time)
);

CREATE TABLE has_actor (
    document_id varchar(15),
    actor_name varchar(100),
    role varchar(50),
    CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES documents(id),
    CONSTRAINT fk_actor_name FOREIGN KEY (actor_name) REFERENCES actors(name),
    PRIMARY KEY (document_id, actor_name)
);

CREATE TABLE has_genre (
    document_id varchar(15),
    genre varchar(50),
    CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES documents(id),
    CONSTRAINT fk_genre FOREIGN KEY (genre) REFERENCES genres(genre),
    PRIMARY KEY (document_id, genre)
);

CREATE TABLE has_tag (
    document_id varchar(15),
    tag varchar(50),
    CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES documents(id),
    CONSTRAINT fk_tag FOREIGN KEY (tag) REFERENCES tags(tag),
    PRIMARY KEY (document_id, tag)
);

-- OTHER

CREATE INDEX idx_studio ON documents(studio);
CREATE INDEX idx_copyright_year ON documents(studio);