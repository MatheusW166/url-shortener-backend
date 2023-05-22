BEGIN;

CREATE FUNCTION check_visit(new_visit_count INTEGER,row_id INTEGER) RETURNS BOOLEAN AS
$$
DECLARE
	previous_visit_count INTEGER;
BEGIN
	previous_visit_count:=(SELECT urls.visit_count FROM urls WHERE urls.id=row_id);
	RETURN new_visit_count = previous_visit_count + 1;
END;
$$ LANGUAGE plpgsql;

CREATE PROCEDURE increment_visit(IN short TEXT) AS 
$$
BEGIN
	UPDATE urls SET visit_count=visit_count+1 WHERE urls.short_url=short;
	COMMIT;
	
	IF FOUND THEN
		RAISE NOTICE '1 rows affected';
	ELSE 
		RAISE EXCEPTION '0 rows affected';
	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TABLE IF NOT EXISTS users
(
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS sessions
(
    id SERIAL PRIMARY KEY,
    token TEXT NOT NULL UNIQUE,
    user_id INTEGER NOT NULL REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS urls
(
    id SERIAL PRIMARY KEY,
    url TEXT NOT NULL,
    short_url TEXT NOT NULL UNIQUE,
    visit_count INTEGER NOT NULL CHECK(check_visit(visit_count,id)) DEFAULT 0,
    user_id INTEGER NOT NULL REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

END;