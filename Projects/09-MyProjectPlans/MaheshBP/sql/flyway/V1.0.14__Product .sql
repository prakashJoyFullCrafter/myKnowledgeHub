set
search_path to core;


CREATE TABLE m_product_category
(
    id                  SERIAL PRIMARY KEY,
    internal_id         character varying(200) NOT NULL UNIQUE,
    parent_category_id  INT REFERENCES m_product_category (id),
    name                character varying(150) NOT NULL,
    description         TEXT,
    icon_key            character varying(50),
    display_order       INT                    NOT NULL DEFAULT 0,
    status              character varying(1)   NOT NULL DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,
    version             INT                    NOT NULL DEFAULT 1
);

