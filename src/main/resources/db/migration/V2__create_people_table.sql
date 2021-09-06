CREATE TABLE people (
                        person_id  BIGSERIAL
                            CONSTRAINT people_pk
                                PRIMARY KEY,
                        first_name VARCHAR,
                        last_name  VARCHAR
);
