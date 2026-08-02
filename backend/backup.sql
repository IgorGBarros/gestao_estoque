--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.inventory_store DROP CONSTRAINT IF EXISTS inventory_store_user_id_854ba86a_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.inventory_saleitem DROP CONSTRAINT IF EXISTS inventory_saleitem_sale_id_09bd155b_fk_inventory_sale_id;
ALTER TABLE IF EXISTS ONLY public.inventory_saleitem DROP CONSTRAINT IF EXISTS inventory_saleitem_product_id_cd9a834b_fk_inventory_product_id;
ALTER TABLE IF EXISTS ONLY public.inventory_saleitem DROP CONSTRAINT IF EXISTS inventory_saleitem_batch_id_b82bea79_fk_inventory;
ALTER TABLE IF EXISTS ONLY public.inventory_sale DROP CONSTRAINT IF EXISTS inventory_sale_store_id_60ee6f5f_fk_inventory_store_id;
ALTER TABLE IF EXISTS ONLY public.inventory_pricehistory DROP CONSTRAINT IF EXISTS inventory_pricehisto_product_id_53789fff_fk_inventory;
ALTER TABLE IF EXISTS ONLY public.inventory_inventoryitem DROP CONSTRAINT IF EXISTS inventory_inventoryitem_store_id_9243fb77_fk_inventory_store_id;
ALTER TABLE IF EXISTS ONLY public.inventory_inventoryitem DROP CONSTRAINT IF EXISTS inventory_inventoryi_product_id_78574124_fk_inventory;
ALTER TABLE IF EXISTS ONLY public.inventory_inventorybatch DROP CONSTRAINT IF EXISTS inventory_inventoryb_item_id_41df143d_fk_inventory;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_user_id_c564eba6_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_content_type_id_c4bce8eb_fk_django_co;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_user_id_6a12ed8b_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_group_id_97559544_fk_auth_group_id;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_content_type_id_2f476e4b_fk_django_co;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_group_id_b120cbf9_fk_auth_group_id;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissio_permission_id_84c5c92e_fk_auth_perm;
DROP INDEX IF EXISTS public.inventory_store_slug_7f929d58_like;
DROP INDEX IF EXISTS public.inventory_saleitem_sale_id_09bd155b;
DROP INDEX IF EXISTS public.inventory_saleitem_product_id_cd9a834b;
DROP INDEX IF EXISTS public.inventory_saleitem_batch_id_b82bea79;
DROP INDEX IF EXISTS public.inventory_sale_store_id_60ee6f5f;
DROP INDEX IF EXISTS public.inventory_product_natura_sku_fb3604bf_like;
DROP INDEX IF EXISTS public.inventory_product_bar_code_5579df6b_like;
DROP INDEX IF EXISTS public.inventory_pricehistory_product_id_53789fff;
DROP INDEX IF EXISTS public.inventory_inventoryitem_store_id_9243fb77;
DROP INDEX IF EXISTS public.inventory_inventoryitem_product_id_78574124;
DROP INDEX IF EXISTS public.inventory_inventorybatch_item_id_41df143d;
DROP INDEX IF EXISTS public.inventory_crawlerlog_sku_63555d21_like;
DROP INDEX IF EXISTS public.inventory_crawlerlog_sku_63555d21;
DROP INDEX IF EXISTS public.django_session_session_key_c0390e0f_like;
DROP INDEX IF EXISTS public.django_session_expire_date_a5c62663;
DROP INDEX IF EXISTS public.django_admin_log_user_id_c564eba6;
DROP INDEX IF EXISTS public.django_admin_log_content_type_id_c4bce8eb;
DROP INDEX IF EXISTS public.auth_user_username_6821ab7c_like;
DROP INDEX IF EXISTS public.auth_user_user_permissions_user_id_a95ead1b;
DROP INDEX IF EXISTS public.auth_user_user_permissions_permission_id_1fbb5f2c;
DROP INDEX IF EXISTS public.auth_user_groups_user_id_6a12ed8b;
DROP INDEX IF EXISTS public.auth_user_groups_group_id_97559544;
DROP INDEX IF EXISTS public.auth_permission_content_type_id_2f476e4b;
DROP INDEX IF EXISTS public.auth_group_permissions_permission_id_84c5c92e;
DROP INDEX IF EXISTS public.auth_group_permissions_group_id_b120cbf9;
DROP INDEX IF EXISTS public.auth_group_name_a6ea08ec_like;
ALTER TABLE IF EXISTS ONLY public.inventory_store DROP CONSTRAINT IF EXISTS inventory_store_user_id_key;
ALTER TABLE IF EXISTS ONLY public.inventory_store DROP CONSTRAINT IF EXISTS inventory_store_slug_key;
ALTER TABLE IF EXISTS ONLY public.inventory_store DROP CONSTRAINT IF EXISTS inventory_store_pkey;
ALTER TABLE IF EXISTS ONLY public.inventory_saleitem DROP CONSTRAINT IF EXISTS inventory_saleitem_pkey;
ALTER TABLE IF EXISTS ONLY public.inventory_sale DROP CONSTRAINT IF EXISTS inventory_sale_pkey;
ALTER TABLE IF EXISTS ONLY public.inventory_product DROP CONSTRAINT IF EXISTS inventory_product_pkey;
ALTER TABLE IF EXISTS ONLY public.inventory_product DROP CONSTRAINT IF EXISTS inventory_product_natura_sku_key;
ALTER TABLE IF EXISTS ONLY public.inventory_product DROP CONSTRAINT IF EXISTS inventory_product_bar_code_key;
ALTER TABLE IF EXISTS ONLY public.inventory_pricehistory DROP CONSTRAINT IF EXISTS inventory_pricehistory_pkey;
ALTER TABLE IF EXISTS ONLY public.inventory_inventoryitem DROP CONSTRAINT IF EXISTS inventory_inventoryitem_store_id_product_id_ba33e0ff_uniq;
ALTER TABLE IF EXISTS ONLY public.inventory_inventoryitem DROP CONSTRAINT IF EXISTS inventory_inventoryitem_pkey;
ALTER TABLE IF EXISTS ONLY public.inventory_inventorybatch DROP CONSTRAINT IF EXISTS inventory_inventorybatch_pkey;
ALTER TABLE IF EXISTS ONLY public.inventory_crawlerlog DROP CONSTRAINT IF EXISTS inventory_crawlerlog_pkey;
ALTER TABLE IF EXISTS ONLY public.django_session DROP CONSTRAINT IF EXISTS django_session_pkey;
ALTER TABLE IF EXISTS ONLY public.django_migrations DROP CONSTRAINT IF EXISTS django_migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.django_content_type DROP CONSTRAINT IF EXISTS django_content_type_pkey;
ALTER TABLE IF EXISTS ONLY public.django_content_type DROP CONSTRAINT IF EXISTS django_content_type_app_label_model_76bd3d3b_uniq;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user DROP CONSTRAINT IF EXISTS auth_user_username_key;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_user_id_permission_id_14a6b632_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user DROP CONSTRAINT IF EXISTS auth_user_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_user_id_group_id_94350c0c_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_content_type_id_codename_01ab375a_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_group DROP CONSTRAINT IF EXISTS auth_group_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_group_id_permission_id_0cd325b0_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_group DROP CONSTRAINT IF EXISTS auth_group_name_key;
DROP TABLE IF EXISTS public.inventory_store;
DROP TABLE IF EXISTS public.inventory_saleitem;
DROP TABLE IF EXISTS public.inventory_sale;
DROP TABLE IF EXISTS public.inventory_product;
DROP TABLE IF EXISTS public.inventory_pricehistory;
DROP TABLE IF EXISTS public.inventory_inventoryitem;
DROP TABLE IF EXISTS public.inventory_inventorybatch;
DROP TABLE IF EXISTS public.inventory_crawlerlog;
DROP TABLE IF EXISTS public.django_session;
DROP TABLE IF EXISTS public.django_migrations;
DROP TABLE IF EXISTS public.django_content_type;
DROP TABLE IF EXISTS public.django_admin_log;
DROP TABLE IF EXISTS public.auth_user_user_permissions;
DROP TABLE IF EXISTS public.auth_user_groups;
DROP TABLE IF EXISTS public.auth_user;
DROP TABLE IF EXISTS public.auth_permission;
DROP TABLE IF EXISTS public.auth_group_permissions;
DROP TABLE IF EXISTS public.auth_group;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


--
-- Name: inventory_crawlerlog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_crawlerlog (
    id bigint NOT NULL,
    sku character varying(50) NOT NULL,
    status_code integer,
    error_message text,
    created_at timestamp with time zone NOT NULL,
    retry_count integer NOT NULL
);


--
-- Name: inventory_crawlerlog_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.inventory_crawlerlog ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.inventory_crawlerlog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: inventory_inventorybatch; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_inventorybatch (
    id bigint NOT NULL,
    quantity integer NOT NULL,
    batch_code character varying(50),
    expiration_date date,
    entry_date timestamp with time zone NOT NULL,
    item_id bigint NOT NULL
);


--
-- Name: inventory_inventorybatch_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.inventory_inventorybatch ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.inventory_inventorybatch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: inventory_inventoryitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_inventoryitem (
    id bigint NOT NULL,
    cost_price numeric(10,2) NOT NULL,
    sale_price numeric(10,2) NOT NULL,
    total_quantity integer NOT NULL,
    min_quantity integer NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    product_id bigint NOT NULL,
    store_id bigint NOT NULL
);


--
-- Name: inventory_inventoryitem_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.inventory_inventoryitem ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.inventory_inventoryitem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: inventory_pricehistory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_pricehistory (
    id bigint NOT NULL,
    price numeric(10,2) NOT NULL,
    captured_at timestamp with time zone NOT NULL,
    product_id bigint NOT NULL
);


--
-- Name: inventory_pricehistory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.inventory_pricehistory ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.inventory_pricehistory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: inventory_product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_product (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    bar_code character varying(50),
    natura_sku character varying(50),
    category character varying(100) NOT NULL,
    description text,
    image_url character varying(500),
    min_quantity integer NOT NULL,
    official_price numeric(10,2) NOT NULL,
    last_checked_price numeric(10,2),
    last_checked_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    CONSTRAINT inventory_product_min_quantity_check CHECK ((min_quantity >= 0))
);


--
-- Name: inventory_product_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.inventory_product ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.inventory_product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: inventory_sale; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_sale (
    id bigint NOT NULL,
    transaction_type character varying(20) NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    client_name character varying(100),
    payment_method character varying(50) NOT NULL,
    notes text,
    created_at timestamp with time zone NOT NULL,
    store_id bigint NOT NULL
);


--
-- Name: inventory_sale_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.inventory_sale ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.inventory_sale_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: inventory_saleitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_saleitem (
    id bigint NOT NULL,
    quantity integer NOT NULL,
    unit_price_sold numeric(10,2) NOT NULL,
    unit_cost_at_time numeric(10,2) NOT NULL,
    batch_id bigint,
    product_id bigint NOT NULL,
    sale_id bigint NOT NULL
);


--
-- Name: inventory_saleitem_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.inventory_saleitem ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.inventory_saleitem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: inventory_store; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_store (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(50) NOT NULL,
    whatsapp character varying(20),
    created_at timestamp with time zone NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: inventory_store_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.inventory_store ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.inventory_store_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	3	add_permission
6	Can change permission	3	change_permission
7	Can delete permission	3	delete_permission
8	Can view permission	3	view_permission
9	Can add group	2	add_group
10	Can change group	2	change_group
11	Can delete group	2	delete_group
12	Can view group	2	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add crawler log	7	add_crawlerlog
26	Can change crawler log	7	change_crawlerlog
27	Can delete crawler log	7	delete_crawlerlog
28	Can view crawler log	7	view_crawlerlog
29	Can add inventory item	9	add_inventoryitem
30	Can change inventory item	9	change_inventoryitem
31	Can delete inventory item	9	delete_inventoryitem
32	Can view inventory item	9	view_inventoryitem
33	Can add product	11	add_product
34	Can change product	11	change_product
35	Can delete product	11	delete_product
36	Can view product	11	view_product
37	Can add sale	12	add_sale
38	Can change sale	12	change_sale
39	Can delete sale	12	delete_sale
40	Can view sale	12	view_sale
41	Can add inventory batch	8	add_inventorybatch
42	Can change inventory batch	8	change_inventorybatch
43	Can delete inventory batch	8	delete_inventorybatch
44	Can view inventory batch	8	view_inventorybatch
45	Can add price history	10	add_pricehistory
46	Can change price history	10	change_pricehistory
47	Can delete price history	10	delete_pricehistory
48	Can view price history	10	view_pricehistory
49	Can add sale item	13	add_saleitem
50	Can change sale item	13	change_saleitem
51	Can delete sale item	13	delete_saleitem
52	Can view sale item	13	view_saleitem
53	Can add store	14	add_store
54	Can change store	14	change_store
55	Can delete store	14	delete_store
56	Can view store	14	view_store
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$1200000$TkEbkEJ6Jb6uxWrkDcRukf$dHe8PqX9Mlsyo+8wnI2MVpWlD/gVolHuFLtFaTOdKVw=	\N	t	admin			admin@example.com	t	t	2026-02-27 19:51:21.722699-03
2	pbkdf2_sha256$1200000$GCBtcHkFc1OQhkVgd1uWs8$6gTugJviwZ8ttdm+/DZqvR4s5GDvU1YfVxlkfO+TtMw=	\N	t	IgorGBarros			igorguimaraesbarros@gmail.com	t	t	2026-03-02 22:25:48.298826-03
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	group
3	auth	permission
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	inventory	crawlerlog
8	inventory	inventorybatch
9	inventory	inventoryitem
10	inventory	pricehistory
11	inventory	product
12	inventory	sale
13	inventory	saleitem
14	inventory	store
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2026-02-27 19:51:10.843186-03
2	auth	0001_initial	2026-02-27 19:51:10.90753-03
3	admin	0001_initial	2026-02-27 19:51:10.934011-03
4	admin	0002_logentry_remove_auto_add	2026-02-27 19:51:10.938012-03
5	admin	0003_logentry_add_action_flag_choices	2026-02-27 19:51:10.942004-03
6	contenttypes	0002_remove_content_type_name	2026-02-27 19:51:10.951013-03
7	auth	0002_alter_permission_name_max_length	2026-02-27 19:51:10.955026-03
8	auth	0003_alter_user_email_max_length	2026-02-27 19:51:10.959026-03
9	auth	0004_alter_user_username_opts	2026-02-27 19:51:10.963025-03
10	auth	0005_alter_user_last_login_null	2026-02-27 19:51:10.968027-03
11	auth	0006_require_contenttypes_0002	2026-02-27 19:51:10.969532-03
12	auth	0007_alter_validators_add_error_messages	2026-02-27 19:51:10.973543-03
13	auth	0008_alter_user_username_max_length	2026-02-27 19:51:10.982061-03
14	auth	0009_alter_user_last_name_max_length	2026-02-27 19:51:10.986053-03
15	auth	0010_alter_group_name_max_length	2026-02-27 19:51:10.991611-03
16	auth	0011_update_proxy_permissions	2026-02-27 19:51:10.994612-03
17	auth	0012_alter_user_first_name_max_length	2026-02-27 19:51:10.998612-03
18	inventory	0001_initial	2026-02-27 19:51:11.102443-03
19	sessions	0001_initial	2026-02-27 19:51:11.109444-03
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- Data for Name: inventory_crawlerlog; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_crawlerlog (id, sku, status_code, error_message, created_at, retry_count) FROM stdin;
\.


--
-- Data for Name: inventory_inventorybatch; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_inventorybatch (id, quantity, batch_code, expiration_date, entry_date, item_id) FROM stdin;
\.


--
-- Data for Name: inventory_inventoryitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_inventoryitem (id, cost_price, sale_price, total_quantity, min_quantity, updated_at, product_id, store_id) FROM stdin;
\.


--
-- Data for Name: inventory_pricehistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_pricehistory (id, price, captured_at, product_id) FROM stdin;
1	106.90	2026-02-27 20:14:54.071283-03	10
2	189.90	2026-02-27 20:17:28.248653-03	22
3	189.90	2026-02-27 20:18:22.06613-03	25
4	189.90	2026-02-27 20:20:00.442758-03	33
5	58.90	2026-02-27 20:20:53.414307-03	37
6	168.90	2026-02-27 20:22:14.391298-03	43
7	93.90	2026-02-27 20:23:21.023731-03	47
8	39.90	2026-02-27 20:25:18.832113-03	56
9	189.90	2026-02-27 20:25:32.663564-03	59
10	34.90	2026-02-27 20:25:46.36971-03	58
11	199.90	2026-02-27 20:26:01.369026-03	63
12	29.90	2026-02-27 20:26:57.923727-03	64
13	164.90	2026-02-27 20:28:00.025053-03	68
14	23.90	2026-02-27 20:28:14.809316-03	69
15	34.90	2026-02-27 20:29:07.298044-03	73
16	29.90	2026-02-27 20:29:21.704053-03	74
17	78.90	2026-02-27 20:30:14.189103-03	78
18	185.90	2026-02-27 20:30:49.856812-03	81
19	189.90	2026-02-27 20:30:59.695278-03	82
20	129.90	2026-02-27 20:31:27.054231-03	84
21	279.90	2026-02-27 20:32:03.946137-03	87
22	29.90	2026-02-27 20:32:32.020208-03	89
23	219.90	2026-02-28 12:09:12.382461-03	90
24	34.90	2026-02-28 12:09:52.836937-03	93
25	34.90	2026-02-28 12:10:59.901539-03	96
26	189.90	2026-02-28 12:11:14.129954-03	97
27	228.90	2026-02-28 12:11:27.620326-03	98
28	93.90	2026-02-28 12:11:41.178253-03	99
29	58.90	2026-02-28 12:12:11.262908-03	101
30	34.90	2026-02-28 12:12:30.655033-03	103
31	52.90	2026-02-28 12:12:50.469646-03	105
32	329.90	2026-02-28 12:13:01.692421-03	106
33	78.90	2026-02-28 12:13:15.009187-03	107
34	124.00	2026-02-28 12:14:31.121635-03	114
35	93.90	2026-02-28 12:15:14.191881-03	117
36	93.90	2026-02-28 12:15:27.448289-03	118
37	5.90	2026-02-28 12:15:53.187951-03	120
38	44.90	2026-02-28 12:16:22.004176-03	125
39	164.90	2026-02-28 12:17:18.772062-03	126
40	38.90	2026-02-28 12:17:31.637348-03	127
41	34.90	2026-02-28 12:18:32.725203-03	131
42	78.90	2026-02-28 12:19:09.778866-03	135
43	58.90	2026-02-28 12:19:49.990537-03	136
44	149.90	2026-02-28 12:26:18.831162-03	141
45	44.90	2026-02-28 12:26:31.433479-03	144
46	279.90	2026-02-28 12:27:28.93938-03	150
47	29.90	2026-02-28 12:27:55.503332-03	146
48	279.90	2026-02-28 12:28:07.922205-03	147
49	29.90	2026-02-28 12:28:23.267449-03	148
50	58.90	2026-02-28 12:29:58.785792-03	159
51	30.90	2026-02-28 12:31:43.230263-03	165
52	58.90	2026-02-28 12:31:55.906951-03	166
53	93.90	2026-02-28 12:32:08.222957-03	167
54	319.90	2026-02-28 12:32:21.509746-03	168
55	105.90	2026-02-28 12:32:49.205353-03	170
56	99.90	2026-02-28 12:33:35.149868-03	173
57	29.90	2026-02-28 12:33:50.392846-03	174
58	93.90	2026-02-28 12:34:53.14824-03	178
59	44.90	2026-02-28 12:35:07.138577-03	183
60	41.90	2026-02-28 12:36:07.122395-03	184
61	58.90	2026-02-28 12:36:21.431038-03	185
62	58.90	2026-02-28 12:36:51.916465-03	187
63	31.40	2026-02-28 13:01:55.668389-03	193
64	185.90	2026-02-28 13:02:27.200014-03	195
65	45.90	2026-02-28 13:03:18.916306-03	199
66	35.90	2026-02-28 13:04:35.987032-03	203
67	13.10	2026-02-28 13:05:00.185498-03	205
68	93.90	2026-02-28 13:05:35.413738-03	208
69	106.90	2026-02-28 13:05:49.07113-03	209
70	95.90	2026-02-28 13:06:55.176122-03	214
71	319.90	2026-02-28 13:07:25.60768-03	216
72	49.90	2026-02-28 13:07:42.837753-03	217
73	59.90	2026-02-28 13:08:16.478641-03	220
74	56.90	2026-02-28 13:08:42.370832-03	222
75	44.90	2026-02-28 13:10:59.05953-03	232
76	34.90	2026-02-28 13:11:14.423848-03	233
77	27.90	2026-02-28 13:11:39.538616-03	237
78	395.00	2026-02-28 13:12:13.895651-03	238
79	38.90	2026-03-05 08:30:16.023338-03	243
80	41.90	2026-03-05 08:30:50.904577-03	241
81	164.90	2026-03-05 08:31:23.312785-03	246
82	124.00	2026-03-05 08:31:33.975944-03	247
83	213.90	2026-03-05 08:31:43.292332-03	248
84	44.90	2026-03-05 08:32:24.240746-03	251
85	37.90	2026-03-05 08:32:46.366421-03	253
86	119.00	2026-03-05 08:33:04.366855-03	254
87	41.90	2026-03-05 08:33:19.073622-03	255
88	29.90	2026-03-05 08:34:35.530477-03	260
89	29.90	2026-03-05 08:34:50.773457-03	261
90	137.90	2026-03-05 08:35:13.851474-03	263
91	395.00	2026-03-05 08:36:19.440288-03	268
92	47.90	2026-03-05 08:36:34.817696-03	269
93	124.00	2026-03-05 08:36:55.257233-03	271
94	213.90	2026-03-05 08:37:08.630358-03	272
95	219.90	2026-03-05 08:37:30.456792-03	274
96	228.90	2026-03-05 08:37:48.114434-03	275
97	108.00	2026-03-05 08:38:04.291001-03	276
98	149.90	2026-03-05 08:39:17.883347-03	282
99	39.90	2026-03-05 08:39:31.37471-03	283
100	58.90	2026-03-05 08:39:57.66333-03	285
101	27.90	2026-03-05 08:40:46.085444-03	289
102	50.90	2026-03-05 08:41:11.448134-03	290
103	29.90	2026-03-05 08:42:30.178725-03	296
104	489.90	2026-03-05 08:43:30.371471-03	301
105	93.90	2026-03-05 08:43:45.560069-03	302
106	79.90	2026-03-05 08:45:04.78544-03	306
107	44.90	2026-03-05 08:45:19.9334-03	307
108	30.90	2026-03-05 08:45:34.074883-03	308
109	99.90	2026-03-05 08:45:48.10327-03	309
110	44.90	2026-03-05 08:45:57.745848-03	310
111	395.00	2026-03-05 08:46:10.811665-03	311
112	28.90	2026-03-05 08:46:40.348611-03	313
113	38.90	2026-03-05 08:46:50.66427-03	314
114	38.40	2026-03-05 08:47:47.175794-03	322
115	29.90	2026-03-05 08:48:33.817249-03	321
116	52.90	2026-03-05 09:30:32.562195-03	335
117	119.90	2026-03-05 09:30:42.681584-03	332
118	164.90	2026-03-05 09:31:00.909607-03	333
119	134.90	2026-03-05 09:31:28.4963-03	334
120	125.90	2026-03-05 09:31:53.970482-03	340
121	82.00	2026-03-05 09:32:33.778535-03	338
122	129.90	2026-03-05 09:32:50.64455-03	337
123	93.90	2026-03-05 09:33:05.053514-03	343
124	37.90	2026-03-05 09:33:46.71958-03	345
125	37.50	2026-03-05 09:33:56.249041-03	344
126	38.40	2026-03-05 09:34:10.340598-03	347
127	38.90	2026-03-05 09:34:32.930771-03	349
128	55.90	2026-03-05 10:32:25.77845-03	363
129	23.90	2026-03-05 10:32:40.543849-03	364
130	45.90	2026-03-05 10:32:58.248321-03	365
131	40.60	2026-03-05 10:33:48.540938-03	367
132	59.90	2026-03-05 10:35:00.124498-03	372
133	30.90	2026-03-05 10:37:29.587689-03	381
134	395.00	2026-03-05 10:38:43.009396-03	385
135	78.90	2026-03-05 10:40:26.481852-03	391
136	49.90	2026-03-05 10:40:38.365679-03	392
137	94.90	2026-03-05 10:40:51.146546-03	394
138	116.90	2026-03-05 10:41:16.118457-03	393
139	41.90	2026-03-05 10:42:09.683825-03	398
140	189.90	2026-03-05 10:42:22.507094-03	402
141	23.90	2026-03-05 10:42:34.636799-03	401
142	75.90	2026-03-05 10:42:46.596477-03	400
143	52.90	2026-03-05 10:42:56.230466-03	399
144	59.90	2026-03-05 10:43:13.206484-03	407
145	79.90	2026-03-05 10:43:35.90114-03	404
146	210.00	2026-03-05 10:43:53.729049-03	406
147	59.90	2026-03-05 10:44:06.180411-03	405
148	69.90	2026-03-05 10:44:22.673053-03	408
149	52.90	2026-03-05 10:45:17.163119-03	412
150	44.90	2026-03-05 10:45:43.155138-03	413
151	50.90	2026-03-05 10:45:54.107205-03	414
152	55.90	2026-03-05 10:46:32.065328-03	418
153	23.90	2026-03-05 10:46:41.773104-03	419
154	50.90	2026-03-05 10:46:58.582855-03	420
155	169.90	2026-03-05 10:48:14.928313-03	425
156	23.90	2026-03-05 10:49:23.992605-03	429
157	116.90	2026-03-05 10:49:35.298537-03	430
158	79.90	2026-03-05 10:50:38.282353-03	435
159	105.90	2026-03-05 10:50:57.246317-03	436
160	89.90	2026-03-05 10:52:23.835035-03	442
161	55.90	2026-03-05 10:52:42.261031-03	443
162	36.90	2026-03-05 10:53:21.249158-03	445
163	51.90	2026-03-05 10:53:46.325619-03	447
164	129.90	2026-03-05 10:54:01.458121-03	448
165	49.90	2026-03-05 10:54:25.760704-03	453
166	29.90	2026-03-05 11:36:16.169186-03	458
167	55.90	2026-03-05 11:36:47.3301-03	460
168	167.00	2026-03-05 11:38:15.061986-03	468
169	52.90	2026-03-05 11:38:30.534007-03	466
170	39.80	2026-03-05 11:38:53.711305-03	469
171	189.90	2026-03-05 11:39:05.576227-03	470
172	99.90	2026-03-05 12:37:26.006795-03	486
173	29.90	2026-03-05 12:37:40.358978-03	487
174	50.90	2026-03-05 12:37:58.317842-03	488
175	79.90	2026-03-05 12:38:36.423856-03	491
176	29.90	2026-03-05 12:38:45.720294-03	492
177	144.00	2026-03-05 12:39:12.558057-03	494
178	50.90	2026-03-05 12:40:22.309143-03	499
179	59.90	2026-03-05 12:40:39.893064-03	500
180	44.90	2026-03-05 12:40:50.461864-03	501
181	209.90	2026-03-05 12:41:06.95584-03	502
182	279.90	2026-03-05 12:42:12.246628-03	506
183	12.40	2026-03-05 12:43:40.343306-03	511
184	43.90	2026-03-05 12:44:33.008359-03	516
185	65.90	2026-03-05 12:44:45.393807-03	515
186	38.90	2026-03-05 12:44:57.416626-03	517
187	112.90	2026-03-05 12:45:55.354192-03	520
188	129.90	2026-03-05 12:46:22.30534-03	522
189	136.00	2026-03-05 12:46:48.78582-03	528
190	37.90	2026-03-05 12:47:22.316959-03	525
191	29.90	2026-03-05 12:47:56.389051-03	527
192	185.00	2026-03-05 12:48:22.983667-03	530
193	69.90	2026-03-05 12:48:59.026368-03	532
194	59.90	2026-03-05 12:49:24.132284-03	533
195	56.90	2026-03-05 12:50:20.252241-03	538
196	35.90	2026-03-05 12:50:30.973586-03	537
197	45.90	2026-03-05 12:51:14.654194-03	540
198	23.90	2026-03-05 12:51:47.40644-03	542
199	28.90	2026-03-05 12:52:33.628207-03	545
200	114.90	2026-03-05 12:53:22.94646-03	547
201	56.90	2026-03-05 12:53:44.942891-03	550
202	55.90	2026-03-05 12:54:14.336396-03	553
203	59.90	2026-03-05 12:54:44.103943-03	554
204	23.90	2026-03-05 12:54:54.114004-03	555
205	250.00	2026-03-05 12:56:06.038085-03	562
206	38.40	2026-03-05 12:56:22.139805-03	561
207	38.40	2026-03-05 12:57:15.308028-03	567
208	209.90	2026-03-05 12:57:47.266359-03	564
209	39.90	2026-03-05 12:58:00.339364-03	571
210	58.90	2026-03-05 12:58:30.341709-03	568
211	132.00	2026-03-05 12:58:41.213886-03	572
212	59.90	2026-03-05 12:59:25.056265-03	573
213	89.90	2026-03-05 13:41:32.436736-03	584
214	49.90	2026-03-05 13:42:44.104146-03	589
215	49.90	2026-03-05 13:42:59.511632-03	590
216	213.90	2026-03-05 13:43:38.2681-03	593
217	159.90	2026-03-05 13:43:52.952166-03	594
218	112.90	2026-03-05 13:44:21.145212-03	596
\.


--
-- Data for Name: inventory_product; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_product (id, name, bar_code, natura_sku, category, description, image_url, min_quantity, official_price, last_checked_price, last_checked_at, created_at) FROM stdin;
2	Una Blush 75 ml	\N	128756	Geral	Una Blush 75 ml\nRef: 128756	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd9c69f1f/produto-joia/background/desktop/128756.jpg	5	0.00	0.00	2026-02-27 20:13:24.249435-03	2026-02-27 19:56:51.889678-03
6	Natura Homem Sagaz 100 ml	\N	81951	Homem	Natura Homem Sagaz 100 ml\nRef: 81951	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw07c342e4/produto-joia/background/desktop/81951.jpg	5	0.00	0.00	2026-02-27 20:14:04.784288-03	2026-02-27 19:56:51.897742-03
8	K Max Masculino 100 ml	\N	72468	Homem	K Max Masculino 100 ml\nRef: 72468	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9b260517/produto-joia/background/desktop/72468.jpg	5	0.00	0.00	2026-02-27 20:14:30.963754-03	2026-02-27 19:56:51.906089-03
10	Água de Colônia Mamãe e Bebê 100 ml	\N	92786	Perfumaria	Água de Colônia Mamãe e Bebê 100 ml\nRef: 92786	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1ef9ad2b/produto-joia/background/desktop/92786.jpg	5	106.90	106.90	2026-02-27 20:14:54.069406-03	2026-02-27 19:56:51.914405-03
12	Desodorante Antitranspirante em Creme Tododia Leite de Algodão	\N	96519	Corpo e Banho	Desodorante Antitranspirante em Creme Tododia Leite de Algodão\nRef: 96519	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7fc77cb7/produto-joia/background/desktop/96519.jpg	5	0.00	0.00	2026-02-27 20:15:39.846509-03	2026-02-27 19:56:51.914405-03
14	Humor Envolve 75 ml	\N	169821	Geral	Humor Envolve 75 ml\nRef: 169821	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwce1d2e96/produto-joia/background/desktop/169821.jpg	5	0.00	0.00	2026-02-27 20:16:10.078651-03	2026-02-27 19:56:51.922694-03
18	Desodorante Antitranspirante Roll-on Tododia Alecrim e Sálvia	\N	189414	Corpo e Banho	Desodorante Antitranspirante Roll-on Tododia Alecrim e Sálvia\nRef: 189414	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc0b1a042/produto-joia/background/desktop/189414.jpg	5	0.00	0.00	2026-02-27 20:16:44.339304-03	2026-02-27 19:56:51.936097-03
22	Kaiak Feminino 100 ml	\N	108407	Geral	Kaiak Feminino 100 ml\nRef: 108407	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2f3766a4/produto-joia/background/desktop/108407.jpg	5	189.90	189.90	2026-02-27 20:17:28.245406-03	2026-02-27 19:56:51.941097-03
23	Ilía Completa 50 ml	\N	122470	Geral	Ilía Completa 50 ml\nRef: 122470	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw01758ab4/produto-joia/background/desktop/122470.jpg	5	0.00	0.00	2026-02-27 20:17:57.785658-03	2026-02-27 19:56:51.947735-03
25	Kaiak Urbe Masculino 100 ml	\N	108401	Homem	Kaiak Urbe Masculino 100 ml\nRef: 108401	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8ab3bacb/produto-joia/background/desktop/108401.jpg	5	189.90	189.90	2026-02-27 20:18:22.06613-03	2026-02-27 19:56:58.643559-03
28	Sabonete em Barra Puro Vegetal Tododia Energia	\N	152302	Corpo e Banho	Sabonete em Barra Puro Vegetal Tododia Energia\nRef: 152302	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa887640e/produto-joia/background/desktop/152302.jpg	5	0.00	0.00	2026-02-27 20:18:56.353741-03	2026-02-27 19:56:58.652562-03
31	Kit Tododia Sabonetes em Barra com 4 Caixas	\N	220210	Corpo e Banho	Kit Tododia Sabonetes em Barra com 4 Caixas\nRef: 220210	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2b03ccf3/Produtos/NATBRA-220210_1.jpg	5	0.00	0.00	2026-02-27 20:19:34.14297-03	2026-02-27 19:56:58.66056-03
33	Kaiak Pulso Masculino 100 ml	\N	108403	Homem	Kaiak Pulso Masculino 100 ml\nRef: 108403	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7071203f/produto-joia/background/desktop/108403.jpg	5	189.90	189.90	2026-02-27 20:20:00.439586-03	2026-02-27 19:56:58.666563-03
36	Kit Desodorante Antitranspirante em Creme Tododia Leite de Algodão (2 unidades)	\N	216457	Corpo e Banho	Kit Desodorante Antitranspirante em Creme Tododia Leite de Algodão (2 unidades)\nRef: 216457	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe29853b4/produto-joia/background/desktop/216457.jpg	5	0.00	0.00	2026-02-27 20:20:41.382832-03	2026-02-27 19:56:58.67457-03
39	Meu Primeiro Humor Feminino 75 ml	\N	86723	Geral	Meu Primeiro Humor Feminino 75 ml\nRef: 86723	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6387a198/produto-joia/background/desktop/86723.png	5	0.00	0.00	2026-02-27 20:21:18.176679-03	2026-02-27 19:56:58.682568-03
41	Luna Nuit 75 ml	\N	204451	Geral	Luna Nuit 75 ml\nRef: 204451	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbd472d1e/produto-joia/background/desktop/204451.jpg	5	0.00	0.00	2026-02-27 20:21:52.547494-03	2026-02-27 19:56:58.688082-03
43	Shiraz Feminino 100 ml	\N	91733	Geral	Shiraz Feminino 100 ml\nRef: 91733	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw35d42975/produto-joia/background/desktop/91733.jpg	5	168.90	168.90	2026-02-27 20:22:14.388299-03	2026-02-27 19:56:58.694081-03
48	Ilía 50 ml	\N	54522	Geral	Ilía 50 ml\nRef: 54522	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw15c3e809/produto-joia/background/desktop/54522.png	5	0.00	0.00	2026-02-27 20:22:56.035466-03	2026-02-27 19:57:06.587452-03
46	Essencial Supreme Feminino 100 ml	\N	95563	Geral	Essencial Supreme Feminino 100 ml\nRef: 95563	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwafaa0d41/produto-joia/background/desktop/95563.jpg	5	0.00	0.00	2026-02-27 20:23:09.912054-03	2026-02-27 19:57:06.587452-03
54	Kit Sabonetes em Barra Tododia com 4 Caixas	\N	245770	Corpo e Banho	Kit Sabonetes em Barra Tododia com 4 Caixas\nRef: 245770	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw92c3c7fd/produto-joia/background/desktop/245770.jpg	5	0.00	0.00	2026-02-27 20:24:01.135282-03	2026-02-27 19:57:06.603002-03
52	Kit Desodorante Corporal Kaiak Clássico Masculino com Refil	\N	258116	Corpo e Banho	Kit Desodorante Corporal Kaiak Clássico Masculino com Refil\nRef: 258116	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8efe1125/produto-joia/background/desktop/258116.jpg	5	0.00	0.00	2026-02-27 20:24:28.115334-03	2026-02-27 19:57:06.59551-03
55	Essencial Sentir Feminino 100 ml	\N	167756	Geral	Essencial Sentir Feminino 100 ml\nRef: 167756	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbef32ce4/produto-joia/background/desktop/167756.jpg	5	0.00	0.00	2026-02-27 20:24:55.063762-03	2026-02-27 19:57:06.604009-03
58	Sabonete em Barra Tododia Todanoite	\N	121969	Corpo e Banho	Sabonete em Barra Tododia Todanoite\nRef: 121969	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw49e6f532/produto-joia/background/desktop/121969.jpg	5	34.90	34.90	2026-02-27 20:25:46.36971-03	2026-02-27 19:57:06.604009-03
61	Essencial Atrai Masculino 100 ml	\N	165811	Homem	Essencial Atrai Masculino 100 ml\nRef: 165811	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwad30fab4/produto-joia/background/desktop/165811_.jpg	5	0.00	0.00	2026-02-27 20:26:34.189648-03	2026-02-27 19:57:06.612231-03
64	Desodorante Antitranspirante Roll-on Erva Doce	\N	189412	Corpo e Banho	Desodorante Antitranspirante Roll-on Erva Doce\nRef: 189412	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc7f8d53b/produto-joia/background/desktop/189412.jpg	5	29.90	29.90	2026-02-27 20:26:57.92169-03	2026-02-27 19:57:06.612231-03
65	Una Brilho 75 ml	\N	156118	Geral	Una Brilho 75 ml\nRef: 156118	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc09b2b3c/produto-joia/background/desktop/156118.jpg	5	0.00	0.00	2026-02-27 20:27:45.58533-03	2026-02-27 19:57:06.620512-03
69	Batom Matte Faces 3,5g	\N	77992	Maquiagem	Batom Matte Faces 3,5g\nRef: 77992	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw038bc66f/produto-joia/background/desktop/PAI77992.jpg	5	23.90	23.90	2026-02-27 20:28:14.809316-03	2026-02-27 19:57:14.049977-03
71	Revelar 75 ml	\N	77466	Geral	Revelar 75 ml\nRef: 77466	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw90c171b6/produto-joia/background/desktop/77466.jpg	5	0.00	0.00	2026-02-27 20:28:38.252255-03	2026-02-27 19:57:14.0542-03
73	Sabonete em Barra Puro Vegetal Tododia Algodão	\N	2830	Corpo e Banho	Sabonete em Barra Puro Vegetal Tododia Algodão\nRef: 2830	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcc7941ff/produto-joia/background/desktop/2830.jpg	5	34.90	34.90	2026-02-27 20:29:07.298044-03	2026-02-27 19:57:14.057201-03
76	Óleo Trifásico Desodorante Corporal Maracujá	\N	159910	Corpo e Banho	Óleo Trifásico Desodorante Corporal Maracujá\nRef: 159910	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwad774c7c/produto-joia/background/desktop/159910.jpg	5	0.00	0.00	2026-02-27 20:29:46.370298-03	2026-02-27 19:57:14.061503-03
79	Kit Kaiak Clássico e Pulso (2 unidades)	\N	258117	Geral	Kit Kaiak Clássico e Pulso (2 unidades)\nRef: 258117	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw05bcc02c/produto-joia/background/desktop/258117.jpg	5	0.00	0.00	2026-02-27 20:30:27.808948-03	2026-02-27 19:57:14.0655-03
81	Luna Radiante 75 ml	\N	2550	Geral	Luna Radiante 75 ml\nRef: 2550	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw82fa36b2/produto-joia/background/desktop/2550.jpg	5	185.90	185.90	2026-02-27 20:30:49.856812-03	2026-02-27 19:57:14.068481-03
84	Ekos Frescor Maracujá 150 ml	\N	73564	Geral	Ekos Frescor Maracujá 150 ml\nRef: 73564	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbc413433/produto-joia/background/desktop/73564.jpg	5	129.90	129.90	2026-02-27 20:31:27.052078-03	2026-02-27 19:57:14.072777-03
86	Águas Jabuticaba Feminino 170 ml	\N	95643	Geral	Águas Jabuticaba Feminino 170 ml\nRef: 95643	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1b9fbfdd/produto-joia/background/desktop/95643.jpg	5	0.00	0.00	2026-02-27 20:31:52.067499-03	2026-02-27 19:57:14.075774-03
88	Creme Hidratante para as Mãos Ekos Castanha	\N	95133	Corpo e Banho	Creme Hidratante para as Mãos Ekos Castanha\nRef: 95133	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5668d3ab/produto-joia/background/desktop/95133.jpg	5	0.00	0.00	2026-02-27 20:32:19.536282-03	2026-02-27 19:57:14.079174-03
91	Urbano 100 ml	\N	184485	Geral	Urbano 100 ml\nRef: 184485	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw599c7f9f/produto-joia/background/desktop/184485.jpg	5	0.00	0.00	2026-02-28 12:09:20.798895-03	2026-02-27 19:57:14.083178-03
94	Kit Biografia Masculino Desodorante Corporal com Refil (2 produtos)	\N	204416	Corpo e Banho	Kit Biografia Masculino Desodorante Corporal com Refil (2 produtos)\nRef: 204416	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0211ef7a/NATBRA-204416_1.jpg	5	0.00	0.00	2026-02-28 12:10:01.751894-03	2026-02-27 19:57:22.023387-03
96	Sabonete em Barra Puro Vegetal Tododia Amora e Flor de Pêssego	\N	181138	Corpo e Banho	Sabonete em Barra Puro Vegetal Tododia Amora e Flor de Pêssego\nRef: 181138	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe033fd7f/produto-joia/background/desktop/181138.jpg	5	34.90	34.90	2026-02-28 12:10:59.898576-03	2026-02-27 19:57:22.027941-03
99	Body Splash Tododia Amora e Flor de Pêssego 200 ml	\N	181136	Geral	Body Splash Tododia Amora e Flor de Pêssego 200 ml\nRef: 181136	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcd279e7c/produto-joia/background/desktop/181136.jpg	5	93.90	93.90	2026-02-28 12:11:41.175143-03	2026-02-27 19:57:22.034296-03
102	Hoje Masculino 100 ml	\N	13692	Homem	Hoje Masculino 100 ml\nRef: 13692	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/pt_BR/v1772227859118/produto-joia/background/desktop/.jpg	5	0.00	0.00	2026-02-28 12:12:21.271228-03	2026-02-27 19:57:22.039564-03
104	Presente Natura Luna Nuit (2 produtos)	\N	239800	Geral	Presente Natura Luna Nuit (2 produtos)\nRef: 239800	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdb6bd905/produto-joia/background/desktop/239800.jpg	5	0.00	0.00	2026-02-28 12:12:41.594933-03	2026-02-27 19:57:22.042341-03
106	Natura Aura Alba 75 ml	\N	178907	Geral	Natura Aura Alba 75 ml\nRef: 178907	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw90eb6ca8/produto-joia/background/desktop/178907.jpg	5	329.90	329.90	2026-02-28 12:13:01.68966-03	2026-02-27 19:57:22.044569-03
109	Desodorante Corporal Biografia Masculino	\N	88454	Corpo e Banho	Desodorante Corporal Biografia Masculino\nRef: 88454	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2691426e/produto-joia/background/desktop/88454.jpg	5	0.00	0.00	2026-02-28 12:13:38.060313-03	2026-02-27 19:57:22.048571-03
111	Sabonete Mamãe e Bebê	\N	92795	Corpo e Banho	Sabonete Mamãe e Bebê\nRef: 92795	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw81844b8f/produto-joia/background/desktop/92795.jpg	5	0.00	0.00	2026-02-28 12:13:57.499107-03	2026-02-27 19:57:22.051888-03
113	Luna Absoluta 75 ml	\N	56417	Geral	Luna Absoluta 75 ml\nRef: 56417	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw325519d9/produto-joia/background/desktop/56417.jpg	5	0.00	0.00	2026-02-28 12:14:22.053232-03	2026-02-27 19:57:22.05489-03
116	Creme Desodorante Hidratante para o Corpo Ekos Castanha	\N	203401	Corpo e Banho	Creme Desodorante Hidratante para o Corpo Ekos Castanha\nRef: 203401	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw09a41dea/produto-joia/background/desktop/203401.jpg	5	0.00	0.00	2026-02-28 12:14:59.225246-03	2026-02-27 19:57:22.058886-03
120	Sacola de Presente P com Laço	\N	161148	Geral	Sacola de Presente P com Laço\nRef: 161148	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0dac4ea9/produto-joia/background/desktop/161148.jpg	5	5.90	5.90	2026-02-28 12:15:53.184943-03	2026-02-27 19:57:30.883707-03
125	Refil Desodorante Corporal Kaiak Masculino	\N	56948	Corpo e Banho	Refil Desodorante Corporal Kaiak Masculino\nRef: 56948	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe9d1c8ee/Produtos/NATBRA-56948_1.jpg	5	44.90	44.90	2026-02-28 12:16:22.000669-03	2026-02-27 19:57:30.892087-03
123	Kriska 100 ml	\N	41795	Geral	Kriska 100 ml\nRef: 41795	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8b22a81f/produto-joia/background/desktop/41795.jpg	5	0.00	0.00	2026-02-28 12:16:47.20289-03	2026-02-27 19:57:30.892087-03
127	Refil Shampoo Lumina Restaurador para Restauração e Liso Prolongado	\N	167294	Cabelos	Refil Shampoo Lumina Restaurador para Restauração e Liso Prolongado\nRef: 167294	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa9f7f850/produto-joia/background/desktop/167294.jpg	5	38.90	38.90	2026-02-28 12:17:31.634335-03	2026-02-27 19:57:30.900368-03
130	Sérum Intensivo Lifting e Firmeza Chronos Derma	\N	169247	Geral	Sérum Intensivo Lifting e Firmeza Chronos Derma\nRef: 169247	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe3463c00/produto-joia/background/desktop/169247.jpg	5	0.00	0.00	2026-02-28 12:18:17.238696-03	2026-02-27 19:57:30.900368-03
133	Biografia Masculino 100 ml	\N	71601	Homem	Biografia Masculino 100 ml\nRef: 71601	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc783c443/produto-joia/background/desktop/71601.jpg	5	0.00	0.00	2026-02-28 12:18:45.112433-03	2026-02-27 19:57:30.90866-03
132	Luna Liberdade	\N	169776	Geral	Luna Liberdade\nRef: 169776	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw36ee9139/produto-joia/background/desktop/169776.jpg	5	0.00	0.00	2026-02-28 12:19:28.204766-03	2026-02-27 19:57:30.90866-03
137	Spray Hidratante Tododia Maçã Verde e Aloe Vera 200 ml	\N	156235	Corpo e Banho	Spray Hidratante Tododia Maçã Verde e Aloe Vera 200 ml\nRef: 156235	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7bd0f478/produto-joia/background/desktop/156235.jpg	5	0.00	0.00	2026-02-28 12:20:01.877018-03	2026-02-27 19:57:30.917092-03
140	Combo Desodorante Antitranspirante em Creme Erva Doce	\N	110688	Corpo e Banho	Combo Desodorante Antitranspirante em Creme Erva Doce\nRef: 110688	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc56b3f88/Produtos/NATBRA-110688_1.jpg	5	0.00	0.00	2026-02-28 12:25:50.017217-03	2026-02-27 19:57:30.917092-03
141	Creme Aveludado Corporal Natura Aura Alba	\N	180310	Corpo e Banho	Creme Aveludado Corporal Natura Aura Alba\nRef: 180310	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw98396b83/produto-joia/background/desktop/180310.jpg	5	149.90	149.90	2026-02-28 12:26:18.82816-03	2026-02-27 19:57:38.832612-03
145	Desodorante Corporal Sr. N	\N	85393	Corpo e Banho	Desodorante Corporal Sr. N\nRef: 85393	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw04c46c2a/produto-joia/background/desktop/85393.jpg	5	0.00	0.00	2026-02-28 12:27:00.181319-03	2026-02-27 19:57:38.847326-03
150	Essencial Exclusivo Floral Feminino 100 ml	\N	95575	Geral	Essencial Exclusivo Floral Feminino 100 ml\nRef: 95575	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5c64becb/produto-joia/background/desktop/95575.jpg	5	279.90	279.90	2026-02-28 12:27:28.935695-03	2026-02-27 19:57:38.8565-03
148	Refil Shampoo para Cabelos Lisos e Ondulados Naturé	\N	102396	Cabelos	Refil Shampoo para Cabelos Lisos e Ondulados Naturé\nRef: 102396	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb2798550/produto-joia/background/desktop/102396.jpg	5	29.90	29.90	2026-02-28 12:28:23.264447-03	2026-02-27 19:57:38.849144-03
154	Natura Homem Absoluto 100 ml	\N	204676	Homem	Natura Homem Absoluto 100 ml\nRef: 204676	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9b08f026/produto-joia/background/desktop/204676.jpg	5	0.00	0.00	2026-02-28 12:29:03.147558-03	2026-02-27 19:57:38.857545-03
152	Frasqueira Mamãe e Bebê	\N	173328	Infantil	Frasqueira Mamãe e Bebê\nRef: 173328	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe7c5a042/produto-joia/background/desktop/173328.jpg	5	0.00	0.00	2026-02-28 12:29:31.79481-03	2026-02-27 19:57:38.857545-03
156	Sabonete Líquido Sem Fragrância da Cabeça aos Pés Mamãe e Bebê	\N	106422	Corpo e Banho	Sabonete Líquido Sem Fragrância da Cabeça aos Pés Mamãe e Bebê\nRef: 106422	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw66b31037/produto-joia/background/desktop/106422.jpg	5	0.00	0.00	2026-02-28 12:30:10.333717-03	2026-02-27 19:57:38.865904-03
161	Creme Hidratante para os Pés Ekos Castanha	\N	69817	Corpo e Banho	Creme Hidratante para os Pés Ekos Castanha\nRef: 69817	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw475fa2ab/produto-joia/background/desktop/69817.jpg	5	0.00	0.00	2026-02-28 12:30:57.776102-03	2026-02-27 19:57:38.874307-03
163	Creme Hidratante para as Mãos Ekos Castanha	\N	70983	Corpo e Banho	Creme Hidratante para as Mãos Ekos Castanha\nRef: 70983	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb4dc041a/produto-joia/background/desktop/70983.jpg	5	0.00	0.00	2026-02-28 12:31:17.194798-03	2026-02-27 19:57:38.874307-03
166	Refil Creme Desodorante Nutritivo para o Corpo Tododia Algodão	\N	2817	Corpo e Banho	Refil Creme Desodorante Nutritivo para o Corpo Tododia Algodão\nRef: 2817	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4031379f/produto-joia/background/desktop/2817.jpg	5	58.90	58.90	2026-02-28 12:31:55.905029-03	2026-02-27 19:57:48.131242-03
168	Una Artisan 75 ml	\N	169373	Geral	Una Artisan 75 ml\nRef: 169373	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf2fca509/produto-joia/background/desktop/169373.jpg	5	319.90	319.90	2026-02-28 12:32:21.507733-03	2026-02-27 19:57:48.137265-03
171	Shampoo Mamãe Bebê	\N	92790	Cabelos	Shampoo Mamãe Bebê\nRef: 92790	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbc632d27/produto-joia/background/desktop/92790.jpg	5	0.00	0.00	2026-02-28 12:33:05.290209-03	2026-02-27 19:57:48.141345-03
173	Colônia Naturé Corre Corre 100 ml	\N	128757	Perfumaria	Colônia Naturé Corre Corre 100 ml\nRef: 128757	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe2c205f4/NATBRA-128757_1.jpg	5	99.90	99.90	2026-02-28 12:33:35.145854-03	2026-02-27 19:57:48.145352-03
177	Kit Kaiak Pulso (2 unidades)	\N	258112	Geral	Kit Kaiak Pulso (2 unidades)\nRef: 258112	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7acb2163/produto-joia/background/desktop/258112.jpg	5	0.00	0.00	2026-02-28 12:34:32.229217-03	2026-02-27 19:57:48.149532-03
179	Natura Homem Neo Deo Parfum 100 ml	\N	110816	Perfumaria	Natura Homem Neo Deo Parfum 100 ml\nRef: 110816	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe7631131/produto-joia/background/desktop/110816.jpg	5	0.00	0.00	2026-02-28 12:35:18.383703-03	2026-02-27 19:57:48.155796-03
182	Hidratante Corporal Natura Naturé	\N	106496	Corpo e Banho	Hidratante Corporal Natura Naturé\nRef: 106496	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw23c70c37/produto-joia/background/desktop/106496.jpg	5	0.00	0.00	2026-02-28 12:35:54.76726-03	2026-02-27 19:57:48.155796-03
186	Kit Tododia Antioleosidade e Sabonete (3 produtos)	\N	244444	Corpo e Banho	Kit Tododia Antioleosidade e Sabonete (3 produtos)\nRef: 244444	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3d2ae9fe/produto-joia/background/desktop/244444.jpg	5	0.00	0.00	2026-02-28 12:36:36.713202-03	2026-02-27 19:57:48.168309-03
188	Presente Natura Ilía Ser (2 produtos)	\N	239790	Geral	Presente Natura Ilía Ser (2 produtos)\nRef: 239790	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3cbdf842/produto-joia/background/desktop/239790.jpg	5	0.00	0.00	2026-02-28 12:37:02.535038-03	2026-02-27 19:58:01.66314-03
190	Kit Lumina para Restauração e Liso Prolongado (4 produtos)	\N	221670	Geral	Kit Lumina para Restauração e Liso Prolongado (4 produtos)\nRef: 221670	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcdb9d8dc/produto-joia/background/desktop/221670.jpg	5	0.00	0.00	2026-02-28 13:01:19.285532-03	2026-02-27 19:58:01.669097-03
193	Sabonete em Barra Puro Vegetal Mamãe e Bebê (2 unidades)	\N	92796	Corpo e Banho	Sabonete em Barra Puro Vegetal Mamãe e Bebê (2 unidades)\nRef: 92796	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw022dead3/Produtos/NATBRA-92796_1.jpg	5	31.40	31.40	2026-02-28 13:01:55.66588-03	2026-02-27 19:58:01.677995-03
195	Luna Confiante 75 ml	\N	102038	Geral	Luna Confiante 75 ml\nRef: 102038	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw28a3ef76/produto-joia/background/desktop/102038.jpg	5	185.90	185.90	2026-02-28 13:02:27.197445-03	2026-02-27 19:58:01.682558-03
199	Refil Shampoo Ekos Patauá	\N	112766	Cabelos	Refil Shampoo Ekos Patauá\nRef: 112766	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6785de59/produto-joia/background/desktop/112766.jpg	5	45.90	45.90	2026-02-28 13:03:18.914305-03	2026-02-27 19:58:01.689882-03
201	Sacola de Presente Mini com Laço	\N	161146	Geral	Sacola de Presente Mini com Laço\nRef: 161146	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3fbdae6d/produto-joia/background/desktop/161146.jpg	5	0.00	0.00	2026-02-28 13:04:08.0336-03	2026-02-27 19:58:01.692884-03
203	Shampoo Reparador Tododia Flor de Cereja e Abacate 300 ml	\N	155601	Cabelos	Shampoo Reparador Tododia Flor de Cereja e Abacate 300 ml\nRef: 155601	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbc1a5904/produto-joia/background/desktop/155601.jpg	5	35.90	35.90	2026-02-28 13:04:35.985039-03	2026-02-27 19:58:01.696081-03
206	Desodorante Corporal Meu Primeiro Humor Feminino	\N	56744	Corpo e Banho	Desodorante Corporal Meu Primeiro Humor Feminino\nRef: 56744	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc2a08cd4/produto-joia/background/desktop/56744.jpg	5	0.00	0.00	2026-02-28 13:05:11.731189-03	2026-02-27 19:58:01.700081-03
208	Body Splash Tododia Algodão 200 ml	\N	72221	Geral	Body Splash Tododia Algodão 200 ml\nRef: 72221	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2d237b5f/produto-joia/background/desktop/72221.jpg	5	93.90	93.90	2026-02-28 13:05:35.41074-03	2026-02-27 19:58:01.703393-03
211	Batom Multimix Cremoso Faces	\N	116201	Maquiagem	Batom Multimix Cremoso Faces\nRef: 116201	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw000194ec/produto-joia/background/desktop/PAI116187.jpg	5	0.00	0.00	2026-02-28 13:06:19.123075-03	2026-02-27 19:58:01.707471-03
213	Essencial Feminino Miniatura 25 ml	\N	108938	Geral	Essencial Feminino Miniatura 25 ml\nRef: 108938	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa95b1dae/NATBRA-108938_1.jpg	5	0.00	0.00	2026-02-28 13:06:43.666638-03	2026-02-27 19:58:09.47806-03
216	Natura Homem Cor.agio 100 ml	\N	89834	Homem	Natura Homem Cor.agio 100 ml\nRef: 89834	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw39ac62a2/produto-joia/background/desktop/89834.jpg	5	319.90	319.90	2026-02-28 13:07:25.604448-03	2026-02-27 19:58:09.485724-03
218	Kaiak Aventura Intensa Masculino 100 ml	\N	171117	Homem	Kaiak Aventura Intensa Masculino 100 ml\nRef: 171117	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8b470158/produto-joia/background/desktop/171117.jpg	5	0.00	0.00	2026-02-28 13:07:54.494766-03	2026-02-27 19:58:09.485724-03
221	Gel Creme Antissinais 45+ Dia	\N	134725	Corpo e Banho	Gel Creme Antissinais 45+ Dia\nRef: 134725	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw00e81d4b/produto-joia/background/desktop/134725.jpg	5	0.00	0.00	2026-02-28 13:08:29.536417-03	2026-02-27 19:58:09.494383-03
223	Creme Antissinais 60+ Dia	\N	134693	Corpo e Banho	Creme Antissinais 60+ Dia\nRef: 134693	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0bec8f90/produto-joia/background/desktop/134693.jpg	5	0.00	0.00	2026-02-28 13:09:00.629545-03	2026-02-27 19:58:09.498685-03
225	Refil Shampoo Equilibrante Antioleosidade	\N	147442	Cabelos	Refil Shampoo Equilibrante Antioleosidade\nRef: 147442	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6d583a7d/produto-joia/background/desktop/147442.jpg	5	0.00	0.00	2026-02-28 13:09:32.387345-03	2026-02-27 19:58:09.500688-03
228	Sérum Intensivo Antioxidante Chronos Derma	\N	169245	Geral	Sérum Intensivo Antioxidante Chronos Derma\nRef: 169245	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw02ac4551/produto-joia/background/desktop/169245.jpg	5	0.00	0.00	2026-02-28 13:10:05.123526-03	2026-02-27 19:58:09.50267-03
230	Balm Redutor de Rugas para Olhos Chronos	\N	111332	Geral	Balm Redutor de Rugas para Olhos Chronos\nRef: 111332	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9b53cf13/NATBRA-111332_1.jpg	5	0.00	0.00	2026-02-28 13:10:32.664275-03	2026-02-27 19:58:09.50267-03
235	Natura Homem Aromáticos 100 ml	\N	167241	Homem	Natura Homem Aromáticos 100 ml\nRef: 167241	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd29262d3/produto-joia/background/desktop/167241.jpg	5	0.00	0.00	2026-02-28 13:11:50.653485-03	2026-02-27 19:58:16.685272-03
238	Natura Coleção Eau de Parfum 4 unidades de 10 ml cada​	\N	139034	Perfumaria	Natura Coleção Eau de Parfum 4 unidades de 10 ml cada​\nRef: 139034	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw684ef00c/produto-joia/background/desktop/139034.jpg	5	395.00	395.00	2026-02-28 13:12:13.893654-03	2026-02-27 19:58:16.685272-03
242	Sérum para Sobrancelhas Una	\N	140742	Geral	Sérum para Sobrancelhas Una\nRef: 140742	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0ee5a018/produto-joia/background/desktop/140742.jpg	5	0.00	0.00	2026-03-05 08:30:06.869835-03	2026-02-27 19:58:16.695301-03
244	Sérum Noturno Antiqueda e Crescimento	\N	147427	Geral	Sérum Noturno Antiqueda e Crescimento\nRef: 147427	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw21948236/produto-joia/background/desktop/147427.jpg	5	0.00	0.00	2026-03-05 08:30:34.752794-03	2026-02-27 19:58:16.70087-03
246	Humor a Rigor Masculino 75 ml	\N	124197	Homem	Humor a Rigor Masculino 75 ml\nRef: 124197	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7f8b441c/produto-joia/background/desktop/124197.jpg	5	164.90	164.90	2026-03-05 08:31:23.306787-03	2026-02-27 19:58:16.701632-03
248	Refil Essencial Exclusivo Feminino 100 ml	\N	11681	Geral	Refil Essencial Exclusivo Feminino 100 ml\nRef: 11681	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwacce3f7e/produto-joia/background/desktop/11681.jpg	5	213.90	213.90	2026-03-05 08:31:43.288501-03	2026-02-27 19:58:16.701632-03
251	Refil Desodorante Corporal Sr. N	\N	85390	Corpo e Banho	Refil Desodorante Corporal Sr. N\nRef: 85390	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9b3e4b94/NATBRA-85390_1.jpg	5	44.90	44.90	2026-03-05 08:32:24.236222-03	2026-02-27 19:58:16.709977-03
253	Condicionador Reparador Tododia Flor de Cereja e Abacate 280 ml	\N	154876	Cabelos	Condicionador Reparador Tododia Flor de Cereja e Abacate 280 ml\nRef: 154876	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9d32e60b/produto-joia/background/desktop/154876.jpg	5	37.90	37.90	2026-03-05 08:32:46.36251-03	2026-02-27 19:58:16.709977-03
256	Desodorante Hidratante Corporal Perfumado Essencial Exclusivo	\N	16871	Corpo e Banho	Desodorante Hidratante Corporal Perfumado Essencial Exclusivo\nRef: 16871	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2b690410/produto-joia/background/desktop/16871.jpg	5	0.00	0.00	2026-03-05 08:33:37.621803-03	2026-02-27 19:58:25.141354-03
259	Kit Natura Homem Essence (3 produtos)	\N	217177	Homem	Kit Natura Homem Essence (3 produtos)\nRef: 217177	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcd0fa39b/produto-joia/background/desktop/217177.jpg	5	0.00	0.00	2026-03-05 08:34:23.402456-03	2026-02-27 19:58:25.149802-03
262	Body Splash Tododia Todanoite 200 ml	\N	159712	Geral	Body Splash Tododia Todanoite 200 ml\nRef: 159712	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb2ba8d38/produto-joia/background/desktop/159712.jpg	5	0.00	0.00	2026-03-05 08:35:04.106897-03	2026-02-27 19:58:25.150808-03
264	Refil Shampoo Estimulante Antiqueda e Crescimento	\N	147450	Cabelos	Refil Shampoo Estimulante Antiqueda e Crescimento\nRef: 147450	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa0fdc091/produto-joia/background/desktop/147450.jpg	5	0.00	0.00	2026-03-05 08:35:28.929326-03	2026-02-27 19:58:25.158765-03
266	Essencial Feminino 100 ml	\N	76421	Geral	Essencial Feminino 100 ml\nRef: 76421	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa15663ff/produto-joia/background/desktop/76421.jpg	5	0.00	0.00	2026-03-05 08:35:56.088678-03	2026-02-27 19:58:25.158765-03
269	Refil Sabonete para as Mãos	\N	28175	Corpo e Banho	Refil Sabonete para as Mãos\nRef: 28175	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbbad9979/NATBRA-28175_1.jpg	5	47.90	47.90	2026-03-05 08:36:34.814644-03	2026-02-27 19:58:25.166271-03
271	Refil Creme Antissinais 60+ Noite	\N	134587	Corpo e Banho	Refil Creme Antissinais 60+ Noite\nRef: 134587	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc4edf745/produto-joia/background/desktop/134587.jpg	5	124.00	124.00	2026-03-05 08:36:55.254234-03	2026-02-27 19:58:25.167114-03
273	Deo Parfum Essencial Desejos Masculino	\N	194227	Perfumaria	Deo Parfum Essencial Desejos Masculino\nRef: 194227	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw034c4d77/produto-joia/background/desktop/194227.jpg	5	0.00	0.00	2026-03-05 08:37:19.497192-03	2026-02-27 19:58:25.167114-03
276	Multiprotetor Antissinais FPS 50 FPUVA 18 Chronos Derma	\N	134189	Geral	Multiprotetor Antissinais FPS 50 FPUVA 18 Chronos Derma\nRef: 134189	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc2ad25b0/produto-joia/background/desktop/134189.jpg	5	108.00	108.00	2026-03-05 08:38:04.287408-03	2026-02-27 19:58:25.175347-03
280	Kit Sabonete Líquido Cremoso para o corpo Banho nas Nuvens Tododia Todanoite com Refil	\N	241068	Corpo e Banho	Kit Sabonete Líquido Cremoso para o corpo Banho nas Nuvens Tododia Todanoite com Refil\nRef: 241068	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw274d68c7/Produtos/NATBRA-241068_1.jpg	5	0.00	0.00	2026-03-05 08:38:43.064078-03	2026-02-27 19:58:33.774466-03
282	Protetor Solar Corporal FPS 70 Natura Solar	\N	176908	Geral	Protetor Solar Corporal FPS 70 Natura Solar\nRef: 176908	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwba1a26f6/produto-joia/background/desktop/176908.jpg	5	149.90	149.90	2026-03-05 08:39:17.881354-03	2026-02-27 19:58:33.78328-03
285	Creme de Pentear para Definição e Hidratação de Cabelos Cacheados	\N	148437	Cabelos	Creme de Pentear para Definição e Hidratação de Cabelos Cacheados\nRef: 148437	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5ef4941f/NATBRA-148437_1.jpg	5	58.90	58.90	2026-03-05 08:39:57.66033-03	2026-02-27 19:58:33.78328-03
288	Néctar Desodorante Hidratante para o Corpo Ekos Maracujá 400 ml	\N	159904	Corpo e Banho	Néctar Desodorante Hidratante para o Corpo Ekos Maracujá 400 ml\nRef: 159904	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd234a70d/Produtos/NATBRA-159904_1.jpg	5	0.00	0.00	2026-03-05 08:40:30.710376-03	2026-02-27 19:58:33.79473-03
290	Shampoo 2 em 1 Natura Homem	\N	151018	Cabelos	Shampoo 2 em 1 Natura Homem\nRef: 151018	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5eaf1c18/produto-joia/background/desktop/151018.jpg	5	50.90	50.90	2026-03-05 08:41:11.446134-03	2026-02-27 19:58:33.799361-03
324	Produto 174187	\N	174187	Geral	Descoberto em Todos os Produtos (Pág 16)	\N	5	0.00	\N	2026-02-27 19:58:49.1301-03	2026-02-27 19:58:49.1301-03
325	Produto 211662	\N	211662	Geral	Descoberto em Todos os Produtos (Pág 17)	\N	5	0.00	\N	2026-02-27 19:58:57.754121-03	2026-02-27 19:58:57.754121-03
326	Produto 69720	\N	69720	Geral	Descoberto em Todos os Produtos (Pág 17)	\N	5	0.00	\N	2026-02-27 19:58:57.754121-03	2026-02-27 19:58:57.754121-03
327	Produto 92952	\N	92952	Geral	Descoberto em Todos os Produtos (Pág 17)	\N	5	0.00	\N	2026-02-27 19:58:57.754121-03	2026-02-27 19:58:57.761679-03
328	Produto 38854	\N	38854	Geral	Descoberto em Todos os Produtos (Pág 17)	\N	5	0.00	\N	2026-02-27 19:58:57.763423-03	2026-02-27 19:58:57.763423-03
329	Produto 203397	\N	203397	Geral	Descoberto em Todos os Produtos (Pág 17)	\N	5	0.00	\N	2026-02-27 19:58:57.763423-03	2026-02-27 19:58:57.763423-03
330	Produto 26384	\N	26384	Geral	Descoberto em Todos os Produtos (Pág 17)	\N	5	0.00	\N	2026-02-27 19:58:57.763423-03	2026-02-27 19:58:57.763423-03
331	Produto 134590	\N	134590	Geral	Descoberto em Todos os Produtos (Pág 17)	\N	5	0.00	\N	2026-02-27 19:58:57.763423-03	2026-02-27 19:58:57.769765-03
294	Refil Condicionador Hidratante Tododia Maçã e Aloe Vera	\N	154860	Cabelos	Refil Condicionador Hidratante Tododia Maçã e Aloe Vera\nRef: 154860	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7d9f2263/produto-joia/background/desktop/154860.jpg	5	0.00	0.00	2026-03-05 08:42:04.813077-03	2026-02-27 19:58:33.806679-03
297	Kit Desodorante Antitranspirante Roll-On Natura Homem Clássico (3 unidades)	\N	213236	Corpo e Banho	Kit Desodorante Antitranspirante Roll-On Natura Homem Clássico (3 unidades)\nRef: 213236	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5b06b680/produto-joia/background/desktop/213236.jpg	5	0.00	0.00	2026-03-05 08:42:40.750303-03	2026-02-27 19:58:33.807572-03
299	Ilía Plena 50 ml	\N	112811	Geral	Ilía Plena 50 ml\nRef: 112811	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1e3e74be/produto-joia/background/desktop/112811.jpg	5	0.00	0.00	2026-03-05 08:43:04.343866-03	2026-02-27 19:58:33.815903-03
302	Body Splash Tododia Manga Rosa e Água de Coco 200 ml	\N	91204	Geral	Body Splash Tododia Manga Rosa e Água de Coco 200 ml\nRef: 91204	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe10221c7/produto-joia/background/desktop/91204.jpg	5	93.90	93.90	2026-03-05 08:43:45.556622-03	2026-02-27 19:58:49.088307-03
305	Creme para Pentear Mamãe e Bebê Cachinhos e Crespinhos	\N	167173	Corpo e Banho	Creme para Pentear Mamãe e Bebê Cachinhos e Crespinhos\nRef: 167173	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4f2bf3d4/produto-joia/background/desktop/167173.jpg	5	0.00	0.00	2026-03-05 08:44:47.996694-03	2026-02-27 19:58:49.097137-03
307	Refil Desodorante Corporal Luna	\N	89259	Corpo e Banho	Refil Desodorante Corporal Luna\nRef: 89259	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw664eba87/NATBRA-89259_1.jpg	5	44.90	44.90	2026-03-05 08:45:19.930438-03	2026-02-27 19:58:49.104786-03
310	Refil Desodorante Corporal Kaiak Oceano Masculino	\N	16626	Corpo e Banho	Refil Desodorante Corporal Kaiak Oceano Masculino\nRef: 16626	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw98dcfe17/NATBRA-16626_1.jpg	5	44.90	44.90	2026-03-05 08:45:57.741838-03	2026-02-27 19:58:49.104786-03
312	Desodorante Hidratante Corporal Perfumado Luna Liberdade	\N	177162	Corpo e Banho	Desodorante Hidratante Corporal Perfumado Luna Liberdade\nRef: 177162	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5fb5902a/produto-joia/background/desktop/177162.jpg	5	0.00	0.00	2026-03-05 08:46:24.126007-03	2026-02-27 19:58:49.112848-03
315	Shampoo Cachos e Crespos Tododia Amora e Óleo de Coco	\N	173588	Cabelos	Shampoo Cachos e Crespos Tododia Amora e Óleo de Coco\nRef: 173588	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc12d5c2e/produto-joia/background/desktop/173588.jpg	5	0.00	0.00	2026-03-05 08:47:05.200664-03	2026-02-27 19:58:49.113371-03
318	Desodorante Hidratante Corporal Luna Nuit	\N	204459	Corpo e Banho	Desodorante Hidratante Corporal Luna Nuit\nRef: 204459	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc333d77c/produto-joia/background/desktop/204459.jpg	5	0.00	0.00	2026-03-05 08:47:33.943491-03	2026-02-27 19:58:49.122097-03
320	Kit Shampoo e Condicionador Nutrição e Reparação	\N	167103	Cabelos	Kit Shampoo e Condicionador Nutrição e Reparação\nRef: 167103	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw276283d8/produto-joia/background/desktop/167103.jpg	5	0.00	0.00	2026-03-05 08:48:18.813495-03	2026-02-27 19:58:49.122097-03
323	Creme Preventivo de Assaduras Mamãe e Bebê	\N	97955	Corpo e Banho	Creme Preventivo de Assaduras Mamãe e Bebê\nRef: 97955	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd8621cc7/produto-joia/background/desktop/97955.jpg	5	0.00	0.00	2026-03-05 08:48:44.094327-03	2026-02-27 19:58:49.1301-03
333	Beijo de Humor Feminino 75 ml	\N	95947	Geral	Beijo de Humor Feminino 75 ml\nRef: 95947	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd5c521ca/produto-joia/background/desktop/95947.jpg	5	164.90	164.90	2026-03-05 09:31:00.905994-03	2026-02-27 19:58:57.770244-03
340	Protetor Solar Facial Stick FPS 50 Natura Solar	\N	178858	Geral	Protetor Solar Facial Stick FPS 50 Natura Solar\nRef: 178858	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfd29ca28/produto-joia/background/desktop/178858.jpg	5	125.90	125.90	2026-03-05 09:31:53.96621-03	2026-02-27 19:58:57.778565-03
339	Luna Coragem 75 ml	\N	115463	Geral	Luna Coragem 75 ml\nRef: 115463	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw22b6b177/produto-joia/background/desktop/115463.jpg	5	0.00	0.00	2026-03-05 09:32:21.549495-03	2026-02-27 19:58:57.778565-03
337	Ekos Frescor Castanha 150 ml	\N	73562	Geral	Ekos Frescor Castanha 150 ml\nRef: 73562	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9867af5b/produto-joia/background/desktop/73562.jpg	5	129.90	129.90	2026-03-05 09:32:50.640548-03	2026-02-27 19:58:57.778565-03
346	Refil Shampoo Ekos Murumuru	\N	112760	Cabelos	Refil Shampoo Ekos Murumuru\nRef: 112760	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0c0c7ed3/produto-joia/background/desktop/112760.jpg	5	0.00	0.00	2026-03-05 09:33:31.243108-03	2026-02-27 19:58:57.786936-03
344	Refil Máscara Concentrada Cronocapilar Tododia Nutre	\N	154863	Cabelos	Refil Máscara Concentrada Cronocapilar Tododia Nutre\nRef: 154863	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1f177ec2/produto-joia/background/desktop/154863.jpg	5	37.50	37.50	2026-03-05 09:33:56.246513-03	2026-02-27 19:58:57.786936-03
348	Batom CC Hidratante FPS 25 Una	\N	76643	Corpo e Banho	Batom CC Hidratante FPS 25 Una\nRef: 76643	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8944c0ec/Produtos/NATBRA-76643_1.jpg	5	0.00	0.00	2026-03-05 09:34:22.568583-03	2026-02-27 19:58:57.795237-03
350	Produto 154866	\N	154866	Geral	Descoberto em Todos os Produtos (Pág 18)	\N	5	0.00	\N	2026-02-27 19:59:04.632944-03	2026-02-27 19:59:04.632944-03
351	Produto 155604	\N	155604	Geral	Descoberto em Todos os Produtos (Pág 18)	\N	5	0.00	\N	2026-02-27 19:59:04.635655-03	2026-02-27 19:59:04.635655-03
352	Produto 169264	\N	169264	Geral	Descoberto em Todos os Produtos (Pág 18)	\N	5	0.00	\N	2026-02-27 19:59:04.635655-03	2026-02-27 19:59:04.635655-03
353	Produto 133863	\N	133863	Geral	Descoberto em Todos os Produtos (Pág 18)	\N	5	0.00	\N	2026-02-27 19:59:04.635655-03	2026-02-27 19:59:04.635655-03
354	Produto 113403	\N	113403	Geral	Descoberto em Todos os Produtos (Pág 18)	\N	5	0.00	\N	2026-02-27 19:59:04.635655-03	2026-02-27 19:59:04.643658-03
355	Produto 215269	\N	215269	Geral	Descoberto em Todos os Produtos (Pág 18)	\N	5	0.00	\N	2026-02-27 19:59:04.643658-03	2026-02-27 19:59:04.643658-03
356	Produto 108410	\N	108410	Geral	Descoberto em Todos os Produtos (Pág 18)	\N	5	0.00	\N	2026-02-27 19:59:04.643658-03	2026-02-27 19:59:04.648577-03
357	Produto 134697	\N	134697	Geral	Descoberto em Todos os Produtos (Pág 18)	\N	5	0.00	\N	2026-02-27 19:59:04.648577-03	2026-02-27 19:59:04.648577-03
358	Produto 147444	\N	147444	Geral	Descoberto em Todos os Produtos (Pág 18)	\N	5	0.00	\N	2026-02-27 19:59:04.650582-03	2026-02-27 19:59:04.65199-03
359	Produto 162097	\N	162097	Geral	Descoberto em Todos os Produtos (Pág 18)	\N	5	0.00	\N	2026-02-27 19:59:04.65199-03	2026-02-27 19:59:04.65199-03
360	Produto 137981	\N	137981	Geral	Descoberto em Todos os Produtos (Pág 18)	\N	5	0.00	\N	2026-02-27 19:59:04.655326-03	2026-02-27 19:59:04.655326-03
384	Produto 169785	\N	169785	Geral	Descoberto em Todos os Produtos (Pág 19)	\N	5	0.00	\N	2026-02-27 19:59:11.782186-03	2026-02-27 19:59:11.782186-03
364	Batom Matte Faces 3,5g	\N	77989	Maquiagem	Batom Matte Faces 3,5g\nRef: 77989	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw038bc66f/produto-joia/background/desktop/PAI77992.jpg	5	23.90	23.90	2026-03-05 10:32:40.539862-03	2026-02-27 19:59:04.660323-03
362	Sabonete em Barra Esfoliante Tododia Energia	\N	152301	Corpo e Banho	Sabonete em Barra Esfoliante Tododia Energia\nRef: 152301	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw65c70ac7/produto-joia/background/desktop/152301.jpg	5	0.00	0.00	2026-03-05 10:33:16.544361-03	2026-02-27 19:59:04.660323-03
368	Luna Fascinante 75 ml	\N	83008	Geral	Luna Fascinante 75 ml\nRef: 83008	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd0912575/produto-joia/background/desktop/83008.jpg	5	0.00	0.00	2026-03-05 10:34:01.983-03	2026-02-27 19:59:04.674884-03
370	Presente Natura Ekos Tukumã (2 produtos)	\N	210384	Geral	Presente Natura Ekos Tukumã (2 produtos)\nRef: 210384	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw78704227/produto-joia/background/desktop/210384.jpg	5	0.00	0.00	2026-03-05 10:34:29.039474-03	2026-02-27 19:59:04.678607-03
373	Kit Ilía Laços (2 unidades)	\N	258120	Geral	Kit Ilía Laços (2 unidades)\nRef: 258120	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw59fc6ed0/produto-joia/background/desktop/258120.jpg	5	0.00	0.00	2026-03-05 10:35:26.47234-03	2026-02-27 19:59:11.765766-03
375	Condicionador Cachos e Crespos Tododia Amora e Óleo de Coco	\N	173587	Cabelos	Condicionador Cachos e Crespos Tododia Amora e Óleo de Coco\nRef: 173587	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9a04b369/produto-joia/background/desktop/173587.jpg	5	0.00	0.00	2026-03-05 10:35:56.519212-03	2026-02-27 19:59:11.769035-03
378	Gel Creme Antissinais 45+ Noite	\N	135032	Corpo e Banho	Gel Creme Antissinais 45+ Noite\nRef: 135032	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4e05aa70/produto-joia/background/desktop/135032.jpg	5	0.00	0.00	2026-03-05 10:36:38.455713-03	2026-02-27 19:59:11.774061-03
380	Máscara Concentrada Crono Capilar Tododia Nutre	\N	154872	Cabelos	Máscara Concentrada Crono Capilar Tododia Nutre\nRef: 154872	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0fedd1b7/produto-joia/background/desktop/154872.jpg	5	0.00	0.00	2026-03-05 10:37:13.202471-03	2026-02-27 19:59:11.777187-03
383	Bruma Facial Hidratante Fixadora Una	\N	153720	Corpo e Banho	Bruma Facial Hidratante Fixadora Una\nRef: 153720	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb2493629/Produtos/NATBRA-153720_1.jpg	5	0.00	0.00	2026-03-05 10:38:13.407153-03	2026-02-27 19:59:11.781187-03
386	Águas Violeta Feminino 170 ml	\N	95642	Geral	Águas Violeta Feminino 170 ml\nRef: 95642	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw234046ef/produto-joia/background/desktop/95642.jpg	5	0.00	0.00	2026-03-05 10:38:58.672537-03	2026-02-27 19:59:11.786494-03
389	Kit Sabonete Líquido da Cabeça aos Pés Mamãe e Bebê com Refil	\N	216456	Corpo e Banho	Kit Sabonete Líquido da Cabeça aos Pés Mamãe e Bebê com Refil\nRef: 216456	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc4e50076/produto-joia/background/desktop/216456.jpg	5	0.00	0.00	2026-03-05 10:39:39.785582-03	2026-02-27 19:59:11.790493-03
392	Máscara Concentrada Crono Capilar Tododia Hidrata	\N	154871	Cabelos	Máscara Concentrada Crono Capilar Tododia Hidrata\nRef: 154871	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw79eb6d35/produto-joia/background/desktop/154871.jpg	5	49.90	49.90	2026-03-05 10:40:38.363021-03	2026-02-27 19:59:11.795069-03
395	Sabonete Cremoso para as Mãos	\N	26441	Corpo e Banho	Sabonete Cremoso para as Mãos\nRef: 26441	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw82b76da9/produto-joia/background/desktop/26441.jpg	5	0.00	0.00	2026-03-05 10:41:29.36801-03	2026-02-27 19:59:34.932301-03
396	Ekos Frescor Castanha 75 ml	\N	159924	Geral	Ekos Frescor Castanha 75 ml\nRef: 159924	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw91a18b79/produto-joia/background/desktop/159924.jpg	5	0.00	0.00	2026-03-05 10:41:41.31836-03	2026-02-27 19:59:34.932301-03
402	Kaiak Ultra Masculino 100 ml	\N	169786	Homem	Kaiak Ultra Masculino 100 ml\nRef: 169786	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5a5e8019/produto-joia/background/desktop/169786.jpg	5	189.90	189.90	2026-03-05 10:42:22.503176-03	2026-02-27 19:59:34.947441-03
399	Shampoo Lumina Restaurador para Restauração e Liso Prolongado	\N	167286	Cabelos	Shampoo Lumina Restaurador para Restauração e Liso Prolongado\nRef: 167286	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw79c6027c/produto-joia/background/desktop/167286.jpg	5	52.90	52.90	2026-03-05 10:42:56.227091-03	2026-02-27 19:59:34.940277-03
406	Vela Perfumada Natura 861 Guaiaco Pataqueira 170 g	\N	151027	Geral	Vela Perfumada Natura 861 Guaiaco Pataqueira 170 g\nRef: 151027	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0291e57c/produto-joia/background/desktop/151027.jpg	5	210.00	210.00	2026-03-05 10:43:53.72537-03	2026-02-27 19:59:34.948447-03
450	Produto 97433	\N	97433	Geral	Descoberto em Todos os Produtos (Pág 24)	\N	5	0.00	\N	2026-02-27 19:59:51.979487-03	2026-02-27 19:59:51.979487-03
451	Produto 116195	\N	116195	Geral	Descoberto em Todos os Produtos (Pág 24)	\N	5	0.00	\N	2026-02-27 19:59:51.979487-03	2026-02-27 19:59:51.979487-03
452	Produto 102039	\N	102039	Geral	Descoberto em Todos os Produtos (Pág 24)	\N	5	0.00	\N	2026-02-27 19:59:51.979487-03	2026-02-27 19:59:51.979487-03
454	Produto 215275	\N	215275	Geral	Descoberto em Todos os Produtos (Pág 24)	\N	5	0.00	\N	2026-02-27 19:59:51.986789-03	2026-02-27 19:59:51.986789-03
455	Produto 167330	\N	167330	Geral	Descoberto em Todos os Produtos (Pág 24)	\N	5	0.00	\N	2026-02-27 19:59:51.987801-03	2026-02-27 19:59:51.987801-03
456	Produto 166871	\N	166871	Geral	Descoberto em Todos os Produtos (Pág 24)	\N	5	0.00	\N	2026-02-27 19:59:51.987801-03	2026-02-27 19:59:51.987801-03
457	Produto 194396	\N	194396	Geral	Descoberto em Todos os Produtos (Pág 24)	\N	5	0.00	\N	2026-02-27 19:59:51.987801-03	2026-02-27 19:59:51.995033-03
461	Produto 134575	\N	134575	Geral	Descoberto em Todos os Produtos (Pág 24)	\N	5	0.00	\N	2026-02-27 19:59:51.995773-03	2026-02-27 19:59:51.995773-03
410	Refil Creme Desodorante Hidratante para o Corpo Ekos Castanha	\N	203381	Corpo e Banho	Refil Creme Desodorante Hidratante para o Corpo Ekos Castanha\nRef: 203381	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc76a7397/produto-joia/background/desktop/203381.jpg	5	0.00	0.00	2026-03-05 10:44:54.300587-03	2026-02-27 19:59:34.956862-03
415	Creme Nutritivo para as Mãos Tododia Tâmara e Canela	\N	6386	Corpo e Banho	Creme Nutritivo para as Mãos Tododia Tâmara e Canela\nRef: 6386	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe92c092b/NATBRA-6386_1.jpg	5	0.00	0.00	2026-03-05 10:45:33.390427-03	2026-02-27 19:59:34.965257-03
414	Sabonete Líquido Íntimo Tododia Suave Conforto	\N	83641	Corpo e Banho	Sabonete Líquido Íntimo Tododia Suave Conforto\nRef: 83641	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw96373402/NATBRA-83641_1.jpg	5	50.90	50.90	2026-03-05 10:45:54.104189-03	2026-02-27 19:59:34.965257-03
418	Condicionador Provitalidade para Reconstrução de Danos Extremos	\N	148442	Cabelos	Condicionador Provitalidade para Reconstrução de Danos Extremos\nRef: 148442	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd9e3a88d/produto-joia/background/desktop/148442.jpg	5	55.90	55.90	2026-03-05 10:46:32.062423-03	2026-02-27 19:59:43.191578-03
421	Kit Lumina Antissinais Regenerador Capilar Completo (5 produtos)	\N	235587	Geral	Kit Lumina Antissinais Regenerador Capilar Completo (5 produtos)\nRef: 235587	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9d5a8a51/Produtos/NATBRA-235587_1.jpg	5	0.00	0.00	2026-03-05 10:47:13.843554-03	2026-02-27 19:59:43.198892-03
424	Maxxi Palette de Sombras 12 Intensa Tons Una	\N	70723	Geral	Maxxi Palette de Sombras 12 Intensa Tons Una\nRef: 70723	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw451c0375/produto-joia/background/desktop/70723.jpg	5	0.00	0.00	2026-03-05 10:48:01.967061-03	2026-02-27 19:59:43.207041-03
426	Kit Una Artisan com Hidratante (2 produtos)	\N	216046	Corpo e Banho	Kit Una Artisan com Hidratante (2 produtos)\nRef: 216046	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw72f7cc41/produto-joia/background/desktop/216046.jpg	5	0.00	0.00	2026-03-05 10:48:32.528436-03	2026-02-27 19:59:43.21104-03
429	Batom Matte Faces 3,5g	\N	90905	Maquiagem	Batom Matte Faces 3,5g\nRef: 90905	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw038bc66f/produto-joia/background/desktop/PAI77992.jpg	5	23.90	23.90	2026-03-05 10:49:23.984065-03	2026-02-27 19:59:43.21648-03
431	Kit Completo Lumina Força e Reparação Molecular (5 produtos)	\N	208135	Geral	Kit Completo Lumina Força e Reparação Molecular (5 produtos)\nRef: 208135	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9a1787a4/produto-joia/background/desktop/208135.jpg	5	0.00	0.00	2026-03-05 10:49:48.550378-03	2026-02-27 19:59:43.219481-03
434	Kit Desodorante Antitranspirante Roll-on Kaiak Pulso Masculino (3 unidades)	\N	221675	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Kaiak Pulso Masculino (3 unidades)\nRef: 221675	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfe59c54e/produto-joia/background/desktop/221675.jpg	5	0.00	0.00	2026-03-05 10:50:24.28536-03	2026-02-27 19:59:43.224822-03
437	Kit Sabonete Líquido Esfoliação e Limpeza Ekos Maracujá (2 produtos)	\N	241047	Corpo e Banho	Kit Sabonete Líquido Esfoliação e Limpeza Ekos Maracujá (2 produtos)\nRef: 241047	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwaa90b200/Produtos/NATBRA-241047_1.jpg	5	0.00	0.00	2026-03-05 10:51:21.806662-03	2026-02-27 19:59:43.229804-03
441	Presente Natura Tododia Sabonetes em Barra Sortidos (1 caixa)	\N	164382	Corpo e Banho	Presente Natura Tododia Sabonetes em Barra Sortidos (1 caixa)\nRef: 164382	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2b54a96c/produto-joia/background/desktop/164382.jpg	5	0.00	0.00	2026-03-05 10:51:58.180422-03	2026-02-27 19:59:51.963058-03
443	Condicionador Polinutrição para Nutrição e Reparação Profunda	\N	147440	Cabelos	Condicionador Polinutrição para Nutrição e Reparação Profunda\nRef: 147440	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4b27ab1b/produto-joia/background/desktop/147440.jpg	5	55.90	55.90	2026-03-05 10:52:42.256516-03	2026-02-27 19:59:51.963058-03
446	Kit Tododia Macadâmia	\N	200142	Geral	Kit Tododia Macadâmia\nRef: 200142	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw48eacc87/NATBRA-200142_1.jpg	5	0.00	0.00	2026-03-05 10:53:35.720871-03	2026-02-27 19:59:51.971133-03
448	Óleo Corporal Natura Aura Alba	\N	197460	Corpo e Banho	Óleo Corporal Natura Aura Alba\nRef: 197460	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8574b947/produto-joia/background/desktop/197460.jpg	5	129.90	129.90	2026-03-05 10:54:01.332491-03	2026-02-27 19:59:51.971133-03
453	Creme para Pentear Cabelos Cacheados e Crespos Naturé	\N	102404	Cabelos	Creme para Pentear Cabelos Cacheados e Crespos Naturé\nRef: 102404	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbcf0db09/NATBRA-102404_1.jpg	5	49.90	49.90	2026-03-05 10:54:25.75819-03	2026-02-27 19:59:51.979487-03
460	Condicionador Lumina Restaurador para Restauração e Liso Prolongado	\N	167291	Cabelos	Condicionador Lumina Restaurador para Restauração e Liso Prolongado\nRef: 167291	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw18b342e3/produto-joia/background/desktop/167291.jpg	5	55.90	55.90	2026-03-05 11:36:47.326498-03	2026-02-27 19:59:51.995773-03
463	Química de Humor Feminino 75 ml	\N	70995	Geral	Química de Humor Feminino 75 ml\nRef: 70995	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2641642e/produto-joia/background/desktop/70995.jpg	5	0.00	0.00	2026-03-05 11:37:40.779884-03	2026-02-27 19:59:59.561481-03
473	Produto 147417	\N	147417	Geral	Descoberto em Todos os Produtos (Pág 25)	\N	5	0.00	\N	2026-02-27 19:59:59.577998-03	2026-02-27 19:59:59.577998-03
474	Produto 102403	\N	102403	Geral	Descoberto em Todos os Produtos (Pág 25)	\N	5	0.00	\N	2026-02-27 19:59:59.577998-03	2026-02-27 19:59:59.577998-03
475	Produto 187608	\N	187608	Geral	Descoberto em Todos os Produtos (Pág 25)	\N	5	0.00	\N	2026-02-27 19:59:59.577998-03	2026-02-27 19:59:59.577998-03
476	Produto 114584	\N	114584	Geral	Descoberto em Todos os Produtos (Pág 25)	\N	5	0.00	\N	2026-02-27 19:59:59.586347-03	2026-02-27 19:59:59.586347-03
477	Produto 194392	\N	194392	Geral	Descoberto em Todos os Produtos (Pág 25)	\N	5	0.00	\N	2026-02-27 19:59:59.586347-03	2026-02-27 19:59:59.586347-03
478	Produto 124202	\N	124202	Geral	Descoberto em Todos os Produtos (Pág 25)	\N	5	0.00	\N	2026-02-27 19:59:59.586347-03	2026-02-27 19:59:59.586347-03
479	Produto 152297	\N	152297	Geral	Descoberto em Todos os Produtos (Pág 25)	\N	5	0.00	\N	2026-02-27 19:59:59.586347-03	2026-02-27 19:59:59.586347-03
480	Produto 152280	\N	152280	Geral	Descoberto em Todos os Produtos (Pág 25)	\N	5	0.00	\N	2026-02-27 19:59:59.586347-03	2026-02-27 19:59:59.586347-03
482	Produto 97431	\N	97431	Geral	Descoberto em Todos os Produtos (Pág 25)	\N	5	0.00	\N	2026-02-27 19:59:59.594857-03	2026-02-27 19:59:59.594857-03
483	Produto 171364	\N	171364	Geral	Descoberto em Todos os Produtos (Pág 25)	\N	5	0.00	\N	2026-02-27 19:59:59.594857-03	2026-02-27 19:59:59.594857-03
484	Produto 91217	\N	91217	Geral	Descoberto em Todos os Produtos (Pág 25)	\N	5	0.00	\N	2026-02-27 19:59:59.594857-03	2026-02-27 19:59:59.594857-03
505	Produto 83390	\N	83390	Geral	Descoberto em Todos os Produtos (Pág 28)	\N	5	0.00	\N	2026-02-27 20:00:24.069462-03	2026-02-27 20:00:24.069462-03
467	Essência para Cabelos Tododia Flor de Ameixa	\N	174032	Cabelos	Essência para Cabelos Tododia Flor de Ameixa\nRef: 174032	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw459966db/produto-joia/background/desktop/174032.jpg	5	0.00	0.00	2026-03-05 11:38:42.434319-03	2026-02-27 19:59:59.569869-03
470	Kaiak Aventura Intensa Feminino 100 ml	\N	171125	Geral	Kaiak Aventura Intensa Feminino 100 ml\nRef: 171125	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc2249580/produto-joia/background/desktop/171125.jpg	5	189.90	189.90	2026-03-05 11:39:05.571248-03	2026-02-27 19:59:59.577164-03
481	Shampoo Mamãe e Bebê Cachinhos e Crespinhos	\N	166870	Cabelos	Shampoo Mamãe e Bebê Cachinhos e Crespinhos\nRef: 166870	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwaded9cfd/produto-joia/background/desktop/166870.jpg	5	0.00	0.00	2026-03-05 12:36:57.88652-03	2026-02-27 19:59:59.594857-03
487	Desodorante Antitranspirante Roll-on Kaiak Pulso Masculino	\N	189396	Corpo e Banho	Desodorante Antitranspirante Roll-on Kaiak Pulso Masculino\nRef: 189396	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa698a7ef/produto-joia/background/desktop/189396.jpg	5	29.90	29.90	2026-03-05 12:37:40.355473-03	2026-02-27 20:00:24.038645-03
490	Kit Lumina Shampoo e Condicionador Hidratação e Proteção Antipoluição (2 produtos)	\N	204411	Cabelos	Kit Lumina Shampoo e Condicionador Hidratação e Proteção Antipoluição (2 produtos)\nRef: 204411	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw842086c5/NATBRA-204411_1.jpg	5	0.00	0.00	2026-03-05 12:38:19.596755-03	2026-02-27 20:00:24.046783-03
493	Creme Desodorante Nutritivo para os Pés Noz Pecã e Cacau	\N	72180	Corpo e Banho	Creme Desodorante Nutritivo para os Pés Noz Pecã e Cacau\nRef: 72180	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3ef0b94c/NATBRA-72180_1.jpg	5	0.00	0.00	2026-03-05 12:38:58.739025-03	2026-02-27 20:00:24.051789-03
495	Kit Ekos Maracujá Completo	\N	239974	Geral	Kit Ekos Maracujá Completo\nRef: 239974	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw00647a57/produto-joia/background/desktop/239974.jpg	5	0.00	0.00	2026-03-05 12:39:28.930491-03	2026-02-27 20:00:24.054789-03
497	Presente Natura Queridinhos (3 produtos)	\N	174336	Geral	Presente Natura Queridinhos (3 produtos)\nRef: 174336	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3ba57afe/produto-joia/background/desktop/174336.jpg	5	0.00	0.00	2026-03-05 12:39:52.921956-03	2026-02-27 20:00:24.058213-03
500	Condicionador Antissinais Regenerador Capilar Lumina	\N	174212	Cabelos	Condicionador Antissinais Regenerador Capilar Lumina\nRef: 174212	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcafdf81b/produto-joia/background/desktop/174212.jpg	5	59.90	59.90	2026-03-05 12:40:39.889064-03	2026-02-27 20:00:24.062214-03
503	Batom Extremo Conforto FPS 25 Una 3,8g	\N	17352	Maquiagem	Batom Extremo Conforto FPS 25 Una 3,8g\nRef: 17352	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3d5692bd/Produtos/NATBRA-17352_1.jpg	5	0.00	0.00	2026-03-05 12:41:23.823232-03	2026-02-27 20:00:24.066462-03
506	Essencial Ato Feminino 100 ml	\N	114583	Geral	Essencial Ato Feminino 100 ml\nRef: 114583	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3b35669a/produto-joia/background/desktop/114583.jpg	5	279.90	279.90	2026-03-05 12:42:12.244629-03	2026-02-27 20:00:24.071379-03
509	Loção Hidratante Preventiva de Estrias Mamãe e Bebê	\N	92808	Corpo e Banho	Loção Hidratante Preventiva de Estrias Mamãe e Bebê\nRef: 92808	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd09944ef/produto-joia/background/desktop/92808.jpg	5	0.00	0.00	2026-03-05 12:43:01.915101-03	2026-02-27 20:00:39.855514-03
513	Festival de Humor Feminino 75 ml	\N	131462	Geral	Festival de Humor Feminino 75 ml\nRef: 131462	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw40d93f23/produto-joia/background/desktop/131462.jpg	5	0.00	0.00	2026-03-05 12:43:27.609185-03	2026-02-27 20:00:39.863955-03
514	Sabonete Líquido Esfoliante Corporal Tododia Capim Limão e Hortelã	\N	113412	Corpo e Banho	Sabonete Líquido Esfoliante Corporal Tododia Capim Limão e Hortelã\nRef: 113412	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2f0967cc/NATBRA-113412_1.jpg	5	0.00	0.00	2026-03-05 12:44:18.8903-03	2026-02-27 20:00:39.871182-03
517	Refil Shampoo Força e Reparação Molecular Lumina	\N	164509	Cabelos	Refil Shampoo Força e Reparação Molecular Lumina\nRef: 164509	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2974a560/produto-joia/background/desktop/164509.jpg	5	38.90	38.90	2026-03-05 12:44:57.414663-03	2026-02-27 20:00:39.872339-03
519	Presente Natura Essencial Feminino (3 produtos)	\N	210127	Geral	Presente Natura Essencial Feminino (3 produtos)\nRef: 210127	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw17f26ead/produto-joia/background/desktop/210127.jpg	5	0.00	0.00	2026-03-05 12:45:25.89112-03	2026-02-27 20:00:39.87952-03
522	Ekos Frescor Cacau 150 ml	\N	162219	Geral	Ekos Frescor Cacau 150 ml\nRef: 162219	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3fc96cf0/produto-joia/background/desktop/162219.jpg	5	129.90	129.90	2026-03-05 12:46:22.302339-03	2026-02-27 20:00:39.881296-03
536	Produto 160237	\N	160237	Geral	Descoberto em Todos os Produtos (Pág 31)	\N	5	0.00	\N	2026-02-27 20:00:48.587781-03	2026-02-27 20:00:48.587781-03
569	Produto 106294	\N	106294	Geral	Descoberto em Todos os Produtos (Pág 32)	\N	5	0.00	\N	2026-02-27 20:00:57.010999-03	2026-02-27 20:00:57.010999-03
576	Produto 171109	\N	171109	Geral	Descoberto em Todos os Produtos (Pág 33)	\N	5	0.00	\N	2026-02-27 20:01:05.227105-03	2026-02-27 20:01:05.227105-03
577	Produto 182087	\N	182087	Geral	Descoberto em Todos os Produtos (Pág 33)	\N	5	0.00	\N	2026-02-27 20:01:05.227105-03	2026-02-27 20:01:05.227105-03
578	Produto 166873	\N	166873	Geral	Descoberto em Todos os Produtos (Pág 33)	\N	5	0.00	\N	2026-02-27 20:01:05.227105-03	2026-02-27 20:01:05.227105-03
579	Produto 97170	\N	97170	Geral	Descoberto em Todos os Produtos (Pág 33)	\N	5	0.00	\N	2026-02-27 20:01:05.234546-03	2026-02-27 20:01:05.234546-03
580	Produto 176914	\N	176914	Geral	Descoberto em Todos os Produtos (Pág 33)	\N	5	0.00	\N	2026-02-27 20:01:05.234546-03	2026-02-27 20:01:05.234546-03
525	Shampoo Cabelos Cacheados e Crespos Naturé	\N	102400	Cabelos	Shampoo Cabelos Cacheados e Crespos Naturé\nRef: 102400	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4ba2f9d2/NATBRA-102400_1.jpg	5	37.90	37.90	2026-03-05 12:47:22.313933-03	2026-02-27 20:00:39.889386-03
527	Desodorante Antitranspirante Roll-On Natura Homem Dom	\N	150227	Corpo e Banho	Desodorante Antitranspirante Roll-On Natura Homem Dom\nRef: 150227	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6d352859/produto-joia/background/desktop/150227.jpg	5	29.90	29.90	2026-03-05 12:47:56.385538-03	2026-02-27 20:00:39.889386-03
531	Kit Nutritivo Tododia Pêssego e Amêndoa	\N	194394	Geral	Kit Nutritivo Tododia Pêssego e Amêndoa\nRef: 194394	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw748a0955/NATBRA-194394_1.jpg	5	0.00	0.00	2026-03-05 12:48:37.922023-03	2026-02-27 20:00:48.578181-03
533	Gloss Labial Hidratação Ativa Una	\N	164826	Geral	Gloss Labial Hidratação Ativa Una\nRef: 164826	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw31965597/produto-joia/background/desktop/164826.jpg	5	59.90	59.90	2026-03-05 12:49:24.129293-03	2026-02-27 20:00:48.579289-03
539	Shampoo Purificante Lumina para Hidratação e Proteção Antipoluição	\N	147416	Cabelos	Shampoo Purificante Lumina para Hidratação e Proteção Antipoluição\nRef: 147416	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6211ab7d/produto-joia/background/desktop/147416.jpg	5	0.00	0.00	2026-03-05 12:49:52.884167-03	2026-02-27 20:00:48.587781-03
540	Sabonete em Barra Cremoso e Esfoliante Puro Vegetal Ekos Maracujá	\N	124393	Corpo e Banho	Sabonete em Barra Cremoso e Esfoliante Puro Vegetal Ekos Maracujá\nRef: 124393	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3f68c086/produto-joia/background/desktop/124393.jpg	5	45.90	45.90	2026-03-05 12:51:14.649676-03	2026-02-27 20:00:48.596203-03
543	Creme Hidratante Desodorante Corporal Una Artisan	\N	170986	Corpo e Banho	Creme Hidratante Desodorante Corporal Una Artisan\nRef: 170986	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4e2d5db2/produto-joia/background/desktop/170986.jpg	5	0.00	0.00	2026-03-05 12:52:08.655849-03	2026-02-27 20:00:48.59722-03
546	Multicorretor Antissinais Natura Homem	\N	151019	Homem	Multicorretor Antissinais Natura Homem\nRef: 151019	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdf4accf4/produto-joia/background/desktop/151019.jpg	5	0.00	0.00	2026-03-05 12:52:49.027101-03	2026-02-27 20:00:48.605026-03
547	Miniatura Essencial Exclusivo Masculino 25 ml	\N	111027	Homem	Miniatura Essencial Exclusivo Masculino 25 ml\nRef: 111027	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw17009b54/produto-joia/background/desktop/111027.jpg	5	114.90	114.90	2026-03-05 12:53:22.943484-03	2026-02-27 20:00:48.605026-03
551	Mochila Natura Papai e Bebê com Trocador	\N	124131	Infantil	Mochila Natura Papai e Bebê com Trocador\nRef: 124131	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7eea4a2a/produto-joia/background/desktop/124131.jpg	5	0.00	0.00	2026-03-05 12:53:57.315427-03	2026-02-27 20:00:48.613052-03
552	Gel para Barbear Natura Homem	\N	152277	Homem	Gel para Barbear Natura Homem\nRef: 152277	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwec7c2fb9/produto-joia/background/desktop/152277.jpg	5	0.00	0.00	2026-03-05 12:54:28.85307-03	2026-02-27 20:00:56.977483-03
557	Protetor Antioleosidade Redutor de Poros FPS 30 / FPUVA 10 Chronos Derma	\N	69725	Geral	Protetor Antioleosidade Redutor de Poros FPS 30 / FPUVA 10 Chronos Derma\nRef: 69725	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw21d791fa/produto-joia/background/desktop/69725.jpg	5	0.00	0.00	2026-03-05 12:55:05.459007-03	2026-02-27 20:00:56.986267-03
558	Kit Lumina Nutrição e Reparação (4 produtos)	\N	217194	Geral	Kit Lumina Nutrição e Reparação (4 produtos)\nRef: 217194	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw86e71faa/produto-joia/background/desktop/217194.jpg	5	0.00	0.00	2026-03-05 12:55:52.294958-03	2026-02-27 20:00:56.994253-03
560	Óleo Trifásico Desodorante Corporal Ekos Amazô	\N	134427	Corpo e Banho	Óleo Trifásico Desodorante Corporal Ekos Amazô\nRef: 134427	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw209b8dfa/produto-joia/background/desktop/134427.jpg	5	0.00	0.00	2026-03-05 12:56:33.848027-03	2026-02-27 20:00:56.994253-03
563	Kit Refil Desodorante Corporal Natura Homem (2 unidades)	\N	254607	Corpo e Banho	Kit Refil Desodorante Corporal Natura Homem (2 unidades)\nRef: 254607	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4ada0e32/Produtos/NATBRA-254607_1.jpg	5	0.00	0.00	2026-03-05 12:57:02.141864-03	2026-02-27 20:00:57.002427-03
564	Natura Homem Especiarias	\N	119428	Homem	Natura Homem Especiarias\nRef: 119428	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7dfc5d54/produto-joia/background/desktop/119428.jpg	5	209.90	209.90	2026-03-05 12:57:47.263045-03	2026-02-27 20:00:57.002427-03
572	Essência de Tratamento Revitalização e Luminosidade Chronos Derma	\N	135043	Geral	Essência de Tratamento Revitalização e Luminosidade Chronos Derma\nRef: 135043	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3485e0e1/produto-joia/background/desktop/135043.jpg	5	132.00	132.00	2026-03-05 12:58:41.209888-03	2026-02-27 20:00:57.010999-03
573	Polpa Hidratante para as Mãos Ekos Andiroba	\N	122484	Corpo e Banho	Polpa Hidratante para as Mãos Ekos Andiroba\nRef: 122484	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwde81cbab/produto-joia/background/desktop/122484.jpg	5	59.90	59.90	2026-03-05 12:59:25.052902-03	2026-02-27 20:00:57.019125-03
581	Produto 70406	\N	70406	Geral	Descoberto em Todos os Produtos (Pág 33)	\N	5	0.00	\N	2026-02-27 20:01:05.234546-03	2026-02-27 20:01:05.234546-03
582	Produto 11683	\N	11683	Geral	Descoberto em Todos os Produtos (Pág 33)	\N	5	0.00	\N	2026-02-27 20:01:05.234546-03	2026-02-27 20:01:05.234546-03
583	Produto 9456	\N	9456	Geral	Descoberto em Todos os Produtos (Pág 33)	\N	5	0.00	\N	2026-02-27 20:01:05.234546-03	2026-02-27 20:01:05.24281-03
586	Produto 96518	\N	96518	Geral	Descoberto em Todos os Produtos (Pág 33)	\N	5	0.00	\N	2026-02-27 20:01:05.243156-03	2026-02-27 20:01:05.243156-03
600	Produto 139270	\N	139270	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.893627-03	2026-02-27 20:01:12.893627-03
601	Produto 154864	\N	154864	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.895635-03	2026-02-27 20:01:12.896633-03
602	Produto 219717	\N	219717	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.89864-03	2026-02-27 20:01:12.89864-03
603	Produto 2791	\N	2791	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.901012-03	2026-02-27 20:01:12.902012-03
604	Produto 203379	\N	203379	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.903013-03	2026-02-27 20:01:12.904012-03
605	Produto 174921	\N	174921	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.906012-03	2026-02-27 20:01:12.906012-03
606	Produto 177731	\N	177731	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.908177-03	2026-02-27 20:01:12.909208-03
607	Produto 211152	\N	211152	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.910207-03	2026-02-27 20:01:12.911211-03
608	Produto 228004	\N	228004	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.913208-03	2026-02-27 20:01:12.913208-03
609	Produto 134585	\N	134585	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.915219-03	2026-02-27 20:01:12.915219-03
610	Produto 164824	\N	164824	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.917526-03	2026-02-27 20:01:12.917526-03
611	Produto 11682	\N	11682	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.919524-03	2026-02-27 20:01:12.920515-03
612	Produto 181515	\N	181515	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.921532-03	2026-02-27 20:01:12.922532-03
613	Produto 228006	\N	228006	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.923515-03	2026-02-27 20:01:12.924829-03
614	Produto 116188	\N	116188	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.925856-03	2026-02-27 20:01:12.926864-03
615	Produto 211659	\N	211659	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.927864-03	2026-02-27 20:01:12.927864-03
616	Produto 187605	\N	187605	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.929856-03	2026-02-27 20:01:12.929856-03
617	Produto 65830	\N	65830	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.93187-03	2026-02-27 20:01:12.93187-03
618	Produto 147407	\N	147407	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.934274-03	2026-02-27 20:01:12.935272-03
619	Produto 220145	\N	220145	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.936272-03	2026-02-27 20:01:12.937272-03
620	Produto 145489	\N	145489	Geral	Descoberto em Todos os Produtos (Pág 34)	\N	5	0.00	\N	2026-02-27 20:01:12.939272-03	2026-02-27 20:01:12.940272-03
621	Produto 166351	\N	166351	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.682545-03	2026-02-27 20:01:21.682545-03
622	Produto 219721	\N	219721	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.682545-03	2026-02-27 20:01:21.682545-03
623	Produto 140411	\N	140411	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.682545-03	2026-02-27 20:01:21.689853-03
624	Produto 208771	\N	208771	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.690859-03	2026-02-27 20:01:21.690859-03
625	Produto 128615	\N	128615	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.690859-03	2026-02-27 20:01:21.690859-03
626	Produto 208138	\N	208138	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.690859-03	2026-02-27 20:01:21.690859-03
627	Produto 213547	\N	213547	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.690859-03	2026-02-27 20:01:21.698161-03
628	Produto 134594	\N	134594	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.699175-03	2026-02-27 20:01:21.699175-03
629	Produto 174196	\N	174196	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.699175-03	2026-02-27 20:01:21.699175-03
630	Produto 122112	\N	122112	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.699175-03	2026-02-27 20:01:21.699175-03
631	Produto 239726	\N	239726	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.699175-03	2026-02-27 20:01:21.706472-03
632	Produto 148443	\N	148443	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.707478-03	2026-02-27 20:01:21.707478-03
633	Produto 204430	\N	204430	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.707478-03	2026-02-27 20:01:21.707478-03
634	Produto 147401	\N	147401	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.707478-03	2026-02-27 20:01:21.707478-03
635	Produto 236562	\N	236562	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.714885-03	2026-02-27 20:01:21.714885-03
636	Produto 110643	\N	110643	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.716209-03	2026-02-27 20:01:21.716209-03
637	Produto 121967	\N	121967	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.716209-03	2026-02-27 20:01:21.716209-03
638	Produto 148419	\N	148419	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.716209-03	2026-02-27 20:01:21.716209-03
588	Refil Creme Desodorante Nutritivo para o Corpo Tododia Noz Pecã e Cacau	\N	2821	Corpo e Banho	Refil Creme Desodorante Nutritivo para o Corpo Tododia Noz Pecã e Cacau\nRef: 2821	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw37acb3f8/produto-joia/background/desktop/2821.jpg	5	0.00	0.00	2026-03-05 13:42:27.96518-03	2026-02-27 20:01:05.251215-03
590	Refil Pó Compacto Matte Faces 6,5g	\N	8992	Maquiagem	Refil Pó Compacto Matte Faces 6,5g\nRef: 8992	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw27c933d3/Produtos/NATBRA-8992_1.jpg	5	49.90	49.90	2026-03-05 13:42:59.508637-03	2026-02-27 20:01:05.251215-03
593	Refil Essencial Ato Masculino 100 ml	\N	114586	Homem	Refil Essencial Ato Masculino 100 ml\nRef: 114586	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0d13f3d1/NATBRA-114586_1.jpg	5	213.90	213.90	2026-03-05 13:43:38.266108-03	2026-02-27 20:01:05.26117-03
596	Creme Desodorante Corporal Perfumado Sève Amêndoas e Orquídea Negra	\N	189566	Corpo e Banho	Creme Desodorante Corporal Perfumado Sève Amêndoas e Orquídea Negra\nRef: 189566	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw656bf98d/produto-joia/background/desktop/189566.jpg	5	112.90	112.90	2026-03-05 13:44:21.14261-03	2026-02-27 20:01:05.26117-03
599	Kit Sabonete em Barra Tododia Amora Vermelha e Jabuticaba e Tododia Flor de Gengibre e Tangerina (2 caixas)	\N	241071	Corpo e Banho	Kit Sabonete em Barra Tododia Amora Vermelha e Jabuticaba e Tododia Flor de Gengibre e Tangerina (2 caixas)\nRef: 241071	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2d793bbf/Produtos/NATBRA-241071_1.jpg	5	0.00	0.00	2026-03-05 13:45:06.378187-03	2026-02-27 20:01:12.891602-03
639	Produto 167289	\N	167289	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.723207-03	2026-02-27 20:01:21.724218-03
640	Produto 180470	\N	180470	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.724218-03	2026-02-27 20:01:21.724218-03
641	Produto 187996	\N	187996	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.724218-03	2026-02-27 20:01:21.724218-03
642	Produto 219073	\N	219073	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.455413-03	2026-02-27 20:01:30.456841-03
643	Produto 189398	\N	189398	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.456841-03	2026-02-27 20:01:30.456841-03
644	Produto 210422	\N	210422	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.456841-03	2026-02-27 20:01:30.456841-03
645	Produto 152298	\N	152298	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.464769-03	2026-02-27 20:01:30.465089-03
646	Produto 28724	\N	28724	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.465089-03	2026-02-27 20:01:30.465089-03
647	Produto 194393	\N	194393	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.465089-03	2026-02-27 20:01:30.465089-03
648	Produto 69200	\N	69200	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.465089-03	2026-02-27 20:01:30.465089-03
649	Produto 168819	\N	168819	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.47305-03	2026-02-27 20:01:30.473516-03
650	Produto 176398	\N	176398	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.473516-03	2026-02-27 20:01:30.473516-03
651	Produto 148432	\N	148432	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.473516-03	2026-02-27 20:01:30.473516-03
652	Produto 86180	\N	86180	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.480225-03	2026-02-27 20:01:30.480225-03
653	Produto 222447	\N	222447	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.481235-03	2026-02-27 20:01:30.481235-03
654	Produto 110281	\N	110281	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.481235-03	2026-02-27 20:01:30.481235-03
655	Produto 221678	\N	221678	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.481235-03	2026-02-27 20:01:30.481235-03
656	Produto 252074	\N	252074	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.488629-03	2026-02-27 20:01:30.489138-03
657	Produto 148450	\N	148450	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.489701-03	2026-02-27 20:01:30.489701-03
658	Produto 189563	\N	189563	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.489701-03	2026-02-27 20:01:30.489701-03
659	Produto 160210	\N	160210	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.489701-03	2026-02-27 20:01:30.489701-03
660	Produto 9481	\N	9481	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.489701-03	2026-02-27 20:01:30.489701-03
661	Produto 181518	\N	181518	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.497854-03	2026-02-27 20:01:30.497854-03
662	Produto 92526	\N	92526	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.497854-03	2026-02-27 20:01:30.497854-03
663	Produto 147420	\N	147420	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.497854-03	2026-02-27 20:01:30.497854-03
664	Produto 242263	\N	242263	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.497854-03	2026-02-27 20:01:30.497854-03
665	Produto 167994	\N	167994	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.497854-03	2026-02-27 20:01:30.497854-03
666	Produto 129797	\N	129797	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.771848-03	2026-02-27 20:01:38.771848-03
667	Produto 187035	\N	187035	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.771848-03	2026-02-27 20:01:38.771848-03
668	Produto 103140	\N	103140	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.771848-03	2026-02-27 20:01:38.779105-03
669	Produto 208142	\N	208142	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.780202-03	2026-02-27 20:01:38.780747-03
670	Produto 219734	\N	219734	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.780747-03	2026-02-27 20:01:38.780747-03
671	Produto 115886	\N	115886	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.780747-03	2026-02-27 20:01:38.780747-03
672	Produto 100148	\N	100148	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.780747-03	2026-02-27 20:01:38.780747-03
673	Produto 197576	\N	197576	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.787357-03	2026-02-27 20:01:38.788466-03
674	Produto 190391	\N	190391	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.788466-03	2026-02-27 20:01:38.788466-03
675	Produto 169258	\N	169258	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.788466-03	2026-02-27 20:01:38.788466-03
676	Produto 102420	\N	102420	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.788466-03	2026-02-27 20:01:38.788466-03
677	Produto 118445	\N	118445	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.788466-03	2026-02-27 20:01:38.795693-03
678	Produto 70393	\N	70393	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.796706-03	2026-02-27 20:01:38.796706-03
679	Produto 217166	\N	217166	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.796706-03	2026-02-27 20:01:38.796706-03
680	Produto 116186	\N	116186	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.796706-03	2026-02-27 20:01:38.796706-03
681	Produto 148425	\N	148425	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.796706-03	2026-02-27 20:01:38.796706-03
682	Produto 229956	\N	229956	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.804027-03	2026-02-27 20:01:38.804027-03
683	Produto 17042	\N	17042	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.805109-03	2026-02-27 20:01:38.805109-03
684	Produto 9009	\N	9009	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.805109-03	2026-02-27 20:01:38.805109-03
685	Produto 95949	\N	95949	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.805109-03	2026-02-27 20:01:38.805109-03
686	Produto 107021	\N	107021	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.812467-03	2026-02-27 20:01:38.812467-03
687	Produto 167329	\N	167329	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.813542-03	2026-02-27 20:01:38.813542-03
688	Produto 7978	\N	7978	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.813542-03	2026-02-27 20:01:38.813542-03
689	Produto 228452	\N	228452	Geral	Descoberto em Todos os Produtos (Pág 37)	\N	5	0.00	\N	2026-02-27 20:01:38.813542-03	2026-02-27 20:01:38.813542-03
690	Produto 208773	\N	208773	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.471969-03	2026-02-27 20:01:46.473883-03
691	Produto 211660	\N	211660	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.475965-03	2026-02-27 20:01:46.476968-03
692	Produto 103976	\N	103976	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.47834-03	2026-02-27 20:01:46.479469-03
693	Produto 160264	\N	160264	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.481467-03	2026-02-27 20:01:46.481467-03
694	Produto 174337	\N	174337	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.483466-03	2026-02-27 20:01:46.483466-03
695	Produto 236561	\N	236561	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.484486-03	2026-02-27 20:01:46.48547-03
696	Produto 235592	\N	235592	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.486492-03	2026-02-27 20:01:46.487539-03
697	Produto 219742	\N	219742	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.488538-03	2026-02-27 20:01:46.489537-03
698	Produto 93028	\N	93028	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.490537-03	2026-02-27 20:01:46.49154-03
699	Produto 110182	\N	110182	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.492538-03	2026-02-27 20:01:46.493621-03
700	Produto 9921	\N	9921	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.494841-03	2026-02-27 20:01:46.494841-03
701	Produto 9045	\N	9045	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.495846-03	2026-02-27 20:01:46.496859-03
702	Produto 228005	\N	228005	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.49785-03	2026-02-27 20:01:46.498857-03
703	Produto 195646	\N	195646	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.499857-03	2026-02-27 20:01:46.50085-03
704	Produto 97174	\N	97174	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.501851-03	2026-02-27 20:01:46.501851-03
705	Produto 150192	\N	150192	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.504114-03	2026-02-27 20:01:46.504114-03
706	Produto 97173	\N	97173	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.50612-03	2026-02-27 20:01:46.50612-03
707	Produto 125298	\N	125298	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.507113-03	2026-02-27 20:01:46.508134-03
708	Produto 147447	\N	147447	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.509124-03	2026-02-27 20:01:46.510113-03
709	Produto 6421	\N	6421	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.511444-03	2026-02-27 20:01:46.511444-03
710	Produto 163721	\N	163721	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.513474-03	2026-02-27 20:01:46.513474-03
711	Produto 174913	\N	174913	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.515475-03	2026-02-27 20:01:46.515475-03
712	Produto 235591	\N	235591	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.51748-03	2026-02-27 20:01:46.51748-03
713	Produto 147446	\N	147446	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.844308-03	2026-02-27 20:01:54.844308-03
714	Produto 155896	\N	155896	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.852618-03	2026-02-27 20:01:54.852618-03
715	Produto 70410	\N	70410	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.852618-03	2026-02-27 20:01:54.852618-03
716	Produto 239988	\N	239988	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.852618-03	2026-02-27 20:01:54.852618-03
717	Produto 133865	\N	133865	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.852618-03	2026-02-27 20:01:54.852618-03
718	Produto 100535	\N	100535	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.859924-03	2026-02-27 20:01:54.86094-03
719	Produto 150222	\N	150222	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.86094-03	2026-02-27 20:01:54.86094-03
720	Produto 125949	\N	125949	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.86094-03	2026-02-27 20:01:54.86094-03
721	Produto 239254	\N	239254	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.86094-03	2026-02-27 20:01:54.86094-03
722	Produto 218206	\N	218206	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.86094-03	2026-02-27 20:01:54.86094-03
723	Produto 166022	\N	166022	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.869336-03	2026-02-27 20:01:54.869336-03
724	Produto 187122	\N	187122	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.869336-03	2026-02-27 20:01:54.869336-03
725	Produto 184469	\N	184469	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.869336-03	2026-02-27 20:01:54.869336-03
726	Produto 9619	\N	9619	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.869336-03	2026-02-27 20:01:54.869336-03
727	Produto 70402	\N	70402	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.869336-03	2026-02-27 20:01:54.876595-03
728	Produto 148176	\N	148176	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.877606-03	2026-02-27 20:01:54.877606-03
729	Produto 221676	\N	221676	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.877606-03	2026-02-27 20:01:54.877606-03
730	Produto 181513	\N	181513	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.877606-03	2026-02-27 20:01:54.877606-03
731	Produto 209111	\N	209111	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.877606-03	2026-02-27 20:01:54.877606-03
732	Produto 221673	\N	221673	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.886049-03	2026-02-27 20:01:54.886049-03
733	Produto 164512	\N	164512	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.886049-03	2026-02-27 20:01:54.886049-03
734	Produto 213232	\N	213232	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.886049-03	2026-02-27 20:01:54.886049-03
735	Produto 102407	\N	102407	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.886049-03	2026-02-27 20:01:54.886049-03
736	Produto 92550	\N	92550	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.886049-03	2026-02-27 20:01:54.893238-03
737	Produto 151559	\N	151559	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.250698-03	2026-02-27 20:02:02.251826-03
738	Produto 244487	\N	244487	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.251826-03	2026-02-27 20:02:02.251826-03
739	Produto 174338	\N	174338	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.251826-03	2026-02-27 20:02:02.251826-03
740	Produto 156234	\N	156234	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.251826-03	2026-02-27 20:02:02.259209-03
741	Produto 217164	\N	217164	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.259582-03	2026-02-27 20:02:02.259582-03
742	Produto 194789	\N	194789	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.259582-03	2026-02-27 20:02:02.259582-03
743	Produto 148175	\N	148175	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.259582-03	2026-02-27 20:02:02.259582-03
744	Produto 166358	\N	166358	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.259582-03	2026-02-27 20:02:02.259582-03
745	Produto 194529	\N	194529	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.267918-03	2026-02-27 20:02:02.267918-03
746	Produto 34262	\N	34262	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.267918-03	2026-02-27 20:02:02.267918-03
747	Produto 208137	\N	208137	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.267918-03	2026-02-27 20:02:02.267918-03
748	Produto 8848	\N	8848	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.267918-03	2026-02-27 20:02:02.267918-03
749	Produto 228007	\N	228007	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.267918-03	2026-02-27 20:02:02.275585-03
750	Produto 91192	\N	91192	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.27628-03	2026-02-27 20:02:02.27628-03
751	Produto 114277	\N	114277	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.27628-03	2026-02-27 20:02:02.27628-03
752	Produto 155606	\N	155606	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.27628-03	2026-02-27 20:02:02.27628-03
753	Produto 218196	\N	218196	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.27628-03	2026-02-27 20:02:02.27628-03
754	Produto 243055	\N	243055	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.27628-03	2026-02-27 20:02:02.284581-03
755	Produto 134197	\N	134197	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.284581-03	2026-02-27 20:02:02.284581-03
756	Produto 239795	\N	239795	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.284581-03	2026-02-27 20:02:02.284581-03
757	Produto 235590	\N	235590	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.284581-03	2026-02-27 20:02:02.284581-03
758	Produto 98767	\N	98767	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.284581-03	2026-02-27 20:02:02.284581-03
759	Produto 167105	\N	167105	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.292305-03	2026-02-27 20:02:02.29295-03
760	Produto 69724	\N	69724	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.29295-03	2026-02-27 20:02:02.29295-03
761	Produto 215256	\N	215256	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.499399-03	2026-02-27 20:02:09.499754-03
762	Produto 110411	\N	110411	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.501851-03	2026-02-27 20:02:09.501851-03
763	Produto 173585	\N	173585	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.503846-03	2026-02-27 20:02:09.503846-03
764	Produto 17043	\N	17043	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.504861-03	2026-02-27 20:02:09.505854-03
765	Produto 85400	\N	85400	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.506849-03	2026-02-27 20:02:09.507739-03
766	Produto 228446	\N	228446	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.509089-03	2026-02-27 20:02:09.509089-03
767	Produto 150223	\N	150223	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.510094-03	2026-02-27 20:02:09.511091-03
768	Produto 173593	\N	173593	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.512091-03	2026-02-27 20:02:09.513091-03
769	Produto 162090	\N	162090	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.514091-03	2026-02-27 20:02:09.514091-03
770	Produto 218184	\N	218184	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.515089-03	2026-02-27 20:02:09.51604-03
771	Produto 256331	\N	256331	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.51737-03	2026-02-27 20:02:09.51737-03
772	Produto 135058	\N	135058	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.51838-03	2026-02-27 20:02:09.51938-03
773	Produto 154850	\N	154850	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.520375-03	2026-02-27 20:02:09.521379-03
774	Produto 148169	\N	148169	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.52238-03	2026-02-27 20:02:09.523404-03
775	Produto 220209	\N	220209	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.524657-03	2026-02-27 20:02:09.525692-03
776	Produto 121968	\N	121968	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.526696-03	2026-02-27 20:02:09.52771-03
777	Produto 239219	\N	239219	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.528757-03	2026-02-27 20:02:09.528757-03
778	Produto 97171	\N	97171	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.530758-03	2026-02-27 20:02:09.530758-03
779	Produto 228438	\N	228438	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.531751-03	2026-02-27 20:02:09.53271-03
780	Produto 241067	\N	241067	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.534057-03	2026-02-27 20:02:09.534057-03
781	Produto 221567	\N	221567	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.536047-03	2026-02-27 20:02:09.536047-03
782	Produto 252083	\N	252083	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.537044-03	2026-02-27 20:02:09.538045-03
783	Produto 110184	\N	110184	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.539043-03	2026-02-27 20:02:09.539043-03
784	Produto 110189	\N	110189	Geral	Descoberto em Todos os Produtos (Pág 41)	\N	5	0.00	\N	2026-02-27 20:02:09.54101-03	2026-02-27 20:02:09.54101-03
785	Produto 23154	\N	23154	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.773921-03	2026-02-27 20:02:16.773921-03
786	Produto 256325	\N	256325	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.781698-03	2026-02-27 20:02:16.781698-03
787	Produto 122461	\N	122461	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.782702-03	2026-02-27 20:02:16.782702-03
788	Produto 194224	\N	194224	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.782702-03	2026-02-27 20:02:16.782702-03
789	Produto 219704	\N	219704	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.782702-03	2026-02-27 20:02:16.782702-03
790	Produto 219739	\N	219739	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.782702-03	2026-02-27 20:02:16.782702-03
791	Produto 95757	\N	95757	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.789985-03	2026-02-27 20:02:16.789985-03
792	Produto 113245	\N	113245	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.790724-03	2026-02-27 20:02:16.790724-03
793	Produto 88103	\N	88103	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.790724-03	2026-02-27 20:02:16.790724-03
794	Produto 174326	\N	174326	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.790724-03	2026-02-27 20:02:16.790724-03
795	Produto 110185	\N	110185	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.790724-03	2026-02-27 20:02:16.790724-03
796	Produto 204434	\N	204434	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.798315-03	2026-02-27 20:02:16.798315-03
797	Produto 236589	\N	236589	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.799127-03	2026-02-27 20:02:16.799127-03
798	Produto 172099	\N	172099	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.799127-03	2026-02-27 20:02:16.799127-03
799	Produto 159952	\N	159952	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.799127-03	2026-02-27 20:02:16.799127-03
800	Produto 122115	\N	122115	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.799127-03	2026-02-27 20:02:16.799127-03
801	Produto 169166	\N	169166	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.806669-03	2026-02-27 20:02:16.807381-03
802	Produto 116198	\N	116198	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.807381-03	2026-02-27 20:02:16.807381-03
803	Produto 116199	\N	116199	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.807381-03	2026-02-27 20:02:16.807381-03
804	Produto 150216	\N	150216	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.807381-03	2026-02-27 20:02:16.807381-03
805	Produto 7977	\N	7977	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.807381-03	2026-02-27 20:02:16.807381-03
806	Produto 86013	\N	86013	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.815778-03	2026-02-27 20:02:16.815778-03
807	Produto 122121	\N	122121	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.815778-03	2026-02-27 20:02:16.815778-03
808	Produto 186458	\N	186458	Geral	Descoberto em Todos os Produtos (Pág 42)	\N	5	0.00	\N	2026-02-27 20:02:16.818611-03	2026-02-27 20:02:16.818611-03
809	Produto 167192	\N	167192	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.547099-03	2026-02-27 20:02:24.548107-03
810	Produto 231708	\N	231708	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.548476-03	2026-02-27 20:02:24.548476-03
811	Produto 212742	\N	212742	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.548476-03	2026-02-27 20:02:24.548476-03
812	Produto 19949	\N	19949	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.548476-03	2026-02-27 20:02:24.555358-03
813	Produto 148439	\N	148439	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.556421-03	2026-02-27 20:02:24.556421-03
814	Produto 15825	\N	15825	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.558454-03	2026-02-27 20:02:24.558454-03
815	Produto 197470	\N	197470	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.558454-03	2026-02-27 20:02:24.558454-03
816	Produto 213205	\N	213205	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.563185-03	2026-02-27 20:02:24.563751-03
817	Produto 241078	\N	241078	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.564719-03	2026-02-27 20:02:24.564719-03
818	Produto 105024	\N	105024	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.566728-03	2026-02-27 20:02:24.566728-03
819	Produto 217174	\N	217174	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.568733-03	2026-02-27 20:02:24.568733-03
820	Produto 110186	\N	110186	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.570737-03	2026-02-27 20:02:24.570737-03
821	Produto 170806	\N	170806	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.57208-03	2026-02-27 20:02:24.573049-03
822	Produto 221669	\N	221669	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.573049-03	2026-02-27 20:02:24.573049-03
823	Produto 164506	\N	164506	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.573049-03	2026-02-27 20:02:24.573049-03
824	Produto 203382	\N	203382	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.573049-03	2026-02-27 20:02:24.578629-03
825	Produto 131411	\N	131411	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.578629-03	2026-02-27 20:02:24.578629-03
826	Produto 139255	\N	139255	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.581502-03	2026-02-27 20:02:24.581502-03
827	Produto 159122	\N	159122	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.581502-03	2026-02-27 20:02:24.581502-03
828	Produto 219743	\N	219743	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.585051-03	2026-02-27 20:02:24.585051-03
829	Produto 54406	\N	54406	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.585051-03	2026-02-27 20:02:24.585051-03
830	Produto 171127	\N	171127	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.588699-03	2026-02-27 20:02:24.589733-03
831	Produto 174594	\N	174594	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.589733-03	2026-02-27 20:02:24.589733-03
832	Produto 102738	\N	102738	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.589733-03	2026-02-27 20:02:24.589733-03
833	Produto 235586	\N	235586	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.73862-03	2026-02-27 20:02:31.73862-03
834	Produto 151021	\N	151021	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.73862-03	2026-02-27 20:02:31.73862-03
835	Produto 217163	\N	217163	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.746309-03	2026-02-27 20:02:31.747092-03
836	Produto 228806	\N	228806	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.747092-03	2026-02-27 20:02:31.747092-03
837	Produto 176905	\N	176905	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.747092-03	2026-02-27 20:02:31.747092-03
838	Produto 110680	\N	110680	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.747092-03	2026-02-27 20:02:31.747092-03
839	Produto 156246	\N	156246	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.75512-03	2026-02-27 20:02:31.75542-03
840	Produto 103593	\N	103593	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.75542-03	2026-02-27 20:02:31.75542-03
841	Produto 93029	\N	93029	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.75542-03	2026-02-27 20:02:31.75542-03
842	Produto 208774	\N	208774	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.75542-03	2026-02-27 20:02:31.75542-03
843	Produto 184337	\N	184337	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.762661-03	2026-02-27 20:02:31.763177-03
844	Produto 148165	\N	148165	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.764878-03	2026-02-27 20:02:31.764878-03
845	Produto 16873	\N	16873	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.764878-03	2026-02-27 20:02:31.764878-03
846	Produto 194200	\N	194200	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.764878-03	2026-02-27 20:02:31.764878-03
847	Produto 259841	\N	259841	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.764878-03	2026-02-27 20:02:31.764878-03
848	Produto 164508	\N	164508	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.771117-03	2026-02-27 20:02:31.771598-03
849	Produto 169229	\N	169229	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.771598-03	2026-02-27 20:02:31.771598-03
850	Produto 203810	\N	203810	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.771598-03	2026-02-27 20:02:31.771598-03
851	Produto 8882	\N	8882	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.771598-03	2026-02-27 20:02:31.771598-03
852	Produto 7741	\N	7741	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.771598-03	2026-02-27 20:02:31.771598-03
853	Produto 184953	\N	184953	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.771598-03	2026-02-27 20:02:31.779616-03
854	Produto 67645	\N	67645	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.779996-03	2026-02-27 20:02:31.779996-03
855	Produto 122474	\N	122474	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.779996-03	2026-02-27 20:02:31.779996-03
856	Produto 239190	\N	239190	Geral	Descoberto em Todos os Produtos (Pág 44)	\N	5	0.00	\N	2026-02-27 20:02:31.779996-03	2026-02-27 20:02:31.779996-03
857	Produto 15045	\N	15045	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.736724-03	2026-02-27 20:02:45.736724-03
858	Produto 178865	\N	178865	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.736724-03	2026-02-27 20:02:45.736724-03
859	Produto 119239	\N	119239	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.745052-03	2026-02-27 20:02:45.745052-03
860	Produto 189394	\N	189394	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.745052-03	2026-02-27 20:02:45.745052-03
861	Produto 190371	\N	190371	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.745052-03	2026-02-27 20:02:45.745052-03
862	Produto 176907	\N	176907	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.745052-03	2026-02-27 20:02:45.745052-03
863	Produto 184481	\N	184481	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.753152-03	2026-02-27 20:02:45.753152-03
864	Produto 219725	\N	219725	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.753152-03	2026-02-27 20:02:45.753152-03
865	Produto 140711	\N	140711	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.753152-03	2026-02-27 20:02:45.753152-03
866	Produto 70996	\N	70996	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.753152-03	2026-02-27 20:02:45.753152-03
867	Produto 189393	\N	189393	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.760605-03	2026-02-27 20:02:45.760605-03
868	Produto 178148	\N	178148	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.761668-03	2026-02-27 20:02:45.761668-03
869	Produto 55105	\N	55105	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.761668-03	2026-02-27 20:02:45.761668-03
870	Produto 2271	\N	2271	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.761668-03	2026-02-27 20:02:45.761668-03
871	Produto 167174	\N	167174	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.761668-03	2026-02-27 20:02:45.761668-03
872	Produto 103145	\N	103145	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.770185-03	2026-02-27 20:02:45.770185-03
873	Produto 134588	\N	134588	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.770185-03	2026-02-27 20:02:45.770185-03
874	Produto 150228	\N	150228	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.770185-03	2026-02-27 20:02:45.770185-03
875	Produto 100146	\N	100146	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.770185-03	2026-02-27 20:02:45.770185-03
876	Produto 97172	\N	97172	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.777412-03	2026-02-27 20:02:45.777412-03
877	Produto 152331	\N	152331	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.778485-03	2026-02-27 20:02:45.778485-03
878	Produto 228238	\N	228238	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.778485-03	2026-02-27 20:02:45.778485-03
879	Produto 167331	\N	167331	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.778485-03	2026-02-27 20:02:45.778485-03
880	Produto 107364	\N	107364	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.03719-03	2026-02-27 20:02:53.03919-03
881	Produto 228445	\N	228445	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.04119-03	2026-02-27 20:02:53.04119-03
882	Produto 210839	\N	210839	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.043669-03	2026-02-27 20:02:53.043669-03
883	Produto 200649	\N	200649	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.045765-03	2026-02-27 20:02:53.045765-03
884	Produto 55104	\N	55104	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.047779-03	2026-02-27 20:02:53.047779-03
885	Produto 75505	\N	75505	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.048766-03	2026-02-27 20:02:53.049764-03
886	Produto 164516	\N	164516	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.051192-03	2026-02-27 20:02:53.051192-03
887	Produto 185928	\N	185928	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.052459-03	2026-02-27 20:02:53.053461-03
888	Produto 194815	\N	194815	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.054471-03	2026-02-27 20:02:53.055461-03
889	Produto 180461	\N	180461	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.056458-03	2026-02-27 20:02:53.056458-03
890	Produto 152283	\N	152283	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.057457-03	2026-02-27 20:02:53.057457-03
891	Produto 150219	\N	150219	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.058459-03	2026-02-27 20:02:53.05978-03
892	Produto 123157	\N	123157	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.05978-03	2026-02-27 20:02:53.061048-03
893	Produto 148449	\N	148449	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.062045-03	2026-02-27 20:02:53.063043-03
894	Produto 133589	\N	133589	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.065008-03	2026-02-27 20:02:53.065008-03
895	Produto 150739	\N	150739	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.066006-03	2026-02-27 20:02:53.067004-03
896	Produto 8847	\N	8847	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.067865-03	2026-02-27 20:02:53.069193-03
897	Produto 4960	\N	4960	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.071183-03	2026-02-27 20:02:53.071183-03
898	Produto 27251	\N	27251	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.07219-03	2026-02-27 20:02:53.073192-03
899	Produto 133503	\N	133503	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.07419-03	2026-02-27 20:02:53.07419-03
900	Produto 73189	\N	73189	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.075191-03	2026-02-27 20:02:53.076189-03
901	Produto 70401	\N	70401	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.076508-03	2026-02-27 20:02:53.077594-03
902	Produto 185782	\N	185782	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.078593-03	2026-02-27 20:02:53.078593-03
903	Produto 147434	\N	147434	Geral	Descoberto em Todos os Produtos (Pág 47)	\N	5	0.00	\N	2026-02-27 20:02:53.079593-03	2026-02-27 20:02:53.080592-03
904	Produto 171367	\N	171367	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.842876-03	2026-02-27 20:03:00.843878-03
905	Produto 8883	\N	8883	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.845877-03	2026-02-27 20:03:00.846876-03
906	Produto 34089	\N	34089	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.847876-03	2026-02-27 20:03:00.848878-03
907	Produto 125798	\N	125798	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.849878-03	2026-02-27 20:03:00.850879-03
908	Produto 150340	\N	150340	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.851877-03	2026-02-27 20:03:00.852878-03
909	Produto 95988	\N	95988	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.853876-03	2026-02-27 20:03:00.854875-03
910	Produto 148448	\N	148448	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.855875-03	2026-02-27 20:03:00.855875-03
911	Produto 208143	\N	208143	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.857876-03	2026-02-27 20:03:00.857876-03
912	Produto 117687	\N	117687	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.859879-03	2026-02-27 20:03:00.859879-03
913	Produto 93024	\N	93024	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.861065-03	2026-02-27 20:03:00.862065-03
914	Produto 126943	\N	126943	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.863063-03	2026-02-27 20:03:00.863063-03
915	Produto 148166	\N	148166	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.865065-03	2026-02-27 20:03:00.865065-03
916	Produto 56766	\N	56766	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.867066-03	2026-02-27 20:03:00.867066-03
917	Produto 235676	\N	235676	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.869064-03	2026-02-27 20:03:00.869064-03
918	Produto 162094	\N	162094	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.870063-03	2026-02-27 20:03:00.871063-03
919	Produto 23082	\N	23082	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.872064-03	2026-02-27 20:03:00.873063-03
920	Produto 15826	\N	15826	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.874066-03	2026-02-27 20:03:00.874066-03
921	Produto 167106	\N	167106	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.876066-03	2026-02-27 20:03:00.876066-03
922	Produto 221671	\N	221671	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.878064-03	2026-02-27 20:03:00.878064-03
923	Produto 216040	\N	216040	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.879064-03	2026-02-27 20:03:00.880063-03
924	Produto 97169	\N	97169	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.881249-03	2026-02-27 20:03:00.881249-03
925	Produto 228805	\N	228805	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.882247-03	2026-02-27 20:03:00.883254-03
926	Produto 110679	\N	110679	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.885248-03	2026-02-27 20:03:00.885248-03
927	Produto 164517	\N	164517	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:08.877383-03	2026-02-27 20:03:08.879391-03
928	Produto 239968	\N	239968	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:08.991953-03	2026-02-27 20:03:08.993961-03
929	Produto 107359	\N	107359	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:08.995968-03	2026-02-27 20:03:08.995968-03
930	Produto 222193	\N	222193	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:08.998836-03	2026-02-27 20:03:08.999844-03
931	Produto 183307	\N	183307	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.000188-03	2026-02-27 20:03:09.000188-03
932	Produto 108877	\N	108877	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.000188-03	2026-02-27 20:03:09.000188-03
933	Produto 114585	\N	114585	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.000188-03	2026-02-27 20:03:09.000188-03
934	Produto 166359	\N	166359	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.000188-03	2026-02-27 20:03:09.007091-03
935	Produto 105026	\N	105026	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.008187-03	2026-02-27 20:03:09.008187-03
936	Produto 58406	\N	58406	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.008187-03	2026-02-27 20:03:09.008187-03
937	Produto 140045	\N	140045	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.008187-03	2026-02-27 20:03:09.008187-03
938	Produto 147457	\N	147457	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.008187-03	2026-02-27 20:03:09.008187-03
939	Produto 92551	\N	92551	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.015416-03	2026-02-27 20:03:09.015416-03
940	Produto 110644	\N	110644	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.016458-03	2026-02-27 20:03:09.016458-03
941	Produto 6422	\N	6422	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.316579-03	2026-02-27 20:03:09.322872-03
942	Produto 148174	\N	148174	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.324826-03	2026-02-27 20:03:09.324826-03
943	Produto 241059	\N	241059	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.326844-03	2026-02-27 20:03:09.326844-03
944	Produto 194397	\N	194397	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.328851-03	2026-02-27 20:03:09.328851-03
945	Produto 219072	\N	219072	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.328851-03	2026-02-27 20:03:09.328851-03
946	Produto 226815	\N	226815	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.332048-03	2026-02-27 20:03:09.333077-03
947	Produto 221208	\N	221208	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.333584-03	2026-02-27 20:03:09.335588-03
948	Produto 229969	\N	229969	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.335588-03	2026-02-27 20:03:09.335588-03
949	Produto 155285	\N	155285	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.337591-03	2026-02-27 20:03:09.339595-03
950	Produto 92604	\N	92604	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.340328-03	2026-02-27 20:03:09.341379-03
951	Produto 173003	\N	173003	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.272778-03	2026-02-27 20:03:17.273775-03
952	Produto 6587	\N	6587	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.273775-03	2026-02-27 20:03:17.273775-03
953	Produto 148159	\N	148159	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.273775-03	2026-02-27 20:03:17.273775-03
954	Produto 231694	\N	231694	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.280903-03	2026-02-27 20:03:17.281908-03
955	Produto 217206	\N	217206	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.281908-03	2026-02-27 20:03:17.281908-03
956	Produto 152271	\N	152271	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.281908-03	2026-02-27 20:03:17.281908-03
957	Produto 173608	\N	173608	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.281908-03	2026-02-27 20:03:17.281908-03
958	Produto 219735	\N	219735	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.281908-03	2026-02-27 20:03:17.281908-03
959	Produto 156233	\N	156233	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.281908-03	2026-02-27 20:03:17.289405-03
960	Produto 148478	\N	148478	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.290114-03	2026-02-27 20:03:17.290114-03
961	Produto 148405	\N	148405	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.290114-03	2026-02-27 20:03:17.290114-03
962	Produto 217198	\N	217198	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.290114-03	2026-02-27 20:03:17.290114-03
963	Produto 24865	\N	24865	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.290114-03	2026-02-27 20:03:17.290114-03
964	Produto 218192	\N	218192	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.290114-03	2026-02-27 20:03:17.290114-03
965	Produto 235588	\N	235588	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.298345-03	2026-02-27 20:03:17.298345-03
966	Produto 69651	\N	69651	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.298345-03	2026-02-27 20:03:17.298345-03
967	Produto 116530	\N	116530	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.298345-03	2026-02-27 20:03:17.298345-03
968	Produto 127775	\N	127775	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.298345-03	2026-02-27 20:03:17.298345-03
969	Produto 179458	\N	179458	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.298345-03	2026-02-27 20:03:17.298345-03
970	Produto 160265	\N	160265	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.298345-03	2026-02-27 20:03:17.305924-03
971	Produto 139241	\N	139241	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.306766-03	2026-02-27 20:03:17.306766-03
972	Produto 105715	\N	105715	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.306766-03	2026-02-27 20:03:17.306766-03
973	Produto 127761	\N	127761	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.306766-03	2026-02-27 20:03:17.306766-03
974	Produto 191628	\N	191628	Geral	Descoberto em Todos os Produtos (Pág 50)	\N	5	0.00	\N	2026-02-27 20:03:17.306766-03	2026-02-27 20:03:17.306766-03
975	Produto 148441	\N	148441	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.64653-03	2026-02-27 20:03:24.64808-03
976	Produto 116688	\N	116688	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.64808-03	2026-02-27 20:03:24.64808-03
977	Produto 239268	\N	239268	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.64808-03	2026-02-27 20:03:24.64808-03
978	Produto 239267	\N	239267	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.65644-03	2026-02-27 20:03:24.65644-03
979	Produto 181008	\N	181008	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.65644-03	2026-02-27 20:03:24.65644-03
980	Produto 95778	\N	95778	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.65644-03	2026-02-27 20:03:24.65644-03
981	Produto 173010	\N	173010	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.663171-03	2026-02-27 20:03:24.664088-03
982	Produto 219703	\N	219703	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.664088-03	2026-02-27 20:03:24.664088-03
983	Produto 180820	\N	180820	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.664088-03	2026-02-27 20:03:24.664088-03
984	Produto 239980	\N	239980	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.664088-03	2026-02-27 20:03:24.664088-03
985	Produto 116531	\N	116531	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.664088-03	2026-02-27 20:03:24.664088-03
986	Produto 9304	\N	9304	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.664088-03	2026-02-27 20:03:24.671497-03
987	Produto 171110	\N	171110	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.672532-03	2026-02-27 20:03:24.672532-03
988	Produto 168818	\N	168818	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.672532-03	2026-02-27 20:03:24.672532-03
989	Produto 229968	\N	229968	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.672532-03	2026-02-27 20:03:24.672532-03
990	Produto 95773	\N	95773	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.672532-03	2026-02-27 20:03:24.672532-03
991	Produto 148479	\N	148479	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.672532-03	2026-02-27 20:03:24.672532-03
992	Produto 19852	\N	19852	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.680839-03	2026-02-27 20:03:24.680839-03
993	Produto 148409	\N	148409	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.680839-03	2026-02-27 20:03:24.680839-03
994	Produto 148471	\N	148471	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.680839-03	2026-02-27 20:03:24.680839-03
995	Produto 151032	\N	151032	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.680839-03	2026-02-27 20:03:24.680839-03
996	Produto 241079	\N	241079	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.680839-03	2026-02-27 20:03:24.680839-03
997	Produto 219736	\N	219736	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.689169-03	2026-02-27 20:03:24.689169-03
998	Produto 108128	\N	108128	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.689169-03	2026-02-27 20:03:24.689169-03
999	Produto 108409	\N	108409	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.204416-03	2026-02-27 20:03:33.204416-03
1000	Produto 175103	\N	175103	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.204416-03	2026-02-27 20:03:33.204416-03
1001	Produto 180469	\N	180469	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.212901-03	2026-02-27 20:03:33.212901-03
1002	Produto 115659	\N	115659	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.212901-03	2026-02-27 20:03:33.212901-03
1003	Produto 148435	\N	148435	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.212901-03	2026-02-27 20:03:33.212901-03
1004	Produto 172411	\N	172411	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.219675-03	2026-02-27 20:03:33.220201-03
1005	Produto 98943	\N	98943	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.221834-03	2026-02-27 20:03:33.222456-03
1006	Produto 213231	\N	213231	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.223656-03	2026-02-27 20:03:33.224184-03
1007	Produto 9583	\N	9583	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.225248-03	2026-02-27 20:03:33.225765-03
1008	Produto 148410	\N	148410	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.227383-03	2026-02-27 20:03:33.227383-03
1009	Produto 215258	\N	215258	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.228961-03	2026-02-27 20:03:33.229389-03
1010	Produto 239176	\N	239176	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.230997-03	2026-02-27 20:03:33.230997-03
1011	Produto 148400	\N	148400	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.232095-03	2026-02-27 20:03:33.232652-03
1012	Produto 110681	\N	110681	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.233758-03	2026-02-27 20:03:33.234279-03
1013	Produto 217180	\N	217180	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.235374-03	2026-02-27 20:03:33.235941-03
1014	Produto 92573	\N	92573	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.237205-03	2026-02-27 20:03:33.237593-03
1015	Produto 155890	\N	155890	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.238663-03	2026-02-27 20:03:33.239222-03
1016	Produto 164820	\N	164820	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.240329-03	2026-02-27 20:03:33.240329-03
1017	Produto 169235	\N	169235	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.242003-03	2026-02-27 20:03:33.242003-03
1018	Produto 162012	\N	162012	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.242003-03	2026-02-27 20:03:33.242003-03
1019	Produto 95123	\N	95123	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.242003-03	2026-02-27 20:03:33.245062-03
1020	Produto 246101	\N	246101	Geral	Descoberto em Todos os Produtos (Pág 52)	\N	5	0.00	\N	2026-02-27 20:03:33.245952-03	2026-02-27 20:03:33.245952-03
1021	Produto 195643	\N	195643	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.084754-03	2026-02-27 20:03:41.086051-03
1022	Produto 102729	\N	102729	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.088151-03	2026-02-27 20:03:41.08915-03
1023	Produto 239269	\N	239269	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.09115-03	2026-02-27 20:03:41.09215-03
1024	Produto 208131	\N	208131	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.094363-03	2026-02-27 20:03:41.094363-03
1025	Produto 174175	\N	174175	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.096395-03	2026-02-27 20:03:41.096395-03
1026	Produto 160269	\N	160269	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.098389-03	2026-02-27 20:03:41.098389-03
1027	Produto 129969	\N	129969	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.099396-03	2026-02-27 20:03:41.100396-03
1028	Produto 4741	\N	4741	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.101396-03	2026-02-27 20:03:41.101396-03
1029	Produto 239984	\N	239984	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.103171-03	2026-02-27 20:03:41.103171-03
1030	Produto 148455	\N	148455	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.103171-03	2026-02-27 20:03:41.103171-03
1031	Produto 164505	\N	164505	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.103171-03	2026-02-27 20:03:41.103171-03
1032	Produto 108136	\N	108136	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.103171-03	2026-02-27 20:03:41.103171-03
1033	Produto 216050	\N	216050	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.103171-03	2026-02-27 20:03:41.103171-03
1034	Produto 103134	\N	103134	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.111622-03	2026-02-27 20:03:41.111622-03
1035	Produto 118905	\N	118905	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.111622-03	2026-02-27 20:03:41.111622-03
1036	Produto 204429	\N	204429	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.111622-03	2026-02-27 20:03:41.111622-03
1037	Produto 110181	\N	110181	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.111622-03	2026-02-27 20:03:41.111622-03
1038	Produto 108135	\N	108135	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.111622-03	2026-02-27 20:03:41.111622-03
1039	Produto 107325	\N	107325	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.120245-03	2026-02-27 20:03:41.120635-03
1040	Produto 229972	\N	229972	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.120635-03	2026-02-27 20:03:41.120635-03
1041	Produto 155876	\N	155876	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.120635-03	2026-02-27 20:03:41.120635-03
1042	Produto 228434	\N	228434	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.120635-03	2026-02-27 20:03:41.120635-03
1043	Produto 166332	\N	166332	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.120635-03	2026-02-27 20:03:41.120635-03
1044	Produto 189863	\N	189863	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.252398-03	2026-02-27 20:03:48.252398-03
1045	Produto 244742	\N	244742	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.260833-03	2026-02-27 20:03:48.260833-03
1046	Produto 140004	\N	140004	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.260833-03	2026-02-27 20:03:48.260833-03
1047	Produto 110191	\N	110191	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.260833-03	2026-02-27 20:03:48.260833-03
1048	Produto 218209	\N	218209	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.260833-03	2026-02-27 20:03:48.268012-03
1049	Produto 170769	\N	170769	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.269082-03	2026-02-27 20:03:48.269082-03
1050	Produto 212781	\N	212781	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.269082-03	2026-02-27 20:03:48.269082-03
1051	Produto 241080	\N	241080	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.269082-03	2026-02-27 20:03:48.269082-03
1052	Produto 172410	\N	172410	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.273905-03	2026-02-27 20:03:48.273905-03
1053	Produto 9432	\N	9432	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.273905-03	2026-02-27 20:03:48.276321-03
1054	Produto 167322	\N	167322	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.27737-03	2026-02-27 20:03:48.27737-03
1055	Produto 109482	\N	109482	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.27737-03	2026-02-27 20:03:48.27737-03
1056	Produto 111466	\N	111466	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.27737-03	2026-02-27 20:03:48.27737-03
1057	Produto 219722	\N	219722	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.27737-03	2026-02-27 20:03:48.27737-03
1058	Produto 218215	\N	218215	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.27737-03	2026-02-27 20:03:48.27737-03
1059	Produto 56757	\N	56757	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.285671-03	2026-02-27 20:03:48.285671-03
1060	Produto 16872	\N	16872	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.285671-03	2026-02-27 20:03:48.285671-03
1061	Produto 108463	\N	108463	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.285671-03	2026-02-27 20:03:48.285671-03
1062	Produto 216472	\N	216472	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.285671-03	2026-02-27 20:03:48.285671-03
1063	Produto 108126	\N	108126	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.285671-03	2026-02-27 20:03:48.285671-03
1064	Produto 221679	\N	221679	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.292971-03	2026-02-27 20:03:48.29402-03
1065	Produto 215270	\N	215270	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.29402-03	2026-02-27 20:03:48.29402-03
1066	Produto 154848	\N	154848	Geral	Descoberto em Todos os Produtos (Pág 54)	\N	5	0.00	\N	2026-02-27 20:03:48.29402-03	2026-02-27 20:03:48.29402-03
1067	Produto 231401	\N	231401	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.711585-03	2026-02-27 20:04:03.71259-03
1068	Produto 239975	\N	239975	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.715918-03	2026-02-27 20:04:03.715918-03
1069	Produto 217207	\N	217207	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.717953-03	2026-02-27 20:04:03.719014-03
1070	Produto 160273	\N	160273	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.720953-03	2026-02-27 20:04:03.720953-03
1071	Produto 110192	\N	110192	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.722969-03	2026-02-27 20:04:03.722969-03
1072	Produto 107324	\N	107324	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.724263-03	2026-02-27 20:04:03.725265-03
1073	Produto 108132	\N	108132	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.726265-03	2026-02-27 20:04:03.726265-03
1074	Produto 229965	\N	229965	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.727265-03	2026-02-27 20:04:03.728265-03
1075	Produto 140046	\N	140046	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.729265-03	2026-02-27 20:04:03.729265-03
1076	Produto 219075	\N	219075	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.730264-03	2026-02-27 20:04:03.731264-03
1077	Produto 123735	\N	123735	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.732268-03	2026-02-27 20:04:03.732268-03
1078	Produto 152330	\N	152330	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.733526-03	2026-02-27 20:04:03.733526-03
1079	Produto 17276	\N	17276	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.734525-03	2026-02-27 20:04:03.735526-03
1080	Produto 116192	\N	116192	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.736526-03	2026-02-27 20:04:03.736526-03
1081	Produto 105713	\N	105713	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.737527-03	2026-02-27 20:04:03.738526-03
1082	Produto 110810	\N	110810	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.739526-03	2026-02-27 20:04:03.739526-03
1083	Produto 239250	\N	239250	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.740904-03	2026-02-27 20:04:03.740904-03
1084	Produto 93505	\N	93505	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.741624-03	2026-02-27 20:04:03.741624-03
1085	Produto 194522	\N	194522	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.741624-03	2026-02-27 20:04:03.741624-03
1086	Produto 106534	\N	106534	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.741624-03	2026-02-27 20:04:03.741624-03
1087	Produto 118910	\N	118910	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.741624-03	2026-02-27 20:04:03.748792-03
1088	Produto 217168	\N	217168	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.749714-03	2026-02-27 20:04:03.749714-03
1089	Produto 113409	\N	113409	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.749714-03	2026-02-27 20:04:03.749714-03
1090	Produto 7740	\N	7740	Geral	Descoberto em Todos os Produtos (Pág 56)	\N	5	0.00	\N	2026-02-27 20:04:03.749714-03	2026-02-27 20:04:03.749714-03
1091	Produto 135037	\N	135037	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.539309-03	2026-02-27 20:04:11.539309-03
1092	Produto 254619	\N	254619	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.539309-03	2026-02-27 20:04:11.539309-03
1093	Produto 97639	\N	97639	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.547635-03	2026-02-27 20:04:11.547942-03
1094	Produto 97644	\N	97644	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.547942-03	2026-02-27 20:04:11.547942-03
1095	Produto 116689	\N	116689	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.547942-03	2026-02-27 20:04:11.547942-03
1096	Produto 98941	\N	98941	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.547942-03	2026-02-27 20:04:11.547942-03
1097	Produto 23037	\N	23037	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.547942-03	2026-02-27 20:04:11.547942-03
1098	Produto 134695	\N	134695	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.556008-03	2026-02-27 20:04:11.556008-03
1099	Produto 167296	\N	167296	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.556008-03	2026-02-27 20:04:11.556008-03
1100	Produto 195641	\N	195641	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.556008-03	2026-02-27 20:04:11.556008-03
1101	Produto 173612	\N	173612	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.556008-03	2026-02-27 20:04:11.556008-03
1102	Produto 108129	\N	108129	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.564298-03	2026-02-27 20:04:11.564298-03
1103	Produto 120195	\N	120195	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.564298-03	2026-02-27 20:04:11.564298-03
1104	Produto 239972	\N	239972	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.564298-03	2026-02-27 20:04:11.564298-03
1105	Produto 95776	\N	95776	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.564298-03	2026-02-27 20:04:11.564298-03
1106	Produto 135035	\N	135035	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.564298-03	2026-02-27 20:04:11.572641-03
1107	Produto 181129	\N	181129	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.572641-03	2026-02-27 20:04:11.572641-03
1108	Produto 160235	\N	160235	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.572641-03	2026-02-27 20:04:11.572641-03
1109	Produto 177282	\N	177282	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.572641-03	2026-02-27 20:04:11.572641-03
1110	Produto 239728	\N	239728	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.572641-03	2026-02-27 20:04:11.572641-03
1111	Produto 213238	\N	213238	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.581019-03	2026-02-27 20:04:11.581019-03
1112	Produto 194391	\N	194391	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.581019-03	2026-02-27 20:04:11.581019-03
1113	Produto 175112	\N	175112	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.581019-03	2026-02-27 20:04:11.581019-03
1114	Produto 170133	\N	170133	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.581019-03	2026-02-27 20:04:11.581019-03
1115	Produto 185536	\N	185536	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.330449-03	2026-02-27 20:04:20.330449-03
1116	Produto 92567	\N	92567	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.330449-03	2026-02-27 20:04:20.330449-03
1117	Produto 139240	\N	139240	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.330449-03	2026-02-27 20:04:20.330449-03
1118	Produto 92584	\N	92584	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.339005-03	2026-02-27 20:04:20.339005-03
1119	Produto 218191	\N	218191	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.339005-03	2026-02-27 20:04:20.339005-03
1120	Produto 211661	\N	211661	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.339005-03	2026-02-27 20:04:20.339005-03
1121	Produto 179460	\N	179460	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.339005-03	2026-02-27 20:04:20.346718-03
1122	Produto 102465	\N	102465	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.347069-03	2026-02-27 20:04:20.347069-03
1123	Produto 218195	\N	218195	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.347069-03	2026-02-27 20:04:20.347069-03
1124	Produto 126266	\N	126266	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.347069-03	2026-02-27 20:04:20.347069-03
1125	Produto 92549	\N	92549	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.347069-03	2026-02-27 20:04:20.347069-03
1126	Produto 169217	\N	169217	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.347069-03	2026-02-27 20:04:20.347069-03
1127	Produto 211656	\N	211656	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.355532-03	2026-02-27 20:04:20.355532-03
1128	Produto 115658	\N	115658	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.355532-03	2026-02-27 20:04:20.355532-03
1129	Produto 228437	\N	228437	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.355532-03	2026-02-27 20:04:20.355532-03
1130	Produto 228439	\N	228439	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.355532-03	2026-02-27 20:04:20.355532-03
1131	Produto 217205	\N	217205	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.355532-03	2026-02-27 20:04:20.355532-03
1132	Produto 239970	\N	239970	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.363358-03	2026-02-27 20:04:20.363871-03
1133	Produto 204420	\N	204420	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.363871-03	2026-02-27 20:04:20.363871-03
1134	Produto 239959	\N	239959	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.363871-03	2026-02-27 20:04:20.363871-03
1135	Produto 108144	\N	108144	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.363871-03	2026-02-27 20:04:20.363871-03
1136	Produto 137976	\N	137976	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.363871-03	2026-02-27 20:04:20.363871-03
1137	Produto 89381	\N	89381	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.363871-03	2026-02-27 20:04:20.363871-03
1138	Produto 216461	\N	216461	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.372113-03	2026-02-27 20:04:20.372113-03
1139	Produto 108131	\N	108131	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.663362-03	2026-02-27 20:04:27.663362-03
1140	Produto 191635	\N	191635	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.671619-03	2026-02-27 20:04:27.671619-03
1141	Produto 156236	\N	156236	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.671619-03	2026-02-27 20:04:27.671619-03
1142	Produto 116690	\N	116690	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.671619-03	2026-02-27 20:04:27.671619-03
1143	Produto 217172	\N	217172	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.679818-03	2026-02-27 20:04:27.679818-03
1144	Produto 239983	\N	239983	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.679818-03	2026-02-27 20:04:27.679818-03
1145	Produto 219719	\N	219719	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.679818-03	2026-02-27 20:04:27.679818-03
1146	Produto 228456	\N	228456	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.679818-03	2026-02-27 20:04:27.679818-03
1147	Produto 9125	\N	9125	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.679818-03	2026-02-27 20:04:27.679818-03
1148	Produto 112892	\N	112892	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.688019-03	2026-02-27 20:04:27.688019-03
1149	Produto 170137	\N	170137	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.688019-03	2026-02-27 20:04:27.688019-03
1150	Produto 215262	\N	215262	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.688019-03	2026-02-27 20:04:27.688019-03
1151	Produto 213237	\N	213237	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.688019-03	2026-02-27 20:04:27.688019-03
1152	Produto 113407	\N	113407	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.688019-03	2026-02-27 20:04:27.688019-03
1153	Produto 211657	\N	211657	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.695378-03	2026-02-27 20:04:27.695378-03
1154	Produto 107125	\N	107125	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.696197-03	2026-02-27 20:04:27.696197-03
1155	Produto 23153	\N	23153	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.696197-03	2026-02-27 20:04:27.696197-03
1156	Produto 95870	\N	95870	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.696197-03	2026-02-27 20:04:27.696197-03
1157	Produto 55107	\N	55107	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.696197-03	2026-02-27 20:04:27.696197-03
1158	Produto 189545	\N	189545	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.696197-03	2026-02-27 20:04:27.703834-03
1159	Produto 101037	\N	101037	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.704924-03	2026-02-27 20:04:27.704924-03
1160	Produto 95868	\N	95868	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.704924-03	2026-02-27 20:04:27.704924-03
1161	Produto 217195	\N	217195	Geral	Descoberto em Todos os Produtos (Pág 59)	\N	5	0.00	\N	2026-02-27 20:04:27.704924-03	2026-02-27 20:04:27.704924-03
1162	Produto 216071	\N	216071	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.492952-03	2026-02-27 20:04:36.493916-03
1163	Produto 169233	\N	169233	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.495931-03	2026-02-27 20:04:36.496484-03
1164	Produto 159923	\N	159923	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.498105-03	2026-02-27 20:04:36.498105-03
1165	Produto 114274	\N	114274	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.499731-03	2026-02-27 20:04:36.499731-03
1166	Produto 215257	\N	215257	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.500798-03	2026-02-27 20:04:36.50133-03
1167	Produto 140463	\N	140463	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.502745-03	2026-02-27 20:04:36.503118-03
1168	Produto 140712	\N	140712	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.504185-03	2026-02-27 20:04:36.504736-03
1169	Produto 135039	\N	135039	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.506356-03	2026-02-27 20:04:36.506356-03
1170	Produto 217201	\N	217201	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.506914-03	2026-02-27 20:04:36.506914-03
1171	Produto 241066	\N	241066	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.506914-03	2026-02-27 20:04:36.506914-03
1172	Produto 254614	\N	254614	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.510574-03	2026-02-27 20:04:36.510574-03
1173	Produto 104884	\N	104884	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.511614-03	2026-02-27 20:04:36.511614-03
1174	Produto 173604	\N	173604	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.511614-03	2026-02-27 20:04:36.511614-03
1175	Produto 194212	\N	194212	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.511614-03	2026-02-27 20:04:36.511614-03
1176	Produto 75233	\N	75233	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.511614-03	2026-02-27 20:04:36.511614-03
1177	Produto 174902	\N	174902	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.518919-03	2026-02-27 20:04:36.51999-03
1178	Produto 217190	\N	217190	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.51999-03	2026-02-27 20:04:36.51999-03
1179	Produto 194824	\N	194824	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.51999-03	2026-02-27 20:04:36.51999-03
1180	Produto 218182	\N	218182	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.51999-03	2026-02-27 20:04:36.51999-03
1181	Produto 170765	\N	170765	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.527258-03	2026-02-27 20:04:36.527258-03
1182	Produto 231697	\N	231697	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.528264-03	2026-02-27 20:04:36.528264-03
1183	Produto 113150	\N	113150	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.528264-03	2026-02-27 20:04:36.528264-03
1184	Produto 239979	\N	239979	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.528264-03	2026-02-27 20:04:36.528264-03
1185	Produto 219720	\N	219720	Geral	Descoberto em Todos os Produtos (Pág 60)	\N	5	0.00	\N	2026-02-27 20:04:36.528264-03	2026-02-27 20:04:36.528264-03
1186	Produto 217178	\N	217178	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.768946-03	2026-02-27 20:04:44.768946-03
1187	Produto 228447	\N	228447	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.768946-03	2026-02-27 20:04:44.768946-03
1188	Produto 110076	\N	110076	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.776894-03	2026-02-27 20:04:44.776894-03
1189	Produto 239976	\N	239976	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.776894-03	2026-02-27 20:04:44.776894-03
1190	Produto 232508	\N	232508	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.776894-03	2026-02-27 20:04:44.776894-03
1191	Produto 231701	\N	231701	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.784486-03	2026-02-27 20:04:44.784486-03
1192	Produto 191638	\N	191638	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.785262-03	2026-02-27 20:04:44.785262-03
1193	Produto 148444	\N	148444	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.785262-03	2026-02-27 20:04:44.785262-03
1194	Produto 166341	\N	166341	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.785262-03	2026-02-27 20:04:44.785262-03
1195	Produto 139238	\N	139238	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.785262-03	2026-02-27 20:04:44.785262-03
1196	Produto 139262	\N	139262	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.793378-03	2026-02-27 20:04:44.793378-03
1197	Produto 166345	\N	166345	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.793378-03	2026-02-27 20:04:44.793378-03
1198	Produto 139265	\N	139265	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.793378-03	2026-02-27 20:04:44.793378-03
1199	Produto 163210	\N	163210	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.793378-03	2026-02-27 20:04:44.793378-03
1200	Produto 109860	\N	109860	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.793378-03	2026-02-27 20:04:44.793378-03
1201	Produto 23152	\N	23152	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.801164-03	2026-02-27 20:04:44.802116-03
1202	Produto 164822	\N	164822	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.802116-03	2026-02-27 20:04:44.802116-03
1203	Produto 203384	\N	203384	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.802116-03	2026-02-27 20:04:44.802116-03
1204	Produto 246106	\N	246106	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.802116-03	2026-02-27 20:04:44.802116-03
1205	Produto 219738	\N	219738	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.802116-03	2026-02-27 20:04:44.802116-03
1206	Produto 110190	\N	110190	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.809397-03	2026-02-27 20:04:44.809397-03
1207	Produto 213239	\N	213239	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.810377-03	2026-02-27 20:04:44.810377-03
1208	Produto 140050	\N	140050	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.810377-03	2026-02-27 20:04:44.810377-03
1209	Produto 191639	\N	191639	Geral	Descoberto em Todos os Produtos (Pág 61)	\N	5	0.00	\N	2026-02-27 20:04:44.810377-03	2026-02-27 20:04:44.810377-03
1210	Produto 135047	\N	135047	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.217734-03	2026-02-27 20:04:52.217734-03
1211	Produto 120471	\N	120471	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.217734-03	2026-02-27 20:04:52.217734-03
1212	Produto 148417	\N	148417	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.226166-03	2026-02-27 20:04:52.226166-03
1213	Produto 239789	\N	239789	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.226166-03	2026-02-27 20:04:52.226166-03
1214	Produto 106129	\N	106129	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.226166-03	2026-02-27 20:04:52.226166-03
1215	Produto 216460	\N	216460	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.226166-03	2026-02-27 20:04:52.226166-03
1216	Produto 213553	\N	213553	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.226166-03	2026-02-27 20:04:52.226166-03
1217	Produto 213555	\N	213555	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.234321-03	2026-02-27 20:04:52.234321-03
1218	Produto 213554	\N	213554	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.234321-03	2026-02-27 20:04:52.234321-03
1219	Produto 148477	\N	148477	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.234321-03	2026-02-27 20:04:52.234321-03
1220	Produto 208139	\N	208139	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.234321-03	2026-02-27 20:04:52.234321-03
1221	Produto 218210	\N	218210	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.234321-03	2026-02-27 20:04:52.234321-03
1222	Produto 191619	\N	191619	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.241608-03	2026-02-27 20:04:52.241608-03
1223	Produto 105716	\N	105716	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.242581-03	2026-02-27 20:04:52.242581-03
1224	Produto 127766	\N	127766	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.242581-03	2026-02-27 20:04:52.242581-03
1225	Produto 218218	\N	218218	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.242581-03	2026-02-27 20:04:52.242581-03
1226	Produto 109481	\N	109481	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.242581-03	2026-02-27 20:04:52.242581-03
1227	Produto 97650	\N	97650	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.250628-03	2026-02-27 20:04:52.250628-03
1228	Produto 166352	\N	166352	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.250628-03	2026-02-27 20:04:52.250628-03
1229	Produto 124319	\N	124319	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.250628-03	2026-02-27 20:04:52.250628-03
1230	Produto 152267	\N	152267	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.250628-03	2026-02-27 20:04:52.250628-03
1231	Produto 246102	\N	246102	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.250628-03	2026-02-27 20:04:52.250628-03
1232	Produto 213228	\N	213228	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.250628-03	2026-02-27 20:04:52.258216-03
1233	Produto 256327	\N	256327	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.258938-03	2026-02-27 20:04:52.258938-03
1234	Produto 103999	\N	103999	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.467044-03	2026-02-27 20:04:59.467044-03
1235	Produto 228457	\N	228457	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.467044-03	2026-02-27 20:04:59.473973-03
1236	Produto 178163	\N	178163	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.475323-03	2026-02-27 20:04:59.475323-03
1237	Produto 216070	\N	216070	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.475323-03	2026-02-27 20:04:59.475323-03
1238	Produto 170135	\N	170135	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.475323-03	2026-02-27 20:04:59.475323-03
1239	Produto 70358	\N	70358	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.475323-03	2026-02-27 20:04:59.475323-03
1240	Produto 217193	\N	217193	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.482176-03	2026-02-27 20:04:59.482176-03
1241	Produto 216059	\N	216059	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.483182-03	2026-02-27 20:04:59.483182-03
1242	Produto 72020	\N	72020	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.483182-03	2026-02-27 20:04:59.483182-03
1243	Produto 156244	\N	156244	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.483182-03	2026-02-27 20:04:59.483182-03
1244	Produto 217170	\N	217170	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.483182-03	2026-02-27 20:04:59.483182-03
1245	Produto 256333	\N	256333	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.490513-03	2026-02-27 20:04:59.490513-03
1246	Produto 216062	\N	216062	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.49152-03	2026-02-27 20:04:59.49152-03
1247	Produto 170770	\N	170770	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.49152-03	2026-02-27 20:04:59.49152-03
1248	Produto 110187	\N	110187	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.49152-03	2026-02-27 20:04:59.49152-03
1249	Produto 9149	\N	9149	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.49152-03	2026-02-27 20:04:59.49152-03
1250	Produto 154851	\N	154851	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.49152-03	2026-02-27 20:04:59.49152-03
1251	Produto 219069	\N	219069	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.499731-03	2026-02-27 20:04:59.499731-03
1252	Produto 176444	\N	176444	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.499731-03	2026-02-27 20:04:59.499731-03
1253	Produto 215273	\N	215273	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.499731-03	2026-02-27 20:04:59.499731-03
1254	Produto 239987	\N	239987	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.499731-03	2026-02-27 20:04:59.499731-03
1255	Produto 169223	\N	169223	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.499731-03	2026-02-27 20:04:59.499731-03
1256	Produto 222192	\N	222192	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.507171-03	2026-02-27 20:04:59.508001-03
1257	Produto 166368	\N	166368	Geral	Descoberto em Todos os Produtos (Pág 63)	\N	5	0.00	\N	2026-02-27 20:04:59.508001-03	2026-02-27 20:04:59.508001-03
1258	Produto 155613	\N	155613	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.288592-03	2026-02-27 20:05:13.288592-03
1259	Produto 107127	\N	107127	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.291888-03	2026-02-27 20:05:13.291888-03
1260	Produto 148127	\N	148127	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.293909-03	2026-02-27 20:05:13.293909-03
1261	Produto 106125	\N	106125	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.295888-03	2026-02-27 20:05:13.296889-03
1262	Produto 106829	\N	106829	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.29826-03	2026-02-27 20:05:13.29926-03
1263	Produto 85389	\N	85389	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.30051-03	2026-02-27 20:05:13.301509-03
1264	Produto 97648	\N	97648	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.30251-03	2026-02-27 20:05:13.303509-03
1265	Produto 191626	\N	191626	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.30451-03	2026-02-27 20:05:13.305667-03
1266	Produto 110183	\N	110183	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.30671-03	2026-02-27 20:05:13.30771-03
1267	Produto 162010	\N	162010	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.30871-03	2026-02-27 20:05:13.309709-03
1268	Produto 254608	\N	254608	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.310711-03	2026-02-27 20:05:13.311709-03
1269	Produto 166361	\N	166361	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.312709-03	2026-02-27 20:05:13.313418-03
1270	Produto 176440	\N	176440	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.314752-03	2026-02-27 20:05:13.314752-03
1271	Produto 137959	\N	137959	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.316752-03	2026-02-27 20:05:13.316752-03
1272	Produto 72177	\N	72177	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.318752-03	2026-02-27 20:05:13.318752-03
1273	Produto 135025	\N	135025	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.320752-03	2026-02-27 20:05:13.320752-03
1274	Produto 228449	\N	228449	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.322961-03	2026-02-27 20:05:13.323492-03
1275	Produto 111426	\N	111426	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.324516-03	2026-02-27 20:05:13.325515-03
1276	Produto 218219	\N	218219	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.325515-03	2026-02-27 20:05:13.325515-03
1277	Produto 173606	\N	173606	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.325515-03	2026-02-27 20:05:13.325515-03
1278	Produto 229961	\N	229961	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.331047-03	2026-02-27 20:05:13.332047-03
1279	Produto 218200	\N	218200	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.333047-03	2026-02-27 20:05:13.334047-03
1280	Produto 216476	\N	216476	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.335046-03	2026-02-27 20:05:13.336047-03
1281	Produto 222190	\N	222190	Geral	Descoberto em Todos os Produtos (Pág 65)	\N	5	0.00	\N	2026-02-27 20:05:13.337046-03	2026-02-27 20:05:13.338047-03
1282	Produto 195640	\N	195640	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.804996-03	2026-02-27 20:05:21.812357-03
1283	Produto 173605	\N	173605	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.813364-03	2026-02-27 20:05:21.813364-03
1284	Produto 106128	\N	106128	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.813364-03	2026-02-27 20:05:21.813364-03
1285	Produto 239259	\N	239259	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.820719-03	2026-02-27 20:05:21.820719-03
1286	Produto 110195	\N	110195	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.821725-03	2026-02-27 20:05:21.821725-03
1287	Produto 221662	\N	221662	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.821725-03	2026-02-27 20:05:21.821725-03
1288	Produto 173597	\N	173597	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.821725-03	2026-02-27 20:05:21.821725-03
1289	Produto 244787	\N	244787	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.821725-03	2026-02-27 20:05:21.821725-03
1290	Produto 228451	\N	228451	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.828991-03	2026-02-27 20:05:21.82992-03
1291	Produto 239184	\N	239184	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.82992-03	2026-02-27 20:05:21.82992-03
1292	Produto 6586	\N	6586	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.82992-03	2026-02-27 20:05:21.82992-03
1293	Produto 6319	\N	6319	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.82992-03	2026-02-27 20:05:21.82992-03
1294	Produto 108125	\N	108125	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.82992-03	2026-02-27 20:05:21.82992-03
1295	Produto 219733	\N	219733	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.837312-03	2026-02-27 20:05:21.838128-03
1296	Produto 234125	\N	234125	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.838128-03	2026-02-27 20:05:21.838128-03
1297	Produto 191617	\N	191617	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.838128-03	2026-02-27 20:05:21.838128-03
1298	Produto 148436	\N	148436	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.838128-03	2026-02-27 20:05:21.838128-03
1299	Produto 6589	\N	6589	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.838128-03	2026-02-27 20:05:21.838128-03
1300	Produto 139804	\N	139804	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.846476-03	2026-02-27 20:05:21.846476-03
1301	Produto 102866	\N	102866	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.846476-03	2026-02-27 20:05:21.846476-03
1302	Produto 167635	\N	167635	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.846476-03	2026-02-27 20:05:21.846476-03
1303	Produto 97700	\N	97700	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.846476-03	2026-02-27 20:05:21.846476-03
1304	Produto 151545	\N	151545	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.846476-03	2026-02-27 20:05:21.846476-03
1305	Produto 204432	\N	204432	Geral	Descoberto em Todos os Produtos (Pág 66)	\N	5	0.00	\N	2026-02-27 20:05:21.854799-03	2026-02-27 20:05:21.854799-03
1306	Produto 217200	\N	217200	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.569972-03	2026-02-27 20:05:29.569972-03
1307	Produto 183308	\N	183308	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.569972-03	2026-02-27 20:05:29.569972-03
1308	Produto 238536	\N	238536	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.569972-03	2026-02-27 20:05:29.57792-03
1309	Produto 219732	\N	219732	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.578419-03	2026-02-27 20:05:29.578419-03
1310	Produto 219068	\N	219068	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.578419-03	2026-02-27 20:05:29.578419-03
1311	Produto 181521	\N	181521	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.578419-03	2026-02-27 20:05:29.578419-03
1312	Produto 239798	\N	239798	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.578419-03	2026-02-27 20:05:29.578419-03
1313	Produto 218211	\N	218211	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.586128-03	2026-02-27 20:05:29.586656-03
1314	Produto 254616	\N	254616	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.586656-03	2026-02-27 20:05:29.586656-03
1315	Produto 191636	\N	191636	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.586656-03	2026-02-27 20:05:29.586656-03
1316	Produto 239186	\N	239186	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.586656-03	2026-02-27 20:05:29.586656-03
1317	Produto 148472	\N	148472	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.586656-03	2026-02-27 20:05:29.586656-03
1318	Produto 140927	\N	140927	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.586656-03	2026-02-27 20:05:29.586656-03
1319	Produto 239213	\N	239213	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.595047-03	2026-02-27 20:05:29.595047-03
1320	Produto 218193	\N	218193	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.595047-03	2026-02-27 20:05:29.595047-03
1321	Produto 148473	\N	148473	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.595047-03	2026-02-27 20:05:29.595047-03
1322	Produto 231704	\N	231704	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.595047-03	2026-02-27 20:05:29.595047-03
1323	Produto 166349	\N	166349	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.595047-03	2026-02-27 20:05:29.595047-03
1324	Produto 252070	\N	252070	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.603783-03	2026-02-27 20:05:29.603783-03
1325	Produto 106127	\N	106127	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.603783-03	2026-02-27 20:05:29.603783-03
1326	Produto 113243	\N	113243	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.603783-03	2026-02-27 20:05:29.603783-03
1327	Produto 206194	\N	206194	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.603783-03	2026-02-27 20:05:29.603783-03
1328	Produto 93026	\N	93026	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.603783-03	2026-02-27 20:05:29.603783-03
1329	Produto 219706	\N	219706	Geral	Descoberto em Todos os Produtos (Pág 67)	\N	5	0.00	\N	2026-02-27 20:05:29.611963-03	2026-02-27 20:05:29.611963-03
1330	Produto 228440	\N	228440	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.353159-03	2026-02-27 20:05:38.359914-03
1331	Produto 228441	\N	228441	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.36192-03	2026-02-27 20:05:38.36192-03
1332	Produto 228443	\N	228443	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.36192-03	2026-02-27 20:05:38.36192-03
1333	Produto 175105	\N	175105	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.368219-03	2026-02-27 20:05:38.369315-03
1334	Produto 159123	\N	159123	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.369873-03	2026-02-27 20:05:38.369873-03
1335	Produto 203399	\N	203399	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.369873-03	2026-02-27 20:05:38.369873-03
1336	Produto 252072	\N	252072	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.369873-03	2026-02-27 20:05:38.376273-03
1337	Produto 215274	\N	215274	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.37738-03	2026-02-27 20:05:38.37738-03
1338	Produto 116692	\N	116692	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.37738-03	2026-02-27 20:05:38.381041-03
1339	Produto 229967	\N	229967	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.384706-03	2026-02-27 20:05:38.385714-03
1340	Produto 130032	\N	130032	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.38627-03	2026-02-27 20:05:38.38627-03
1341	Produto 239990	\N	239990	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.38627-03	2026-02-27 20:05:38.392169-03
1342	Produto 244741	\N	244741	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.39441-03	2026-02-27 20:05:38.39441-03
1343	Produto 192148	\N	192148	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.397-03	2026-02-27 20:05:38.397-03
1344	Produto 214711	\N	214711	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.399007-03	2026-02-27 20:05:38.399007-03
1345	Produto 6588	\N	6588	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.40264-03	2026-02-27 20:05:38.40264-03
1346	Produto 194398	\N	194398	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.405385-03	2026-02-27 20:05:38.405385-03
1347	Produto 239253	\N	239253	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.407392-03	2026-02-27 20:05:38.407392-03
1348	Produto 106543	\N	106543	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.410885-03	2026-02-27 20:05:38.410885-03
1349	Produto 129617	\N	129617	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.413302-03	2026-02-27 20:05:38.413302-03
1350	Produto 252075	\N	252075	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.41531-03	2026-02-27 20:05:38.41531-03
1351	Produto 191634	\N	191634	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.418051-03	2026-02-27 20:05:38.419515-03
1352	Produto 231703	\N	231703	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.421522-03	2026-02-27 20:05:38.421522-03
1353	Produto 98942	\N	98942	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.423528-03	2026-02-27 20:05:38.423528-03
1354	Produto 16269	\N	16269	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.179673-03	2026-02-27 20:05:46.180674-03
1355	Produto 8297	\N	8297	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.183616-03	2026-02-27 20:05:46.183921-03
1356	Produto 167182	\N	167182	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.186173-03	2026-02-27 20:05:46.186173-03
1357	Produto 173609	\N	173609	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.188206-03	2026-02-27 20:05:46.189173-03
1358	Produto 239264	\N	239264	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.190182-03	2026-02-27 20:05:46.191173-03
1359	Produto 12179	\N	12179	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.191805-03	2026-02-27 20:05:46.191805-03
1360	Produto 196320	\N	196320	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.193128-03	2026-02-27 20:05:46.194128-03
1361	Produto 167327	\N	167327	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.195128-03	2026-02-27 20:05:46.195128-03
1362	Produto 215260	\N	215260	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.197128-03	2026-02-27 20:05:46.197128-03
1363	Produto 219714	\N	219714	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.198148-03	2026-02-27 20:05:46.198148-03
1364	Produto 239206	\N	239206	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.200124-03	2026-02-27 20:05:46.200451-03
1365	Produto 106542	\N	106542	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.201491-03	2026-02-27 20:05:46.202488-03
1366	Produto 161145	\N	161145	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.203488-03	2026-02-27 20:05:46.203488-03
1367	Produto 173601	\N	173601	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.204484-03	2026-02-27 20:05:46.205486-03
1368	Produto 148415	\N	148415	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.206483-03	2026-02-27 20:05:46.206483-03
1369	Produto 239258	\N	239258	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.208452-03	2026-02-27 20:05:46.208452-03
1370	Produto 241062	\N	241062	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.209702-03	2026-02-27 20:05:46.2107-03
1371	Produto 103136	\N	103136	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.2117-03	2026-02-27 20:05:46.2117-03
1372	Produto 106137	\N	106137	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.212702-03	2026-02-27 20:05:46.213701-03
1373	Produto 15352	\N	15352	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.214698-03	2026-02-27 20:05:46.214698-03
1374	Produto 127768	\N	127768	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.766606-03	2026-02-27 20:05:53.783949-03
1375	Produto 170152	\N	170152	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.792341-03	2026-02-27 20:05:53.792341-03
1376	Produto 166330	\N	166330	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.799169-03	2026-02-27 20:05:53.800176-03
1377	Produto 215267	\N	215267	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.800565-03	2026-02-27 20:05:53.800565-03
1378	Produto 108142	\N	108142	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.800565-03	2026-02-27 20:05:53.800565-03
1379	Produto 97261	\N	97261	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.800565-03	2026-02-27 20:05:53.800565-03
1380	Produto 173607	\N	173607	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.800565-03	2026-02-27 20:05:53.807363-03
1381	Produto 181520	\N	181520	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.808368-03	2026-02-27 20:05:53.808368-03
1382	Produto 139239	\N	139239	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.808368-03	2026-02-27 20:05:53.808368-03
1383	Produto 166365	\N	166365	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.808368-03	2026-02-27 20:05:53.808368-03
1384	Produto 110202	\N	110202	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.808368-03	2026-02-27 20:05:53.808368-03
1385	Produto 239211	\N	239211	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.808368-03	2026-02-27 20:05:53.808368-03
1386	Produto 107126	\N	107126	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.816803-03	2026-02-27 20:05:53.816803-03
1387	Produto 133024	\N	133024	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.816803-03	2026-02-27 20:05:53.816803-03
1388	Produto 15822	\N	15822	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.816803-03	2026-02-27 20:05:53.816803-03
1389	Produto 218962	\N	218962	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.816803-03	2026-02-27 20:05:53.816803-03
1390	Produto 128752	\N	128752	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.816803-03	2026-02-27 20:05:53.816803-03
1391	Produto 107128	\N	107128	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.824031-03	2026-02-27 20:05:53.825086-03
1392	Produto 139801	\N	139801	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.825086-03	2026-02-27 20:05:53.825086-03
1393	Produto 218185	\N	218185	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.825086-03	2026-02-27 20:05:53.825086-03
1394	Produto 239198	\N	239198	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.825086-03	2026-02-27 20:05:53.825086-03
1395	Produto 180473	\N	180473	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.825086-03	2026-02-27 20:05:53.825086-03
1396	Produto 95780	\N	95780	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.832356-03	2026-02-27 20:05:53.832356-03
1397	Produto 166338	\N	166338	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.833362-03	2026-02-27 20:05:53.833362-03
1398	Produto 90176	\N	90176	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.064061-03	2026-02-27 20:06:16.064061-03
1399	Produto 239995	\N	239995	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.064061-03	2026-02-27 20:06:16.064061-03
1400	Produto 123008	\N	123008	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.070759-03	2026-02-27 20:06:16.070759-03
1401	Produto 239256	\N	239256	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.071765-03	2026-02-27 20:06:16.071765-03
1402	Produto 148470	\N	148470	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.071765-03	2026-02-27 20:06:16.071765-03
1403	Produto 191620	\N	191620	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.071765-03	2026-02-27 20:06:16.071765-03
1404	Produto 239977	\N	239977	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.071765-03	2026-02-27 20:06:16.079033-03
1405	Produto 16641	\N	16641	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.080038-03	2026-02-27 20:06:16.080038-03
1406	Produto 169244	\N	169244	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.080038-03	2026-02-27 20:06:16.080038-03
1407	Produto 146474	\N	146474	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.080038-03	2026-02-27 20:06:16.080038-03
1408	Produto 201327	\N	201327	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.080038-03	2026-02-27 20:06:16.080038-03
1409	Produto 201328	\N	201328	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.080038-03	2026-02-27 20:06:16.087375-03
1410	Produto 110682	\N	110682	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.088244-03	2026-02-27 20:06:16.088244-03
1411	Produto 166335	\N	166335	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.088244-03	2026-02-27 20:06:16.088244-03
1412	Produto 155848	\N	155848	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.088244-03	2026-02-27 20:06:16.088244-03
1413	Produto 60001	\N	60001	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.088244-03	2026-02-27 20:06:16.088244-03
1414	Produto 102870	\N	102870	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.088244-03	2026-02-27 20:06:16.088244-03
1415	Produto 139243	\N	139243	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.096818-03	2026-02-27 20:06:16.096818-03
1416	Produto 239971	\N	239971	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.097817-03	2026-02-27 20:06:16.097817-03
1417	Produto 166329	\N	166329	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.097817-03	2026-02-27 20:06:16.097817-03
1418	Produto 173592	\N	173592	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.097817-03	2026-02-27 20:06:16.097817-03
1419	Produto 219741	\N	219741	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.097817-03	2026-02-27 20:06:16.097817-03
1420	Produto 166340	\N	166340	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.104123-03	2026-02-27 20:06:16.105123-03
1421	Produto 137960	\N	137960	Geral	Descoberto em Todos os Produtos (Pág 73)	\N	5	0.00	\N	2026-02-27 20:06:16.105123-03	2026-02-27 20:06:16.105123-03
1422	Produto 218202	\N	218202	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.645592-03	2026-02-27 20:06:24.645592-03
1423	Produto 239266	\N	239266	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.654231-03	2026-02-27 20:06:24.654231-03
1424	Produto 108874	\N	108874	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.654231-03	2026-02-27 20:06:24.654231-03
1425	Produto 220859	\N	220859	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.654231-03	2026-02-27 20:06:24.654231-03
1426	Produto 191618	\N	191618	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.661153-03	2026-02-27 20:06:24.662158-03
1427	Produto 239257	\N	239257	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.662158-03	2026-02-27 20:06:24.662158-03
1428	Produto 191623	\N	191623	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.662158-03	2026-02-27 20:06:24.662158-03
1429	Produto 193846	\N	193846	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.662158-03	2026-02-27 20:06:24.662158-03
1430	Produto 252082	\N	252082	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.669619-03	2026-02-27 20:06:24.669619-03
1431	Produto 239224	\N	239224	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.670626-03	2026-02-27 20:06:24.670626-03
1432	Produto 231696	\N	231696	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.670626-03	2026-02-27 20:06:24.670626-03
1433	Produto 122123	\N	122123	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.670626-03	2026-02-27 20:06:24.670626-03
1434	Produto 213225	\N	213225	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.670626-03	2026-02-27 20:06:24.670626-03
1435	Produto 107327	\N	107327	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.670626-03	2026-02-27 20:06:24.677873-03
1436	Produto 138035	\N	138035	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.678879-03	2026-02-27 20:06:24.678879-03
1437	Produto 217196	\N	217196	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.678879-03	2026-02-27 20:06:24.678879-03
1438	Produto 191637	\N	191637	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.678879-03	2026-02-27 20:06:24.678879-03
1439	Produto 239199	\N	239199	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.678879-03	2026-02-27 20:06:24.678879-03
1440	Produto 239797	\N	239797	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.678879-03	2026-02-27 20:06:24.678879-03
1441	Produto 239194	\N	239194	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.687141-03	2026-02-27 20:06:24.687141-03
1442	Produto 110197	\N	110197	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.687141-03	2026-02-27 20:06:24.687141-03
1443	Produto 109479	\N	109479	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.687141-03	2026-02-27 20:06:24.687141-03
1444	Produto 106132	\N	106132	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.687141-03	2026-02-27 20:06:24.687141-03
1445	Produto 97426	\N	97426	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.687141-03	2026-02-27 20:06:24.687141-03
1446	Produto 178864	\N	178864	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.24318-03	2026-02-27 20:06:40.24318-03
1447	Produto 228444	\N	228444	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.24318-03	2026-02-27 20:06:40.24318-03
1448	Produto 118918	\N	118918	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.251619-03	2026-02-27 20:06:40.251619-03
1449	Produto 140743	\N	140743	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.251619-03	2026-02-27 20:06:40.251619-03
1450	Produto 213208	\N	213208	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.258887-03	2026-02-27 20:06:40.258887-03
1451	Produto 78934	\N	78934	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.259869-03	2026-02-27 20:06:40.259869-03
1452	Produto 106544	\N	106544	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.259869-03	2026-02-27 20:06:40.259869-03
1453	Produto 252073	\N	252073	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.259869-03	2026-02-27 20:06:40.259869-03
1454	Produto 204413	\N	204413	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.259869-03	2026-02-27 20:06:40.259869-03
1455	Produto 135028	\N	135028	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.267857-03	2026-02-27 20:06:40.267857-03
1456	Produto 177723	\N	177723	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.267857-03	2026-02-27 20:06:40.267857-03
1457	Produto 215263	\N	215263	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.267857-03	2026-02-27 20:06:40.267857-03
1458	Produto 179463	\N	179463	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.267857-03	2026-02-27 20:06:40.267857-03
1459	Produto 111425	\N	111425	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.267857-03	2026-02-27 20:06:40.267857-03
1460	Produto 239204	\N	239204	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.276194-03	2026-02-27 20:06:40.276194-03
1461	Produto 239212	\N	239212	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.276194-03	2026-02-27 20:06:40.276194-03
1462	Produto 108148	\N	108148	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.276194-03	2026-02-27 20:06:40.276194-03
1463	Produto 216467	\N	216467	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.276194-03	2026-02-27 20:06:40.276194-03
1464	Produto 173591	\N	173591	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.276194-03	2026-02-27 20:06:40.276194-03
1465	Produto 140741	\N	140741	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.284571-03	2026-02-27 20:06:40.284571-03
1466	Produto 181516	\N	181516	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.284571-03	2026-02-27 20:06:40.284571-03
1467	Produto 213209	\N	213209	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.284571-03	2026-02-27 20:06:40.284571-03
1468	Produto 239174	\N	239174	Geral	Descoberto em Todos os Produtos (Pág 76)	\N	5	0.00	\N	2026-02-27 20:06:40.284571-03	2026-02-27 20:06:40.284571-03
1469	Produto 104875	\N	104875	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.058787-03	2026-02-27 20:06:56.06071-03
1470	Produto 170766	\N	170766	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.064271-03	2026-02-27 20:06:56.064858-03
1471	Produto 10161	\N	10161	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.066091-03	2026-02-27 20:06:56.067091-03
1472	Produto 108138	\N	108138	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.068097-03	2026-02-27 20:06:56.069091-03
1473	Produto 147448	\N	147448	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.070095-03	2026-02-27 20:06:56.071091-03
1474	Produto 135042	\N	135042	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.073091-03	2026-02-27 20:06:56.073091-03
1475	Produto 219727	\N	219727	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.075188-03	2026-02-27 20:06:56.075188-03
1476	Produto 137968	\N	137968	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.07625-03	2026-02-27 20:06:56.07725-03
1477	Produto 195216	\N	195216	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.07826-03	2026-02-27 20:06:56.07826-03
1478	Produto 178160	\N	178160	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.080249-03	2026-02-27 20:06:56.080249-03
1479	Produto 8885	\N	8885	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.081576-03	2026-02-27 20:06:56.081576-03
1480	Produto 8884	\N	8884	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.083579-03	2026-02-27 20:06:56.083579-03
1481	Produto 252080	\N	252080	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.084578-03	2026-02-27 20:06:56.085578-03
1482	Produto 252081	\N	252081	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.086578-03	2026-02-27 20:06:56.086578-03
1483	Produto 151703	\N	151703	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.087577-03	2026-02-27 20:06:56.088578-03
1484	Produto 116885	\N	116885	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.089577-03	2026-02-27 20:06:56.089577-03
1485	Produto 177729	\N	177729	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.090793-03	2026-02-27 20:06:56.091793-03
1486	Produto 111398	\N	111398	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.092795-03	2026-02-27 20:06:56.092795-03
1487	Produto 166346	\N	166346	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.093793-03	2026-02-27 20:06:56.094793-03
1488	Produto 166344	\N	166344	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.095793-03	2026-02-27 20:06:56.095793-03
1489	Produto 166328	\N	166328	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.096792-03	2026-02-27 20:06:56.098149-03
1490	Produto 107323	\N	107323	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.099225-03	2026-02-27 20:06:56.099225-03
1491	Produto 166339	\N	166339	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.921891-03	2026-02-27 20:07:03.922897-03
1492	Produto 131338	\N	131338	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.922897-03	2026-02-27 20:07:03.922897-03
1493	Produto 252068	\N	252068	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.922897-03	2026-02-27 20:07:03.922897-03
1494	Produto 119426	\N	119426	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.922897-03	2026-02-27 20:07:03.922897-03
1495	Produto 166326	\N	166326	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.922897-03	2026-02-27 20:07:03.930177-03
1496	Produto 166333	\N	166333	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.931138-03	2026-02-27 20:07:03.931138-03
1497	Produto 129608	\N	129608	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.931138-03	2026-02-27 20:07:03.931138-03
1498	Produto 137957	\N	137957	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.931138-03	2026-02-27 20:07:03.931138-03
1499	Produto 176438	\N	176438	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.931138-03	2026-02-27 20:07:03.931138-03
1500	Produto 108939	\N	108939	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.931138-03	2026-02-27 20:07:03.931138-03
1501	Produto 137955	\N	137955	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.939495-03	2026-02-27 20:07:03.939495-03
1502	Produto 28025	\N	28025	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.939495-03	2026-02-27 20:07:03.939495-03
1503	Produto 109154	\N	109154	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.939495-03	2026-02-27 20:07:03.939495-03
1504	Produto 148397	\N	148397	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.939495-03	2026-02-27 20:07:03.939495-03
1505	Produto 106131	\N	106131	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.939495-03	2026-02-27 20:07:03.939495-03
1506	Produto 106136	\N	106136	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.946891-03	2026-02-27 20:07:03.947897-03
1507	Produto 106134	\N	106134	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.947897-03	2026-02-27 20:07:03.947897-03
1508	Produto 116698	\N	116698	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.947897-03	2026-02-27 20:07:03.947897-03
1509	Produto 102871	\N	102871	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.947897-03	2026-02-27 20:07:03.947897-03
1510	Produto 116696	\N	116696	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.947897-03	2026-02-27 20:07:03.947897-03
1511	Produto 106551	\N	106551	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.955275-03	2026-02-27 20:07:03.956342-03
1512	Produto 163222	\N	163222	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.956342-03	2026-02-27 20:07:03.956342-03
1513	Produto 116695	\N	116695	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.956342-03	2026-02-27 20:07:03.956342-03
1514	Produto 106535	\N	106535	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.087696-03	2026-02-27 20:07:11.087696-03
1515	Produto 173602	\N	173602	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.095902-03	2026-02-27 20:07:11.095902-03
1516	Produto 173598	\N	173598	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.095902-03	2026-02-27 20:07:11.095902-03
1517	Produto 137958	\N	137958	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.095902-03	2026-02-27 20:07:11.095902-03
1518	Produto 256324	\N	256324	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.104839-03	2026-02-27 20:07:11.104839-03
1519	Produto 139803	\N	139803	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.108642-03	2026-02-27 20:07:11.108642-03
1520	Produto 139802	\N	139802	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.108642-03	2026-02-27 20:07:11.108642-03
1521	Produto 140049	\N	140049	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.112609-03	2026-02-27 20:07:11.112609-03
1522	Produto 173599	\N	173599	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.112609-03	2026-02-27 20:07:11.112609-03
1523	Produto 173600	\N	173600	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.112609-03	2026-02-27 20:07:11.112609-03
1524	Produto 166343	\N	166343	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.120895-03	2026-02-27 20:07:11.120895-03
1525	Produto 123025	\N	123025	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.120895-03	2026-02-27 20:07:11.120895-03
1526	Produto 217199	\N	217199	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.120895-03	2026-02-27 20:07:11.120895-03
1527	Produto 222187	\N	222187	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.120895-03	2026-02-27 20:07:11.120895-03
1528	Produto 239265	\N	239265	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.129111-03	2026-02-27 20:07:11.129111-03
1529	Produto 239251	\N	239251	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.129111-03	2026-02-27 20:07:11.129111-03
1530	Produto 69653	\N	69653	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.129111-03	2026-02-27 20:07:11.129111-03
1531	Produto 9431	\N	9431	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.129111-03	2026-02-27 20:07:11.129111-03
1532	Produto 8889	\N	8889	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.137546-03	2026-02-27 20:07:11.137546-03
1533	Produto 107134	\N	107134	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.137546-03	2026-02-27 20:07:11.137546-03
1534	Produto 100145	\N	100145	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.137546-03	2026-02-27 20:07:11.137546-03
1535	Produto 104890	\N	104890	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.137546-03	2026-02-27 20:07:11.137546-03
1536	Produto 104893	\N	104893	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.137546-03	2026-02-27 20:07:11.145895-03
1537	Produto 107133	\N	107133	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.145895-03	2026-02-27 20:07:11.145895-03
1538	Produto 102873	\N	102873	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.903798-03	2026-02-27 20:07:18.903798-03
1539	Produto 104892	\N	104892	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.903798-03	2026-02-27 20:07:18.903798-03
1540	Produto 104889	\N	104889	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.903798-03	2026-02-27 20:07:18.903798-03
1541	Produto 104895	\N	104895	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.912032-03	2026-02-27 20:07:18.912032-03
1542	Produto 110685	\N	110685	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.912032-03	2026-02-27 20:07:18.912032-03
1543	Produto 108150	\N	108150	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.912032-03	2026-02-27 20:07:18.912032-03
1544	Produto 110683	\N	110683	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.912032-03	2026-02-27 20:07:18.912032-03
1545	Produto 110082	\N	110082	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.912032-03	2026-02-27 20:07:18.912032-03
1546	Produto 120194	\N	120194	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.912032-03	2026-02-27 20:07:18.919836-03
1547	Produto 116697	\N	116697	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.920299-03	2026-02-27 20:07:18.920299-03
1548	Produto 118980	\N	118980	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.920299-03	2026-02-27 20:07:18.920299-03
1549	Produto 118042	\N	118042	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.920299-03	2026-02-27 20:07:18.920299-03
1550	Produto 109839	\N	109839	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.920299-03	2026-02-27 20:07:18.920299-03
1551	Produto 109153	\N	109153	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.920299-03	2026-02-27 20:07:18.920299-03
1552	Produto 108133	\N	108133	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.928763-03	2026-02-27 20:07:18.928763-03
1553	Produto 110196	\N	110196	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.928763-03	2026-02-27 20:07:18.928763-03
1554	Produto 108151	\N	108151	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.928763-03	2026-02-27 20:07:18.928763-03
1555	Produto 110198	\N	110198	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.928763-03	2026-02-27 20:07:18.928763-03
1556	Produto 108153	\N	108153	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.928763-03	2026-02-27 20:07:18.928763-03
1557	Produto 109151	\N	109151	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.937283-03	2026-02-27 20:07:18.937283-03
1558	Produto 127757	\N	127757	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.937283-03	2026-02-27 20:07:18.937283-03
1559	Produto 139249	\N	139249	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.937283-03	2026-02-27 20:07:18.937283-03
1560	Produto 139251	\N	139251	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.937283-03	2026-02-27 20:07:18.937283-03
1561	Produto 129620	\N	129620	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.937283-03	2026-02-27 20:07:18.937283-03
1562	Produto 140039	\N	140039	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.327228-03	2026-02-27 20:07:34.327228-03
1563	Produto 167215	\N	167215	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.327228-03	2026-02-27 20:07:34.327228-03
1564	Produto 163224	\N	163224	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.335623-03	2026-02-27 20:07:34.335623-03
1565	Produto 173993	\N	173993	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.335623-03	2026-02-27 20:07:34.335623-03
1566	Produto 173596	\N	173596	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.335623-03	2026-02-27 20:07:34.335623-03
1567	Produto 166364	\N	166364	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.335623-03	2026-02-27 20:07:34.335623-03
1568	Produto 173992	\N	173992	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.343412-03	2026-02-27 20:07:34.343412-03
1569	Produto 166336	\N	166336	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.343412-03	2026-02-27 20:07:34.343412-03
1570	Produto 173611	\N	173611	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.343412-03	2026-02-27 20:07:34.343412-03
1571	Produto 173603	\N	173603	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.343412-03	2026-02-27 20:07:34.343412-03
1572	Produto 167637	\N	167637	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.343412-03	2026-02-27 20:07:34.343412-03
1573	Produto 173595	\N	173595	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.351758-03	2026-02-27 20:07:34.351758-03
1574	Produto 166331	\N	166331	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.351758-03	2026-02-27 20:07:34.351758-03
1575	Produto 166348	\N	166348	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.351758-03	2026-02-27 20:07:34.351758-03
1576	Produto 166334	\N	166334	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.351758-03	2026-02-27 20:07:34.351758-03
1577	Produto 173610	\N	173610	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.351758-03	2026-02-27 20:07:34.351758-03
1578	Produto 16528	\N	16528	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.359135-03	2026-02-27 20:07:34.360143-03
1579	Produto 167634	\N	167634	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.360143-03	2026-02-27 20:07:34.360143-03
1580	Produto 167638	\N	167638	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.360143-03	2026-02-27 20:07:34.360143-03
1581	Produto 167104	\N	167104	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.360143-03	2026-02-27 20:07:34.360143-03
1582	Produto 173009	\N	173009	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.367388-03	2026-02-27 20:07:34.367388-03
1583	Produto 181519	\N	181519	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.368372-03	2026-02-27 20:07:34.368372-03
1584	Produto 191632	\N	191632	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.368372-03	2026-02-27 20:07:34.368372-03
1585	Produto 189773	\N	189773	Geral	Descoberto em Todos os Produtos (Pág 83)	\N	5	0.00	\N	2026-02-27 20:07:34.368372-03	2026-02-27 20:07:34.368372-03
1586	Produto 191633	\N	191633	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.817272-03	2026-02-27 20:07:41.817272-03
1587	Produto 180462	\N	180462	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.817272-03	2026-02-27 20:07:41.817272-03
1588	Produto 191621	\N	191621	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.825622-03	2026-02-27 20:07:41.825622-03
1589	Produto 191630	\N	191630	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.82858-03	2026-02-27 20:07:41.82858-03
1590	Produto 191629	\N	191629	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.82858-03	2026-02-27 20:07:41.82858-03
1591	Produto 191622	\N	191622	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.832796-03	2026-02-27 20:07:41.833687-03
1592	Produto 191627	\N	191627	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.833687-03	2026-02-27 20:07:41.833687-03
1593	Produto 191625	\N	191625	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.833687-03	2026-02-27 20:07:41.833687-03
1594	Produto 191624	\N	191624	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.833687-03	2026-02-27 20:07:41.833687-03
1595	Produto 191631	\N	191631	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.833687-03	2026-02-27 20:07:41.833687-03
1596	Produto 181510	\N	181510	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.841996-03	2026-02-27 20:07:41.841996-03
1597	Produto 180799	\N	180799	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.841996-03	2026-02-27 20:07:41.841996-03
1598	Produto 181511	\N	181511	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.841996-03	2026-02-27 20:07:41.841996-03
1599	Produto 181514	\N	181514	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.841996-03	2026-02-27 20:07:41.841996-03
1600	Produto 181517	\N	181517	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.841996-03	2026-02-27 20:07:41.849508-03
1601	Produto 204419	\N	204419	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.850328-03	2026-02-27 20:07:41.850328-03
1602	Produto 204412	\N	204412	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.850328-03	2026-02-27 20:07:41.850328-03
1603	Produto 204406	\N	204406	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.850328-03	2026-02-27 20:07:41.850328-03
1604	Produto 204417	\N	204417	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.850328-03	2026-02-27 20:07:41.850328-03
1605	Produto 216061	\N	216061	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.857812-03	2026-02-27 20:07:41.857812-03
1606	Produto 217176	\N	217176	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.858708-03	2026-02-27 20:07:41.858708-03
1607	Produto 216065	\N	216065	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.858708-03	2026-02-27 20:07:41.858708-03
1608	Produto 213219	\N	213219	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.858708-03	2026-02-27 20:07:41.858708-03
1609	Produto 215272	\N	215272	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.866143-03	2026-02-27 20:07:41.867148-03
1610	Produto 213549	\N	213549	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.857981-03	2026-02-27 20:07:49.858936-03
1611	Produto 213556	\N	213556	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.861989-03	2026-02-27 20:07:49.861989-03
1612	Produto 213552	\N	213552	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.863939-03	2026-02-27 20:07:49.863939-03
1613	Produto 218205	\N	218205	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.866031-03	2026-02-27 20:07:49.866031-03
1614	Produto 216044	\N	216044	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.867264-03	2026-02-27 20:07:49.867264-03
1615	Produto 215266	\N	215266	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.868257-03	2026-02-27 20:07:49.869258-03
1616	Produto 216475	\N	216475	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.87025-03	2026-02-27 20:07:49.871251-03
1617	Produto 218212	\N	218212	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.872255-03	2026-02-27 20:07:49.872255-03
1618	Produto 218204	\N	218204	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.873619-03	2026-02-27 20:07:49.873619-03
1619	Produto 215271	\N	215271	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.875688-03	2026-02-27 20:07:49.875688-03
1620	Produto 208140	\N	208140	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.876683-03	2026-02-27 20:07:49.877683-03
1621	Produto 213550	\N	213550	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.878682-03	2026-02-27 20:07:49.878682-03
1622	Produto 213220	\N	213220	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.879682-03	2026-02-27 20:07:49.879682-03
1623	Produto 217204	\N	217204	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.880682-03	2026-02-27 20:07:49.881604-03
1624	Produto 213218	\N	213218	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.882781-03	2026-02-27 20:07:49.882781-03
1625	Produto 213210	\N	213210	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.883776-03	2026-02-27 20:07:49.884776-03
1626	Produto 216066	\N	216066	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.885768-03	2026-02-27 20:07:49.885768-03
1627	Produto 216058	\N	216058	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.886776-03	2026-02-27 20:07:49.887923-03
1628	Produto 212782	\N	212782	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.888931-03	2026-02-27 20:07:49.888931-03
1629	Produto 218213	\N	218213	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.889917-03	2026-02-27 20:07:49.891091-03
1630	Produto 217179	\N	217179	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.89209-03	2026-02-27 20:07:49.89209-03
1631	Produto 216075	\N	216075	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.89309-03	2026-02-27 20:07:49.894089-03
1632	Produto 218214	\N	218214	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.894089-03	2026-02-27 20:07:49.89509-03
1633	Produto 218203	\N	218203	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.89609-03	2026-02-27 20:07:49.89609-03
1634	Produto 216035	\N	216035	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.861754-03	2026-02-27 20:07:57.862746-03
1635	Produto 217173	\N	217173	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.866077-03	2026-02-27 20:07:57.867076-03
1636	Produto 216051	\N	216051	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.869119-03	2026-02-27 20:07:57.869119-03
1637	Produto 219702	\N	219702	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.871151-03	2026-02-27 20:07:57.872433-03
1638	Produto 219715	\N	219715	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.873465-03	2026-02-27 20:07:57.874465-03
1639	Produto 219723	\N	219723	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.876466-03	2026-02-27 20:07:57.876466-03
1640	Produto 222188	\N	222188	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.877465-03	2026-02-27 20:07:57.878465-03
1641	Produto 221664	\N	221664	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.879465-03	2026-02-27 20:07:57.879465-03
1642	Produto 219716	\N	219716	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.881475-03	2026-02-27 20:07:57.881475-03
1643	Produto 219707	\N	219707	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.882707-03	2026-02-27 20:07:57.883708-03
1644	Produto 219718	\N	219718	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.884721-03	2026-02-27 20:07:57.884721-03
1645	Produto 231691	\N	231691	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.886708-03	2026-02-27 20:07:57.886708-03
1646	Produto 232507	\N	232507	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.887707-03	2026-02-27 20:07:57.888708-03
1647	Produto 232510	\N	232510	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.890036-03	2026-02-27 20:07:57.890036-03
1648	Produto 231693	\N	231693	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.892036-03	2026-02-27 20:07:57.892036-03
1649	Produto 232518	\N	232518	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.893037-03	2026-02-27 20:07:57.894036-03
1650	Produto 231707	\N	231707	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.895036-03	2026-02-27 20:07:57.895036-03
1651	Produto 231705	\N	231705	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.896036-03	2026-02-27 20:07:57.897037-03
1652	Produto 231687	\N	231687	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.897964-03	2026-02-27 20:07:57.897964-03
1653	Produto 232525	\N	232525	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.897964-03	2026-02-27 20:07:57.897964-03
1654	Produto 232509	\N	232509	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.897964-03	2026-02-27 20:07:57.897964-03
1655	Produto 232529	\N	232529	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.897964-03	2026-02-27 20:07:57.897964-03
1656	Produto 225173	\N	225173	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.905344-03	2026-02-27 20:07:57.906179-03
1657	Produto 226588	\N	226588	Geral	Descoberto em Todos os Produtos (Pág 86)	\N	5	0.00	\N	2026-02-27 20:07:57.906179-03	2026-02-27 20:07:57.906179-03
1658	Produto 229971	\N	229971	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.654288-03	2026-02-27 20:08:06.65497-03
1659	Produto 224953	\N	224953	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.65497-03	2026-02-27 20:08:06.658594-03
1660	Produto 232506	\N	232506	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.658594-03	2026-02-27 20:08:06.658594-03
1661	Produto 232513	\N	232513	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.663187-03	2026-02-27 20:08:06.663187-03
1662	Produto 232528	\N	232528	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.663187-03	2026-02-27 20:08:06.663187-03
1663	Produto 232524	\N	232524	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.663187-03	2026-02-27 20:08:06.663187-03
1664	Produto 228435	\N	228435	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.663187-03	2026-02-27 20:08:06.670842-03
1665	Produto 228436	\N	228436	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.671506-03	2026-02-27 20:08:06.671506-03
1666	Produto 238705	\N	238705	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.671506-03	2026-02-27 20:08:06.671506-03
1667	Produto 219744	\N	219744	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.671506-03	2026-02-27 20:08:06.671506-03
1668	Produto 238704	\N	238704	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.671506-03	2026-02-27 20:08:06.679246-03
1669	Produto 230580	\N	230580	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.679791-03	2026-02-27 20:08:06.679791-03
1670	Produto 239221	\N	239221	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.679791-03	2026-02-27 20:08:06.679791-03
1671	Produto 228240	\N	228240	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.679791-03	2026-02-27 20:08:06.679791-03
1672	Produto 239178	\N	239178	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.679791-03	2026-02-27 20:08:06.687612-03
1673	Produto 239192	\N	239192	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.688128-03	2026-02-27 20:08:06.688128-03
1674	Produto 239208	\N	239208	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.688128-03	2026-02-27 20:08:06.688128-03
1675	Produto 239177	\N	239177	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.688128-03	2026-02-27 20:08:06.688128-03
1676	Produto 239179	\N	239179	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.688128-03	2026-02-27 20:08:06.688128-03
1677	Produto 239175	\N	239175	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.688128-03	2026-02-27 20:08:06.688128-03
1678	Produto 239180	\N	239180	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.696353-03	2026-02-27 20:08:06.696353-03
1679	Produto 239202	\N	239202	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.696353-03	2026-02-27 20:08:06.696353-03
1680	Produto 239187	\N	239187	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.696353-03	2026-02-27 20:08:06.696353-03
1681	Produto 239183	\N	239183	Geral	Descoberto em Todos os Produtos (Pág 87)	\N	5	0.00	\N	2026-02-27 20:08:06.696353-03	2026-02-27 20:08:06.696353-03
1682	Produto 239182	\N	239182	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.774516-03	2026-02-27 20:08:14.774516-03
1683	Produto 228442	\N	228442	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.778034-03	2026-02-27 20:08:14.778034-03
1684	Produto 239181	\N	239181	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.778034-03	2026-02-27 20:08:14.778034-03
1685	Produto 239220	\N	239220	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.778034-03	2026-02-27 20:08:14.778034-03
1686	Produto 239197	\N	239197	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.778034-03	2026-02-27 20:08:14.786341-03
1687	Produto 239201	\N	239201	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.786341-03	2026-02-27 20:08:14.786341-03
1688	Produto 239205	\N	239205	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.786341-03	2026-02-27 20:08:14.786341-03
1689	Produto 239207	\N	239207	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.786341-03	2026-02-27 20:08:14.786341-03
1690	Produto 239210	\N	239210	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.786341-03	2026-02-27 20:08:14.786341-03
1691	Produto 239218	\N	239218	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.786341-03	2026-02-27 20:08:14.786341-03
1692	Produto 244728	\N	244728	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.794781-03	2026-02-27 20:08:14.794781-03
1693	Produto 244762	\N	244762	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.794781-03	2026-02-27 20:08:14.794781-03
1694	Produto 244779	\N	244779	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.794781-03	2026-02-27 20:08:14.794781-03
1695	Produto 244754	\N	244754	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.794781-03	2026-02-27 20:08:14.794781-03
1696	Produto 244727	\N	244727	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.794781-03	2026-02-27 20:08:14.794781-03
1697	Produto 244736	\N	244736	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.8035-03	2026-02-27 20:08:14.8035-03
1698	Produto 244735	\N	244735	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.8035-03	2026-02-27 20:08:14.8035-03
1699	Produto 244770	\N	244770	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.8035-03	2026-02-27 20:08:14.8035-03
1700	Produto 244790	\N	244790	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.8035-03	2026-02-27 20:08:14.8035-03
1701	Produto 244784	\N	244784	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.8035-03	2026-02-27 20:08:14.8035-03
1702	Produto 244788	\N	244788	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.8035-03	2026-02-27 20:08:14.811286-03
1703	Produto 244744	\N	244744	Geral	Descoberto em Todos os Produtos (Pág 88)	\N	5	0.00	\N	2026-02-27 20:08:14.811286-03	2026-02-27 20:08:14.811286-03
1704	Produto 244789	\N	244789	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.802938-03	2026-02-27 20:08:22.802938-03
1705	Produto 244751	\N	244751	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.811287-03	2026-02-27 20:08:22.811287-03
1706	Produto 244759	\N	244759	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.811287-03	2026-02-27 20:08:22.811287-03
1707	Produto 244775	\N	244775	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.811287-03	2026-02-27 20:08:22.811287-03
1708	Produto 244778	\N	244778	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.811287-03	2026-02-27 20:08:22.81837-03
1709	Produto 244763	\N	244763	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.819374-03	2026-02-27 20:08:22.819374-03
1710	Produto 244765	\N	244765	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.819374-03	2026-02-27 20:08:22.819374-03
1711	Produto 244791	\N	244791	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.819374-03	2026-02-27 20:08:22.819374-03
1712	Produto 246096	\N	246096	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.819374-03	2026-02-27 20:08:22.819374-03
1713	Produto 239260	\N	239260	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.826641-03	2026-02-27 20:08:22.827357-03
1714	Produto 239271	\N	239271	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.827357-03	2026-02-27 20:08:22.827357-03
1715	Produto 239275	\N	239275	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.827357-03	2026-02-27 20:08:22.827357-03
1716	Produto 244747	\N	244747	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.827357-03	2026-02-27 20:08:22.827357-03
1717	Produto 244750	\N	244750	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.827357-03	2026-02-27 20:08:22.827357-03
1718	Produto 244746	\N	244746	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.835046-03	2026-02-27 20:08:22.835046-03
1719	Produto 244752	\N	244752	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.835813-03	2026-02-27 20:08:22.835813-03
1720	Produto 244748	\N	244748	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.835813-03	2026-02-27 20:08:22.835813-03
1721	Produto 244737	\N	244737	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.835813-03	2026-02-27 20:08:22.835813-03
1722	Produto 244761	\N	244761	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.835813-03	2026-02-27 20:08:22.835813-03
1723	Produto 239262	\N	239262	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.843358-03	2026-02-27 20:08:22.843358-03
1724	Produto 239247	\N	239247	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.844305-03	2026-02-27 20:08:22.844305-03
1725	Produto 239243	\N	239243	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.844305-03	2026-02-27 20:08:22.844305-03
1726	Produto 239255	\N	239255	Geral	Descoberto em Todos os Produtos (Pág 89)	\N	5	0.00	\N	2026-02-27 20:08:22.844305-03	2026-02-27 20:08:22.844305-03
1727	Produto 239276	\N	239276	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.185415-03	2026-02-27 20:08:31.185415-03
1728	Produto 239272	\N	239272	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.192213-03	2026-02-27 20:08:31.192213-03
1729	Produto 239235	\N	239235	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.194514-03	2026-02-27 20:08:31.194514-03
1730	Produto 240313	\N	240313	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.194514-03	2026-02-27 20:08:31.194514-03
1731	Produto 252088	\N	252088	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.201616-03	2026-02-27 20:08:31.201616-03
1732	Produto 239252	\N	239252	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.203277-03	2026-02-27 20:08:31.203964-03
1733	Produto 239249	\N	239249	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.203964-03	2026-02-27 20:08:31.203964-03
1734	Produto 239240	\N	239240	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.203964-03	2026-02-27 20:08:31.203964-03
1735	Produto 256330	\N	256330	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.209838-03	2026-02-27 20:08:31.209838-03
1736	Produto 239222	\N	239222	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.209838-03	2026-02-27 20:08:31.209838-03
1737	Produto 239233	\N	239233	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.209838-03	2026-02-27 20:08:31.209838-03
1738	Produto 241076	\N	241076	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.209838-03	2026-02-27 20:08:31.209838-03
1739	Produto 239274	\N	239274	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.209838-03	2026-02-27 20:08:31.209838-03
1740	Produto 239978	\N	239978	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.218331-03	2026-02-27 20:08:31.218663-03
1741	Produto 239989	\N	239989	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.218663-03	2026-02-27 20:08:31.218663-03
1742	Produto 239263	\N	239263	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.218663-03	2026-02-27 20:08:31.218663-03
1743	Produto 239997	\N	239997	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.218663-03	2026-02-27 20:08:31.218663-03
1744	Produto 239993	\N	239993	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.225578-03	2026-02-27 20:08:31.226616-03
1745	Produto 239957	\N	239957	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.226616-03	2026-02-27 20:08:31.226616-03
1746	Produto 239261	\N	239261	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.226616-03	2026-02-27 20:08:31.226616-03
1747	Produto 239231	\N	239231	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.226616-03	2026-02-27 20:08:31.226616-03
1748	Produto 239964	\N	239964	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.226616-03	2026-02-27 20:08:31.226616-03
1749	Produto 239223	\N	239223	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.233781-03	2026-02-27 20:08:31.233781-03
1750	Produto 239270	\N	239270	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.235009-03	2026-02-27 20:08:31.235009-03
1751	Produto 239963	\N	239963	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.036292-03	2026-02-27 20:08:38.037299-03
1752	Produto 239227	\N	239227	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.040298-03	2026-02-27 20:08:38.04126-03
1753	Produto 239962	\N	239962	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.042704-03	2026-02-27 20:08:38.043686-03
1754	Produto 239241	\N	239241	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.045702-03	2026-02-27 20:08:38.045702-03
1755	Produto 244740	\N	244740	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.047691-03	2026-02-27 20:08:38.048688-03
1756	Produto 239238	\N	239238	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.050897-03	2026-02-27 20:08:38.050897-03
1757	Produto 239799	\N	239799	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.052856-03	2026-02-27 20:08:38.052856-03
1758	Produto 239796	\N	239796	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.05389-03	2026-02-27 20:08:38.054893-03
1759	Produto 4953	\N	4953	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.055855-03	2026-02-27 20:08:38.0569-03
1760	Produto 78213	\N	78213	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.058288-03	2026-02-27 20:08:38.058288-03
1761	Produto 95777	\N	95777	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.060384-03	2026-02-27 20:08:38.060384-03
1762	Produto 124834	\N	124834	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.06238-03	2026-02-27 20:08:38.06238-03
1763	Produto 200147	\N	200147	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.064347-03	2026-02-27 20:08:38.064347-03
1764	Produto 215505	\N	215505	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.06636-03	2026-02-27 20:08:38.06636-03
1765	Produto 215507	\N	215507	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.068447-03	2026-02-27 20:08:38.068447-03
1766	Produto 217197	\N	217197	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.069461-03	2026-02-27 20:08:38.070444-03
1767	Produto 213551	\N	213551	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.071448-03	2026-02-27 20:08:38.072445-03
1768	Produto 215506	\N	215506	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.073469-03	2026-02-27 20:08:38.073469-03
1769	Produto 215508	\N	215508	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.074446-03	2026-02-27 20:08:38.075741-03
1770	Produto 213557	\N	213557	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.07675-03	2026-02-27 20:08:38.07675-03
1771	Produto 232514	\N	232514	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.078742-03	2026-02-27 20:08:38.078742-03
1772	Produto 166347	\N	166347	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.080749-03	2026-02-27 20:08:38.080749-03
1773	Produto 166327	\N	166327	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.082772-03	2026-02-27 20:08:38.083173-03
1774	Produto 244749	\N	244749	Geral	Descoberto em Todos os Produtos (Pág 91)	\N	5	0.00	\N	2026-02-27 20:08:38.084252-03	2026-02-27 20:08:38.085263-03
1775	Produto 216474	\N	216474	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:45.976972-03	2026-02-27 20:08:45.977982-03
1776	Produto 102728	\N	102728	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:45.979971-03	2026-02-27 20:08:45.980979-03
1777	Produto 140714	\N	140714	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:45.983241-03	2026-02-27 20:08:45.983241-03
1778	Produto 107130	\N	107130	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:45.985353-03	2026-02-27 20:08:45.985353-03
1779	Produto 107132	\N	107132	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:45.987313-03	2026-02-27 20:08:45.988311-03
1780	Produto 3379	\N	3379	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:45.989868-03	2026-02-27 20:08:45.990178-03
1781	Produto 122119	\N	122119	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:45.991234-03	2026-02-27 20:08:45.992233-03
1782	Produto 104102	\N	104102	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:45.993233-03	2026-02-27 20:08:45.994232-03
1783	Produto 95782	\N	95782	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:45.995232-03	2026-02-27 20:08:45.995232-03
1784	Produto 104891	\N	104891	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:45.996265-03	2026-02-27 20:08:45.99728-03
1785	Produto 239969	\N	239969	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:45.998279-03	2026-02-27 20:08:45.99876-03
1786	Produto 239960	\N	239960	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:45.999857-03	2026-02-27 20:08:45.999857-03
1787	Produto 239985	\N	239985	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:46.000862-03	2026-02-27 20:08:46.000862-03
1788	Produto 110203	\N	110203	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:46.001866-03	2026-02-27 20:08:46.002915-03
1789	Produto 110204	\N	110204	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:46.003916-03	2026-02-27 20:08:46.003916-03
1790	Produto 110200	\N	110200	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:46.004916-03	2026-02-27 20:08:46.004916-03
1791	Produto 110201	\N	110201	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:46.00699-03	2026-02-27 20:08:46.00699-03
1792	Produto 110199	\N	110199	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:46.008089-03	2026-02-27 20:08:46.008089-03
1793	Produto 127762	\N	127762	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:46.009081-03	2026-02-27 20:08:46.010089-03
1794	Produto 102924	\N	102924	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:46.011088-03	2026-02-27 20:08:46.012088-03
1795	Produto 106548	\N	106548	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:46.014092-03	2026-02-27 20:08:46.014092-03
1796	Produto 104879	\N	104879	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:46.015559-03	2026-02-27 20:08:46.016646-03
1797	Produto 104886	\N	104886	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:46.018191-03	2026-02-27 20:08:46.018191-03
1798	Produto 108140	\N	108140	Geral	Descoberto em Todos os Produtos (Pág 92)	\N	5	0.00	\N	2026-02-27 20:08:46.020237-03	2026-02-27 20:08:46.020237-03
1799	Produto 107129	\N	107129	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.094326-03	2026-02-27 20:08:54.095331-03
1800	Produto 104878	\N	104878	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.098803-03	2026-02-27 20:08:54.098803-03
1801	Produto 108154	\N	108154	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.098803-03	2026-02-27 20:08:54.098803-03
1802	Produto 107131	\N	107131	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.098803-03	2026-02-27 20:08:54.098803-03
1803	Produto 116838	\N	116838	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.106587-03	2026-02-27 20:08:54.106587-03
1804	Produto 116699	\N	116699	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.106587-03	2026-02-27 20:08:54.108879-03
1805	Produto 135023	\N	135023	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.108879-03	2026-02-27 20:08:54.108879-03
1806	Produto 135034	\N	135034	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.108879-03	2026-02-27 20:08:54.108879-03
1807	Produto 135022	\N	135022	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.108879-03	2026-02-27 20:08:54.108879-03
1808	Produto 135026	\N	135026	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.11489-03	2026-02-27 20:08:54.115211-03
1809	Produto 137967	\N	137967	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.115846-03	2026-02-27 20:08:54.115846-03
1810	Produto 151029	\N	151029	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.115846-03	2026-02-27 20:08:54.115846-03
1811	Produto 166342	\N	166342	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.115846-03	2026-02-27 20:08:54.115846-03
1812	Produto 166337	\N	166337	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.115846-03	2026-02-27 20:08:54.115846-03
1813	Produto 173594	\N	173594	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.123158-03	2026-02-27 20:08:54.123158-03
1814	Produto 239229	\N	239229	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.123158-03	2026-02-27 20:08:54.123158-03
1815	Produto 239982	\N	239982	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.123158-03	2026-02-27 20:08:54.123158-03
1816	Produto 239991	\N	239991	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.123158-03	2026-02-27 20:08:54.123158-03
1817	Produto 204405	\N	204405	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.123158-03	2026-02-27 20:08:54.129588-03
1818	Produto 216041	\N	216041	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.130475-03	2026-02-27 20:08:54.131888-03
1819	Produto 221666	\N	221666	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.131888-03	2026-02-27 20:08:54.131888-03
1820	Produto 213224	\N	213224	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.131888-03	2026-02-27 20:08:54.131888-03
1821	Produto 216045	\N	216045	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.131888-03	2026-02-27 20:08:54.131888-03
1822	Produto 208133	\N	208133	Geral	Descoberto em Todos os Produtos (Pág 93)	\N	5	0.00	\N	2026-02-27 20:08:54.131888-03	2026-02-27 20:08:54.131888-03
1823	Produto 208132	\N	208132	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.97615-03	2026-02-27 20:09:01.977156-03
1824	Produto 219745	\N	219745	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.979172-03	2026-02-27 20:09:01.980443-03
1825	Produto 241081	\N	241081	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.981449-03	2026-02-27 20:09:01.981449-03
1826	Produto 231688	\N	231688	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.982444-03	2026-02-27 20:09:01.983437-03
1827	Produto 239195	\N	239195	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.98444-03	2026-02-27 20:09:01.98444-03
1828	Produto 252078	\N	252078	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.985439-03	2026-02-27 20:09:01.985439-03
1829	Produto 239244	\N	239244	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.986437-03	2026-02-27 20:09:01.987448-03
1830	Produto 244731	\N	244731	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.98789-03	2026-02-27 20:09:01.98897-03
1831	Produto 239273	\N	239273	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.989967-03	2026-02-27 20:09:01.989967-03
1832	Produto 155894	\N	155894	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.990972-03	2026-02-27 20:09:01.990972-03
1833	Produto 155897	\N	155897	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.991965-03	2026-02-27 20:09:01.992968-03
1834	Produto 114276	\N	114276	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.992968-03	2026-02-27 20:09:01.993965-03
1835	Produto 59363	\N	59363	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.993965-03	2026-02-27 20:09:01.994966-03
1836	Produto 124394	\N	124394	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.995977-03	2026-02-27 20:09:01.995977-03
1837	Produto 217165	\N	217165	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.997289-03	2026-02-27 20:09:01.997289-03
1838	Produto 160266	\N	160266	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.998292-03	2026-02-27 20:09:01.998292-03
1839	Produto 106547	\N	106547	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:01.999289-03	2026-02-27 20:09:01.999289-03
1840	Produto 106550	\N	106550	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:02.00029-03	2026-02-27 20:09:02.001288-03
1841	Produto 108157	\N	108157	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:02.001288-03	2026-02-27 20:09:02.002291-03
1842	Produto 111305	\N	111305	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:02.002291-03	2026-02-27 20:09:02.003288-03
1843	Produto 111306	\N	111306	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:02.003288-03	2026-02-27 20:09:02.004293-03
1844	Produto 108156	\N	108156	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:02.004293-03	2026-02-27 20:09:02.005615-03
1845	Produto 121341	\N	121341	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:02.006615-03	2026-02-27 20:09:02.006615-03
1846	Produto 111428	\N	111428	Geral	Descoberto em Todos os Produtos (Pág 94)	\N	5	0.00	\N	2026-02-27 20:09:02.007615-03	2026-02-27 20:09:02.007615-03
1847	Produto 108155	\N	108155	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.897697-03	2026-02-27 20:09:08.898697-03
1848	Produto 108146	\N	108146	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.900691-03	2026-02-27 20:09:08.900691-03
1849	Produto 123066	\N	123066	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.90169-03	2026-02-27 20:09:08.902691-03
1850	Produto 124833	\N	124833	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.90312-03	2026-02-27 20:09:08.904401-03
1851	Produto 124203	\N	124203	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.9054-03	2026-02-27 20:09:08.9054-03
1852	Produto 150190	\N	150190	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.9064-03	2026-02-27 20:09:08.9064-03
1853	Produto 150217	\N	150217	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.9074-03	2026-02-27 20:09:08.9074-03
1854	Produto 150304	\N	150304	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.9084-03	2026-02-27 20:09:08.9084-03
1855	Produto 150303	\N	150303	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.9094-03	2026-02-27 20:09:08.9094-03
1856	Produto 150302	\N	150302	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.9104-03	2026-02-27 20:09:08.911412-03
1857	Produto 140759	\N	140759	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.912712-03	2026-02-27 20:09:08.912712-03
1858	Produto 174618	\N	174618	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.91371-03	2026-02-27 20:09:08.914709-03
1859	Produto 189774	\N	189774	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.915709-03	2026-02-27 20:09:08.915709-03
1860	Produto 179544	\N	179544	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.916709-03	2026-02-27 20:09:08.916709-03
1861	Produto 217167	\N	217167	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.91771-03	2026-02-27 20:09:08.918709-03
1862	Produto 217169	\N	217169	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.918709-03	2026-02-27 20:09:08.919712-03
1863	Produto 213217	\N	213217	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.920022-03	2026-02-27 20:09:08.920702-03
1864	Produto 216052	\N	216052	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.920702-03	2026-02-27 20:09:08.920702-03
1865	Produto 20214	\N	20214	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.920702-03	2026-02-27 20:09:08.920702-03
1866	Produto 58005	\N	58005	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.920702-03	2026-02-27 20:09:08.920702-03
1867	Produto 57996	\N	57996	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.920702-03	2026-02-27 20:09:08.920702-03
1868	Produto 60000	\N	60000	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.920702-03	2026-02-27 20:09:08.920702-03
1869	Produto 67666	\N	67666	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.928142-03	2026-02-27 20:09:08.928142-03
1870	Produto 963	\N	963	Geral	Descoberto em Todos os Produtos (Pág 95)	\N	5	0.00	\N	2026-02-27 20:09:08.929055-03	2026-02-27 20:09:08.929055-03
1871	Produto 229960	\N	229960	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.478536-03	2026-02-27 20:09:16.478536-03
1872	Produto 252084	\N	252084	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.478536-03	2026-02-27 20:09:16.478536-03
1873	Produto 241060	\N	241060	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.485388-03	2026-02-27 20:09:16.486361-03
1874	Produto 252077	\N	252077	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.486361-03	2026-02-27 20:09:16.486361-03
1875	Produto 111561	\N	111561	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.486361-03	2026-02-27 20:09:16.486361-03
1876	Produto 75493	\N	75493	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.486361-03	2026-02-27 20:09:16.486361-03
1877	Produto 228239	\N	228239	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.486361-03	2026-02-27 20:09:16.493666-03
1878	Produto 239788	\N	239788	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.49468-03	2026-02-27 20:09:16.49468-03
1879	Produto 252086	\N	252086	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.49468-03	2026-02-27 20:09:16.49468-03
1880	Produto 235531	\N	235531	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.49468-03	2026-02-27 20:09:16.49468-03
1881	Produto 239998	\N	239998	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.49468-03	2026-02-27 20:09:16.49468-03
1882	Produto 203389	\N	203389	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.49468-03	2026-02-27 20:09:16.49468-03
1883	Produto 239986	\N	239986	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.49468-03	2026-02-27 20:09:16.49468-03
1884	Produto 239965	\N	239965	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.502012-03	2026-02-27 20:09:16.503017-03
1885	Produto 239996	\N	239996	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.503017-03	2026-02-27 20:09:16.503017-03
1886	Produto 239966	\N	239966	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.503017-03	2026-02-27 20:09:16.503017-03
1887	Produto 239967	\N	239967	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.503017-03	2026-02-27 20:09:16.503017-03
1888	Produto 252076	\N	252076	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.503017-03	2026-02-27 20:09:16.503017-03
1889	Produto 122499	\N	122499	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.503017-03	2026-02-27 20:09:16.503017-03
1890	Produto 171357	\N	171357	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.503017-03	2026-02-27 20:09:16.51035-03
1891	Produto 123055	\N	123055	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.511323-03	2026-02-27 20:09:16.511323-03
1892	Produto 100144	\N	100144	Geral	Descoberto em Todos os Produtos (Pág 96)	\N	5	0.00	\N	2026-02-27 20:09:16.511323-03	2026-02-27 20:09:16.511323-03
1	Kit Kaiak Aventura Masculino 100 ml	\N	254600	Homem	Kit Kaiak Aventura Masculino 100 ml\nRef: 254600	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7b9b3bb8/produto-joia/background/desktop/254600.jpg	5	0.00	0.00	2026-02-27 20:12:59.671675-03	2026-02-27 19:56:51.877903-03
3	Kit Sabonete em Barra Puro Vegetal Tododia (4 caixas)	\N	241070	Corpo e Banho	Kit Sabonete em Barra Puro Vegetal Tododia (4 caixas)\nRef: 241070	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw33899df2/Produtos/NATBRA-241070_1.jpg	5	0.00	0.00	2026-02-27 20:13:13.943157-03	2026-02-27 19:56:51.889678-03
4	Biografia Feminino 100 ml	\N	71600	Geral	Biografia Feminino 100 ml\nRef: 71600	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw08abba22/produto-joia/background/desktop/71600.jpg	5	0.00	0.00	2026-02-27 20:13:36.755208-03	2026-02-27 19:56:51.897742-03
5	Kit Tododia Morango e Baunilha Dourada com Body Splash (2 produtos)	\N	230067	Geral	Kit Tododia Morango e Baunilha Dourada com Body Splash (2 produtos)\nRef: 230067	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3fd722d5/produto-joia/background/desktop/230067.jpg	5	0.00	0.00	2026-02-27 20:13:52.279854-03	2026-02-27 19:56:51.897742-03
7	Essencial Único Masculino 90 ml	\N	103348	Homem	Essencial Único Masculino 90 ml\nRef: 103348	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw529cda89/produto-joia/background/desktop/103348.jpg	5	0.00	0.00	2026-02-27 20:14:17.882347-03	2026-02-27 19:56:51.906089-03
9	Biografia Assinatura Feminino 100 ml	\N	71602	Geral	Biografia Assinatura Feminino 100 ml\nRef: 71602	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb818556c/produto-joia/background/desktop/71602.jpg	5	0.00	0.00	2026-02-27 20:14:43.695312-03	2026-02-27 19:56:51.906089-03
11	Essencial Oud Feminino 100 ml	\N	76425	Geral	Essencial Oud Feminino 100 ml\nRef: 76425	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw396d5289/produto-joia/background/desktop/76425.jpg	5	0.00	0.00	2026-02-27 20:15:09.310726-03	2026-02-27 19:56:51.914405-03
13	Kriska Drama 100 ml	\N	68943	Geral	Kriska Drama 100 ml\nRef: 68943	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw290abfc5/produto-joia/background/desktop/68943.jpg	5	0.00	0.00	2026-02-27 20:15:23.547024-03	2026-02-27 19:56:51.921689-03
15	Biografia Assinatura Masculino 100 ml	\N	71603	Homem	Biografia Assinatura Masculino 100 ml\nRef: 71603	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw95586380/produto-joia/background/desktop/71603.jpg	5	0.00	0.00	2026-02-27 20:15:53.744084-03	2026-02-27 19:56:51.922694-03
16	Essencial Exclusivo Masculino 100 ml	\N	76422	Homem	Essencial Exclusivo Masculino 100 ml\nRef: 76422	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwedd24450/produto-joia/background/desktop/76422.jpg	5	0.00	0.00	2026-02-27 20:16:24.202983-03	2026-02-27 19:56:51.930049-03
17	Protetor Multiclareador FPS 70 Chronos Derma	\N	89247	Geral	Protetor Multiclareador FPS 70 Chronos Derma\nRef: 89247	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3f5a4ba2/produto-joia/background/desktop/89247.jpg	5	0.00	0.00	2026-02-27 20:16:35.102808-03	2026-02-27 19:56:51.933097-03
19	Natura Homem Essence 100 ml	\N	59847	Homem	Natura Homem Essence 100 ml\nRef: 59847	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb372f997/produto-joia/background/desktop/59847.jpg	5	0.00	0.00	2026-02-27 20:16:58.478505-03	2026-02-27 19:56:51.938099-03
20	Essencial Exclusivo Feminino 100 ml	\N	76423	Geral	Essencial Exclusivo Feminino 100 ml\nRef: 76423	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe398d26e/produto-joia/background/desktop/76423.jpg	5	0.00	0.00	2026-02-27 20:17:15.588976-03	2026-02-27 19:56:51.941097-03
21	Essencial Atrai Feminino 100 ml	\N	165813	Geral	Essencial Atrai Feminino 100 ml\nRef: 165813	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd956ac6d/produto-joia/background/desktop/165813.jpg	5	0.00	0.00	2026-02-27 20:17:44.155462-03	2026-02-27 19:56:51.941097-03
24	Kit Tododia Sabonetes em Barra com 2 Caixas	\N	220211	Corpo e Banho	Kit Tododia Sabonetes em Barra com 2 Caixas\nRef: 220211	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf4b49a3c/Produtos/NATBRA-220211_1.jpg	5	0.00	0.00	2026-02-27 20:18:09.839149-03	2026-02-27 19:56:58.640563-03
26	Natura Homem Dom 100 ml	\N	71770	Homem	Natura Homem Dom 100 ml\nRef: 71770	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc4573aeb/produto-joia/background/desktop/71770.jpg	5	0.00	0.00	2026-02-27 20:18:31.479409-03	2026-02-27 19:56:58.646563-03
27	Essencial Masculino 100 ml	\N	76420	Homem	Essencial Masculino 100 ml\nRef: 76420	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3ed3cfe0/produto-joia/background/desktop/76420.jpg	5	0.00	0.00	2026-02-27 20:18:46.586836-03	2026-02-27 19:56:58.649562-03
29	Essencial Oud Masculino 100 ml	\N	76424	Homem	Essencial Oud Masculino 100 ml\nRef: 76424	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3b99cf7e/produto-joia/background/desktop/76424.jpg	5	0.00	0.00	2026-02-27 20:19:05.920988-03	2026-02-27 19:56:58.654562-03
30	Kit Tododia Macadâmia com Body Splash (2 produtos)	\N	240507	Geral	Kit Tododia Macadâmia com Body Splash (2 produtos)\nRef: 240507	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5b904277/produto-joia/background/desktop/240507.jpg	5	0.00	0.00	2026-02-27 20:19:20.61682-03	2026-02-27 19:56:58.65761-03
32	Hoje Feminino 100 ml	\N	13691	Geral	Hoje Feminino 100 ml\nRef: 13691	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe71a7743/produto-joia/background/desktop/13691.jpg	5	0.00	0.00	2026-02-27 20:19:46.514363-03	2026-02-27 19:56:58.662565-03
34	Presente Natura Mamãe e Bebê (3 produtos)	\N	93782	Infantil	Presente Natura Mamãe e Bebê (3 produtos)\nRef: 93782	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2eb1b576/produto-joia/background/desktop/93782.jpg	5	0.00	0.00	2026-02-27 20:20:18.150917-03	2026-02-27 19:56:58.669562-03
35	Body Splash Tododia Capim Limão e Hortelã 200 ml	\N	109160	Geral	Body Splash Tododia Capim Limão e Hortelã 200 ml\nRef: 109160	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw651f9662/produto-joia/background/desktop/109160.jpg	5	0.00	0.00	2026-02-27 20:20:29.987499-03	2026-02-27 19:56:58.671563-03
37	Refil Creme Desodorante Nutritivo para o Corpo Tododia Amora Vermelha e Jabuticaba	\N	87516	Corpo e Banho	Refil Creme Desodorante Nutritivo para o Corpo Tododia Amora Vermelha e Jabuticaba\nRef: 87516	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2cbe0dc5/produto-joia/background/desktop/87516.jpg	5	58.90	58.90	2026-02-27 20:20:53.406052-03	2026-02-27 19:56:58.67657-03
38	Sabonete Em Barra Puro Vegetal Tododia Capim Limão e Hortelã	\N	109163	Corpo e Banho	Sabonete Em Barra Puro Vegetal Tododia Capim Limão e Hortelã\nRef: 109163	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw44bfefb4/produto-joia/background/desktop/109163.jpg	5	0.00	0.00	2026-02-27 20:21:08.792432-03	2026-02-27 19:56:58.679571-03
40	Kriska Shock 100 ml	\N	68944	Geral	Kriska Shock 100 ml\nRef: 68944	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdedffd23/produto-joia/background/desktop/68944.jpg	5	0.00	0.00	2026-02-27 20:21:28.225167-03	2026-02-27 19:56:58.684568-03
42	Luna 75 ml	\N	44452	Geral	Luna 75 ml\nRef: 44452	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcd19e230/produto-joia/background/desktop/44452.jpg	5	0.00	0.00	2026-02-27 20:22:05.361675-03	2026-02-27 19:56:58.691079-03
44	Kit Kaiak Clássico Masculino (2 unidades)	\N	258113	Homem	Kit Kaiak Clássico Masculino (2 unidades)\nRef: 258113	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4b5c71f8/produto-joia/background/desktop/258113.jpg	5	0.00	0.00	2026-02-27 20:22:28.257864-03	2026-02-27 19:56:58.696081-03
45	Body Splash Tododia Flor de Gengibre e Tangerina 200 ml	\N	152286	Geral	Body Splash Tododia Flor de Gengibre e Tangerina 200 ml\nRef: 152286	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2da743d3/produto-joia/background/desktop/152286.jpg	5	0.00	0.00	2026-02-27 20:22:42.02549-03	2026-02-27 19:57:06.585147-03
47	Body Splash Tododia Amora Vermelha e Jabuticaba 200 ml	\N	88075	Geral	Body Splash Tododia Amora Vermelha e Jabuticaba 200 ml\nRef: 88075	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8aead48b/produto-joia/background/desktop/88075.jpg	5	93.90	93.90	2026-02-27 20:23:20.764474-03	2026-02-27 19:57:06.587452-03
49	Águas Lavanda Feminino 170 ml	\N	95644	Geral	Águas Lavanda Feminino 170 ml\nRef: 95644	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc377365b/produto-joia/background/desktop/95644.jpg	5	0.00	0.00	2026-02-27 20:23:31.273704-03	2026-02-27 19:57:06.59551-03
50	Kit Óleo Desodorante Corporal Sève Amêndoas Doces Intensa com Refil (2 produtos)	\N	208315	Corpo e Banho	Kit Óleo Desodorante Corporal Sève Amêndoas Doces Intensa com Refil (2 produtos)\nRef: 208315	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9f422cf7/produto-joia/background/desktop/208315.jpg	5	0.00	0.00	2026-02-27 20:23:46.415094-03	2026-02-27 19:57:06.59551-03
53	Sabonete em Barra Puro Vegetal Cremoso e Esfoliante Refrescante Ekos	\N	129799	Corpo e Banho	Sabonete em Barra Puro Vegetal Cremoso e Esfoliante Refrescante Ekos\nRef: 129799	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3092b0a2/produto-joia/background/desktop/129799.jpg	5	0.00	0.00	2026-02-27 20:24:16.158857-03	2026-02-27 19:57:06.59551-03
51	Ekos Frescor Pitanga 150 ml	\N	73563	Geral	Ekos Frescor Pitanga 150 ml\nRef: 73563	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1f58d026/produto-joia/background/desktop/73563.jpg	5	0.00	0.00	2026-02-27 20:24:45.224197-03	2026-02-27 19:57:06.59551-03
57	Kit Mamãe e Bebê Relaxante (3 produtos)	\N	218194	Infantil	Kit Mamãe e Bebê Relaxante (3 produtos)\nRef: 218194	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw981dea29/produto-joia/background/desktop/218194.jpg	5	0.00	0.00	2026-02-27 20:25:06.869402-03	2026-02-27 19:57:06.604009-03
56	Refil Sabonete Líquido da Cabeça aos Pés Mamãe e Bebê	\N	92802	Corpo e Banho	Refil Sabonete Líquido da Cabeça aos Pés Mamãe e Bebê\nRef: 92802	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw201305ba/NATBRA-92802_1.jpg	5	39.90	39.90	2026-02-27 20:25:18.529168-03	2026-02-27 19:57:06.604009-03
59	Kaiak Aventura Masculino 100 ml	\N	108402	Homem	Kaiak Aventura Masculino 100 ml\nRef: 108402	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2133ed04/produto-joia/background/desktop/108402.jpg	5	189.90	189.90	2026-02-27 20:25:32.663564-03	2026-02-27 19:57:06.604009-03
63	Ilía Secreto 50 ml	\N	83314	Geral	Ilía Secreto 50 ml\nRef: 83314	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbef76b12/produto-joia/background/desktop/83314.jpg	5	199.90	199.90	2026-02-27 20:26:01.360646-03	2026-02-27 19:57:06.612231-03
62	Sérum Intensivo Multiclareador Chronos Derma	\N	169222	Geral	Sérum Intensivo Multiclareador Chronos Derma\nRef: 169222	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbe6bec49/produto-joia/background/desktop/169222.jpg	5	0.00	0.00	2026-02-27 20:26:17.229846-03	2026-02-27 19:57:06.612231-03
60	Kit Desodorante Antitranspirante Roll-on Erva Doce (3 unidades)	\N	213548	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Erva Doce (3 unidades)\nRef: 213548	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd71c3c93/produto-joia/background/desktop/213548.jpg	5	0.00	0.00	2026-02-27 20:26:44.749892-03	2026-02-27 19:57:06.612231-03
67	Natura Homem 100 ml	\N	53255	Homem	Natura Homem 100 ml\nRef: 53255	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa74b99d6/produto-joia/background/desktop/53255.jpg	5	0.00	0.00	2026-02-27 20:27:10.362433-03	2026-02-27 19:57:06.620512-03
66	Natura Homem Tato 100 ml	\N	99159	Homem	Natura Homem Tato 100 ml\nRef: 99159	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6558b335/produto-joia/background/desktop/99159.jpg	5	0.00	0.00	2026-02-27 20:27:21.263501-03	2026-02-27 19:57:06.620512-03
68	Humor a Dois Masculino 75 ml	\N	86725	Homem	Humor a Dois Masculino 75 ml\nRef: 86725	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd2fb56f2/produto-joia/background/desktop/86725.jpg	5	164.90	164.90	2026-02-27 20:28:00.022044-03	2026-02-27 19:57:06.620512-03
70	Colônia Naturé Catavento 100 ml	\N	106421	Perfumaria	Colônia Naturé Catavento 100 ml\nRef: 106421	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6868a44d/produto-joia/background/desktop/106421.jpg	5	0.00	0.00	2026-02-27 20:28:25.625354-03	2026-02-27 19:57:14.053205-03
72	Kit Cachos Tododia Amora e Óleo de Coco (4 produtos)	\N	209112	Corpo e Banho	Kit Cachos Tododia Amora e Óleo de Coco (4 produtos)\nRef: 209112	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw70dfb1ad/produto-joia/background/desktop/209112.jpg	5	0.00	0.00	2026-02-27 20:28:50.068114-03	2026-02-27 19:57:14.055212-03
74	Desodorante Antitranspirante Roll-on Tododia Algodão	\N	189401	Corpo e Banho	Desodorante Antitranspirante Roll-on Tododia Algodão\nRef: 189401	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd1913dcf/produto-joia/background/desktop/189401.jpg	5	29.90	29.90	2026-02-27 20:29:21.695523-03	2026-02-27 19:57:14.058198-03
75	Humor Liberta 75 ml	\N	102422	Geral	Humor Liberta 75 ml\nRef: 102422	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8f1ba940/produto-joia/background/desktop/102422.jpg	5	0.00	0.00	2026-02-27 20:29:34.811842-03	2026-02-27 19:57:14.060157-03
77	Paz e Humor Masculino 75 ml	\N	86728	Homem	Paz e Humor Masculino 75 ml\nRef: 86728	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9dc64483/produto-joia/background/desktop/86728.jpg	5	0.00	0.00	2026-02-27 20:30:02.664134-03	2026-02-27 19:57:14.0625-03
78	Creme Desodorante Nutritivo para o Corpo Tododia Cereja Negra e Praliné	\N	174614	Corpo e Banho	Creme Desodorante Nutritivo para o Corpo Tododia Cereja Negra e Praliné\nRef: 174614	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa7177107/produto-joia/background/desktop/174614.jpg	5	78.90	78.90	2026-02-27 20:30:14.180935-03	2026-02-27 19:57:14.064499-03
80	Sabonete em Barra Puro Vegetal Tododia Romã e Flor de Amora	\N	150230	Corpo e Banho	Sabonete em Barra Puro Vegetal Tododia Romã e Flor de Amora\nRef: 150230	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwea1cc9e6/Produtos/NATBRA-150230_1.jpg	5	0.00	0.00	2026-02-27 20:30:40.098421-03	2026-02-27 19:57:14.0675-03
82	Kaiak Oceano Masculino 100 ml	\N	108405	Homem	Kaiak Oceano Masculino 100 ml\nRef: 108405	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa08885d4/produto-joia/background/desktop/108405.jpg	5	189.90	189.90	2026-02-27 20:30:59.692534-03	2026-02-27 19:57:14.069771-03
83	Sabonete em Barra Puro Vegetal Tododia Morango e Baunilha Dourada (5 unidades)	\N	205939	Corpo e Banho	Sabonete em Barra Puro Vegetal Tododia Morango e Baunilha Dourada (5 unidades)\nRef: 205939	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc7c39d3e/produto-joia/background/desktop/205939.jpg	5	0.00	0.00	2026-02-27 20:31:12.075941-03	2026-02-27 19:57:14.071766-03
85	Kit Tododia Flor de Cereja e Abacate (3 produtos)	\N	209174	Geral	Kit Tododia Flor de Cereja e Abacate (3 produtos)\nRef: 209174	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1e696018/produto-joia/background/desktop/209174.jpg	5	0.00	0.00	2026-02-27 20:31:40.291631-03	2026-02-27 19:57:14.074776-03
87	Essencial Sentir Masculino 100 ml	\N	167755	Homem	Essencial Sentir Masculino 100 ml\nRef: 167755	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4dfd9ee4/produto-joia/background/desktop/167755.jpg	5	279.90	279.90	2026-02-27 20:32:03.946137-03	2026-02-27 19:57:14.076794-03
89	Desodorante Antitranspirante Roll-on Tododia Pele Uniforme	\N	190850	Corpo e Banho	Desodorante Antitranspirante Roll-on Tododia Pele Uniforme\nRef: 190850	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw16d74e94/produto-joia/background/desktop/190850.jpg	5	29.90	29.90	2026-02-27 20:32:32.015214-03	2026-02-27 19:57:14.080174-03
1893	OLEO CORPORAL NATURA SEVE 200ML AMENDOAS DOCE	7909883202132	\N	Perfumaria	Fonte: Cosmos_Api	\N	5	0.00	\N	\N	2026-02-28 00:46:36.309638-03
90	Luna Intensa 50 ml	\N	86935	Geral	Luna Intensa 50 ml\nRef: 86935	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5ede7282/produto-joia/background/desktop/86935.jpg	5	219.90	219.90	2026-02-28 12:09:12.350461-03	2026-02-27 19:57:14.082172-03
92	Essencial Intenso Masculino 100 ml	\N	95572	Homem	Essencial Intenso Masculino 100 ml\nRef: 95572	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw46520df0/produto-joia/background/desktop/95572.jpg	5	0.00	0.00	2026-02-28 12:09:41.355145-03	2026-02-27 19:57:14.084178-03
93	Sabonete em Barra Puro Vegetal Tododia Amora Vermelha e Jabuticaba	\N	87512	Corpo e Banho	Sabonete em Barra Puro Vegetal Tododia Amora Vermelha e Jabuticaba\nRef: 87512	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5a4cdb21/produto-joia/background/desktop/87512.jpg	5	34.90	34.90	2026-02-28 12:09:52.833889-03	2026-02-27 19:57:22.019852-03
95	Hidratante Mamãe e Bebê	\N	92804	Corpo e Banho	Hidratante Mamãe e Bebê\nRef: 92804	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa6b951c4/produto-joia/background/desktop/92804.jpg	5	0.00	0.00	2026-02-28 12:10:18.487108-03	2026-02-27 19:57:22.025768-03
97	Kaiak Masculino 100 ml	\N	108400	Homem	Kaiak Masculino 100 ml\nRef: 108400	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0db74c67/produto-joia/background/desktop/108400.jpg	5	189.90	189.90	2026-02-28 12:11:14.126483-03	2026-02-27 19:57:22.029941-03
98	Refil Essencial Único Masculino 90 ml	\N	107122	Homem	Refil Essencial Único Masculino 90 ml\nRef: 107122	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw470f4047/produto-joia/background/desktop/107122.png	5	228.90	228.90	2026-02-28 12:11:27.617138-03	2026-02-27 19:57:22.032946-03
100	Kit Ilía Clássico (2 unidades)	\N	258122	Geral	Kit Ilía Clássico (2 unidades)\nRef: 258122	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw01fa5a7c/produto-joia/background/desktop/258122.jpg	5	0.00	0.00	2026-02-28 12:11:55.552374-03	2026-02-27 19:57:22.036563-03
101	Refil Creme Desodorante Nutritivo Para o Corpo Tododia Capim Limão e Hortelã	\N	109159	Corpo e Banho	Refil Creme Desodorante Nutritivo Para o Corpo Tododia Capim Limão e Hortelã\nRef: 109159	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdefda6c0/NATBRA-109159_1.jpg	5	58.90	58.90	2026-02-28 12:12:11.2593-03	2026-02-27 19:57:22.037566-03
103	Sabonete em Barra Puro Vegetal Tododia Tâmara e Canela	\N	7733	Corpo e Banho	Sabonete em Barra Puro Vegetal Tododia Tâmara e Canela\nRef: 7733	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw223d908b/produto-joia/background/desktop/7733.jpg	5	34.90	34.90	2026-02-28 12:12:30.653032-03	2026-02-27 19:57:22.040565-03
105	Sabonete Líquido da Cabeça aos Pés Mamãe e Bebê	\N	92800	Corpo e Banho	Sabonete Líquido da Cabeça aos Pés Mamãe e Bebê\nRef: 92800	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw14d06f73/produto-joia/background/desktop/92800.jpg	5	52.90	52.90	2026-02-28 12:12:50.467633-03	2026-02-27 19:57:22.043573-03
107	Creme Desodorante Nutritivo para o Corpo Tododia Morango e Baunilha Dourada	\N	205936	Corpo e Banho	Creme Desodorante Nutritivo para o Corpo Tododia Morango e Baunilha Dourada\nRef: 205936	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1e9f11a4/produto-joia/background/desktop/205936.jpg	5	78.90	78.90	2026-02-28 12:13:15.006185-03	2026-02-27 19:57:22.04657-03
108	Kit Desodorante Antitranspirante Roll-on Tododia Pele Uniforme (3 unidades)	\N	218102	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Tododia Pele Uniforme (3 unidades)\nRef: 218102	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw25d36bd6/produto-joia/background/desktop/218102.jpg	5	0.00	0.00	2026-02-28 12:13:25.818263-03	2026-02-27 19:57:22.047572-03
110	Una Artisan 75 ml	\N	2458	Geral	Una Artisan 75 ml\nRef: 2458	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8e34ac15/produto-joia/background/desktop/2458.jpg	5	0.00	0.00	2026-02-28 12:13:48.553885-03	2026-02-27 19:57:22.050576-03
112	Kit Lumina Antiqueda e Crescimento (4 produtos)	\N	217192	Geral	Kit Lumina Antiqueda e Crescimento (4 produtos)\nRef: 217192	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1583ee5b/produto-joia/background/desktop/217192.jpg	5	0.00	0.00	2026-02-28 12:14:11.26921-03	2026-02-27 19:57:22.052936-03
114	Refil Creme Antissinais 60+ Dia	\N	134700	Corpo e Banho	Refil Creme Antissinais 60+ Dia\nRef: 134700	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwaf811f17/produto-joia/background/desktop/134700.jpg	5	124.00	124.00	2026-02-28 12:14:31.118935-03	2026-02-27 19:57:22.05589-03
115	Kit Natura Homem Cor.agio com Hidratante e Sabonete (3 produtos)	\N	217171	Corpo e Banho	Kit Natura Homem Cor.agio com Hidratante e Sabonete (3 produtos)\nRef: 217171	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf26dc741/produto-joia/background/desktop/217171.jpg	5	0.00	0.00	2026-02-28 12:14:45.779067-03	2026-02-27 19:57:22.05689-03
117	Body Splash Tododia Morango e Baunilha Dourada 200 ml	\N	205937	Geral	Body Splash Tododia Morango e Baunilha Dourada 200 ml\nRef: 205937	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2e381201/produto-joia/background/desktop/205937.jpg	5	93.90	93.90	2026-02-28 12:15:14.189972-03	2026-02-27 19:57:30.875992-03
118	Body Splash Tododia Ameixa e Flor de Baunilha 200 ml	\N	100679	Geral	Body Splash Tododia Ameixa e Flor de Baunilha 200 ml\nRef: 100679	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe14ebd16/produto-joia/background/desktop/100679.jpg	5	93.90	93.90	2026-02-28 12:15:27.445375-03	2026-02-27 19:57:30.883707-03
119	Lenços Umedecidos sem Fragrância Mamãe e Bebê	\N	92799	Infantil	Lenços Umedecidos sem Fragrância Mamãe e Bebê\nRef: 92799	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8f495c5e/produto-joia/background/desktop/92799.jpg	5	0.00	0.00	2026-02-28 12:15:41.95647-03	2026-02-27 19:57:30.883707-03
121	Ilía Florescer 50 ml	\N	155887	Geral	Ilía Florescer 50 ml\nRef: 155887	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd5b73fa0/NATBRA-155887_1.jpg	5	0.00	0.00	2026-02-28 12:16:08.9751-03	2026-02-27 19:57:30.891081-03
122	Sabonete em Barra Puro Vegetal Cremoso Ekos Castanha	\N	156242	Corpo e Banho	Sabonete em Barra Puro Vegetal Cremoso Ekos Castanha\nRef: 156242	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa0c0c5dc/NATBRA-156242_1.jpg	5	0.00	0.00	2026-02-28 12:16:36.40497-03	2026-02-27 19:57:30.892087-03
124	Águas Flor de Laranjeira Feminino 170 ml	\N	95638	Geral	Águas Flor de Laranjeira Feminino 170 ml\nRef: 95638	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9bbbf936/produto-joia/background/desktop/95638.jpg	5	0.00	0.00	2026-02-28 12:17:00.431502-03	2026-02-27 19:57:30.892087-03
126	Humor Próprio Feminino 75 ml	\N	86727	Geral	Humor Próprio Feminino 75 ml\nRef: 86727	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw10c5cd58/produto-joia/background/desktop/86727.jpg	5	164.90	164.90	2026-02-28 12:17:18.768097-03	2026-02-27 19:57:30.900368-03
128	Refil Shampoo Mamãe e Bebê	\N	92791	Cabelos	Refil Shampoo Mamãe e Bebê\nRef: 92791	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw665da0c5/produto-joia/background/desktop/92791.jpg	5	0.00	0.00	2026-02-28 12:17:43.871002-03	2026-02-27 19:57:30.900368-03
129	Creme Hidratante para as Mãos Ekos Açaí	\N	97269	Corpo e Banho	Creme Hidratante para as Mãos Ekos Açaí\nRef: 97269	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5e564d36/produto-joia/background/desktop/97269.jpg	5	0.00	0.00	2026-02-28 12:18:00.422572-03	2026-02-27 19:57:30.900368-03
131	Sabonete em Barra Puro Vegetal Tododia Alecrim e Sálvia	\N	72147	Corpo e Banho	Sabonete em Barra Puro Vegetal Tododia Alecrim e Sálvia\nRef: 72147	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw66b24479/produto-joia/background/desktop/72147.jpg	5	34.90	34.90	2026-02-28 12:18:32.722214-03	2026-02-27 19:57:30.90866-03
134	Kit Tododia Máscaras Reparação, Nutrição e Hidratação	\N	177694	Cabelos	Kit Tododia Máscaras Reparação, Nutrição e Hidratação\nRef: 177694	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd3efe3f8/produto-joia/background/desktop/177694.jpg	5	0.00	0.00	2026-02-28 12:18:57.466806-03	2026-02-27 19:57:30.90866-03
135	Creme Desodorante Nutritivo Para o Corpo Tododia Algodão	\N	2816	Corpo e Banho	Creme Desodorante Nutritivo Para o Corpo Tododia Algodão\nRef: 2816	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw340743f5/produto-joia/background/desktop/2816.jpg	5	78.90	78.90	2026-02-28 12:19:09.775864-03	2026-02-27 19:57:30.90866-03
136	Refil Creme Sorbet Desodorante Nutritivo para o Corpo Tododia Acerola e Hibisco	\N	117798	Corpo e Banho	Refil Creme Sorbet Desodorante Nutritivo para o Corpo Tododia Acerola e Hibisco\nRef: 117798	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dweaf1486e/produto-joia/background/desktop/117798.jpg	5	58.90	58.90	2026-02-28 12:19:49.986699-03	2026-02-27 19:57:30.916008-03
138	Polpa Desodorante Hidratante para o Corpo Ekos Andiroba	\N	163709	Corpo e Banho	Polpa Desodorante Hidratante para o Corpo Ekos Andiroba\nRef: 163709	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6f898616/produto-joia/background/desktop/163709.jpg	5	0.00	0.00	2026-02-28 12:20:15.018278-03	2026-02-27 19:57:30.917092-03
139	Kit Tododia Algodão com Hidratante, Body Splash e Sabonete em Barra (3 produtos)	\N	215255	Corpo e Banho	Kit Tododia Algodão com Hidratante, Body Splash e Sabonete em Barra (3 produtos)\nRef: 215255	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfe13ad5b/produto-joia/background/desktop/215255.jpg	5	0.00	0.00	2026-02-28 12:20:33.259918-03	2026-02-27 19:57:30.917092-03
142	Kit Lumina Nutrição e Reparação Shampoo, Condicionador e Máscara (3 produtos)	\N	217191	Cabelos	Kit Lumina Nutrição e Reparação Shampoo, Condicionador e Máscara (3 produtos)\nRef: 217191	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa7325a2f/produto-joia/background/desktop/217191.jpg	5	0.00	0.00	2026-02-28 12:26:04.840389-03	2026-02-27 19:57:38.839891-03
144	Refil Desodorante Corporal Natura Homem	\N	57412	Corpo e Banho	Refil Desodorante Corporal Natura Homem\nRef: 57412	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9b745bf6/produto-joia/background/desktop/57412.jpg	5	44.90	44.90	2026-02-28 12:26:31.429479-03	2026-02-27 19:57:38.841434-03
143	Sintonia Clássico Masculino 100 ml	\N	71766	Homem	Sintonia Clássico Masculino 100 ml\nRef: 71766	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4ebdea70/produto-joia/background/desktop/71766.jpg	5	0.00	0.00	2026-02-28 12:26:42.203813-03	2026-02-27 19:57:38.841434-03
149	Kit Desodorante Antitranspirante Roll-on Sem Perfume (3 unidades)	\N	213545	Perfumaria	Kit Desodorante Antitranspirante Roll-on Sem Perfume (3 unidades)\nRef: 213545	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw33819c7f/produto-joia/background/desktop/213545.jpg	5	0.00	0.00	2026-02-28 12:27:13.149267-03	2026-02-27 19:57:38.849144-03
146	Desodorante Antitranspirante Roll-on Tododia Sem Perfume	\N	189413	Perfumaria	Desodorante Antitranspirante Roll-on Tododia Sem Perfume\nRef: 189413	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf1343b82/produto-joia/background/desktop/189413.jpg	5	29.90	29.90	2026-02-28 12:27:55.499833-03	2026-02-27 19:57:38.849144-03
147	Essencial Supreme Masculino 100 ml	\N	95560	Homem	Essencial Supreme Masculino 100 ml\nRef: 95560	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw56ccd236/produto-joia/background/desktop/95560.jpg	5	279.90	279.90	2026-02-28 12:28:07.919203-03	2026-02-27 19:57:38.849144-03
153	Kit Sabonete em Barra Tododia Amora Vermelha e Jabuticaba e Tododia Chá de Camomila e Lavanda (2 caixas)	\N	241072	Corpo e Banho	Kit Sabonete em Barra Tododia Amora Vermelha e Jabuticaba e Tododia Chá de Camomila e Lavanda (2 caixas)\nRef: 241072	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw75e75496/Produtos/NATBRA-241072_1.jpg	5	0.00	0.00	2026-02-28 12:28:35.196041-03	2026-02-27 19:57:38.857545-03
151	Kit Mamãe e Bebê Shampoo, Condicionador, Sabonete Líquido e Hidratante (4 produtos)	\N	218199	Cabelos	Kit Mamãe e Bebê Shampoo, Condicionador, Sabonete Líquido e Hidratante (4 produtos)\nRef: 218199	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwee0e310d/produto-joia/background/desktop/218199.jpg	5	0.00	0.00	2026-02-28 12:28:52.419925-03	2026-02-27 19:57:38.857545-03
155	Shampoo 2 em 1 Naturé	\N	102406	Cabelos	Shampoo 2 em 1 Naturé\nRef: 102406	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb17b37fa/NATBRA-102406_1.jpg	5	0.00	0.00	2026-02-28 12:29:18.635869-03	2026-02-27 19:57:38.864865-03
160	Essencial Desejos Feminino 100 ml	\N	194226	Geral	Essencial Desejos Feminino 100 ml\nRef: 194226	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0ca238e7/produto-joia/background/desktop/194226.jpg	5	0.00	0.00	2026-02-28 12:29:45.255102-03	2026-02-27 19:57:38.865904-03
159	Refil Creme Sorbet Desodorante Nutritivo para o Corpo Tododia Manga Rosa e Água de Coco	\N	103382	Corpo e Banho	Refil Creme Sorbet Desodorante Nutritivo para o Corpo Tododia Manga Rosa e Água de Coco\nRef: 103382	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb2133374/produto-joia/background/desktop/103382.jpg	5	58.90	58.90	2026-02-28 12:29:58.781799-03	2026-02-27 19:57:38.865904-03
157	Ilía Laços Feminino 50 ml	\N	95054	Geral	Ilía Laços Feminino 50 ml\nRef: 95054	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw77b580be/produto-joia/background/desktop/95054.jpg	5	0.00	0.00	2026-02-28 12:30:25.14623-03	2026-02-27 19:57:38.865904-03
158	Kit Desodorante Antitranspirante Roll-on Algodão (3 unidades)	\N	213546	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Algodão (3 unidades)\nRef: 213546	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwaec6e93c/produto-joia/background/desktop/213546.jpg	5	0.00	0.00	2026-02-28 12:30:37.760257-03	2026-02-27 19:57:38.865904-03
162	Presente Natura Una Artisan (2 produtos)	\N	239793	Geral	Presente Natura Una Artisan (2 produtos)\nRef: 239793	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2a4ac155/produto-joia/background/desktop/239793.jpg	5	0.00	0.00	2026-02-28 12:31:08.121484-03	2026-02-27 19:57:38.874307-03
164	Kaiak Aero Masculino 100 ml	\N	108404	Homem	Kaiak Aero Masculino 100 ml\nRef: 108404	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6a6f1aed/produto-joia/background/desktop/108404.jpg	5	0.00	0.00	2026-02-28 12:31:27.056885-03	2026-02-27 19:57:38.874307-03
165	Desodorante Antitranspirante em Creme Erva Doce	\N	2179	Corpo e Banho	Desodorante Antitranspirante em Creme Erva Doce\nRef: 2179	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw616a1215/NATBRA-2179_1.jpg	5	30.90	30.90	2026-02-28 12:31:43.22686-03	2026-02-27 19:57:48.122986-03
167	Body Splash Tododia Macadâmia 200 ml	\N	72195	Geral	Body Splash Tododia Macadâmia 200 ml\nRef: 72195	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwae6fe2a9/produto-joia/background/desktop/72195.jpg	5	93.90	93.90	2026-02-28 12:32:08.219949-03	2026-02-27 19:57:48.135262-03
169	Kit Mamãe e Bebê Banho com Cheirinho de Amor (3 produtos)	\N	128286	Infantil	Kit Mamãe e Bebê Banho com Cheirinho de Amor (3 produtos)\nRef: 128286	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw48603224/produto-joia/background/desktop/128286.jpg	5	0.00	0.00	2026-02-28 12:32:35.937323-03	2026-02-27 19:57:48.139338-03
170	Refil Ekos Frescor Maracujá 150 ml	\N	73569	Geral	Refil Ekos Frescor Maracujá 150 ml\nRef: 73569	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw522192df/produto-joia/background/desktop/73569.jpg	5	105.90	105.90	2026-02-28 12:32:49.201344-03	2026-02-27 19:57:48.141345-03
172	Batom Multimix Cremoso Faces	\N	116204	Maquiagem	Batom Multimix Cremoso Faces\nRef: 116204	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw000194ec/produto-joia/background/desktop/PAI116187.jpg	5	0.00	0.00	2026-02-28 12:33:19.836214-03	2026-02-27 19:57:48.143349-03
174	Desodorante Antitranspirante Roll-On Natura Homem Clássico	\N	150225	Corpo e Banho	Desodorante Antitranspirante Roll-On Natura Homem Clássico\nRef: 150225	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdf085dcc/produto-joia/background/desktop/150225.jpg	5	29.90	29.90	2026-02-28 12:33:50.390853-03	2026-02-27 19:57:48.147523-03
175	Refil Desodorante Corporal Natura Homem Elo	\N	173494	Corpo e Banho	Refil Desodorante Corporal Natura Homem Elo\nRef: 173494	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd32a8137/produto-joia/background/desktop/173494.jpg	5	0.00	0.00	2026-02-28 12:34:05.938242-03	2026-02-27 19:57:48.149532-03
176	Natura Homem Verum 100 ml	\N	112092	Homem	Natura Homem Verum 100 ml\nRef: 112092	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw014a4541/produto-joia/background/desktop/112092.jpg	5	0.00	0.00	2026-02-28 12:34:14.926613-03	2026-02-27 19:57:48.149532-03
178	Body Splash Tododia Acerola e Hibisco 200 ml	\N	117800	Geral	Body Splash Tododia Acerola e Hibisco 200 ml\nRef: 117800	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb4dc041a/produto-joia/background/desktop/117800.jpg	5	93.90	93.90	2026-02-28 12:34:53.145702-03	2026-02-27 19:57:48.149532-03
183	Refil Creme de Pentear para Definição e Hidratação de Cabelos Cacheados	\N	148403	Cabelos	Refil Creme de Pentear para Definição e Hidratação de Cabelos Cacheados\nRef: 148403	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb3d971af/produto-joia/background/desktop/148403.jpg	5	44.90	44.90	2026-02-28 12:35:07.135577-03	2026-02-27 19:57:48.155796-03
180	Supermáscara Tint para Cílios Faces	\N	9832	Cabelos	Supermáscara Tint para Cílios Faces\nRef: 9832	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf41bd5d9/produto-joia/background/desktop/9832.jpg	5	0.00	0.00	2026-02-28 12:35:30.697646-03	2026-02-27 19:57:48.155796-03
181	Kit Refil Shampoo Mamãe e Bebê (3 unidades)	\N	213211	Cabelos	Kit Refil Shampoo Mamãe e Bebê (3 unidades)\nRef: 213211	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1a5aa154/produto-joia/background/desktop/213211.jpg	5	0.00	0.00	2026-02-28 12:35:42.833608-03	2026-02-27 19:57:48.155796-03
184	Refil Condicionador Lumina Restaurador para Restauração e Liso Prolongado	\N	167285	Cabelos	Refil Condicionador Lumina Restaurador para Restauração e Liso Prolongado\nRef: 167285	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw46e56bf7/produto-joia/background/desktop/167285.jpg	5	41.90	41.90	2026-02-28 12:36:07.11827-03	2026-02-27 19:57:48.164298-03
185	Refil Creme Sorbet Desodorante Nutritivo para o Corpo Tododia Amora e Flor de Pêssego	\N	181339	Corpo e Banho	Refil Creme Sorbet Desodorante Nutritivo para o Corpo Tododia Amora e Flor de Pêssego\nRef: 181339	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9da63528/produto-joia/background/desktop/181339.jpg	5	58.90	58.90	2026-02-28 12:36:21.428025-03	2026-02-27 19:57:48.166306-03
187	Refil Creme Desodorante Nutritivo Corporal Tododia Macadâmia	\N	2815	Corpo e Banho	Refil Creme Desodorante Nutritivo Corporal Tododia Macadâmia\nRef: 2815	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfcf77251/produto-joia/background/desktop/2815.jpg	5	58.90	58.90	2026-02-28 12:36:51.914472-03	2026-02-27 19:57:48.170312-03
189	Condicionador Mamãe e Bebê	\N	92793	Cabelos	Condicionador Mamãe e Bebê\nRef: 92793	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5fcad04c/produto-joia/background/desktop/92793.jpg	5	0.00	0.00	2026-02-28 12:37:20.023038-03	2026-02-27 19:58:01.667096-03
191	Una 75 ml	\N	2446	Geral	Una 75 ml\nRef: 2446	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw98306a83/produto-joia/background/desktop/2446.jpg	5	0.00	0.00	2026-02-28 13:01:33.120152-03	2026-02-27 19:58:01.672951-03
192	Kit Creme Desodorante Nutritivo Tododia Morango e Baunilha Dourada com Refil	\N	230065	Corpo e Banho	Kit Creme Desodorante Nutritivo Tododia Morango e Baunilha Dourada com Refil\nRef: 230065	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfd2b80b6/produto-joia/background/desktop/230065.jpg	5	0.00	0.00	2026-02-28 13:01:44.597487-03	2026-02-27 19:58:01.675951-03
194	Creme Desodorante Nutritivo para o Corpo Tododia Tâmara e Canela	\N	2786	Corpo e Banho	Creme Desodorante Nutritivo para o Corpo Tododia Tâmara e Canela\nRef: 2786	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd7016196/produto-joia/background/desktop/2786.jpg	5	0.00	0.00	2026-02-28 13:02:11.272283-03	2026-02-27 19:58:01.679557-03
196	Kit Creme Hidratante para as Mãos Ekos Castanha (3 unidades)	\N	241046	Corpo e Banho	Kit Creme Hidratante para as Mãos Ekos Castanha (3 unidades)\nRef: 241046	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8268ebe1/produto-joia/background/desktop/241046.jpg	5	0.00	0.00	2026-02-28 13:02:42.383266-03	2026-02-27 19:58:01.684558-03
197	Primer Blur Una	\N	59313	Geral	Primer Blur Una\nRef: 59313	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf3c5754e/produto-joia/background/desktop/59313.jpg	5	0.00	0.00	2026-02-28 13:02:51.984557-03	2026-02-27 19:58:01.686557-03
198	Kit Tododia Morango e Baunilha Dourada com Hidratante, Body Splash e Sabonete	\N	258119	Corpo e Banho	Kit Tododia Morango e Baunilha Dourada com Hidratante, Body Splash e Sabonete\nRef: 258119	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw714bfa46/produto-joia/background/desktop/258119.jpg	5	0.00	0.00	2026-02-28 13:03:07.249244-03	2026-02-27 19:58:01.687885-03
200	Óleo com Guias de Massagem no Bebê Mamãe e Bebê	\N	75234	Corpo e Banho	Óleo com Guias de Massagem no Bebê Mamãe e Bebê\nRef: 75234	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw51006132/produto-joia/background/desktop/75234.jpg	5	0.00	0.00	2026-02-28 13:03:53.901308-03	2026-02-27 19:58:01.691883-03
202	Conjunto Mamãe e Bebê com frasqueira (4 produtos)	\N	187034	Infantil	Conjunto Mamãe e Bebê com frasqueira (4 produtos)\nRef: 187034	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf733b3f7/produto-joia/background/desktop/187034.jpg	5	0.00	0.00	2026-02-28 13:04:24.906556-03	2026-02-27 19:58:01.693885-03
204	Hidratante Relaxante Mamãe e Bebê	\N	92806	Corpo e Banho	Hidratante Relaxante Mamãe e Bebê\nRef: 92806	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6deb22a0/produto-joia/background/desktop/92806.jpg	5	0.00	0.00	2026-02-28 13:04:46.836851-03	2026-02-27 19:58:01.697081-03
205	Lenços Umedecidos com Fragrância 16 folhas	\N	92819	Geral	Lenços Umedecidos com Fragrância 16 folhas\nRef: 92819	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw91d2a8cb/NATBRA-92819_1.jpg	5	13.10	13.10	2026-02-28 13:05:00.183502-03	2026-02-27 19:58:01.699082-03
207	Kit Desodorante Corporal Natura Kaiak Feminino com Refil (2 produtos)	\N	213226	Corpo e Banho	Kit Desodorante Corporal Natura Kaiak Feminino com Refil (2 produtos)\nRef: 213226	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe76a25e9/produto-joia/background/desktop/213226.jpg	5	0.00	0.00	2026-02-28 13:05:23.019285-03	2026-02-27 19:58:01.702079-03
209	Água de Colônia Relaxante Mamãe e Bebê 100 ml	\N	92788	Perfumaria	Água de Colônia Relaxante Mamãe e Bebê 100 ml\nRef: 92788	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwebbd1e86/produto-joia/background/desktop/92788.jpg	5	106.90	106.90	2026-02-28 13:05:49.068122-03	2026-02-27 19:58:01.704473-03
210	Essencial Único Feminino 90 ml	\N	103349	Geral	Essencial Único Feminino 90 ml\nRef: 103349	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw72146a4a/produto-joia/background/desktop/103349.jpg	5	0.00	0.00	2026-02-28 13:05:59.771695-03	2026-02-27 19:58:01.706472-03
212	Sabonete em Barra Puro Vegetal Tododia Acerola e Hibisco (5 unidades)	\N	117749	Corpo e Banho	Sabonete em Barra Puro Vegetal Tododia Acerola e Hibisco (5 unidades)\nRef: 117749	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbd3d430d/produto-joia/background/desktop/117749.jpg	5	0.00	0.00	2026-02-28 13:06:32.961428-03	2026-02-27 19:58:09.47806-03
214	Polpa Esfoliante para o Corpo Ekos Castanha	\N	69825	Corpo e Banho	Polpa Esfoliante para o Corpo Ekos Castanha\nRef: 69825	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw98816c9f/produto-joia/background/desktop/69825.jpg	5	95.90	95.90	2026-02-28 13:06:55.173038-03	2026-02-27 19:58:09.47806-03
215	Corretivo Cobertura Extrema 24h Una 8ml	\N	122122	Maquiagem	Corretivo Cobertura Extrema 24h Una 8ml\nRef: 122122	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe04ee797/produto-joia/background/desktop/PAI122122.jpg	5	0.00	0.00	2026-02-28 13:07:12.194755-03	2026-02-27 19:58:09.485724-03
217	Máscara Concentrada Crono Capilar Tododia Repara	\N	154875	Cabelos	Máscara Concentrada Crono Capilar Tododia Repara\nRef: 154875	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw061fe0d6/produto-joia/background/desktop/154875.jpg	5	49.90	49.90	2026-02-28 13:07:42.834793-03	2026-02-27 19:58:09.485724-03
219	Kit Ilía Laços e Clássico (2 unidades)	\N	258121	Geral	Kit Ilía Laços e Clássico (2 unidades)\nRef: 258121	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw766f61a5/produto-joia/background/desktop/258121.jpg	5	0.00	0.00	2026-02-28 13:08:07.140306-03	2026-02-27 19:58:09.485724-03
220	Creme Hidratante para as Mãos Ekos Maracujá	\N	80967	Corpo e Banho	Creme Hidratante para as Mãos Ekos Maracujá\nRef: 80967	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2d06849e/produto-joia/background/desktop/80967.jpg	5	59.90	59.90	2026-02-28 13:08:16.475631-03	2026-02-27 19:58:09.493773-03
222	Desodorante Corporal Kaiak Masculino	\N	56747	Corpo e Banho	Desodorante Corporal Kaiak Masculino\nRef: 56747	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5c3817a7/produto-joia/background/desktop/56747.jpg	5	56.90	56.90	2026-02-28 13:08:42.367833-03	2026-02-27 19:58:09.496681-03
224	Kit Sabonetes Corpo e Barba e Deo Parfum Natura Homem Cor.agio	\N	219724	Perfumaria	Kit Sabonetes Corpo e Barba e Deo Parfum Natura Homem Cor.agio\nRef: 219724	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9c8135c1/produto-joia/background/desktop/219724.jpg	5	0.00	0.00	2026-02-28 13:09:12.839021-03	2026-02-27 19:58:09.498685-03
226	Polpa Hidratante para Mãos Ekos Castanha	\N	160267	Corpo e Banho	Polpa Hidratante para Mãos Ekos Castanha\nRef: 160267	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4251820b/produto-joia/background/desktop/160267.jpg	5	0.00	0.00	2026-02-28 13:09:45.602568-03	2026-02-27 19:58:09.50267-03
227	Gelatina de Definição e Brilho para Cabelos Cacheados e Crespos	\N	148404	Cabelos	Gelatina de Definição e Brilho para Cabelos Cacheados e Crespos\nRef: 148404	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf59e2cc1/NATBRA-148404_1.jpg	5	0.00	0.00	2026-02-28 13:09:54.781645-03	2026-02-27 19:58:09.50267-03
229	Refil Shampoo Hidratante Maçã Verde e Aloe Vera	\N	154868	Cabelos	Refil Shampoo Hidratante Maçã Verde e Aloe Vera\nRef: 154868	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfd39f891/produto-joia/background/desktop/154868.jpg	5	0.00	0.00	2026-02-28 13:10:22.177473-03	2026-02-27 19:58:09.50267-03
231	Desodorante Corporal Biografia Feminino	\N	88453	Corpo e Banho	Desodorante Corporal Biografia Feminino\nRef: 88453	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd9c18e66/NATBRA-88453_1.jpg	5	0.00	0.00	2026-02-28 13:10:46.850458-03	2026-02-27 19:58:09.51076-03
232	Refil Desodorante Corporal Biografia Masculino	\N	88431	Corpo e Banho	Refil Desodorante Corporal Biografia Masculino\nRef: 88431	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw63dd5e70/NATBRA-88431_1.jpg	5	44.90	44.90	2026-02-28 13:10:59.057555-03	2026-02-27 19:58:09.51118-03
233	Sabonete em Barra Puro Vegetal Tododia Cereja Negra e Praliné	\N	174494	Corpo e Banho	Sabonete em Barra Puro Vegetal Tododia Cereja Negra e Praliné\nRef: 174494	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw202cc0d5/produto-joia/background/desktop/174494.jpg	5	34.90	34.90	2026-02-28 13:11:14.420548-03	2026-02-27 19:58:16.676989-03
234	Protetor Térmico para Finalização	\N	148459	Geral	Protetor Térmico para Finalização\nRef: 148459	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwaa654117/produto-joia/background/desktop/148459.jpg	5	0.00	0.00	2026-02-28 13:11:27.261592-03	2026-02-27 19:58:16.676989-03
237	Refil Shampoo Nutritivo Tododia Pêssego e Amêndoa	\N	154867	Cabelos	Refil Shampoo Nutritivo Tododia Pêssego e Amêndoa\nRef: 154867	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3ad8b344/produto-joia/background/desktop/154867.jpg	5	27.90	27.90	2026-02-28 13:11:39.535901-03	2026-02-27 19:58:16.685272-03
236	Kit Tododia Detox para Cabelos Mistos e Oleosos (2 produtos)	\N	256328	Cabelos	Kit Tododia Detox para Cabelos Mistos e Oleosos (2 produtos)\nRef: 256328	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw406c32a7/produto-joia/background/desktop/256328.jpg	5	0.00	0.00	2026-02-28 13:12:05.268643-03	2026-02-27 19:58:16.685272-03
239	Ilía Clássico e Plena (2 unidades)	\N	258114	Geral	Ilía Clássico e Plena (2 unidades)\nRef: 258114	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw76b45430/produto-joia/background/desktop/258114.jpg	5	0.00	0.00	2026-02-28 13:12:37.676972-03	2026-02-27 19:58:16.692541-03
1894	Chronos Multiprotetor antissinais	\N	\N	Rosto	FPS 50	\N	5	0.00	\N	\N	2026-03-02 21:18:13.243983-03
240	Kit Desodorante Antitranspirante Roll-on Kaiak Aventura Masculino (3 unidades)	\N	216459	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Kaiak Aventura Masculino (3 unidades)\nRef: 216459	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw27826db4/produto-joia/background/desktop/216459.jpg	5	0.00	0.00	2026-03-05 08:29:51.266033-03	2026-02-27 19:58:16.693295-03
243	Refil Shampoo Cremoso para Definição e Hidratação de Cabelos Cacheados	\N	148162	Cabelos	Refil Shampoo Cremoso para Definição e Hidratação de Cabelos Cacheados\nRef: 148162	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1cd7c348/produto-joia/background/desktop/148162.jpg	5	38.90	38.90	2026-03-05 08:30:16.021337-03	2026-02-27 19:58:16.695301-03
241	Refil Shampoo de Tratamento Antissinais Regenerador Capilar Lumina	\N	174194	Cabelos	Refil Shampoo de Tratamento Antissinais Regenerador Capilar Lumina\nRef: 174194	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw202f7cd4/produto-joia/background/desktop/174194.jpg	5	41.90	41.90	2026-03-05 08:30:50.898584-03	2026-02-27 19:58:16.695301-03
245	Kit Shampoo, Condicionador e Spray Naturé	\N	232515	Cabelos	Kit Shampoo, Condicionador e Spray Naturé\nRef: 232515	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw00110433/produto-joia/background/desktop/232515.jpg	5	0.00	0.00	2026-03-05 08:31:03.83749-03	2026-02-27 19:58:16.701632-03
247	Refil Gel Creme Antissinais 45+ Noite	\N	134589	Corpo e Banho	Refil Gel Creme Antissinais 45+ Noite\nRef: 134589	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfa198cdf/produto-joia/background/desktop/134589.jpg	5	124.00	124.00	2026-03-05 08:31:33.972945-03	2026-02-27 19:58:16.701632-03
249	Creme Merengue para o Corpo Tododia Morango e Baunilha Dourada	\N	205941	Corpo e Banho	Creme Merengue para o Corpo Tododia Morango e Baunilha Dourada\nRef: 205941	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5dde7781/produto-joia/background/desktop/205941.jpg	5	0.00	0.00	2026-03-05 08:31:58.526255-03	2026-02-27 19:58:16.701632-03
250	Shampoo Estimulante Antiqueda e Crescimento	\N	147421	Cabelos	Shampoo Estimulante Antiqueda e Crescimento\nRef: 147421	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw81a62769/produto-joia/background/desktop/147421.jpg	5	0.00	0.00	2026-03-05 08:32:12.399856-03	2026-02-27 19:58:16.709977-03
252	Sr. N 100 ml	\N	30410	Geral	Sr. N 100 ml\nRef: 30410	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwae6a048f/produto-joia/background/desktop/30410.jpg	5	0.00	0.00	2026-03-05 08:32:35.011629-03	2026-02-27 19:58:16.709977-03
254	Protetor Multiclareador FPS 70 Chronos Derma	\N	69049	Geral	Protetor Multiclareador FPS 70 Chronos Derma\nRef: 69049	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0ab66a44/produto-joia/background/desktop/69049.jpg	5	119.00	119.00	2026-03-05 08:33:04.362929-03	2026-02-27 19:58:16.709977-03
255	Refil Condicionador para Definição e Hidratação de Cabelos Cacheados	\N	148413	Cabelos	Refil Condicionador para Definição e Hidratação de Cabelos Cacheados\nRef: 148413	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwaf6b338c/produto-joia/background/desktop/148413.jpg	5	41.90	41.90	2026-03-05 08:33:19.070598-03	2026-02-27 19:58:16.718422-03
257	Máscara Fortalecedora Ekos Patauá	\N	112777	Cabelos	Máscara Fortalecedora Ekos Patauá\nRef: 112777	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9ebdd961/produto-joia/background/desktop/112777.jpg	5	0.00	0.00	2026-03-05 08:33:56.678475-03	2026-02-27 19:58:25.142371-03
258	Kit Antiqueda e Crescimento Lumina com Shampoo e Condicionador	\N	194390	Cabelos	Kit Antiqueda e Crescimento Lumina com Shampoo e Condicionador\nRef: 194390	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2054353f/NATBRA-194390_1.jpg	5	0.00	0.00	2026-03-05 08:34:08.675783-03	2026-02-27 19:58:25.142371-03
260	Desodorante Antitranspirante Roll-on Tododia Macadâmia	\N	189402	Corpo e Banho	Desodorante Antitranspirante Roll-on Tododia Macadâmia\nRef: 189402	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0135f589/produto-joia/background/desktop/189402.jpg	5	29.90	29.90	2026-03-05 08:34:35.527389-03	2026-02-27 19:58:25.150808-03
261	Desodorante Antitranspirante Roll-On Natura Homem Sagaz	\N	155842	Corpo e Banho	Desodorante Antitranspirante Roll-On Natura Homem Sagaz\nRef: 155842	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1113325c/produto-joia/background/desktop/155842.jpg	5	29.90	29.90	2026-03-05 08:34:50.771218-03	2026-02-27 19:58:25.150808-03
263	Ekos Frescor Maracujá Natureza dos Sonhos 150 ml	\N	132672	Geral	Ekos Frescor Maracujá Natureza dos Sonhos 150 ml\nRef: 132672	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc11208e8/produto-joia/background/desktop/132672.jpg	5	137.90	137.90	2026-03-05 08:35:13.848172-03	2026-02-27 19:58:25.150808-03
265	Kit Lumina Antissinais Regenerador Capilar (3 produtos)	\N	224952	Geral	Kit Lumina Antissinais Regenerador Capilar (3 produtos)\nRef: 224952	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw648329f3/produto-joia/background/desktop/224952.jpg	5	0.00	0.00	2026-03-05 08:35:39.797021-03	2026-02-27 19:58:25.158765-03
267	Kit Nutritivo Tododia Pêssego e Amêndoa (3 produtos)	\N	213230	Geral	Kit Nutritivo Tododia Pêssego e Amêndoa (3 produtos)\nRef: 213230	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe3289a41/produto-joia/background/desktop/213230.jpg	5	0.00	0.00	2026-03-05 08:36:10.142262-03	2026-02-27 19:58:25.158765-03
268	Eau de Parfum Natura 740 Sândalo Breu Branco 50 ml	\N	151030	Perfumaria	Eau de Parfum Natura 740 Sândalo Breu Branco 50 ml\nRef: 151030	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa33ee5d1/produto-joia/background/desktop/151030.jpg	5	395.00	395.00	2026-03-05 08:36:19.43829-03	2026-02-27 19:58:25.158765-03
270	Óleo Desodorante Corporal Essencial Atrai Feminino	\N	170517	Corpo e Banho	Óleo Desodorante Corporal Essencial Atrai Feminino\nRef: 170517	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc0f56ea2/produto-joia/background/desktop/170517_.jpg	5	0.00	0.00	2026-03-05 08:36:45.224346-03	2026-02-27 19:58:25.167114-03
272	Refil Essencial Exclusivo Masculino 100 ml	\N	7979	Homem	Refil Essencial Exclusivo Masculino 100 ml\nRef: 7979	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdd38c8c0/produto-joia/background/desktop/7979.jpg	5	213.90	213.90	2026-03-05 08:37:08.627832-03	2026-02-27 19:58:25.167114-03
274	Sintonia Impacto Masculino 100 ml	\N	71773	Homem	Sintonia Impacto Masculino 100 ml\nRef: 71773	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw97b623d8/produto-joia/background/desktop/71773.jpg	5	219.90	219.90	2026-03-05 08:37:30.453653-03	2026-02-27 19:58:25.167114-03
275	Refil Essencial Único Feminino 90 ml	\N	107121	Geral	Refil Essencial Único Feminino 90 ml\nRef: 107121	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwed42d81d/produto-joia/background/desktop/107121.jpg	5	228.90	228.90	2026-03-05 08:37:48.111107-03	2026-02-27 19:58:25.175347-03
277	Sabonete Mamãe e Bebê com Saboneteira	\N	92797	Corpo e Banho	Sabonete Mamãe e Bebê com Saboneteira\nRef: 92797	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1ebcaa03/produto-joia/background/desktop/92797.jpg	5	0.00	0.00	2026-03-05 08:38:19.367095-03	2026-02-27 19:58:25.175347-03
278	Kit Ilía Laços e Plena (2 unidades)	\N	258115	Geral	Kit Ilía Laços e Plena (2 unidades)\nRef: 258115	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbc9dde9c/produto-joia/background/desktop/258115.jpg	5	0.00	0.00	2026-03-05 08:38:33.681407-03	2026-02-27 19:58:25.175347-03
281	Kit Tododia Morango e Baunilha Dourada	\N	258123	Geral	Kit Tododia Morango e Baunilha Dourada\nRef: 258123	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb63a220e/produto-joia/background/desktop/258123.jpg	5	0.00	0.00	2026-03-05 08:38:52.663237-03	2026-02-27 19:58:33.781811-03
279	Kit Mamãe e Bebê Shampoo, Condicionador, Sabonete em Barra e Hidratante (4 produtos)	\N	218198	Cabelos	Kit Mamãe e Bebê Shampoo, Condicionador, Sabonete em Barra e Hidratante (4 produtos)\nRef: 218198	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw71fc4c6f/produto-joia/background/desktop/218198.jpg	5	0.00	0.00	2026-03-05 08:39:02.32212-03	2026-02-27 19:58:33.774466-03
283	Creme Nutritivo para as Mãos Tododia Algodão	\N	72178	Corpo e Banho	Creme Nutritivo para as Mãos Tododia Algodão\nRef: 72178	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw682659af/NATBRA-72178_1.jpg	5	39.90	39.90	2026-03-05 08:39:31.371704-03	2026-02-27 19:58:33.78328-03
284	Kit Creme de Pentear Nutrição e Reparação Profunda Lumina com Refil (2 produtos)	\N	185537	Corpo e Banho	Kit Creme de Pentear Nutrição e Reparação Profunda Lumina com Refil (2 produtos)\nRef: 185537	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3714e4c5/produto-joia/background/desktop/185537.jpg	5	0.00	0.00	2026-03-05 08:39:43.892877-03	2026-02-27 19:58:33.78328-03
286	Corretivo Cobertura Extrema 24h Una 8ml	\N	122117	Maquiagem	Corretivo Cobertura Extrema 24h Una 8ml\nRef: 122117	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe04ee797/produto-joia/background/desktop/PAI122122.jpg	5	0.00	0.00	2026-03-05 08:40:08.893341-03	2026-02-27 19:58:33.79088-03
287	Sabonete em Barra Puro Vegetal Cremoso e Esfoliante Ekos	\N	134574	Corpo e Banho	Sabonete em Barra Puro Vegetal Cremoso e Esfoliante Ekos\nRef: 134574	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcfc27fa8/produto-joia/background/desktop/134574.jpg	5	0.00	0.00	2026-03-05 08:40:21.494702-03	2026-02-27 19:58:33.79088-03
289	Refil Shampoo Reparador Tododia Flor de Cereja e Abacate	\N	154865	Cabelos	Refil Shampoo Reparador Tododia Flor de Cereja e Abacate\nRef: 154865	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw66b26c49/produto-joia/background/desktop/154865.jpg	5	27.90	27.90	2026-03-05 08:40:46.082453-03	2026-02-27 19:58:33.796732-03
291	Kit Desodorante Antitranspirante em Creme Tododia Macadâmia (2 unidades)	\N	221672	Corpo e Banho	Kit Desodorante Antitranspirante em Creme Tododia Macadâmia (2 unidades)\nRef: 221672	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw391989a0/produto-joia/background/desktop/221672.jpg	5	0.00	0.00	2026-03-05 08:41:26.87695-03	2026-02-27 19:58:33.801073-03
292	Shampoo Equilibrante Antioleosidade	\N	147449	Cabelos	Shampoo Equilibrante Antioleosidade\nRef: 147449	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw625059a6/produto-joia/background/desktop/147449.jpg	5	0.00	0.00	2026-03-05 08:41:41.248164-03	2026-02-27 19:58:33.801073-03
293	Creme Antissinais 60+ Noite	\N	135036	Corpo e Banho	Creme Antissinais 60+ Noite\nRef: 135036	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5b136ad5/produto-joia/background/desktop/135036.jpg	5	0.00	0.00	2026-03-05 08:41:50.797286-03	2026-02-27 19:58:33.801073-03
295	Shampoo Nutritivo Tododia Pêssego e Amêndoa 300 ml	\N	154869	Cabelos	Shampoo Nutritivo Tododia Pêssego e Amêndoa 300 ml\nRef: 154869	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7803d42b/produto-joia/background/desktop/154869.jpg	5	0.00	0.00	2026-03-05 08:42:14.555879-03	2026-02-27 19:58:33.807572-03
296	Desodorante Antitranspirante Roll-on Kaiak Masculino	\N	189390	Corpo e Banho	Desodorante Antitranspirante Roll-on Kaiak Masculino\nRef: 189390	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdea45c94/produto-joia/background/desktop/189390.jpg	5	29.90	29.90	2026-03-05 08:42:30.175724-03	2026-02-27 19:58:33.807572-03
298	Gelatina Cachos e Crespos Tododia Amora e Óleo de Coco	\N	173590	Corpo e Banho	Gelatina Cachos e Crespos Tododia Amora e Óleo de Coco\nRef: 173590	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd9dec2b3/produto-joia/background/desktop/173590.jpg	5	0.00	0.00	2026-03-05 08:42:51.349777-03	2026-02-27 19:58:33.807572-03
300	Ekos Ryo Floresta 75 ml	\N	193490	Geral	Ekos Ryo Floresta 75 ml\nRef: 193490	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw706481a7/produto-joia/background/desktop/193490.jpg	5	0.00	0.00	2026-03-05 08:43:16.516858-03	2026-02-27 19:58:33.815903-03
301	Conjunto Mamãe e Bebê com bolsa e trocador (7 produtos)	\N	187033	Infantil	Conjunto Mamãe e Bebê com bolsa e trocador (7 produtos)\nRef: 187033	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw268b3d91/produto-joia/background/desktop/187033.jpg	5	489.90	489.90	2026-03-05 08:43:30.3684-03	2026-02-27 19:58:49.088307-03
303	Shampoo Cabelo e Corpo Kaiak Masculino	\N	108876	Cabelos	Shampoo Cabelo e Corpo Kaiak Masculino\nRef: 108876	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2b170820/NATBRA-108876_1.jpg	5	0.00	0.00	2026-03-05 08:43:59.156518-03	2026-02-27 19:58:49.097137-03
304	Sabonete em Barra Massageador Tododia Todanoite	\N	121965	Corpo e Banho	Sabonete em Barra Massageador Tododia Todanoite\nRef: 121965	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa958d35e/produto-joia/background/desktop/121965.jpg	5	0.00	0.00	2026-03-05 08:44:12.507063-03	2026-02-27 19:58:49.097137-03
306	Spray de Aminoácidos Lumina Pré-Secagem para Restauração e Liso Prolongado	\N	167288	Geral	Spray de Aminoácidos Lumina Pré-Secagem para Restauração e Liso Prolongado\nRef: 167288	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf237a441/produto-joia/background/desktop/167288.jpg	5	79.90	79.90	2026-03-05 08:45:04.78244-03	2026-02-27 19:58:49.097137-03
308	Desodorante Antitranspirante em Creme Tododia Macadâmia	\N	1925	Corpo e Banho	Desodorante Antitranspirante em Creme Tododia Macadâmia\nRef: 1925	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb7e741ad/produto-joia/background/desktop/1925.jpg	5	30.90	30.90	2026-03-05 08:45:34.07137-03	2026-02-27 19:58:49.104786-03
309	Refil Óleo Desodorante Corporal Sève Amêndoas Doces Intensa	\N	39015	Corpo e Banho	Refil Óleo Desodorante Corporal Sève Amêndoas Doces Intensa\nRef: 39015	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf4d27d33/produto-joia/background/desktop/39015.jpg	5	99.90	99.90	2026-03-05 08:45:48.100271-03	2026-02-27 19:58:49.104786-03
311	Eau de Parfum Natura 679 Ambrette Copaíba 50 ml	\N	151024	Perfumaria	Eau de Parfum Natura 679 Ambrette Copaíba 50 ml\nRef: 151024	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwef8616a0/produto-joia/background/desktop/151024.jpg	5	395.00	395.00	2026-03-05 08:46:10.807146-03	2026-02-27 19:58:49.104786-03
313	Refil Condicionador Nutritivo Tododia Pêssego e Amêndoa	\N	154859	Cabelos	Refil Condicionador Nutritivo Tododia Pêssego e Amêndoa\nRef: 154859	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2ffde38f/produto-joia/background/desktop/154859.jpg	5	28.90	28.90	2026-03-05 08:46:40.345031-03	2026-02-27 19:58:49.113371-03
314	Refil Shampoo para Nutrição e Reparação Profunda	\N	147412	Cabelos	Refil Shampoo para Nutrição e Reparação Profunda\nRef: 147412	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw59a7bb6b/produto-joia/background/desktop/147412.jpg	5	38.90	38.90	2026-03-05 08:46:50.661259-03	2026-02-27 19:58:49.113371-03
316	Refil Óleo Desodorante Corporal Sève Amêndoas e\nOrquídea Negra	\N	199914	Corpo e Banho	Refil Óleo Desodorante Corporal Sève Amêndoas e\nOrquídea Negra\nRef: 199914	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw87cd4db8/Produtos/NATBRA-199914_1.jpg	5	0.00	0.00	2026-03-05 08:47:14.78549-03	2026-02-27 19:58:49.113371-03
317	Tododia Limão Siciliano e Flor de Gardênia Body Splash Feminino 200 ml	\N	162095	Geral	Tododia Limão Siciliano e Flor de Gardênia Body Splash Feminino 200 ml\nRef: 162095	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd6ada526/produto-joia/background/desktop/162095.jpg	5	0.00	0.00	2026-03-05 08:47:25.587255-03	2026-02-27 19:58:49.113371-03
322	Refil Sabonete Líquido em Gel Tododia Amora Vermelha e Jabuticaba	\N	5894	Corpo e Banho	Refil Sabonete Líquido em Gel Tododia Amora Vermelha e Jabuticaba\nRef: 5894	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcbb25172/produto-joia/background/desktop/5894.jpg	5	38.40	38.40	2026-03-05 08:47:47.172089-03	2026-02-27 19:58:49.122097-03
319	Kit Desodorante Antitranspirante Roll-on Kaiak Masculino (3 unidades)	\N	216458	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Kaiak Masculino (3 unidades)\nRef: 216458	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf97ffbf3/produto-joia/background/desktop/216458.jpg	5	0.00	0.00	2026-03-05 08:48:02.09119-03	2026-02-27 19:58:49.122097-03
321	Desodorante Antitranspirante Roll-on Kaiak Aventura Masculino	\N	189392	Corpo e Banho	Desodorante Antitranspirante Roll-on Kaiak Aventura Masculino\nRef: 189392	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw482caeaf/produto-joia/background/desktop/189392.jpg	5	29.90	29.90	2026-03-05 08:48:33.814247-03	2026-02-27 19:58:49.122097-03
335	Shampoo para Nutrição e Reparação Profunda	\N	147411	Cabelos	Shampoo para Nutrição e Reparação Profunda\nRef: 147411	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdf82b8e3/produto-joia/background/desktop/147411.jpg	5	52.90	52.90	2026-03-05 09:30:32.539538-03	2026-02-27 19:58:57.770244-03
332	Pó Solto Translúcido Luminoso Una	\N	165814	Maquiagem	Pó Solto Translúcido Luminoso Una\nRef: 165814	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6ec0b153/produto-joia/background/desktop/165814.jpg	5	119.90	119.90	2026-03-05 09:30:42.677589-03	2026-02-27 19:58:57.770244-03
334	Desodorante Hidratante Corporal Perfumado Una Artisan	\N	140595	Corpo e Banho	Desodorante Hidratante Corporal Perfumado Una Artisan\nRef: 140595	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcc2baa24/produto-joia/background/desktop/140595.jpg	5	134.90	134.90	2026-03-05 09:31:28.4923-03	2026-02-27 19:58:57.770244-03
336	Kit Refis Shampoo e Condicionador Lumina Hidratação e Proteção Antipoluição (2 produtos)	\N	208770	Cabelos	Kit Refis Shampoo e Condicionador Lumina Hidratação e Proteção Antipoluição (2 produtos)\nRef: 208770	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw92866d74/produto-joia/background/desktop/208770.jpg	5	0.00	0.00	2026-03-05 09:31:42.488485-03	2026-02-27 19:58:57.778565-03
341	Refil Desodorante Corporal Kriska Drama Feminino 100 ml	\N	155287	Corpo e Banho	Refil Desodorante Corporal Kriska Drama Feminino 100 ml\nRef: 155287	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw738197ca/produto-joia/background/desktop/155287.jpg	5	0.00	0.00	2026-03-05 09:32:04.723723-03	2026-02-27 19:58:57.778565-03
338	Triplo Esfoliante Peeling Antissinais Chronos Derma	\N	135057	Geral	Triplo Esfoliante Peeling Antissinais Chronos Derma\nRef: 135057	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw64b943ac/produto-joia/background/desktop/135057.jpg	5	82.00	82.00	2026-03-05 09:32:33.774533-03	2026-02-27 19:58:57.778565-03
343	Body Splash Tododia Jambo Rosa e Flor de Caju 200 ml	\N	196313	Geral	Body Splash Tododia Jambo Rosa e Flor de Caju 200 ml\nRef: 196313	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe210156f/produto-joia/background/desktop/196313.jpg	5	93.90	93.90	2026-03-05 09:33:05.049274-03	2026-02-27 19:58:57.786936-03
342	Sabonete em Barra Cremoso Puro Vegetal Ekos Castanha (4 unidades)	\N	124398	Corpo e Banho	Sabonete em Barra Cremoso Puro Vegetal Ekos Castanha (4 unidades)\nRef: 124398	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7f4e9f97/produto-joia/background/desktop/124398.jpg	5	0.00	0.00	2026-03-05 09:33:21.559614-03	2026-02-27 19:58:57.786936-03
345	Caixa de Sabonetes em Barra 2 em 1 Corpo e Barba Natura Homem	\N	151023	Corpo e Banho	Caixa de Sabonetes em Barra 2 em 1 Corpo e Barba Natura Homem\nRef: 151023	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9b0a42b5/produto-joia/background/desktop/151023.jpg	5	37.90	37.90	2026-03-05 09:33:46.716368-03	2026-02-27 19:58:57.786936-03
347	Refil Sabonete Líquido Cremoso Corporal Banho nas Nuvens Tododia Todanoite	\N	159710	Corpo e Banho	Refil Sabonete Líquido Cremoso Corporal Banho nas Nuvens Tododia Todanoite\nRef: 159710	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw089fc21d/produto-joia/background/desktop/159710.jpg	5	38.40	38.40	2026-03-05 09:34:10.337003-03	2026-02-27 19:58:57.795237-03
349	Refil Shampoo Reestruturante para Reconstrução de Danos Extremos	\N	148177	Cabelos	Refil Shampoo Reestruturante para Reconstrução de Danos Extremos\nRef: 148177	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0ff9adf7/produto-joia/background/desktop/148177.jpg	5	38.90	38.90	2026-03-05 09:34:32.926251-03	2026-02-27 19:59:04.627286-03
361	Kit Ilía Plena (2 unidades)	\N	258118	Geral	Kit Ilía Plena (2 unidades)\nRef: 258118	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw29bd41d5/produto-joia/background/desktop/258118.jpg	5	0.00	0.00	2026-03-05 10:32:10.163317-03	2026-02-27 19:59:04.657331-03
363	Multimáscara Tint para Cílios à Prova D’Água Faces	\N	9833	Cabelos	Multimáscara Tint para Cílios à Prova D’Água Faces\nRef: 9833	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw995fe030/produto-joia/background/desktop/9833.jpg	5	55.90	55.90	2026-03-05 10:32:25.774938-03	2026-02-27 19:59:04.660323-03
365	Spray Multi Sol, Mar e Piscina Tododia Manga Rosa e Água de Coco	\N	192102	Geral	Spray Multi Sol, Mar e Piscina Tododia Manga Rosa e Água de Coco\nRef: 192102	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwac09c579/produto-joia/background/desktop/192102.jpg	5	45.90	45.90	2026-03-05 10:32:58.244586-03	2026-02-27 19:59:04.660323-03
366	Kit Luna Classico com Hidratante e Desodorante Roll-on (3 produtos)	\N	217162	Corpo e Banho	Kit Luna Classico com Hidratante e Desodorante Roll-on (3 produtos)\nRef: 217162	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw30246cba/produto-joia/background/desktop/217162.jpg	5	0.00	0.00	2026-03-05 10:33:30.880161-03	2026-02-27 19:59:04.669052-03
367	Refil Ekos Sabonete Líquido Esfoliante Maracujá	\N	70392	Corpo e Banho	Refil Ekos Sabonete Líquido Esfoliante Maracujá\nRef: 70392	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5e057b88/NATBRA-70392_1.jpg	5	40.60	40.60	2026-03-05 10:33:48.53752-03	2026-02-27 19:59:04.669052-03
369	Corretivo Cobertura Extrema 24h Una 8ml	\N	122114	Maquiagem	Corretivo Cobertura Extrema 24h Una 8ml\nRef: 122114	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe04ee797/produto-joia/background/desktop/PAI122122.jpg	5	0.00	0.00	2026-03-05 10:34:16.299836-03	2026-02-27 19:59:04.676391-03
371	Kit Creme Desodorante Nutritivo Para o Corpo Tododia Algodão (2 unidades)	\N	193845	Corpo e Banho	Kit Creme Desodorante Nutritivo Para o Corpo Tododia Algodão (2 unidades)\nRef: 193845	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwae849c76/produto-joia/background/desktop/193845.jpg	5	0.00	0.00	2026-03-05 10:34:42.878475-03	2026-02-27 19:59:11.759731-03
372	Refil Máscara Lumina Restauradora para Restauração e Liso Prolongado	\N	167295	Cabelos	Refil Máscara Lumina Restauradora para Restauração e Liso Prolongado\nRef: 167295	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwed8303c0/produto-joia/background/desktop/167295.jpg	5	59.90	59.90	2026-03-05 10:35:00.121497-03	2026-02-27 19:59:11.763767-03
374	Kit Sabonete Líquido Corporal Ekos Andiroba com Refil	\N	206678	Corpo e Banho	Kit Sabonete Líquido Corporal Ekos Andiroba com Refil\nRef: 206678	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7e9baeff/produto-joia/background/desktop/206678.jpg	5	0.00	0.00	2026-03-05 10:35:40.198972-03	2026-02-27 19:59:11.767651-03
376	Refil Condicionador Ekos Murumuru	\N	112762	Cabelos	Refil Condicionador Ekos Murumuru\nRef: 112762	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw68c3e258/produto-joia/background/desktop/112762.jpg	5	0.00	0.00	2026-03-05 10:36:11.471121-03	2026-02-27 19:59:11.771061-03
377	Presente Natura Essencial Masculino (2 produtos)	\N	239727	Homem	Presente Natura Essencial Masculino (2 produtos)\nRef: 239727	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa440f7ca/produto-joia/background/desktop/239727.jpg	5	0.00	0.00	2026-03-05 10:36:28.066599-03	2026-02-27 19:59:11.773061-03
379	Kit Naturé Refis Cabelos Cacheados e Crespos (3 produtos)	\N	185557	Cabelos	Kit Naturé Refis Cabelos Cacheados e Crespos (3 produtos)\nRef: 185557	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4e392b6d/produto-joia/background/desktop/185557.jpg	5	0.00	0.00	2026-03-05 10:36:56.593204-03	2026-02-27 19:59:11.775965-03
381	Desodorante Antitranspirante em Creme Tododia Noz Pecã e Cacau	\N	2185	Corpo e Banho	Desodorante Antitranspirante em Creme Tododia Noz Pecã e Cacau\nRef: 2185	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw391b9f37/produto-joia/background/desktop/2185.jpg	5	30.90	30.90	2026-03-05 10:37:29.584761-03	2026-02-27 19:59:11.778187-03
382	Kit Tododia Pêssego e Amêndoa (3 produtos)	\N	208128	Geral	Kit Tododia Pêssego e Amêndoa (3 produtos)\nRef: 208128	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7a5c0071/produto-joia/background/desktop/208128.jpg	5	0.00	0.00	2026-03-05 10:37:43.65132-03	2026-02-27 19:59:11.780187-03
385	Eau de Parfum Natura 875 Vetiver Capitiú 50 ml	\N	151025	Perfumaria	Eau de Parfum Natura 875 Vetiver Capitiú 50 ml\nRef: 151025	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6246290a/produto-joia/background/desktop/151025.jpg	5	395.00	395.00	2026-03-05 10:38:43.005917-03	2026-02-27 19:59:11.784293-03
387	Refil Creme Noturno Para o Corpo Tododia Todanoite	\N	121961	Corpo e Banho	Refil Creme Noturno Para o Corpo Tododia Todanoite\nRef: 121961	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw74480ed8/produto-joia/background/desktop/121961.jpg	5	0.00	0.00	2026-03-05 10:39:09.376364-03	2026-02-27 19:59:11.787493-03
388	Kit Sabonete Líquido Tododia Noz Pecã e Cacau com Refil	\N	258125	Corpo e Banho	Kit Sabonete Líquido Tododia Noz Pecã e Cacau com Refil\nRef: 258125	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7e0fed8e/produto-joia/background/desktop/258125.jpg	5	0.00	0.00	2026-03-05 10:39:21.553455-03	2026-02-27 19:59:11.789493-03
390	Refil Desodorante Corporal Humor Liberta	\N	124228	Corpo e Banho	Refil Desodorante Corporal Humor Liberta\nRef: 124228	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4a840236/produto-joia/background/desktop/124228.jpg	5	0.00	0.00	2026-03-05 10:40:10.629494-03	2026-02-27 19:59:11.792492-03
391	Creme Desodorante Nutritivo Para o Corpo Tododia Capim Limão e Hortelã	\N	109156	Corpo e Banho	Creme Desodorante Nutritivo Para o Corpo Tododia Capim Limão e Hortelã\nRef: 109156	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8477a8e3/produto-joia/background/desktop/109156.jpg	5	78.90	78.90	2026-03-05 10:40:26.478333-03	2026-02-27 19:59:11.794069-03
394	Sérum de Prevenção Antissinais Regenerador Capilar Lumina	\N	176050	Geral	Sérum de Prevenção Antissinais Regenerador Capilar Lumina\nRef: 176050	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1926434c/produto-joia/background/desktop/176050.jpg	5	94.90	94.90	2026-03-05 10:40:51.142622-03	2026-02-27 19:59:34.930962-03
393	Óleo Desodorante Hidratante Corporal Sève Amêndoas e Orquídea Negra	\N	140683	Corpo e Banho	Óleo Desodorante Hidratante Corporal Sève Amêndoas e Orquídea Negra\nRef: 140683	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdbca3d5a/produto-joia/background/desktop/140683.jpg	5	116.90	116.90	2026-03-05 10:41:16.116465-03	2026-02-27 19:59:34.924142-03
397	Kit Tododia Cronograma Capilar (3 produtos)	\N	204410	Geral	Kit Tododia Cronograma Capilar (3 produtos)\nRef: 204410	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0e5fd7ca/NATBRA-204410_1.jpg	5	0.00	0.00	2026-03-05 10:41:51.78824-03	2026-02-27 19:59:34.932301-03
398	Refil Condicionador Polinutrição para Nutrição e Reparação Profunda	\N	147410	Cabelos	Refil Condicionador Polinutrição para Nutrição e Reparação Profunda\nRef: 147410	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4cf407c6/produto-joia/background/desktop/147410.jpg	5	41.90	41.90	2026-03-05 10:42:09.679811-03	2026-02-27 19:59:34.93927-03
401	Batom Matte Faces 3,5g	\N	87469	Maquiagem	Batom Matte Faces 3,5g\nRef: 87469	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw038bc66f/produto-joia/background/desktop/PAI77992.jpg	5	23.90	23.90	2026-03-05 10:42:34.63288-03	2026-02-27 19:59:34.940277-03
400	Desodorante Hidratante Corporal Sève Amêndoas e Frésia	\N	172091	Corpo e Banho	Desodorante Hidratante Corporal Sève Amêndoas e Frésia\nRef: 172091	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf69a4e61/produto-joia/background/desktop/172091.jpg	5	75.90	75.90	2026-03-05 10:42:46.593972-03	2026-02-27 19:59:34.940277-03
407	Refil Máscara Antissinais Regenerador Capilar Lumina	\N	174193	Cabelos	Refil Máscara Antissinais Regenerador Capilar Lumina\nRef: 174193	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw79e2fe9f/produto-joia/background/desktop/174193.jpg	5	59.90	59.90	2026-03-05 10:43:13.202489-03	2026-02-27 19:59:34.948447-03
403	Natura Homem Madeiras Desodorante Colônia 100 ml	\N	102040	Perfumaria	Natura Homem Madeiras Desodorante Colônia 100 ml\nRef: 102040	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7f9cf328/produto-joia/background/desktop/102040.jpg	5	0.00	0.00	2026-03-05 10:43:24.651665-03	2026-02-27 19:59:34.948447-03
404	Máscara Regeneradora para Reconstrução de Danos Extremos	\N	148412	Cabelos	Máscara Regeneradora para Reconstrução de Danos Extremos\nRef: 148412	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7f9dbe00/produto-joia/background/desktop/148412.jpg	5	79.90	79.90	2026-03-05 10:43:35.898505-03	2026-02-27 19:59:34.948447-03
405	Refil Máscara Recuperadora para Definição e Hidratação de Cabelos Cacheados	\N	148406	Cabelos	Refil Máscara Recuperadora para Definição e Hidratação de Cabelos Cacheados\nRef: 148406	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw29d8a40e/produto-joia/background/desktop/148406.jpg	5	59.90	59.90	2026-03-05 10:44:06.176885-03	2026-02-27 19:59:34.948447-03
408	Refil Polpa Desodorante Hidratante para o Corpo Ekos Andiroba	\N	162093	Corpo e Banho	Refil Polpa Desodorante Hidratante para o Corpo Ekos Andiroba\nRef: 162093	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9c4bfe36/produto-joia/background/desktop/162093.jpg	5	69.90	69.90	2026-03-05 10:44:22.669051-03	2026-02-27 19:59:34.956862-03
409	Desodorante Corporal Erva Doce	\N	123156	Corpo e Banho	Desodorante Corporal Erva Doce\nRef: 123156	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc23f1de3/produto-joia/background/desktop/123156.jpg	5	0.00	0.00	2026-03-05 10:44:40.205455-03	2026-02-27 19:59:34.956862-03
411	Creme Nuvem Relaxante Para o Corpo Tododia Todanoite	\N	121958	Corpo e Banho	Creme Nuvem Relaxante Para o Corpo Tododia Todanoite\nRef: 121958	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5b2c7ab6/produto-joia/background/desktop/121958.jpg	5	0.00	0.00	2026-03-05 10:45:03.795375-03	2026-02-27 19:59:34.956862-03
412	Shampoo Reestruturante para Reconstrução de Danos Extremos	\N	148170	Cabelos	Shampoo Reestruturante para Reconstrução de Danos Extremos\nRef: 148170	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2ad0dfec/produto-joia/background/desktop/148170.jpg	5	52.90	52.90	2026-03-05 10:45:17.160111-03	2026-02-27 19:59:34.956862-03
413	Refil Desodorante Corporal Kaiak Feminino	\N	56763	Corpo e Banho	Refil Desodorante Corporal Kaiak Feminino\nRef: 56763	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1080a7fa/Produtos/NATBRA-56763_1.jpg	5	44.90	44.90	2026-03-05 10:45:43.152616-03	2026-02-27 19:59:34.965257-03
416	Kit Óleo Desodorante Corporal Sève Amêndoas e\nOrquídea Negra com Refil	\N	220212	Corpo e Banho	Kit Óleo Desodorante Corporal Sève Amêndoas e\nOrquídea Negra com Refil\nRef: 220212	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1fc31cc1/Produtos/NATBRA-220212_1.jpg	5	0.00	0.00	2026-03-05 10:46:08.398186-03	2026-02-27 19:59:43.184773-03
417	Shampoo Antirresíduos para Detox Capilar	\N	147404	Cabelos	Shampoo Antirresíduos para Detox Capilar\nRef: 147404	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0a5cfca2/produto-joia/background/desktop/147404.jpg	5	0.00	0.00	2026-03-05 10:46:22.38895-03	2026-02-27 19:59:43.188577-03
419	Batom Multimix Cremoso Faces	\N	116197	Maquiagem	Batom Multimix Cremoso Faces\nRef: 116197	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw000194ec/produto-joia/background/desktop/PAI116187.jpg	5	23.90	23.90	2026-03-05 10:46:41.76207-03	2026-02-27 19:59:43.194579-03
420	Sabonete Líquido em Gel Tododia Amora Vermelha e Jabuticaba	\N	5870	Corpo e Banho	Sabonete Líquido em Gel Tododia Amora Vermelha e Jabuticaba\nRef: 5870	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwae1610ca/NATBRA-5870_1.jpg	5	50.90	50.90	2026-03-05 10:46:58.578691-03	2026-02-27 19:59:43.196831-03
422	Creme Desodorante Nutritivo para o Corpo Tododia Noz Pecã e Cacau	\N	2820	Corpo e Banho	Creme Desodorante Nutritivo para o Corpo Tododia Noz Pecã e Cacau\nRef: 2820	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw16b5e9a9/produto-joia/background/desktop/2820.jpg	5	0.00	0.00	2026-03-05 10:47:28.411939-03	2026-02-27 19:59:43.201888-03
423	Kit Desodorante Spray Corporal Sr. N (3 produtos)	\N	216078	Corpo e Banho	Kit Desodorante Spray Corporal Sr. N (3 produtos)\nRef: 216078	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfa5fc0bc/produto-joia/background/desktop/216078.jpg	5	0.00	0.00	2026-03-05 10:47:46.300219-03	2026-02-27 19:59:43.204696-03
425	Kriska Jeans 100 ml	\N	103977	Geral	Kriska Jeans 100 ml\nRef: 103977	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw88213d38/produto-joia/background/desktop/103977.jpg	5	169.90	169.90	2026-03-05 10:48:14.924795-03	2026-02-27 19:59:43.209041-03
427	Sabonete em Barra Puro Vegetal Essencial Masculino 110 g	\N	131410	Corpo e Banho	Sabonete em Barra Puro Vegetal Essencial Masculino 110 g\nRef: 131410	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9b4275fb/produto-joia/background/desktop/131410.jpg	5	0.00	0.00	2026-03-05 10:48:46.939627-03	2026-02-27 19:59:43.213392-03
428	Spray Reativador Cachos e Crespos Tododia Amora e Óleo de Coco	\N	173583	Corpo e Banho	Spray Reativador Cachos e Crespos Tododia Amora e Óleo de Coco\nRef: 173583	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa3dc7368/produto-joia/background/desktop/173583.jpg	5	0.00	0.00	2026-03-05 10:49:00.108158-03	2026-02-27 19:59:43.21548-03
430	Óleo Corporal Sève Amêndoas Doces	\N	19081	Corpo e Banho	Óleo Corporal Sève Amêndoas Doces\nRef: 19081	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4b9c63af/produto-joia/background/desktop/19081.jpg	5	116.90	116.90	2026-03-05 10:49:35.296073-03	2026-02-27 19:59:43.218481-03
432	Refil Creme Energizante Corporal 2 em 1 Tododia Energia	\N	152290	Corpo e Banho	Refil Creme Energizante Corporal 2 em 1 Tododia Energia\nRef: 152290	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0b78b6e6/produto-joia/background/desktop/152290.jpg	5	0.00	0.00	2026-03-05 10:49:59.413561-03	2026-02-27 19:59:43.221769-03
433	Desodorante Hidratante Corporal Perfumado Essencial Feminino	\N	16870	Corpo e Banho	Desodorante Hidratante Corporal Perfumado Essencial Feminino\nRef: 16870	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbf237e51/produto-joia/background/desktop/16870.jpg	5	0.00	0.00	2026-03-05 10:50:13.68436-03	2026-02-27 19:59:43.223823-03
435	Refil Óleo Trifásico Desodorante Corporal Ekos Pitanga	\N	97432	Corpo e Banho	Refil Óleo Trifásico Desodorante Corporal Ekos Pitanga\nRef: 97432	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4675b3ee/NATBRA-97432_1.jpg	5	79.90	79.90	2026-03-05 10:50:38.28036-03	2026-02-27 19:59:43.226823-03
436	Refil Ekos Frescor Açaí 150 ml	\N	73570	Geral	Refil Ekos Frescor Açaí 150 ml\nRef: 73570	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdf94c6a4/produto-joia/background/desktop/73570.jpg	5	105.90	105.90	2026-03-05 10:50:57.244317-03	2026-02-27 19:59:43.227822-03
438	Frasqueira Térmica Crer Para Ver	\N	218960	Geral	Frasqueira Térmica Crer Para Ver\nRef: 218960	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1404d7db/produto-joia/background/desktop/218960.jpg	5	0.00	0.00	2026-03-05 10:51:35.19643-03	2026-02-27 19:59:51.954605-03
439	Refil Condicionador Fortificante Antiqueda e Crescimento	\N	147451	Cabelos	Refil Condicionador Fortificante Antiqueda e Crescimento\nRef: 147451	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwedd3fef4/produto-joia/background/desktop/147451.jpg	5	0.00	0.00	2026-03-05 10:51:46.240243-03	2026-02-27 19:59:51.954605-03
440	Kit Sol, Mar e Piscina Tododia Manga Rosa e Água de Coco (3 produtos)	\N	241082	Geral	Kit Sol, Mar e Piscina Tododia Manga Rosa e Água de Coco (3 produtos)\nRef: 241082	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw997f14c9/NATBRA-241082_1.jpg	5	0.00	0.00	2026-03-05 10:52:10.006345-03	2026-02-27 19:59:51.963058-03
442	Creme Desodorante Hidratante para o Corpo Ekos Tukumã	\N	203390	Corpo e Banho	Creme Desodorante Hidratante para o Corpo Ekos Tukumã\nRef: 203390	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7c52fb19/produto-joia/background/desktop/203390.jpg	5	89.90	89.90	2026-03-05 10:52:23.831068-03	2026-02-27 19:59:51.963058-03
444	Kit Shampoo e Condicionador Lumina Antioleosidade (2 produtos)	\N	208141	Cabelos	Kit Shampoo e Condicionador Lumina Antioleosidade (2 produtos)\nRef: 208141	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb0ec3eda/produto-joia/background/desktop/208141.jpg	5	0.00	0.00	2026-03-05 10:53:01.384746-03	2026-02-27 19:59:51.971133-03
445	Lenços Umedecidos com Fragrância Mamãe e Bebê	\N	92798	Infantil	Lenços Umedecidos com Fragrância Mamãe e Bebê\nRef: 92798	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwad0e883f/NATBRA-92798_1.jpg	5	36.90	36.90	2026-03-05 10:53:21.037756-03	2026-02-27 19:59:51.971133-03
447	Refil Sabonete Líquido Para Mãos Maracujá Ekos	\N	70388	Corpo e Banho	Refil Sabonete Líquido Para Mãos Maracujá Ekos\nRef: 70388	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8d083627/produto-joia/background/desktop/70388.jpg	5	51.90	51.90	2026-03-05 10:53:46.321619-03	2026-02-27 19:59:51.971133-03
449	Refil Creme para Pentear Cachos Tododia Amora e Óleo de Coco	\N	173586	Corpo e Banho	Refil Creme para Pentear Cachos Tododia Amora e Óleo de Coco\nRef: 173586	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb666d803/produto-joia/background/desktop/173586.jpg	5	0.00	0.00	2026-03-05 10:54:14.085688-03	2026-02-27 19:59:51.978441-03
458	Refil Shampoo Cabelos Cacheados e Crespos Naturé	\N	102401	Cabelos	Refil Shampoo Cabelos Cacheados e Crespos Naturé\nRef: 102401	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3f8934c4/produto-joia/background/desktop/102401.jpg	5	29.90	29.90	2026-03-05 11:36:16.16467-03	2026-02-27 19:59:51.995773-03
459	Refil Shampoo Lumina Matizador para Matização e Restauração	\N	148157	Cabelos	Refil Shampoo Lumina Matizador para Matização e Restauração\nRef: 148157	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw09693adb/produto-joia/background/desktop/148157.jpg	5	0.00	0.00	2026-03-05 11:36:33.381417-03	2026-02-27 19:59:51.995773-03
462	Bruma Facial Energizante Tododia Flor de Gengibre e Tangerina	\N	152289	Geral	Bruma Facial Energizante Tododia Flor de Gengibre e Tangerina\nRef: 152289	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe8a10a34/produto-joia/background/desktop/152289.jpg	5	0.00	0.00	2026-03-05 11:37:02.404419-03	2026-02-27 19:59:59.561481-03
464	Spray de Ambientes Tododia Todanoite	\N	121966	Geral	Spray de Ambientes Tododia Todanoite\nRef: 121966	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf54b5e37/produto-joia/background/desktop/121966.jpg	5	0.00	0.00	2026-03-05 11:37:19.314116-03	2026-02-27 19:59:59.561481-03
465	Kit Shampoo, Máscara e Spray Lumina para Reparação e Blindagem	\N	239216	Cabelos	Kit Shampoo, Máscara e Spray Lumina para Reparação e Blindagem\nRef: 239216	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9531e480/produto-joia/background/desktop/239216.jpg	5	0.00	0.00	2026-03-05 11:37:55.401561-03	2026-02-27 19:59:59.568846-03
468	Refil Super Sérum Redutor de Rugas Chronos Derma	\N	169234	Geral	Refil Super Sérum Redutor de Rugas Chronos Derma\nRef: 169234	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw781426bb/produto-joia/background/desktop/169234.jpg	5	167.00	167.00	2026-03-05 11:38:15.058303-03	2026-02-27 19:59:59.569869-03
466	Shampoo Cremoso para Definição e Hidratação de Cabelos Cacheados	\N	148161	Cabelos	Shampoo Cremoso para Definição e Hidratação de Cabelos Cacheados\nRef: 148161	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0af954b6/NATBRA-148161_1.jpg	5	52.90	52.90	2026-03-05 11:38:30.526409-03	2026-02-27 19:59:59.569869-03
469	Creme Desodorante Hidratante para o Corpo Ekos Tukumã	\N	189554	Corpo e Banho	Creme Desodorante Hidratante para o Corpo Ekos Tukumã\nRef: 189554	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc89d31ba/produto-joia/background/desktop/189554.jpg	5	39.80	39.80	2026-03-05 11:38:53.706512-03	2026-02-27 19:59:59.569869-03
471	Gel Creme Antissinais 30+ Dia	\N	134592	Corpo e Banho	Gel Creme Antissinais 30+ Dia\nRef: 134592	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa1a88b61/produto-joia/background/desktop/134592.jpg	5	0.00	0.00	2026-03-05 11:39:18.224482-03	2026-02-27 19:59:59.577998-03
472	Creme Desodorante Nutritivo para o Corpo Tododia Macadâmia	\N	23081	Corpo e Banho	Creme Desodorante Nutritivo para o Corpo Tododia Macadâmia\nRef: 23081	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0419e764/produto-joia/background/desktop/23081.jpg	5	0.00	0.00	2026-03-05 11:39:33.282891-03	2026-02-27 19:59:59.577998-03
485	Gel Creme Antissinais 30+ Noite	\N	134593	Corpo e Banho	Gel Creme Antissinais 30+ Noite\nRef: 134593	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb6c2222d/produto-joia/background/desktop/134593.jpg	5	0.00	0.00	2026-03-05 12:37:11.3557-03	2026-02-27 20:00:24.030548-03
486	Refil Óleo Desodorante Corporal Sève Pimenta Rosa	\N	25543	Corpo e Banho	Refil Óleo Desodorante Corporal Sève Pimenta Rosa\nRef: 25543	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb23849cb/produto-joia/background/desktop/25543.jpg	5	99.90	99.90	2026-03-05 12:37:26.003271-03	2026-02-27 20:00:24.034968-03
488	Sabonete Líquido Cremoso para o corpo Banho nas Nuvens Tododia Todanoite	\N	159711	Corpo e Banho	Sabonete Líquido Cremoso para o corpo Banho nas Nuvens Tododia Todanoite\nRef: 159711	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw280c2327/NATBRA-159711_1.jpg	5	50.90	50.90	2026-03-05 12:37:58.312852-03	2026-02-27 20:00:24.042205-03
489	Kit Refis Shampoo e Condicionador Mamãe e Bebê (3 produtos)	\N	213213	Cabelos	Kit Refis Shampoo e Condicionador Mamãe e Bebê (3 produtos)\nRef: 213213	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd4b1ee23/produto-joia/background/desktop/213213.jpg	5	0.00	0.00	2026-03-05 12:38:08.96585-03	2026-02-27 20:00:24.044703-03
491	Óleo Leve Reparador para Nutrição e Reparação Profunda	\N	147439	Corpo e Banho	Óleo Leve Reparador para Nutrição e Reparação Profunda\nRef: 147439	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw29089c39/produto-joia/background/desktop/147439.jpg	5	79.90	79.90	2026-03-05 12:38:36.419401-03	2026-02-27 20:00:24.048505-03
492	Desodorante Antitranspirante Roll-On Natura Homem Essence	\N	150229	Corpo e Banho	Desodorante Antitranspirante Roll-On Natura Homem Essence\nRef: 150229	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw97a0c7c6/produto-joia/background/desktop/150229.jpg	5	29.90	29.90	2026-03-05 12:38:45.717182-03	2026-02-27 20:00:24.050789-03
494	Refil Hidratante Acqua Renovador Chronos Derma	\N	91819	Corpo e Banho	Refil Hidratante Acqua Renovador Chronos Derma\nRef: 91819	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdb8ce6db/produto-joia/background/desktop/91819.jpg	5	144.00	144.00	2026-03-05 12:39:12.552089-03	2026-02-27 20:00:24.053789-03
496	Kit Natura Homem (2 unidades)	\N	256326	Homem	Kit Natura Homem (2 unidades)\nRef: 256326	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw04a14557/produto-joia/background/desktop/256326.jpg	5	0.00	0.00	2026-03-05 12:39:39.004985-03	2026-02-27 20:00:24.056792-03
498	Refil Condicionador Suave Antioleosidade	\N	147445	Cabelos	Refil Condicionador Suave Antioleosidade\nRef: 147445	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd5004db0/produto-joia/background/desktop/147445.jpg	5	0.00	0.00	2026-03-05 12:40:07.64391-03	2026-02-27 20:00:24.059212-03
499	Sabonete Líquido Íntimo Tododia Delicado Frescor	\N	83638	Corpo e Banho	Sabonete Líquido Íntimo Tododia Delicado Frescor\nRef: 83638	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4ed3d716/produto-joia/background/desktop/83638.jpg	5	50.90	50.90	2026-03-05 12:40:22.305633-03	2026-02-27 20:00:24.061215-03
501	Refil Desodorante Corporal Biografia Feminino	\N	88455	Corpo e Banho	Refil Desodorante Corporal Biografia Feminino\nRef: 88455	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3965d8c2/NATBRA-88455_1.jpg	5	44.90	44.90	2026-03-05 12:40:50.459333-03	2026-02-27 20:00:24.064214-03
502	Biografia Encontros Feminino 100 ml	\N	110410	Geral	Biografia Encontros Feminino 100 ml\nRef: 110410	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw521a88c7/produto-joia/background/desktop/110410.jpg	5	209.90	209.90	2026-03-05 12:41:06.952267-03	2026-02-27 20:00:24.065163-03
504	Kit Tododia Todanoite com Sabonete, Hidratante e Body Splash (3 produtos)	\N	215261	Corpo e Banho	Kit Tododia Todanoite com Sabonete, Hidratante e Body Splash (3 produtos)\nRef: 215261	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw15df2e21/produto-joia/background/desktop/215261.jpg	5	0.00	0.00	2026-03-05 12:41:37.438077-03	2026-02-27 20:00:24.068467-03
507	Sabonete em Barra Puro Vegetal Tododia Noz Pecã e Cacau	\N	2832	Corpo e Banho	Sabonete em Barra Puro Vegetal Tododia Noz Pecã e Cacau\nRef: 2832	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3dff1896/produto-joia/background/desktop/2832.jpg	5	0.00	0.00	2026-03-05 12:42:30.513197-03	2026-02-27 20:00:24.072466-03
508	Colônia Naturé Esconde Esconde 100 ml	\N	102409	Perfumaria	Colônia Naturé Esconde Esconde 100 ml\nRef: 102409	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw007d335e/produto-joia/background/desktop/102409.jpg	5	0.00	0.00	2026-03-05 12:42:51.444245-03	2026-02-27 20:00:39.855514-03
510	Shampoo Revitalizante Naturé	\N	166872	Cabelos	Shampoo Revitalizante Naturé\nRef: 166872	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw91297454/produto-joia/background/desktop/166872.jpg	5	0.00	0.00	2026-03-05 12:43:13.605884-03	2026-02-27 20:00:39.863955-03
511	Sabonete em Barra Puro Vegetal Esfoliante Ekos Tukumã	\N	192147	Corpo e Banho	Sabonete em Barra Puro Vegetal Esfoliante Ekos Tukumã\nRef: 192147	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0c4649b6/produto-joia/background/desktop/192147.jpg	5	12.40	12.40	2026-03-05 12:43:40.340307-03	2026-02-27 20:00:39.863955-03
512	Kit Lenços Umedecidos Sem Fragrância Mamãe e Bebê (3 unidades)	\N	221680	Infantil	Kit Lenços Umedecidos Sem Fragrância Mamãe e Bebê (3 unidades)\nRef: 221680	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw48177207/produto-joia/background/desktop/221680.jpg	5	0.00	0.00	2026-03-05 12:43:57.336094-03	2026-02-27 20:00:39.863955-03
516	Condicionador Cabelos Cacheados e Crespos Naturé	\N	102402	Cabelos	Condicionador Cabelos Cacheados e Crespos Naturé\nRef: 102402	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6cc202f3/NATBRA-102402_1.jpg	5	43.90	43.90	2026-03-05 12:44:33.005749-03	2026-02-27 20:00:39.872339-03
515	Batom Matte Intransferível Una 8ml	\N	54382	Maquiagem	Batom Matte Intransferível Una 8ml\nRef: 54382	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw999dd2d0/produto-joia/background/desktop/167329.jpg	5	65.90	65.90	2026-03-05 12:44:45.390808-03	2026-02-27 20:00:39.872339-03
518	Condicionador Hidratante Tododia Maçã Verde e Aloe Vera 280 ml	\N	154873	Cabelos	Condicionador Hidratante Tododia Maçã Verde e Aloe Vera 280 ml\nRef: 154873	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw82517be3/produto-joia/background/desktop/154873.jpg	5	0.00	0.00	2026-03-05 12:45:13.988905-03	2026-02-27 20:00:39.876895-03
523	Refil Condicionador Cachos e Crespos Tododia Amora e Óleo de Coco	\N	173589	Cabelos	Refil Condicionador Cachos e Crespos Tododia Amora e Óleo de Coco\nRef: 173589	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1972948e/produto-joia/background/desktop/173589.jpg	5	0.00	0.00	2026-03-05 12:45:42.722415-03	2026-02-27 20:00:39.881296-03
520	Creme Desodorante Corporal Perfumado Sève Amêndoas Doces	\N	189568	Corpo e Banho	Creme Desodorante Corporal Perfumado Sève Amêndoas Doces\nRef: 189568	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc8f03676/produto-joia/background/desktop/189568.jpg	5	112.90	112.90	2026-03-05 12:45:55.351345-03	2026-02-27 20:00:39.881296-03
521	Kit Força e Reparação Molecular Lumina (3 produtos)	\N	216469	Geral	Kit Força e Reparação Molecular Lumina (3 produtos)\nRef: 216469	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe7bbb14c/produto-joia/background/desktop/216469.jpg	5	0.00	0.00	2026-03-05 12:46:07.960714-03	2026-02-27 20:00:39.881296-03
524	Refil Óleo Desodorante Corporal Sève Rosas e Amêndoas	\N	38856	Corpo e Banho	Refil Óleo Desodorante Corporal Sève Rosas e Amêndoas\nRef: 38856	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa52c4e62/produto-joia/background/desktop/38856.jpg	5	0.00	0.00	2026-03-05 12:46:36.76792-03	2026-02-27 20:00:39.888026-03
528	Refil Super Sérum para Olhos Redutor de Rugas e Flacidez Chronos Derma	\N	169238	Geral	Refil Super Sérum para Olhos Redutor de Rugas e Flacidez Chronos Derma\nRef: 169238	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf5d9d514/produto-joia/background/desktop/169238.jpg	5	136.00	136.00	2026-03-05 12:46:48.782827-03	2026-02-27 20:00:39.889386-03
526	Kit Natura Homem Essence e Desodorante Roll-on (2 produtos)	\N	217175	Corpo e Banho	Kit Natura Homem Essence e Desodorante Roll-on (2 produtos)\nRef: 217175	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw89bb5822/produto-joia/background/desktop/217175.jpg	5	0.00	0.00	2026-03-05 12:47:39.010184-03	2026-02-27 20:00:39.889386-03
529	Creme Noturno Para o Corpo Tododia Todanoite	\N	121970	Corpo e Banho	Creme Noturno Para o Corpo Tododia Todanoite\nRef: 121970	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe621842d/produto-joia/background/desktop/121970.jpg	5	0.00	0.00	2026-03-05 12:48:10.85006-03	2026-02-27 20:00:39.896185-03
530	Sérum Chronos Derma Intensivo para Bolsas e Olheiras	\N	127754	Geral	Sérum Chronos Derma Intensivo para Bolsas e Olheiras\nRef: 127754	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwabf737f1/produto-joia/background/desktop/127754.jpg	5	185.00	185.00	2026-03-05 12:48:22.98067-03	2026-02-27 20:00:48.571482-03
534	Kit Sabonete em Barra Tododia Flor de Gengibre e Tangerina e Tododia Tâmara e Canela (2 caixas)	\N	241063	Corpo e Banho	Kit Sabonete em Barra Tododia Flor de Gengibre e Tangerina e Tododia Tâmara e Canela (2 caixas)\nRef: 241063	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7a78a756/Produtos/NATBRA-241063_1.jpg	5	0.00	0.00	2026-03-05 12:48:47.353343-03	2026-02-27 20:00:48.579289-03
532	Refil Creme Desodorante Hidratante para o Corpo Ekos Maracujá	\N	203386	Corpo e Banho	Refil Creme Desodorante Hidratante para o Corpo Ekos Maracujá\nRef: 203386	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe17b241b/produto-joia/background/desktop/203386.jpg	5	69.90	69.90	2026-03-05 12:48:59.02301-03	2026-02-27 20:00:48.579289-03
535	Kit Natura Homem Essence (2 unidades)	\N	232516	Homem	Kit Natura Homem Essence (2 unidades)\nRef: 232516	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4bb42674/produto-joia/background/desktop/232516.jpg	5	0.00	0.00	2026-03-05 12:49:40.469402-03	2026-02-27 20:00:48.587465-03
538	Desodorante Corporal Natura Homem	\N	110686	Corpo e Banho	Desodorante Corporal Natura Homem\nRef: 110686	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc24f7f2d/produto-joia/background/desktop/110686.jpg	5	56.90	56.90	2026-03-05 12:50:20.249151-03	2026-02-27 20:00:48.587781-03
537	Balm Labial Tododia Manga Rosa e Água de Coco	\N	180471	Geral	Balm Labial Tododia Manga Rosa e Água de Coco\nRef: 180471	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2ea1e31c/produto-joia/background/desktop/180471.jpg	5	35.90	35.90	2026-03-05 12:50:30.970901-03	2026-02-27 20:00:48.587781-03
541	Batom Color Tint FPS 8 Faces	\N	10162	Maquiagem	Batom Color Tint FPS 8 Faces\nRef: 10162	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe2486bf9/produto-joia/background/desktop/10162.png	5	0.00	0.00	2026-03-05 12:51:29.536722-03	2026-02-27 20:00:48.59722-03
542	Batom Multimix Cremoso Faces	\N	116193	Maquiagem	Batom Multimix Cremoso Faces\nRef: 116193	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw000194ec/produto-joia/background/desktop/PAI116187.jpg	5	23.90	23.90	2026-03-05 12:51:47.398811-03	2026-02-27 20:00:48.59722-03
544	Kit Dupla Antissinais 60+ Chronos Derma ( 2 produtos)	\N	219705	Geral	Kit Dupla Antissinais 60+ Chronos Derma ( 2 produtos)\nRef: 219705	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw62b5da28/produto-joia/background/desktop/219705.jpg	5	0.00	0.00	2026-03-05 12:52:18.540106-03	2026-02-27 20:00:48.603201-03
545	Sabonete em Barra Corpo e Barba Kaiak	\N	108875	Corpo e Banho	Sabonete em Barra Corpo e Barba Kaiak\nRef: 108875	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw918cd933/NATBRA-108875_1.jpg	5	28.90	28.90	2026-03-05 12:52:33.625198-03	2026-02-27 20:00:48.605026-03
548	Refil Creme para Pentear Crespos Tododia Amora e Óleo de Coco	\N	173582	Corpo e Banho	Refil Creme para Pentear Crespos Tododia Amora e Óleo de Coco\nRef: 173582	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw87aa4d0d/produto-joia/background/desktop/173582.jpg	5	0.00	0.00	2026-03-05 12:53:05.940191-03	2026-02-27 20:00:48.605026-03
549	Creme Desodorante Hidratante para o Corpo Ekos Maracujá Natureza dos Sonhos	\N	231780	Corpo e Banho	Creme Desodorante Hidratante para o Corpo Ekos Maracujá Natureza dos Sonhos\nRef: 231780	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw21189eb3/produto-joia/background/desktop/231780.jpg	5	0.00	0.00	2026-03-05 12:53:33.981927-03	2026-02-27 20:00:48.613052-03
550	Desodorante Corporal Masculino Kaiak Oceano	\N	16623	Corpo e Banho	Desodorante Corporal Masculino Kaiak Oceano\nRef: 16623	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe6718f0b/produto-joia/background/desktop/16623.jpg	5	56.90	56.90	2026-03-05 12:53:44.938818-03	2026-02-27 20:00:48.613052-03
553	Condicionador para Definição e Hidratação de Cabelos Cacheados	\N	148411	Cabelos	Condicionador para Definição e Hidratação de Cabelos Cacheados\nRef: 148411	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdfb6a180/NATBRA-148411_1.jpg	5	55.90	55.90	2026-03-05 12:54:14.334396-03	2026-02-27 20:00:56.977483-03
554	Estojo Rosa Metalizado	\N	71663	Geral	Estojo Rosa Metalizado\nRef: 71663	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw427825ea/produto-joia/background/desktop/71663.jpg	5	59.90	59.90	2026-03-05 12:54:44.100941-03	2026-02-27 20:00:56.986267-03
555	Batom Multimix Cremoso Faces	\N	116203	Maquiagem	Batom Multimix Cremoso Faces\nRef: 116203	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw000194ec/produto-joia/background/desktop/PAI116187.jpg	5	23.90	23.90	2026-03-05 12:54:54.112009-03	2026-02-27 20:00:56.986267-03
556	Natura Homem Emocion.e 100 ml	\N	2190	Homem	Natura Homem Emocion.e 100 ml\nRef: 2190	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8e24e195/produto-joia/background/desktop/2190.jpg	5	0.00	0.00	2026-03-05 12:55:17.087772-03	2026-02-27 20:00:56.986267-03
559	Creme Desodorante Hidratante para o Corpo Ekos Açaí	\N	203398	Corpo e Banho	Creme Desodorante Hidratante para o Corpo Ekos Açaí\nRef: 203398	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw84babb98/produto-joia/background/desktop/203398.jpg	5	0.00	0.00	2026-03-05 12:55:35.914089-03	2026-02-27 20:00:56.994253-03
562	Difusor de Ambiente Natura Bothânica Aura Gingi	\N	167636	Geral	Difusor de Ambiente Natura Bothânica Aura Gingi\nRef: 167636	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc609d3f3/produto-joia/background/desktop/167636.jpg	5	250.00	250.00	2026-03-05 12:56:06.035478-03	2026-02-27 20:00:56.994253-03
561	Refil Sabonete Líquido em Gel Tododia Noz Pecã e Cacau	\N	86356	Corpo e Banho	Refil Sabonete Líquido em Gel Tododia Noz Pecã e Cacau\nRef: 86356	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb2cb0b44/produto-joia/background/desktop/86356.jpg	5	38.40	38.40	2026-03-05 12:56:22.136747-03	2026-02-27 20:00:56.994253-03
565	Fluido de Massagem para o Corpo Ekos Andiroba	\N	73214	Geral	Fluido de Massagem para o Corpo Ekos Andiroba\nRef: 73214	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw76317126/produto-joia/background/desktop/73214.jpg	5	0.00	0.00	2026-03-05 12:56:47.180301-03	2026-02-27 20:00:57.002427-03
567	Refil Sabonete Líquido Cremoso para o Corpo Tododia Algodão	\N	113406	Corpo e Banho	Refil Sabonete Líquido Cremoso para o Corpo Tododia Algodão\nRef: 113406	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2b801d0c/NATBRA-113406_1.jpg	5	38.40	38.40	2026-03-05 12:57:15.304521-03	2026-02-27 20:00:57.002427-03
566	Kaiak Sonar Feminino 100 ml	\N	155608	Geral	Kaiak Sonar Feminino 100 ml\nRef: 155608	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dweb504c3f/produto-joia/background/desktop/155608.jpg	5	0.00	0.00	2026-03-05 12:57:36.010553-03	2026-02-27 20:00:57.002427-03
571	Lápis Para Lábios Color & Contour Faces	\N	9521	Geral	Lápis Para Lábios Color & Contour Faces\nRef: 9521	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw22284f18/Produtos/NATBRA-9521_1.jpg	5	39.90	39.90	2026-03-05 12:58:00.336004-03	2026-02-27 20:00:57.010999-03
568	Refil Creme Desodorante Nutritivo para o Corpo Tododia Morango e Baunilha Dourada	\N	206230	Corpo e Banho	Refil Creme Desodorante Nutritivo para o Corpo Tododia Morango e Baunilha Dourada\nRef: 206230	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6522ae5f/produto-joia/background/desktop/206230.jpg	5	58.90	58.90	2026-03-05 12:58:30.338712-03	2026-02-27 20:00:57.010999-03
570	Natura Homem Elo 100 ml	\N	125366	Homem	Natura Homem Elo 100 ml\nRef: 125366	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd18e41ee/produto-joia/background/desktop/125366.jpg	5	0.00	0.00	2026-03-05 12:58:55.475458-03	2026-02-27 20:00:57.010999-03
574	Kit Sabonete em Barra Tododia Flor de Gengibre e Tangerina e Tododia Chá de Camomila e Lavanda (2 caixas)	\N	241073	Corpo e Banho	Kit Sabonete em Barra Tododia Flor de Gengibre e Tangerina e Tododia Chá de Camomila e Lavanda (2 caixas)\nRef: 241073	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw06c62f22/Produtos/NATBRA-241073_1.jpg	5	0.00	0.00	2026-03-05 12:59:10.97643-03	2026-02-27 20:00:57.019125-03
575	Óleo em Creme Ultranutritivo Restaurador Tododia Jambo Rosa e Flor de Caju	\N	172407	Corpo e Banho	Óleo em Creme Ultranutritivo Restaurador Tododia Jambo Rosa e Flor de Caju\nRef: 172407	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5f666df1/produto-joia/background/desktop/172407.jpg	5	0.00	0.00	2026-03-05 12:59:34.461721-03	2026-02-27 20:01:05.227105-03
584	Máscara para Cílios Alongamento Infinito à Prova D’água Una	\N	106122	Cabelos	Máscara para Cílios Alongamento Infinito à Prova D’água Una\nRef: 106122	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0c349c5e/produto-joia/background/desktop/106122.jpg	5	89.90	89.90	2026-03-05 13:41:32.430226-03	2026-02-27 20:01:05.243156-03
585	Sabonete em Óleo Limpeza Demaquilante Chronos Derma	\N	171365	Corpo e Banho	Sabonete em Óleo Limpeza Demaquilante Chronos Derma\nRef: 171365	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw74c00273/produto-joia/background/desktop/171365.jpg	5	0.00	0.00	2026-03-05 13:41:45.801908-03	2026-02-27 20:01:05.243156-03
587	Kit Shampoo Antiqueda e Crescimento Lumina com Refil	\N	244488	Cabelos	Kit Shampoo Antiqueda e Crescimento Lumina com Refil\nRef: 244488	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb1cc7108/produto-joia/background/desktop/244488.jpg	5	0.00	0.00	2026-03-05 13:42:18.238996-03	2026-02-27 20:01:05.243156-03
589	Refil Pó Compacto Matte Faces 6,5g	\N	9025	Maquiagem	Refil Pó Compacto Matte Faces 6,5g\nRef: 9025	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe601c256/Produtos/NATBRA-9025_1.jpg	5	49.90	49.90	2026-03-05 13:42:44.101146-03	2026-02-27 20:01:05.251215-03
591	Kit Lumina Cacheados Shampoo, Condicionador e Creme para Pentear (3 produtos)	\N	217202	Cabelos	Kit Lumina Cacheados Shampoo, Condicionador e Creme para Pentear (3 produtos)\nRef: 217202	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1d59c558/produto-joia/background/desktop/217202.jpg	5	0.00	0.00	2026-03-05 13:43:12.513969-03	2026-02-27 20:01:05.251215-03
592	Gloss Labial Faces	\N	175111	Geral	Gloss Labial Faces\nRef: 175111	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd5611523/produto-joia/background/desktop/175111.jpg	5	0.00	0.00	2026-03-05 13:43:26.30472-03	2026-02-27 20:01:05.25955-03
594	Presente Mochila Crer Para Ver	\N	218961	Geral	Presente Mochila Crer Para Ver\nRef: 218961	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2dba5deb/produto-joia/background/desktop/218961.jpg	5	159.90	159.90	2026-03-05 13:43:52.949167-03	2026-02-27 20:01:05.26117-03
595	Sabonete em Barra Puro Vegetal Ekos Açaí (4 unidades)	\N	124395	Corpo e Banho	Sabonete em Barra Puro Vegetal Ekos Açaí (4 unidades)\nRef: 124395	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb596c417/produto-joia/background/desktop/124395.jpg	5	0.00	0.00	2026-03-05 13:44:08.146602-03	2026-02-27 20:01:05.26117-03
597	Sabonete Gel para o Rosto Faces	\N	90175	Corpo e Banho	Sabonete Gel para o Rosto Faces\nRef: 90175	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw158d2582/produto-joia/background/desktop/90175.jpg	5	0.00	0.00	2026-03-05 13:44:37.176383-03	2026-02-27 20:01:05.267864-03
598	Kit Desodorante Antitranspirante Roll-on Tododia Alecrim e Sálvia (3 unidades)	\N	213541	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Tododia Alecrim e Sálvia (3 unidades)\nRef: 213541	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc8c7da65/produto-joia/background/desktop/213541.jpg	5	0.00	0.00	2026-03-05 13:44:53.536222-03	2026-02-27 20:01:12.888384-03
\.


--
-- Data for Name: inventory_sale; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_sale (id, transaction_type, total_amount, client_name, payment_method, notes, created_at, store_id) FROM stdin;
\.


--
-- Data for Name: inventory_saleitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_saleitem (id, quantity, unit_price_sold, unit_cost_at_time, batch_id, product_id, sale_id) FROM stdin;
\.


--
-- Data for Name: inventory_store; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_store (id, name, slug, whatsapp, created_at, user_id) FROM stdin;
1	Consultoria Natura VIP	vip	5511999999999	2026-02-27 19:51:22.144089-03	1
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 56, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 2, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 14, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 19, true);


--
-- Name: inventory_crawlerlog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_crawlerlog_id_seq', 1, false);


--
-- Name: inventory_inventorybatch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_inventorybatch_id_seq', 1, false);


--
-- Name: inventory_inventoryitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_inventoryitem_id_seq', 1, false);


--
-- Name: inventory_pricehistory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_pricehistory_id_seq', 218, true);


--
-- Name: inventory_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_product_id_seq', 1894, true);


--
-- Name: inventory_sale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_sale_id_seq', 1, false);


--
-- Name: inventory_saleitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_saleitem_id_seq', 1, false);


--
-- Name: inventory_store_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_store_id_seq', 1, true);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: inventory_crawlerlog inventory_crawlerlog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_crawlerlog
    ADD CONSTRAINT inventory_crawlerlog_pkey PRIMARY KEY (id);


--
-- Name: inventory_inventorybatch inventory_inventorybatch_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_inventorybatch
    ADD CONSTRAINT inventory_inventorybatch_pkey PRIMARY KEY (id);


--
-- Name: inventory_inventoryitem inventory_inventoryitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_inventoryitem
    ADD CONSTRAINT inventory_inventoryitem_pkey PRIMARY KEY (id);


--
-- Name: inventory_inventoryitem inventory_inventoryitem_store_id_product_id_ba33e0ff_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_inventoryitem
    ADD CONSTRAINT inventory_inventoryitem_store_id_product_id_ba33e0ff_uniq UNIQUE (store_id, product_id);


--
-- Name: inventory_pricehistory inventory_pricehistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_pricehistory
    ADD CONSTRAINT inventory_pricehistory_pkey PRIMARY KEY (id);


--
-- Name: inventory_product inventory_product_bar_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_product
    ADD CONSTRAINT inventory_product_bar_code_key UNIQUE (bar_code);


--
-- Name: inventory_product inventory_product_natura_sku_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_product
    ADD CONSTRAINT inventory_product_natura_sku_key UNIQUE (natura_sku);


--
-- Name: inventory_product inventory_product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_product
    ADD CONSTRAINT inventory_product_pkey PRIMARY KEY (id);


--
-- Name: inventory_sale inventory_sale_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_sale
    ADD CONSTRAINT inventory_sale_pkey PRIMARY KEY (id);


--
-- Name: inventory_saleitem inventory_saleitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_saleitem
    ADD CONSTRAINT inventory_saleitem_pkey PRIMARY KEY (id);


--
-- Name: inventory_store inventory_store_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_store
    ADD CONSTRAINT inventory_store_pkey PRIMARY KEY (id);


--
-- Name: inventory_store inventory_store_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_store
    ADD CONSTRAINT inventory_store_slug_key UNIQUE (slug);


--
-- Name: inventory_store inventory_store_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_store
    ADD CONSTRAINT inventory_store_user_id_key UNIQUE (user_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: inventory_crawlerlog_sku_63555d21; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_crawlerlog_sku_63555d21 ON public.inventory_crawlerlog USING btree (sku);


--
-- Name: inventory_crawlerlog_sku_63555d21_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_crawlerlog_sku_63555d21_like ON public.inventory_crawlerlog USING btree (sku varchar_pattern_ops);


--
-- Name: inventory_inventorybatch_item_id_41df143d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_inventorybatch_item_id_41df143d ON public.inventory_inventorybatch USING btree (item_id);


--
-- Name: inventory_inventoryitem_product_id_78574124; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_inventoryitem_product_id_78574124 ON public.inventory_inventoryitem USING btree (product_id);


--
-- Name: inventory_inventoryitem_store_id_9243fb77; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_inventoryitem_store_id_9243fb77 ON public.inventory_inventoryitem USING btree (store_id);


--
-- Name: inventory_pricehistory_product_id_53789fff; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_pricehistory_product_id_53789fff ON public.inventory_pricehistory USING btree (product_id);


--
-- Name: inventory_product_bar_code_5579df6b_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_product_bar_code_5579df6b_like ON public.inventory_product USING btree (bar_code varchar_pattern_ops);


--
-- Name: inventory_product_natura_sku_fb3604bf_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_product_natura_sku_fb3604bf_like ON public.inventory_product USING btree (natura_sku varchar_pattern_ops);


--
-- Name: inventory_sale_store_id_60ee6f5f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_sale_store_id_60ee6f5f ON public.inventory_sale USING btree (store_id);


--
-- Name: inventory_saleitem_batch_id_b82bea79; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_saleitem_batch_id_b82bea79 ON public.inventory_saleitem USING btree (batch_id);


--
-- Name: inventory_saleitem_product_id_cd9a834b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_saleitem_product_id_cd9a834b ON public.inventory_saleitem USING btree (product_id);


--
-- Name: inventory_saleitem_sale_id_09bd155b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_saleitem_sale_id_09bd155b ON public.inventory_saleitem USING btree (sale_id);


--
-- Name: inventory_store_slug_7f929d58_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_store_slug_7f929d58_like ON public.inventory_store USING btree (slug varchar_pattern_ops);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: inventory_inventorybatch inventory_inventoryb_item_id_41df143d_fk_inventory; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_inventorybatch
    ADD CONSTRAINT inventory_inventoryb_item_id_41df143d_fk_inventory FOREIGN KEY (item_id) REFERENCES public.inventory_inventoryitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: inventory_inventoryitem inventory_inventoryi_product_id_78574124_fk_inventory; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_inventoryitem
    ADD CONSTRAINT inventory_inventoryi_product_id_78574124_fk_inventory FOREIGN KEY (product_id) REFERENCES public.inventory_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: inventory_inventoryitem inventory_inventoryitem_store_id_9243fb77_fk_inventory_store_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_inventoryitem
    ADD CONSTRAINT inventory_inventoryitem_store_id_9243fb77_fk_inventory_store_id FOREIGN KEY (store_id) REFERENCES public.inventory_store(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: inventory_pricehistory inventory_pricehisto_product_id_53789fff_fk_inventory; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_pricehistory
    ADD CONSTRAINT inventory_pricehisto_product_id_53789fff_fk_inventory FOREIGN KEY (product_id) REFERENCES public.inventory_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: inventory_sale inventory_sale_store_id_60ee6f5f_fk_inventory_store_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_sale
    ADD CONSTRAINT inventory_sale_store_id_60ee6f5f_fk_inventory_store_id FOREIGN KEY (store_id) REFERENCES public.inventory_store(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: inventory_saleitem inventory_saleitem_batch_id_b82bea79_fk_inventory; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_saleitem
    ADD CONSTRAINT inventory_saleitem_batch_id_b82bea79_fk_inventory FOREIGN KEY (batch_id) REFERENCES public.inventory_inventorybatch(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: inventory_saleitem inventory_saleitem_product_id_cd9a834b_fk_inventory_product_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_saleitem
    ADD CONSTRAINT inventory_saleitem_product_id_cd9a834b_fk_inventory_product_id FOREIGN KEY (product_id) REFERENCES public.inventory_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: inventory_saleitem inventory_saleitem_sale_id_09bd155b_fk_inventory_sale_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_saleitem
    ADD CONSTRAINT inventory_saleitem_sale_id_09bd155b_fk_inventory_sale_id FOREIGN KEY (sale_id) REFERENCES public.inventory_sale(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: inventory_store inventory_store_user_id_854ba86a_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_store
    ADD CONSTRAINT inventory_store_user_id_854ba86a_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

