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
ALTER TABLE IF EXISTS ONLY public.inventory_stocktransaction DROP CONSTRAINT IF EXISTS inventory_stocktrans_store_id_a0327880_fk_inventory;
ALTER TABLE IF EXISTS ONLY public.inventory_stocktransaction DROP CONSTRAINT IF EXISTS inventory_stocktrans_product_id_6432f3fb_fk_inventory;
ALTER TABLE IF EXISTS ONLY public.inventory_stocktransaction DROP CONSTRAINT IF EXISTS inventory_stocktrans_batch_id_f0154012_fk_inventory;
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
DROP INDEX IF EXISTS public.inventory_stocktransaction_store_id_a0327880;
DROP INDEX IF EXISTS public.inventory_stocktransaction_product_id_6432f3fb;
DROP INDEX IF EXISTS public.inventory_stocktransaction_batch_id_f0154012;
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
ALTER TABLE IF EXISTS ONLY public.inventory_stocktransaction DROP CONSTRAINT IF EXISTS inventory_stocktransaction_pkey;
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
DROP TABLE IF EXISTS public.inventory_stocktransaction;
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
-- Name: inventory_stocktransaction; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_stocktransaction (
    id bigint NOT NULL,
    transaction_type character varying(20) NOT NULL,
    quantity integer NOT NULL,
    unit_cost numeric(10,2),
    unit_price numeric(10,2),
    description character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    batch_id bigint,
    product_id bigint NOT NULL,
    store_id bigint NOT NULL
);


--
-- Name: inventory_stocktransaction_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.inventory_stocktransaction ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.inventory_stocktransaction_id_seq
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
57	Can add stock transaction	15	add_stocktransaction
58	Can change stock transaction	15	change_stocktransaction
59	Can delete stock transaction	15	delete_stocktransaction
60	Can view stock transaction	15	view_stocktransaction
61	Can add custom user	16	add_customuser
62	Can change custom user	16	change_customuser
63	Can delete custom user	16	delete_customuser
64	Can view custom user	16	view_customuser
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
15	inventory	stocktransaction
16	inventory	customuser
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
20	inventory	0002_stocktransaction	2026-03-07 10:56:56.065209-03
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
219	44.90	2026-03-07 12:47:16.044242-03	324
220	59.90	2026-03-07 12:49:01.08341-03	327
221	69.90	2026-03-07 12:49:48.025346-03	329
222	124.00	2026-03-07 12:50:00.806657-03	331
223	31.90	2026-03-07 12:50:09.38749-03	330
224	116.90	2026-03-07 12:50:23.7959-03	328
225	239.00	2026-03-07 12:50:50.870846-03	352
226	78.90	2026-03-07 12:52:50.703914-03	359
227	79.90	2026-03-07 12:53:34.432118-03	450
228	23.90	2026-03-07 12:53:50.723961-03	451
229	45.90	2026-03-07 12:55:10.847756-03	461
230	33.90	2026-03-07 12:55:36.143301-03	474
231	279.90	2026-03-07 12:56:11.151851-03	476
232	79.90	2026-03-07 12:57:14.221752-03	482
233	83.90	2026-03-07 12:58:19.543361-03	576
234	129.90	2026-03-07 12:58:41.056004-03	577
235	66.90	2026-03-07 12:58:52.348519-03	579
236	39.90	2026-03-07 12:59:06.473763-03	583
237	55.90	2026-03-07 12:59:30.758586-03	581
238	139.90	2026-03-07 12:59:46.315412-03	580
239	37.50	2026-03-07 13:00:18.501243-03	601
240	116.90	2026-03-07 13:01:22.485266-03	605
241	29.90	2026-03-07 13:01:33.781882-03	606
242	57.00	2026-03-07 13:01:59.644708-03	608
243	124.00	2026-03-07 13:02:12.049728-03	609
244	59.90	2026-03-07 13:02:21.517727-03	610
245	119.90	2026-03-07 13:02:50.732912-03	612
246	57.00	2026-03-07 13:03:01.814512-03	613
247	23.90	2026-03-07 13:03:15.16902-03	614
248	87.90	2026-03-07 13:03:36.920813-03	616
249	44.90	2026-03-07 13:03:53.037748-03	617
250	90.90	2026-03-07 13:04:29.855937-03	620
251	72.90	2026-03-07 13:04:41.927199-03	623
252	35.90	2026-03-07 13:05:09.48556-03	621
253	124.00	2026-03-07 13:06:27.626577-03	628
254	79.90	2026-03-07 13:06:40.561967-03	629
255	35.90	2026-03-07 13:49:17.53297-03	640
256	29.90	2026-03-07 13:50:10.189332-03	643
257	116.90	2026-03-07 13:50:42.395681-03	646
258	56.90	2026-03-07 13:51:12.260133-03	648
259	136.00	2026-03-07 13:51:23.602202-03	649
260	44.90	2026-03-07 13:51:34.839179-03	651
261	94.90	2026-03-07 13:51:50.241698-03	650
262	50.90	2026-03-07 13:51:59.522448-03	652
263	59.90	2026-03-07 13:52:20.012214-03	654
264	57.90	2026-03-07 13:53:30.497101-03	659
265	164.90	2026-03-07 14:51:48.869661-03	672
266	495.90	2026-03-07 14:52:02.552064-03	673
267	37.90	2026-03-07 14:52:15.693239-03	674
268	66.90	2026-03-07 14:52:47.734361-03	676
269	195.00	2026-03-07 14:53:01.149003-03	675
270	40.60	2026-03-07 14:53:27.293168-03	678
271	23.90	2026-03-07 14:53:40.14226-03	680
272	49.90	2026-03-07 14:54:42.42025-03	684
273	64.90	2026-03-07 14:55:25.559982-03	687
274	23.90	2026-03-07 14:57:56.487777-03	698
275	39.90	2026-03-07 14:58:27.053396-03	700
276	49.90	2026-03-07 14:58:39.564617-03	701
277	57.00	2026-03-07 14:58:52.187144-03	702
278	7.90	2026-03-07 14:59:05.508161-03	703
279	134.90	2026-03-07 14:59:55.920677-03	706
280	59.90	2026-03-07 15:00:32.828506-03	708
281	35.90	2026-03-07 15:00:43.449533-03	709
282	29.90	2026-03-07 15:00:56.665597-03	710
283	55.90	2026-03-07 15:02:23.111131-03	715
284	29.90	2026-03-07 15:03:22.76922-03	719
285	189.90	2026-03-07 15:03:33.080844-03	720
286	49.90	2026-03-07 15:04:12.472426-03	723
287	39.90	2026-03-07 15:05:07.48542-03	726
288	69.90	2026-03-07 15:05:21.948054-03	727
289	119.90	2026-03-07 15:05:55.020367-03	730
290	41.90	2026-03-07 15:06:36.474999-03	733
291	35.90	2026-03-07 15:07:03.372765-03	735
292	99.90	2026-03-07 15:08:10.23637-03	739
293	27.90	2026-03-07 15:08:20.817699-03	740
294	36.90	2026-03-07 15:08:46.810607-03	742
295	57.00	2026-03-07 15:10:31.816614-03	749
296	55.90	2026-03-07 15:52:33.884164-03	758
297	209.90	2026-03-07 15:53:26.748351-03	762
298	51.90	2026-03-07 15:54:13.152687-03	765
299	29.90	2026-03-07 15:54:47.388355-03	767
300	109.90	2026-03-07 15:55:03.392796-03	768
301	89.90	2026-03-07 15:55:15.103236-03	769
302	8.90	2026-03-07 15:56:18.801419-03	773
303	20.90	2026-03-07 16:56:54.635314-03	787
304	78.90	2026-03-07 16:58:12.086642-03	793
305	5.00	2026-03-07 16:58:25.886239-03	794
306	70.90	2026-03-07 16:59:40.398184-03	799
307	23.90	2026-03-07 17:00:12.878065-03	802
308	23.90	2026-03-07 17:00:26.98823-03	803
309	79.90	2026-03-07 17:00:39.049309-03	804
310	50.90	2026-03-07 17:01:02.320597-03	806
311	39.90	2026-03-07 17:01:37.632501-03	809
312	40.60	2026-03-07 17:02:12.882437-03	812
313	59.90	2026-03-07 17:02:35.689517-03	813
314	59.90	2026-03-07 17:04:32.78905-03	823
315	114.90	2026-03-07 17:05:06.679519-03	825
316	98.00	2026-03-07 17:05:15.918022-03	826
317	230.00	2026-03-07 17:05:30.149321-03	827
318	57.90	2026-03-07 17:06:44.442631-03	834
319	64.90	2026-03-07 17:07:49.639804-03	838
320	52.90	2026-03-07 17:08:15.424174-03	840
321	23.90	2026-03-07 17:08:41.06847-03	841
322	79.90	2026-03-07 17:09:03.113598-03	844
323	134.90	2026-03-07 17:09:16.455118-03	845
324	139.90	2026-03-07 17:09:24.833977-03	846
325	38.40	2026-03-07 17:10:39.645918-03	852
326	23.90	2026-03-07 17:11:08.516115-03	854
327	219.90	2026-03-07 17:11:21.965685-03	855
328	34.90	2026-03-07 17:11:49.242832-03	857
329	69.90	2026-03-07 17:12:01.680301-03	858
330	169.90	2026-03-07 17:12:13.202523-03	859
331	170.20	2026-03-07 17:13:17.570046-03	861
332	47.90	2026-03-07 17:13:43.835556-03	863
333	160.00	2026-03-07 17:14:07.227412-03	865
334	29.90	2026-03-07 17:14:35.170413-03	867
335	7.00	2026-03-07 17:14:52.358414-03	868
336	64.90	2026-03-07 18:01:47.600347-03	879
337	35.90	2026-03-07 18:02:01.915907-03	880
338	59.90	2026-03-07 18:02:48.296711-03	884
339	79.90	2026-03-07 18:02:56.379345-03	885
340	109.90	2026-03-07 18:03:23.923413-03	887
341	47.20	2026-03-07 18:03:40.414883-03	888
342	155.00	2026-03-07 18:03:49.357454-03	889
343	44.90	2026-03-07 18:04:25.820922-03	892
344	79.90	2026-03-07 19:01:51.046446-03	904
345	40.90	2026-03-07 19:02:07.831384-03	906
346	209.90	2026-03-07 19:02:45.824018-03	909
347	149.90	2026-03-07 19:03:06.030139-03	910
348	50.90	2026-03-07 19:03:31.529595-03	912
349	23.90	2026-03-07 19:03:44.294244-03	913
350	79.90	2026-03-07 19:04:02.605893-03	915
351	44.90	2026-03-07 19:04:18.876163-03	916
352	35.90	2026-03-07 19:05:13.232389-03	920
353	95.90	2026-03-07 19:06:02.562987-03	924
354	64.90	2026-03-07 19:06:22.042564-03	926
355	35.90	2026-03-07 19:07:01.418272-03	929
356	20.90	2026-03-07 19:07:29.077451-03	931
357	64.90	2026-03-07 19:07:41.706503-03	932
358	213.90	2026-03-07 19:07:51.703774-03	933
359	49.90	2026-03-07 19:08:21.722256-03	935
360	69.90	2026-03-07 19:08:35.669995-03	936
361	168.00	2026-03-07 19:08:46.265461-03	937
362	49.90	2026-03-07 19:09:11.459571-03	939
363	79.90	2026-03-07 19:09:28.640206-03	940
364	35.90	2026-03-07 19:09:39.790376-03	941
365	29.90	2026-03-07 19:12:31.622085-03	956
366	109.90	2026-03-07 19:12:44.684771-03	957
367	35.90	2026-03-07 19:13:14.066548-03	959
368	389.90	2026-03-07 19:13:23.972695-03	960
369	69.90	2026-03-07 19:14:12.306263-03	963
370	67.50	2026-03-07 19:14:57.924571-03	967
371	37.80	2026-03-07 19:15:25.473834-03	969
372	29.90	2026-03-07 19:15:48.307372-03	972
373	150.00	2026-03-07 19:15:58.141592-03	971
374	159.90	2026-03-07 19:16:22.09854-03	974
375	34.90	2026-03-07 19:16:50.567261-03	976
376	59.90	2026-03-07 19:17:43.432066-03	980
377	10.00	2026-03-07 19:18:22.901558-03	983
378	49.90	2026-03-07 19:19:00.681436-03	986
379	99.90	2026-03-07 20:06:26.258618-03	998
380	66.90	2026-03-07 20:07:19.856801-03	1002
381	84.90	2026-03-07 20:07:43.515933-03	1004
382	99.90	2026-03-07 20:07:58.056614-03	1005
383	39.90	2026-03-07 20:08:27.323294-03	1007
384	79.90	2026-03-07 20:08:45.792841-03	1008
385	64.90	2026-03-07 20:09:35.425755-03	1012
386	69.90	2026-03-07 21:07:04.872433-03	1025
387	39.90	2026-03-07 21:07:55.929636-03	1028
388	99.90	2026-03-07 21:08:05.86382-03	1032
389	99.90	2026-03-07 21:09:58.614605-03	1038
390	65.90	2026-03-07 21:10:08.490084-03	1039
391	45.90	2026-03-07 21:10:52.790093-03	1043
392	16.80	2026-03-07 21:12:19.615575-03	1046
393	39.90	2026-03-07 21:13:23.94081-03	1053
394	49.90	2026-03-07 21:14:00.899254-03	1056
395	64.90	2026-03-07 21:14:22.946801-03	1054
396	99.90	2026-03-07 21:14:55.42947-03	1063
397	185.90	2026-03-07 21:15:08.715772-03	1061
398	56.90	2026-03-07 21:15:30.46197-03	1059
399	6.90	2026-03-07 21:16:23.530427-03	1066
400	65.90	2026-03-07 21:17:46.79548-03	1072
401	99.90	2026-03-07 21:18:00.638934-03	1073
402	168.00	2026-03-07 21:18:29.506125-03	1075
403	95.90	2026-03-07 21:18:52.927744-03	1077
404	54.90	2026-03-07 21:19:47.529724-03	1081
405	64.90	2026-03-07 21:20:33.082336-03	1084
406	64.90	2026-03-07 21:20:56.749229-03	1087
407	50.90	2026-03-07 21:21:36.529959-03	1090
408	102.00	2026-03-07 21:21:49.840623-03	1091
409	34.90	2026-03-07 21:22:32.262289-03	1095
410	99.90	2026-03-07 21:22:40.965339-03	1096
411	56.90	2026-03-07 21:22:54.868704-03	1097
412	64.90	2026-03-07 21:23:20.154549-03	1099
413	29.90	2026-03-07 21:23:30.127856-03	1100
414	109.90	2026-03-07 21:23:44.580207-03	1101
415	99.90	2026-03-07 21:23:56.194343-03	1102
416	71.90	2026-03-07 21:24:12.156394-03	1103
417	59.90	2026-03-07 21:24:36.739049-03	1105
418	79.90	2026-03-07 21:24:51.784723-03	1106
419	59.90	2026-03-07 21:25:04.148282-03	1107
420	49.90	2026-03-07 22:07:04.819396-03	1116
421	150.00	2026-03-07 22:07:15.567773-03	1117
422	69.90	2026-03-07 22:07:26.216482-03	1118
423	59.90	2026-03-07 22:08:56.497659-03	1124
424	109.00	2026-03-07 22:09:26.732299-03	1126
425	99.90	2026-03-07 23:11:51.641981-03	1139
426	159.90	2026-03-07 23:12:06.179495-03	1140
427	27.90	2026-03-07 23:12:17.550995-03	1141
428	34.90	2026-03-07 23:12:42.011541-03	1142
429	49.90	2026-03-07 23:14:02.834524-03	1147
430	79.90	2026-03-07 23:14:11.915496-03	1148
431	160.00	2026-03-07 23:14:27.278189-03	1149
432	38.40	2026-03-07 23:15:06.041424-03	1152
433	30.90	2026-03-07 23:16:13.561478-03	1157
434	59.90	2026-03-07 23:16:24.772728-03	1156
435	44.90	2026-03-07 23:16:39.869-03	1159
436	64.90	2026-03-07 23:17:07.292367-03	1160
437	195.00	2026-03-07 23:17:37.136365-03	1163
438	53.90	2026-03-07 23:18:02.500885-03	1165
439	95.90	2026-03-07 23:18:27.440734-03	1167
440	98.00	2026-03-07 23:18:41.689487-03	1168
441	109.90	2026-03-07 23:20:13.505454-03	1174
442	64.90	2026-03-07 23:20:27.556992-03	1175
443	109.90	2026-03-07 23:20:40.383842-03	1176
444	11.00	2026-03-07 23:20:55.223713-03	1177
445	43.80	2026-03-07 23:21:19.641075-03	1179
446	25.90	2026-03-07 23:21:43.36917-03	1181
447	159.90	2026-03-07 23:24:13.074663-03	1192
448	59.90	2026-03-07 23:24:26.858496-03	1193
449	45.90	2026-03-07 23:24:38.211504-03	1194
450	180.00	2026-03-07 23:24:55.358809-03	1195
451	126.00	2026-03-07 23:25:09.078481-03	1196
452	45.90	2026-03-07 23:25:22.675185-03	1197
453	126.00	2026-03-07 23:25:37.666464-03	1198
454	86.90	2026-03-07 23:25:58.017156-03	1199
455	59.90	2026-03-07 23:26:35.451956-03	1202
456	168.00	2026-03-07 23:27:46.430714-03	1208
457	159.90	2026-03-07 23:28:02.210404-03	1209
458	79.90	2026-03-07 23:28:11.541011-03	1210
459	79.90	2026-03-07 23:28:34.191086-03	1212
460	408.00	2026-03-07 23:29:23.555982-03	1216
461	408.00	2026-03-07 23:29:33.918549-03	1217
462	408.00	2026-03-07 23:29:48.649615-03	1218
463	389.90	2026-03-07 23:29:58.013992-03	1219
464	9.20	2026-03-08 00:12:01.988422-03	1230
465	160.00	2026-03-08 00:14:08.905372-03	1238
466	69.90	2026-03-08 00:14:57.994711-03	1242
467	29.90	2026-03-08 00:16:34.567909-03	1247
468	60.90	2026-03-08 01:14:56.16313-03	1263
469	159.90	2026-03-08 01:15:30.919397-03	1265
470	98.00	2026-03-08 01:16:01.703329-03	1267
471	116.90	2026-03-08 01:16:36.058777-03	1269
472	79.90	2026-03-08 01:17:28.283358-03	1273
473	49.90	2026-03-08 01:17:55.598036-03	1275
474	109.90	2026-03-08 01:18:19.332056-03	1277
475	13.90	2026-03-08 01:19:31.594787-03	1282
476	109.90	2026-03-08 01:19:45.901117-03	1283
477	109.90	2026-03-08 01:20:47.212802-03	1288
478	35.90	2026-03-08 01:21:56.383377-03	1293
479	99.90	2026-03-08 01:22:07.671464-03	1294
480	159.90	2026-03-08 01:22:39.105049-03	1297
481	58.90	2026-03-08 01:22:54.85418-03	1298
482	250.00	2026-03-08 01:23:23.854928-03	1302
483	240.00	2026-03-08 01:23:36.301688-03	1300
484	20.90	2026-03-08 01:25:12.2614-03	1307
485	119.90	2026-03-08 01:26:12.383135-03	1311
486	159.90	2026-03-08 01:27:03.467047-03	1315
487	45.90	2026-03-08 01:28:49.933204-03	1323
488	23.90	2026-03-08 01:28:58.635275-03	1328
489	59.90	2026-03-08 01:29:37.848648-03	1326
490	230.00	2026-03-08 01:31:27.443564-03	1334
491	34.90	2026-03-08 01:31:55.05758-03	1338
492	49.90	2026-03-08 01:33:16.842823-03	1343
493	70.00	2026-03-08 01:33:31.628295-03	1344
494	66.90	2026-03-08 01:34:45.791853-03	1349
495	23.90	2026-03-08 02:16:41.97386-03	1359
496	59.90	2026-03-08 02:16:53.194272-03	1360
497	64.90	2026-03-08 02:17:04.204334-03	1361
498	10.90	2026-03-08 02:18:06.769484-03	1366
499	109.90	2026-03-08 02:18:19.605801-03	1367
500	52.90	2026-03-08 02:18:32.289504-03	1368
501	122.90	2026-03-08 02:19:14.508587-03	1371
502	63.90	2026-03-08 03:17:25.709568-03	1390
503	49.90	2026-03-08 03:17:38.592788-03	1389
504	180.00	2026-03-08 03:19:03.376672-03	1392
505	59.90	2026-03-08 03:19:17.485044-03	1396
506	45.90	2026-03-08 03:19:30.664417-03	1397
507	159.90	2026-03-08 03:20:26.198753-03	1403
508	55.90	2026-03-08 03:21:19.219084-03	1409
509	79.90	2026-03-08 03:21:47.482393-03	1407
510	39.90	2026-03-08 03:21:59.32258-03	1405
511	79.90	2026-03-08 03:22:08.323273-03	1408
512	64.90	2026-03-08 03:22:32.401342-03	1410
513	45.90	2026-03-08 03:22:45.665724-03	1411
514	109.90	2026-03-08 03:23:31.264844-03	1418
515	45.90	2026-03-08 03:24:11.181158-03	1417
516	45.90	2026-03-08 03:24:22.619048-03	1420
517	54.90	2026-03-08 03:25:21.965091-03	1424
518	159.90	2026-03-08 03:25:43.591963-03	1426
519	159.90	2026-03-08 03:25:53.247538-03	1429
520	159.90	2026-03-08 03:26:09.974431-03	1428
521	159.90	2026-03-08 03:28:34.742449-03	1438
522	99.90	2026-03-08 03:30:00.473999-03	1445
523	49.90	2026-03-08 03:32:40.976809-03	1459
524	79.90	2026-03-08 03:32:55.32356-03	1455
525	109.90	2026-03-08 03:33:35.687222-03	1464
526	99.90	2026-03-08 03:34:23.281474-03	1462
527	119.90	2026-03-08 03:35:02.910231-03	1466
528	23.90	2026-03-08 03:35:46.556556-03	1470
529	99.90	2026-03-08 03:36:12.501508-03	1472
530	79.90	2026-03-08 03:36:21.939247-03	1473
531	79.90	2026-03-08 03:36:32.094558-03	1474
532	79.90	2026-03-08 03:36:59.2524-03	1476
533	49.90	2026-03-08 04:18:43.156299-03	1486
534	45.90	2026-03-08 04:18:55.833136-03	1487
535	45.90	2026-03-08 04:19:12.350281-03	1488
536	45.90	2026-03-08 04:19:28.476397-03	1489
537	45.90	2026-03-08 04:19:54.5595-03	1491
538	45.90	2026-03-08 04:20:43.124149-03	1495
539	45.90	2026-03-08 04:20:57.613746-03	1496
540	38.90	2026-03-08 04:21:31.095097-03	1499
541	39.90	2026-03-08 04:22:11.542606-03	1503
542	29.90	2026-03-08 04:22:23.100134-03	1504
543	109.90	2026-03-08 05:19:37.563088-03	1515
544	109.90	2026-03-08 05:19:52.501309-03	1516
545	240.00	2026-03-08 05:20:21.986754-03	1519
546	240.00	2026-03-08 05:20:36.318059-03	1520
547	109.90	2026-03-08 05:20:51.662036-03	1522
548	168.00	2026-03-08 05:21:04.214568-03	1521
549	109.90	2026-03-08 05:21:18.150699-03	1523
550	45.90	2026-03-08 05:21:43.613933-03	1524
551	49.90	2026-03-08 05:23:08.457304-03	1531
552	47.90	2026-03-08 05:23:59.381921-03	1534
553	64.90	2026-03-08 05:25:16.34608-03	1544
554	283.90	2026-03-08 05:25:30.374305-03	1546
555	99.90	2026-03-08 05:25:58.417419-03	1543
556	64.90	2026-03-08 05:26:14.302626-03	1542
557	39.90	2026-03-08 05:26:38.897332-03	1551
558	34.90	2026-03-08 05:26:53.832837-03	1547
559	149.90	2026-03-08 05:27:15.186207-03	1549
560	99.90	2026-03-08 05:28:03.578617-03	1552
561	99.90	2026-03-08 05:28:28.221731-03	1554
562	99.90	2026-03-08 05:28:43.834162-03	1556
563	210.00	2026-03-08 05:28:52.687407-03	1560
564	39.90	2026-03-08 05:29:04.55849-03	1557
565	210.00	2026-03-08 05:29:25.696033-03	1559
566	140.00	2026-03-08 05:29:48.8297-03	1562
567	109.90	2026-03-08 05:30:18.997946-03	1566
568	109.90	2026-03-08 05:30:47.343924-03	1565
569	98.00	2026-03-08 05:30:59.209564-03	1567
570	109.90	2026-03-08 05:31:10.285156-03	1571
571	109.90	2026-03-08 05:31:24.263869-03	1568
572	45.90	2026-03-08 05:31:34.973577-03	1569
573	109.90	2026-03-08 05:31:45.517802-03	1570
574	340.00	2026-03-08 05:31:57.882546-03	1572
575	45.90	2026-03-08 05:32:12.207016-03	1575
576	109.90	2026-03-08 05:32:22.224852-03	1577
577	109.90	2026-03-08 05:32:36.373072-03	1573
578	45.90	2026-03-08 05:32:52.494962-03	1574
579	45.90	2026-03-08 05:33:07.244009-03	1576
580	59.90	2026-03-08 05:33:16.587735-03	1578
581	250.00	2026-03-08 05:33:25.934781-03	1579
582	250.00	2026-03-08 05:33:38.910053-03	1580
583	134.90	2026-03-08 05:34:06.031298-03	1582
584	159.90	2026-03-08 05:34:16.677034-03	1584
585	119.90	2026-03-08 05:34:32.95445-03	1583
586	159.90	2026-03-08 05:34:57.873029-03	1586
587	93.00	2026-03-08 05:35:14.69244-03	1587
588	159.90	2026-03-08 05:35:30.543902-03	1588
589	159.90	2026-03-08 05:35:46.719877-03	1590
590	159.90	2026-03-08 05:35:57.70366-03	1589
591	159.90	2026-03-08 05:36:13.984064-03	1591
592	159.90	2026-03-08 05:36:27.523697-03	1595
593	159.90	2026-03-08 05:36:39.802069-03	1592
594	159.90	2026-03-08 05:36:51.257118-03	1593
595	159.90	2026-03-08 05:37:04.365245-03	1594
596	119.90	2026-03-08 05:37:15.292906-03	1600
597	119.90	2026-03-08 05:37:27.509791-03	1596
598	119.90	2026-03-08 05:37:40.199239-03	1598
599	119.90	2026-03-08 05:37:51.67788-03	1599
600	90.00	2026-03-08 05:38:03.757245-03	1597
601	408.00	2026-03-08 06:20:19.5083-03	1612
602	306.00	2026-03-08 06:22:09.17981-03	1621
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
748	Pó Compacto Matte Faces 6,5g	\N	8848	Maquiagem	Pó Compacto Matte Faces 6,5g\nRef: 8848	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8e41080b/Produtos/NATBRA-8848_1.jpg	5	0.00	0.00	2026-03-07 15:10:20.284473-03	2026-02-27 20:02:02.267918-03
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
714	Presente Natura Erva Doce Sabonetes em Barra	\N	155896	Corpo e Banho	Presente Natura Erva Doce Sabonetes em Barra\nRef: 155896	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw80eecaf5/produto-joia/background/desktop/155896.jpg	5	0.00	0.00	2026-03-07 15:01:52.923251-03	2026-02-27 20:01:54.852618-03
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
327	Sabonete em Espuma Relaxante Mamãe e Bebê	\N	92952	Corpo e Banho	Sabonete em Espuma Relaxante Mamãe e Bebê\nRef: 92952	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3a7170cb/produto-joia/background/desktop/92952.jpg	5	59.90	59.90	2026-03-07 12:49:01.080291-03	2026-02-27 19:58:57.761679-03
331	Refil Creme Antissinais 70+ Noite	\N	134590	Corpo e Banho	Refil Creme Antissinais 70+ Noite\nRef: 134590	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4f31dc57/produto-joia/background/desktop/134590.jpg	5	124.00	124.00	2026-03-07 12:50:00.803665-03	2026-02-27 19:58:57.769765-03
328	Óleo Desodorante Corporal Sève Amêndoas Doces Intensa	\N	38854	Corpo e Banho	Óleo Desodorante Corporal Sève Amêndoas Doces Intensa\nRef: 38854	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0c6fdc0e/produto-joia/background/desktop/38854.jpg	5	116.90	116.90	2026-03-07 12:50:23.793898-03	2026-02-27 19:58:57.763423-03
715	Sabonete Líquido para o Corpo Ekos Maracujá	\N	70410	Corpo e Banho	Sabonete Líquido para o Corpo Ekos Maracujá\nRef: 70410	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7ebd7675/produto-joia/background/desktop/70410.jpg	5	55.90	55.90	2026-03-07 15:02:23.107815-03	2026-02-27 20:01:54.852618-03
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
350	Shampoo Hidratante Tododia Maçã Verde e Aloe Vera 300 ml	\N	154866	Cabelos	Shampoo Hidratante Tododia Maçã Verde e Aloe Vera 300 ml\nRef: 154866	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6bea2007/produto-joia/background/desktop/154866.jpg	5	0.00	0.00	2026-03-07 12:50:35.65068-03	2026-02-27 19:59:04.632944-03
351	Refil Desodorante Corporal Essencial Exclusivo Feminino	\N	155604	Corpo e Banho	Refil Desodorante Corporal Essencial Exclusivo Feminino\nRef: 155604	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw66eb3c29/NATBRA-155604_1.jpg	5	0.00	0.00	2026-03-07 12:51:22.608995-03	2026-02-27 19:59:04.635655-03
356	Kaiak Oceano Feminino 100 ml	\N	108410	Geral	Kaiak Oceano Feminino 100 ml\nRef: 108410	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0ab4cc77/produto-joia/background/desktop/108410.jpg	5	0.00	0.00	2026-03-07 12:51:47.192509-03	2026-02-27 19:59:04.648577-03
358	Condicionador Fortificante Antiqueda e Crescimento	\N	147444	Cabelos	Condicionador Fortificante Antiqueda e Crescimento\nRef: 147444	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7114e0c4/produto-joia/background/desktop/147444.jpg	5	0.00	0.00	2026-03-07 12:52:34.699317-03	2026-02-27 19:59:04.65199-03
455	Produto 167330	\N	167330	Geral	Descoberto em Todos os Produtos (Pág 24)	\N	5	0.00	\N	2026-02-27 19:59:51.987801-03	2026-02-27 19:59:51.987801-03
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
451	Batom Multimix Cremoso Faces	\N	116195	Maquiagem	Batom Multimix Cremoso Faces\nRef: 116195	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw000194ec/produto-joia/background/desktop/PAI116187.jpg	5	23.90	23.90	2026-03-07 12:53:50.720673-03	2026-02-27 19:59:51.979487-03
457	Kit Reconstrução de Danos Lumina	\N	194396	Geral	Kit Reconstrução de Danos Lumina\nRef: 194396	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9a312a1e/NATBRA-194396_1.jpg	5	0.00	0.00	2026-03-07 12:54:30.456834-03	2026-02-27 19:59:51.995033-03
461	Sabonete em Barra Puro Vegetal Cremoso Ekos	\N	134575	Corpo e Banho	Sabonete em Barra Puro Vegetal Cremoso Ekos\nRef: 134575	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw36311d44/produto-joia/background/desktop/134575.jpg	5	45.90	45.90	2026-03-07 12:55:10.844691-03	2026-02-27 19:59:51.995773-03
478	Produto 124202	\N	124202	Geral	Descoberto em Todos os Produtos (Pág 25)	\N	5	0.00	\N	2026-02-27 19:59:59.586347-03	2026-02-27 19:59:59.586347-03
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
475	Refil Óleo Trifásico Desodorante Corporal Ekos Castanha	\N	187608	Corpo e Banho	Refil Óleo Trifásico Desodorante Corporal Ekos Castanha\nRef: 187608	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbe9b03c6/produto-joia/background/desktop/187608.jpg	5	0.00	0.00	2026-03-07 12:55:49.432014-03	2026-02-27 19:59:59.577998-03
476	Essencial Ato Masculino 100 ml	\N	114584	Homem	Essencial Ato Masculino 100 ml\nRef: 114584	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5055cc60/produto-joia/background/desktop/114584.jpg	5	279.90	279.90	2026-03-07 12:56:11.148735-03	2026-02-27 19:59:59.586347-03
480	Natura Homem Nós 100 ml	\N	152280	Homem	Natura Homem Nós 100 ml\nRef: 152280	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw590b0b3a/produto-joia/background/desktop/152280.jpg	5	0.00	0.00	2026-03-07 12:56:53.955901-03	2026-02-27 19:59:59.586347-03
483	Luna Divina 75 ml	\N	171364	Geral	Luna Divina 75 ml\nRef: 171364	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb012efd1/produto-joia/background/desktop/171364.jpg	5	0.00	0.00	2026-03-07 12:57:26.366103-03	2026-02-27 19:59:59.594857-03
717	Ekos Ryo Vivo 75 ml	\N	133865	Geral	Ekos Ryo Vivo 75 ml\nRef: 133865	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1875e0db/produto-joia/background/desktop/133865.jpg	5	0.00	0.00	2026-03-07 15:02:53.413269-03	2026-02-27 20:01:54.852618-03
536	Produto 160237	\N	160237	Geral	Descoberto em Todos os Produtos (Pág 31)	\N	5	0.00	\N	2026-02-27 20:00:48.587781-03	2026-02-27 20:00:48.587781-03
569	Produto 106294	\N	106294	Geral	Descoberto em Todos os Produtos (Pág 32)	\N	5	0.00	\N	2026-02-27 20:00:57.010999-03	2026-02-27 20:00:57.010999-03
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
576	Refil Difusor de Ambientes Erva Doce Casa	\N	171109	Geral	Refil Difusor de Ambientes Erva Doce Casa\nRef: 171109	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3e9f37e2/produto-joia/background/desktop/171109.jpg	5	83.90	83.90	2026-03-07 12:58:19.540298-03	2026-02-27 20:01:05.227105-03
577	Protetor Solar Corporal FPS 30 Natura Solar	\N	182087	Geral	Protetor Solar Corporal FPS 30 Natura Solar\nRef: 182087	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc6d30682/produto-joia/background/desktop/182087.jpg	5	129.90	129.90	2026-03-07 12:58:41.053748-03	2026-02-27 20:01:05.227105-03
718	Sabonete em Barra Puro Vegetal Tododia Ameixa e Flor de Baunilha	\N	100535	Corpo e Banho	Sabonete em Barra Puro Vegetal Tododia Ameixa e Flor de Baunilha\nRef: 100535	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw75f248a6/produto-joia/background/desktop/100535.jpg	5	0.00	0.00	2026-03-07 15:03:11.668404-03	2026-02-27 20:01:54.86094-03
586	Produto 96518	\N	96518	Geral	Descoberto em Todos os Produtos (Pág 33)	\N	5	0.00	\N	2026-02-27 20:01:05.243156-03	2026-02-27 20:01:05.243156-03
632	Produto 148443	\N	148443	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.707478-03	2026-02-27 20:01:21.707478-03
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
581	Sabonete Líquido Corporal Ekos Andiroba	\N	70406	Corpo e Banho	Sabonete Líquido Corporal Ekos Andiroba\nRef: 70406	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw300b70b8/produto-joia/background/desktop/70406.jpg	5	55.90	55.90	2026-03-07 12:59:30.755986-03	2026-02-27 20:01:05.234546-03
602	Kit Gel para Barbear e Balm Pós-barba Natura Homem (2 produtos)	\N	219717	Maquiagem	Kit Gel para Barbear e Balm Pós-barba Natura Homem (2 produtos)\nRef: 219717	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1f080abd/produto-joia/background/desktop/219717.jpg	5	0.00	0.00	2026-03-07 13:00:34.099705-03	2026-02-27 20:01:12.89864-03
605	Máscara para Cílios Multi HD Una 9 g	\N	174921	Cabelos	Máscara para Cílios Multi HD Una 9 g\nRef: 174921	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe3de4e10/produto-joia/background/desktop/174921.jpg	5	116.90	116.90	2026-03-07 13:01:22.483272-03	2026-02-27 20:01:12.906012-03
607	Kit Tododia Jambo Rosa e Flor de Caju (2 produtos)	\N	211152	Geral	Kit Tododia Jambo Rosa e Flor de Caju (2 produtos)\nRef: 211152	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd8539089/produto-joia/background/desktop/211152.jpg	5	0.00	0.00	2026-03-07 13:01:45.827125-03	2026-02-27 20:01:12.911211-03
610	Gloss Labial Volume Imediato Una Incolor	\N	164824	Geral	Gloss Labial Volume Imediato Una Incolor\nRef: 164824	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7d5fc7f7/produto-joia/background/desktop/164824.jpg	5	59.90	59.90	2026-03-07 13:02:21.516734-03	2026-02-27 20:01:12.917526-03
612	Base Stick FPS 50 Una	\N	181515	Maquiagem	Base Stick FPS 50 Una\nRef: 181515	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw81bd8b21/produto-joia/background/desktop/181515.jpg	5	119.90	119.90	2026-03-07 13:02:50.730377-03	2026-02-27 20:01:12.922532-03
614	Batom Multimix Cremoso Faces	\N	116188	Maquiagem	Batom Multimix Cremoso Faces\nRef: 116188	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw000194ec/produto-joia/background/desktop/PAI116187.jpg	5	23.90	23.90	2026-03-07 13:03:15.166019-03	2026-02-27 20:01:12.926864-03
617	Caneta Delineadora para Olhos Preta Faces	\N	65830	Maquiagem	Caneta Delineadora para Olhos Preta Faces\nRef: 65830	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb8e662a2/produto-joia/background/desktop/65830.jpg	5	44.90	44.90	2026-03-07 13:03:53.034826-03	2026-02-27 20:01:12.93187-03
620	Tônico Capilar Antiqueda Natura Homem	\N	145489	Homem	Tônico Capilar Antiqueda Natura Homem\nRef: 145489	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5ad653a2/produto-joia/background/desktop/145489.jpg	5	90.90	90.90	2026-03-07 13:04:29.853896-03	2026-02-27 20:01:12.940272-03
621	Gel Secativo de Espinhas Seca+ Faces	\N	166351	Geral	Gel Secativo de Espinhas Seca+ Faces\nRef: 166351	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc346e351/produto-joia/background/desktop/166351.jpg	5	35.90	35.90	2026-03-07 13:05:09.48256-03	2026-02-27 20:01:21.682545-03
624	Kit Refis Shampoo e Condicionador Lumina Antioleosidade (2 produtos)	\N	208771	Cabelos	Kit Refis Shampoo e Condicionador Lumina Antioleosidade (2 produtos)\nRef: 208771	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc121b72e/produto-joia/background/desktop/208771.jpg	5	0.00	0.00	2026-03-07 13:05:32.384498-03	2026-02-27 20:01:21.690859-03
631	Presente Natura Kaiak Masculino (4 produtos)	\N	239726	Homem	Presente Natura Kaiak Masculino (4 produtos)\nRef: 239726	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb8ed6810/produto-joia/background/desktop/239726.jpg	5	0.00	0.00	2026-03-07 13:06:11.496814-03	2026-02-27 20:01:21.706472-03
629	Máscara Antissinais Regenerador Capilar Lumina	\N	174196	Cabelos	Máscara Antissinais Regenerador Capilar Lumina\nRef: 174196	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1ebbb0b7/produto-joia/background/desktop/174196.jpg	5	79.90	79.90	2026-03-07 13:06:40.557966-03	2026-02-27 20:01:21.699175-03
639	Produto 167289	\N	167289	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.723207-03	2026-02-27 20:01:21.724218-03
720	Kaiak O2 Masculino 100 ml	\N	125949	Homem	Kaiak O2 Masculino 100 ml\nRef: 125949	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfcdc9b35/produto-joia/background/desktop/125949.jpg	5	189.90	189.90	2026-03-07 15:03:33.073847-03	2026-02-27 20:01:54.86094-03
641	Produto 187996	\N	187996	Geral	Descoberto em Todos os Produtos (Pág 35)	\N	5	0.00	\N	2026-02-27 20:01:21.724218-03	2026-02-27 20:01:21.724218-03
658	Produto 189563	\N	189563	Geral	Descoberto em Todos os Produtos (Pág 36)	\N	5	0.00	\N	2026-02-27 20:01:30.489701-03	2026-02-27 20:01:30.489701-03
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
643	Desodorante Antitranspirante Roll-on Kaiak Urbe Masculino	\N	189398	Corpo e Banho	Desodorante Antitranspirante Roll-on Kaiak Urbe Masculino\nRef: 189398	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe80b3411/produto-joia/background/desktop/189398.jpg	5	29.90	29.90	2026-03-07 13:50:10.186-03	2026-02-27 20:01:30.456841-03
647	Kit Tododia Hidratação (2 produtos)	\N	194393	Geral	Kit Tododia Hidratação (2 produtos)\nRef: 194393	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw09006fe1/Produtos/NATBRA-194393_1.jpg	5	0.00	0.00	2026-03-07 13:50:59.733578-03	2026-02-27 20:01:30.465089-03
649	Refil Sérum Intensivo Lifting e Firmeza Chronos Derma	\N	168819	Geral	Refil Sérum Intensivo Lifting e Firmeza Chronos Derma\nRef: 168819	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwed67fa9f/produto-joia/background/desktop/168819.jpg	5	136.00	136.00	2026-03-07 13:51:23.600202-03	2026-02-27 20:01:30.473516-03
652	Sabonete Líquido em Gel Tododia Noz Pecã e Cacau	\N	86180	Corpo e Banho	Sabonete Líquido em Gel Tododia Noz Pecã e Cacau\nRef: 86180	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3c8845f2/produto-joia/background/desktop/86180.jpg	5	50.90	50.90	2026-03-07 13:51:59.519458-03	2026-02-27 20:01:30.480225-03
653	Ekos Frescor Maracujá Natureza dos Sonhos 150 ml	\N	222447	Geral	Ekos Frescor Maracujá Natureza dos Sonhos 150 ml\nRef: 222447	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw724fefae/produto-joia/background/desktop/222447.jpg	5	0.00	0.00	2026-03-07 13:52:34.837261-03	2026-02-27 20:01:30.481235-03
657	Leave-In Matizador para Restauração	\N	148450	Geral	Leave-In Matizador para Restauração\nRef: 148450	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc5512e69/produto-joia/background/desktop/148450.jpg	5	0.00	0.00	2026-03-07 13:53:15.586222-03	2026-02-27 20:01:30.489701-03
671	Gel 2 em 1 para Barbear e Pós Barba Kaiak	\N	115886	Maquiagem	Gel 2 em 1 para Barbear e Pós Barba Kaiak\nRef: 115886	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw87cd7841/produto-joia/background/desktop/115886.jpg	5	0.00	0.00	2026-03-07 14:51:35.967968-03	2026-02-27 20:01:38.780747-03
673	Kit Mamãe e Bebê com Mala Maternidade (6 produtos)	\N	197576	Infantil	Kit Mamãe e Bebê com Mala Maternidade (6 produtos)\nRef: 197576	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw273685f1/produto-joia/background/desktop/197576.jpg	5	495.90	495.90	2026-03-07 14:52:02.548519-03	2026-02-27 20:01:38.788466-03
676	Refil Desodorante Hidratante Corporal Luna Confiante	\N	102420	Corpo e Banho	Refil Desodorante Hidratante Corporal Luna Confiante\nRef: 102420	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2fe7aa7a/produto-joia/background/desktop/102420.jpg	5	66.90	66.90	2026-03-07 14:52:47.731361-03	2026-02-27 20:01:38.788466-03
678	Refil Sabonete Líquido Corporal Ekos Andiroba	\N	70393	Corpo e Banho	Refil Sabonete Líquido Corporal Ekos Andiroba\nRef: 70393	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd1da0a72/NATBRA-70393_1.jpg	5	40.60	40.60	2026-03-07 14:53:27.290641-03	2026-02-27 20:01:38.796706-03
682	Kit Desodorante Antitranspirante em Creme Tododia Leite de Algodão (3 unidades)	\N	229956	Corpo e Banho	Kit Desodorante Antitranspirante em Creme Tododia Leite de Algodão (3 unidades)\nRef: 229956	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf6ad54fb/produto-joia/background/desktop/229956.jpg	5	0.00	0.00	2026-03-07 14:54:10.674789-03	2026-02-27 20:01:38.804027-03
684	Refil Pó Compacto Matte Faces 6,5g	\N	9009	Maquiagem	Refil Pó Compacto Matte Faces 6,5g\nRef: 9009	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7bdb561f/Produtos/NATBRA-9009_1.jpg	5	49.90	49.90	2026-03-07 14:54:42.416248-03	2026-02-27 20:01:38.805109-03
687	Batom Matte Intransferível Una 8ml	\N	167329	Maquiagem	Batom Matte Intransferível Una 8ml\nRef: 167329	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw999dd2d0/produto-joia/background/desktop/167329.jpg	5	64.90	64.90	2026-03-07 14:55:25.556974-03	2026-02-27 20:01:38.813542-03
688	Refil Essencial Feminino 100 ml	\N	7978	Geral	Refil Essencial Feminino 100 ml\nRef: 7978	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw12260fa5/produto-joia/background/desktop/7978.jpg	5	0.00	0.00	2026-03-07 14:55:54.495152-03	2026-02-27 20:01:38.813542-03
692	Natura Homem Sagaz Miniatura 25 ml	\N	103976	Homem	Natura Homem Sagaz Miniatura 25 ml\nRef: 103976	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3dd985e3/produto-joia/background/desktop/103976.jpg	5	0.00	0.00	2026-03-07 14:56:31.387765-03	2026-02-27 20:01:46.479469-03
694	Óleo Trifásico Desodorante Corporal Ekos Castanha	\N	174337	Corpo e Banho	Óleo Trifásico Desodorante Corporal Ekos Castanha\nRef: 174337	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc6d5aa4e/produto-joia/background/desktop/174337.jpg	5	0.00	0.00	2026-03-07 14:57:00.810368-03	2026-02-27 20:01:46.483466-03
716	Kit Ekos Andiroba Creme e Óleo Trifásico para o Corpo	\N	239988	Corpo e Banho	Kit Ekos Andiroba Creme e Óleo Trifásico para o Corpo\nRef: 239988	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw857816fc/produto-joia/background/desktop/239988.jpg	5	0.00	0.00	2026-03-07 15:02:37.792469-03	2026-02-27 20:01:54.852618-03
719	Desodorante Antitranspirante Roll-On Natura Homem Tato	\N	150222	Corpo e Banho	Desodorante Antitranspirante Roll-On Natura Homem Tato\nRef: 150222	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9e333bec/produto-joia/background/desktop/150222.jpg	5	29.90	29.90	2026-03-07 15:03:22.764822-03	2026-02-27 20:01:54.86094-03
722	Kit Naturé Colônia Pula Pula, Sabonete em Barra e Hidratante (3 produtos)	\N	218206	Perfumaria	Kit Naturé Colônia Pula Pula, Sabonete em Barra e Hidratante (3 produtos)\nRef: 218206	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7e78dc6c/produto-joia/background/desktop/218206.jpg	5	0.00	0.00	2026-03-07 15:04:01.872055-03	2026-02-27 20:01:54.86094-03
724	Copo Térmico Crer Para Ver	\N	187122	Geral	Copo Térmico Crer Para Ver\nRef: 187122	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9b78abc9/NATBRA-187122_1.jpg	5	0.00	0.00	2026-03-07 15:04:24.3472-03	2026-02-27 20:01:54.869336-03
727	Sabonete Líquido para Mãos Ekos Castanha	\N	70402	Corpo e Banho	Sabonete Líquido para Mãos Ekos Castanha\nRef: 70402	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwae04d715/produto-joia/background/desktop/70402.jpg	5	69.90	69.90	2026-03-07 15:05:21.945043-03	2026-02-27 20:01:54.876595-03
704	Produto 97174	\N	97174	Geral	Descoberto em Todos os Produtos (Pág 38)	\N	5	0.00	\N	2026-02-27 20:01:46.501851-03	2026-02-27 20:01:46.501851-03
730	Base Stick FPS 50 Una	\N	181513	Maquiagem	Base Stick FPS 50 Una\nRef: 181513	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw22717184/produto-joia/background/desktop/181513.jpg	5	119.90	119.90	2026-03-07 15:05:55.016556-03	2026-02-27 20:01:54.877606-03
732	Kit Desodorante Antitranspirante em Creme Tododia Macadâmia (3 unidades)	\N	221673	Corpo e Banho	Kit Desodorante Antitranspirante em Creme Tododia Macadâmia (3 unidades)\nRef: 221673	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfc97114d/produto-joia/background/desktop/221673.jpg	5	0.00	0.00	2026-03-07 15:06:23.308629-03	2026-02-27 20:01:54.886049-03
735	Refil Shampoo 2 em 1 Naturé	\N	102407	Cabelos	Refil Shampoo 2 em 1 Naturé\nRef: 102407	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf4580779/produto-joia/background/desktop/102407.jpg	5	35.90	35.90	2026-03-07 15:07:03.369957-03	2026-02-27 20:01:54.886049-03
738	Kit Condicionador Antiqueda e Crescimento Lumina com Refil	\N	244487	Cabelos	Kit Condicionador Antiqueda e Crescimento Lumina com Refil\nRef: 244487	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa0620b51/produto-joia/background/desktop/244487.jpg	5	0.00	0.00	2026-03-07 15:07:54.06429-03	2026-02-27 20:02:02.251826-03
741	Kit Kaiak Feminino Completo (4 produtos)	\N	217164	Geral	Kit Kaiak Feminino Completo (4 produtos)\nRef: 217164	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5ef56121/produto-joia/background/desktop/217164.jpg	5	0.00	0.00	2026-03-07 15:08:34.554461-03	2026-02-27 20:02:02.259582-03
1550	Desodorante Antitranspirante Roll-On Kaiak Oceano Masculino	\N	109839	Corpo e Banho	Desodorante Antitranspirante Roll-On Kaiak Oceano Masculino\nRef: 109839	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1c64ce42/NATBRA-109839_1.jpg	5	0.00	0.00	2026-03-08 05:27:29.780559-03	2026-02-27 20:07:18.920299-03
736	Produto 92550	\N	92550	Geral	Descoberto em Todos os Produtos (Pág 39)	\N	5	0.00	\N	2026-02-27 20:01:54.886049-03	2026-02-27 20:01:54.893238-03
744	Produto 166358	\N	166358	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.259582-03	2026-02-27 20:02:02.259582-03
750	Produto 91192	\N	91192	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.27628-03	2026-02-27 20:02:02.27628-03
751	Produto 114277	\N	114277	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.27628-03	2026-02-27 20:02:02.27628-03
752	Produto 155606	\N	155606	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.27628-03	2026-02-27 20:02:02.27628-03
753	Produto 218196	\N	218196	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.27628-03	2026-02-27 20:02:02.27628-03
754	Produto 243055	\N	243055	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.27628-03	2026-02-27 20:02:02.284581-03
699	Base Sérum Nude Me Una	\N	110182	Maquiagem	Base Sérum Nude Me Una\nRef: 110182	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw59119830/Produtos/NATBRA-110182_1.jpg	5	0.00	0.00	2026-03-07 14:58:11.947417-03	2026-02-27 20:01:46.493621-03
702	Calcinha Absorvente Instituto Natura + Pantys	\N	228005	Geral	Calcinha Absorvente Instituto Natura + Pantys\nRef: 228005	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1cd65378/produto-joia/background/desktop/228005.jpg	5	57.00	57.00	2026-03-07 14:58:52.184383-03	2026-02-27 20:01:46.498857-03
705	Ekos Ryo Festa 75 ml	\N	150192	Geral	Ekos Ryo Festa 75 ml\nRef: 150192	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw658b5e96/produto-joia/background/desktop/150192.jpg	5	0.00	0.00	2026-03-07 14:59:41.875247-03	2026-02-27 20:01:46.504114-03
708	Refil Máscara Reparadora para Nutrição e Reparação Profunda	\N	147447	Cabelos	Refil Máscara Reparadora para Nutrição e Reparação Profunda\nRef: 147447	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw28228e63/produto-joia/background/desktop/147447.jpg	5	59.90	59.90	2026-03-07 15:00:32.824758-03	2026-02-27 20:01:46.510113-03
711	Ekos Frescor Açaí 75 ml	\N	174913	Geral	Ekos Frescor Açaí 75 ml\nRef: 174913	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe003f49a/produto-joia/background/desktop/174913.jpg	5	0.00	0.00	2026-03-07 15:01:10.921081-03	2026-02-27 20:01:46.515475-03
713	Condicionador Protetor Lumina para Hidratação e Proteção Antipoluição	\N	147446	Cabelos	Condicionador Protetor Lumina para Hidratação e Proteção Antipoluição\nRef: 147446	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc35e1c95/produto-joia/background/desktop/147446.jpg	5	0.00	0.00	2026-03-07 15:01:39.108397-03	2026-02-27 20:01:54.844308-03
745	Ekos Frescor Pitanga 75 ml	\N	194529	Geral	Ekos Frescor Pitanga 75 ml\nRef: 194529	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw53c8bf03/produto-joia/background/desktop/194529.jpg	5	0.00	0.00	2026-03-07 15:09:31.998483-03	2026-02-27 20:02:02.267918-03
747	Kit Shampoo e Condicionador Lumina Força e Reparação Molecular (2 produtos)	\N	208137	Cabelos	Kit Shampoo e Condicionador Lumina Força e Reparação Molecular (2 produtos)\nRef: 208137	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd60f75ea/produto-joia/background/desktop/208137.jpg	5	0.00	0.00	2026-03-07 15:10:04.797515-03	2026-02-27 20:02:02.267918-03
755	Produto 134197	\N	134197	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.284581-03	2026-02-27 20:02:02.284581-03
756	Produto 239795	\N	239795	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.284581-03	2026-02-27 20:02:02.284581-03
757	Produto 235590	\N	235590	Geral	Descoberto em Todos os Produtos (Pág 40)	\N	5	0.00	\N	2026-02-27 20:02:02.284581-03	2026-02-27 20:02:02.284581-03
1555	Base Sérum Nude Me Una	\N	110198	Maquiagem	Base Sérum Nude Me Una\nRef: 110198	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcd0d6180/Produtos/NATBRA-110198_1.jpg	5	0.00	0.00	2026-03-08 05:27:51.150718-03	2026-02-27 20:07:18.928763-03
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
760	Máscara de Argila Purificante Chronos	\N	69724	Cabelos	Máscara de Argila Purificante Chronos\nRef: 69724	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7362aa76/NATBRA-69724_1.jpg	5	0.00	0.00	2026-03-07 15:53:01.273452-03	2026-02-27 20:02:02.29295-03
763	Refil Shampoo Cachos e Crespos Tododia Amora e Óleo de Coco	\N	173585	Cabelos	Refil Shampoo Cachos e Crespos Tododia Amora e Óleo de Coco\nRef: 173585	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb262746a/produto-joia/background/desktop/173585.jpg	5	0.00	0.00	2026-03-07 15:53:42.776111-03	2026-02-27 20:02:09.503846-03
767	Desodorante Antitranspirante Roll-On Natura Homem Sem Perfume	\N	150223	Perfumaria	Desodorante Antitranspirante Roll-On Natura Homem Sem Perfume\nRef: 150223	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw39072f20/produto-joia/background/desktop/150223.jpg	5	29.90	29.90	2026-03-07 15:54:47.384921-03	2026-02-27 20:02:09.511091-03
769	Esfoliante Térmico Ekos Andiroba	\N	162090	Geral	Esfoliante Térmico Ekos Andiroba\nRef: 162090	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa69b21e1/produto-joia/background/desktop/162090.jpg	5	89.90	89.90	2026-03-07 15:55:15.100228-03	2026-02-27 20:02:09.514091-03
771	Kit Natura Homem Especiarias e Aromáticos	\N	256331	Homem	Kit Natura Homem Especiarias e Aromáticos\nRef: 256331	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw191643b3/produto-joia/background/desktop/256331.jpg	5	0.00	0.00	2026-03-07 15:55:40.963793-03	2026-02-27 20:02:09.51737-03
774	Refil Shampoo Hidratante para Definição e Nutrição de Cabelos Crespos	\N	148169	Cabelos	Refil Shampoo Hidratante para Definição e Nutrição de Cabelos Crespos\nRef: 148169	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw70af256b/produto-joia/background/desktop/148169.jpg	5	0.00	0.00	2026-03-07 15:56:31.064671-03	2026-02-27 20:02:09.523404-03
788	Luna Absoluta Miniatura 25 ml	\N	194224	Geral	Luna Absoluta Miniatura 25 ml\nRef: 194224	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc8a0b2a6/produto-joia/background/desktop/194224.jpg	5	0.00	0.00	2026-03-07 16:57:10.897748-03	2026-02-27 20:02:16.782702-03
791	Delineador Matte Peel Off Una	\N	95757	Maquiagem	Delineador Matte Peel Off Una\nRef: 95757	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5d8c7d1c/produto-joia/background/desktop/95757.jpg	5	0.00	0.00	2026-03-07 16:57:40.594571-03	2026-02-27 20:02:16.789985-03
792	Condicionador Ekos Patauá	\N	113245	Cabelos	Condicionador Ekos Patauá\nRef: 113245	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc00552b4/produto-joia/background/desktop/113245.jpg	5	0.00	0.00	2026-03-07 16:57:56.450082-03	2026-02-27 20:02:16.790724-03
795	Base Sérum Nude Me Una	\N	110185	Maquiagem	Base Sérum Nude Me Una\nRef: 110185	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw59e53e5d/Produtos/NATBRA-110185_1.jpg	5	0.00	0.00	2026-03-07 16:58:41.203621-03	2026-02-27 20:02:16.790724-03
798	Esfoliante Nutritivo Tododia Jambo Rosa e Flor de Caju	\N	172099	Geral	Esfoliante Nutritivo Tododia Jambo Rosa e Flor de Caju\nRef: 172099	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwafe4df6c/produto-joia/background/desktop/172099.jpg	5	0.00	0.00	2026-03-07 16:59:25.961854-03	2026-02-27 20:02:16.799127-03
800	Corretivo Cobertura Extrema 24h Una 8ml	\N	122115	Maquiagem	Corretivo Cobertura Extrema 24h Una 8ml\nRef: 122115	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe04ee797/produto-joia/background/desktop/PAI122122.jpg	5	0.00	0.00	2026-03-07 16:59:55.264886-03	2026-02-27 20:02:16.799127-03
802	Batom Multimix Cremoso Faces	\N	116198	Maquiagem	Batom Multimix Cremoso Faces\nRef: 116198	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw000194ec/produto-joia/background/desktop/PAI116187.jpg	5	23.90	23.90	2026-03-07 17:00:12.875104-03	2026-02-27 20:02:16.807381-03
805	Refil Essencial Masculino 100 ml	\N	7977	Homem	Refil Essencial Masculino 100 ml\nRef: 7977	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw88650fda/produto-joia/background/desktop/7977.jpg	5	0.00	0.00	2026-03-07 17:00:47.899183-03	2026-02-27 20:02:16.807381-03
807	Corretivo Cobertura Extrema 24h Una 8ml	\N	122121	Maquiagem	Corretivo Cobertura Extrema 24h Una 8ml\nRef: 122121	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe04ee797/produto-joia/background/desktop/PAI122122.jpg	5	0.00	0.00	2026-03-07 17:01:14.840042-03	2026-02-27 20:02:16.815778-03
810	Kit Creme Desodorante Nutritivo para o Corpo Tododia Algodão com Refil	\N	231708	Corpo e Banho	Kit Creme Desodorante Nutritivo para o Corpo Tododia Algodão com Refil\nRef: 231708	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6ba02b71/produto-joia/background/desktop/231708.jpg	5	0.00	0.00	2026-03-07 17:01:59.731613-03	2026-02-27 20:02:24.548476-03
1553	Base Sérum Nude Me Una	\N	110196	Maquiagem	Base Sérum Nude Me Una\nRef: 110196	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbbe69c9f/Produtos/NATBRA-110196_1.jpg	5	0.00	0.00	2026-03-08 05:28:15.879476-03	2026-02-27 20:07:18.928763-03
821	Produto 170806	\N	170806	Geral	Descoberto em Todos os Produtos (Pág 43)	\N	5	0.00	\N	2026-02-27 20:02:24.57208-03	2026-02-27 20:02:24.573049-03
869	Produto 55105	\N	55105	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.761668-03	2026-02-27 20:02:45.761668-03
870	Produto 2271	\N	2271	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.761668-03	2026-02-27 20:02:45.761668-03
816	Kit Sabonete Cremoso para as Mãos Erva Doce com Refil (2 produtos)	\N	213205	Corpo e Banho	Kit Sabonete Cremoso para as Mãos Erva Doce com Refil (2 produtos)\nRef: 213205	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw82d4a90e/produto-joia/background/desktop/213205.jpg	5	0.00	0.00	2026-03-07 17:03:15.608417-03	2026-02-27 20:02:24.563751-03
819	Kit Natura Homem Sagaz (3 produtos)	\N	217174	Homem	Kit Natura Homem Sagaz (3 produtos)\nRef: 217174	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwafb4e0d2/produto-joia/background/desktop/217174.jpg	5	0.00	0.00	2026-03-07 17:03:49.700532-03	2026-02-27 20:02:24.568733-03
823	Refil Máscara Força e Reparação Molecular	\N	164506	Cabelos	Refil Máscara Força e Reparação Molecular\nRef: 164506	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd8a8238f/produto-joia/background/desktop/164506.jpg	5	59.90	59.90	2026-03-07 17:04:32.785833-03	2026-02-27 20:02:24.573049-03
825	Essencial Miniatura Masculino 25 ml	\N	131411	Homem	Essencial Miniatura Masculino 25 ml\nRef: 131411	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwac2a380f/produto-joia/background/desktop/131411.jpg	5	114.90	114.90	2026-03-07 17:05:06.676482-03	2026-02-27 20:02:24.578629-03
827	Difusor Natura 861 Guaiaco Pataqueira 200 ml	\N	159122	Geral	Difusor Natura 861 Guaiaco Pataqueira 200 ml\nRef: 159122	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf6e045bf/produto-joia/background/desktop/159122.jpg	5	230.00	230.00	2026-03-07 17:05:30.145916-03	2026-02-27 20:02:24.581502-03
830	Frasco Vazio Difusor de Ambientes Erva Doce Casa	\N	171127	Geral	Frasco Vazio Difusor de Ambientes Erva Doce Casa\nRef: 171127	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa002fdad/Produtos/NATBRA-171127_1.jpg	5	0.00	0.00	2026-03-07 17:06:07.642612-03	2026-02-27 20:02:24.589733-03
831	Desodorante Hidratante Ekos Açaí	\N	174594	Corpo e Banho	Desodorante Hidratante Ekos Açaí\nRef: 174594	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb5be76b0/produto-joia/background/desktop/174594.jpg	5	0.00	0.00	2026-03-07 17:06:36.148015-03	2026-02-27 20:02:24.589733-03
835	Kit Kaiak Feminino com Desodorante Roll-on (2 produtos)	\N	217163	Corpo e Banho	Kit Kaiak Feminino com Desodorante Roll-on (2 produtos)\nRef: 217163	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc26ee71b/produto-joia/background/desktop/217163.jpg	5	0.00	0.00	2026-03-07 17:07:08.249343-03	2026-02-27 20:02:31.747092-03
838	Refil Pó Compacto Nude Me Una	\N	110680	Maquiagem	Refil Pó Compacto Nude Me Una\nRef: 110680	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb643cc36/Produtos/NATBRA-110680_1.jpg	5	64.90	64.90	2026-03-07 17:07:49.636804-03	2026-02-27 20:02:31.747092-03
840	Água Prebiótica para o Corpo Tododia Manga Rosa e Água de Coco	\N	103593	Geral	Água Prebiótica para o Corpo Tododia Manga Rosa e Água de Coco\nRef: 103593	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwadc87ceb/produto-joia/background/desktop/103593.jpg	5	52.90	52.90	2026-03-07 17:08:15.421672-03	2026-02-27 20:02:31.75542-03
843	Presente Natura Tododia Feliz Aniversário (3 produtos)	\N	184337	Geral	Presente Natura Tododia Feliz Aniversário (3 produtos)\nRef: 184337	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw09732a17/produto-joia/background/desktop/184337.jpg	5	0.00	0.00	2026-03-07 17:08:54.510009-03	2026-02-27 20:02:31.763177-03
846	Kit Difusor de Ambientes Erva Doce Casa	\N	194200	Geral	Kit Difusor de Ambientes Erva Doce Casa\nRef: 194200	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf1027719/produto-joia/background/desktop/194200.jpg	5	139.90	139.90	2026-03-07 17:09:24.831525-03	2026-02-27 20:02:31.764878-03
848	Sérum Noturno Força e Reparação Molecular Lumina	\N	164508	Geral	Sérum Noturno Força e Reparação Molecular Lumina\nRef: 164508	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8e67ca97/produto-joia/background/desktop/164508.jpg	5	0.00	0.00	2026-03-07 17:09:47.139026-03	2026-02-27 20:02:31.771598-03
850	Kit Banho Cheirosinho Natura Naturé (2 produtos)	\N	203810	Geral	Kit Banho Cheirosinho Natura Naturé (2 produtos)\nRef: 203810	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3b15ea46/produto-joia/background/desktop/203810.jpg	5	0.00	0.00	2026-03-07 17:10:20.35702-03	2026-02-27 20:02:31.771598-03
854	Batom Matte Faces 3,5g	\N	67645	Maquiagem	Batom Matte Faces 3,5g\nRef: 67645	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw038bc66f/produto-joia/background/desktop/PAI77992.jpg	5	23.90	23.90	2026-03-07 17:11:08.513128-03	2026-02-27 20:02:31.779996-03
856	Kit Lumina Matização e Restauração para Loiros e Grisalhos	\N	239190	Geral	Kit Lumina Matização e Restauração para Loiros e Grisalhos\nRef: 239190	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa839205a/produto-joia/background/desktop/239190.jpg	5	0.00	0.00	2026-03-07 17:11:35.691576-03	2026-02-27 20:02:31.779996-03
859	Kriska Romance 100 ml	\N	119239	Geral	Kriska Romance 100 ml\nRef: 119239	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe0ae6e68/produto-joia/background/desktop/119239.jpg	5	169.90	169.90	2026-03-07 17:12:13.199887-03	2026-02-27 20:02:45.745052-03
861	Presente Natura Ekos Maracujá Ritual Calmante (3 produtos)	\N	190371	Geral	Presente Natura Ekos Maracujá Ritual Calmante (3 produtos)\nRef: 190371	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5a4e6c1b/produto-joia/background/desktop/190371.jpg	5	170.20	170.20	2026-03-07 17:13:17.567629-03	2026-02-27 20:02:45.745052-03
864	Kit Balm Pós-barba e Deo Parfum Natura Homem Essence	\N	219725	Perfumaria	Kit Balm Pós-barba e Deo Parfum Natura Homem Essence\nRef: 219725	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6aa7d3aa/produto-joia/background/desktop/219725.jpg	5	0.00	0.00	2026-03-07 17:13:55.061657-03	2026-02-27 20:02:45.753152-03
866	Química de Humor Masculino 75 ml	\N	70996	Homem	Química de Humor Masculino 75 ml\nRef: 70996	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw00b0518f/NATBRA-70996_1.jpg	5	0.00	0.00	2026-03-07 17:14:20.944125-03	2026-02-27 20:02:45.753152-03
871	Produto 167174	\N	167174	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.761668-03	2026-02-27 20:02:45.761668-03
872	Produto 103145	\N	103145	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.770185-03	2026-02-27 20:02:45.770185-03
873	Produto 134588	\N	134588	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.770185-03	2026-02-27 20:02:45.770185-03
874	Produto 150228	\N	150228	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.770185-03	2026-02-27 20:02:45.770185-03
875	Produto 100146	\N	100146	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.770185-03	2026-02-27 20:02:45.770185-03
876	Produto 97172	\N	97172	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.777412-03	2026-02-27 20:02:45.777412-03
877	Produto 152331	\N	152331	Geral	Descoberto em Todos os Produtos (Pág 46)	\N	5	0.00	\N	2026-02-27 20:02:45.778485-03	2026-02-27 20:02:45.778485-03
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
908	Produto 150340	\N	150340	Geral	Descoberto em Todos os Produtos (Pág 48)	\N	5	0.00	\N	2026-02-27 20:03:00.851877-03	2026-02-27 20:03:00.852878-03
881	Kit Óleo Desodorante Hidratante Corporal Sève (2 unidades)	\N	228445	Corpo e Banho	Kit Óleo Desodorante Hidratante Corporal Sève (2 unidades)\nRef: 228445	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw19cfde65/produto-joia/background/desktop/228445.jpg	5	0.00	0.00	2026-03-07 18:02:10.828865-03	2026-02-27 20:02:53.04119-03
884	Pincel PRO Base Líquida Una	\N	55104	Maquiagem	Pincel PRO Base Líquida Una\nRef: 55104	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwaa7978ac/produto-joia/background/desktop/55104.jpg	5	59.90	59.90	2026-03-07 18:02:48.294712-03	2026-02-27 20:02:53.047779-03
886	Shampoo Força e Reparação Molecular Lumina	\N	164516	Cabelos	Shampoo Força e Reparação Molecular Lumina\nRef: 164516	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd74f218d/produto-joia/background/desktop/164516.jpg	5	0.00	0.00	2026-03-07 18:03:11.240203-03	2026-02-27 20:02:53.051192-03
889	Difusor de Ambientes em Cerâmica Bothânica	\N	180461	Geral	Difusor de Ambientes em Cerâmica Bothânica\nRef: 180461	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw35c8daee/produto-joia/background/desktop/180461.jpg	5	155.00	155.00	2026-03-07 18:03:49.354454-03	2026-02-27 20:02:53.056458-03
891	Kit Concentrado Corporal em Creme Ekos Castanha	\N	150219	Corpo e Banho	Kit Concentrado Corporal em Creme Ekos Castanha\nRef: 150219	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf3d0dba3/produto-joia/background/desktop/150219.jpg	5	0.00	0.00	2026-03-07 18:04:14.551356-03	2026-02-27 20:02:53.05978-03
905	Pó Compacto Matte Faces 6,5g	\N	8883	Maquiagem	Pó Compacto Matte Faces 6,5g\nRef: 8883	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw38bf3dca/Produtos/NATBRA-8883_1.jpg	5	0.00	0.00	2026-03-07 19:01:59.662014-03	2026-02-27 20:03:00.846876-03
907	Refil Spray de Ambientes Tododia Todanoite	\N	125798	Geral	Refil Spray de Ambientes Tododia Todanoite\nRef: 125798	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw518bcdca/produto-joia/background/desktop/125798.jpg	5	0.00	0.00	2026-03-07 19:02:22.647481-03	2026-02-27 20:03:00.850879-03
911	Kit Refil Desodorante Corporal Biografia Feminino (2 unidades)	\N	208143	Corpo e Banho	Kit Refil Desodorante Corporal Biografia Feminino (2 unidades)\nRef: 208143	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1a24776c/produto-joia/background/desktop/208143.jpg	5	0.00	0.00	2026-03-07 19:03:17.479532-03	2026-02-27 20:03:00.857876-03
913	Batom Matte Faces 3,5g	\N	93024	Maquiagem	Batom Matte Faces 3,5g\nRef: 93024	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw038bc66f/produto-joia/background/desktop/PAI77992.jpg	5	23.90	23.90	2026-03-07 19:03:44.293244-03	2026-02-27 20:03:00.862065-03
916	Refil Desodorante Corporal Meu Primeiro Humor Feminino	\N	56766	Corpo e Banho	Refil Desodorante Corporal Meu Primeiro Humor Feminino\nRef: 56766	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw16ccfeff/NATBRA-56766_1.jpg	5	44.90	44.90	2026-03-07 19:04:18.87317-03	2026-02-27 20:03:00.867066-03
919	Creme Desodorante Nutritivo para o Corpo Tododia Noz Pecã e Cacau	\N	23082	Corpo e Banho	Creme Desodorante Nutritivo para o Corpo Tododia Noz Pecã e Cacau\nRef: 23082	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0b1b831f/produto-joia/background/desktop/23082.jpg	5	0.00	0.00	2026-03-07 19:05:04.469032-03	2026-02-27 20:03:00.873063-03
922	Kit Shampoo e Creme de Pentear Lumina para Definição e Hidratação de Cabelos Cacheados (2 produtos)	\N	221671	Cabelos	Kit Shampoo e Creme de Pentear Lumina para Definição e Hidratação de Cabelos Cacheados (2 produtos)\nRef: 221671	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw425cfe71/produto-joia/background/desktop/221671.jpg	5	0.00	0.00	2026-03-07 19:05:37.473573-03	2026-02-27 20:03:00.878064-03
925	Kit Óleo Trifásico Desodorante Corporal Ekos Açaí com Refil	\N	228805	Corpo e Banho	Kit Óleo Trifásico Desodorante Corporal Ekos Açaí com Refil\nRef: 228805	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2bc60c68/Produtos/NATBRA-228805_1.jpg	5	0.00	0.00	2026-03-07 19:06:11.846068-03	2026-02-27 20:03:00.883254-03
928	Kit Ekos Patauá Shampoo, Condicionador e Máscara	\N	239968	Cabelos	Kit Ekos Patauá Shampoo, Condicionador e Máscara\nRef: 239968	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4295b947/produto-joia/background/desktop/239968.jpg	5	0.00	0.00	2026-03-07 19:06:49.458966-03	2026-02-27 20:03:08.993961-03
950	Produto 92604	\N	92604	Geral	Descoberto em Todos os Produtos (Pág 49)	\N	5	0.00	\N	2026-02-27 20:03:09.340328-03	2026-02-27 20:03:09.341379-03
932	Desodorante Hidratante Corporal Kaiak Masculino 150 ml	\N	108877	Corpo e Banho	Desodorante Hidratante Corporal Kaiak Masculino 150 ml\nRef: 108877	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw83b5df9d/NATBRA-108877_1.jpg	5	64.90	64.90	2026-03-07 19:07:41.704999-03	2026-02-27 20:03:09.000188-03
935	Gel Glitter Faces	\N	105026	Geral	Gel Glitter Faces\nRef: 105026	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw91bb8c9e/produto-joia/background/desktop/105026.jpg	5	49.90	49.90	2026-03-07 19:08:21.719221-03	2026-02-27 20:03:09.008187-03
936	Pincel PRO Duo Fibras Una	\N	58406	Geral	Pincel PRO Duo Fibras Una\nRef: 58406	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8f9eae23/NATBRA-58406_1.jpg	5	69.90	69.90	2026-03-07 19:08:35.666994-03	2026-02-27 20:03:09.008187-03
939	Lápis PRO Labial Una	\N	92551	Geral	Lápis PRO Labial Una\nRef: 92551	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe9fc977d/Produtos/NATBRA-92551_1.jpg	5	49.90	49.90	2026-03-07 19:09:11.457571-03	2026-02-27 20:03:09.015416-03
941	Batom Color Hidra FPS 8 Faces 3,5g	\N	6422	Maquiagem	Batom Color Hidra FPS 8 Faces 3,5g\nRef: 6422	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7afe303d/Produtos/NATBRA-6422_1.jpg	5	35.90	35.90	2026-03-07 19:09:39.787384-03	2026-02-27 20:03:09.322872-03
943	Kit Ekos Maracujá Creme para o Corpo e Refil	\N	241059	Corpo e Banho	Kit Ekos Maracujá Creme para o Corpo e Refil\nRef: 241059	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1a306099/produto-joia/background/desktop/241059.jpg	5	0.00	0.00	2026-03-07 19:09:57.981439-03	2026-02-27 20:03:09.326844-03
946	Kit Creme Desodorante Hidratante para o Corpo Ekos Castanha com Refil	\N	226815	Corpo e Banho	Kit Creme Desodorante Hidratante para o Corpo Ekos Castanha com Refil\nRef: 226815	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb8a9ab13/Produtos/NATBRA-226815_1.jpg	5	0.00	0.00	2026-03-07 19:10:36.047334-03	2026-02-27 20:03:09.333077-03
949	Luna Luninha Desodorante Colônia Feminino	\N	155285	Perfumaria	Luna Luninha Desodorante Colônia Feminino\nRef: 155285	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw63102944/produto-joia/background/desktop/155285.jpg	5	0.00	0.00	2026-03-07 19:11:05.609027-03	2026-02-27 20:03:09.339595-03
952	Batom Color Tint FPS 8 Faces	\N	6587	Maquiagem	Batom Color Tint FPS 8 Faces\nRef: 6587	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw72055d52/Produtos/NATBRA-6587_1.jpg	5	0.00	0.00	2026-03-07 19:11:39.692016-03	2026-02-27 20:03:17.273775-03
955	Kit Lumina Finalizadores para Cacheados e Crespos (3 produtos)	\N	217206	Geral	Kit Lumina Finalizadores para Cacheados e Crespos (3 produtos)\nRef: 217206	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7c3e2e65/produto-joia/background/desktop/217206.jpg	5	0.00	0.00	2026-03-07 19:12:21.197771-03	2026-02-27 20:03:17.281908-03
957	Refil Base Líquida HD Una	\N	173608	Maquiagem	Refil Base Líquida HD Una\nRef: 173608	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwab8ce950/produto-joia/background/desktop/173608.jpg	5	109.90	109.90	2026-03-07 19:12:44.681776-03	2026-02-27 20:03:17.281908-03
960	Ekos Raiz 50 ml	\N	148478	Geral	Ekos Raiz 50 ml\nRef: 148478	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwddf9dbd3/produto-joia/background/desktop/148478.jpg	5	389.90	389.90	2026-03-07 19:13:23.969694-03	2026-02-27 20:03:17.290114-03
963	Refil Iluminador Marmorizado Corpo e Rosto Una	\N	24865	Geral	Refil Iluminador Marmorizado Corpo e Rosto Una\nRef: 24865	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0ef99ece/produto-joia/background/desktop/24865.jpg	5	69.90	69.90	2026-03-07 19:14:12.30327-03	2026-02-27 20:03:17.290114-03
965	Kit Desodorante Antitranspirante em Creme Tododia Manga Rosa e Água de Coco (2 unidades)	\N	235588	Corpo e Banho	Kit Desodorante Antitranspirante em Creme Tododia Manga Rosa e Água de Coco (2 unidades)\nRef: 235588	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe34bb576/Produtos/NATBRA-235588_1.jpg	5	0.00	0.00	2026-03-07 19:14:36.562652-03	2026-02-27 20:03:17.298345-03
968	Base Matte Powder Una	\N	127775	Maquiagem	Base Matte Powder Una\nRef: 127775	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc9ff9eef/Produtos/NATBRA-127775_1.jpg	5	0.00	0.00	2026-03-07 19:15:10.922276-03	2026-02-27 20:03:17.298345-03
970	Hidratante para Mãos Humor Próprio	\N	160265	Corpo e Banho	Hidratante para Mãos Humor Próprio\nRef: 160265	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4ed7fa34/produto-joia/background/desktop/160265.jpg	5	0.00	0.00	2026-03-07 19:15:38.097106-03	2026-02-27 20:03:17.305924-03
973	Base Matte Powder Una	\N	127761	Maquiagem	Base Matte Powder Una\nRef: 127761	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd3c63710/Produtos/NATBRA-127761_1.jpg	5	0.00	0.00	2026-03-07 19:16:11.680442-03	2026-02-27 20:03:17.306766-03
975	Refil Condicionador de Limpeza para Definição Intensa de Cabelos Cacheados e Crespos	\N	148441	Cabelos	Refil Condicionador de Limpeza para Definição Intensa de Cabelos Cacheados e Crespos\nRef: 148441	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb5fceb27/produto-joia/background/desktop/148441.jpg	5	0.00	0.00	2026-03-07 19:16:33.895989-03	2026-02-27 20:03:24.64808-03
978	Kit Sérum Preenchedor Hidratante e Acqua Renovador Chronos Derma	\N	239267	Corpo e Banho	Kit Sérum Preenchedor Hidratante e Acqua Renovador Chronos Derma\nRef: 239267	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3d313260/produto-joia/background/desktop/239267.jpg	5	0.00	0.00	2026-03-07 19:17:18.596476-03	2026-02-27 20:03:24.65644-03
981	Desodorante Hidratante Corporal Perfumado Luna Ilumina	\N	173010	Corpo e Banho	Desodorante Hidratante Corporal Perfumado Luna Ilumina\nRef: 173010	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb404d5b6/produto-joia/background/desktop/173010.jpg	5	0.00	0.00	2026-03-07 19:17:55.253054-03	2026-02-27 20:03:24.664088-03
984	Kit Ekos Patauá Shampoo e Condicionador	\N	239980	Cabelos	Kit Ekos Patauá Shampoo e Condicionador\nRef: 239980	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf3dc156a/produto-joia/background/desktop/239980.jpg	5	0.00	0.00	2026-03-07 19:18:36.773829-03	2026-02-27 20:03:24.664088-03
986	Refil Pó Compacto Matte Faces 6,5g	\N	9304	Maquiagem	Refil Pó Compacto Matte Faces 6,5g\nRef: 9304	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf2fa69a2/Produtos/NATBRA-9304_1.jpg	5	49.90	49.90	2026-03-07 19:19:00.678967-03	2026-02-27 20:03:24.671497-03
987	Produto 171110	\N	171110	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.672532-03	2026-02-27 20:03:24.672532-03
988	Produto 168818	\N	168818	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.672532-03	2026-02-27 20:03:24.672532-03
989	Produto 229968	\N	229968	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.672532-03	2026-02-27 20:03:24.672532-03
990	Produto 95773	\N	95773	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.672532-03	2026-02-27 20:03:24.672532-03
991	Produto 148479	\N	148479	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.672532-03	2026-02-27 20:03:24.672532-03
992	Produto 19852	\N	19852	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.680839-03	2026-02-27 20:03:24.680839-03
993	Produto 148409	\N	148409	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.680839-03	2026-02-27 20:03:24.680839-03
994	Produto 148471	\N	148471	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.680839-03	2026-02-27 20:03:24.680839-03
995	Produto 151032	\N	151032	Geral	Descoberto em Todos os Produtos (Pág 51)	\N	5	0.00	\N	2026-02-27 20:03:24.680839-03	2026-02-27 20:03:24.680839-03
1556	Base Matte Una	\N	108153	Maquiagem	Base Matte Una\nRef: 108153	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw33c8c11d/Produtos/NATBRA-108153_1.jpg	5	99.90	99.90	2026-03-08 05:28:43.83-03	2026-02-27 20:07:18.928763-03
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
1041	Produto 155876	\N	155876	Geral	Descoberto em Todos os Produtos (Pág 53)	\N	5	0.00	\N	2026-02-27 20:03:41.120635-03	2026-02-27 20:03:41.120635-03
998	Base Matte Una	\N	108128	Maquiagem	Base Matte Una\nRef: 108128	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe23f1bb3/Produtos/NATBRA-108128_1.jpg	5	99.90	99.90	2026-03-07 20:06:26.256618-03	2026-02-27 20:03:24.689169-03
1000	Gloss Labial Faces	\N	175103	Geral	Gloss Labial Faces\nRef: 175103	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf0622c34/produto-joia/background/desktop/175103.jpg	5	0.00	0.00	2026-03-07 20:06:52.279852-03	2026-02-27 20:03:33.204416-03
1003	Máscara Restauradora para Reparação e Blindagem	\N	148435	Cabelos	Máscara Restauradora para Reparação e Blindagem\nRef: 148435	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9706b5b6/produto-joia/background/desktop/148435.jpg	5	0.00	0.00	2026-03-07 20:07:30.666676-03	2026-02-27 20:03:33.212901-03
1006	Kit Desodorante Antitranspirante em Creme Erva Doce (2 unidades)	\N	213231	Corpo e Banho	Kit Desodorante Antitranspirante em Creme Erva Doce (2 unidades)\nRef: 213231	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf2b16260/produto-joia/background/desktop/213231.jpg	5	0.00	0.00	2026-03-07 20:08:11.15411-03	2026-02-27 20:03:33.224184-03
1009	Kit Tododia Amora Vermelha e Jabuticaba com Hidratante e Body Splash (2 produtos)	\N	215258	Corpo e Banho	Kit Tododia Amora Vermelha e Jabuticaba com Hidratante e Body Splash (2 produtos)\nRef: 215258	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw76add4fd/produto-joia/background/desktop/215258.jpg	5	0.00	0.00	2026-03-07 20:08:56.149084-03	2026-02-27 20:03:33.229389-03
1012	Refil Pó Compacto Nude Me Una	\N	110681	Maquiagem	Refil Pó Compacto Nude Me Una\nRef: 110681	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfce69ac5/Produtos/NATBRA-110681_1.jpg	5	64.90	64.90	2026-03-07 20:09:35.423322-03	2026-02-27 20:03:33.234279-03
1025	Paleta de Sombras Faces (6 cores)	\N	174175	Geral	Paleta de Sombras Faces (6 cores)\nRef: 174175	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8a39644e/produto-joia/background/desktop/174175.jpg	5	69.90	69.90	2026-03-07 21:07:04.870433-03	2026-02-27 20:03:41.096395-03
1028	Pó Compacto Faces 5,5g	\N	4741	Maquiagem	Pó Compacto Faces 5,5g\nRef: 4741	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe1376e97/Produtos/NATBRA-4741_1.jpg	5	39.90	39.90	2026-03-07 21:07:55.9262-03	2026-02-27 20:03:41.101396-03
1032	Base Matte Una	\N	108136	Maquiagem	Base Matte Una\nRef: 108136	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe0f815df/Produtos/NATBRA-108136_1.jpg	5	99.90	99.90	2026-03-07 21:08:05.860819-03	2026-02-27 20:03:41.103171-03
1031	Máscara Força e Reparação Molecular Lumina	\N	164505	Cabelos	Máscara Força e Reparação Molecular Lumina\nRef: 164505	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw889b3ad1/produto-joia/background/desktop/164505.jpg	5	0.00	0.00	2026-03-07 21:08:46.373286-03	2026-02-27 20:03:41.103171-03
1035	Batom Matte Faces 3,5g	\N	118905	Maquiagem	Batom Matte Faces 3,5g\nRef: 118905	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw038bc66f/produto-joia/background/desktop/PAI77992.jpg	5	0.00	0.00	2026-03-07 21:09:22.334366-03	2026-02-27 20:03:41.111622-03
1037	Base Sérum Nude Me Una	\N	110181	Maquiagem	Base Sérum Nude Me Una\nRef: 110181	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw86661e9f/Produtos/NATBRA-110181_1.jpg	5	0.00	0.00	2026-03-07 21:09:48.768392-03	2026-02-27 20:03:41.111622-03
1039	Batom Matte Intransferível Una 8ml	\N	107325	Maquiagem	Batom Matte Intransferível Una 8ml\nRef: 107325	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw999dd2d0/produto-joia/background/desktop/167329.jpg	5	65.90	65.90	2026-03-07 21:10:08.487082-03	2026-02-27 20:03:41.120635-03
1043	Base Líquida Faces Checkmatte	\N	166332	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166332	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwaeba6313/produto-joia/background/desktop/166332.jpg	5	45.90	45.90	2026-03-07 21:10:52.788091-03	2026-02-27 20:03:41.120635-03
1047	Base Sérum Nude Me Una	\N	110191	Maquiagem	Base Sérum Nude Me Una\nRef: 110191	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw55b1793d/Produtos/NATBRA-110191_1.jpg	5	0.00	0.00	2026-03-07 21:12:11.076869-03	2026-02-27 20:03:48.260833-03
1051	Kit Desodorante Antitranspirante Roll-on Erva Doce (2 unidades)	\N	241080	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Erva Doce (2 unidades)\nRef: 241080	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf66ae861/NATBRA-241080_1.jpg	5	0.00	0.00	2026-03-07 21:12:37.209214-03	2026-02-27 20:03:48.269082-03
1053	Blush Color Faces	\N	9432	Geral	Blush Color Faces\nRef: 9432	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3fa17397/Produtos/NATBRA-9432_1.jpg	5	39.90	39.90	2026-03-07 21:13:23.937165-03	2026-02-27 20:03:48.276321-03
1056	Batom Matte Longa Duração Faces	\N	111466	Maquiagem	Batom Matte Longa Duração Faces\nRef: 111466	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdeca6aa8/produto-joia/background/desktop/111466.jpg	5	49.90	49.90	2026-03-07 21:14:00.89677-03	2026-02-27 20:03:48.27737-03
1054	Batom Cristal Una 8ml	\N	167322	Maquiagem	Batom Cristal Una 8ml\nRef: 167322	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw09942cf2/produto-joia/background/desktop/167322.jpg	5	64.90	64.90	2026-03-07 21:14:22.943858-03	2026-02-27 20:03:48.27737-03
1063	Base Matte Una	\N	108126	Maquiagem	Base Matte Una\nRef: 108126	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw565b6b72/Produtos/NATBRA-108126_1.jpg	5	99.90	99.90	2026-03-07 21:14:55.427469-03	2026-02-27 20:03:48.285671-03
1059	Desodorante Corporal Humor Próprio Feminino	\N	56757	Corpo e Banho	Desodorante Corporal Humor Próprio Feminino\nRef: 56757	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdacb3b74/NATBRA-56757_1.jpg	5	56.90	56.90	2026-03-07 21:15:30.45996-03	2026-02-27 20:03:48.285671-03
1064	Kit Lenços Umedecidos Sem Fragrância Mamãe e Bebê (2 unidades)	\N	221679	Infantil	Kit Lenços Umedecidos Sem Fragrância Mamãe e Bebê (2 unidades)\nRef: 221679	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6ddb7174/produto-joia/background/desktop/221679.jpg	5	0.00	0.00	2026-03-07 21:16:00.573326-03	2026-02-27 20:03:48.29402-03
1067	Presente Natura Ekos Andiroba (2 produtos)	\N	231401	Geral	Presente Natura Ekos Andiroba (2 produtos)\nRef: 231401	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd1755002/produto-joia/background/desktop/231401.jpg	5	0.00	0.00	2026-03-07 21:16:32.935627-03	2026-02-27 20:04:03.71259-03
1070	Sabonete Facial Esfoliante Natura Homem	\N	160273	Corpo e Banho	Sabonete Facial Esfoliante Natura Homem\nRef: 160273	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdebd2186/produto-joia/background/desktop/160273.jpg	5	0.00	0.00	2026-03-07 21:17:19.607965-03	2026-02-27 20:04:03.720953-03
1072	Batom Matte Intransferível Una 8ml	\N	107324	Maquiagem	Batom Matte Intransferível Una 8ml\nRef: 107324	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw999dd2d0/produto-joia/background/desktop/167329.jpg	5	65.90	65.90	2026-03-07 21:17:46.792248-03	2026-02-27 20:04:03.725265-03
1075	Refil Spray de Ambientes Bothânica Aura Gingi 200 ml	\N	140046	Geral	Refil Spray de Ambientes Bothânica Aura Gingi 200 ml\nRef: 140046	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbff6d278/produto-joia/background/desktop/140046.jpg	5	168.00	168.00	2026-03-07 21:18:29.503096-03	2026-02-27 20:04:03.729265-03
1078	Hidratante para Mãos e Áreas Ressecadas Natura Homem	\N	152330	Corpo e Banho	Hidratante para Mãos e Áreas Ressecadas Natura Homem\nRef: 152330	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa2f354a6/produto-joia/background/desktop/152330.jpg	5	0.00	0.00	2026-03-07 21:19:09.21582-03	2026-02-27 20:04:03.733526-03
1080	Batom Multimix Cremoso Faces	\N	116192	Maquiagem	Batom Multimix Cremoso Faces\nRef: 116192	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw000194ec/produto-joia/background/desktop/PAI116187.jpg	5	0.00	0.00	2026-03-07 21:19:31.798535-03	2026-02-27 20:04:03.736526-03
1083	Kit Desodorante Antitranspirante Roll-on Tododia Macadâmia (2 unidades)	\N	239250	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Tododia Macadâmia (2 unidades)\nRef: 239250	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd149dfe3/Produtos/NATBRA-239250_1.jpg	5	0.00	0.00	2026-03-07 21:20:12.479841-03	2026-02-27 20:04:03.740904-03
1084	Batom CC Hidratante FPS 25 Una	\N	93505	Corpo e Banho	Batom CC Hidratante FPS 25 Una\nRef: 93505	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw22f5bed4/Produtos/NATBRA-93505_1.jpg	5	64.90	64.90	2026-03-07 21:20:33.07902-03	2026-02-27 20:04:03.741624-03
1089	Shampoo Ekos Patauá	\N	113409	Cabelos	Shampoo Ekos Patauá\nRef: 113409	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbbf972d1/produto-joia/background/desktop/113409.jpg	5	0.00	0.00	2026-03-07 21:21:08.72606-03	2026-02-27 20:04:03.749714-03
1090	Sabonete Líquido em Gel Tododia Tâmara e Canela	\N	7740	Corpo e Banho	Sabonete Líquido em Gel Tododia Tâmara e Canela\nRef: 7740	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc6444ffa/produto-joia/background/desktop/7740.jpg	5	50.90	50.90	2026-03-07 21:21:36.526812-03	2026-02-27 20:04:03.749714-03
1093	Base Líquida Checkmatte Faces	\N	97639	Maquiagem	Base Líquida Checkmatte Faces\nRef: 97639	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw76efcc93/Produtos/NATBRA-97639_1.jpg	5	0.00	0.00	2026-03-07 21:22:12.040197-03	2026-02-27 20:04:11.547942-03
1095	Corretivo Checkmatte Faces	\N	116689	Maquiagem	Corretivo Checkmatte Faces\nRef: 116689	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2ce1a35a/Produtos/NATBRA-116689_1.jpg	5	34.90	34.90	2026-03-07 21:22:32.260287-03	2026-02-27 20:04:11.547942-03
1098	Creme Antissinais 80+ Dia	\N	134695	Corpo e Banho	Creme Antissinais 80+ Dia\nRef: 134695	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw08404689/produto-joia/background/desktop/134695.jpg	5	0.00	0.00	2026-03-07 21:23:06.630206-03	2026-02-27 20:04:11.556008-03
1100	Garrafa Crer Para Ver	\N	195641	Geral	Garrafa Crer Para Ver\nRef: 195641	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9d4b519f/produto-joia/background/desktop/195641.jpg	5	29.90	29.90	2026-03-07 21:23:30.124859-03	2026-02-27 20:04:11.556008-03
1102	Base Matte Una	\N	108129	Maquiagem	Base Matte Una\nRef: 108129	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe379442b/Produtos/NATBRA-108129_1.jpg	5	99.90	99.90	2026-03-07 21:23:56.191311-03	2026-02-27 20:04:11.564298-03
1108	Produto 160235	\N	160235	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.572641-03	2026-02-27 20:04:11.572641-03
1109	Produto 177282	\N	177282	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.572641-03	2026-02-27 20:04:11.572641-03
1110	Produto 239728	\N	239728	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.572641-03	2026-02-27 20:04:11.572641-03
1111	Produto 213238	\N	213238	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.581019-03	2026-02-27 20:04:11.581019-03
1112	Produto 194391	\N	194391	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.581019-03	2026-02-27 20:04:11.581019-03
1113	Produto 175112	\N	175112	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.581019-03	2026-02-27 20:04:11.581019-03
1114	Produto 170133	\N	170133	Geral	Descoberto em Todos os Produtos (Pág 57)	\N	5	0.00	\N	2026-02-27 20:04:11.581019-03	2026-02-27 20:04:11.581019-03
1115	Produto 185536	\N	185536	Geral	Descoberto em Todos os Produtos (Pág 58)	\N	5	0.00	\N	2026-02-27 20:04:20.330449-03	2026-02-27 20:04:20.330449-03
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
1105	Batom Matte Powder Una	\N	95776	Maquiagem	Batom Matte Powder Una\nRef: 95776	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1436a4e9/produto-joia/background/desktop/95776.jpg	5	59.90	59.90	2026-03-07 21:24:36.736047-03	2026-02-27 20:04:11.564298-03
1116	Lápis PRO Labial Una	\N	92567	Geral	Lápis PRO Labial Una\nRef: 92567	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa3f78036/Produtos/NATBRA-92567_1.jpg	5	49.90	49.90	2026-03-07 22:07:04.816392-03	2026-02-27 20:04:20.330449-03
1118	Refil Blush Intense Me Una 6g	\N	92584	Geral	Refil Blush Intense Me Una 6g\nRef: 92584	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf42d00fb/Produtos/NATBRA-92584_1.jpg	5	69.90	69.90	2026-03-07 22:07:26.213947-03	2026-02-27 20:04:20.339005-03
1121	Iluminador para Rosto, Olhos e Boca Humor Festival	\N	179460	Geral	Iluminador para Rosto, Olhos e Boca Humor Festival\nRef: 179460	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa7ca9274/produto-joia/background/desktop/179460.jpg	5	0.00	0.00	2026-03-07 22:08:17.466402-03	2026-02-27 20:04:20.346718-03
1123	Kit Mamãe e Bebê Gestante	\N	218195	Infantil	Kit Mamãe e Bebê Gestante\nRef: 218195	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw74513264/produto-joia/background/desktop/218195.jpg	5	0.00	0.00	2026-03-07 22:08:41.552687-03	2026-02-27 20:04:20.347069-03
1125	Gloss labial FPS 15 Una	\N	92549	Geral	Gloss labial FPS 15 Una\nRef: 92549	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4bccfe3c/produto-joia/background/desktop/167330.jpg	5	0.00	0.00	2026-03-07 22:09:16.519634-03	2026-02-27 20:04:20.347069-03
1139	Base Matte Una	\N	108131	Maquiagem	Base Matte Una\nRef: 108131	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9f584d41/Produtos/NATBRA-108131_1.jpg	5	99.90	99.90	2026-03-07 23:11:51.638981-03	2026-02-27 20:04:27.663362-03
1142	Corretivo Checkmatte Faces	\N	116690	Maquiagem	Corretivo Checkmatte Faces\nRef: 116690	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw52f37989/Produtos/NATBRA-116690_1.jpg	5	34.90	34.90	2026-03-07 23:12:42.008533-03	2026-02-27 20:04:27.671619-03
1144	Kit Ekos Patauá Condicionador com Refil	\N	239983	Cabelos	Kit Ekos Patauá Condicionador com Refil\nRef: 239983	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1ad91505/produto-joia/background/desktop/239983.jpg	5	0.00	0.00	2026-03-07 23:13:13.550131-03	2026-02-27 20:04:27.679818-03
1147	Refil Pó Compacto Matte Faces 6,5g	\N	9125	Maquiagem	Refil Pó Compacto Matte Faces 6,5g\nRef: 9125	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw35313a34/Produtos/NATBRA-9125_1.jpg	5	49.90	49.90	2026-03-07 23:14:02.832274-03	2026-02-27 20:04:27.679818-03
1149	Refil Difusor de Ambiente Natura Bothânica Divinus Plantae	\N	170137	Geral	Refil Difusor de Ambiente Natura Bothânica Divinus Plantae\nRef: 170137	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw539d95be/produto-joia/background/desktop/170137.jpg	5	160.00	160.00	2026-03-07 23:14:27.275134-03	2026-02-27 20:04:27.688019-03
1152	Refil Sabonete Líquido Cremoso para o Corpo Tododia Macadâmia	\N	113407	Corpo e Banho	Refil Sabonete Líquido Cremoso para o Corpo Tododia Macadâmia\nRef: 113407	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw069c68ab/produto-joia/background/desktop/113407.jpg	5	38.40	38.40	2026-03-07 23:15:06.039501-03	2026-02-27 20:04:27.688019-03
1155	Creme Desodorante Nutritivo para o Corpo Tododia Tâmara e Canela	\N	23153	Corpo e Banho	Creme Desodorante Nutritivo para o Corpo Tododia Tâmara e Canela\nRef: 23153	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe6838b1f/produto-joia/background/desktop/23153.jpg	5	0.00	0.00	2026-03-07 23:15:52.738999-03	2026-02-27 20:04:27.696197-03
1157	Pincel PRO Lábios Una	\N	55107	Geral	Pincel PRO Lábios Una\nRef: 55107	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw67564f12/produto-joia/background/desktop/55107.jpg	5	30.90	30.90	2026-03-07 23:16:13.558479-03	2026-02-27 20:04:27.696197-03
1160	Batom Cristal Una 8ml	\N	95868	Maquiagem	Batom Cristal Una 8ml\nRef: 95868	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw09942cf2/produto-joia/background/desktop/167322.jpg	5	64.90	64.90	2026-03-07 23:17:07.289377-03	2026-02-27 20:04:27.704924-03
1557	Sombra Mono Faces	\N	109151	Geral	Sombra Mono Faces\nRef: 109151	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc9331205/Produtos/NATBRA-109151_1.jpg	5	39.90	39.90	2026-03-08 05:29:04.554883-03	2026-02-27 20:07:18.937283-03
1164	Aromatizador de Ambientes Ekos Maracujá	\N	159923	Geral	Aromatizador de Ambientes Ekos Maracujá\nRef: 159923	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw15d26c1c/produto-joia/background/desktop/159923.jpg	5	0.00	0.00	2026-03-07 23:17:48.836927-03	2026-02-27 20:04:36.498105-03
1167	Duo Esfoliante Multicamadas Ekos Maracujá Natureza Dos Sonhos 200 g	\N	140463	Geral	Duo Esfoliante Multicamadas Ekos Maracujá Natureza Dos Sonhos 200 g\nRef: 140463	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9d79c1d8/produto-joia/background/desktop/140463.jpg	5	95.90	95.90	2026-03-07 23:18:27.438809-03	2026-02-27 20:04:36.503118-03
1169	Creme Antissinais 80+ Noite	\N	135039	Corpo e Banho	Creme Antissinais 80+ Noite\nRef: 135039	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfdec1135/produto-joia/background/desktop/135039.jpg	5	0.00	0.00	2026-03-07 23:18:57.496872-03	2026-02-27 20:04:36.506356-03
1172	Kit Refil Desodorante Corporal Kaiak Oceano Feminino (2 unidades)	\N	254614	Corpo e Banho	Kit Refil Desodorante Corporal Kaiak Oceano Feminino (2 unidades)\nRef: 254614	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7e57ca89/Produtos/NATBRA-254614_1.jpg	5	0.00	0.00	2026-03-07 23:19:39.244511-03	2026-02-27 20:04:36.510574-03
1174	Refil Base Líquida HD Una	\N	173604	Maquiagem	Refil Base Líquida HD Una\nRef: 173604	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb542466b/produto-joia/background/desktop/173604.jpg	5	109.90	109.90	2026-03-07 23:20:13.502744-03	2026-02-27 20:04:36.511614-03
1177	Caixa de Presente G com Cinta	\N	174902	Geral	Caixa de Presente G com Cinta\nRef: 174902	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5d00de4f/produto-joia/background/desktop/174902.jpg	5	11.00	11.00	2026-03-07 23:20:55.22071-03	2026-02-27 20:04:36.51999-03
1180	Kit Una Iluminador Marmorizado e Pincel	\N	218182	Geral	Kit Una Iluminador Marmorizado e Pincel\nRef: 218182	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw568200fd/produto-joia/background/desktop/218182.jpg	5	0.00	0.00	2026-03-07 23:21:29.898642-03	2026-02-27 20:04:36.51999-03
1181	Estojo Crer para Ver	\N	170765	Geral	Estojo Crer para Ver\nRef: 170765	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdfe833a7/produto-joia/background/desktop/170765.jpg	5	25.90	25.90	2026-03-07 23:21:43.367177-03	2026-02-27 20:04:36.527258-03
1184	Kit Ekos Patauá Shampoo, Condicionador, Máscara e Tônico	\N	239979	Cabelos	Kit Ekos Patauá Shampoo, Condicionador, Máscara e Tônico\nRef: 239979	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2d13037d/produto-joia/background/desktop/239979.jpg	5	0.00	0.00	2026-03-07 23:22:26.258916-03	2026-02-27 20:04:36.528264-03
1187	Kit Óleo Desodorante Hidratante Corporal Sève Amêndoas Doces (2 unidades)	\N	228447	Corpo e Banho	Kit Óleo Desodorante Hidratante Corporal Sève Amêndoas Doces (2 unidades)\nRef: 228447	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw67ec9df0/produto-joia/background/desktop/228447.jpg	5	0.00	0.00	2026-03-07 23:23:05.223114-03	2026-02-27 20:04:44.768946-03
1190	Kit Natura Homem Essence e Natura Homem Nós	\N	232508	Homem	Kit Natura Homem Essence e Natura Homem Nós\nRef: 232508	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw70dfab8c/produto-joia/background/desktop/232508.jpg	5	0.00	0.00	2026-03-07 23:23:43.478104-03	2026-02-27 20:04:44.776894-03
1192	Base Líquida HD Una	\N	191638	Maquiagem	Base Líquida HD Una\nRef: 191638	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9dc2a317/produto-joia/background/desktop/191638.jpg	5	159.90	159.90	2026-03-07 23:24:13.071655-03	2026-02-27 20:04:44.785262-03
1195	Hidratante Mãos Natura Bothânica Ficus Herb	\N	139238	Corpo e Banho	Hidratante Mãos Natura Bothânica Ficus Herb\nRef: 139238	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw530f0a1f/produto-joia/background/desktop/139238.jpg	5	180.00	180.00	2026-03-07 23:24:55.355808-03	2026-02-27 20:04:44.785262-03
1197	Base Líquida Faces Checkmatte	\N	166345	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166345	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9706b5b6/produto-joia/background/desktop/166345.jpg	5	45.90	45.90	2026-03-07 23:25:22.672567-03	2026-02-27 20:04:44.793378-03
1200	Sabonete em Barra Humor a Rigor Masculino	\N	109860	Corpo e Banho	Sabonete em Barra Humor a Rigor Masculino\nRef: 109860	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw75bf250a/produto-joia/background/desktop/109860.jpg	5	0.00	0.00	2026-03-07 23:26:09.747726-03	2026-02-27 20:04:44.793378-03
1202	Gloss Labial Hidratação Ativa Una	\N	164822	Geral	Gloss Labial Hidratação Ativa Una\nRef: 164822	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd44daa74/produto-joia/background/desktop/164822.jpg	5	59.90	59.90	2026-03-07 23:26:35.449781-03	2026-02-27 20:04:44.802116-03
1205	Kit Desodorante Antitranspirante Roll-on Natura Homem Nós (3 unidades)	\N	219738	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Natura Homem Nós (3 unidades)\nRef: 219738	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dweac42324/produto-joia/background/desktop/219738.jpg	5	0.00	0.00	2026-03-07 23:27:08.579374-03	2026-02-27 20:04:44.802116-03
1208	Refil Spray de Ambientes Bothânica Cyan Serenum 200 ml	\N	140050	Geral	Refil Spray de Ambientes Bothânica Cyan Serenum 200 ml\nRef: 140050	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw87d7bf78/produto-joia/background/desktop/140050.jpg	5	168.00	168.00	2026-03-07 23:27:46.42765-03	2026-02-27 20:04:44.810377-03
1211	Conjunto Natura Tododia Capim Limão e Hortelã	\N	120471	Geral	Conjunto Natura Tododia Capim Limão e Hortelã\nRef: 120471	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwda1ea7b2/produto-joia/background/desktop/120471.jpg	5	0.00	0.00	2026-03-07 23:28:23.060997-03	2026-02-27 20:04:52.217734-03
1213	Presente Natura Una Artisan Duo Batons (2 produtos)	\N	239789	Geral	Presente Natura Una Artisan Duo Batons (2 produtos)\nRef: 239789	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb9dbef07/produto-joia/background/desktop/239789.jpg	5	0.00	0.00	2026-03-07 23:28:46.390577-03	2026-02-27 20:04:52.226166-03
1216	Kit Bothânica Spray para Ambientes Aura Gingi e Refil (2 produtos)	\N	213553	Geral	Kit Bothânica Spray para Ambientes Aura Gingi e Refil (2 produtos)\nRef: 213553	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw834f9d00/produto-joia/background/desktop/213553.jpg	5	408.00	408.00	2026-03-07 23:29:23.553981-03	2026-02-27 20:04:52.226166-03
1222	Produto 191619	\N	191619	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.241608-03	2026-02-27 20:04:52.241608-03
1223	Produto 105716	\N	105716	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.242581-03	2026-02-27 20:04:52.242581-03
1224	Produto 127766	\N	127766	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.242581-03	2026-02-27 20:04:52.242581-03
1225	Produto 218218	\N	218218	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.242581-03	2026-02-27 20:04:52.242581-03
1226	Produto 109481	\N	109481	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.242581-03	2026-02-27 20:04:52.242581-03
1227	Produto 97650	\N	97650	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.250628-03	2026-02-27 20:04:52.250628-03
1228	Produto 166352	\N	166352	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.250628-03	2026-02-27 20:04:52.250628-03
1229	Produto 124319	\N	124319	Geral	Descoberto em Todos os Produtos (Pág 62)	\N	5	0.00	\N	2026-02-27 20:04:52.250628-03	2026-02-27 20:04:52.250628-03
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
1230	Sacola de Presente M Crer Para Ver	\N	152267	Geral	Sacola de Presente M Crer Para Ver\nRef: 152267	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1506106b/produto-joia/background/desktop/152267.jpg	5	9.20	9.20	2026-03-08 00:12:01.984424-03	2026-02-27 20:04:52.250628-03
1232	Kit Reparador Tododia Flor de Cereja e Abacate (3 produtos)	\N	213228	Geral	Kit Reparador Tododia Flor de Cereja e Abacate (3 produtos)\nRef: 213228	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa4f226a0/produto-joia/background/desktop/213228.jpg	5	0.00	0.00	2026-03-08 00:12:30.687926-03	2026-02-27 20:04:52.258216-03
1235	Kit Shampoo 2 em 1 Naturé com Refil	\N	228457	Cabelos	Kit Shampoo 2 em 1 Naturé com Refil\nRef: 228457	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwaf194c0f/produto-joia/background/desktop/228457.jpg	5	0.00	0.00	2026-03-08 00:13:19.962299-03	2026-02-27 20:04:59.473973-03
1238	Refil Difusor de Ambiente Natura Bothânica Cyan Serenum	\N	170135	Geral	Refil Difusor de Ambiente Natura Bothânica Cyan Serenum\nRef: 170135	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdc857589/produto-joia/background/desktop/170135.jpg	5	160.00	160.00	2026-03-08 00:14:08.900662-03	2026-02-27 20:04:59.475323-03
1240	Kit Lumina Reconstrução de Danos Extremos (4 produtos)	\N	217193	Geral	Kit Lumina Reconstrução de Danos Extremos (4 produtos)\nRef: 217193	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwed0c1cc7/produto-joia/background/desktop/217193.jpg	5	0.00	0.00	2026-03-08 00:14:36.735117-03	2026-02-27 20:04:59.482176-03
1243	Refil Colônia Naturé Catavento 100 ml	\N	156244	Perfumaria	Refil Colônia Naturé Catavento 100 ml\nRef: 156244	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe374b55c/produto-joia/background/desktop/156244.jpg	5	0.00	0.00	2026-03-08 00:15:24.618923-03	2026-02-27 20:04:59.483182-03
1246	Kit Desodorante Spray Corporal Biografia Feminino (3 produtos)	\N	216062	Corpo e Banho	Kit Desodorante Spray Corporal Biografia Feminino (3 produtos)\nRef: 216062	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwff04e0c3/produto-joia/background/desktop/216062.jpg	5	0.00	0.00	2026-03-08 00:16:19.481116-03	2026-02-27 20:04:59.49152-03
1259	Corretivo Cushion Nude Me Una	\N	107127	Maquiagem	Corretivo Cushion Nude Me Una\nRef: 107127	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6bd1909c/Produtos/NATBRA-107127_1.jpg	5	0.00	0.00	2026-03-08 01:14:02.689052-03	2026-02-27 20:05:13.291888-03
1261	Refil Studio Palette Una	\N	106125	Geral	Refil Studio Palette Una\nRef: 106125	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4b2cea9b/produto-joia/background/desktop/106125.jpg	5	0.00	0.00	2026-03-08 01:14:28.90479-03	2026-02-27 20:05:13.296889-03
1264	Base Líquida Checkmatte Faces	\N	97648	Maquiagem	Base Líquida Checkmatte Faces\nRef: 97648	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9cf0c557/Produtos/NATBRA-97648_1.jpg	5	0.00	0.00	2026-03-08 01:15:18.380438-03	2026-02-27 20:05:13.303509-03
1266	Base Sérum Nude Me Una	\N	110183	Maquiagem	Base Sérum Nude Me Una\nRef: 110183	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw924af78a/Produtos/NATBRA-110183_1.jpg	5	0.00	0.00	2026-03-08 01:15:50.438225-03	2026-02-27 20:05:13.30771-03
1269	Águas Framboesa Feminino 170 ml	\N	166361	Geral	Águas Framboesa Feminino 170 ml\nRef: 166361	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw80704c99/produto-joia/background/desktop/166361.jpg	5	116.90	116.90	2026-03-08 01:16:36.055779-03	2026-02-27 20:05:13.313418-03
1271	Delineador Retrátil Faces	\N	137959	Maquiagem	Delineador Retrátil Faces\nRef: 137959	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3710295d/produto-joia/background/desktop/PAI109141.jpg	5	0.00	0.00	2026-03-08 01:17:02.851525-03	2026-02-27 20:05:13.316752-03
1273	Base Tint Extremo Conforto FPS 40 Una 30 ml	\N	135025	Maquiagem	Base Tint Extremo Conforto FPS 40 Una 30 ml\nRef: 135025	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw59f55f8b/Produtos/NATBRA-135025_1.jpg	5	79.90	79.90	2026-03-08 01:17:28.280145-03	2026-02-27 20:05:13.320752-03
1276	Kit Rotina Flacidez Chronos Derma (3 produtos)	\N	218219	Geral	Kit Rotina Flacidez Chronos Derma (3 produtos)\nRef: 218219	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe77c5198/produto-joia/background/desktop/218219.jpg	5	0.00	0.00	2026-03-08 01:18:07.873611-03	2026-02-27 20:05:13.325515-03
1280	Kit Luna e Luna Radiante (2 unidades)	\N	216476	Geral	Kit Luna e Luna Radiante (2 unidades)\nRef: 216476	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf3d5f039/produto-joia/background/desktop/216476.jpg	5	0.00	0.00	2026-03-08 01:19:02.010826-03	2026-02-27 20:05:13.336047-03
1282	Sacola Premium Gratidão Crer Para Ver	\N	195640	Geral	Sacola Premium Gratidão Crer Para Ver\nRef: 195640	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9ea52ad1/produto-joia/background/desktop/195640.jpg	5	13.90	13.90	2026-03-08 01:19:31.592209-03	2026-02-27 20:05:21.812357-03
1284	Refil Studio Palette Una	\N	106128	Geral	Refil Studio Palette Una\nRef: 106128	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfc9d8bfb/Produtos/NATBRA-106128_1.jpg	5	0.00	0.00	2026-03-08 01:19:55.799904-03	2026-02-27 20:05:21.813364-03
1287	Kit Meu Primeiro Humor Feminino 75 ml (2 unidades)	\N	221662	Geral	Kit Meu Primeiro Humor Feminino 75 ml (2 unidades)\nRef: 221662	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw978952ce/produto-joia/background/desktop/221662.jpg	5	0.00	0.00	2026-03-08 01:20:37.716236-03	2026-02-27 20:05:21.821725-03
1290	Kit Condicionador Lumina Força e Reparação Molecular com Refil	\N	228451	Cabelos	Kit Condicionador Lumina Força e Reparação Molecular com Refil\nRef: 228451	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5398e207/produto-joia/background/desktop/228451.jpg	5	0.00	0.00	2026-03-08 01:21:14.38625-03	2026-02-27 20:05:21.82992-03
1292	Batom Color Tint FPS 8 Faces	\N	6586	Maquiagem	Batom Color Tint FPS 8 Faces\nRef: 6586	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw13704a77/Produtos/NATBRA-6586_1.jpg	5	0.00	0.00	2026-03-08 01:21:42.546813-03	2026-02-27 20:05:21.82992-03
1294	Base Matte Una	\N	108125	Maquiagem	Base Matte Una\nRef: 108125	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw11609f79/NATBRA-108125_1.jpg	5	99.90	99.90	2026-03-08 01:22:07.668457-03	2026-02-27 20:05:21.82992-03
1297	Base Líquida HD Una	\N	191617	Maquiagem	Base Líquida HD Una\nRef: 191617	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe3b314d0/produto-joia/background/desktop/191617.jpg	5	159.90	159.90	2026-03-08 01:22:39.101498-03	2026-02-27 20:05:21.838128-03
1299	Batom Color Tint FPS 8 Faces	\N	6589	Maquiagem	Batom Color Tint FPS 8 Faces\nRef: 6589	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw34683e09/Produtos/NATBRA-6589_1.jpg	5	0.00	0.00	2026-03-08 01:23:10.181835-03	2026-02-27 20:05:21.838128-03
1300	Spray de Ambientes Natura Bothânica Aura Gingi	\N	139804	Geral	Spray de Ambientes Natura Bothânica Aura Gingi\nRef: 139804	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwffdb1d15/produto-joia/background/desktop/139804.jpg	5	240.00	240.00	2026-03-08 01:23:36.299692-03	2026-02-27 20:05:21.846476-03
1304	Shampoo Cabelo Corpo e Barba Essencial Supreme 300 ml	\N	151545	Cabelos	Shampoo Cabelo Corpo e Barba Essencial Supreme 300 ml\nRef: 151545	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw37dcd3ca/produto-joia/background/desktop/151545.jpg	5	0.00	0.00	2026-03-08 01:24:19.428544-03	2026-02-27 20:05:21.846476-03
1306	Kit Lumina Crespos Shampoo, Condicionador e Gelatina (3 produtos)	\N	217200	Cabelos	Kit Lumina Crespos Shampoo, Condicionador e Gelatina (3 produtos)\nRef: 217200	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1de76fcf/produto-joia/background/desktop/217200.jpg	5	0.00	0.00	2026-03-08 01:24:58.485325-03	2026-02-27 20:05:29.569972-03
1309	Kit Shampoo Purificante Lumina para Hidratação e Proteção Antipoluição com Refil (2 produtos)	\N	219732	Cabelos	Kit Shampoo Purificante Lumina para Hidratação e Proteção Antipoluição com Refil (2 produtos)\nRef: 219732	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf10bf4be/produto-joia/background/desktop/219732.jpg	5	0.00	0.00	2026-03-08 01:25:40.182432-03	2026-02-27 20:05:29.578419-03
1313	Kit Naturé Colônia Corre Corre e Hidratante (2 produtos)	\N	218211	Perfumaria	Kit Naturé Colônia Corre Corre e Hidratante (2 produtos)\nRef: 218211	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwde97c9ee/produto-joia/background/desktop/218211.jpg	5	0.00	0.00	2026-03-08 01:26:26.82944-03	2026-02-27 20:05:29.586656-03
1315	Base Líquida HD Una	\N	191636	Maquiagem	Base Líquida HD Una\nRef: 191636	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwab371a5a/produto-joia/background/desktop/191636.jpg	5	159.90	159.90	2026-03-08 01:27:03.463967-03	2026-02-27 20:05:29.586656-03
1318	Polpa Hidratante Para as Mãos Ekos Amazô	\N	140927	Corpo e Banho	Polpa Hidratante Para as Mãos Ekos Amazô\nRef: 140927	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw298db13d/produto-joia/background/desktop/140927.jpg	5	0.00	0.00	2026-03-08 01:27:29.064983-03	2026-02-27 20:05:29.586656-03
1320	Kit Mamãe e Bebê Sem Fragrância (3 produtos)	\N	218193	Infantil	Kit Mamãe e Bebê Sem Fragrância (3 produtos)\nRef: 218193	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcafd624b/produto-joia/background/desktop/218193.jpg	5	0.00	0.00	2026-03-08 01:28:10.376924-03	2026-02-27 20:05:29.595047-03
1323	Base Líquida Faces Checkmatte	\N	166349	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166349	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8e126dce/produto-joia/background/desktop/166349.jpg	5	45.90	45.90	2026-03-08 01:28:49.928211-03	2026-02-27 20:05:29.595047-03
1325	Refil Studio Palette Una	\N	106127	Geral	Refil Studio Palette Una\nRef: 106127	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1d5f4856/Produtos/NATBRA-106127_1.jpg	5	0.00	0.00	2026-03-08 01:29:23.079779-03	2026-02-27 20:05:29.603783-03
1327	Kit Nutritivo Tododia Pêssego e Amêndoa (4 produtos)	\N	206194	Geral	Kit Nutritivo Tododia Pêssego e Amêndoa (4 produtos)\nRef: 206194	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe123432b/produto-joia/background/desktop/206194.jpg	5	0.00	0.00	2026-03-08 01:29:49.911207-03	2026-02-27 20:05:29.603783-03
1331	Kit Creme Antissinais 70+ Noite com Refil	\N	228441	Corpo e Banho	Kit Creme Antissinais 70+ Noite com Refil\nRef: 228441	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4ef225ce/produto-joia/background/desktop/228441.jpg	5	0.00	0.00	2026-03-08 01:30:31.905957-03	2026-02-27 20:05:38.36192-03
1333	Gloss Labial Faces	\N	175105	Geral	Gloss Labial Faces\nRef: 175105	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0b36799a/produto-joia/background/desktop/175105.jpg	5	0.00	0.00	2026-03-08 01:31:00.573677-03	2026-02-27 20:05:38.369315-03
1350	Produto 252075	\N	252075	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.41531-03	2026-02-27 20:05:38.41531-03
1351	Produto 191634	\N	191634	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.418051-03	2026-02-27 20:05:38.419515-03
1352	Produto 231703	\N	231703	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.421522-03	2026-02-27 20:05:38.421522-03
1353	Produto 98942	\N	98942	Geral	Descoberto em Todos os Produtos (Pág 68)	\N	5	0.00	\N	2026-02-27 20:05:38.423528-03	2026-02-27 20:05:38.423528-03
1354	Produto 16269	\N	16269	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.179673-03	2026-02-27 20:05:46.180674-03
1355	Produto 8297	\N	8297	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.183616-03	2026-02-27 20:05:46.183921-03
1356	Produto 167182	\N	167182	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.186173-03	2026-02-27 20:05:46.186173-03
1357	Produto 173609	\N	173609	Geral	Descoberto em Todos os Produtos (Pág 69)	\N	5	0.00	\N	2026-02-27 20:05:46.188206-03	2026-02-27 20:05:46.189173-03
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
1387	Produto 133024	\N	133024	Geral	Descoberto em Todos os Produtos (Pág 70)	\N	5	0.00	\N	2026-02-27 20:05:53.816803-03	2026-02-27 20:05:53.816803-03
1338	Corretivo Checkmatte Faces	\N	116692	Maquiagem	Corretivo Checkmatte Faces\nRef: 116692	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4f6f4c63/Produtos/NATBRA-116692_1.jpg	5	34.90	34.90	2026-03-08 01:31:55.053595-03	2026-02-27 20:05:38.381041-03
1341	Kit Ekos Andiroba Completo	\N	239990	Geral	Kit Ekos Andiroba Completo\nRef: 239990	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa07ac182/produto-joia/background/desktop/239990.jpg	5	0.00	0.00	2026-03-08 01:32:38.293256-03	2026-02-27 20:05:38.392169-03
1342	Kit Faces Lip Combo Gloss Brown Star e Lápis Marrom	\N	244741	Geral	Kit Faces Lip Combo Gloss Brown Star e Lápis Marrom\nRef: 244741	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw194b4b93/produto-joia/background/desktop/244741.jpg	5	0.00	0.00	2026-03-08 01:33:01.978522-03	2026-02-27 20:05:38.39441-03
1345	Batom Color Tint FPS 8 Faces	\N	6588	Maquiagem	Batom Color Tint FPS 8 Faces\nRef: 6588	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd77d2cd6/Produtos/NATBRA-6588_1.jpg	5	0.00	0.00	2026-03-08 01:33:44.559351-03	2026-02-27 20:05:38.40264-03
1348	Esmalte Faces 6ml	\N	106543	Geral	Esmalte Faces 6ml\nRef: 106543	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw00abb178/Produtos/NATBRA-106543_1.jpg	5	0.00	0.00	2026-03-08 01:34:30.391412-03	2026-02-27 20:05:38.410885-03
1349	Refil Desodorante Hidratante Corporal Luna Ousadia	\N	129617	Corpo e Banho	Refil Desodorante Hidratante Corporal Luna Ousadia\nRef: 129617	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc5c3ca2d/produto-joia/background/desktop/129617.jpg	5	66.90	66.90	2026-03-08 01:34:45.788853-03	2026-02-27 20:05:38.413302-03
1360	Lápis para Olhos Duo Una Celebrar	\N	196320	Geral	Lápis para Olhos Duo Una Celebrar\nRef: 196320	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw18177782/produto-joia/background/desktop/196320.jpg	5	59.90	59.90	2026-03-08 02:16:53.190458-03	2026-02-27 20:05:46.194128-03
1363	Kit Rotina Antirugas Chronos Derma (2 produtos)	\N	219714	Geral	Kit Rotina Antirugas Chronos Derma (2 produtos)\nRef: 219714	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2c79afa8/produto-joia/background/desktop/219714.jpg	5	0.00	0.00	2026-03-08 02:17:26.533622-03	2026-02-27 20:05:46.198148-03
1365	Esmalte Faces 6ml	\N	106542	Geral	Esmalte Faces 6ml\nRef: 106542	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb8e47856/Produtos/NATBRA-106542_1.jpg	5	0.00	0.00	2026-03-08 02:17:55.205814-03	2026-02-27 20:05:46.202488-03
1367	Refil Base Líquida HD Una	\N	173601	Maquiagem	Refil Base Líquida HD Una\nRef: 173601	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw62191488/produto-joia/background/desktop/173601.jpg	5	109.90	109.90	2026-03-08 02:18:19.602818-03	2026-02-27 20:05:46.205486-03
1370	Kit Águas Lavanda Feminino 170 ml (2 unidades)	\N	241062	Geral	Kit Águas Lavanda Feminino 170 ml (2 unidades)\nRef: 241062	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6d44eb1d/Produtos/NATBRA-241062_1.jpg	5	0.00	0.00	2026-03-08 02:19:04.48763-03	2026-02-27 20:05:46.2107-03
1372	Refil Studio Palette Una	\N	106137	Geral	Refil Studio Palette Una\nRef: 106137	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6e822fc1/Produtos/NATBRA-106137_1.jpg	5	0.00	0.00	2026-03-08 02:19:32.325404-03	2026-02-27 20:05:46.213701-03
1374	Base Matte Powder Una	\N	127768	Maquiagem	Base Matte Powder Una\nRef: 127768	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb1ca1da9/Produtos/NATBRA-127768_1.jpg	5	0.00	0.00	2026-03-08 02:19:57.503915-03	2026-02-27 20:05:53.783949-03
1386	Corretivo Cushion Nude Me Una	\N	107126	Maquiagem	Corretivo Cushion Nude Me Una\nRef: 107126	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw68858000/Produtos/NATBRA-107126_1.jpg	5	0.00	0.00	2026-03-08 03:17:10.865776-03	2026-02-27 20:05:53.816803-03
1388	Esmalte 3D Gel Una - Origami 110	\N	15822	Geral	Esmalte 3D Gel Una - Origami 110\nRef: 15822	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9329e108/Produtos/NATBRA-15822_1.jpg	5	0.00	0.00	2026-03-08 03:17:48.5873-03	2026-02-27 20:05:53.816803-03
1392	Óleo Hidratante Corpo Natura Bothânica Origins	\N	139801	Corpo e Banho	Óleo Hidratante Corpo Natura Bothânica Origins\nRef: 139801	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb353f741/produto-joia/background/desktop/139801.jpg	5	180.00	180.00	2026-03-08 03:19:03.372919-03	2026-02-27 20:05:53.825086-03
1559	Vela Natura Bothânica Aura Gingi	\N	139249	Geral	Vela Natura Bothânica Aura Gingi\nRef: 139249	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb975fc76/produto-joia/background/desktop/139249.jpg	5	210.00	210.00	2026-03-08 05:29:25.693032-03	2026-02-27 20:07:18.937283-03
1436	Produto 138035	\N	138035	Geral	Descoberto em Todos os Produtos (Pág 74)	\N	5	0.00	\N	2026-02-27 20:06:24.678879-03	2026-02-27 20:06:24.678879-03
1396	Batom Matte Powder Una	\N	95780	Maquiagem	Batom Matte Powder Una\nRef: 95780	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf0e84979/produto-joia/background/desktop/95780.jpg	5	59.90	59.90	2026-03-08 03:19:17.482104-03	2026-02-27 20:05:53.832356-03
1399	Kit Ekos Murumuru Shampoo, Condicionador e Creme para Pentear	\N	239995	Cabelos	Kit Ekos Murumuru Shampoo, Condicionador e Creme para Pentear\nRef: 239995	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9267f160/produto-joia/background/desktop/239995.jpg	5	0.00	0.00	2026-03-08 03:19:46.225507-03	2026-02-27 20:06:16.064061-03
1403	Base Líquida HD Una	\N	191620	Maquiagem	Base Líquida HD Una\nRef: 191620	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8832fe5e/produto-joia/background/desktop/191620.jpg	5	159.90	159.90	2026-03-08 03:20:26.19584-03	2026-02-27 20:06:16.071765-03
1404	Kit Ekos Tukumã Creme para o Corpo e Refil	\N	239977	Corpo e Banho	Kit Ekos Tukumã Creme para o Corpo e Refil\nRef: 239977	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa5ced182/produto-joia/background/desktop/239977.jpg	5	0.00	0.00	2026-03-08 03:20:50.537015-03	2026-02-27 20:06:16.079033-03
1406	Refil Sérum Intensivo Redutor de Oleosidade Chronos Derma	\N	169244	Geral	Refil Sérum Intensivo Redutor de Oleosidade Chronos Derma\nRef: 169244	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw90cfdc43/produto-joia/background/desktop/169244.jpg	5	0.00	0.00	2026-03-08 03:21:32.965198-03	2026-02-27 20:06:16.080038-03
1405	Esponja Color Blend Faces	\N	16641	Geral	Esponja Color Blend Faces\nRef: 16641	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1d81daaa/produto-joia/background/desktop/16641.jpg	5	39.90	39.90	2026-03-08 03:21:59.319585-03	2026-02-27 20:06:16.080038-03
1410	Refil Pó Compacto Nude Me Una	\N	110682	Maquiagem	Refil Pó Compacto Nude Me Una\nRef: 110682	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw84e332e5/Produtos/NATBRA-110682_1.jpg	5	64.90	64.90	2026-03-08 03:22:32.398349-03	2026-02-27 20:06:16.088244-03
1413	Condicionador Nutrição e Brilho Natura Plant	\N	60001	Cabelos	Condicionador Nutrição e Brilho Natura Plant\nRef: 60001	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwecd6dac1/produto-joia/background/desktop/60001.jpg	5	0.00	0.00	2026-03-08 03:22:54.483443-03	2026-02-27 20:06:16.088244-03
1418	Refil Base Líquida HD Una	\N	173592	Maquiagem	Refil Base Líquida HD Una\nRef: 173592	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0e8603bb/produto-joia/background/desktop/173592.jpg	5	109.90	109.90	2026-03-08 03:23:31.261762-03	2026-02-27 20:06:16.097817-03
1416	Kit Ekos Maracujá Creme para o Corpo e Mãos	\N	239971	Corpo e Banho	Kit Ekos Maracujá Creme para o Corpo e Mãos\nRef: 239971	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw02d13560/produto-joia/background/desktop/239971.jpg	5	0.00	0.00	2026-03-08 03:23:59.008562-03	2026-02-27 20:06:16.097817-03
1421	Delineador Retrátil Faces	\N	137960	Maquiagem	Delineador Retrátil Faces\nRef: 137960	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3710295d/produto-joia/background/desktop/PAI109141.jpg	5	0.00	0.00	2026-03-08 03:24:35.761717-03	2026-02-27 20:06:16.105123-03
1424	Sabonete Líquido Kaiak Feminino	\N	108874	Corpo e Banho	Sabonete Líquido Kaiak Feminino\nRef: 108874	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc8a27607/produto-joia/background/desktop/108874.jpg	5	54.90	54.90	2026-03-08 03:25:21.962087-03	2026-02-27 20:06:24.654231-03
1426	Base Líquida HD Una	\N	191618	Maquiagem	Base Líquida HD Una\nRef: 191618	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc76db046/produto-joia/background/desktop/191618.jpg	5	159.90	159.90	2026-03-08 03:25:43.588946-03	2026-02-27 20:06:24.662158-03
1428	Base Líquida HD Una	\N	191623	Maquiagem	Base Líquida HD Una\nRef: 191623	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbdb02805/produto-joia/background/desktop/191623.jpg	5	159.90	159.90	2026-03-08 03:26:09.97169-03	2026-02-27 20:06:24.662158-03
1435	Batom Matte Intransferível Una 8ml	\N	107327	Maquiagem	Batom Matte Intransferível Una 8ml\nRef: 107327	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw999dd2d0/produto-joia/background/desktop/167329.jpg	5	0.00	0.00	2026-03-08 03:26:53.969335-03	2026-02-27 20:06:24.677873-03
1431	Kit Creme Nutritivo com Refil Tododia Capim Limão e Hortelã	\N	239224	Corpo e Banho	Kit Creme Nutritivo com Refil Tododia Capim Limão e Hortelã\nRef: 239224	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw809a328f/produto-joia/background/desktop/239224.jpg	5	0.00	0.00	2026-03-08 03:27:33.646445-03	2026-02-27 20:06:24.670626-03
1437	Kit Lumina Anticaspa (2 produtos)	\N	217196	Geral	Kit Lumina Anticaspa (2 produtos)\nRef: 217196	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwadaa81d0/produto-joia/background/desktop/217196.jpg	5	0.00	0.00	2026-03-08 03:27:56.941872-03	2026-02-27 20:06:24.678879-03
1438	Base Líquida HD Una	\N	191637	Maquiagem	Base Líquida HD Una\nRef: 191637	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2ea924b9/produto-joia/background/desktop/191637.jpg	5	159.90	159.90	2026-03-08 03:28:34.739405-03	2026-02-27 20:06:24.678879-03
1442	Base Sérum Nude Me Una	\N	110197	Maquiagem	Base Sérum Nude Me Una\nRef: 110197	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe1a39791/Produtos/NATBRA-110197_1.jpg	5	0.00	0.00	2026-03-08 03:29:22.694555-03	2026-02-27 20:06:24.687141-03
1444	Refil Studio Palette Una	\N	106132	Geral	Refil Studio Palette Una\nRef: 106132	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwce8c7f6d/Produtos/NATBRA-106132_1.jpg	5	0.00	0.00	2026-03-08 03:29:48.8611-03	2026-02-27 20:06:24.687141-03
1447	Kit Caneta Delineadora para Olhos e Esmalte 3D Gel Una	\N	228444	Maquiagem	Kit Caneta Delineadora para Olhos e Esmalte 3D Gel Una\nRef: 228444	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3db7423e/produto-joia/background/desktop/228444.jpg	5	0.00	0.00	2026-03-08 03:30:16.876616-03	2026-02-27 20:06:40.24318-03
1449	Pochete Natura Humor	\N	140743	Geral	Pochete Natura Humor\nRef: 140743	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfa9c947f/produto-joia/background/desktop/140743.jpg	5	0.00	0.00	2026-03-08 03:30:43.290514-03	2026-02-27 20:06:40.251619-03
1478	Produto 178160	\N	178160	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.080249-03	2026-02-27 20:06:56.080249-03
1479	Produto 8885	\N	8885	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.081576-03	2026-02-27 20:06:56.081576-03
1480	Produto 8884	\N	8884	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.083579-03	2026-02-27 20:06:56.083579-03
1481	Produto 252080	\N	252080	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.084578-03	2026-02-27 20:06:56.085578-03
1482	Produto 252081	\N	252081	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.086578-03	2026-02-27 20:06:56.086578-03
1483	Produto 151703	\N	151703	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.087577-03	2026-02-27 20:06:56.088578-03
1484	Produto 116885	\N	116885	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.089577-03	2026-02-27 20:06:56.089577-03
1485	Produto 177729	\N	177729	Geral	Descoberto em Todos os Produtos (Pág 78)	\N	5	0.00	\N	2026-02-27 20:06:56.090793-03	2026-02-27 20:06:56.091793-03
1492	Produto 131338	\N	131338	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.922897-03	2026-02-27 20:07:03.922897-03
1505	Produto 106131	\N	106131	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.939495-03	2026-02-27 20:07:03.939495-03
1506	Produto 106136	\N	106136	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.946891-03	2026-02-27 20:07:03.947897-03
1507	Produto 106134	\N	106134	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.947897-03	2026-02-27 20:07:03.947897-03
1508	Produto 116698	\N	116698	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.947897-03	2026-02-27 20:07:03.947897-03
1452	Esmalte Faces 6ml	\N	106544	Geral	Esmalte Faces 6ml\nRef: 106544	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw21f05bd4/Produtos/NATBRA-106544_1.jpg	5	0.00	0.00	2026-03-08 03:32:07.379575-03	2026-02-27 20:06:40.259869-03
1459	Batom Matte Longa Duração Faces	\N	111425	Maquiagem	Batom Matte Longa Duração Faces\nRef: 111425	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwda81baf7/produto-joia/background/desktop/111425.jpg	5	49.90	49.90	2026-03-08 03:32:40.973803-03	2026-02-27 20:06:40.267857-03
1456	Sombra Retrátil para Olhos Faces	\N	177723	Geral	Sombra Retrátil para Olhos Faces\nRef: 177723	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw18177782/produto-joia/background/desktop/177723.jpg	5	0.00	0.00	2026-03-08 03:33:05.75053-03	2026-02-27 20:06:40.267857-03
1464	Refil Base Líquida HD Una	\N	173591	Maquiagem	Refil Base Líquida HD Una\nRef: 173591	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw876119b3/produto-joia/background/desktop/173591.jpg	5	109.90	109.90	2026-03-08 03:33:35.684215-03	2026-02-27 20:06:40.276194-03
1461	Kit Condicionador com Refil Lumina Restauração e Liso Prolongado	\N	239212	Cabelos	Kit Condicionador com Refil Lumina Restauração e Liso Prolongado\nRef: 239212	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5c3ce837/produto-joia/background/desktop/239212.jpg	5	0.00	0.00	2026-03-08 03:34:07.629152-03	2026-02-27 20:06:40.276194-03
1466	Base Stick FPS 50 Una	\N	181516	Maquiagem	Base Stick FPS 50 Una\nRef: 181516	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9d12c197/produto-joia/background/desktop/181516.jpg	5	119.90	119.90	2026-03-08 03:35:02.907142-03	2026-02-27 20:06:40.284571-03
1469	Refil Base Fluida HD Una	\N	104875	Maquiagem	Refil Base Fluida HD Una\nRef: 104875	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw77f4face/Produtos/NATBRA-104875_1.jpg	5	0.00	0.00	2026-03-08 03:35:33.983655-03	2026-02-27 20:06:56.06071-03
1470	Kit Lápis e Caneta Crer Para Ver	\N	170766	Geral	Kit Lápis e Caneta Crer Para Ver\nRef: 170766	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfc3b2dd5/produto-joia/background/desktop/170766.jpg	5	23.90	23.90	2026-03-08 03:35:46.553966-03	2026-02-27 20:06:56.064858-03
1474	Base Tint Extremo Conforto FPS 40 Una 30 ml	\N	135042	Maquiagem	Base Tint Extremo Conforto FPS 40 Una 30 ml\nRef: 135042	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw30936994/Produtos/NATBRA-135042_1.jpg	5	79.90	79.90	2026-03-08 03:36:32.091562-03	2026-02-27 20:06:56.073091-03
1476	Sombra Líquida Fix Una 4g	\N	137968	Geral	Sombra Líquida Fix Una 4g\nRef: 137968	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa144cacc/Produtos/NATBRA-137968_1.jpg	5	79.90	79.90	2026-03-08 03:36:59.248234-03	2026-02-27 20:06:56.07725-03
1486	Batom Matte Longa Duração Faces	\N	111398	Maquiagem	Batom Matte Longa Duração Faces\nRef: 111398	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa01f45a9/produto-joia/background/desktop/111398.jpg	5	49.90	49.90	2026-03-08 04:18:43.152295-03	2026-02-27 20:06:56.092795-03
1488	Base Líquida Faces Checkmatte	\N	166344	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166344	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2b29c25a/produto-joia/background/desktop/166344.jpg	5	45.90	45.90	2026-03-08 04:19:12.347958-03	2026-02-27 20:06:56.095793-03
1491	Base Líquida Faces Checkmatte	\N	166339	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166339	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3f5a4ba2/produto-joia/background/desktop/166339.jpg	5	45.90	45.90	2026-03-08 04:19:54.556025-03	2026-02-27 20:07:03.922897-03
1494	Batom Gel Lip Stain Una	\N	119426	Maquiagem	Batom Gel Lip Stain Una\nRef: 119426	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw810d5fd8/Produtos/NATBRA-119426_1.jpg	5	0.00	0.00	2026-03-08 04:20:27.047809-03	2026-02-27 20:07:03.922897-03
1496	Base Líquida Faces Checkmatte	\N	166333	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166333	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf824594b/produto-joia/background/desktop/166333.jpg	5	45.90	45.90	2026-03-08 04:20:57.610731-03	2026-02-27 20:07:03.931138-03
1499	Prato de Sobremesa Crer Para Ver	\N	176438	Geral	Prato de Sobremesa Crer Para Ver\nRef: 176438	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw848073c6/produto-joia/background/desktop/176438.jpg	5	38.90	38.90	2026-03-08 04:21:31.092097-03	2026-02-27 20:07:03.931138-03
1501	Delineador Retrátil Faces	\N	137955	Maquiagem	Delineador Retrátil Faces\nRef: 137955	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3710295d/produto-joia/background/desktop/PAI109141.jpg	5	0.00	0.00	2026-03-08 04:21:48.548722-03	2026-02-27 20:07:03.939495-03
1503	Sombra Mono Faces	\N	109154	Geral	Sombra Mono Faces\nRef: 109154	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb75efc2f/Produtos/NATBRA-109154_1.jpg	5	39.90	39.90	2026-03-08 04:22:11.539605-03	2026-02-27 20:07:03.939495-03
1509	Produto 102871	\N	102871	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.947897-03	2026-02-27 20:07:03.947897-03
1510	Produto 116696	\N	116696	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.947897-03	2026-02-27 20:07:03.947897-03
1511	Produto 106551	\N	106551	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.955275-03	2026-02-27 20:07:03.956342-03
1512	Produto 163222	\N	163222	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.956342-03	2026-02-27 20:07:03.956342-03
1513	Produto 116695	\N	116695	Geral	Descoberto em Todos os Produtos (Pág 79)	\N	5	0.00	\N	2026-02-27 20:07:03.956342-03	2026-02-27 20:07:03.956342-03
1514	Produto 106535	\N	106535	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.087696-03	2026-02-27 20:07:11.087696-03
1552	Base Matte Una	\N	108133	Maquiagem	Base Matte Una\nRef: 108133	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa70dcbc2/Produtos/NATBRA-108133_1.jpg	5	99.90	99.90	2026-03-08 05:28:03.57569-03	2026-02-27 20:07:18.928763-03
1554	Base Matte Una	\N	108151	Maquiagem	Base Matte Una\nRef: 108151	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw944e80c1/Produtos/NATBRA-108151_1.jpg	5	99.90	99.90	2026-03-08 05:28:28.21573-03	2026-02-27 20:07:18.928763-03
1517	Produto 137958	\N	137958	Geral	Descoberto em Todos os Produtos (Pág 80)	\N	5	0.00	\N	2026-02-27 20:07:11.095902-03	2026-02-27 20:07:11.095902-03
1560	Vela Natura Bothânica Divinus Plantae	\N	139251	Geral	Vela Natura Bothânica Divinus Plantae\nRef: 139251	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7ece4d7a/produto-joia/background/desktop/139251.jpg	5	210.00	210.00	2026-03-08 05:28:52.684706-03	2026-02-27 20:07:18.937283-03
1558	Base Matte Powder Una	\N	127757	Maquiagem	Base Matte Powder Una\nRef: 127757	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6cb6ae3b/Produtos/NATBRA-127757_1.jpg	5	0.00	0.00	2026-03-08 05:29:16.855429-03	2026-02-27 20:07:18.937283-03
1562	Blend de Óleos Essenciais Despertar Bothânica	\N	140039	Corpo e Banho	Blend de Óleos Essenciais Despertar Bothânica\nRef: 140039	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw79e2fe9f/produto-joia/background/desktop/140039.jpg	5	140.00	140.00	2026-03-08 05:29:48.825931-03	2026-02-27 20:07:34.327228-03
1566	Refil Base Líquida HD Una	\N	173596	Maquiagem	Refil Base Líquida HD Una\nRef: 173596	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7847bbb0/produto-joia/background/desktop/173596.jpg	5	109.90	109.90	2026-03-08 05:30:18.993886-03	2026-02-27 20:07:34.335623-03
1541	Produto 104895	\N	104895	Geral	Descoberto em Todos os Produtos (Pág 81)	\N	5	0.00	\N	2026-02-27 20:07:18.912032-03	2026-02-27 20:07:18.912032-03
1519	Spray de Ambientes Natura Bothânica Nobilis Antique	\N	139803	Geral	Spray de Ambientes Natura Bothânica Nobilis Antique\nRef: 139803	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw257d8285/produto-joia/background/desktop/139803.jpg	5	240.00	240.00	2026-03-08 05:20:21.983129-03	2026-02-27 20:07:11.108642-03
1522	Refil Base Líquida HD Una	\N	173599	Maquiagem	Refil Base Líquida HD Una\nRef: 173599	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7847bbb0/produto-joia/background/desktop/173599.jpg	5	109.90	109.90	2026-03-08 05:20:51.658919-03	2026-02-27 20:07:11.112609-03
1526	Kit Lumina Crespos Shampoo, Condicionador e Creme para Pentear (3 produtos)	\N	217199	Cabelos	Kit Lumina Crespos Shampoo, Condicionador e Creme para Pentear (3 produtos)\nRef: 217199	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb011edce/produto-joia/background/desktop/217199.jpg	5	0.00	0.00	2026-03-08 05:21:28.378377-03	2026-02-27 20:07:11.120895-03
1525	Batom Lip Tint Faces	\N	123025	Maquiagem	Batom Lip Tint Faces\nRef: 123025	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8c5b225d/Produtos/NATBRA-123025_1.jpg	5	0.00	0.00	2026-03-08 05:21:55.69812-03	2026-02-27 20:07:11.120895-03
1528	Kit Base Sérum Una com Pincel	\N	239265	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239265	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw019dac74/produto-joia/background/desktop/239265.jpg	5	0.00	0.00	2026-03-08 05:22:40.394389-03	2026-02-27 20:07:11.129111-03
1531	Refil Pó Compacto Matte Faces 6,5g	\N	9431	Maquiagem	Refil Pó Compacto Matte Faces 6,5g\nRef: 9431	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcd23218c/Produtos/NATBRA-9431_1.jpg	5	49.90	49.90	2026-03-08 05:23:08.453751-03	2026-02-27 20:07:11.129111-03
1532	Pó Compacto Matte Faces 6,5g	\N	8889	Maquiagem	Pó Compacto Matte Faces 6,5g\nRef: 8889	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw60aabb3d/Produtos/NATBRA-8889_1.jpg	5	0.00	0.00	2026-03-08 05:23:31.783497-03	2026-02-27 20:07:11.137546-03
1535	Refil Base Fluida HD Una	\N	104890	Maquiagem	Refil Base Fluida HD Una\nRef: 104890	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw991c277f/Produtos/NATBRA-104890_1.jpg	5	0.00	0.00	2026-03-08 05:24:09.557376-03	2026-02-27 20:07:11.137546-03
1539	Refil Base Fluida HD Una	\N	104892	Maquiagem	Refil Base Fluida HD Una\nRef: 104892	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5067ac22/Produtos/NATBRA-104892_1.jpg	5	0.00	0.00	2026-03-08 05:24:39.518402-03	2026-02-27 20:07:18.903798-03
1540	Refil Base Fluida HD Una	\N	104889	Maquiagem	Refil Base Fluida HD Una\nRef: 104889	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6d6c04b9/Produtos/NATBRA-104889_1.jpg	5	0.00	0.00	2026-03-08 05:25:04.976053-03	2026-02-27 20:07:18.903798-03
1545	Humor Estelar Masculino 75 ml	\N	110082	Homem	Humor Estelar Masculino 75 ml\nRef: 110082	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5d26eb56/produto-joia/background/desktop/110082.jpg	5	0.00	0.00	2026-03-08 05:25:42.691718-03	2026-02-27 20:07:18.912032-03
1542	Refil Pó Compacto Nude Me Una	\N	110685	Maquiagem	Refil Pó Compacto Nude Me Una\nRef: 110685	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbbf84569/Produtos/NATBRA-110685_1.jpg	5	64.90	64.90	2026-03-08 05:26:14.299971-03	2026-02-27 20:07:18.912032-03
1547	Corretivo Checkmatte Faces	\N	116697	Maquiagem	Corretivo Checkmatte Faces\nRef: 116697	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6211bae5/Produtos/NATBRA-116697_1.jpg	5	34.90	34.90	2026-03-08 05:26:53.829503-03	2026-02-27 20:07:18.920299-03
1549	Acessório Natura Biōme	\N	118042	Geral	Acessório Natura Biōme\nRef: 118042	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1ff3c44d/produto-joia/background/desktop/118042.jpg	5	149.90	149.90	2026-03-08 05:27:15.183515-03	2026-02-27 20:07:18.920299-03
1604	Produto 204417	\N	204417	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.850328-03	2026-02-27 20:07:41.850328-03
1605	Produto 216061	\N	216061	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.857812-03	2026-02-27 20:07:41.857812-03
1606	Produto 217176	\N	217176	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.858708-03	2026-02-27 20:07:41.858708-03
1607	Produto 216065	\N	216065	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.858708-03	2026-02-27 20:07:41.858708-03
1608	Produto 213219	\N	213219	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.858708-03	2026-02-27 20:07:41.858708-03
1609	Produto 215272	\N	215272	Geral	Descoberto em Todos os Produtos (Pág 84)	\N	5	0.00	\N	2026-02-27 20:07:41.866143-03	2026-02-27 20:07:41.867148-03
1610	Produto 213549	\N	213549	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.857981-03	2026-02-27 20:07:49.858936-03
1611	Produto 213556	\N	213556	Geral	Descoberto em Todos os Produtos (Pág 85)	\N	5	0.00	\N	2026-02-27 20:07:49.861989-03	2026-02-27 20:07:49.861989-03
1569	Base Líquida Faces Checkmatte	\N	166336	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166336	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3db6ea09/produto-joia/background/desktop/166336.jpg	5	45.90	45.90	2026-03-08 05:31:34.96998-03	2026-02-27 20:07:34.343412-03
1572	Kit Bothânica Meum Rituale (2 produtos)	\N	167637	Geral	Kit Bothânica Meum Rituale (2 produtos)\nRef: 167637	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcd5deea1/produto-joia/background/desktop/167637.jpg	5	340.00	340.00	2026-03-08 05:31:57.878624-03	2026-02-27 20:07:34.343412-03
1573	Refil Base Líquida HD Una	\N	173595	Maquiagem	Refil Base Líquida HD Una\nRef: 173595	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw45038d7e/produto-joia/background/desktop/173595.jpg	5	109.90	109.90	2026-03-08 05:32:36.370072-03	2026-02-27 20:07:34.351758-03
1576	Base Líquida Faces Checkmatte	\N	166334	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166334	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw04d5ece3/produto-joia/background/desktop/166334.jpg	5	45.90	45.90	2026-03-08 05:33:07.239791-03	2026-02-27 20:07:34.351758-03
1580	Difusor de Ambiente Natura Bothânica Divinus Plantae	\N	167638	Geral	Difusor de Ambiente Natura Bothânica Divinus Plantae\nRef: 167638	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1d85e77f/produto-joia/background/desktop/167638.jpg	5	250.00	250.00	2026-03-08 05:33:38.906061-03	2026-02-27 20:07:34.360143-03
1582	Desodorante Hidratante Corporal Perfumado Luna Intensa	\N	173009	Corpo e Banho	Desodorante Hidratante Corporal Perfumado Luna Intensa\nRef: 173009	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw113b99d0/Produtos/NATBRA-173009_1.jpg	5	134.90	134.90	2026-03-08 05:34:06.027346-03	2026-02-27 20:07:34.367388-03
1585	Kit Tododia Energia Flor de Gengibre e Tangerina (2 produtos)	\N	189773	Geral	Kit Tododia Energia Flor de Gengibre e Tangerina (2 produtos)\nRef: 189773	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7501659c/produto-joia/background/desktop/189773.jpg	5	0.00	0.00	2026-03-08 05:34:46.480181-03	2026-02-27 20:07:34.368372-03
1588	Base Líquida HD Una	\N	191621	Maquiagem	Base Líquida HD Una\nRef: 191621	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw292db8f4/produto-joia/background/desktop/191621.jpg	5	159.90	159.90	2026-03-08 05:35:30.540902-03	2026-02-27 20:07:41.825622-03
1589	Base Líquida HD Una	\N	191630	Maquiagem	Base Líquida HD Una\nRef: 191630	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0eff55cf/produto-joia/background/desktop/191630.jpg	5	159.90	159.90	2026-03-08 05:35:57.700419-03	2026-02-27 20:07:41.82858-03
1595	Base Líquida HD Una	\N	191631	Maquiagem	Base Líquida HD Una\nRef: 191631	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2ea1e31c/produto-joia/background/desktop/191631.jpg	5	159.90	159.90	2026-03-08 05:36:27.52052-03	2026-02-27 20:07:41.833687-03
1594	Base Líquida HD Una	\N	191624	Maquiagem	Base Líquida HD Una\nRef: 191624	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf1da9c8a/produto-joia/background/desktop/191624.jpg	5	159.90	159.90	2026-03-08 05:37:04.362188-03	2026-02-27 20:07:41.833687-03
1596	Base Stick FPS 50 Una	\N	181510	Maquiagem	Base Stick FPS 50 Una\nRef: 181510	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc4766a20/produto-joia/background/desktop/181510.jpg	5	119.90	119.90	2026-03-08 05:37:27.506875-03	2026-02-27 20:07:41.841996-03
1599	Base Stick FPS 50 Una	\N	181514	Maquiagem	Base Stick FPS 50 Una\nRef: 181514	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw52d2f5ca/produto-joia/background/desktop/181514.jpg	5	119.90	119.90	2026-03-08 05:37:51.675874-03	2026-02-27 20:07:41.841996-03
1602	Kit Lumina Hidratação e Proteção Antipoluição (3 produtos)	\N	204412	Geral	Kit Lumina Hidratação e Proteção Antipoluição (3 produtos)\nRef: 204412	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe95a7ecf/NATBRA-204412_1.jpg	5	0.00	0.00	2026-03-08 05:38:28.943352-03	2026-02-27 20:07:41.850328-03
1613	Kit Naturé Colônia Corre Corre e Sabonete em Barra (2 produtos)	\N	218205	Perfumaria	Kit Naturé Colônia Corre Corre e Sabonete em Barra (2 produtos)\nRef: 218205	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2b23e0df/produto-joia/background/desktop/218205.jpg	5	0.00	0.00	2026-03-08 06:20:33.418587-03	2026-02-27 20:07:49.866031-03
1616	Kit Luna Radiante (2 unidades)	\N	216475	Geral	Kit Luna Radiante (2 unidades)\nRef: 216475	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4c83a16e/produto-joia/background/desktop/216475.jpg	5	0.00	0.00	2026-03-08 06:21:10.532214-03	2026-02-27 20:07:49.871251-03
1618	Kit Naturé Colônia Catavento e Sabonete em Barra (2 produtos)	\N	218204	Perfumaria	Kit Naturé Colônia Catavento e Sabonete em Barra (2 produtos)\nRef: 218204	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5c7baa07/produto-joia/background/desktop/218204.jpg	5	0.00	0.00	2026-03-08 06:21:34.92393-03	2026-02-27 20:07:49.873619-03
1621	Kit Bothânica Hidratante para as Mãos Fructus Folium e Refil (2 produtos)	\N	213550	Corpo e Banho	Kit Bothânica Hidratante para as Mãos Fructus Folium e Refil (2 produtos)\nRef: 213550	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7df36bc4/produto-joia/background/desktop/213550.jpg	5	306.00	306.00	2026-03-08 06:22:09.176671-03	2026-02-27 20:07:49.878682-03
1624	Kit Spray de Volume e Protetor Térmico para Finalização Lumina (2 produtos)	\N	213218	Geral	Kit Spray de Volume e Protetor Térmico para Finalização Lumina (2 produtos)\nRef: 213218	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw14250609/produto-joia/background/desktop/213218.jpg	5	0.00	0.00	2026-03-08 06:22:41.697661-03	2026-02-27 20:07:49.882781-03
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
1628	Kit Una Artisan Deo Parfum e Gloss Labial Hidratação Ativa	\N	212782	Perfumaria	Kit Una Artisan Deo Parfum e Gloss Labial Hidratação Ativa\nRef: 212782	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw03964480/produto-joia/background/desktop/212782.jpg	5	0.00	0.00	2026-03-08 06:23:28.423693-03	2026-02-27 20:07:49.888931-03
1642	Kit Básico para o Dia a Dia Chronos Derma (2 produtos)	\N	219716	Geral	Kit Básico para o Dia a Dia Chronos Derma (2 produtos)\nRef: 219716	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw707894b1/produto-joia/background/desktop/219716.jpg	5	0.00	0.00	2026-03-08 07:21:20.634908-03	2026-02-27 20:07:57.881475-03
1645	Kit Protetor Solar Corporal FPS 30 e Gel Hidratante Pós-sol Natura Solar	\N	231691	Corpo e Banho	Kit Protetor Solar Corporal FPS 30 e Gel Hidratante Pós-sol Natura Solar\nRef: 231691	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf0a3f367/produto-joia/background/desktop/231691.jpg	5	0.00	0.00	2026-03-08 07:21:59.928363-03	2026-02-27 20:07:57.886708-03
1647	Kit Química de Humor Feminino (2 unidades)	\N	232510	Geral	Kit Química de Humor Feminino (2 unidades)\nRef: 232510	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3115284b/produto-joia/background/desktop/232510.jpg	5	0.00	0.00	2026-03-08 07:22:23.881031-03	2026-02-27 20:07:57.890036-03
1650	Kit Protetor Solar Facial Stick e Protetor Solar Corporal FPS 50 Natura Solar	\N	231707	Geral	Kit Protetor Solar Facial Stick e Protetor Solar Corporal FPS 50 Natura Solar\nRef: 231707	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw24ab18df/produto-joia/background/desktop/231707.jpg	5	0.00	0.00	2026-03-08 07:23:12.535943-03	2026-02-27 20:07:57.895036-03
1653	Kit Química de Humor e Humor Próprio Feminino	\N	232525	Geral	Kit Química de Humor e Humor Próprio Feminino\nRef: 232525	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4ae3f751/produto-joia/background/desktop/232525.jpg	5	0.00	0.00	2026-03-08 07:23:59.339017-03	2026-02-27 20:07:57.897964-03
1656	Kit Hidratação Ekos Pitanga (2 produtos)	\N	225173	Geral	Kit Hidratação Ekos Pitanga (2 produtos)\nRef: 225173	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe4c47c99/produto-joia/background/desktop/225173.jpg	5	0.00	0.00	2026-03-08 07:24:39.458424-03	2026-02-27 20:07:57.906179-03
1659	Kit Lumina Definição para Cabelos Cacheados e Crespos (2 produtos)	\N	224953	Cabelos	Kit Lumina Definição para Cabelos Cacheados e Crespos (2 produtos)\nRef: 224953	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc447e11e/produto-joia/background/desktop/224953.jpg	5	0.00	0.00	2026-03-08 07:25:14.822988-03	2026-02-27 20:08:06.658594-03
1661	Kit Natura Homem Nós (2 unidades)	\N	232513	Homem	Kit Natura Homem Nós (2 unidades)\nRef: 232513	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4c9ed361/produto-joia/background/desktop/232513.jpg	5	0.00	0.00	2026-03-08 07:25:40.956734-03	2026-02-27 20:08:06.663187-03
1664	Kit Gel Creme Antissinais 30+ Noite com Refil	\N	228435	Corpo e Banho	Kit Gel Creme Antissinais 30+ Noite com Refil\nRef: 228435	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc4bcc064/produto-joia/background/desktop/228435.jpg	5	0.00	0.00	2026-03-08 07:26:26.532711-03	2026-02-27 20:08:06.670842-03
1666	Kit Deo Parfum Una Blush e Batom	\N	238705	Perfumaria	Kit Deo Parfum Una Blush e Batom\nRef: 238705	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw76efb77b/Produtos/NATBRA-238705_1.jpg	5	0.00	0.00	2026-03-08 07:26:48.008686-03	2026-02-27 20:08:06.671506-03
1668	Kit Deo Parfum Una Blush e Batom	\N	238704	Perfumaria	Kit Deo Parfum Una Blush e Batom\nRef: 238704	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5db9a7e0/Produtos/NATBRA-238704_1.jpg	5	0.00	0.00	2026-03-08 07:27:25.948934-03	2026-02-27 20:08:06.679246-03
1671	Kit Tododia Cachos Perfumados (3 produtos)	\N	228240	Geral	Kit Tododia Cachos Perfumados (3 produtos)\nRef: 228240	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw619bcd62/Produtos/NATBRA-228240_1.jpg	5	0.00	0.00	2026-03-08 07:28:14.797748-03	2026-02-27 20:08:06.679791-03
1673	Kit Máscara com Refil Lumina Definição e Nutrição para Cabelos Crespos	\N	239192	Cabelos	Kit Máscara com Refil Lumina Definição e Nutrição para Cabelos Crespos\nRef: 239192	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3ff9cbb1/produto-joia/background/desktop/239192.jpg	5	0.00	0.00	2026-03-08 07:28:56.066181-03	2026-02-27 20:08:06.688128-03
1676	Kit Base Sérum Una com Pincel	\N	239179	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239179	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7d91e77a/produto-joia/background/desktop/239179.jpg	5	0.00	0.00	2026-03-08 07:29:30.722868-03	2026-02-27 20:08:06.688128-03
1678	Kit Lumina Brilho e Proteção da Cor Shampoo e Máscara	\N	239180	Cabelos	Kit Lumina Brilho e Proteção da Cor Shampoo e Máscara\nRef: 239180	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0703314b/produto-joia/background/desktop/239180.jpg	5	0.00	0.00	2026-03-08 07:30:00.113835-03	2026-02-27 20:08:06.696353-03
1680	Kit Base Sérum Una com Pincel	\N	239187	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239187	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw28150073/produto-joia/background/desktop/239187.jpg	5	0.00	0.00	2026-03-08 07:30:28.123267-03	2026-02-27 20:08:06.696353-03
1733	Produto 239249	\N	239249	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.203964-03	2026-02-27 20:08:31.203964-03
1734	Produto 239240	\N	239240	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.203964-03	2026-02-27 20:08:31.203964-03
1735	Produto 256330	\N	256330	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.209838-03	2026-02-27 20:08:31.209838-03
1736	Produto 239222	\N	239222	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.209838-03	2026-02-27 20:08:31.209838-03
1737	Produto 239233	\N	239233	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.209838-03	2026-02-27 20:08:31.209838-03
1738	Produto 241076	\N	241076	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.209838-03	2026-02-27 20:08:31.209838-03
1739	Produto 239274	\N	239274	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.209838-03	2026-02-27 20:08:31.209838-03
1740	Produto 239978	\N	239978	Geral	Descoberto em Todos os Produtos (Pág 90)	\N	5	0.00	\N	2026-02-27 20:08:31.218331-03	2026-02-27 20:08:31.218663-03
1686	Kit Creme Nutritivo com Refil Tododia Jambo Rosa e Flor de Caju	\N	239197	Corpo e Banho	Kit Creme Nutritivo com Refil Tododia Jambo Rosa e Flor de Caju\nRef: 239197	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5499cde2/produto-joia/background/desktop/239197.jpg	5	0.00	0.00	2026-03-08 07:31:48.722126-03	2026-02-27 20:08:14.786341-03
1689	Kit Base Sérum Una com Pincel	\N	239207	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239207	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw13cae148/produto-joia/background/desktop/239207.jpg	5	0.00	0.00	2026-03-08 07:32:13.714222-03	2026-02-27 20:08:14.786341-03
1695	Kit Una Artisan e Gloss	\N	244754	Geral	Kit Una Artisan e Gloss\nRef: 244754	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0022de95/produto-joia/background/desktop/244754.jpg	5	0.00	0.00	2026-03-08 07:33:16.155733-03	2026-02-27 20:08:14.794781-03
1692	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte	\N	244728	Cabelos	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte\nRef: 244728	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfa2bf9b2/produto-joia/background/desktop/244728.jpg	5	0.00	0.00	2026-03-08 07:33:32.017402-03	2026-02-27 20:08:14.794781-03
1696	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss	\N	244727	Cabelos	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss\nRef: 244727	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwef90bce0/produto-joia/background/desktop/244727.jpg	5	0.00	0.00	2026-03-08 07:34:22.105828-03	2026-02-27 20:08:14.794781-03
1698	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte	\N	244735	Cabelos	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte\nRef: 244735	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9b0fb3eb/produto-joia/background/desktop/244735.jpg	5	0.00	0.00	2026-03-08 07:35:00.454081-03	2026-02-27 20:08:14.8035-03
1702	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte	\N	244788	Cabelos	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte\nRef: 244788	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5c64b008/produto-joia/background/desktop/244788.jpg	5	0.00	0.00	2026-03-08 07:35:38.315815-03	2026-02-27 20:08:14.811286-03
1708	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte	\N	244778	Cabelos	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte\nRef: 244778	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw575d73cd/produto-joia/background/desktop/244778.jpg	5	0.00	0.00	2026-03-08 07:36:37.057258-03	2026-02-27 20:08:22.81837-03
1706	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss	\N	244759	Cabelos	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss\nRef: 244759	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw071f678f/produto-joia/background/desktop/244759.jpg	5	0.00	0.00	2026-03-08 07:37:04.665041-03	2026-02-27 20:08:22.811287-03
1709	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss	\N	244763	Cabelos	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss\nRef: 244763	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0703f27c/produto-joia/background/desktop/244763.jpg	5	0.00	0.00	2026-03-08 07:38:07.363751-03	2026-02-27 20:08:22.819374-03
1713	Kit Base Sérum Una com Pincel	\N	239260	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239260	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw95b9edd5/produto-joia/background/desktop/239260.jpg	5	0.00	0.00	2026-03-08 07:38:45.739726-03	2026-02-27 20:08:22.827357-03
1714	Kit Base Sérum Una com Pincel	\N	239271	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239271	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2e6ef345/produto-joia/background/desktop/239271.jpg	5	0.00	0.00	2026-03-08 07:39:35.248054-03	2026-02-27 20:08:22.827357-03
1718	Kit Una Clássico e Gloss	\N	244746	Geral	Kit Una Clássico e Gloss\nRef: 244746	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw72645eff/produto-joia/background/desktop/244746.jpg	5	0.00	0.00	2026-03-08 07:40:32.569449-03	2026-02-27 20:08:22.835046-03
1719	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte	\N	244752	Cabelos	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte\nRef: 244752	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2a84b049/produto-joia/background/desktop/244752.jpg	5	0.00	0.00	2026-03-08 07:41:02.590924-03	2026-02-27 20:08:22.835813-03
1721	Kit Una Blush e Gloss	\N	244737	Geral	Kit Una Blush e Gloss\nRef: 244737	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3607d9c9/produto-joia/background/desktop/244737.jpg	5	0.00	0.00	2026-03-08 07:41:34.067705-03	2026-02-27 20:08:22.835813-03
1724	Kit Base Sérum Una com Pincel	\N	239247	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239247	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa8960728/produto-joia/background/desktop/239247.jpg	5	0.00	0.00	2026-03-08 07:42:14.888353-03	2026-02-27 20:08:22.844305-03
1727	Kit Base Sérum Una com Pincel	\N	239276	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239276	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw71dbd2e2/produto-joia/background/desktop/239276.jpg	5	0.00	0.00	2026-03-08 07:42:45.295414-03	2026-02-27 20:08:31.185415-03
1730	Kit Ekos Frescor Pitanga (2 unidades)	\N	240313	Geral	Kit Ekos Frescor Pitanga (2 unidades)\nRef: 240313	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw084fcf50/Produtos/NATBRA-240313_1.jpg	5	0.00	0.00	2026-03-08 07:43:36.805261-03	2026-02-27 20:08:31.194514-03
1732	Kit Base Sérum Una com Pincel	\N	239252	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239252	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5df77a64/produto-joia/background/desktop/239252.jpg	5	0.00	0.00	2026-03-08 07:44:12.261602-03	2026-02-27 20:08:31.203964-03
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
1055	Spray Pós-Barba Kaiak	\N	109482	Maquiagem	Spray Pós-Barba Kaiak\nRef: 109482	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4088ae7e/NATBRA-109482_1.jpg	5	0.00	0.00	2026-03-07 21:14:10.362894-03	2026-02-27 20:03:48.27737-03
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
700	Lápis para Olhos Faces 1,3g	\N	9921	Geral	Lápis para Olhos Faces 1,3g\nRef: 9921	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8ef0bbdb/Produtos/NATBRA-9921_1.jpg	5	39.90	39.90	2026-03-07 14:58:27.050141-03	2026-02-27 20:01:46.494841-03
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
324	Refil Condicionador Antissinais Regenerador Capilar Lumina	\N	174187	Cabelos	Refil Condicionador Antissinais Regenerador Capilar Lumina\nRef: 174187	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9a390003/produto-joia/background/desktop/174187.jpg	5	44.90	44.90	2026-03-07 12:47:16.023623-03	2026-02-27 19:58:49.1301-03
325	Kit Lenços Umedecidos com Fragrância Mamãe e Bebê (3 unidades)	\N	211662	Infantil	Kit Lenços Umedecidos com Fragrância Mamãe e Bebê (3 unidades)\nRef: 211662	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw67588f86/produto-joia/background/desktop/211662.jpg	5	0.00	0.00	2026-03-07 12:48:46.016468-03	2026-02-27 19:58:57.754121-03
326	Sabonete em Gel Limpeza Purificante Antioleosidade Chronos Derma	\N	69720	Corpo e Banho	Sabonete em Gel Limpeza Purificante Antioleosidade Chronos Derma\nRef: 69720	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw81d5372a/produto-joia/background/desktop/69720.jpg	5	0.00	0.00	2026-03-07 12:49:30.668303-03	2026-02-27 19:58:57.754121-03
329	Refil Creme Desodorante Hidratante para o Corpo Ekos Tukumã	\N	203397	Corpo e Banho	Refil Creme Desodorante Hidratante para o Corpo Ekos Tukumã\nRef: 203397	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc1797512/produto-joia/background/desktop/203397.jpg	5	69.90	69.90	2026-03-07 12:49:48.021435-03	2026-02-27 19:58:57.763423-03
330	Sabonete Puro Vegetal Cremoso Erva Doce	\N	26384	Corpo e Banho	Sabonete Puro Vegetal Cremoso Erva Doce\nRef: 26384	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5eaa3cd0/Produtos/NATBRA-26384_1.jpg	5	31.90	31.90	2026-03-07 12:50:09.384539-03	2026-02-27 19:58:57.763423-03
352	Super Sérum Redutor de Rugas Chronos Derma	\N	169264	Geral	Super Sérum Redutor de Rugas Chronos Derma\nRef: 169264	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4d458367/produto-joia/background/desktop/169264.jpg	5	239.00	239.00	2026-03-07 12:50:50.866838-03	2026-02-27 19:59:04.635655-03
354	Sabonete Líquido Cremoso para o Corpo Tododia Algodão	\N	113403	Corpo e Banho	Sabonete Líquido Cremoso para o Corpo Tododia Algodão\nRef: 113403	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw29071085/produto-joia/background/desktop/113403.jpg	5	0.00	0.00	2026-03-07 12:51:05.474987-03	2026-02-27 19:59:04.643658-03
353	Ekos Ryo Chuva 75 ml	\N	133863	Geral	Ekos Ryo Chuva 75 ml\nRef: 133863	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb9944844/produto-joia/background/desktop/133863.png	5	0.00	0.00	2026-03-07 12:51:36.400475-03	2026-02-27 19:59:04.635655-03
355	Kit Tododia Capim Limão e Hortelã com Sabonete, Hidratante e Body Splash (3 produtos)	\N	215269	Corpo e Banho	Kit Tododia Capim Limão e Hortelã com Sabonete, Hidratante e Body Splash (3 produtos)\nRef: 215269	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1ffefcb0/produto-joia/background/desktop/215269.jpg	5	0.00	0.00	2026-03-07 12:52:04.747806-03	2026-02-27 19:59:04.643658-03
357	Creme Antissinais 70+ Dia	\N	134697	Corpo e Banho	Creme Antissinais 70+ Dia\nRef: 134697	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2d61e586/produto-joia/background/desktop/134697.jpg	5	0.00	0.00	2026-03-07 12:52:19.726572-03	2026-02-27 19:59:04.648577-03
359	Creme Desodorante Nutritivo Tododia Limão Siciliano e Flor de Gardênia	\N	162097	Corpo e Banho	Creme Desodorante Nutritivo Tododia Limão Siciliano e Flor de Gardênia\nRef: 162097	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw280ab1ab/produto-joia/background/desktop/162097.jpg	5	78.90	78.90	2026-03-07 12:52:50.70083-03	2026-02-27 19:59:04.65199-03
360	Refil Sabonete em Espuma Limpeza Suave Chronos Derma	\N	137981	Corpo e Banho	Refil Sabonete em Espuma Limpeza Suave Chronos Derma\nRef: 137981	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8d5c43a9/produto-joia/background/desktop/137981.jpg	5	0.00	0.00	2026-03-07 12:53:05.901661-03	2026-02-27 19:59:04.655326-03
450	Refil Óleo Trifásico Desodorante Corporal Ekos Andiroba	\N	97433	Corpo e Banho	Refil Óleo Trifásico Desodorante Corporal Ekos Andiroba\nRef: 97433	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw971f9c8f/produto-joia/background/desktop/97433.jpg	5	79.90	79.90	2026-03-07 12:53:34.429084-03	2026-02-27 19:59:51.979487-03
452	Desodorante Hidratante Corporal Perfumado Luna Confiante	\N	102039	Corpo e Banho	Desodorante Hidratante Corporal Perfumado Luna Confiante\nRef: 102039	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw68cb5312/produto-joia/background/desktop/102039.jpg	5	0.00	0.00	2026-03-07 12:54:00.610727-03	2026-02-27 19:59:51.979487-03
454	Kit Tododia Energia Flor de Gengibre e Tangerina com Sabonete, Hidratante e Body Splash (3 produtos)	\N	215275	Corpo e Banho	Kit Tododia Energia Flor de Gengibre e Tangerina com Sabonete, Hidratante e Body Splash (3 produtos)\nRef: 215275	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw210b0685/produto-joia/background/desktop/215275.jpg	5	0.00	0.00	2026-03-07 12:54:16.331871-03	2026-02-27 19:59:51.986789-03
456	Condicionador Mamãe e Bebê Cachinhos e Crespinhos	\N	166871	Cabelos	Condicionador Mamãe e Bebê Cachinhos e Crespinhos\nRef: 166871	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1c5bf0d4/produto-joia/background/desktop/166871.jpg	5	0.00	0.00	2026-03-07 12:55:00.050136-03	2026-02-27 19:59:51.987801-03
473	Máscara Antiquebra para Antiqueda e Crescimento	\N	147417	Cabelos	Máscara Antiquebra para Antiqueda e Crescimento\nRef: 147417	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8b03d09d/produto-joia/background/desktop/147417.jpg	5	0.00	0.00	2026-03-07 12:55:21.47304-03	2026-02-27 19:59:59.577998-03
474	Refil Condicionador Cabelos Cacheados e Crespos Naturé	\N	102403	Cabelos	Refil Condicionador Cabelos Cacheados e Crespos Naturé\nRef: 102403	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9dfce5cf/produto-joia/background/desktop/102403.jpg	5	33.90	33.90	2026-03-07 12:55:36.141103-03	2026-02-27 19:59:59.577998-03
479	Gel de Banho Energizante para o Corpo Tododia Energia	\N	152297	Geral	Gel de Banho Energizante para o Corpo Tododia Energia\nRef: 152297	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfb2877f9/produto-joia/background/desktop/152297.jpg	5	0.00	0.00	2026-03-07 12:55:58.74701-03	2026-02-27 19:59:59.586347-03
477	Kit Reparador Tododia Flor de Cereja e Abacate	\N	194392	Geral	Kit Reparador Tododia Flor de Cereja e Abacate\nRef: 194392	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw876c8d02/NATBRA-194392_1.jpg	5	0.00	0.00	2026-03-07 12:56:27.200688-03	2026-02-27 19:59:59.586347-03
484	Desodorante Antitranspirante em Creme Tododia Manga Rosa e Água de Coco	\N	91217	Corpo e Banho	Desodorante Antitranspirante em Creme Tododia Manga Rosa e Água de Coco\nRef: 91217	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd072d137/produto-joia/background/desktop/91217.jpg	5	0.00	0.00	2026-03-07 12:57:04.201336-03	2026-02-27 19:59:59.594857-03
482	Refil Óleo Trifásico Desodorante Corporal Ekos Maracujá	\N	97431	Corpo e Banho	Refil Óleo Trifásico Desodorante Corporal Ekos Maracujá\nRef: 97431	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc962d859/produto-joia/background/desktop/97431.jpg	5	79.90	79.90	2026-03-07 12:57:14.218751-03	2026-02-27 19:59:59.594857-03
578	Condicionador Restaurador Naturé	\N	166873	Cabelos	Condicionador Restaurador Naturé\nRef: 166873	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw00c26ae1/produto-joia/background/desktop/166873.jpg	5	0.00	0.00	2026-03-07 12:58:28.820233-03	2026-02-27 20:01:05.227105-03
579	Refil Desodorante Hidratante Corporal Perfumado Luna Radiante	\N	97170	Corpo e Banho	Refil Desodorante Hidratante Corporal Perfumado Luna Radiante\nRef: 97170	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0e0367bd/produto-joia/background/desktop/97170.jpg	5	66.90	66.90	2026-03-07 12:58:52.344869-03	2026-02-27 20:01:05.234546-03
583	Blush Color Faces	\N	9456	Geral	Blush Color Faces\nRef: 9456	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd7158577/Produtos/NATBRA-9456_1.jpg	5	39.90	39.90	2026-03-07 12:59:06.470764-03	2026-02-27 20:01:05.24281-03
582	Refil Essencial Oud Masculino 100 ml	\N	11683	Homem	Refil Essencial Oud Masculino 100 ml\nRef: 11683	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9ce856ae/produto-joia/background/desktop/11683.jpg	5	0.00	0.00	2026-03-07 12:59:17.675052-03	2026-02-27 20:01:05.234546-03
580	Protetor Solar Corporal FPS 50 Natura Solar	\N	176914	Geral	Protetor Solar Corporal FPS 50 Natura Solar\nRef: 176914	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe92b6dfc/produto-joia/background/desktop/176914.jpg	5	139.90	139.90	2026-03-07 12:59:46.313411-03	2026-02-27 20:01:05.234546-03
600	Refil Difusor Natura 861 Guaiaco Pataqueira 200 ml sem vareta	\N	139270	Geral	Refil Difusor Natura 861 Guaiaco Pataqueira 200 ml sem vareta\nRef: 139270	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw624e2ead/NATBRA-139270_1.jpg	5	0.00	0.00	2026-03-07 13:00:08.897174-03	2026-02-27 20:01:12.893627-03
601	Refil Máscara Concentrada Cronocapilar Tododia Repara	\N	154864	Cabelos	Refil Máscara Concentrada Cronocapilar Tododia Repara\nRef: 154864	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd3a41fc4/produto-joia/background/desktop/154864.jpg	5	37.50	37.50	2026-03-07 13:00:18.499243-03	2026-02-27 20:01:12.896633-03
603	Refil Creme Desodorante Nutritivo para o Corpo Tododia Tâmara e Canela	\N	2791	Corpo e Banho	Refil Creme Desodorante Nutritivo para o Corpo Tododia Tâmara e Canela\nRef: 2791	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8a1b66b2/produto-joia/background/desktop/2791.jpg	5	0.00	0.00	2026-03-07 13:00:51.845544-03	2026-02-27 20:01:12.902012-03
604	Creme Desodorante Hidratante para o Corpo Ekos Castanha	\N	203379	Corpo e Banho	Creme Desodorante Hidratante para o Corpo Ekos Castanha\nRef: 203379	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe15360cf/produto-joia/background/desktop/203379.jpg	5	0.00	0.00	2026-03-07 13:01:06.58476-03	2026-02-27 20:01:12.904012-03
606	Desodorante Antitranspirante Roll-on Kaiak O2 Masculino	\N	177731	Corpo e Banho	Desodorante Antitranspirante Roll-on Kaiak O2 Masculino\nRef: 177731	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5a9891c2/produto-joia/background/desktop/177731.jpg	5	29.90	29.90	2026-03-07 13:01:33.779881-03	2026-02-27 20:01:12.909208-03
608	Calcinha Absorvente Instituto Natura + Pantys	\N	228004	Geral	Calcinha Absorvente Instituto Natura + Pantys\nRef: 228004	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw17c0491b/produto-joia/background/desktop/228004.jpg	5	57.00	57.00	2026-03-07 13:01:59.641149-03	2026-02-27 20:01:12.913208-03
609	Refil Gel Creme Antissinais 45+ Dia	\N	134585	Corpo e Banho	Refil Gel Creme Antissinais 45+ Dia\nRef: 134585	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd1913dcf/produto-joia/background/desktop/134585.jpg	5	124.00	124.00	2026-03-07 13:02:12.046737-03	2026-02-27 20:01:12.915219-03
611	Refil Essencial Oud Feminino 100 ml	\N	11682	Geral	Refil Essencial Oud Feminino 100 ml\nRef: 11682	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw95cd1b5c/produto-joia/background/desktop/11682.jpg	5	0.00	0.00	2026-03-07 13:02:35.195773-03	2026-02-27 20:01:12.920515-03
613	Calcinha Absorvente Instituto Natura + Pantys	\N	228006	Geral	Calcinha Absorvente Instituto Natura + Pantys\nRef: 228006	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw907a58d9/produto-joia/background/desktop/228006.jpg	5	57.00	57.00	2026-03-07 13:03:01.812099-03	2026-02-27 20:01:12.924829-03
615	Kit Desodorante Antitranspirante em Creme Tododia Sem Perfume (2 unidades)	\N	211659	Perfumaria	Kit Desodorante Antitranspirante em Creme Tododia Sem Perfume (2 unidades)\nRef: 211659	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc44eb0b9/produto-joia/background/desktop/211659.jpg	5	0.00	0.00	2026-03-07 13:03:26.547157-03	2026-02-27 20:01:12.927864-03
616	Perfume para Cabelos Luna Divina	\N	187605	Perfumaria	Perfume para Cabelos Luna Divina\nRef: 187605	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8942b4bc/produto-joia/background/desktop/187605.jpg	5	87.90	87.90	2026-03-07 13:03:36.918553-03	2026-02-27 20:01:12.929856-03
618	Refil Máscara Antiquebra para Antiqueda e Crescimento	\N	147407	Cabelos	Refil Máscara Antiquebra para Antiqueda e Crescimento\nRef: 147407	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw75341dc1/produto-joia/background/desktop/147407.jpg	5	0.00	0.00	2026-03-07 13:04:06.557688-03	2026-02-27 20:01:12.935272-03
619	Sabonete em Barra Cremoso Ekos Maracujá Natureza dos Sonhos	\N	220145	Corpo e Banho	Sabonete em Barra Cremoso Ekos Maracujá Natureza dos Sonhos\nRef: 220145	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9af513ac/produto-joia/background/desktop/220145.jpg	5	0.00	0.00	2026-03-07 13:04:18.74984-03	2026-02-27 20:01:12.937272-03
623	Desodorante Corporal Ilía Ser 100 ml	\N	140411	Corpo e Banho	Desodorante Corporal Ilía Ser 100 ml\nRef: 140411	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbdbb3a23/produto-joia/background/desktop/140411.jpg	5	72.90	72.90	2026-03-07 13:04:41.925157-03	2026-02-27 20:01:21.689853-03
622	Kit Desodorante Roll-on e Sabonete Corpo e Barba Natura Homem (2 produtos)	\N	219721	Corpo e Banho	Kit Desodorante Roll-on e Sabonete Corpo e Barba Natura Homem (2 produtos)\nRef: 219721	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc3b3f216/produto-joia/background/desktop/219721.jpg	5	0.00	0.00	2026-03-07 13:04:54.290032-03	2026-02-27 20:01:21.682545-03
626	Kit Shampoo, Condicionador e Máscara Lumina Força e Reparação Molecular (3 produtos)	\N	208138	Cabelos	Kit Shampoo, Condicionador e Máscara Lumina Força e Reparação Molecular (3 produtos)\nRef: 208138	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw254f9c4b/produto-joia/background/desktop/208138.jpg	5	0.00	0.00	2026-03-07 13:05:21.747504-03	2026-02-27 20:01:21.690859-03
625	Luna Ousadia 75 ml	\N	128615	Geral	Luna Ousadia 75 ml\nRef: 128615	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd882b422/produto-joia/background/desktop/128615.jpg	5	0.00	0.00	2026-03-07 13:05:46.808784-03	2026-02-27 20:01:21.690859-03
627	Kit Desodorante Antitranspirante Roll-on Amora Vermelha e Jabuticaba (3 unidades)	\N	213547	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Amora Vermelha e Jabuticaba (3 unidades)\nRef: 213547	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7b87e287/produto-joia/background/desktop/213547.jpg	5	0.00	0.00	2026-03-07 13:05:59.32719-03	2026-02-27 20:01:21.698161-03
628	Refil Creme Antissinais 80+ Noite	\N	134594	Corpo e Banho	Refil Creme Antissinais 80+ Noite\nRef: 134594	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw53d4cabd/produto-joia/background/desktop/134594.jpg	5	124.00	124.00	2026-03-07 13:06:27.623111-03	2026-02-27 20:01:21.699175-03
630	Corretivo Cobertura Extrema 24h Una 8ml	\N	122112	Maquiagem	Corretivo Cobertura Extrema 24h Una 8ml\nRef: 122112	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe04ee797/produto-joia/background/desktop/PAI122122.jpg	5	0.00	0.00	2026-03-07 13:07:02.904877-03	2026-02-27 20:01:21.699175-03
633	Lápis Labial Retrátil PRO Una	\N	204430	Geral	Lápis Labial Retrátil PRO Una\nRef: 204430	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6e86d9f4/produto-joia/background/desktop/204430.jpg	5	0.00	0.00	2026-03-07 13:07:15.036532-03	2026-02-27 20:01:21.707478-03
640	Balm Labial Tododia Acerola e Hibisco	\N	180470	Geral	Balm Labial Tododia Acerola e Hibisco\nRef: 180470	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf8e132d9/produto-joia/background/desktop/180470.jpg	5	35.90	35.90	2026-03-07 13:49:17.51744-03	2026-02-27 20:01:21.724218-03
642	Kit Sabonete Líquido Esfoliante para o Corpo Ekos Tukumã com Refil	\N	219073	Corpo e Banho	Kit Sabonete Líquido Esfoliante para o Corpo Ekos Tukumã com Refil\nRef: 219073	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb2148478/Produtos/NATBRA-219073_1.jpg	5	0.00	0.00	2026-03-07 13:49:34.197294-03	2026-02-27 20:01:30.456841-03
644	Presente Natura Tododia Algodão (2 produtos)	\N	210422	Geral	Presente Natura Tododia Algodão (2 produtos)\nRef: 210422	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw08346d40/Produtos/NATBRA-210422_1.jpg	5	0.00	0.00	2026-03-07 13:49:54.924353-03	2026-02-27 20:01:30.456841-03
645	Creme Energizante Corporal 2 em 1 Tododia Energia	\N	152298	Corpo e Banho	Creme Energizante Corporal 2 em 1 Tododia Energia\nRef: 152298	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0b2ea04d/produto-joia/background/desktop/152298.jpg	5	0.00	0.00	2026-03-07 13:50:25.97733-03	2026-02-27 20:01:30.465089-03
646	Óleo Desodorante Corporal Sève Rosas e Amêndoas	\N	28724	Corpo e Banho	Óleo Desodorante Corporal Sève Rosas e Amêndoas\nRef: 28724	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw88034756/NATBRA-28724_1.jpg	5	116.90	116.90	2026-03-07 13:50:42.392091-03	2026-02-27 20:01:30.465089-03
648	Desodorante Corporal Luna	\N	69200	Corpo e Banho	Desodorante Corporal Luna\nRef: 69200	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw328cf8ff/produto-joia/background/desktop/69200.jpg	5	56.90	56.90	2026-03-07 13:51:12.255058-03	2026-02-27 20:01:30.465089-03
651	Refil Creme de Pentear Ativador para Definição e Nutrição de Cabelos Crespos	\N	148432	Cabelos	Refil Creme de Pentear Ativador para Definição e Nutrição de Cabelos Crespos\nRef: 148432	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa29fdddf/produto-joia/background/desktop/148432.jpg	5	44.90	44.90	2026-03-07 13:51:34.834922-03	2026-02-27 20:01:30.473516-03
650	Leave-in Densificador Antissinais Regenerador Capilar Lumina	\N	176398	Geral	Leave-in Densificador Antissinais Regenerador Capilar Lumina\nRef: 176398	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw736ff57c/produto-joia/background/desktop/176398.jpg	5	94.90	94.90	2026-03-07 13:51:50.238211-03	2026-02-27 20:01:30.473516-03
655	Kit Desodorante Antitranspirante Roll-on Luna (3 unidades)	\N	221678	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Luna (3 unidades)\nRef: 221678	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe8da00f2/produto-joia/background/desktop/221678.jpg	5	0.00	0.00	2026-03-07 13:52:09.420084-03	2026-02-27 20:01:30.481235-03
701	Refil Pó Compacto Matte Faces 6,5g	\N	9045	Maquiagem	Refil Pó Compacto Matte Faces 6,5g\nRef: 9045	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd8eed0f2/Produtos/NATBRA-9045_1.jpg	5	49.90	49.90	2026-03-07 14:58:39.561709-03	2026-02-27 20:01:46.496859-03
654	Sabonete Líquido em Gel Tododia Alecrim e Sálvia	\N	110281	Corpo e Banho	Sabonete Líquido em Gel Tododia Alecrim e Sálvia\nRef: 110281	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7f00f7c2/NATBRA-110281_1.jpg	5	59.90	59.90	2026-03-07 13:52:20.009081-03	2026-02-27 20:01:30.481235-03
656	Kit Creme Hidratante para as Mãos Ekos Açaí (2 unidades)	\N	252074	Corpo e Banho	Kit Creme Hidratante para as Mãos Ekos Açaí (2 unidades)\nRef: 252074	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe2030118/Produtos/NATBRA-252074_1.jpg	5	0.00	0.00	2026-03-07 13:52:52.258794-03	2026-02-27 20:01:30.489138-03
659	Shampoo Anticaspa Natura Homem	\N	160210	Cabelos	Shampoo Anticaspa Natura Homem\nRef: 160210	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw36311d44/produto-joia/background/desktop/160210.jpg	5	57.90	57.90	2026-03-07 13:53:30.49111-03	2026-02-27 20:01:30.489701-03
670	Kit Desodorante Antitranspirante em Creme Tododia Noz Pecã e Cacau (2 unidades)	\N	219734	Corpo e Banho	Kit Desodorante Antitranspirante em Creme Tododia Noz Pecã e Cacau (2 unidades)\nRef: 219734	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb71087c2/produto-joia/background/desktop/219734.jpg	5	0.00	0.00	2026-03-07 14:51:23.073464-03	2026-02-27 20:01:38.780747-03
672	Humor On-line Feminino 75 ml	\N	100148	Geral	Humor On-line Feminino 75 ml\nRef: 100148	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4d03282a/produto-joia/background/desktop/100148.jpg	5	164.90	164.90	2026-03-07 14:51:48.86681-03	2026-02-27 20:01:38.780747-03
674	Condicionador Sol, Mar e Piscina Tododia Manga Rosa e Água de Coco	\N	190391	Cabelos	Condicionador Sol, Mar e Piscina Tododia Manga Rosa e Água de Coco\nRef: 190391	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc67454a2/produto-joia/background/desktop/190391.jpg	5	37.90	37.90	2026-03-07 14:52:15.689039-03	2026-02-27 20:01:38.788466-03
677	Batom Lip Tint Faces	\N	118445	Maquiagem	Batom Lip Tint Faces\nRef: 118445	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw281a411b/Produtos/NATBRA-118445_1.jpg	5	0.00	0.00	2026-03-07 14:52:28.252618-03	2026-02-27 20:01:38.795693-03
675	Super Sérum para Olhos Redutor de Rugas e Flacidez Chronos Derma	\N	169258	Geral	Super Sérum para Olhos Redutor de Rugas e Flacidez Chronos Derma\nRef: 169258	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw62c38743/produto-joia/background/desktop/169258.jpg	5	195.00	195.00	2026-03-07 14:53:01.145999-03	2026-02-27 20:01:38.788466-03
681	Spray Protetor UV para Reparação e Blindagem	\N	148425	Geral	Spray Protetor UV para Reparação e Blindagem\nRef: 148425	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb0ccacdc/produto-joia/background/desktop/148425.jpg	5	0.00	0.00	2026-03-07 14:53:16.489216-03	2026-02-27 20:01:38.796706-03
680	Batom Multimix Cremoso Faces	\N	116186	Maquiagem	Batom Multimix Cremoso Faces\nRef: 116186	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw000194ec/produto-joia/background/desktop/PAI116187.jpg	5	23.90	23.90	2026-03-07 14:53:40.13926-03	2026-02-27 20:01:38.796706-03
679	Kit Essencial Masculino, Sabonete em Barra e Creme de Barbear (3 produtos)	\N	217166	Corpo e Banho	Kit Essencial Masculino, Sabonete em Barra e Creme de Barbear (3 produtos)\nRef: 217166	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw028cdf91/produto-joia/background/desktop/217166.jpg	5	0.00	0.00	2026-03-07 14:53:56.501465-03	2026-02-27 20:01:38.796706-03
685	Beijo de Humor Masculino 75 ml	\N	95949	Homem	Beijo de Humor Masculino 75 ml\nRef: 95949	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw32232b75/produto-joia/background/desktop/95949.jpg	5	0.00	0.00	2026-03-07 14:54:26.700214-03	2026-02-27 20:01:38.805109-03
683	Caneta Delineadora de Sobrancelhas Una	\N	17042	Maquiagem	Caneta Delineadora de Sobrancelhas Una\nRef: 17042	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw517eccac/Produtos/NATBRA-17042_1.jpg	5	0.00	0.00	2026-03-07 14:54:53.103728-03	2026-02-27 20:01:38.805109-03
686	Una Instinct 75 ml	\N	107021	Geral	Una Instinct 75 ml\nRef: 107021	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdbd53562/produto-joia/background/desktop/107021.jpg	5	0.00	0.00	2026-03-07 14:55:10.203111-03	2026-02-27 20:01:38.812467-03
689	Kit Desodorante Corporal Natura Homem com Refil	\N	228452	Corpo e Banho	Kit Desodorante Corporal Natura Homem com Refil\nRef: 228452	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4f074f40/produto-joia/background/desktop/228452.jpg	5	0.00	0.00	2026-03-07 14:55:42.264256-03	2026-02-27 20:01:38.813542-03
690	Kit Refis Shampoo e Condicionador Lumina Reconstrução de Danos Extremos (2 produtos)	\N	208773	Cabelos	Kit Refis Shampoo e Condicionador Lumina Reconstrução de Danos Extremos (2 produtos)\nRef: 208773	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf09e1c88/produto-joia/background/desktop/208773.jpg	5	0.00	0.00	2026-03-07 14:56:08.626268-03	2026-02-27 20:01:46.473883-03
691	Kit Hidratante Mamãe e Bebê com Refil (2 produtos)	\N	211660	Corpo e Banho	Kit Hidratante Mamãe e Bebê com Refil (2 produtos)\nRef: 211660	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8026e5c8/produto-joia/background/desktop/211660.jpg	5	0.00	0.00	2026-03-07 14:56:20.094873-03	2026-02-27 20:01:46.476968-03
693	Shower Gel 4 em 1 Natura Homem	\N	160264	Homem	Shower Gel 4 em 1 Natura Homem\nRef: 160264	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw361b919e/produto-joia/background/desktop/160264.jpg	5	0.00	0.00	2026-03-07 14:56:45.988383-03	2026-02-27 20:01:46.481467-03
695	Kit Reparador Tododia Flor de Cereja e Abacate e Sabonete Alecrim e Sálvia (3 produtos)	\N	236561	Corpo e Banho	Kit Reparador Tododia Flor de Cereja e Abacate e Sabonete Alecrim e Sálvia (3 produtos)\nRef: 236561	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8e066ca1/Produtos/NATBRA-236561_1.jpg	5	0.00	0.00	2026-03-07 14:57:15.052574-03	2026-02-27 20:01:46.48547-03
696	Kit Una Rotina de Maquiagem com Primer Blur e Bruma Hidratante Fixadora (2 produtos)	\N	235592	Corpo e Banho	Kit Una Rotina de Maquiagem com Primer Blur e Bruma Hidratante Fixadora (2 produtos)\nRef: 235592	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8c1a25ae/Produtos/NATBRA-235592_1.jpg	5	0.00	0.00	2026-03-07 14:57:27.243303-03	2026-02-27 20:01:46.487539-03
697	Kit Shampoo 2 em 1 e Sabonete Corpo e Barba Natura Homem (2 produtos)	\N	219742	Cabelos	Kit Shampoo 2 em 1 e Sabonete Corpo e Barba Natura Homem (2 produtos)\nRef: 219742	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw60cfa881/produto-joia/background/desktop/219742.jpg	5	0.00	0.00	2026-03-07 14:57:42.975115-03	2026-02-27 20:01:46.489537-03
698	Batom Matte Faces 3,5g	\N	93028	Maquiagem	Batom Matte Faces 3,5g\nRef: 93028	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw038bc66f/produto-joia/background/desktop/PAI77992.jpg	5	23.90	23.90	2026-03-07 14:57:56.484544-03	2026-02-27 20:01:46.49154-03
703	Sacola Estampada Crer Para Ver	\N	195646	Geral	Sacola Estampada Crer Para Ver\nRef: 195646	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw21f81d98/produto-joia/background/desktop/195646.jpg	5	7.90	7.90	2026-03-07 14:59:05.50416-03	2026-02-27 20:01:46.50085-03
706	Desodorante Hidratante Corporal Perfumado Luna Intenso	\N	97173	Corpo e Banho	Desodorante Hidratante Corporal Perfumado Luna Intenso\nRef: 97173	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwde6884ad/produto-joia/background/desktop/97173.jpg	5	134.90	134.90	2026-03-07 14:59:55.916638-03	2026-02-27 20:01:46.50612-03
707	Creme Hidratante para Mãos Essencial Exclusivo Feminino	\N	125298	Corpo e Banho	Creme Hidratante para Mãos Essencial Exclusivo Feminino\nRef: 125298	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1875bbec/produto-joia/background/desktop/125298.jpg	5	0.00	0.00	2026-03-07 15:00:16.489014-03	2026-02-27 20:01:46.508134-03
709	Batom Color Hidra FPS 8 Faces 3,5g	\N	6421	Maquiagem	Batom Color Hidra FPS 8 Faces 3,5g\nRef: 6421	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8df753d0/Produtos/NATBRA-6421_1.jpg	5	35.90	35.90	2026-03-07 15:00:43.446524-03	2026-02-27 20:01:46.511444-03
710	Body Splash Desodorante Colônia Tododia Acerola e Hibisco Miniatura 60 ml	\N	163721	Perfumaria	Body Splash Desodorante Colônia Tododia Acerola e Hibisco Miniatura 60 ml\nRef: 163721	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwadd2fbde/produto-joia/background/desktop/163721.jpg	5	29.90	29.90	2026-03-07 15:00:56.661574-03	2026-02-27 20:01:46.513474-03
712	Kit Lumina Antissinais Regenerador Capilar Shampoo e Condicionador (2 produtos)	\N	235591	Cabelos	Kit Lumina Antissinais Regenerador Capilar Shampoo e Condicionador (2 produtos)\nRef: 235591	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/pt_BR/v1772828548038/produto-joia/background/desktop/235591.jpg	5	0.00	0.00	2026-03-07 15:01:26.153322-03	2026-02-27 20:01:46.51748-03
721	Kit Multiprotetor Facial Antissinais FPS 50 Chronos Derma	\N	239254	Geral	Kit Multiprotetor Facial Antissinais FPS 50 Chronos Derma\nRef: 239254	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw367983c8/produto-joia/background/desktop/239254.jpg	5	0.00	0.00	2026-03-07 15:03:49.760306-03	2026-02-27 20:01:54.86094-03
723	Sabonete em Barra Naturés na Natureza (1 caixa)	\N	166022	Corpo e Banho	Sabonete em Barra Naturés na Natureza (1 caixa)\nRef: 166022	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe7c1dbde/produto-joia/background/desktop/166022.jpg	5	49.90	49.90	2026-03-07 15:04:12.46834-03	2026-02-27 20:01:54.869336-03
725	Kit Naturé Refis Cabelos Lisos e Ondulados (2 produtos)	\N	184469	Cabelos	Kit Naturé Refis Cabelos Lisos e Ondulados (2 produtos)\nRef: 184469	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1c4568a5/produto-joia/background/desktop/184469.jpg	5	0.00	0.00	2026-03-07 15:04:42.592529-03	2026-02-27 20:01:54.869336-03
726	Lápis Para Lábios Color & Contour Faces	\N	9619	Geral	Lápis Para Lábios Color & Contour Faces\nRef: 9619	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7c5efaee/Produtos/NATBRA-9619_1.jpg	5	39.90	39.90	2026-03-07 15:05:07.481533-03	2026-02-27 20:01:54.869336-03
728	Shampoo Revitalizante Brilho e Proteção da Cor	\N	148176	Cabelos	Shampoo Revitalizante Brilho e Proteção da Cor\nRef: 148176	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw79d3c62d/produto-joia/background/desktop/148176.jpg	5	0.00	0.00	2026-03-07 15:05:34.352341-03	2026-02-27 20:01:54.877606-03
729	Kit Desodorante Antitranspirante Roll-on Kaiak Urbe Masculino (3 unidades)	\N	221676	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Kaiak Urbe Masculino (3 unidades)\nRef: 221676	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8a347dcb/produto-joia/background/desktop/221676.jpg	5	0.00	0.00	2026-03-07 15:05:43.254176-03	2026-02-27 20:01:54.877606-03
731	Kit Crespos Tododia Amora e Óleo de Coco (4 produtos)	\N	209111	Corpo e Banho	Kit Crespos Tododia Amora e Óleo de Coco (4 produtos)\nRef: 209111	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4070555a/produto-joia/background/desktop/209111.jpg	5	0.00	0.00	2026-03-07 15:06:08.400575-03	2026-02-27 20:01:54.877606-03
733	Refil Condicionador Força e Reparação Molecular	\N	164512	Cabelos	Refil Condicionador Força e Reparação Molecular\nRef: 164512	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd0d3f787/produto-joia/background/desktop/164512.jpg	5	41.90	41.90	2026-03-07 15:06:36.471005-03	2026-02-27 20:01:54.886049-03
734	Kit Desodorante Antitranspirante em Creme Erva Doce (3 unidades)	\N	213232	Corpo e Banho	Kit Desodorante Antitranspirante em Creme Erva Doce (3 unidades)\nRef: 213232	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6f177470/produto-joia/background/desktop/213232.jpg	5	0.00	0.00	2026-03-07 15:06:48.869524-03	2026-02-27 20:01:54.886049-03
737	Sabonete em Barra Cremoso Puro Vegetal Biografia Masculino	\N	151559	Corpo e Banho	Sabonete em Barra Cremoso Puro Vegetal Biografia Masculino\nRef: 151559	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw81beb19e/produto-joia/background/desktop/151559.jpg	5	0.00	0.00	2026-03-07 15:07:35.253444-03	2026-02-27 20:02:02.251826-03
739	Óleo Trifásico Desodorante Corporal Ekos Castanha	\N	174338	Corpo e Banho	Óleo Trifásico Desodorante Corporal Ekos Castanha\nRef: 174338	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9a5afc41/produto-joia/background/desktop/174338.jpg	5	99.90	99.90	2026-03-07 15:08:10.232367-03	2026-02-27 20:02:02.251826-03
740	Refil Creme para Pentear Reparador Tododia Flor de Cereja e Abacate	\N	156234	Corpo e Banho	Refil Creme para Pentear Reparador Tododia Flor de Cereja e Abacate\nRef: 156234	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcbfe8af9/produto-joia/background/desktop/156234.jpg	5	27.90	27.90	2026-03-07 15:08:20.812698-03	2026-02-27 20:02:02.259209-03
742	Sabonete Líquido para o Corpo Essencial Feminino	\N	194789	Corpo e Banho	Sabonete Líquido para o Corpo Essencial Feminino\nRef: 194789	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw56456a04/Produtos/NATBRA-194789_1.jpg	5	36.90	36.90	2026-03-07 15:08:46.807607-03	2026-02-27 20:02:02.259582-03
743	Refil Shampoo Revitalizante para Brilho e Proteção da Cor	\N	148175	Cabelos	Refil Shampoo Revitalizante para Brilho e Proteção da Cor\nRef: 148175	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4f33da33/produto-joia/background/desktop/148175.jpg	5	0.00	0.00	2026-03-07 15:08:58.877853-03	2026-02-27 20:02:02.259582-03
746	Caneta Delineadora para Olhos Una	\N	34262	Maquiagem	Caneta Delineadora para Olhos Una\nRef: 34262	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4350042b/produto-joia/background/desktop/34262.jpg	5	0.00	0.00	2026-03-07 15:09:44.018423-03	2026-02-27 20:02:02.267918-03
749	Calcinha Absorvente Instituto Natura + Pantys	\N	228007	Geral	Calcinha Absorvente Instituto Natura + Pantys\nRef: 228007	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw355b73c5/produto-joia/background/desktop/228007.jpg	5	57.00	57.00	2026-03-07 15:10:31.813862-03	2026-02-27 20:02:02.275585-03
758	Sabonete Líquido Esfoliante para o Corpo Ekos Tukumã 185 ml	\N	98767	Corpo e Banho	Sabonete Líquido Esfoliante para o Corpo Ekos Tukumã 185 ml\nRef: 98767	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc3c6343a/produto-joia/background/desktop/98767.jpg	5	55.90	55.90	2026-03-07 15:52:33.876165-03	2026-02-27 20:02:02.284581-03
759	Kit Shampoo e Condicionador Reconstrução de Danos Extremos	\N	167105	Cabelos	Kit Shampoo e Condicionador Reconstrução de Danos Extremos\nRef: 167105	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6226f9a8/produto-joia/background/desktop/167105.jpg	5	0.00	0.00	2026-03-07 15:52:44.226375-03	2026-02-27 20:02:02.29295-03
761	Kit Tododia Algodão com Hidratante e Body Splash (2 produtos)	\N	215256	Corpo e Banho	Kit Tododia Algodão com Hidratante e Body Splash (2 produtos)\nRef: 215256	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb0ea3ed1/produto-joia/background/desktop/215256.jpg	5	0.00	0.00	2026-03-07 15:53:12.857153-03	2026-02-27 20:02:09.499754-03
762	Biografia Encontros Masculino 100 ml	\N	110411	Homem	Biografia Encontros Masculino 100 ml\nRef: 110411	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2d6b8273/produto-joia/background/desktop/110411.jpg	5	209.90	209.90	2026-03-07 15:53:26.744351-03	2026-02-27 20:02:09.501851-03
764	Caneta Delineadora de Sobrancelhas Una	\N	17043	Maquiagem	Caneta Delineadora de Sobrancelhas Una\nRef: 17043	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw55927abe/Produtos/NATBRA-17043_1.jpg	5	0.00	0.00	2026-03-07 15:53:58.140265-03	2026-02-27 20:02:09.505854-03
765	Creme de Barbear Espumante Sr. N	\N	85400	Corpo e Banho	Creme de Barbear Espumante Sr. N\nRef: 85400	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe0b7153c/produto-joia/background/desktop/85400.jpg	5	51.90	51.90	2026-03-07 15:54:13.149696-03	2026-02-27 20:02:09.507739-03
766	Kit Óleo Desodorante Hidratante Corporal Sève Amêndoas e Orquídea Negra (2 unidades)	\N	228446	Corpo e Banho	Kit Óleo Desodorante Hidratante Corporal Sève Amêndoas e Orquídea Negra (2 unidades)\nRef: 228446	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd66afb9e/produto-joia/background/desktop/228446.jpg	5	0.00	0.00	2026-03-07 15:54:27.879652-03	2026-02-27 20:02:09.509089-03
768	Refil Base Líquida HD Una	\N	173593	Maquiagem	Refil Base Líquida HD Una\nRef: 173593	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7242ba9e/produto-joia/background/desktop/173593.jpg	5	109.90	109.90	2026-03-07 15:55:03.389795-03	2026-02-27 20:02:09.513091-03
770	Kit Faces Batons Queridinhos (3 produtos)	\N	218184	Geral	Kit Faces Batons Queridinhos (3 produtos)\nRef: 218184	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw48136469/produto-joia/background/desktop/218184.jpg	5	0.00	0.00	2026-03-07 15:55:28.703543-03	2026-02-27 20:02:09.51604-03
772	Refil Fluido Bifásico Demaquilante Intensivo Chronos Derma	\N	135058	Geral	Refil Fluido Bifásico Demaquilante Intensivo Chronos Derma\nRef: 135058	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0e205f8d/produto-joia/background/desktop/135058.jpg	5	0.00	0.00	2026-03-07 15:56:02.553214-03	2026-02-27 20:02:09.51938-03
773	Caixa Especial de Presente G	\N	154850	Geral	Caixa Especial de Presente G\nRef: 154850	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw44f8850a/produto-joia/background/desktop/154850.jpg	5	8.90	8.90	2026-03-07 15:56:18.798425-03	2026-02-27 20:02:09.521379-03
775	Kit Sabonetes em Barra e Óleo Bifásico Desodorante Hidratante Corporal Tododia Macadâmia	\N	220209	Corpo e Banho	Kit Sabonetes em Barra e Óleo Bifásico Desodorante Hidratante Corporal Tododia Macadâmia\nRef: 220209	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb89f359f/produto-joia/background/desktop/220209.jpg	5	0.00	0.00	2026-03-07 15:56:41.935607-03	2026-02-27 20:02:09.525692-03
787	Sabonetes em Barra Puro Vegetal Tododia Algodão (2 unidades)	\N	122461	Corpo e Banho	Sabonetes em Barra Puro Vegetal Tododia Algodão (2 unidades)\nRef: 122461	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw21f3b86d/produto-joia/background/desktop/122461.jpg	5	20.90	20.90	2026-03-07 16:56:54.623309-03	2026-02-27 20:02:16.782702-03
789	Kit Dupla Antissinais 45+ Chronos Derma (2 produtos)	\N	219704	Geral	Kit Dupla Antissinais 45+ Chronos Derma (2 produtos)\nRef: 219704	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdf472d19/produto-joia/background/desktop/219704.jpg	5	0.00	0.00	2026-03-07 16:57:20.612736-03	2026-02-27 20:02:16.782702-03
790	Kit Desodorante Antitranspirante Roll-on Natura Homem Sagaz (3 unidades)	\N	219739	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Natura Homem Sagaz (3 unidades)\nRef: 219739	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw904dc3ac/produto-joia/background/desktop/219739.jpg	5	0.00	0.00	2026-03-07 16:57:31.739756-03	2026-02-27 20:02:16.782702-03
793	Creme Desodorante Nutritivo para o Corpo Tododia Amora Vermelha e Jabuticaba	\N	88103	Corpo e Banho	Creme Desodorante Nutritivo para o Corpo Tododia Amora Vermelha e Jabuticaba\nRef: 88103	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6456e73d/produto-joia/background/desktop/88103.jpg	5	78.90	78.90	2026-03-07 16:58:12.084327-03	2026-02-27 20:02:16.790724-03
794	Embalagem de Presente P Parabéns	\N	174326	Geral	Embalagem de Presente P Parabéns\nRef: 174326	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw69d02d57/produto-joia/background/desktop/174326.jpg	5	5.00	5.00	2026-03-07 16:58:25.883066-03	2026-02-27 20:02:16.790724-03
796	Lápis Labial Retrátil PRO Una	\N	204434	Geral	Lápis Labial Retrátil PRO Una\nRef: 204434	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb741e40f/produto-joia/background/desktop/204434.jpg	5	0.00	0.00	2026-03-07 16:58:52.30284-03	2026-02-27 20:02:16.798315-03
797	Kit Nutritivo Tododia Pêssego e Amêndoa e Sabonete Macadâmia (3 produtos)	\N	236589	Corpo e Banho	Kit Nutritivo Tododia Pêssego e Amêndoa e Sabonete Macadâmia (3 produtos)\nRef: 236589	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw01b63c36/Produtos/NATBRA-236589_1.jpg	5	0.00	0.00	2026-03-07 16:59:14.936001-03	2026-02-27 20:02:16.799127-03
799	Espuma de Barbear Natura Homem	\N	159952	Homem	Espuma de Barbear Natura Homem\nRef: 159952	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw27f7a2a1/produto-joia/background/desktop/159952.jpg	5	70.90	70.90	2026-03-07 16:59:40.395074-03	2026-02-27 20:02:16.799127-03
801	Sabonete em Óleo Corporal Ekos Castanha	\N	169166	Corpo e Banho	Sabonete em Óleo Corporal Ekos Castanha\nRef: 169166	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw27dfbb37/produto-joia/background/desktop/169166.jpg	5	0.00	0.00	2026-03-07 17:00:03.661781-03	2026-02-27 20:02:16.807381-03
803	Batom Multimix Cremoso Faces	\N	116199	Maquiagem	Batom Multimix Cremoso Faces\nRef: 116199	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw000194ec/produto-joia/background/desktop/PAI116187.jpg	5	23.90	23.90	2026-03-07 17:00:26.985232-03	2026-02-27 20:02:16.807381-03
804	Luna Perfume para Cabelos	\N	150216	Perfumaria	Luna Perfume para Cabelos\nRef: 150216	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw304f5aed/produto-joia/background/desktop/150216.jpg	5	79.90	79.90	2026-03-07 17:00:39.046351-03	2026-02-27 20:02:16.807381-03
806	Sabonete Líquido em Gel Tododia Alecrim e Sálvia	\N	86013	Corpo e Banho	Sabonete Líquido em Gel Tododia Alecrim e Sálvia\nRef: 86013	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1e877b92/produto-joia/background/desktop/86013.jpg	5	50.90	50.90	2026-03-07 17:01:02.319602-03	2026-02-27 20:02:16.815778-03
808	Kit Tododia Energia Flor de gengibre e Tangerina com Body Splash (2 produtos)	\N	186458	Geral	Kit Tododia Energia Flor de gengibre e Tangerina com Body Splash (2 produtos)\nRef: 186458	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw52f2dbed/produto-joia/background/desktop/186458.jpg	5	0.00	0.00	2026-03-07 17:01:25.195599-03	2026-02-27 20:02:16.818611-03
809	Gel de Sobrancelhas Incolor Faces	\N	167192	Geral	Gel de Sobrancelhas Incolor Faces\nRef: 167192	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw92a04302/produto-joia/background/desktop/167192.jpg	5	39.90	39.90	2026-03-07 17:01:37.629499-03	2026-02-27 20:02:24.548107-03
812	Refil Sabonete Líquido Esfoliante Corporal Ekos Tukumã	\N	19949	Corpo e Banho	Refil Sabonete Líquido Esfoliante Corporal Ekos Tukumã\nRef: 19949	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa33015e5/NATBRA-19949_1.jpg	5	40.60	40.60	2026-03-07 17:02:12.880436-03	2026-02-27 20:02:24.555358-03
811	Kit Super Sérum Redutor de Rugas Chronos Derma com Refil	\N	212742	Geral	Kit Super Sérum Redutor de Rugas Chronos Derma com Refil\nRef: 212742	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbdf80da8/produto-joia/background/desktop/212742.jpg	5	0.00	0.00	2026-03-07 17:02:25.229054-03	2026-02-27 20:02:24.548476-03
813	Refil Máscara Reconstrutora para Definição e Nutrição de Cabelos Crespos	\N	148439	Cabelos	Refil Máscara Reconstrutora para Definição e Nutrição de Cabelos Crespos\nRef: 148439	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw07453f2d/produto-joia/background/desktop/148439.jpg	5	59.90	59.90	2026-03-07 17:02:35.687522-03	2026-02-27 20:02:24.556421-03
814	Base Primer 3D Gel Una 8 ml	\N	15825	Maquiagem	Base Primer 3D Gel Una 8 ml\nRef: 15825	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf7530509/NATBRA-15825_1.jpg	5	0.00	0.00	2026-03-07 17:02:45.994623-03	2026-02-27 20:02:24.558454-03
815	Presente Natura Kaiak Masculino Miniaturas (3 produtos)	\N	197470	Homem	Presente Natura Kaiak Masculino Miniaturas (3 produtos)\nRef: 197470	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc2ab2e60/produto-joia/background/desktop/197470.jpg	5	0.00	0.00	2026-03-07 17:03:01.606771-03	2026-02-27 20:02:24.558454-03
817	Kit Body Splash e Balm Labial Tododia Manga Rosa e Água de Coco	\N	241078	Geral	Kit Body Splash e Balm Labial Tododia Manga Rosa e Água de Coco\nRef: 241078	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd54c4798/NATBRA-241078_1.jpg	5	0.00	0.00	2026-03-07 17:03:27.996679-03	2026-02-27 20:02:24.564719-03
818	Máscara Hidratante Refresh Faces	\N	105024	Cabelos	Máscara Hidratante Refresh Faces\nRef: 105024	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfb391521/produto-joia/background/desktop/105024.jpg	5	0.00	0.00	2026-03-07 17:03:38.043292-03	2026-02-27 20:02:24.566728-03
820	Base Sérum Nude Me Una	\N	110186	Maquiagem	Base Sérum Nude Me Una\nRef: 110186	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3bac6827/Produtos/NATBRA-110186_1.jpg	5	0.00	0.00	2026-03-07 17:04:00.472863-03	2026-02-27 20:02:24.570737-03
824	Creme Desodorante Hidratante para o Corpo Ekos Maracujá	\N	203382	Corpo e Banho	Creme Desodorante Hidratante para o Corpo Ekos Maracujá\nRef: 203382	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc6ca6939/produto-joia/background/desktop/203382.jpg	5	0.00	0.00	2026-03-07 17:04:43.957985-03	2026-02-27 20:02:24.578629-03
822	Kit Shampoo, Condicionador e Spray Lumina para Restauração e Liso Prolongado (3 produtos)	\N	221669	Cabelos	Kit Shampoo, Condicionador e Spray Lumina para Restauração e Liso Prolongado (3 produtos)\nRef: 221669	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw43c0dd3e/produto-joia/background/desktop/221669.jpg	5	0.00	0.00	2026-03-07 17:04:58.426796-03	2026-02-27 20:02:24.573049-03
826	Refil Sabonete Líquido Mãos Bothânica Ficus Herb 230 ml	\N	139255	Corpo e Banho	Refil Sabonete Líquido Mãos Bothânica Ficus Herb 230 ml\nRef: 139255	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw39e5edd9/produto-joia/background/desktop/139255.jpg	5	98.00	98.00	2026-03-07 17:05:15.914454-03	2026-02-27 20:02:24.581502-03
828	Kit Shampoo Anticaspa e Sabonete Corpo e Barba Natura Homem (2 produtos)	\N	219743	Cabelos	Kit Shampoo Anticaspa e Sabonete Corpo e Barba Natura Homem (2 produtos)\nRef: 219743	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2a86caef/produto-joia/background/desktop/219743.jpg	5	0.00	0.00	2026-03-07 17:05:45.503128-03	2026-02-27 20:02:24.585051-03
829	Batom Matte Intransferível Una 8ml	\N	54406	Maquiagem	Batom Matte Intransferível Una 8ml\nRef: 54406	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw22b817f5/produto-joia/background/desktop/54406.jpg	5	0.00	0.00	2026-03-07 17:05:55.810565-03	2026-02-27 20:02:24.585051-03
832	Kit Creme Desodorante Nutritivo Corporal Tododia Macadâmia com Refil	\N	102738	Corpo e Banho	Kit Creme Desodorante Nutritivo Corporal Tododia Macadâmia com Refil\nRef: 102738	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf2e8860f/produto-joia/background/desktop/102738.jpg	5	0.00	0.00	2026-03-07 17:06:21.048852-03	2026-02-27 20:02:24.589733-03
834	Creme para Barbear Multifuncional Natura Homem	\N	151021	Corpo e Banho	Creme para Barbear Multifuncional Natura Homem\nRef: 151021	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw21d046b1/produto-joia/background/desktop/151021.jpg	5	57.90	57.90	2026-03-07 17:06:44.440732-03	2026-02-27 20:02:31.73862-03
833	Kit Lumina Antissinais Regenerador Capilar (3 produtos)	\N	235586	Geral	Kit Lumina Antissinais Regenerador Capilar (3 produtos)\nRef: 235586	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwabaf93be/Produtos/NATBRA-235586_1.jpg	5	0.00	0.00	2026-03-07 17:06:57.660817-03	2026-02-27 20:02:31.73862-03
837	Protetor Solar Facial Pele Normal a Seca FPS 70 Natura Solar	\N	176905	Geral	Protetor Solar Facial Pele Normal a Seca FPS 70 Natura Solar\nRef: 176905	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2a71995b/produto-joia/background/desktop/176905.jpg	5	0.00	0.00	2026-03-07 17:07:24.065058-03	2026-02-27 20:02:31.747092-03
836	Kit Óleo Trifásico Desodorante Corporal Ekos Maracujá com Refil	\N	228806	Corpo e Banho	Kit Óleo Trifásico Desodorante Corporal Ekos Maracujá com Refil\nRef: 228806	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwac1f639c/produto-joia/background/desktop/228806.jpg	5	0.00	0.00	2026-03-07 17:07:34.309115-03	2026-02-27 20:02:31.747092-03
839	Desodorante Hidratante Corporal Iluminador Essencial Ato Feminino	\N	156246	Corpo e Banho	Desodorante Hidratante Corporal Iluminador Essencial Ato Feminino\nRef: 156246	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw24bddaac/produto-joia/background/desktop/156246.jpg	5	0.00	0.00	2026-03-07 17:08:02.739631-03	2026-02-27 20:02:31.75542-03
842	Kit Refis Shampoo e Condicionador Lumina Brilho e Proteção da Cor (2 produtos)	\N	208774	Cabelos	Kit Refis Shampoo e Condicionador Lumina Brilho e Proteção da Cor (2 produtos)\nRef: 208774	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw65819961/produto-joia/background/desktop/208774.jpg	5	0.00	0.00	2026-03-07 17:08:30.893401-03	2026-02-27 20:02:31.75542-03
841	Batom Matte Faces 3,5g	\N	93029	Maquiagem	Batom Matte Faces 3,5g\nRef: 93029	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw038bc66f/produto-joia/background/desktop/PAI77992.jpg	5	23.90	23.90	2026-03-07 17:08:41.065199-03	2026-02-27 20:02:31.75542-03
844	Óleo Multifuncional para Definição Intensa de Cabelos Cacheados e Crespos	\N	148165	Cabelos	Óleo Multifuncional para Definição Intensa de Cabelos Cacheados e Crespos\nRef: 148165	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw062dd994/NATBRA-148165_1.jpg	5	79.90	79.90	2026-03-07 17:09:03.110825-03	2026-02-27 20:02:31.764878-03
845	Desodorante Hidratante Corporal Perfumado Essencial Supreme	\N	16873	Corpo e Banho	Desodorante Hidratante Corporal Perfumado Essencial Supreme\nRef: 16873	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwaf76e447/produto-joia/background/desktop/16873.jpg	5	134.90	134.90	2026-03-07 17:09:16.452557-03	2026-02-27 20:02:31.764878-03
847	Kit Lumina Trio Hidratação e Proteção Antipoluição	\N	259841	Geral	Kit Lumina Trio Hidratação e Proteção Antipoluição\nRef: 259841	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw11d755a1/produto-joia/background/desktop/259841.jpg	5	0.00	0.00	2026-03-07 17:09:34.397158-03	2026-02-27 20:02:31.764878-03
851	Pó Compacto Matte Faces 6,5g	\N	8882	Maquiagem	Pó Compacto Matte Faces 6,5g\nRef: 8882	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf474b5a3/Produtos/NATBRA-8882_1.jpg	5	0.00	0.00	2026-03-07 17:09:56.395852-03	2026-02-27 20:02:31.771598-03
849	Sérum Intensivo Redutor de Oleosidade Chronos Derma	\N	169229	Geral	Sérum Intensivo Redutor de Oleosidade Chronos Derma\nRef: 169229	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2d0cd2fc/produto-joia/background/desktop/169229.jpg	5	0.00	0.00	2026-03-07 17:10:06.995754-03	2026-02-27 20:02:31.771598-03
852	Refil Sabonete Líquido em Gel Tododia Tâmara e Canela	\N	7741	Corpo e Banho	Refil Sabonete Líquido em Gel Tododia Tâmara e Canela\nRef: 7741	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc69e0791/NATBRA-7741_1.jpg	5	38.40	38.40	2026-03-07 17:10:39.642494-03	2026-02-27 20:02:31.771598-03
853	Kit Tododia Maçã Verde e Aloe Vera (4 produtos)	\N	184953	Geral	Kit Tododia Maçã Verde e Aloe Vera (4 produtos)\nRef: 184953	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf65aafc8/produto-joia/background/desktop/184953.jpg	5	0.00	0.00	2026-03-07 17:10:52.924924-03	2026-02-27 20:02:31.779616-03
855	Luna Ilumina 50 ml	\N	122474	Geral	Luna Ilumina 50 ml\nRef: 122474	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw37c741de/produto-joia/background/desktop/122474.jpg	5	219.90	219.90	2026-03-07 17:11:21.961985-03	2026-02-27 20:02:31.779996-03
857	Refil Pó Compacto Faces	\N	15045	Maquiagem	Refil Pó Compacto Faces\nRef: 15045	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa53d35fa/Produtos/NATBRA-15045_1.jpg	5	34.90	34.90	2026-03-07 17:11:49.239694-03	2026-02-27 20:02:45.736724-03
858	Gel Hidratante Pós-sol Natura Solar	\N	178865	Corpo e Banho	Gel Hidratante Pós-sol Natura Solar\nRef: 178865	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9c802bf4/produto-joia/background/desktop/178865.jpg	5	69.90	69.90	2026-03-07 17:12:01.678303-03	2026-02-27 20:02:45.736724-03
860	Desodorante Antitranspirante Roll-on Kaiak Oceano Masculino	\N	189394	Corpo e Banho	Desodorante Antitranspirante Roll-on Kaiak Oceano Masculino\nRef: 189394	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb4ea4112/produto-joia/background/desktop/189394.jpg	5	0.00	0.00	2026-03-07 17:12:39.228733-03	2026-02-27 20:02:45.745052-03
862	Protetor Solar Infantil FPS 50 Natura Solar	\N	176907	Infantil	Protetor Solar Infantil FPS 50 Natura Solar\nRef: 176907	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3bae8e54/produto-joia/background/desktop/176907.jpg	5	0.00	0.00	2026-03-07 17:13:32.367807-03	2026-02-27 20:02:45.745052-03
863	Creme Perfumado de Mãos Natura Aura Alba	\N	184481	Corpo e Banho	Creme Perfumado de Mãos Natura Aura Alba\nRef: 184481	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4df6ccd9/produto-joia/background/desktop/184481.jpg	5	47.90	47.90	2026-03-07 17:13:43.83264-03	2026-02-27 20:02:45.753152-03
865	Sabonete Líquido para Mãos que Cozinham Bothânica Mente Sana	\N	140711	Corpo e Banho	Sabonete Líquido para Mãos que Cozinham Bothânica Mente Sana\nRef: 140711	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw265eb76c/produto-joia/background/desktop/140711.jpg	5	160.00	160.00	2026-03-07 17:14:07.224719-03	2026-02-27 20:02:45.753152-03
867	Desodorante Antitranspirante Roll-on Kaiak Aventura Feminino	\N	189393	Corpo e Banho	Desodorante Antitranspirante Roll-on Kaiak Aventura Feminino\nRef: 189393	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw09aad93d/produto-joia/background/desktop/189393.jpg	5	29.90	29.90	2026-03-07 17:14:35.1675-03	2026-02-27 20:02:45.760605-03
868	Embalagem de Presente M Parabéns	\N	178148	Geral	Embalagem de Presente M Parabéns\nRef: 178148	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5fcbdd08/produto-joia/background/desktop/178148.jpg	5	7.00	7.00	2026-03-07 17:14:52.356574-03	2026-02-27 20:02:45.761668-03
878	Kit Lumina Verão com Nécessaire (4 produtos)	\N	228238	Geral	Kit Lumina Verão com Nécessaire (4 produtos)\nRef: 228238	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw618baa0c/produto-joia/background/desktop/228238.jpg	5	0.00	0.00	2026-03-07 18:01:34.287976-03	2026-02-27 20:02:45.778485-03
879	Batom Matte Intransferível Una 8ml	\N	167331	Maquiagem	Batom Matte Intransferível Una 8ml\nRef: 167331	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw54b5147a/produto-joia/background/mobile/167331.jpg	5	64.90	64.90	2026-03-07 18:01:47.59822-03	2026-02-27 20:02:45.778485-03
880	Batom Color Hidra FPS 8 Faces 3,5g	\N	107364	Maquiagem	Batom Color Hidra FPS 8 Faces 3,5g\nRef: 107364	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb2b8bc22/Produtos/NATBRA-107364_1.jpg	5	35.90	35.90	2026-03-07 18:02:01.913901-03	2026-02-27 20:02:53.03919-03
882	Kit Desodorante Corporal Biografia Feminino (3 produtos)	\N	210839	Corpo e Banho	Kit Desodorante Corporal Biografia Feminino (3 produtos)\nRef: 210839	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9871e2da/produto-joia/background/desktop/210839.jpg	5	0.00	0.00	2026-03-07 18:02:26.003421-03	2026-02-27 20:02:53.043669-03
883	Máscara Hidratante Lumina para Hidratação e Proteção Antipoluição	\N	200649	Cabelos	Máscara Hidratante Lumina para Hidratação e Proteção Antipoluição\nRef: 200649	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe5760459/produto-joia/background/desktop/200649.jpg	5	0.00	0.00	2026-03-07 18:02:39.617954-03	2026-02-27 20:02:53.045765-03
885	Refil Óleo Bifásico Desodorante Corporal Ekos Tukumã	\N	75505	Corpo e Banho	Refil Óleo Bifásico Desodorante Corporal Ekos Tukumã\nRef: 75505	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw777d42c2/produto-joia/background/desktop/75505.jpg	5	79.90	79.90	2026-03-07 18:02:56.377345-03	2026-02-27 20:02:53.049764-03
887	Garrafa Térmica Crer Para Ver	\N	185928	Geral	Garrafa Térmica Crer Para Ver\nRef: 185928	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5aab60b3/Produtos/NATBRA-185928_1.jpg	5	109.90	109.90	2026-03-07 18:03:23.919491-03	2026-02-27 20:02:53.053461-03
888	Desodorante Hidratante Corporal Essencial Feminino	\N	194815	Corpo e Banho	Desodorante Hidratante Corporal Essencial Feminino\nRef: 194815	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw93d86d32/Produtos/NATBRA-194815_1.jpg	5	47.20	47.20	2026-03-07 18:03:40.412881-03	2026-02-27 20:02:53.055461-03
890	Refil Gel de Banho Energizante para o Corpo Tododia Energia	\N	152283	Geral	Refil Gel de Banho Energizante para o Corpo Tododia Energia\nRef: 152283	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwee7e8df5/produto-joia/background/desktop/152283.jpg	5	0.00	0.00	2026-03-07 18:04:02.78984-03	2026-02-27 20:02:53.057457-03
892	Refil Desodorante Corporal Erva Doce	\N	123157	Corpo e Banho	Refil Desodorante Corporal Erva Doce\nRef: 123157	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8bc9d9ae/produto-joia/background/desktop/123157.jpg	5	44.90	44.90	2026-03-07 18:04:25.817481-03	2026-02-27 20:02:53.061048-03
904	Essência Sublime Lumina	\N	171367	Geral	Essência Sublime Lumina\nRef: 171367	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwadac62cc/produto-joia/background/desktop/171367.jpg	5	79.90	79.90	2026-03-07 19:01:51.043447-03	2026-02-27 20:03:00.843878-03
906	Sabonete Sortido Puro Vegetal Erva Doce	\N	34089	Corpo e Banho	Sabonete Sortido Puro Vegetal Erva Doce\nRef: 34089	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8ca9c72d/NATBRA-34089_1.jpg	5	40.90	40.90	2026-03-07 19:02:07.829383-03	2026-02-27 20:03:00.848878-03
909	Biografia Inspire Masculino 100 ml	\N	95988	Homem	Biografia Inspire Masculino 100 ml\nRef: 95988	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/pt_BR/v1772828548038/produto-joia/background/desktop/95988.jpg	5	209.90	209.90	2026-03-07 19:02:45.821017-03	2026-02-27 20:03:00.854875-03
910	Kit Tratamento Intensivo para Reconstrução de Danos Extremos (2 produtos)	\N	148448	Geral	Kit Tratamento Intensivo para Reconstrução de Danos Extremos (2 produtos)\nRef: 148448	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6ec7f7ff/produto-joia/background/desktop/148448.jpg	5	149.90	149.90	2026-03-07 19:03:06.027413-03	2026-02-27 20:03:00.855875-03
912	Esfoliante para o Corpo Tododia Acerola e Hibisco	\N	117687	Geral	Esfoliante para o Corpo Tododia Acerola e Hibisco\nRef: 117687	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3f776dc2/produto-joia/background/desktop/117687.jpg	5	50.90	50.90	2026-03-07 19:03:31.527595-03	2026-02-27 20:03:00.859879-03
914	Refil Máscara de Blindagem para Cabelos Opacos ou com Coloração Lumina	\N	126943	Cabelos	Refil Máscara de Blindagem para Cabelos Opacos ou com Coloração Lumina\nRef: 126943	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7aa7b12a/produto-joia/background/desktop/126943.jpg	5	0.00	0.00	2026-03-07 19:03:52.210337-03	2026-02-27 20:03:00.863063-03
915	Spray de Volume para Finalização	\N	148166	Geral	Spray de Volume para Finalização\nRef: 148166	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3eae6197/produto-joia/background/desktop/148166.jpg	5	79.90	79.90	2026-03-07 19:04:02.603905-03	2026-02-27 20:03:00.865065-03
917	Kit Desodorante Antitranspirante Roll-on Erva Doce (4 unidades)	\N	235676	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Erva Doce (4 unidades)\nRef: 235676	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw238afc22/produto-joia/background/desktop/235676.jpg	5	0.00	0.00	2026-03-07 19:04:29.651328-03	2026-02-27 20:03:00.869064-03
918	Refil Creme Desodorante Nutritivo Tododia Limão Siciliano e Flor de Gardênia	\N	162094	Corpo e Banho	Refil Creme Desodorante Nutritivo Tododia Limão Siciliano e Flor de Gardênia\nRef: 162094	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw22d6689c/produto-joia/background/desktop/162094.jpg	5	0.00	0.00	2026-03-07 19:04:46.427764-03	2026-02-27 20:03:00.871063-03
920	Top Coat 3D Gel Una	\N	15826	Geral	Top Coat 3D Gel Una\nRef: 15826	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa08e2f9f/produto-joia/background/desktop/15826.jpg	5	35.90	35.90	2026-03-07 19:05:13.229299-03	2026-02-27 20:03:00.874066-03
921	Kit Shampoo e Máscara Reconstrução de Danos Extremos	\N	167106	Cabelos	Kit Shampoo e Máscara Reconstrução de Danos Extremos\nRef: 167106	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3e9135e4/produto-joia/background/desktop/167106.jpg	5	0.00	0.00	2026-03-07 19:05:24.096124-03	2026-02-27 20:03:00.876066-03
923	Kit Luna Absoluta com Hidratante (2 produtos)	\N	216040	Corpo e Banho	Kit Luna Absoluta com Hidratante (2 produtos)\nRef: 216040	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9988ba2b/produto-joia/background/desktop/216040.jpg	5	0.00	0.00	2026-03-07 19:05:53.17688-03	2026-02-27 20:03:00.880063-03
924	Desodorante Hidratante Corporal Perfumado Luna Radiante	\N	97169	Corpo e Banho	Desodorante Hidratante Corporal Perfumado Luna Radiante\nRef: 97169	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfde61168/produto-joia/background/desktop/97169.jpg	5	95.90	95.90	2026-03-07 19:06:02.560881-03	2026-02-27 20:03:00.881249-03
926	Refil Pó Compacto Nude Me Una	\N	110679	Maquiagem	Refil Pó Compacto Nude Me Una\nRef: 110679	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb974d9cb/Produtos/NATBRA-110679_1.jpg	5	64.90	64.90	2026-03-07 19:06:22.039561-03	2026-02-27 20:03:00.885248-03
927	Condicionador Força e Reparação Molecular Lumina	\N	164517	Cabelos	Condicionador Força e Reparação Molecular Lumina\nRef: 164517	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0bbd7f10/produto-joia/background/desktop/164517.jpg	5	0.00	0.00	2026-03-07 19:06:30.929551-03	2026-02-27 20:03:08.879391-03
929	Batom Color Hidra FPS 8 Faces 3,5g	\N	107359	Maquiagem	Batom Color Hidra FPS 8 Faces 3,5g\nRef: 107359	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw61675c69/Produtos/NATBRA-107359_1.jpg	5	35.90	35.90	2026-03-07 19:07:01.415271-03	2026-02-27 20:03:08.995968-03
930	Kit Kaiak Aero Masculino 100 ml (2 unidades)	\N	222193	Homem	Kit Kaiak Aero Masculino 100 ml (2 unidades)\nRef: 222193	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7d91fbf4/produto-joia/background/desktop/222193.jpg	5	0.00	0.00	2026-03-07 19:07:13.959975-03	2026-02-27 20:03:08.999844-03
931	Máscara Facial Refrescante Faces 20 ml	\N	183307	Cabelos	Máscara Facial Refrescante Faces 20 ml\nRef: 183307	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw77a73784/produto-joia/background/desktop/183308.jpg	5	20.90	20.90	2026-03-07 19:07:29.07445-03	2026-02-27 20:03:09.000188-03
933	Refil Essencial Ato Feminino 100 ml	\N	114585	Geral	Refil Essencial Ato Feminino 100 ml\nRef: 114585	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8ed619c5/NATBRA-114585_1.jpg	5	213.90	213.90	2026-03-07 19:07:51.700775-03	2026-02-27 20:03:09.000188-03
934	Polpa Desodorante Hidratante para o Corpo Ekos Andiroba	\N	166359	Corpo e Banho	Polpa Desodorante Hidratante para o Corpo Ekos Andiroba\nRef: 166359	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb38aab8c/produto-joia/background/desktop/166359.jpg	5	0.00	0.00	2026-03-07 19:08:09.596308-03	2026-02-27 20:03:09.007091-03
937	Refil Spray de Ambientes Bothânica Divinus Plantae 200 ml	\N	140045	Geral	Refil Spray de Ambientes Bothânica Divinus Plantae 200 ml\nRef: 140045	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8c99e288/produto-joia/background/desktop/140045.jpg	5	168.00	168.00	2026-03-07 19:08:46.26246-03	2026-02-27 20:03:09.008187-03
938	Tônico de Tratamento Intensivo Anticaspa	\N	147457	Geral	Tônico de Tratamento Intensivo Anticaspa\nRef: 147457	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb30eb9bd/produto-joia/background/desktop/147457.jpg	5	0.00	0.00	2026-03-07 19:09:01.999134-03	2026-02-27 20:03:09.008187-03
940	Refil Óleo Trifásico Desodorante Corporal Ekos Açaí	\N	110644	Corpo e Banho	Refil Óleo Trifásico Desodorante Corporal Ekos Açaí\nRef: 110644	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw336447aa/produto-joia/background/desktop/110644.jpg	5	79.90	79.90	2026-03-07 19:09:28.637259-03	2026-02-27 20:03:09.016458-03
942	Shampoo Revitalizante para Reparação e Blindagem	\N	148174	Cabelos	Shampoo Revitalizante para Reparação e Blindagem\nRef: 148174	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw50f45357/produto-joia/background/desktop/148174.jpg	5	0.00	0.00	2026-03-07 19:09:48.763957-03	2026-02-27 20:03:09.324826-03
944	Kit para Cabelos Crespos Lumina	\N	194397	Cabelos	Kit para Cabelos Crespos Lumina\nRef: 194397	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwee8f5397/NATBRA-194397_1.jpg	5	0.00	0.00	2026-03-07 19:10:11.347491-03	2026-02-27 20:03:09.328851-03
945	Kit Sabonete Líquido para Mãos Ekos Maracujá com Refil	\N	219072	Corpo e Banho	Kit Sabonete Líquido para Mãos Ekos Maracujá com Refil\nRef: 219072	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdebef001/Produtos/NATBRA-219072_1.jpg	5	0.00	0.00	2026-03-07 19:10:25.051275-03	2026-02-27 20:03:09.328851-03
947	Kit Óleo Trifásico Desodorante Corporal Ekos Andiroba (2 unidades)	\N	221208	Corpo e Banho	Kit Óleo Trifásico Desodorante Corporal Ekos Andiroba (2 unidades)\nRef: 221208	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw41720883/Produtos/NATBRA-221208_1.jpg	5	0.00	0.00	2026-03-07 19:10:45.08196-03	2026-02-27 20:03:09.335588-03
948	Kit Desodorante Antitranspirante Roll-On Natura Homem Sem Perfume (3 unidades)	\N	229969	Perfumaria	Kit Desodorante Antitranspirante Roll-On Natura Homem Sem Perfume (3 unidades)\nRef: 229969	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwff9a611a/produto-joia/background/desktop/229969.jpg	5	0.00	0.00	2026-03-07 19:10:56.999534-03	2026-02-27 20:03:09.335588-03
951	Desodorante Hidratante Iluminador Corporal Perfumado Luna Divina	\N	173003	Corpo e Banho	Desodorante Hidratante Iluminador Corporal Perfumado Luna Divina\nRef: 173003	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc118aaf7/produto-joia/background/desktop/173003.jpg	5	0.00	0.00	2026-03-07 19:11:25.452926-03	2026-02-27 20:03:17.273775-03
953	Ampola Matização e Restauração	\N	148159	Geral	Ampola Matização e Restauração\nRef: 148159	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2edd91fc/produto-joia/background/desktop/148159.jpg	5	0.00	0.00	2026-03-07 19:11:54.351357-03	2026-02-27 20:03:17.273775-03
954	Kit Shampoo Hidratante Tododia Maçã Verde e Aloe Vera com Refil	\N	231694	Cabelos	Kit Shampoo Hidratante Tododia Maçã Verde e Aloe Vera com Refil\nRef: 231694	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6afc17fd/produto-joia/background/desktop/231694.jpg	5	0.00	0.00	2026-03-07 19:12:10.567548-03	2026-02-27 20:03:17.281908-03
956	Desodorante Antitranspirante Roll-on Natura Homem Nós	\N	152271	Corpo e Banho	Desodorante Antitranspirante Roll-on Natura Homem Nós\nRef: 152271	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1c146cc0/produto-joia/background/desktop/152271.jpg	5	29.90	29.90	2026-03-07 19:12:31.620062-03	2026-02-27 20:03:17.281908-03
958	Kit Desodorante Antitranspirante em Creme Tododia Noz Pecã e Cacau (3 unidades)	\N	219735	Corpo e Banho	Kit Desodorante Antitranspirante em Creme Tododia Noz Pecã e Cacau (3 unidades)\nRef: 219735	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw43b23f92/produto-joia/background/desktop/219735.jpg	5	0.00	0.00	2026-03-07 19:12:59.246459-03	2026-02-27 20:03:17.281908-03
959	Creme para Pentear Reparador Tododia Flor de Cereja e Abacate 180 ml	\N	156233	Corpo e Banho	Creme para Pentear Reparador Tododia Flor de Cereja e Abacate 180 ml\nRef: 156233	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7850a399/produto-joia/background/desktop/156233.jpg	5	35.90	35.90	2026-03-07 19:13:14.063549-03	2026-02-27 20:03:17.289405-03
961	Refil Condicionador para Brilho e Proteção da Cor	\N	148405	Cabelos	Refil Condicionador para Brilho e Proteção da Cor\nRef: 148405	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd8957d24/produto-joia/background/desktop/148405.jpg	5	0.00	0.00	2026-03-07 19:13:38.359085-03	2026-02-27 20:03:17.290114-03
962	Kit Lumina Cabelos Crespos Shampoo, Condicionador e Máscara (3 produtos)	\N	217198	Cabelos	Kit Lumina Cabelos Crespos Shampoo, Condicionador e Máscara (3 produtos)\nRef: 217198	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw740b0b14/produto-joia/background/desktop/217198.jpg	5	0.00	0.00	2026-03-07 19:14:00.105475-03	2026-02-27 20:03:17.290114-03
964	Kit Natura Homem Gel para Barbear, Balm e Óleo Pós-Barba (3 produtos)	\N	218192	Corpo e Banho	Kit Natura Homem Gel para Barbear, Balm e Óleo Pós-Barba (3 produtos)\nRef: 218192	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9b66cde7/produto-joia/background/desktop/218192.jpg	5	0.00	0.00	2026-03-07 19:14:23.178838-03	2026-02-27 20:03:17.290114-03
966	Desodorante Antitranspirante Roll-On Kaiak Urbe Masculino	\N	69651	Corpo e Banho	Desodorante Antitranspirante Roll-On Kaiak Urbe Masculino\nRef: 69651	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw528dc545/produto-joia/background/desktop/69651.jpg	5	0.00	0.00	2026-03-07 19:14:49.942202-03	2026-02-27 20:03:17.298345-03
967	Creme para Barbear 2 em 1 Kaiak	\N	116530	Corpo e Banho	Creme para Barbear 2 em 1 Kaiak\nRef: 116530	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw800cc956/Produtos/NATBRA-116530_1.jpg	5	67.50	67.50	2026-03-07 19:14:57.921449-03	2026-02-27 20:03:17.298345-03
969	Shampoo Cabelo e Corpo Natura Homem Sagaz	\N	179458	Cabelos	Shampoo Cabelo e Corpo Natura Homem Sagaz\nRef: 179458	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0c8560b8/produto-joia/background/desktop/179458_.jpg	5	37.80	37.80	2026-03-07 19:15:25.471019-03	2026-02-27 20:03:17.298345-03
972	Pincel PRO Esfumador Una	\N	105715	Geral	Pincel PRO Esfumador Una\nRef: 105715	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc9c89635/produto-joia/background/desktop/105715.jpg	5	29.90	29.90	2026-03-07 19:15:48.304373-03	2026-02-27 20:03:17.306766-03
971	Sabonete Líquido Mãos Natura Bothânica Ficus Herb	\N	139241	Corpo e Banho	Sabonete Líquido Mãos Natura Bothânica Ficus Herb\nRef: 139241	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcbe9243c/produto-joia/background/desktop/139241.jpg	5	150.00	150.00	2026-03-07 19:15:58.138634-03	2026-02-27 20:03:17.306766-03
974	Base Líquida HD Una	\N	191628	Maquiagem	Base Líquida HD Una\nRef: 191628	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw09290680/produto-joia/background/desktop/191628.jpg	5	159.90	159.90	2026-03-07 19:16:22.095518-03	2026-02-27 20:03:17.306766-03
976	Corretivo Checkmatte Faces	\N	116688	Maquiagem	Corretivo Checkmatte Faces\nRef: 116688	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwae089dd3/Produtos/NATBRA-116688_1.jpg	5	34.90	34.90	2026-03-07 19:16:50.565085-03	2026-02-27 20:03:24.64808-03
977	Kit Sabonete em Espuma e Triplo Esfoliante Antissinais Chronos Derma	\N	239268	Corpo e Banho	Kit Sabonete em Espuma e Triplo Esfoliante Antissinais Chronos Derma\nRef: 239268	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw497f8e33/produto-joia/background/desktop/239268.jpg	5	0.00	0.00	2026-03-07 19:17:03.274709-03	2026-02-27 20:03:24.64808-03
979	Desodorante Hidratante Corporal Ekos Ryo Chuva	\N	181008	Corpo e Banho	Desodorante Hidratante Corporal Ekos Ryo Chuva\nRef: 181008	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw80e5bcd6/produto-joia/background/desktop/181008.jpg	5	0.00	0.00	2026-03-07 19:17:31.246759-03	2026-02-27 20:03:24.65644-03
980	Batom Matte Powder Una	\N	95778	Maquiagem	Batom Matte Powder Una\nRef: 95778	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw19c7c76e/produto-joia/background/desktop/95778.jpg	5	59.90	59.90	2026-03-07 19:17:43.430073-03	2026-02-27 20:03:24.65644-03
982	Kit Dupla Antissinais 30+ Chronos Derma (2 produtos)	\N	219703	Geral	Kit Dupla Antissinais 30+ Chronos Derma (2 produtos)\nRef: 219703	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9e3d3864/produto-joia/background/desktop/219703.jpg	5	0.00	0.00	2026-03-07 19:18:08.896663-03	2026-02-27 20:03:24.664088-03
983	Varetas para Difusor de Ambientes Erva Doce Casa	\N	180820	Geral	Varetas para Difusor de Ambientes Erva Doce Casa\nRef: 180820	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw20b5d60b/Produtos/NATBRA-180820_1.jpg	5	10.00	10.00	2026-03-07 19:18:22.899557-03	2026-02-27 20:03:24.664088-03
985	Desodorante Hidratante Corporal Feminino Humor Próprio	\N	116531	Corpo e Banho	Desodorante Hidratante Corporal Feminino Humor Próprio\nRef: 116531	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd6204429/produto-joia/background/desktop/116531.jpg	5	0.00	0.00	2026-03-07 19:18:47.747274-03	2026-02-27 20:03:24.664088-03
996	Kit Sabonete Líquido em Gel para o Corpo Tododia Alecrim e Sálvia com Refil	\N	241079	Corpo e Banho	Kit Sabonete Líquido em Gel para o Corpo Tododia Alecrim e Sálvia com Refil\nRef: 241079	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw37f5aead/NATBRA-241079_1.jpg	5	0.00	0.00	2026-03-07 20:05:51.352002-03	2026-02-27 20:03:24.680839-03
997	Kit Desodorante Antitranspirante Roll-On Natura Homem Elo (3 unidades)	\N	219736	Corpo e Banho	Kit Desodorante Antitranspirante Roll-On Natura Homem Elo (3 unidades)\nRef: 219736	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw153f133d/produto-joia/background/desktop/219736.jpg	5	0.00	0.00	2026-03-07 20:06:05.119153-03	2026-02-27 20:03:24.689169-03
999	Kaiak Aero Feminino 100 ml	\N	108409	Geral	Kaiak Aero Feminino 100 ml\nRef: 108409	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc4e3049d/produto-joia/background/desktop/108409.jpg	5	0.00	0.00	2026-03-07 20:06:38.496328-03	2026-02-27 20:03:33.204416-03
1001	Bronzer Iluminador Corporal Tododia Acerola e Hibisco	\N	180469	Geral	Bronzer Iluminador Corporal Tododia Acerola e Hibisco\nRef: 180469	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe17b241b/produto-joia/background/desktop/180469.jpg	5	0.00	0.00	2026-03-07 20:07:07.195557-03	2026-02-27 20:03:33.212901-03
1002	Refil Desodorante Hidratante Corporal Luna Coragem	\N	115659	Corpo e Banho	Refil Desodorante Hidratante Corporal Luna Coragem\nRef: 115659	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe1e1e4b9/produto-joia/background/desktop/115659.jpg	5	66.90	66.90	2026-03-07 20:07:19.853748-03	2026-02-27 20:03:33.212901-03
1004	Manteiga Uniformizadora de Tom Tododia Jambo Rosa e Flor de Caju	\N	172411	Geral	Manteiga Uniformizadora de Tom Tododia Jambo Rosa e Flor de Caju\nRef: 172411	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbca27b85/produto-joia/background/desktop/172411.jpg	5	84.90	84.90	2026-03-07 20:07:43.513932-03	2026-02-27 20:03:33.220201-03
1005	Refil Desodorante Hidratante Corporal Perfumado Essencial Oud	\N	98943	Corpo e Banho	Refil Desodorante Hidratante Corporal Perfumado Essencial Oud\nRef: 98943	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2c68128b/produto-joia/background/desktop/98943.jpg	5	99.90	99.90	2026-03-07 20:07:58.052817-03	2026-02-27 20:03:33.222456-03
1007	Lápis Para Lábios Color & Contour Faces	\N	9583	Geral	Lápis Para Lábios Color & Contour Faces\nRef: 9583	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf04cd718/Produtos/NATBRA-9583_1.jpg	5	39.90	39.90	2026-03-07 20:08:27.320073-03	2026-02-27 20:03:33.225765-03
1008	Máscara de Blindagem para Brilho e Proteção da Cor	\N	148410	Cabelos	Máscara de Blindagem para Brilho e Proteção da Cor\nRef: 148410	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe1d715b7/produto-joia/background/desktop/148410.jpg	5	79.90	79.90	2026-03-07 20:08:45.789712-03	2026-02-27 20:03:33.227383-03
1010	Kit Shampoo com Refil Lumina Antioleosidade	\N	239176	Cabelos	Kit Shampoo com Refil Lumina Antioleosidade\nRef: 239176	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcaa41d2b/produto-joia/background/desktop/239176.jpg	5	0.00	0.00	2026-03-07 20:09:10.905439-03	2026-02-27 20:03:33.230997-03
1011	Refil Condicionador para Definição e Nutrição de Cabelos Crespos	\N	148400	Cabelos	Refil Condicionador para Definição e Nutrição de Cabelos Crespos\nRef: 148400	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1739d0b1/produto-joia/background/desktop/148400.jpg	5	0.00	0.00	2026-03-07 20:09:26.781782-03	2026-02-27 20:03:33.232652-03
1024	Kit Cremes Nutritivos Tododia Energia e Jambo Rosa e Flor de Caju (2 produtos)	\N	208131	Corpo e Banho	Kit Cremes Nutritivos Tododia Energia e Jambo Rosa e Flor de Caju (2 produtos)\nRef: 208131	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw25df1a78/produto-joia/background/desktop/208131.jpg	5	0.00	0.00	2026-03-07 21:06:56.168379-03	2026-02-27 20:03:41.094363-03
1026	Polpa para Mãos Ekos Priprioca	\N	160269	Corpo e Banho	Polpa para Mãos Ekos Priprioca\nRef: 160269	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw98c703ec/Produtos/NATBRA-160269_1.jpg	5	0.00	0.00	2026-03-07 21:07:25.340481-03	2026-02-27 20:03:41.098389-03
1027	Sabonetes em Barra Puro Vegetal Ilía	\N	129969	Corpo e Banho	Sabonetes em Barra Puro Vegetal Ilía\nRef: 129969	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7f489abe/produto-joia/background/desktop/129969.jpg	5	0.00	0.00	2026-03-07 21:07:41.817193-03	2026-02-27 20:03:41.100396-03
1029	Kit Ekos Castanha Creme para o Corpo e Mãos	\N	239984	Corpo e Banho	Kit Ekos Castanha Creme para o Corpo e Mãos\nRef: 239984	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb53aed9a/produto-joia/background/desktop/239984.jpg	5	0.00	0.00	2026-03-07 21:08:18.58315-03	2026-02-27 20:03:41.103171-03
1030	Spray Texturizador para Finalização	\N	148455	Geral	Spray Texturizador para Finalização\nRef: 148455	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc501c8db/produto-joia/background/desktop/148455.jpg	5	0.00	0.00	2026-03-07 21:08:31.790817-03	2026-02-27 20:03:41.103171-03
1033	Kit Essencial Feminino com Hidratante (2 produtos)	\N	216050	Corpo e Banho	Kit Essencial Feminino com Hidratante (2 produtos)\nRef: 216050	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd057f38f/produto-joia/background/desktop/216050.jpg	5	0.00	0.00	2026-03-07 21:09:01.485448-03	2026-02-27 20:03:41.103171-03
1034	Loção Protetora FPS 30 FPUVA 10 Fotoequilíbrio	\N	103134	Geral	Loção Protetora FPS 30 FPUVA 10 Fotoequilíbrio\nRef: 103134	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3f776dc2/produto-joia/background/desktop/103134.jpg	5	0.00	0.00	2026-03-07 21:09:10.798217-03	2026-02-27 20:03:41.111622-03
1036	Lápis Labial Retrátil PRO Una	\N	204429	Geral	Lápis Labial Retrátil PRO Una\nRef: 204429	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw60c51b27/produto-joia/background/desktop/204429.jpg	5	0.00	0.00	2026-03-07 21:09:36.91361-03	2026-02-27 20:03:41.111622-03
1038	Base Matte Una	\N	108135	Maquiagem	Base Matte Una\nRef: 108135	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw86ba57a6/Produtos/NATBRA-108135_1.jpg	5	99.90	99.90	2026-03-07 21:09:58.612605-03	2026-02-27 20:03:41.111622-03
1042	Kit Gel Creme Antissinais 30+ Dia com Refil	\N	228434	Corpo e Banho	Kit Gel Creme Antissinais 30+ Dia com Refil\nRef: 228434	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw08feeec9/produto-joia/background/desktop/228434.jpg	5	0.00	0.00	2026-03-07 21:10:24.879899-03	2026-02-27 20:03:41.120635-03
1040	Kit Refil Condicionador para Cabelos Lisos e Ondulados Naturé (3 unidades)	\N	229972	Cabelos	Kit Refil Condicionador para Cabelos Lisos e Ondulados Naturé (3 unidades)\nRef: 229972	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw13b8f73b/produto-joia/background/desktop/229972.jpg	5	0.00	0.00	2026-03-07 21:11:17.712196-03	2026-02-27 20:03:41.120635-03
1044	Presente Natura Ekos Ryos Sabonetes (3 unidades)	\N	189863	Corpo e Banho	Presente Natura Ekos Ryos Sabonetes (3 unidades)\nRef: 189863	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4e82ef3f/produto-joia/background/desktop/189863.jpg	5	0.00	0.00	2026-03-07 21:11:29.574268-03	2026-02-27 20:03:48.252398-03
1045	Kit Una Clássico e Gloss	\N	244742	Geral	Kit Una Clássico e Gloss\nRef: 244742	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw58639b48/produto-joia/background/desktop/244742.jpg	5	0.00	0.00	2026-03-07 21:11:43.807988-03	2026-02-27 20:03:48.260833-03
1048	Kit Naturé Colônia Pula Pula e Hidratante (2 produtos)	\N	218209	Perfumaria	Kit Naturé Colônia Pula Pula e Hidratante (2 produtos)\nRef: 218209	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd1b87820/produto-joia/background/desktop/218209.jpg	5	0.00	0.00	2026-03-07 21:11:55.610722-03	2026-02-27 20:03:48.268012-03
1046	Sabonete em Barra Humor Próprio	\N	140004	Corpo e Banho	Sabonete em Barra Humor Próprio\nRef: 140004	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw20e0a58d/produto-joia/background/desktop/140004.jpg	5	16.80	16.80	2026-03-07 21:12:19.612575-03	2026-02-27 20:03:48.260833-03
1049	Bolsa Tiracolo com Porta-celular Crer para Ver	\N	170769	Geral	Bolsa Tiracolo com Porta-celular Crer para Ver\nRef: 170769	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7af8201d/NATBRA-170769_1.jpg	5	0.00	0.00	2026-03-07 21:12:29.010891-03	2026-02-27 20:03:48.269082-03
1050	Kit Una Artisan Deo Parfum e Gloss Labial Hidratação Ativa	\N	212781	Perfumaria	Kit Una Artisan Deo Parfum e Gloss Labial Hidratação Ativa\nRef: 212781	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw672905cc/produto-joia/background/desktop/212781.jpg	5	0.00	0.00	2026-03-07 21:12:51.534306-03	2026-02-27 20:03:48.269082-03
1052	Geleia Desodorante Iluminadora Tododia Jambo Rosa e Flor de Caju	\N	172410	Corpo e Banho	Geleia Desodorante Iluminadora Tododia Jambo Rosa e Flor de Caju\nRef: 172410	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw879d756d/produto-joia/background/desktop/172410.jpg	5	0.00	0.00	2026-03-07 21:13:08.239001-03	2026-02-27 20:03:48.273905-03
1057	Kit Desodorante Colônia e Desodorante Roll-on Natura Homem (2 produtos)	\N	219722	Perfumaria	Kit Desodorante Colônia e Desodorante Roll-on Natura Homem (2 produtos)\nRef: 219722	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw93ccc77b/produto-joia/background/desktop/219722.jpg	5	0.00	0.00	2026-03-07 21:13:49.800006-03	2026-02-27 20:03:48.27737-03
1058	Kit Rotina Rugas Super Chronos Derma (3 produtos)	\N	218215	Geral	Kit Rotina Rugas Super Chronos Derma (3 produtos)\nRef: 218215	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw852a47a1/produto-joia/background/desktop/218215.jpg	5	0.00	0.00	2026-03-07 21:14:34.320433-03	2026-02-27 20:03:48.27737-03
1061	Luna Força	\N	108463	Geral	Luna Força\nRef: 108463	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw80b830bb/produto-joia/background/desktop/108463.jpg	5	185.90	185.90	2026-03-07 21:15:08.713777-03	2026-02-27 20:03:48.285671-03
1060	Desodorante Hidratante Corporal Perfumado Essencial Oud	\N	16872	Corpo e Banho	Desodorante Hidratante Corporal Perfumado Essencial Oud\nRef: 16872	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb2fffc37/produto-joia/background/desktop/16872.jpg	5	0.00	0.00	2026-03-07 21:15:17.150315-03	2026-02-27 20:03:48.285671-03
1062	Kit Kaiak Urbe Masculino (2 unidades)	\N	216472	Homem	Kit Kaiak Urbe Masculino (2 unidades)\nRef: 216472	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4c6c207e/produto-joia/background/desktop/216472.jpg	5	0.00	0.00	2026-03-07 21:15:43.959812-03	2026-02-27 20:03:48.285671-03
1065	Kit Tododia Capim Limão e Hortelã com Hidratante e Body Splash (2 produtos)	\N	215270	Corpo e Banho	Kit Tododia Capim Limão e Hortelã com Hidratante e Body Splash (2 produtos)\nRef: 215270	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0fe725fe/produto-joia/background/desktop/215270.jpg	5	0.00	0.00	2026-03-07 21:16:11.512647-03	2026-02-27 20:03:48.29402-03
1066	Caixa Especial de Presente P	\N	154848	Geral	Caixa Especial de Presente P\nRef: 154848	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw95187e4f/produto-joia/background/desktop/154848.jpg	5	6.90	6.90	2026-03-07 21:16:23.527427-03	2026-02-27 20:03:48.29402-03
1068	Kit Ekos Açaí Creme para o Corpo e Frescor	\N	239975	Corpo e Banho	Kit Ekos Açaí Creme para o Corpo e Frescor\nRef: 239975	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw91837769/produto-joia/background/desktop/239975.jpg	5	0.00	0.00	2026-03-07 21:16:50.755978-03	2026-02-27 20:04:03.715918-03
1069	Kit Lumina Brilho e Proteção da Cor Shampoo, Condicionador e Máscara (3 produtos)	\N	217207	Cabelos	Kit Lumina Brilho e Proteção da Cor Shampoo, Condicionador e Máscara (3 produtos)\nRef: 217207	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9764b394/produto-joia/background/desktop/217207.jpg	5	0.00	0.00	2026-03-07 21:17:04.148916-03	2026-02-27 20:04:03.719014-03
1071	Base Sérum Nude Me Una	\N	110192	Maquiagem	Base Sérum Nude Me Una\nRef: 110192	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe2364112/Produtos/NATBRA-110192_1.jpg	5	0.00	0.00	2026-03-07 21:17:32.581423-03	2026-02-27 20:04:03.722969-03
1073	Base Matte Una	\N	108132	Maquiagem	Base Matte Una\nRef: 108132	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4c6bdaaa/Produtos/NATBRA-108132_1.jpg	5	99.90	99.90	2026-03-07 21:18:00.636889-03	2026-02-27 20:04:03.726265-03
1074	Kit Refil Condicionador Suave Mamãe e Bebê (2 unidades)	\N	229965	Cabelos	Kit Refil Condicionador Suave Mamãe e Bebê (2 unidades)\nRef: 229965	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw93c25fcd/produto-joia/background/desktop/229965.jpg	5	0.00	0.00	2026-03-07 21:18:18.09872-03	2026-02-27 20:04:03.728265-03
1076	Kit Perfumação e Hidratação Ekos Pitanga (2 produtos)	\N	219075	Geral	Kit Perfumação e Hidratação Ekos Pitanga (2 produtos)\nRef: 219075	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4f4ef896/produto-joia/background/desktop/219075.jpg	5	0.00	0.00	2026-03-07 21:18:41.250832-03	2026-02-27 20:04:03.731264-03
1077	Bálsamo Concentrado para o Corpo Ekos Tukumã	\N	123735	Geral	Bálsamo Concentrado para o Corpo Ekos Tukumã\nRef: 123735	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwebaa990c/produto-joia/background/desktop/123735.jpg	5	95.90	95.90	2026-03-07 21:18:52.925005-03	2026-02-27 20:04:03.732268-03
1079	Batom Extremo Conforto FPS 25 Una 3,8g	\N	17276	Maquiagem	Batom Extremo Conforto FPS 25 Una 3,8g\nRef: 17276	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdbeb9744/Produtos/NATBRA-17276_1.jpg	5	0.00	0.00	2026-03-07 21:19:17.918368-03	2026-02-27 20:04:03.735526-03
1081	Pincel PRO Iluminador Una	\N	105713	Geral	Pincel PRO Iluminador Una\nRef: 105713	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw55ccfa93/NATBRA-105713_1.jpg	5	54.90	54.90	2026-03-07 21:19:47.526725-03	2026-02-27 20:04:03.738526-03
1082	Creme Desodorante Nutritivo Para o Corpo Tododia Capim Limão e Hortelã	\N	110810	Corpo e Banho	Creme Desodorante Nutritivo Para o Corpo Tododia Capim Limão e Hortelã\nRef: 110810	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe9ff726d/produto-joia/background/desktop/110810.jpg	5	0.00	0.00	2026-03-07 21:19:59.182227-03	2026-02-27 20:04:03.739526-03
1086	Esmalte Faces Rosa Nude Buenos Aires	\N	106534	Geral	Esmalte Faces Rosa Nude Buenos Aires\nRef: 106534	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8a5bb876/NATBRA-106534_1.jpg	5	0.00	0.00	2026-03-07 21:20:22.955485-03	2026-02-27 20:04:03.741624-03
1085	Creme Hidratante para as Mãos Ekos Pitanga	\N	194522	Corpo e Banho	Creme Hidratante para as Mãos Ekos Pitanga\nRef: 194522	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1287ffc8/produto-joia/background/desktop/194522.jpg	5	0.00	0.00	2026-03-07 21:20:45.761893-03	2026-02-27 20:04:03.741624-03
1087	Gel Booster Hidratante Facial Faces	\N	118910	Corpo e Banho	Gel Booster Hidratante Facial Faces\nRef: 118910	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdbf124fc/produto-joia/background/desktop/118910.jpg	5	64.90	64.90	2026-03-07 21:20:56.746237-03	2026-02-27 20:04:03.748792-03
1088	Kit Essencial Oud Masculino, Sabonete em Barra e Creme de Barbear (3 produtos)	\N	217168	Corpo e Banho	Kit Essencial Oud Masculino, Sabonete em Barra e Creme de Barbear (3 produtos)\nRef: 217168	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9301696c/produto-joia/background/desktop/217168.jpg	5	0.00	0.00	2026-03-07 21:21:26.221093-03	2026-02-27 20:04:03.749714-03
1091	Refil Essência de Tratamento Revitalização e Luminosidade Chronos Derma	\N	135037	Geral	Refil Essência de Tratamento Revitalização e Luminosidade Chronos Derma\nRef: 135037	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw68feb50c/produto-joia/background/desktop/135037.jpg	5	102.00	102.00	2026-03-07 21:21:49.838622-03	2026-02-27 20:04:11.539309-03
1092	Kit Desodorante Antitranspirante Roll-on Kaiak Masculino (2 unidades)	\N	254619	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Kaiak Masculino (2 unidades)\nRef: 254619	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4def3bae/Produtos/NATBRA-254619_1.jpg	5	0.00	0.00	2026-03-07 21:21:58.931763-03	2026-02-27 20:04:11.539309-03
1094	Base Líquida Checkmatte Faces	\N	97644	Maquiagem	Base Líquida Checkmatte Faces\nRef: 97644	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw212da8fe/Produtos/NATBRA-97644_1.jpg	5	0.00	0.00	2026-03-07 21:22:23.08013-03	2026-02-27 20:04:11.547942-03
1096	Refil Desodorante Hidratante Corporal Perfumado Essencial	\N	98941	Corpo e Banho	Refil Desodorante Hidratante Corporal Perfumado Essencial\nRef: 98941	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw62857d4f/produto-joia/background/desktop/98941.jpg	5	99.90	99.90	2026-03-07 21:22:40.96233-03	2026-02-27 20:04:11.547942-03
1097	Creme Desodorante Nutritivo Corporal Tododia Algodão	\N	23037	Corpo e Banho	Creme Desodorante Nutritivo Corporal Tododia Algodão\nRef: 23037	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw354d6216/Produtos/NATBRA-23037_1.jpg	5	56.90	56.90	2026-03-07 21:22:54.865704-03	2026-02-27 20:04:11.547942-03
1099	Batom CC Hidratante FPS 25 Una	\N	167296	Corpo e Banho	Batom CC Hidratante FPS 25 Una\nRef: 167296	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwec85f29d/produto-joia/background/desktop/167296.jpg	5	64.90	64.90	2026-03-07 21:23:20.152272-03	2026-02-27 20:04:11.556008-03
1101	Refil Base Líquida HD Una	\N	173612	Maquiagem	Refil Base Líquida HD Una\nRef: 173612	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw82606fac/produto-joia/background/desktop/173612.jpg	5	109.90	109.90	2026-03-07 21:23:44.57687-03	2026-02-27 20:04:11.556008-03
1103	Conjunto Sabonete em Barra com Saboneteira Kaiak	\N	120195	Corpo e Banho	Conjunto Sabonete em Barra com Saboneteira Kaiak\nRef: 120195	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbe8e24db/NATBRA-120195_1.jpg	5	71.90	71.90	2026-03-07 21:24:12.153664-03	2026-02-27 20:04:11.564298-03
1104	Kit Ekos Maracujá Creme para o Corpo e Frescor	\N	239972	Corpo e Banho	Kit Ekos Maracujá Creme para o Corpo e Frescor\nRef: 239972	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdb06da70/produto-joia/background/desktop/239972.jpg	5	0.00	0.00	2026-03-07 21:24:24.640686-03	2026-02-27 20:04:11.564298-03
1106	Base Tint Extremo Conforto FPS 40 Una 30 ml	\N	135035	Maquiagem	Base Tint Extremo Conforto FPS 40 Una 30 ml\nRef: 135035	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2a233759/Produtos/NATBRA-135035_1.jpg	5	79.90	79.90	2026-03-07 21:24:51.781723-03	2026-02-27 20:04:11.572641-03
1107	Gloss Labial Hidratação Ativa Una	\N	181129	Geral	Gloss Labial Hidratação Ativa Una\nRef: 181129	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw75ace648/produto-joia/background/desktop/181129.jpg	5	59.90	59.90	2026-03-07 21:25:04.145383-03	2026-02-27 20:04:11.572641-03
1117	Sabonete Líquido Mãos Natura Bothânica Fructus Folium	\N	139240	Corpo e Banho	Sabonete Líquido Mãos Natura Bothânica Fructus Folium\nRef: 139240	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw530605dc/produto-joia/background/desktop/139240.jpg	5	150.00	150.00	2026-03-07 22:07:15.565475-03	2026-02-27 20:04:20.330449-03
1119	Kit Natura Homem Creme para Barbear, Balm e Óleo Pós-Barba (3 produtos)	\N	218191	Corpo e Banho	Kit Natura Homem Creme para Barbear, Balm e Óleo Pós-Barba (3 produtos)\nRef: 218191	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwcc31bcf2/produto-joia/background/desktop/218191.jpg	5	0.00	0.00	2026-03-07 22:07:51.736961-03	2026-02-27 20:04:20.339005-03
1120	Kit Lenços Umedecidos com Fragrância Mamãe e Bebê (2 unidades)	\N	211661	Infantil	Kit Lenços Umedecidos com Fragrância Mamãe e Bebê (2 unidades)\nRef: 211661	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdd42fa4c/produto-joia/background/desktop/211661.jpg	5	0.00	0.00	2026-03-07 22:08:04.018139-03	2026-02-27 20:04:20.339005-03
1122	Óleo Desodorante Corporal Perfumado Luna Confiante	\N	102465	Corpo e Banho	Óleo Desodorante Corporal Perfumado Luna Confiante\nRef: 102465	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa055436a/NATBRA-102465_1.jpg	5	0.00	0.00	2026-03-07 22:08:29.534951-03	2026-02-27 20:04:20.347069-03
1124	Sabonetes em Barra Naturés 3 un de 90 g	\N	126266	Corpo e Banho	Sabonetes em Barra Naturés 3 un de 90 g\nRef: 126266	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw60e80598/produto-joia/background/desktop/126266.jpg	5	59.90	59.90	2026-03-07 22:08:56.495163-03	2026-02-27 20:04:20.347069-03
1126	Balm Redutor de Rugas Chronos Derma	\N	169217	Geral	Balm Redutor de Rugas Chronos Derma\nRef: 169217	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw666ca643/produto-joia/background/desktop/169217.jpg	5	109.00	109.00	2026-03-07 22:09:26.730298-03	2026-02-27 20:04:20.347069-03
1140	Base Líquida HD Una	\N	191635	Maquiagem	Base Líquida HD Una\nRef: 191635	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc0ea44d5/produto-joia/background/desktop/191635.jpg	5	159.90	159.90	2026-03-07 23:12:06.175848-03	2026-02-27 20:04:27.671619-03
1141	Refil Creme para Pentear Nutritivo Tododia Pêssego e Amêndoa	\N	156236	Corpo e Banho	Refil Creme para Pentear Nutritivo Tododia Pêssego e Amêndoa\nRef: 156236	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw55cd68d6/produto-joia/background/desktop/156236.jpg	5	27.90	27.90	2026-03-07 23:12:17.547508-03	2026-02-27 20:04:27.671619-03
1143	Kit Natura Homem Sagaz e Desodorante Roll-on (2 produtos)	\N	217172	Corpo e Banho	Kit Natura Homem Sagaz e Desodorante Roll-on (2 produtos)\nRef: 217172	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbb5226fc/produto-joia/background/desktop/217172.jpg	5	0.00	0.00	2026-03-07 23:13:01.355704-03	2026-02-27 20:04:27.679818-03
1145	Kit Creme para Barbear e Hidratante Corporal Natura Homem (2 produtos)	\N	219719	Corpo e Banho	Kit Creme para Barbear e Hidratante Corporal Natura Homem (2 produtos)\nRef: 219719	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw87e338c4/produto-joia/background/desktop/219719.jpg	5	0.00	0.00	2026-03-07 23:13:26.846999-03	2026-02-27 20:04:27.679818-03
1146	Kit Desodorante Antitranspirante Roll-on Kaiak O2 Feminino (3 unidades)	\N	228456	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Kaiak O2 Feminino (3 unidades)\nRef: 228456	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3080c2d0/produto-joia/background/desktop/228456.jpg	5	0.00	0.00	2026-03-07 23:13:37.90347-03	2026-02-27 20:04:27.679818-03
1148	Sérum Noturno Nutritivo Ekos Murumuru	\N	112892	Geral	Sérum Noturno Nutritivo Ekos Murumuru\nRef: 112892	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2e543f49/produto-joia/background/desktop/112892.jpg	5	79.90	79.90	2026-03-07 23:14:11.913505-03	2026-02-27 20:04:27.688019-03
1150	Kit Tododia Todanoite com Hidratante e Body Splash (2 produtos)	\N	215262	Corpo e Banho	Kit Tododia Todanoite com Hidratante e Body Splash (2 produtos)\nRef: 215262	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1610f8af/produto-joia/background/desktop/215262.jpg	5	0.00	0.00	2026-03-07 23:14:38.563839-03	2026-02-27 20:04:27.688019-03
1151	Kit Desodorante Antitranspirante Roll-On Natura Homem Tato (3 unidades)	\N	213237	Corpo e Banho	Kit Desodorante Antitranspirante Roll-On Natura Homem Tato (3 unidades)\nRef: 213237	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7577c9b7/produto-joia/background/desktop/213237.jpg	5	0.00	0.00	2026-03-07 23:14:55.06423-03	2026-02-27 20:04:27.688019-03
1153	Kit Shampoo e Máscara Lumina para Nutrição e Reparação Profunda (2 produtos)	\N	211657	Cabelos	Kit Shampoo e Máscara Lumina para Nutrição e Reparação Profunda (2 produtos)\nRef: 211657	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0853994d/produto-joia/background/desktop/211657.jpg	5	0.00	0.00	2026-03-07 23:15:24.832689-03	2026-02-27 20:04:27.695378-03
1154	Corretivo Cushion Nude Me Una	\N	107125	Maquiagem	Corretivo Cushion Nude Me Una\nRef: 107125	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw42ba9fc6/Produtos/NATBRA-107125_1.jpg	5	0.00	0.00	2026-03-07 23:15:40.48239-03	2026-02-27 20:04:27.696197-03
1158	Nécessaire Crer Para Ver	\N	189545	Geral	Nécessaire Crer Para Ver\nRef: 189545	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1a640ced/produto-joia/background/desktop/189545.jpg	5	0.00	0.00	2026-03-07 23:16:03.32353-03	2026-02-27 20:04:27.703834-03
1156	Batom Cristal Una 8ml	\N	95870	Maquiagem	Batom Cristal Una 8ml\nRef: 95870	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw09942cf2/produto-joia/background/desktop/167322.jpg	5	59.90	59.90	2026-03-07 23:16:24.770217-03	2026-02-27 20:04:27.696197-03
1159	Duo Superbrilho Faces 2,5g	\N	101037	Geral	Duo Superbrilho Faces 2,5g\nRef: 101037	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa0ab1fc3/Produtos/NATBRA-101037_1.jpg	5	44.90	44.90	2026-03-07 23:16:39.866-03	2026-02-27 20:04:27.704924-03
1161	Kit Lumina Matização para Loiros e Grisalhos (2 produtos)	\N	217195	Geral	Kit Lumina Matização para Loiros e Grisalhos (2 produtos)\nRef: 217195	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf8610cf1/produto-joia/background/desktop/217195.jpg	5	0.00	0.00	2026-03-07 23:16:52.884864-03	2026-02-27 20:04:27.704924-03
1162	Kit Luna Clássico com Hidratante (2 produtos)	\N	216071	Corpo e Banho	Kit Luna Clássico com Hidratante (2 produtos)\nRef: 216071	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9c25b938/produto-joia/background/desktop/216071.jpg	5	0.00	0.00	2026-03-07 23:17:22.118237-03	2026-02-27 20:04:36.493916-03
1163	Sérum Intensivo Preenchedor Hidratante Chronos Derma	\N	169233	Corpo e Banho	Sérum Intensivo Preenchedor Hidratante Chronos Derma\nRef: 169233	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1021db43/produto-joia/background/desktop/169233.jpg	5	195.00	195.00	2026-03-07 23:17:37.133888-03	2026-02-27 20:04:36.496484-03
1165	Sabonete em Barra Corpo e Barba Essencial Masculino	\N	114274	Corpo e Banho	Sabonete em Barra Corpo e Barba Essencial Masculino\nRef: 114274	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw848d59c6/NATBRA-114274_1.jpg	5	53.90	53.90	2026-03-07 23:18:02.498626-03	2026-02-27 20:04:36.499731-03
1166	Kit Tododia Macadâmia com Hidratante e Body Splash (2 produtos)	\N	215257	Corpo e Banho	Kit Tododia Macadâmia com Hidratante e Body Splash (2 produtos)\nRef: 215257	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwafaeace5/produto-joia/background/desktop/215257.jpg	5	0.00	0.00	2026-03-07 23:18:13.792026-03	2026-02-27 20:04:36.50133-03
1168	Refil Sabonete Líquido Mãos Bothânica Fructus Folium 230 ml	\N	140712	Corpo e Banho	Refil Sabonete Líquido Mãos Bothânica Fructus Folium 230 ml\nRef: 140712	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfeb6b86e/produto-joia/background/desktop/140712.jpg	5	98.00	98.00	2026-03-07 23:18:41.686561-03	2026-02-27 20:04:36.504736-03
1170	Kit Lumina Cacheados Shampoo, Condicionador e Máscara (3 produtos)	\N	217201	Cabelos	Kit Lumina Cacheados Shampoo, Condicionador e Máscara (3 produtos)\nRef: 217201	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw94195cd2/produto-joia/background/desktop/217201.jpg	5	0.00	0.00	2026-03-07 23:19:08.273541-03	2026-02-27 20:04:36.506914-03
1171	Kit Sabonete Líquido Cremoso para o Corpo Tododia Algodão com Refil	\N	241066	Corpo e Banho	Kit Sabonete Líquido Cremoso para o Corpo Tododia Algodão com Refil\nRef: 241066	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd241ea8d/Produtos/NATBRA-241066_1.jpg	5	0.00	0.00	2026-03-07 23:19:17.571832-03	2026-02-27 20:04:36.506914-03
1173	Refil Base Fluida HD Una	\N	104884	Maquiagem	Refil Base Fluida HD Una\nRef: 104884	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw668d5aa0/Produtos/NATBRA-104884_1.jpg	5	0.00	0.00	2026-03-07 23:19:59.898007-03	2026-02-27 20:04:36.511614-03
1175	Batom CC Hidratante FPS 25 Una Celebrar	\N	194212	Corpo e Banho	Batom CC Hidratante FPS 25 Una Celebrar\nRef: 194212	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw47f11dab/produto-joia/background/desktop/194212.jpg	5	64.90	64.90	2026-03-07 23:20:27.553957-03	2026-02-27 20:04:36.511614-03
1176	Óleo Para Gestante com Guias de Massagem Mamãe e Bebê	\N	75233	Corpo e Banho	Óleo Para Gestante com Guias de Massagem Mamãe e Bebê\nRef: 75233	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7019b895/NATBRA-75233_1.jpg	5	109.90	109.90	2026-03-07 23:20:40.38088-03	2026-02-27 20:04:36.511614-03
1178	Kit Sr. N, Creme de Barbear e Gel Pós Barba (3 produtos)	\N	217190	Corpo e Banho	Kit Sr. N, Creme de Barbear e Gel Pós Barba (3 produtos)\nRef: 217190	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw261871c5/produto-joia/background/desktop/217190.jpg	5	0.00	0.00	2026-03-07 23:21:06.731682-03	2026-02-27 20:04:36.51999-03
1179	Acqua Gel Desodorante Hidratante Pós-sol Perfumado Kaiak Masculino	\N	194824	Corpo e Banho	Acqua Gel Desodorante Hidratante Pós-sol Perfumado Kaiak Masculino\nRef: 194824	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw349e912d/Produtos/NATBRA-194824_1.jpg	5	43.80	43.80	2026-03-07 23:21:19.637686-03	2026-02-27 20:04:36.51999-03
1182	Kit Protetor Solar Facial Pele Mista a Oleosa e Protetor Solar Corporal FPS 50 Natura Solar	\N	231697	Geral	Kit Protetor Solar Facial Pele Mista a Oleosa e Protetor Solar Corporal FPS 50 Natura Solar\nRef: 231697	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc5a45627/produto-joia/background/desktop/231697.jpg	5	0.00	0.00	2026-03-07 23:21:57.762137-03	2026-02-27 20:04:36.528264-03
1183	Máscara Pré-shampoo Ekos Murumuru	\N	113150	Cabelos	Máscara Pré-shampoo Ekos Murumuru\nRef: 113150	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8f81d9ee/produto-joia/background/desktop/113150.jpg	5	0.00	0.00	2026-03-07 23:22:09.635703-03	2026-02-27 20:04:36.528264-03
1185	Kit Desodorante Roll-on e Hidratante Corporal Natura Homem (2 produtos)	\N	219720	Corpo e Banho	Kit Desodorante Roll-on e Hidratante Corporal Natura Homem (2 produtos)\nRef: 219720	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4ea36a1a/produto-joia/background/desktop/219720.jpg	5	0.00	0.00	2026-03-07 23:22:36.03234-03	2026-02-27 20:04:36.528264-03
1186	Kit Natura Homem e Desodorante Roll-on (2 produtos)	\N	217178	Corpo e Banho	Kit Natura Homem e Desodorante Roll-on (2 produtos)\nRef: 217178	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa998a5b1/produto-joia/background/desktop/217178.jpg	5	0.00	0.00	2026-03-07 23:22:50.127065-03	2026-02-27 20:04:44.768946-03
1188	Sabonete em Barra Kaiak Oceano	\N	110076	Corpo e Banho	Sabonete em Barra Kaiak Oceano\nRef: 110076	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf1ac09f9/produto-joia/background/desktop/110076.jpg	5	0.00	0.00	2026-03-07 23:23:20.40357-03	2026-02-27 20:04:44.776894-03
1189	Kit Ekos Açaí Creme para o Corpo e Mãos	\N	239976	Corpo e Banho	Kit Ekos Açaí Creme para o Corpo e Mãos\nRef: 239976	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw468e8345/produto-joia/background/desktop/239976.jpg	5	0.00	0.00	2026-03-07 23:23:32.092926-03	2026-02-27 20:04:44.776894-03
1191	Kit Protetor Solar Facial Pele Mista a Oleosa e Protetor Solar Corporal FPS 70 Natura Solar	\N	231701	Geral	Kit Protetor Solar Facial Pele Mista a Oleosa e Protetor Solar Corporal FPS 70 Natura Solar\nRef: 231701	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9768caf4/produto-joia/background/desktop/231701.jpg	5	0.00	0.00	2026-03-07 23:23:56.579684-03	2026-02-27 20:04:44.784486-03
1193	Refil Máscara de Blindagem para Brilho e Proteção da Cor	\N	148444	Cabelos	Refil Máscara de Blindagem para Brilho e Proteção da Cor\nRef: 148444	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf508cacf/produto-joia/background/desktop/148444.jpg	5	59.90	59.90	2026-03-07 23:24:26.855942-03	2026-02-27 20:04:44.785262-03
1194	Base Líquida Faces Checkmatte	\N	166341	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166341	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw86d9027d/produto-joia/background/desktop/166341.jpg	5	45.90	45.90	2026-03-07 23:24:38.208965-03	2026-02-27 20:04:44.785262-03
1196	Refil Hidratante Mãos Bothânica Fructus Folium 230 ml	\N	139262	Corpo e Banho	Refil Hidratante Mãos Bothânica Fructus Folium 230 ml\nRef: 139262	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw08e998e4/produto-joia/background/desktop/139262.jpg	5	126.00	126.00	2026-03-07 23:25:09.076487-03	2026-02-27 20:04:44.793378-03
1198	Refil Hidratante para Mãos Bothânica Meum Rituale	\N	139265	Corpo e Banho	Refil Hidratante para Mãos Bothânica Meum Rituale\nRef: 139265	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw006cf35c/produto-joia/background/desktop/139265.jpg	5	126.00	126.00	2026-03-07 23:25:37.664466-03	2026-02-27 20:04:44.793378-03
1199	Frasqueira Crer Para Ver	\N	163210	Geral	Frasqueira Crer Para Ver\nRef: 163210	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb7869c5b/produto-joia/background/desktop/163210.jpg	5	86.90	86.90	2026-03-07 23:25:58.014152-03	2026-02-27 20:04:44.793378-03
1201	Creme Desodorante Nutritivo para o Corpo Tododia Avelã e Cassis	\N	23152	Corpo e Banho	Creme Desodorante Nutritivo para o Corpo Tododia Avelã e Cassis\nRef: 23152	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf52b78de/produto-joia/background/desktop/23152.jpg	5	0.00	0.00	2026-03-07 23:26:23.007698-03	2026-02-27 20:04:44.802116-03
1203	Refil Creme Desodorante Hidratante para o Corpo Ekos Açaí	\N	203384	Corpo e Banho	Refil Creme Desodorante Hidratante para o Corpo Ekos Açaí\nRef: 203384	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe6b2c5b4/produto-joia/background/desktop/203384.jpg	5	0.00	0.00	2026-03-07 23:26:50.268998-03	2026-02-27 20:04:44.802116-03
1204	Kit Protetor Solar Facial Pele Normal a Seca FPS 70 Natura Solar (2 unidades)	\N	246106	Geral	Kit Protetor Solar Facial Pele Normal a Seca FPS 70 Natura Solar (2 unidades)\nRef: 246106	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5551bf56/NATBRA-246106_1.jpg	5	0.00	0.00	2026-03-07 23:26:59.431338-03	2026-02-27 20:04:44.802116-03
1206	Base Sérum Nude Me Una	\N	110190	Maquiagem	Base Sérum Nude Me Una\nRef: 110190	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd22f5335/Produtos/NATBRA-110190_1.jpg	5	0.00	0.00	2026-03-07 23:27:23.435185-03	2026-02-27 20:04:44.809397-03
1207	Kit Desodorantes Antitranspirantes Roll-On Natura Homem (3 produtos)	\N	213239	Corpo e Banho	Kit Desodorantes Antitranspirantes Roll-On Natura Homem (3 produtos)\nRef: 213239	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd3d10cbb/produto-joia/background/desktop/213239.jpg	5	0.00	0.00	2026-03-07 23:27:35.631991-03	2026-02-27 20:04:44.810377-03
1209	Base Líquida HD Una	\N	191639	Maquiagem	Base Líquida HD Una\nRef: 191639	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw51c32f3c/produto-joia/background/desktop/191639.jpg	5	159.90	159.90	2026-03-07 23:28:02.207415-03	2026-02-27 20:04:44.810377-03
1210	Base Tint Extremo Conforto FPS 40 Una 30 ml	\N	135047	Maquiagem	Base Tint Extremo Conforto FPS 40 Una 30 ml\nRef: 135047	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3540bc1f/Produtos/NATBRA-135047_1.jpg	5	79.90	79.90	2026-03-07 23:28:11.539011-03	2026-02-27 20:04:52.217734-03
1212	Máscara Reconstrutora para Definição e Nutrição de Cabelos Crespos	\N	148417	Cabelos	Máscara Reconstrutora para Definição e Nutrição de Cabelos Crespos\nRef: 148417	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe58d24d4/produto-joia/background/desktop/148417.jpg	5	79.90	79.90	2026-03-07 23:28:34.189045-03	2026-02-27 20:04:52.226166-03
1214	Refil Studio Palette Una	\N	106129	Geral	Refil Studio Palette Una\nRef: 106129	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdf09b161/Produtos/NATBRA-106129_1.jpg	5	0.00	0.00	2026-03-07 23:28:56.709149-03	2026-02-27 20:04:52.226166-03
1215	Kit Desodorante Antitranspirante Roll-on Kaiak Feminino (3 unidades)	\N	216460	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Kaiak Feminino (3 unidades)\nRef: 216460	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfe6c4bf9/produto-joia/background/desktop/216460.jpg	5	0.00	0.00	2026-03-07 23:29:13.916115-03	2026-02-27 20:04:52.226166-03
1217	Kit Bothânica Spray para Ambientes Cyan Serenum (2 produtos)	\N	213555	Geral	Kit Bothânica Spray para Ambientes Cyan Serenum (2 produtos)\nRef: 213555	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8641c247/produto-joia/background/desktop/213555.jpg	5	408.00	408.00	2026-03-07 23:29:33.916547-03	2026-02-27 20:04:52.234321-03
1218	Kit Bothânica Spray para Ambientes Nobilis Antique e Refil (2 produtos)	\N	213554	Geral	Kit Bothânica Spray para Ambientes Nobilis Antique e Refil (2 produtos)\nRef: 213554	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw85e6e868/produto-joia/background/desktop/213554.jpg	5	408.00	408.00	2026-03-07 23:29:48.646708-03	2026-02-27 20:04:52.234321-03
1219	Ekos Pedra 50 ml	\N	148477	Geral	Ekos Pedra 50 ml\nRef: 148477	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw93572499/produto-joia/background/desktop/148477.jpg	5	389.90	389.90	2026-03-07 23:29:58.01185-03	2026-02-27 20:04:52.234321-03
1220	Kit Lumina Força e Reparação Molecular (4 produtos)	\N	208139	Geral	Kit Lumina Força e Reparação Molecular (4 produtos)\nRef: 208139	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3e0f7594/produto-joia/background/desktop/208139.jpg	5	0.00	0.00	2026-03-07 23:30:08.189849-03	2026-02-27 20:04:52.234321-03
1221	Kit Naturé Colônia Catavento e Hidratante (2 produtos)	\N	218210	Perfumaria	Kit Naturé Colônia Catavento e Hidratante (2 produtos)\nRef: 218210	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw545b01c0/produto-joia/background/desktop/218210.jpg	5	0.00	0.00	2026-03-07 23:30:22.471812-03	2026-02-27 20:04:52.234321-03
1231	Kit Hidratante Tododia Maçã Verde e Aloe Vera e Sabonete Macadâmia (3 produtos)	\N	246102	Corpo e Banho	Kit Hidratante Tododia Maçã Verde e Aloe Vera e Sabonete Macadâmia (3 produtos)\nRef: 246102	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3dbfc26d/NATBRA-246102_1.jpg	5	0.00	0.00	2026-03-08 00:12:16.344515-03	2026-02-27 20:04:52.250628-03
1233	Kit Natura Homem Aromáticos (2 unidades)	\N	256327	Homem	Kit Natura Homem Aromáticos (2 unidades)\nRef: 256327	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9250d4aa/produto-joia/background/desktop/256327.jpg	5	0.00	0.00	2026-03-08 00:12:44.327395-03	2026-02-27 20:04:52.258938-03
1234	Creme Desodorante Nutritivo para o Corpo Tododia Amora Vermelha e Jabuticaba	\N	103999	Corpo e Banho	Creme Desodorante Nutritivo para o Corpo Tododia Amora Vermelha e Jabuticaba\nRef: 103999	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwddd9d13b/produto-joia/background/desktop/103999.jpg	5	0.00	0.00	2026-03-08 00:13:07.200313-03	2026-02-27 20:04:59.467044-03
1236	Esmalte Faces	\N	178163	Geral	Esmalte Faces\nRef: 178163	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw588f38ae/produto-joia/background/desktop/178163.jpg	5	0.00	0.00	2026-03-08 00:13:34.757586-03	2026-02-27 20:04:59.475323-03
1237	Kit Desodorante Spray Corporal Meu Primeiro Humor Feminino (3 produtos)	\N	216070	Corpo e Banho	Kit Desodorante Spray Corporal Meu Primeiro Humor Feminino (3 produtos)\nRef: 216070	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3c3ea11b/produto-joia/background/desktop/216070.jpg	5	0.00	0.00	2026-03-08 00:13:49.590469-03	2026-02-27 20:04:59.475323-03
1239	Polpa Hidratante Para as Mãos Ekos Tukumã	\N	70358	Corpo e Banho	Polpa Hidratante Para as Mãos Ekos Tukumã\nRef: 70358	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw09928f93/NATBRA-70358_1.jpg	5	0.00	0.00	2026-03-08 00:14:23.255126-03	2026-02-27 20:04:59.475323-03
1241	Kit Essencial Supreme Feminino e Hidratante (2 produtos)	\N	216059	Corpo e Banho	Kit Essencial Supreme Feminino e Hidratante (2 produtos)\nRef: 216059	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd0a6de13/produto-joia/background/desktop/216059.jpg	5	0.00	0.00	2026-03-08 00:14:46.360892-03	2026-02-27 20:04:59.483182-03
1242	Refil Blush Intense Me Una 6g	\N	72020	Geral	Refil Blush Intense Me Una 6g\nRef: 72020	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw198289ea/Produtos/NATBRA-72020_1.jpg	5	69.90	69.90	2026-03-08 00:14:57.991711-03	2026-02-27 20:04:59.483182-03
1244	Kit Natura Homem Cor.agio com Hidratante (2 produtos)	\N	217170	Corpo e Banho	Kit Natura Homem Cor.agio com Hidratante (2 produtos)\nRef: 217170	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8b861282/produto-joia/background/desktop/217170.jpg	5	0.00	0.00	2026-03-08 00:15:36.212971-03	2026-02-27 20:04:59.483182-03
1245	Kit Sabonete Líquido Cremoso para o Corpo com Refil Tododia Macadâmia (2 produtos)	\N	256333	Corpo e Banho	Kit Sabonete Líquido Cremoso para o Corpo com Refil Tododia Macadâmia (2 produtos)\nRef: 256333	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9b8b33d1/produto-joia/background/desktop/256333.jpg	5	0.00	0.00	2026-03-08 00:16:03.396181-03	2026-02-27 20:04:59.490513-03
1247	Duo Cadernos Natura Crer Para Ver	\N	170770	Geral	Duo Cadernos Natura Crer Para Ver\nRef: 170770	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1540d7ae/produto-joia/background/desktop/170770.jpg	5	29.90	29.90	2026-03-08 00:16:34.564909-03	2026-02-27 20:04:59.49152-03
1260	Bolsa Multifuncional Kaiak	\N	148127	Geral	Bolsa Multifuncional Kaiak\nRef: 148127	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw878086a6/produto-joia/background/desktop/148127.jpg	5	0.00	0.00	2026-03-08 01:14:13.551026-03	2026-02-27 20:05:13.293909-03
1262	Shampoo 2 em 1 Biografia Assinatura Masculino	\N	106829	Cabelos	Shampoo 2 em 1 Biografia Assinatura Masculino\nRef: 106829	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw86a02967/produto-joia/background/desktop/106829.jpg	5	0.00	0.00	2026-03-08 01:14:39.9084-03	2026-02-27 20:05:13.29926-03
1263	Gel Pós-barba Sr N	\N	85389	Maquiagem	Gel Pós-barba Sr N\nRef: 85389	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc1d576a0/produto-joia/background/desktop/85389.jpg	5	60.90	60.90	2026-03-08 01:14:56.159132-03	2026-02-27 20:05:13.301509-03
1265	Base Líquida HD Una	\N	191626	Maquiagem	Base Líquida HD Una\nRef: 191626	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe12ffa5b/produto-joia/background/desktop/191626.jpg	5	159.90	159.90	2026-03-08 01:15:30.916655-03	2026-02-27 20:05:13.305667-03
1267	Refil Sabonete Líquido para Mãos que Cozinham Bothânica Cucumis Acqua	\N	162010	Corpo e Banho	Refil Sabonete Líquido para Mãos que Cozinham Bothânica Cucumis Acqua\nRef: 162010	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9c1fdc80/produto-joia/background/desktop/162010.jpg	5	98.00	98.00	2026-03-08 01:16:01.701325-03	2026-02-27 20:05:13.309709-03
1268	Kit Desodorante Antitranspirante Roll-on Kaiak Urbe Masculino (2 unidades)	\N	254608	Corpo e Banho	Kit Desodorante Antitranspirante Roll-on Kaiak Urbe Masculino (2 unidades)\nRef: 254608	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9a650f0e/Produtos/NATBRA-254608_1.jpg	5	0.00	0.00	2026-03-08 01:16:23.816361-03	2026-02-27 20:05:13.311709-03
1270	Natura Crer Para Ver Xícara e Pires	\N	176440	Geral	Natura Crer Para Ver Xícara e Pires\nRef: 176440	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa1e24538/produto-joia/background/desktop/194199.jpg	5	0.00	0.00	2026-03-08 01:16:49.580817-03	2026-02-27 20:05:13.314752-03
1272	Creme para Mãos Tododia Flor de Lis	\N	72177	Corpo e Banho	Creme para Mãos Tododia Flor de Lis\nRef: 72177	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdc33dac4/produto-joia/background/desktop/72177.jpg	5	0.00	0.00	2026-03-08 01:17:11.390668-03	2026-02-27 20:05:13.318752-03
1274	Kit Cachos e Crespos Tododia Amora e Óleo de Coco (3 produtos)	\N	228449	Corpo e Banho	Kit Cachos e Crespos Tododia Amora e Óleo de Coco (3 produtos)\nRef: 228449	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbde5a1dd/produto-joia/background/desktop/228449.jpg	5	0.00	0.00	2026-03-08 01:17:41.109385-03	2026-02-27 20:05:13.323492-03
1275	Batom Matte Longa Duração Faces	\N	111426	Maquiagem	Batom Matte Longa Duração Faces\nRef: 111426	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd62e71a3/produto-joia/background/desktop/111426.jpg	5	49.90	49.90	2026-03-08 01:17:55.595044-03	2026-02-27 20:05:13.325515-03
1277	Refil Base Líquida HD Una	\N	173606	Maquiagem	Refil Base Líquida HD Una\nRef: 173606	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd512f94c/produto-joia/background/desktop/173606.jpg	5	109.90	109.90	2026-03-08 01:18:19.32935-03	2026-02-27 20:05:13.325515-03
1278	Kit Desodorante Corporal Sr. N Masculino com Refil	\N	229961	Corpo e Banho	Kit Desodorante Corporal Sr. N Masculino com Refil\nRef: 229961	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw67100ba8/produto-joia/background/desktop/229961.jpg	5	0.00	0.00	2026-03-08 01:18:32.572492-03	2026-02-27 20:05:13.332047-03
1279	Kit Naturé Shampoo 2 em 1 e Sabonete em Barra (2 produtos)	\N	218200	Cabelos	Kit Naturé Shampoo 2 em 1 e Sabonete em Barra (2 produtos)\nRef: 218200	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw60893ca1/produto-joia/background/desktop/218200.jpg	5	0.00	0.00	2026-03-08 01:18:50.131184-03	2026-02-27 20:05:13.334047-03
1281	Kit Luna Ousadia e Luna Divina 75 ml	\N	222190	Geral	Kit Luna Ousadia e Luna Divina 75 ml\nRef: 222190	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2ec53166/produto-joia/background/desktop/222190.jpg	5	0.00	0.00	2026-03-08 01:19:15.808506-03	2026-02-27 20:05:13.338047-03
1283	Refil Base Líquida HD Una	\N	173605	Maquiagem	Refil Base Líquida HD Una\nRef: 173605	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw992c16d2/produto-joia/background/desktop/173605.jpg	5	109.90	109.90	2026-03-08 01:19:45.898017-03	2026-02-27 20:05:21.813364-03
1285	Kit Sérum Antioleosidade com Refil Chronos Derma	\N	239259	Geral	Kit Sérum Antioleosidade com Refil Chronos Derma\nRef: 239259	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb0ac8568/produto-joia/background/desktop/239259.jpg	5	0.00	0.00	2026-03-08 01:20:09.173678-03	2026-02-27 20:05:21.820719-03
1286	Base Sérum Nude Me Una	\N	110195	Maquiagem	Base Sérum Nude Me Una\nRef: 110195	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe042ad68/Produtos/NATBRA-110195_1.jpg	5	0.00	0.00	2026-03-08 01:20:23.036295-03	2026-02-27 20:05:21.821725-03
1288	Refil Base Líquida HD Una	\N	173597	Maquiagem	Refil Base Líquida HD Una\nRef: 173597	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbb5602ab/produto-joia/background/desktop/173597.jpg	5	109.90	109.90	2026-03-08 01:20:47.2088-03	2026-02-27 20:05:21.821725-03
1289	Kit Humor Próprio e Batom Matte Faces Cookie Nude	\N	244787	Maquiagem	Kit Humor Próprio e Batom Matte Faces Cookie Nude\nRef: 244787	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwca784ada/produto-joia/background/desktop/244787.jpg	5	0.00	0.00	2026-03-08 01:21:03.492235-03	2026-02-27 20:05:21.821725-03
1291	Kit Condicionador com Refil Lumina Nutrição e Reparação Profunda	\N	239184	Cabelos	Kit Condicionador com Refil Lumina Nutrição e Reparação Profunda\nRef: 239184	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw98d04f77/produto-joia/background/desktop/239184.jpg	5	0.00	0.00	2026-03-08 01:21:27.643905-03	2026-02-27 20:05:21.82992-03
1293	Batom Color Hidra FPS 8 Faces 3,5g	\N	6319	Maquiagem	Batom Color Hidra FPS 8 Faces 3,5g\nRef: 6319	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8649289c/Produtos/NATBRA-6319_1.jpg	5	35.90	35.90	2026-03-08 01:21:56.379391-03	2026-02-27 20:05:21.82992-03
1295	Kit Condicionador Protetor Lumina para Hidratação e Proteção Antipoluição com Refil (2 produtos)	\N	219733	Cabelos	Kit Condicionador Protetor Lumina para Hidratação e Proteção Antipoluição com Refil (2 produtos)\nRef: 219733	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb6a56dc5/produto-joia/background/desktop/219733.jpg	5	0.00	0.00	2026-03-08 01:22:18.972961-03	2026-02-27 20:05:21.838128-03
1296	Kit Tododia Sol, Mar e Piscina Tododia Manga Rosa e Água de Coco (2 produtos)	\N	234125	Geral	Kit Tododia Sol, Mar e Piscina Tododia Manga Rosa e Água de Coco (2 produtos)\nRef: 234125	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3c535a07/produto-joia/background/desktop/234125.jpg	5	0.00	0.00	2026-03-08 01:22:28.53331-03	2026-02-27 20:05:21.838128-03
1298	Creme de Pentear Ativador para Definição e Nutrição de Cabelos Crespos	\N	148436	Cabelos	Creme de Pentear Ativador para Definição e Nutrição de Cabelos Crespos\nRef: 148436	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5980b2f8/produto-joia/background/desktop/148436.jpg	5	58.90	58.90	2026-03-08 01:22:54.851185-03	2026-02-27 20:05:21.838128-03
1302	Difusor de Ambiente Natura Bothânica Cyan Serenum	\N	167635	Geral	Difusor de Ambiente Natura Bothânica Cyan Serenum\nRef: 167635	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw99be22b5/produto-joia/background/desktop/167635.jpg	5	250.00	250.00	2026-03-08 01:23:23.851014-03	2026-02-27 20:05:21.846476-03
1301	Base Líquida Checkmatte Faces	\N	102866	Maquiagem	Base Líquida Checkmatte Faces\nRef: 102866	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdf30c625/Produtos/NATBRA-102866_1.jpg	5	0.00	0.00	2026-03-08 01:23:48.725342-03	2026-02-27 20:05:21.846476-03
1303	Batom Extremo Conforto FPS 25 Una 3,8g	\N	97700	Maquiagem	Batom Extremo Conforto FPS 25 Una 3,8g\nRef: 97700	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb0a3ce1d/Produtos/NATBRA-97700_1.jpg	5	0.00	0.00	2026-03-08 01:24:04.464229-03	2026-02-27 20:05:21.846476-03
1305	Lápis Labial Retrátil PRO Una	\N	204432	Geral	Lápis Labial Retrátil PRO Una\nRef: 204432	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw065ec9c8/produto-joia/background/desktop/204432.jpg	5	0.00	0.00	2026-03-08 01:24:33.583694-03	2026-02-27 20:05:21.854799-03
1308	Kit Sabonete em Barra e Balm Tododia Acerola e Hibisco	\N	238536	Corpo e Banho	Kit Sabonete em Barra e Balm Tododia Acerola e Hibisco\nRef: 238536	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf38c97f9/Produtos/NATBRA-238536_1.jpg	5	0.00	0.00	2026-03-08 01:24:48.994578-03	2026-02-27 20:05:29.57792-03
1307	Máscara Facial Hidratante Pré Make Faces 20 ml	\N	183308	Cabelos	Máscara Facial Hidratante Pré Make Faces 20 ml\nRef: 183308	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf0e94bc1/produto-joia/background/desktop/183307.jpg	5	20.90	20.90	2026-03-08 01:25:12.257315-03	2026-02-27 20:05:29.569972-03
1312	Presente Natura Una Artisan Deo Parfum, Batom e Lápis (3 produtos)	\N	239798	Perfumaria	Presente Natura Una Artisan Deo Parfum, Batom e Lápis (3 produtos)\nRef: 239798	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb5f50279/produto-joia/background/desktop/239798.jpg	5	0.00	0.00	2026-03-08 01:25:28.335977-03	2026-02-27 20:05:29.578419-03
1310	Kit Sabonete Líquido Esfoliante Corporal Ekos Açaí com Refil	\N	219068	Corpo e Banho	Kit Sabonete Líquido Esfoliante Corporal Ekos Açaí com Refil\nRef: 219068	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwda3b6ee5/produto-joia/background/desktop/219068.jpg	5	0.00	0.00	2026-03-08 01:25:53.855215-03	2026-02-27 20:05:29.578419-03
1311	Base Stick FPS 50 Una	\N	181521	Maquiagem	Base Stick FPS 50 Una\nRef: 181521	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw623d9bc7/produto-joia/background/desktop/181521.jpg	5	119.90	119.90	2026-03-08 01:26:12.380143-03	2026-02-27 20:05:29.578419-03
1317	Batom Líquido Ultra Care Una	\N	148472	Maquiagem	Batom Líquido Ultra Care Una\nRef: 148472	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdf189372/Produtos/NATBRA-148472_1.jpg	5	0.00	0.00	2026-03-08 01:26:38.177273-03	2026-02-27 20:05:29.586656-03
1314	Kit Refil Desodorante Corporal Kaiak Feminino (2 unidades)	\N	254616	Corpo e Banho	Kit Refil Desodorante Corporal Kaiak Feminino (2 unidades)\nRef: 254616	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe118dc29/Produtos/NATBRA-254616_1.jpg	5	0.00	0.00	2026-03-08 01:26:46.935179-03	2026-02-27 20:05:29.586656-03
1316	Kit Máscara com Refil Lumina Restauração e Liso Prolongado	\N	239186	Cabelos	Kit Máscara com Refil Lumina Restauração e Liso Prolongado\nRef: 239186	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw24467e84/produto-joia/background/desktop/239186.jpg	5	0.00	0.00	2026-03-08 01:27:18.327505-03	2026-02-27 20:05:29.586656-03
1322	Kit Shampoo Nutritivo Tododia Pêssego e Amêndoa com Refil	\N	231704	Cabelos	Kit Shampoo Nutritivo Tododia Pêssego e Amêndoa com Refil\nRef: 231704	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9d7997d3/produto-joia/background/desktop/231704.jpg	5	0.00	0.00	2026-03-08 01:27:44.162705-03	2026-02-27 20:05:29.595047-03
1319	Kit Shampoo com Refil Lumina Definição e Hidratação de Cabelos Cacheados	\N	239213	Cabelos	Kit Shampoo com Refil Lumina Definição e Hidratação de Cabelos Cacheados\nRef: 239213	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3e3a30d7/produto-joia/background/desktop/239213.jpg	5	0.00	0.00	2026-03-08 01:27:58.740134-03	2026-02-27 20:05:29.595047-03
1321	Batom Líquido Ultra Care Una	\N	148473	Maquiagem	Batom Líquido Ultra Care Una\nRef: 148473	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4b3f3272/Produtos/NATBRA-148473_1.jpg	5	0.00	0.00	2026-03-08 01:28:25.462776-03	2026-02-27 20:05:29.595047-03
1328	Batom Matte Faces 3,5g	\N	93026	Maquiagem	Batom Matte Faces 3,5g\nRef: 93026	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw038bc66f/produto-joia/background/desktop/PAI77992.jpg	5	23.90	23.90	2026-03-08 01:28:58.632535-03	2026-02-27 20:05:29.603783-03
1324	Kit Desodorante Antitranspirante Roll-On Natura Homem Dom (2 unidades)	\N	252070	Corpo e Banho	Kit Desodorante Antitranspirante Roll-On Natura Homem Dom (2 unidades)\nRef: 252070	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwab8c0a16/Produtos/NATBRA-252070_1.jpg	5	0.00	0.00	2026-03-08 01:29:11.961296-03	2026-02-27 20:05:29.603783-03
1326	Shampoo Ekos Murumuru	\N	113243	Cabelos	Shampoo Ekos Murumuru\nRef: 113243	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw82dd3cd7/produto-joia/background/desktop/113243.jpg	5	59.90	59.90	2026-03-08 01:29:37.845222-03	2026-02-27 20:05:29.603783-03
1329	Kit Dupla Antissinais 70+ Chronos Derma (2 produtos)	\N	219706	Geral	Kit Dupla Antissinais 70+ Chronos Derma (2 produtos)\nRef: 219706	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8ac4d1a8/produto-joia/background/desktop/219706.jpg	5	0.00	0.00	2026-03-08 01:30:04.913201-03	2026-02-27 20:05:29.611963-03
1330	Kit Creme Antissinais 70+ Dia com Refil	\N	228440	Corpo e Banho	Kit Creme Antissinais 70+ Dia com Refil\nRef: 228440	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7b9349b9/produto-joia/background/desktop/228440.jpg	5	0.00	0.00	2026-03-08 01:30:19.886493-03	2026-02-27 20:05:38.359914-03
1332	Kit Creme Antissinais 80+ Noite com Refil	\N	228443	Corpo e Banho	Kit Creme Antissinais 80+ Noite com Refil\nRef: 228443	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3cc6c2f9/produto-joia/background/desktop/228443.jpg	5	0.00	0.00	2026-03-08 01:30:42.817449-03	2026-02-27 20:05:38.36192-03
1336	Kit Creme Hidratante para Mãos e Creme Desodorante Hidratante para o Corpo Ekos Maracujá	\N	252072	Corpo e Banho	Kit Creme Hidratante para Mãos e Creme Desodorante Hidratante para o Corpo Ekos Maracujá\nRef: 252072	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7097cd63/Produtos/NATBRA-252072_1.jpg	5	0.00	0.00	2026-03-08 01:31:14.58254-03	2026-02-27 20:05:38.376273-03
1334	Difusor Natura 774 Rosa Capitiú 200 ml	\N	159123	Geral	Difusor Natura 774 Rosa Capitiú 200 ml\nRef: 159123	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc6062ae0/produto-joia/background/desktop/159123.jpg	5	230.00	230.00	2026-03-08 01:31:27.440126-03	2026-02-27 20:05:38.369873-03
1335	Creme Desodorante Hidratante para o Corpo Ekos Tukumã	\N	203399	Corpo e Banho	Creme Desodorante Hidratante para o Corpo Ekos Tukumã\nRef: 203399	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa60c980f/produto-joia/background/desktop/203399.jpg	5	0.00	0.00	2026-03-08 01:31:44.650067-03	2026-02-27 20:05:38.369873-03
1337	Kit Tododia Jambo Rosa e Flor de Caju com Esfoliante e Hidratante (2 produtos)	\N	215274	Corpo e Banho	Kit Tododia Jambo Rosa e Flor de Caju com Esfoliante e Hidratante (2 produtos)\nRef: 215274	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfacf3091/produto-joia/background/desktop/215274.jpg	5	0.00	0.00	2026-03-08 01:32:07.925684-03	2026-02-27 20:05:38.37738-03
1339	Kit Desodorante Antitranspirante em Creme Tododia Sem Perfume (3 unidades)	\N	229967	Perfumaria	Kit Desodorante Antitranspirante em Creme Tododia Sem Perfume (3 unidades)\nRef: 229967	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw214b45cc/produto-joia/background/desktop/229967.jpg	5	0.00	0.00	2026-03-08 01:32:22.952363-03	2026-02-27 20:05:38.385714-03
1340	Sabonete Líquido Corporal Ilía 80 ml	\N	130032	Corpo e Banho	Sabonete Líquido Corporal Ilía 80 ml\nRef: 130032	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa1d6e70a/produto-joia/background/desktop/130032.jpg	5	0.00	0.00	2026-03-08 01:32:50.566353-03	2026-02-27 20:05:38.38627-03
1343	Gloss Multifuncional Una Celebrar	\N	192148	Geral	Gloss Multifuncional Una Celebrar\nRef: 192148	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa7eb2086/produto-joia/background/desktop/192148.jpg	5	49.90	49.90	2026-03-08 01:33:16.839874-03	2026-02-27 20:05:38.397-03
1344	Essência para Higiene das Mãos Bothânica Delicata Thea	\N	214711	Geral	Essência para Higiene das Mãos Bothânica Delicata Thea\nRef: 214711	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf12dede1/produto-joia/background/desktop/214711.jpg	5	70.00	70.00	2026-03-08 01:33:31.625372-03	2026-02-27 20:05:38.399007-03
1346	Kit Refil para Cabelos Crespos Lumina	\N	194398	Cabelos	Kit Refil para Cabelos Crespos Lumina\nRef: 194398	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw555ae033/NATBRA-194398_1.jpg	5	0.00	0.00	2026-03-08 01:33:58.444674-03	2026-02-27 20:05:38.405385-03
1347	Kit Creme Nutritivo Tododia Algodão e Protetor Solar Facial Pele Mista a Oleosa FPS 50 Natura Solar	\N	239253	Corpo e Banho	Kit Creme Nutritivo Tododia Algodão e Protetor Solar Facial Pele Mista a Oleosa FPS 50 Natura Solar\nRef: 239253	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa8baed13/Produtos/NATBRA-239253_1.jpg	5	0.00	0.00	2026-03-08 01:34:14.502284-03	2026-02-27 20:05:38.407392-03
1358	Kit Sérum Antioxidante com Refil Chronos Derma	\N	239264	Geral	Kit Sérum Antioxidante com Refil Chronos Derma\nRef: 239264	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0a1b3c23/produto-joia/background/desktop/239264.jpg	5	0.00	0.00	2026-03-08 02:16:24.649964-03	2026-02-27 20:05:46.191173-03
1359	Batom Matte Faces Coleção do Amor	\N	12179	Maquiagem	Batom Matte Faces Coleção do Amor\nRef: 12179	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw131fdde6/produto-joia/background/desktop/12179.jpg	5	23.90	23.90	2026-03-08 02:16:41.97186-03	2026-02-27 20:05:46.191805-03
1361	Batom Cristal Una 8ml	\N	167327	Maquiagem	Batom Cristal Una 8ml\nRef: 167327	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0be98317/produto-joia/background/desktop/167327.jpg	5	64.90	64.90	2026-03-08 02:17:04.201016-03	2026-02-27 20:05:46.195128-03
1362	Kit Tododia Energia Flor de Gengibre e Tangerina com Hidratante e Sabonete (2 produtos)	\N	215260	Corpo e Banho	Kit Tododia Energia Flor de Gengibre e Tangerina com Hidratante e Sabonete (2 produtos)\nRef: 215260	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw03073d48/produto-joia/background/desktop/215260.jpg	5	0.00	0.00	2026-03-08 02:17:16.778333-03	2026-02-27 20:05:46.197128-03
1364	Kit Base Sérum Una com Pincel	\N	239206	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239206	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2e6ef345/produto-joia/background/desktop/239206.jpg	5	0.00	0.00	2026-03-08 02:17:43.293058-03	2026-02-27 20:05:46.200451-03
1366	Sacola de Presente G com Laço	\N	161145	Geral	Sacola de Presente G com Laço\nRef: 161145	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwca25ed05/produto-joia/background/desktop/161145.jpg	5	10.90	10.90	2026-03-08 02:18:06.767485-03	2026-02-27 20:05:46.203488-03
1368	Condicionador de Limpeza para Definição Intensa de Cabelos Cacheados e Crespos	\N	148415	Cabelos	Condicionador de Limpeza para Definição Intensa de Cabelos Cacheados e Crespos\nRef: 148415	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4e08541c/NATBRA-148415_1.jpg	5	52.90	52.90	2026-03-08 02:18:32.28559-03	2026-02-27 20:05:46.206483-03
1369	Kit Essência de Tratamento com Refil Chronos Derma	\N	239258	Geral	Kit Essência de Tratamento com Refil Chronos Derma\nRef: 239258	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw96c82f51/produto-joia/background/desktop/239258.jpg	5	0.00	0.00	2026-03-08 02:18:46.964601-03	2026-02-27 20:05:46.208452-03
1371	Loção Protetora Criança FPS 60 FPUVA 20 Fotoequilíbrio	\N	103136	Infantil	Loção Protetora Criança FPS 60 FPUVA 20 Fotoequilíbrio\nRef: 103136	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf4801107/produto-joia/background/desktop/103136.jpg	5	122.90	122.90	2026-03-08 02:19:14.505587-03	2026-02-27 20:05:46.2117-03
1373	Esmalte 3D Gel Una - Contraponto 630	\N	15352	Geral	Esmalte 3D Gel Una - Contraponto 630\nRef: 15352	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6116f7fe/Produtos/NATBRA-15352_1.jpg	5	0.00	0.00	2026-03-08 02:19:41.894682-03	2026-02-27 20:05:46.214698-03
1375	Desodorante Corporal Humor Transforma	\N	170152	Corpo e Banho	Desodorante Corporal Humor Transforma\nRef: 170152	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc871c605/produto-joia/background/desktop/170152.jpg	5	0.00	0.00	2026-03-08 02:20:06.789909-03	2026-02-27 20:05:53.792341-03
1390	Bálsamo Demaquilante Faces	\N	128752	Geral	Bálsamo Demaquilante Faces\nRef: 128752	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc592e338/produto-joia/background/desktop/128752.jpg	5	63.90	63.90	2026-03-08 03:17:25.706991-03	2026-02-27 20:05:53.816803-03
1389	Presente Caderno Mudando o Futuro Crer Para Ver	\N	218962	Geral	Presente Caderno Mudando o Futuro Crer Para Ver\nRef: 218962	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8ff0accc/produto-joia/background/desktop/218962.jpg	5	49.90	49.90	2026-03-08 03:17:38.589785-03	2026-02-27 20:05:53.816803-03
1391	Corretivo Cushion Nude Me Una	\N	107128	Maquiagem	Corretivo Cushion Nude Me Una\nRef: 107128	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa987ebb2/Produtos/NATBRA-107128_1.jpg	5	0.00	0.00	2026-03-08 03:18:02.517918-03	2026-02-27 20:05:53.825086-03
1395	Bronzer Iluminador Corporal Tododia Acerola e Hibisco	\N	180473	Geral	Bronzer Iluminador Corporal Tododia Acerola e Hibisco\nRef: 180473	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw86c1985c/produto-joia/background/desktop/180473.jpg	5	0.00	0.00	2026-03-08 03:18:15.784174-03	2026-02-27 20:05:53.825086-03
1394	Kit Condicionador com Refil Lumina Antioleosidade	\N	239198	Cabelos	Kit Condicionador com Refil Lumina Antioleosidade\nRef: 239198	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb338e47e/produto-joia/background/desktop/239198.jpg	5	0.00	0.00	2026-03-08 03:18:33.873099-03	2026-02-27 20:05:53.825086-03
1393	Kit Faces Lápis para Olhos Preto e Supermáscara Tint para Cílios (2 produtos)	\N	218185	Cabelos	Kit Faces Lápis para Olhos Preto e Supermáscara Tint para Cílios (2 produtos)\nRef: 218185	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3aee9e9c/produto-joia/background/desktop/218185.jpg	5	0.00	0.00	2026-03-08 03:18:47.94894-03	2026-02-27 20:05:53.825086-03
1397	Base Líquida Faces Checkmatte	\N	166338	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166338	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb8b972fb/produto-joia/background/desktop/166338.jpg	5	45.90	45.90	2026-03-08 03:19:30.661072-03	2026-02-27 20:05:53.833362-03
1398	Neutralizador de Espinhas Faces	\N	90176	Geral	Neutralizador de Espinhas Faces\nRef: 90176	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw14113c15/produto-joia/background/desktop/90176.jpg	5	0.00	0.00	2026-03-08 03:20:01.495398-03	2026-02-27 20:06:16.064061-03
1400	Sabonete em Barra Puro Vegetal Biografia Clássico Feminino	\N	123008	Corpo e Banho	Sabonete em Barra Puro Vegetal Biografia Clássico Feminino\nRef: 123008	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw014d7b1f/NATBRA-123008_1.jpg	5	0.00	0.00	2026-03-08 03:20:10.213038-03	2026-02-27 20:06:16.070759-03
1401	Kit Sabonete em Espuma com Refil Chronos Derma	\N	239256	Corpo e Banho	Kit Sabonete em Espuma com Refil Chronos Derma\nRef: 239256	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4f0d338d/produto-joia/background/desktop/239256.jpg	5	0.00	0.00	2026-03-08 03:20:40.411059-03	2026-02-27 20:06:16.071765-03
1402	Batom Líquido Ultra Care Una	\N	148470	Maquiagem	Batom Líquido Ultra Care Una\nRef: 148470	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe2756b1a/Produtos/NATBRA-148470_1.jpg	5	0.00	0.00	2026-03-08 03:21:06.525242-03	2026-02-27 20:06:16.071765-03
1409	Lenço Estampado Crer Para Ver	\N	201328	Geral	Lenço Estampado Crer Para Ver\nRef: 201328	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwabec1261/produto-joia/background/desktop/201328.jpg	5	55.90	55.90	2026-03-08 03:21:19.216083-03	2026-02-27 20:06:16.087375-03
1407	Refil Colônia Naturé Pula Pula 100 ml	\N	146474	Perfumaria	Refil Colônia Naturé Pula Pula 100 ml\nRef: 146474	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw198975bc/produto-joia/background/desktop/146474.jpg	5	79.90	79.90	2026-03-08 03:21:47.479178-03	2026-02-27 20:06:16.080038-03
1408	Nécessaire Lumina (1 unidade)	\N	201327	Geral	Nécessaire Lumina (1 unidade)\nRef: 201327	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0d23016b/Produtos/NATBRA-201327_1.jpg	5	79.90	79.90	2026-03-08 03:22:08.319257-03	2026-02-27 20:06:16.080038-03
1412	Luna Marcante 75 ml	\N	155848	Geral	Luna Marcante 75 ml\nRef: 155848	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6d62422e/produto-joia/background/desktop/155848.jpg	5	0.00	0.00	2026-03-08 03:22:22.024823-03	2026-02-27 20:06:16.088244-03
1411	Base Líquida Faces Checkmatte	\N	166335	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166335	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbdbbc467/produto-joia/background/desktop/166335.jpg	5	45.90	45.90	2026-03-08 03:22:45.662731-03	2026-02-27 20:06:16.088244-03
1414	Base Líquida Checkmatte Faces	\N	102870	Maquiagem	Base Líquida Checkmatte Faces\nRef: 102870	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0d19fcf7/Produtos/NATBRA-102870_1.jpg	5	0.00	0.00	2026-03-08 03:23:09.017498-03	2026-02-27 20:06:16.088244-03
1415	Refil Concentrado Corporal em Creme Ekos Castanha	\N	139243	Corpo e Banho	Refil Concentrado Corporal em Creme Ekos Castanha\nRef: 139243	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw16ed448c/produto-joia/background/desktop/139243.jpg	5	0.00	0.00	2026-03-08 03:23:21.955603-03	2026-02-27 20:06:16.096818-03
1419	Kit Shampoo Antiqueda e Tônico Capilar Antiqueda Natura Homem (2 produtos)	\N	219741	Cabelos	Kit Shampoo Antiqueda e Tônico Capilar Antiqueda Natura Homem (2 produtos)\nRef: 219741	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7dbd02ed/produto-joia/background/desktop/219741.jpg	5	0.00	0.00	2026-03-08 03:23:46.689998-03	2026-02-27 20:06:16.097817-03
1417	Base Líquida Faces Checkmatte	\N	166329	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166329	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw97477cf2/produto-joia/background/desktop/166329.jpg	5	45.90	45.90	2026-03-08 03:24:11.177002-03	2026-02-27 20:06:16.097817-03
1420	Base Líquida Faces Checkmatte	\N	166340	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166340	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd5ea71dc/produto-joia/background/desktop/166340.jpg	5	45.90	45.90	2026-03-08 03:24:22.61562-03	2026-02-27 20:06:16.105123-03
1422	Kit Naturé Shampoo 2 em 1, Sabonete em Barra e Hidratante (3 produtos)	\N	218202	Cabelos	Kit Naturé Shampoo 2 em 1, Sabonete em Barra e Hidratante (3 produtos)\nRef: 218202	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3497d082/produto-joia/background/desktop/218202.jpg	5	0.00	0.00	2026-03-08 03:24:56.335812-03	2026-02-27 20:06:24.645592-03
1425	Kit Hidratante Corporal Perfumado Luna Radiante com Refil	\N	220859	Corpo e Banho	Kit Hidratante Corporal Perfumado Luna Radiante com Refil\nRef: 220859	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb7fee289/produto-joia/background/desktop/220859.jpg	5	0.00	0.00	2026-03-08 03:25:11.890146-03	2026-02-27 20:06:24.654231-03
1423	Kit Demaquilante Bifásico com Refil Chronos Derma	\N	239266	Geral	Kit Demaquilante Bifásico com Refil Chronos Derma\nRef: 239266	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe04ea714/produto-joia/background/desktop/239266.jpg	5	0.00	0.00	2026-03-08 03:25:33.308713-03	2026-02-27 20:06:24.654231-03
1429	Base Líquida HD Una	\N	193846	Maquiagem	Base Líquida HD Una\nRef: 193846	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5e847bbb/produto-joia/background/desktop/193846.jpg	5	159.90	159.90	2026-03-08 03:25:53.244624-03	2026-02-27 20:06:24.662158-03
1427	Kit Água Micelar com Refil Chronos Derma	\N	239257	Geral	Kit Água Micelar com Refil Chronos Derma\nRef: 239257	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6467389b/produto-joia/background/desktop/239257.jpg	5	0.00	0.00	2026-03-08 03:26:25.476598-03	2026-02-27 20:06:24.662158-03
1430	Kit Polpa Desodorante Hidratante para o Corpo Ekos Andiroba (2 unidades)	\N	252082	Corpo e Banho	Kit Polpa Desodorante Hidratante para o Corpo Ekos Andiroba (2 unidades)\nRef: 252082	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4d0d5be7/Produtos/NATBRA-252082_1.jpg	5	0.00	0.00	2026-03-08 03:26:43.600604-03	2026-02-27 20:06:24.669619-03
1433	Corretivo Cobertura Extrema 24h Una 8ml	\N	122123	Maquiagem	Corretivo Cobertura Extrema 24h Una 8ml\nRef: 122123	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe04ee797/produto-joia/background/desktop/PAI122122.jpg	5	0.00	0.00	2026-03-08 03:27:10.544794-03	2026-02-27 20:06:24.670626-03
1432	Kit Creme Desodorante Nutritivo para o Corpo Tododia Noz Pecã e Cacau com Refil	\N	231696	Corpo e Banho	Kit Creme Desodorante Nutritivo para o Corpo Tododia Noz Pecã e Cacau com Refil\nRef: 231696	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw093d035a/produto-joia/background/desktop/231696.jpg	5	0.00	0.00	2026-03-08 03:27:20.984217-03	2026-02-27 20:06:24.670626-03
1434	Kit Spray Texturizador e Essência para Finalização Lumina (2 produtos)	\N	213225	Geral	Kit Spray Texturizador e Essência para Finalização Lumina (2 produtos)\nRef: 213225	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw978429b5/produto-joia/background/desktop/213225.jpg	5	0.00	0.00	2026-03-08 03:27:46.490778-03	2026-02-27 20:06:24.670626-03
1440	Presente Natura Una Artisan Deo Parfum e Batom	\N	239797	Perfumaria	Presente Natura Una Artisan Deo Parfum e Batom\nRef: 239797	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7db573cf/produto-joia/background/desktop/239797.jpg	5	0.00	0.00	2026-03-08 03:28:10.427265-03	2026-02-27 20:06:24.678879-03
1533	Corretivo Cushion Nude Me Una	\N	107134	Maquiagem	Corretivo Cushion Nude Me Una\nRef: 107134	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb6916fdf/Produtos/NATBRA-107134_1.jpg	5	0.00	0.00	2026-03-08 05:23:45.236744-03	2026-02-27 20:07:11.137546-03
1439	Kit Lumina Força e Reparação Molecular Shampoo e Máscara	\N	239199	Cabelos	Kit Lumina Força e Reparação Molecular Shampoo e Máscara\nRef: 239199	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf7741b46/produto-joia/background/desktop/239199.jpg	5	0.00	0.00	2026-03-08 03:28:20.843426-03	2026-02-27 20:06:24.678879-03
1441	Kit Creme Nutritivo com Refil Tododia Tâmara e Canela	\N	239194	Corpo e Banho	Kit Creme Nutritivo com Refil Tododia Tâmara e Canela\nRef: 239194	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw73d00183/produto-joia/background/desktop/239194.jpg	5	0.00	0.00	2026-03-08 03:29:05.767073-03	2026-02-27 20:06:24.687141-03
1443	Esmalte 3D Gel Una - Terracota 960	\N	109479	Geral	Esmalte 3D Gel Una - Terracota 960\nRef: 109479	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc5c11989/Produtos/NATBRA-109479_1.jpg	5	0.00	0.00	2026-03-08 03:29:33.834032-03	2026-02-27 20:06:24.687141-03
1445	Óleo Trifásico Desodorante Corporal Ekos Pitanga	\N	97426	Corpo e Banho	Óleo Trifásico Desodorante Corporal Ekos Pitanga\nRef: 97426	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3546bfb4/NATBRA-97426_1.jpg	5	99.90	99.90	2026-03-08 03:30:00.470998-03	2026-02-27 20:06:24.687141-03
1446	Protetor Solar Corporal FPS 50 Natura Solar	\N	178864	Geral	Protetor Solar Corporal FPS 50 Natura Solar\nRef: 178864	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw09f4ef70/produto-joia/background/desktop/178864.jpg	5	0.00	0.00	2026-03-08 03:30:27.154911-03	2026-02-27 20:06:40.24318-03
1448	Batom Lip Tint Faces	\N	118918	Maquiagem	Batom Lip Tint Faces\nRef: 118918	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6c584360/Produtos/NATBRA-118918_1.jpg	5	0.00	0.00	2026-03-08 03:30:55.393212-03	2026-02-27 20:06:40.251619-03
1450	Kit Condicionador Fortificante Lumina Antiqueda e Crescimento com Refil (2 produtos)	\N	213208	Cabelos	Kit Condicionador Fortificante Lumina Antiqueda e Crescimento com Refil (2 produtos)\nRef: 213208	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe0e2f8ec/produto-joia/background/desktop/213208.jpg	5	0.00	0.00	2026-03-08 03:31:15.484124-03	2026-02-27 20:06:40.258887-03
1454	Kit Erva Doce Desodorante Corporal com Refil (2 produtos)	\N	204413	Corpo e Banho	Kit Erva Doce Desodorante Corporal com Refil (2 produtos)\nRef: 204413	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw009ebb62/NATBRA-204413_1.jpg	5	0.00	0.00	2026-03-08 03:31:31.211542-03	2026-02-27 20:06:40.259869-03
1451	Gel de Limpeza Facial Natura Homem	\N	78934	Homem	Gel de Limpeza Facial Natura Homem\nRef: 78934	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc5a7485e/produto-joia/background/desktop/78934.jpg	5	0.00	0.00	2026-03-08 03:31:48.717064-03	2026-02-27 20:06:40.259869-03
1453	Kit Creme Hidratante para as Mãos Ekos Açaí e Ekos Andiroba (2 unidades)	\N	252073	Corpo e Banho	Kit Creme Hidratante para as Mãos Ekos Açaí e Ekos Andiroba (2 unidades)\nRef: 252073	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw00d2c6cf/Produtos/NATBRA-252073_1.jpg	5	0.00	0.00	2026-03-08 03:32:21.76-03	2026-02-27 20:06:40.259869-03
1458	Desodorante Hidratante Corporal Luna Ousadia	\N	179463	Corpo e Banho	Desodorante Hidratante Corporal Luna Ousadia\nRef: 179463	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb9088dd8/produto-joia/background/desktop/179463.jpg	5	0.00	0.00	2026-03-08 03:32:30.310146-03	2026-02-27 20:06:40.267857-03
1455	Base Tint Extremo Conforto FPS 40 Una 30 ml	\N	135028	Maquiagem	Base Tint Extremo Conforto FPS 40 Una 30 ml\nRef: 135028	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1251bd6c/Produtos/NATBRA-135028_1.jpg	5	79.90	79.90	2026-03-08 03:32:55.319653-03	2026-02-27 20:06:40.267857-03
1457	Kit Tododia Todanoite com Sabonete e Hidratante (2 produtos)	\N	215263	Corpo e Banho	Kit Tododia Todanoite com Sabonete e Hidratante (2 produtos)\nRef: 215263	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7408043d/produto-joia/background/desktop/215263.jpg	5	0.00	0.00	2026-03-08 03:33:16.565433-03	2026-02-27 20:06:40.267857-03
1463	Kit Shampoo e Condicionador Brilho e Proteção da Cor Lumina	\N	216467	Cabelos	Kit Shampoo e Condicionador Brilho e Proteção da Cor Lumina\nRef: 216467	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7e96f3a6/produto-joia/background/desktop/216467.jpg	5	0.00	0.00	2026-03-08 03:33:25.475452-03	2026-02-27 20:06:40.276194-03
1460	Kit Condicionador com Refil Lumina Definição e Hidratação de Cabelos Cacheados	\N	239204	Cabelos	Kit Condicionador com Refil Lumina Definição e Hidratação de Cabelos Cacheados\nRef: 239204	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0c7fb264/produto-joia/background/desktop/239204.jpg	5	0.00	0.00	2026-03-08 03:33:49.774692-03	2026-02-27 20:06:40.276194-03
1462	Base Matte Una	\N	108148	Maquiagem	Base Matte Una\nRef: 108148	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd68c90ab/Produtos/NATBRA-108148_1.jpg	5	99.90	99.90	2026-03-08 03:34:23.277976-03	2026-02-27 20:06:40.276194-03
1465	Delineador Retrátil Faces	\N	140741	Maquiagem	Delineador Retrátil Faces\nRef: 140741	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3710295d/produto-joia/background/desktop/PAI109141.jpg	5	0.00	0.00	2026-03-08 03:34:38.675049-03	2026-02-27 20:06:40.284571-03
1467	Kit Shampoo Reestruturante Lumina para Reconstrução de Danos Extremos (2 produtos)	\N	213209	Cabelos	Kit Shampoo Reestruturante Lumina para Reconstrução de Danos Extremos (2 produtos)\nRef: 213209	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf1a93b19/produto-joia/background/desktop/213209.jpg	5	0.00	0.00	2026-03-08 03:34:52.995791-03	2026-02-27 20:06:40.284571-03
1468	Kit Shampoo com Refil Lumina Definição e Nutrição para Cabelos Crespos	\N	239174	Cabelos	Kit Shampoo com Refil Lumina Definição e Nutrição para Cabelos Crespos\nRef: 239174	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7a6a65ee/produto-joia/background/desktop/239174.jpg	5	0.00	0.00	2026-03-08 03:35:17.179113-03	2026-02-27 20:06:40.284571-03
1471	Batom Color Tint FPS 8 Faces	\N	10161	Maquiagem	Batom Color Tint FPS 8 Faces\nRef: 10161	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe15a12c8/Produtos/NATBRA-10161_1.jpg	5	0.00	0.00	2026-03-08 03:36:01.592871-03	2026-02-27 20:06:56.067091-03
1472	Base Matte Una	\N	108138	Maquiagem	Base Matte Una\nRef: 108138	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw594d9fe5/Produtos/NATBRA-108138_1.jpg	5	99.90	99.90	2026-03-08 03:36:12.49854-03	2026-02-27 20:06:56.069091-03
1473	Ampola Reparação Instantânea para Nutrição e Reparação Profunda	\N	147448	Geral	Ampola Reparação Instantânea para Nutrição e Reparação Profunda\nRef: 147448	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw46fad4c9/produto-joia/background/desktop/147448.jpg	5	79.90	79.90	2026-03-08 03:36:21.937245-03	2026-02-27 20:06:56.071091-03
1475	Kit Faces Lápis Labial Vinho e Lip Tint Roxo Go (2 produtos)	\N	219727	Geral	Kit Faces Lápis Labial Vinho e Lip Tint Roxo Go (2 produtos)\nRef: 219727	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0f61315c/produto-joia/background/desktop/219727.jpg	5	0.00	0.00	2026-03-08 03:36:45.525425-03	2026-02-27 20:06:56.075188-03
1477	Kit Miniaturas Shampoo e Condicionador Ekos Murumuru (2 produtos)	\N	195216	Cabelos	Kit Miniaturas Shampoo e Condicionador Ekos Murumuru (2 produtos)\nRef: 195216	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa319db3f/produto-joia/background/desktop/195216.jpg	5	0.00	0.00	2026-03-08 03:37:10.546648-03	2026-02-27 20:06:56.07826-03
1487	Base Líquida Faces Checkmatte	\N	166346	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166346	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5ed28eb8/produto-joia/background/desktop/166346.jpg	5	45.90	45.90	2026-03-08 04:18:55.829956-03	2026-02-27 20:06:56.094793-03
1489	Base Líquida Faces Checkmatte	\N	166328	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166328	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw39b49d5a/produto-joia/background/desktop/166328.jpg	5	45.90	45.90	2026-03-08 04:19:28.4734-03	2026-02-27 20:06:56.098149-03
1490	Batom Matte Intransferível Una 8ml	\N	107323	Maquiagem	Batom Matte Intransferível Una 8ml\nRef: 107323	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw999dd2d0/produto-joia/background/desktop/167329.jpg	5	0.00	0.00	2026-03-08 04:19:39.280376-03	2026-02-27 20:06:56.099225-03
1493	Kit Desodorante Antitranspirante Roll-On Natura Homem Elo (2 unidades)	\N	252068	Corpo e Banho	Kit Desodorante Antitranspirante Roll-On Natura Homem Elo (2 unidades)\nRef: 252068	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb11f35b7/Produtos/NATBRA-252068_1.jpg	5	0.00	0.00	2026-03-08 04:20:17.547398-03	2026-02-27 20:07:03.922897-03
1495	Base Líquida Faces Checkmatte	\N	166326	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166326	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe5518411/produto-joia/background/desktop/166326.jpg	5	45.90	45.90	2026-03-08 04:20:43.121237-03	2026-02-27 20:07:03.930177-03
1497	Sabonete em Barra Refrescante Natura Homem  110 g	\N	129608	Corpo e Banho	Sabonete em Barra Refrescante Natura Homem  110 g\nRef: 129608	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwff33f1ff/produto-joia/background/desktop/129608.jpg	5	0.00	0.00	2026-03-08 04:21:11.660798-03	2026-02-27 20:07:03.931138-03
1498	Delineador Retrátil Faces	\N	137957	Maquiagem	Delineador Retrátil Faces\nRef: 137957	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3710295d/produto-joia/background/desktop/PAI109141.jpg	5	0.00	0.00	2026-03-08 04:21:20.698285-03	2026-02-27 20:07:03.931138-03
1500	Creme Hidratante para Mãos Essencial Feminino	\N	108939	Corpo e Banho	Creme Hidratante para Mãos Essencial Feminino\nRef: 108939	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd26f8f94/NATBRA-108939_1.jpg	5	0.00	0.00	2026-03-08 04:21:39.033901-03	2026-02-27 20:07:03.931138-03
1502	Refil Creme de Pentear Selador de Cutículas Cabelos Secos	\N	28025	Cabelos	Refil Creme de Pentear Selador de Cutículas Cabelos Secos\nRef: 28025	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw68b3c7a5/produto-joia/background/desktop/28025.jpg	5	0.00	0.00	2026-03-08 04:21:58.784295-03	2026-02-27 20:07:03.939495-03
1504	Embalagem Especial de Presente Redonda	\N	148397	Geral	Embalagem Especial de Presente Redonda\nRef: 148397	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9ad902c7/produto-joia/background/desktop/148397.jpg	5	29.90	29.90	2026-03-08 04:22:23.098131-03	2026-02-27 20:07:03.939495-03
1515	Refil Base Líquida HD Una	\N	173602	Maquiagem	Refil Base Líquida HD Una\nRef: 173602	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd257305b/produto-joia/background/desktop/173602.jpg	5	109.90	109.90	2026-03-08 05:19:37.560107-03	2026-02-27 20:07:11.095902-03
1516	Refil Base Líquida HD Una	\N	173598	Maquiagem	Refil Base Líquida HD Una\nRef: 173598	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwca5cf9f7/produto-joia/background/desktop/173598.jpg	5	109.90	109.90	2026-03-08 05:19:52.498309-03	2026-02-27 20:07:11.095902-03
1518	Kit Natura Homem Especiarias (2 unidades)	\N	256324	Homem	Kit Natura Homem Especiarias (2 unidades)\nRef: 256324	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw62a8ed9a/produto-joia/background/desktop/256324.jpg	5	0.00	0.00	2026-03-08 05:20:08.277459-03	2026-02-27 20:07:11.104839-03
1520	Spray de Ambientes Natura Bothânica Cyan Serenum	\N	139802	Geral	Spray de Ambientes Natura Bothânica Cyan Serenum\nRef: 139802	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw228d567d/produto-joia/background/desktop/139802.jpg	5	240.00	240.00	2026-03-08 05:20:36.315144-03	2026-02-27 20:07:11.108642-03
1521	Refil Spray de Ambientes Bothânica Nobilis Antique 200 ml	\N	140049	Geral	Refil Spray de Ambientes Bothânica Nobilis Antique 200 ml\nRef: 140049	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwafbd976a/produto-joia/background/desktop/140049.jpg	5	168.00	168.00	2026-03-08 05:21:04.211567-03	2026-02-27 20:07:11.112609-03
1523	Refil Base Líquida HD Una	\N	173600	Maquiagem	Refil Base Líquida HD Una\nRef: 173600	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw55b1dffb/produto-joia/background/desktop/173600.jpg	5	109.90	109.90	2026-03-08 05:21:18.147596-03	2026-02-27 20:07:11.112609-03
1524	Base Líquida Faces Checkmatte	\N	166343	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166343	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0df6d6da/produto-joia/background/desktop/166343.jpg	5	45.90	45.90	2026-03-08 05:21:43.611011-03	2026-02-27 20:07:11.120895-03
1527	Kit Luna Absoluta 75 ml (2 unidades)	\N	222187	Geral	Kit Luna Absoluta 75 ml (2 unidades)\nRef: 222187	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3134741f/produto-joia/background/desktop/222187.jpg	5	0.00	0.00	2026-03-08 05:22:09.828583-03	2026-02-27 20:07:11.120895-03
1530	Desodorante Antitranspirante Roll-On Kaiak Masculino	\N	69653	Corpo e Banho	Desodorante Antitranspirante Roll-On Kaiak Masculino\nRef: 69653	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0b5a3820/produto-joia/background/desktop/69653.jpg	5	0.00	0.00	2026-03-08 05:22:21.942826-03	2026-02-27 20:07:11.129111-03
1529	Kit Base Sérum Una com Pincel	\N	239251	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239251	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0dbafced/produto-joia/background/desktop/239251.jpg	5	0.00	0.00	2026-03-08 05:22:57.767604-03	2026-02-27 20:07:11.129111-03
1536	Refil Base Fluida HD Una	\N	104893	Maquiagem	Refil Base Fluida HD Una\nRef: 104893	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4d6be9ad/Produtos/NATBRA-104893_1.jpg	5	0.00	0.00	2026-03-08 05:23:22.697413-03	2026-02-27 20:07:11.145895-03
1534	Geléia de Banho Corporal Humor Off-line	\N	100145	Geral	Geléia de Banho Corporal Humor Off-line\nRef: 100145	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb11acb6c/NATBRA-100145_1.jpg	5	47.90	47.90	2026-03-08 05:23:59.378444-03	2026-02-27 20:07:11.137546-03
1537	Corretivo Cushion Nude Me Una	\N	107133	Maquiagem	Corretivo Cushion Nude Me Una\nRef: 107133	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfee43867/Produtos/NATBRA-107133_1.jpg	5	0.00	0.00	2026-03-08 05:24:24.730316-03	2026-02-27 20:07:11.145895-03
1538	Base Líquida Checkmatte Faces	\N	102873	Maquiagem	Base Líquida Checkmatte Faces\nRef: 102873	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0a237b02/Produtos/NATBRA-102873_1.jpg	5	0.00	0.00	2026-03-08 05:24:50.042227-03	2026-02-27 20:07:18.903798-03
1544	Refil Pó Compacto Nude Me Una	\N	110683	Maquiagem	Refil Pó Compacto Nude Me Una\nRef: 110683	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw668574f2/Produtos/NATBRA-110683_1.jpg	5	64.90	64.90	2026-03-08 05:25:16.342156-03	2026-02-27 20:07:18.912032-03
1546	Conjunto Kaiak Com Necessaire	\N	120194	Geral	Conjunto Kaiak Com Necessaire\nRef: 120194	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8ecf36da/produto-joia/background/desktop/120194.jpg	5	283.90	283.90	2026-03-08 05:25:30.371294-03	2026-02-27 20:07:18.919836-03
1543	Base Matte Una	\N	108150	Maquiagem	Base Matte Una\nRef: 108150	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwab5bb5bd/Produtos/NATBRA-108150_1.jpg	5	99.90	99.90	2026-03-08 05:25:58.413935-03	2026-02-27 20:07:18.912032-03
1551	Sombra Mono Faces	\N	109153	Geral	Sombra Mono Faces\nRef: 109153	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb51d86e1/Produtos/NATBRA-109153_1.jpg	5	39.90	39.90	2026-03-08 05:26:38.894338-03	2026-02-27 20:07:18.920299-03
1548	Kit Studio Palette Una	\N	118980	Geral	Kit Studio Palette Una\nRef: 118980	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8dffd71d/Produtos/NATBRA-118980_1.jpg	5	0.00	0.00	2026-03-08 05:27:05.895795-03	2026-02-27 20:07:18.920299-03
1561	Desodorante Hidratante Corporal Luna Ousadia	\N	129620	Corpo e Banho	Desodorante Hidratante Corporal Luna Ousadia\nRef: 129620	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwda72d7d7/produto-joia/background/desktop/129620.jpg	5	0.00	0.00	2026-03-08 05:29:37.439965-03	2026-02-27 20:07:18.937283-03
1563	Kit Natura Tododia Tâmara e Canela	\N	167215	Geral	Kit Natura Tododia Tâmara e Canela\nRef: 167215	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw48b1c10d/produto-joia/background/desktop/167215.jpg	5	0.00	0.00	2026-03-08 05:30:03.667137-03	2026-02-27 20:07:34.327228-03
1564	Esmalte Glitter Faces	\N	163224	Geral	Esmalte Glitter Faces\nRef: 163224	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw35b0c1a6/produto-joia/background/desktop/163224.jpg	5	0.00	0.00	2026-03-08 05:30:33.84517-03	2026-02-27 20:07:34.335623-03
1565	Refil Base Líquida HD Una	\N	173993	Maquiagem	Refil Base Líquida HD Una\nRef: 173993	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa0d62da5/produto-joia/background/desktop/173993.jpg	5	109.90	109.90	2026-03-08 05:30:47.340919-03	2026-02-27 20:07:34.335623-03
1567	Refil Sabonete Líquido para Mãos Bothânica Meum Rituale	\N	166364	Corpo e Banho	Refil Sabonete Líquido para Mãos Bothânica Meum Rituale\nRef: 166364	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbfc1f318/produto-joia/background/desktop/166364.jpg	5	98.00	98.00	2026-03-08 05:30:59.206836-03	2026-02-27 20:07:34.335623-03
1571	Refil Base Líquida HD Una	\N	173603	Maquiagem	Refil Base Líquida HD Una\nRef: 173603	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw667b75b8/produto-joia/background/desktop/173603.jpg	5	109.90	109.90	2026-03-08 05:31:10.282154-03	2026-02-27 20:07:34.343412-03
1568	Refil Base Líquida HD Una	\N	173992	Maquiagem	Refil Base Líquida HD Una\nRef: 173992	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd44daa74/produto-joia/background/desktop/173992.jpg	5	109.90	109.90	2026-03-08 05:31:24.261593-03	2026-02-27 20:07:34.343412-03
1570	Refil Base Líquida HD Una	\N	173611	Maquiagem	Refil Base Líquida HD Una\nRef: 173611	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd295b827/produto-joia/background/desktop/173611.jpg	5	109.90	109.90	2026-03-08 05:31:45.442273-03	2026-02-27 20:07:34.343412-03
1575	Base Líquida Faces Checkmatte	\N	166348	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166348	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7e98826c/produto-joia/background/desktop/166348.jpg	5	45.90	45.90	2026-03-08 05:32:12.204017-03	2026-02-27 20:07:34.351758-03
1577	Refil Base Líquida HD Una	\N	173610	Maquiagem	Refil Base Líquida HD Una\nRef: 173610	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw7e0576d2/produto-joia/background/desktop/173610.jpg	5	109.90	109.90	2026-03-08 05:32:22.221939-03	2026-02-27 20:07:34.351758-03
1574	Base Líquida Faces Checkmatte	\N	166331	Maquiagem	Base Líquida Faces Checkmatte\nRef: 166331	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9a85df5b/produto-joia/background/desktop/166331.jpg	5	45.90	45.90	2026-03-08 05:32:52.490686-03	2026-02-27 20:07:34.351758-03
1578	Shampoo Hidratação em Barra Biōme	\N	16528	Cabelos	Shampoo Hidratação em Barra Biōme\nRef: 16528	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw493ead43/produto-joia/background/desktop/16528.jpg	5	59.90	59.90	2026-03-08 05:33:16.584253-03	2026-02-27 20:07:34.360143-03
1579	Difusor de Ambiente Natura Bothânica Nobilis Antique	\N	167634	Geral	Difusor de Ambiente Natura Bothânica Nobilis Antique\nRef: 167634	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwab79202f/produto-joia/background/desktop/167634.jpg	5	250.00	250.00	2026-03-08 05:33:25.929631-03	2026-02-27 20:07:34.360143-03
1581	Kit Shampoo e Máscara Nutrição e Reparação	\N	167104	Cabelos	Kit Shampoo e Máscara Nutrição e Reparação\nRef: 167104	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd9c7ee6f/produto-joia/background/desktop/167104.jpg	5	0.00	0.00	2026-03-08 05:33:52.053744-03	2026-02-27 20:07:34.360143-03
1584	Base Líquida HD Una	\N	191632	Maquiagem	Base Líquida HD Una\nRef: 191632	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwebbcef8b/produto-joia/background/desktop/191632.jpg	5	159.90	159.90	2026-03-08 05:34:16.674036-03	2026-02-27 20:07:34.368372-03
1583	Base Stick FPS 50 Una	\N	181519	Maquiagem	Base Stick FPS 50 Una\nRef: 181519	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw18c72ce3/produto-joia/background/desktop/181519.jpg	5	119.90	119.90	2026-03-08 05:34:32.951032-03	2026-02-27 20:07:34.368372-03
1586	Base Líquida HD Una	\N	191633	Maquiagem	Base Líquida HD Una\nRef: 191633	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd0f96b58/produto-joia/background/desktop/191633.jpg	5	159.90	159.90	2026-03-08 05:34:57.870018-03	2026-02-27 20:07:41.817272-03
1587	Refil Difusor de Ambientes em Cerâmica Bothânica 2 esferas	\N	180462	Geral	Refil Difusor de Ambientes em Cerâmica Bothânica 2 esferas\nRef: 180462	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8a1f4aa4/produto-joia/background/desktop/180462.jpg	5	93.00	93.00	2026-03-08 05:35:14.688516-03	2026-02-27 20:07:41.817272-03
1590	Base Líquida HD Una	\N	191629	Maquiagem	Base Líquida HD Una\nRef: 191629	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0b0e540b/produto-joia/background/desktop/191629.jpg	5	159.90	159.90	2026-03-08 05:35:46.716823-03	2026-02-27 20:07:41.82858-03
1591	Base Líquida HD Una	\N	191622	Maquiagem	Base Líquida HD Una\nRef: 191622	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2bd125bd/produto-joia/background/desktop/191622.jpg	5	159.90	159.90	2026-03-08 05:36:13.981532-03	2026-02-27 20:07:41.833687-03
1592	Base Líquida HD Una	\N	191627	Maquiagem	Base Líquida HD Una\nRef: 191627	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw736ff57c/produto-joia/background/desktop/191627.jpg	5	159.90	159.90	2026-03-08 05:36:39.799075-03	2026-02-27 20:07:41.833687-03
1593	Base Líquida HD Una	\N	191625	Maquiagem	Base Líquida HD Una\nRef: 191625	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbc413433/produto-joia/background/desktop/191625.jpg	5	159.90	159.90	2026-03-08 05:36:51.253103-03	2026-02-27 20:07:41.833687-03
1600	Base Stick FPS 50 Una	\N	181517	Maquiagem	Base Stick FPS 50 Una\nRef: 181517	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw64b395b6/produto-joia/background/desktop/181517.jpg	5	119.90	119.90	2026-03-08 05:37:15.289893-03	2026-02-27 20:07:41.849508-03
1598	Base Stick FPS 50 Una	\N	181511	Maquiagem	Base Stick FPS 50 Una\nRef: 181511	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw81bd8b21/produto-joia/background/desktop/181511.jpg	5	119.90	119.90	2026-03-08 05:37:40.195848-03	2026-02-27 20:07:41.841996-03
1597	Panos de Copa Bothânica (2 unidades)	\N	180799	Geral	Panos de Copa Bothânica (2 unidades)\nRef: 180799	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwad06797d/produto-joia/background/desktop/180799.jpg	5	90.00	90.00	2026-03-08 05:38:03.753717-03	2026-02-27 20:07:41.841996-03
1601	Kit Lumina Finalizadores Cabelos Crespos (2 produtos	\N	204419	Cabelos	Kit Lumina Finalizadores Cabelos Crespos (2 produtos\nRef: 204419	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw859b66a6/NATBRA-204419.jpg	5	0.00	0.00	2026-03-08 05:38:13.759223-03	2026-02-27 20:07:41.850328-03
1603	Kit Ekos Sabonete Líquido Esfoliante Açaí com Refil (2 produtos)	\N	204406	Corpo e Banho	Kit Ekos Sabonete Líquido Esfoliante Açaí com Refil (2 produtos)\nRef: 204406	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw97ecb676/NATBRA-204406_1.jpg	5	0.00	0.00	2026-03-08 05:38:38.543276-03	2026-02-27 20:07:41.850328-03
1612	Kit Bothânica Spray para Ambientes Divinus Plantae e Refil (2 produtos)	\N	213552	Geral	Kit Bothânica Spray para Ambientes Divinus Plantae e Refil (2 produtos)\nRef: 213552	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw59157001/produto-joia/background/desktop/213552.jpg	5	408.00	408.00	2026-03-08 06:20:19.505286-03	2026-02-27 20:07:49.863939-03
1614	Kit Luna Ousadia com Hidratante (2 produtos)	\N	216044	Corpo e Banho	Kit Luna Ousadia com Hidratante (2 produtos)\nRef: 216044	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf10142a2/produto-joia/background/desktop/216044.jpg	5	0.00	0.00	2026-03-08 06:20:47.463568-03	2026-02-27 20:07:49.867264-03
1615	Kit Tododia Tâmara e Canela com Hidratante e Body Splash (2 produtos)	\N	215266	Corpo e Banho	Kit Tododia Tâmara e Canela com Hidratante e Body Splash (2 produtos)\nRef: 215266	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc8893d3e/produto-joia/background/desktop/215266.jpg	5	0.00	0.00	2026-03-08 06:20:59.754826-03	2026-02-27 20:07:49.869258-03
1617	Kit Limpeza Suave Chronos Derma (2 produtos)	\N	218212	Geral	Kit Limpeza Suave Chronos Derma (2 produtos)\nRef: 218212	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc6d2f6c5/produto-joia/background/desktop/218212.jpg	5	0.00	0.00	2026-03-08 06:21:20.909684-03	2026-02-27 20:07:49.872255-03
1619	Kit Tododia Jambo Rosa e Flor de Caju Completo (4 produtos)	\N	215271	Geral	Kit Tododia Jambo Rosa e Flor de Caju Completo (4 produtos)\nRef: 215271	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw38e57ff0/produto-joia/background/desktop/215271.jpg	5	0.00	0.00	2026-03-08 06:21:45.637683-03	2026-02-27 20:07:49.875688-03
1620	Kit Lumina Força e Reparação Molecular (4 produtos)	\N	208140	Geral	Kit Lumina Força e Reparação Molecular (4 produtos)\nRef: 208140	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbaa8f7de/produto-joia/background/desktop/208140.jpg	5	0.00	0.00	2026-03-08 06:21:57.252484-03	2026-02-27 20:07:49.877683-03
1622	Kit Spray de Volume e Spray Texturizador para Finalização Lumina (2 produtos)	\N	213220	Geral	Kit Spray de Volume e Spray Texturizador para Finalização Lumina (2 produtos)\nRef: 213220	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwd69d1189/produto-joia/background/desktop/213220.jpg	5	0.00	0.00	2026-03-08 06:22:20.783378-03	2026-02-27 20:07:49.879682-03
1623	Kit Lumina Crespos Completo (5 produtos)	\N	217204	Geral	Kit Lumina Crespos Completo (5 produtos)\nRef: 217204	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbefc7500/produto-joia/background/desktop/217204.jpg	5	0.00	0.00	2026-03-08 06:22:30.437885-03	2026-02-27 20:07:49.881604-03
1625	Kit Condicionador Provitalidade Lumina para Reconstrução de Danos Extremos com Refil (2 produtos)	\N	213210	Cabelos	Kit Condicionador Provitalidade Lumina para Reconstrução de Danos Extremos com Refil (2 produtos)\nRef: 213210	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw29d8dfb5/produto-joia/background/desktop/213210.jpg	5	0.00	0.00	2026-03-08 06:22:57.146127-03	2026-02-27 20:07:49.884776-03
1626	Kit Kaiak Feminino com Sabonete Líquido (2 produtos)	\N	216066	Corpo e Banho	Kit Kaiak Feminino com Sabonete Líquido (2 produtos)\nRef: 216066	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw22fd4d24/produto-joia/background/desktop/216066.jpg	5	0.00	0.00	2026-03-08 06:23:09.937968-03	2026-02-27 20:07:49.885768-03
1627	Kit Essencial Oud Feminino com Hidratante (2 produtos)	\N	216058	Corpo e Banho	Kit Essencial Oud Feminino com Hidratante (2 produtos)\nRef: 216058	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw10b0f215/produto-joia/background/desktop/216058.jpg	5	0.00	0.00	2026-03-08 06:23:19.633492-03	2026-02-27 20:07:49.887923-03
1629	Kit Limpeza Intensiva Chronos Derma (2 produtos)	\N	218213	Geral	Kit Limpeza Intensiva Chronos Derma (2 produtos)\nRef: 218213	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwae652a53/produto-joia/background/desktop/218213.jpg	5	0.00	0.00	2026-03-08 06:23:43.02255-03	2026-02-27 20:07:49.891091-03
1641	Kit Hidratante Acqua Renovador Chronos Derma com Refil (2 produtos)	\N	221664	Corpo e Banho	Kit Hidratante Acqua Renovador Chronos Derma com Refil (2 produtos)\nRef: 221664	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe376a376/produto-joia/background/desktop/221664.jpg	5	0.00	0.00	2026-03-08 07:21:04.144137-03	2026-02-27 20:07:57.879465-03
1643	Kit Dupla Antissinais 80+ Chronos Derma (2 produtos)	\N	219707	Geral	Kit Dupla Antissinais 80+ Chronos Derma (2 produtos)\nRef: 219707	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfef1a812/produto-joia/background/desktop/219707.jpg	5	0.00	0.00	2026-03-08 07:21:33.650036-03	2026-02-27 20:07:57.883708-03
1644	Kit Creme para Barbear e Óleo para Barba Natura Homem (2 produtos)	\N	219718	Corpo e Banho	Kit Creme para Barbear e Óleo para Barba Natura Homem (2 produtos)\nRef: 219718	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw844efc20/produto-joia/background/desktop/219718.jpg	5	0.00	0.00	2026-03-08 07:21:49.85705-03	2026-02-27 20:07:57.884721-03
1646	Kit Química do Humor Masculino (2 unidades)	\N	232507	Homem	Kit Química do Humor Masculino (2 unidades)\nRef: 232507	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0eda99c6/produto-joia/background/desktop/232507.jpg	5	0.00	0.00	2026-03-08 07:22:10.875931-03	2026-02-27 20:07:57.888708-03
1648	Kit Protetor Solar Corporal FPS 50 e Gel Hidratante Pós-sol Natura Solar	\N	231693	Corpo e Banho	Kit Protetor Solar Corporal FPS 50 e Gel Hidratante Pós-sol Natura Solar\nRef: 231693	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwc1da3363/produto-joia/background/desktop/231693.jpg	5	0.00	0.00	2026-03-08 07:22:39.747782-03	2026-02-27 20:07:57.892036-03
1649	Kit Natura Homem Elo (2 unidades)	\N	232518	Homem	Kit Natura Homem Elo (2 unidades)\nRef: 232518	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4b2b0690/produto-joia/background/desktop/232518.jpg	5	0.00	0.00	2026-03-08 07:22:59.895802-03	2026-02-27 20:07:57.894036-03
1651	Kit Protetor Solar Facial Pele Normal a Seca e Protetor Solar Corporal FPS 50 Natura Solar	\N	231705	Geral	Kit Protetor Solar Facial Pele Normal a Seca e Protetor Solar Corporal FPS 50 Natura Solar\nRef: 231705	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwdf59dc2f/produto-joia/background/desktop/231705.jpg	5	0.00	0.00	2026-03-08 07:23:30.454706-03	2026-02-27 20:07:57.897037-03
1652	Kit Protetor Solar Corporal FPS 50 e Gel Hidratante Pós-sol Natura Solar	\N	231687	Corpo e Banho	Kit Protetor Solar Corporal FPS 50 e Gel Hidratante Pós-sol Natura Solar\nRef: 231687	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb9b66715/produto-joia/background/desktop/231687.jpg	5	0.00	0.00	2026-03-08 07:23:43.992945-03	2026-02-27 20:07:57.897964-03
1654	Kit Natura Homem Elo e Natura Homem Nós	\N	232509	Homem	Kit Natura Homem Elo e Natura Homem Nós\nRef: 232509	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8bd55a67/produto-joia/background/desktop/232509.jpg	5	0.00	0.00	2026-03-08 07:24:14.082143-03	2026-02-27 20:07:57.897964-03
1655	Kit Química de Humor Masculino e Química de Humor Feminino	\N	232529	Homem	Kit Química de Humor Masculino e Química de Humor Feminino\nRef: 232529	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0b353a56/produto-joia/background/desktop/232529.jpg	5	0.00	0.00	2026-03-08 07:24:25.779904-03	2026-02-27 20:07:57.897964-03
1657	Kit Sérum Chronos Intensivo Multiclareador com Refil	\N	226588	Geral	Kit Sérum Chronos Intensivo Multiclareador com Refil\nRef: 226588	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe2bdeb88/produto-joia/background/desktop/226588.jpg	5	0.00	0.00	2026-03-08 07:24:49.236057-03	2026-02-27 20:07:57.906179-03
1658	Kit Refil Condicionador para Cabelos Lisos e Ondulados Naturé (2 unidades)	\N	229971	Cabelos	Kit Refil Condicionador para Cabelos Lisos e Ondulados Naturé (2 unidades)\nRef: 229971	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwed5217c9/produto-joia/background/desktop/229971.jpg	5	0.00	0.00	2026-03-08 07:25:03.26523-03	2026-02-27 20:08:06.65497-03
1660	Kit Humor Próprio Feminino 75 ml (2 unidades)	\N	232506	Geral	Kit Humor Próprio Feminino 75 ml (2 unidades)\nRef: 232506	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw2fabeaa4/produto-joia/background/desktop/232506.jpg	5	0.00	0.00	2026-03-08 07:25:28.828571-03	2026-02-27 20:08:06.658594-03
1662	Kit Rotina para Pele Oleosa Chronos Derma (3 produtos)	\N	232528	Geral	Kit Rotina para Pele Oleosa Chronos Derma (3 produtos)\nRef: 232528	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw19c4a72b/produto-joia/background/desktop/232528.jpg	5	0.00	0.00	2026-03-08 07:25:58.441818-03	2026-02-27 20:08:06.663187-03
1663	Kit Química de Humor Masculino e Humor Próprio Feminino	\N	232524	Homem	Kit Química de Humor Masculino e Humor Próprio Feminino\nRef: 232524	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8322f11d/produto-joia/background/desktop/232524.jpg	5	0.00	0.00	2026-03-08 07:26:11.500343-03	2026-02-27 20:08:06.663187-03
1665	Kit Gel Creme Antissinais 45+ Dia com Refil	\N	228436	Corpo e Banho	Kit Gel Creme Antissinais 45+ Dia com Refil\nRef: 228436	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8a88bb48/produto-joia/background/desktop/228436.jpg	5	0.00	0.00	2026-03-08 07:26:35.79219-03	2026-02-27 20:08:06.671506-03
1667	Kit Sabonete Facial Esfoliante e Multicorretor Antissinais Natura Homem (2 produtos)	\N	219744	Corpo e Banho	Kit Sabonete Facial Esfoliante e Multicorretor Antissinais Natura Homem (2 produtos)\nRef: 219744	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw319fd92f/produto-joia/background/desktop/219744.jpg	5	0.00	0.00	2026-03-08 07:27:03.846494-03	2026-02-27 20:08:06.671506-03
1669	Kit Hidratação para as Mãos Ekos Tukumã (2 produtos)	\N	230580	Geral	Kit Hidratação para as Mãos Ekos Tukumã (2 produtos)\nRef: 230580	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw8b70c38f/produto-joia/background/desktop/230580.jpg	5	0.00	0.00	2026-03-08 07:27:37.88292-03	2026-02-27 20:08:06.679791-03
1672	Kit Base Sérum Una com Pincel	\N	239178	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239178	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw35271330/produto-joia/background/desktop/239178.jpg	5	0.00	0.00	2026-03-08 07:27:52.576443-03	2026-02-27 20:08:06.687612-03
1670	Kit Ekos Ryo Vivo e Ekos Ryo Festa	\N	239221	Geral	Kit Ekos Ryo Vivo e Ekos Ryo Festa\nRef: 239221	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6f594287/produto-joia/background/desktop/239221.jpg	5	0.00	0.00	2026-03-08 07:28:25.097472-03	2026-02-27 20:08:06.679791-03
1677	Kit Máscara com Refil Lumina Definição e Hidratação de Cabelos Cacheados	\N	239175	Cabelos	Kit Máscara com Refil Lumina Definição e Hidratação de Cabelos Cacheados\nRef: 239175	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwec80cb4f/produto-joia/background/desktop/239175.jpg	5	0.00	0.00	2026-03-08 07:28:40.934315-03	2026-02-27 20:08:06.688128-03
1674	Kit Máscara com Refil Lumina Brilho e Proteção da Cor	\N	239208	Cabelos	Kit Máscara com Refil Lumina Brilho e Proteção da Cor\nRef: 239208	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6221ad8c/produto-joia/background/desktop/239208.jpg	5	0.00	0.00	2026-03-08 07:29:05.505112-03	2026-02-27 20:08:06.688128-03
1675	Kit Lumina Definição e Nutrição para Crespos Shampoo e Máscara	\N	239177	Cabelos	Kit Lumina Definição e Nutrição para Crespos Shampoo e Máscara\nRef: 239177	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw4e89b25b/produto-joia/background/desktop/239177.jpg	5	0.00	0.00	2026-03-08 07:29:18.387711-03	2026-02-27 20:08:06.688128-03
1681	Kit Condicionador com Refil Lumina Brilho e Proteção da Cor	\N	239183	Cabelos	Kit Condicionador com Refil Lumina Brilho e Proteção da Cor\nRef: 239183	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dweb2fe183/produto-joia/background/desktop/239183.jpg	5	0.00	0.00	2026-03-08 07:29:44.209436-03	2026-02-27 20:08:06.696353-03
1679	Kit Base Sérum Una com Pincel	\N	239202	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239202	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwce148f9c/produto-joia/background/desktop/239202.jpg	5	0.00	0.00	2026-03-08 07:30:13.879479-03	2026-02-27 20:08:06.696353-03
1682	Kit Base Sérum Una com Pincel	\N	239182	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239182	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw23803d35/produto-joia/background/desktop/239182.jpg	5	0.00	0.00	2026-03-08 07:30:53.801352-03	2026-02-27 20:08:14.774516-03
1685	Kit Creme Nutritivo com Refil Tododia Energia Flor de Gengibre e Tangerina	\N	239220	Corpo e Banho	Kit Creme Nutritivo com Refil Tododia Energia Flor de Gengibre e Tangerina\nRef: 239220	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1b2d08b1/produto-joia/background/desktop/239220.jpg	5	0.00	0.00	2026-03-08 07:31:02.821045-03	2026-02-27 20:08:14.778034-03
1683	Kit Creme Antissinais 80+ Dia com Refil	\N	228442	Corpo e Banho	Kit Creme Antissinais 80+ Dia com Refil\nRef: 228442	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa1868302/produto-joia/background/desktop/228442.jpg	5	0.00	0.00	2026-03-08 07:31:13.351622-03	2026-02-27 20:08:14.778034-03
1684	Kit Base Sérum Una com Pincel	\N	239181	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239181	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1ea7f74b/produto-joia/background/desktop/239181.jpg	5	0.00	0.00	2026-03-08 07:31:34.020594-03	2026-02-27 20:08:14.778034-03
1690	Kit Shampoo com Refil Lumina Brilho e Proteção da Cor	\N	239210	Cabelos	Kit Shampoo com Refil Lumina Brilho e Proteção da Cor\nRef: 239210	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfd9da928/produto-joia/background/desktop/239210.jpg	5	0.00	0.00	2026-03-08 07:32:03.265979-03	2026-02-27 20:08:14.786341-03
1688	Kit Base Sérum Una com Pincel	\N	239205	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239205	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw17e82c73/produto-joia/background/desktop/239205.jpg	5	0.00	0.00	2026-03-08 07:32:28.558668-03	2026-02-27 20:08:14.786341-03
1687	Kit Base Sérum Una com Pincel	\N	239201	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239201	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw28150073/produto-joia/background/desktop/239201.jpg	5	0.00	0.00	2026-03-08 07:32:49.008904-03	2026-02-27 20:08:14.786341-03
1691	Kit Condicionador com Refil Lumina Definição e Nutrição para Cabelos Crespos	\N	239218	Cabelos	Kit Condicionador com Refil Lumina Definição e Nutrição para Cabelos Crespos\nRef: 239218	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw3552a771/produto-joia/background/desktop/239218.jpg	5	0.00	0.00	2026-03-08 07:33:07.113926-03	2026-02-27 20:08:14.786341-03
1693	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte	\N	244762	Cabelos	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte\nRef: 244762	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwddc520fd/produto-joia/background/desktop/244762.jpg	5	0.00	0.00	2026-03-08 07:33:46.681006-03	2026-02-27 20:08:14.794781-03
1694	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte	\N	244779	Cabelos	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte\nRef: 244779	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1057cacd/produto-joia/background/desktop/244779.jpg	5	0.00	0.00	2026-03-08 07:33:58.421606-03	2026-02-27 20:08:14.794781-03
1701	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss	\N	244784	Cabelos	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss\nRef: 244784	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwbc9e80e9/produto-joia/background/desktop/244784.jpg	5	0.00	0.00	2026-03-08 07:34:35.365225-03	2026-02-27 20:08:14.8035-03
1697	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss	\N	244736	Cabelos	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss\nRef: 244736	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw92cfe6d6/produto-joia/background/desktop/244736.jpg	5	0.00	0.00	2026-03-08 07:34:50.685287-03	2026-02-27 20:08:14.8035-03
1699	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte	\N	244770	Cabelos	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte\nRef: 244770	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw47415fe9/produto-joia/background/desktop/244770.jpg	5	0.00	0.00	2026-03-08 07:35:15.517484-03	2026-02-27 20:08:14.8035-03
1700	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte	\N	244790	Cabelos	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte\nRef: 244790	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw9bd9ec18/produto-joia/background/desktop/244790.jpg	5	0.00	0.00	2026-03-08 07:35:27.059351-03	2026-02-27 20:08:14.8035-03
1703	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss	\N	244744	Cabelos	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss\nRef: 244744	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw97fcf6b8/produto-joia/background/desktop/244744.jpg	5	0.00	0.00	2026-03-08 07:35:52.755892-03	2026-02-27 20:08:14.811286-03
1704	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte	\N	244789	Cabelos	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte\nRef: 244789	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw94986a4b/produto-joia/background/desktop/244789.jpg	5	0.00	0.00	2026-03-08 07:36:08.790831-03	2026-02-27 20:08:22.802938-03
1705	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss	\N	244751	Cabelos	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss\nRef: 244751	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw58f73340/produto-joia/background/desktop/244751.jpg	5	0.00	0.00	2026-03-08 07:36:50.701963-03	2026-02-27 20:08:22.811287-03
1707	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss	\N	244775	Cabelos	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss\nRef: 244775	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw6bd09c5d/produto-joia/background/desktop/244775.jpg	5	0.00	0.00	2026-03-08 07:37:45.437256-03	2026-02-27 20:08:22.811287-03
1712	Kit Protetor Solar Facial Pele Normal a Seca e Protetor Solar Facial Pele Mista a Oleosa FPS 70 Natura Solar	\N	246096	Geral	Kit Protetor Solar Facial Pele Normal a Seca e Protetor Solar Facial Pele Mista a Oleosa FPS 70 Natura Solar\nRef: 246096	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw81404444/NATBRA-246096_1.jpg	5	0.00	0.00	2026-03-08 07:37:56.017797-03	2026-02-27 20:08:22.819374-03
1710	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss	\N	244765	Cabelos	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss\nRef: 244765	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw26b4ee34/produto-joia/background/desktop/244765.jpg	5	0.00	0.00	2026-03-08 07:38:16.793106-03	2026-02-27 20:08:22.819374-03
1711	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte	\N	244791	Cabelos	Kit Faces Base Checkmatte, Máscara Incolor e Batom Matte\nRef: 244791	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw482a002f/produto-joia/background/desktop/244791.jpg	5	0.00	0.00	2026-03-08 07:38:33.06325-03	2026-02-27 20:08:22.819374-03
1717	Kit Una Artisan e Gloss	\N	244750	Geral	Kit Una Artisan e Gloss\nRef: 244750	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa88dc935/produto-joia/background/desktop/244750.jpg	5	0.00	0.00	2026-03-08 07:39:01.379002-03	2026-02-27 20:08:22.827357-03
1715	Kit Base Sérum Una com Pincel	\N	239275	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239275	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw50b262f1/produto-joia/background/desktop/239275.jpg	5	0.00	0.00	2026-03-08 07:39:51.562396-03	2026-02-27 20:08:22.827357-03
1716	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss	\N	244747	Cabelos	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss\nRef: 244747	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwfbc74511/produto-joia/background/desktop/244747.jpg	5	0.00	0.00	2026-03-08 07:40:20.998344-03	2026-02-27 20:08:22.827357-03
1722	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss	\N	244761	Cabelos	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss\nRef: 244761	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb3ca04e6/produto-joia/background/desktop/244761.jpg	5	0.00	0.00	2026-03-08 07:40:45.104316-03	2026-02-27 20:08:22.835813-03
1720	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss	\N	244748	Cabelos	Kit Faces Base Checkmatte, Máscara de Cílios Tint e Gloss\nRef: 244748	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw0703f27c/produto-joia/background/desktop/244748.jpg	5	0.00	0.00	2026-03-08 07:41:17.31478-03	2026-02-27 20:08:22.835813-03
1723	Kit Base Sérum Una com Pincel	\N	239262	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239262	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw1d56e776/produto-joia/background/desktop/239262.jpg	5	0.00	0.00	2026-03-08 07:41:49.951341-03	2026-02-27 20:08:22.843358-03
1725	Kit Creme Nutritivo Tododia Algodão e Protetor Solar Facial Pele Normal a Seca FPS 50 Natura Solar	\N	239243	Corpo e Banho	Kit Creme Nutritivo Tododia Algodão e Protetor Solar Facial Pele Normal a Seca FPS 50 Natura Solar\nRef: 239243	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwe24785fc/Produtos/NATBRA-239243_1.jpg	5	0.00	0.00	2026-03-08 07:42:00.607355-03	2026-02-27 20:08:22.844305-03
1726	Kit Base Sérum Una com Pincel	\N	239255	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239255	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwb8063717/produto-joia/background/desktop/239255.jpg	5	0.00	0.00	2026-03-08 07:42:28.492863-03	2026-02-27 20:08:22.844305-03
1728	Kit Base Sérum Una com Pincel	\N	239272	Maquiagem	Kit Base Sérum Una com Pincel\nRef: 239272	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dw5a4f9817/produto-joia/background/desktop/239272.jpg	5	0.00	0.00	2026-03-08 07:43:00.10476-03	2026-02-27 20:08:31.192213-03
1729	Kit Ekos Ryo Chuva e Ekos Ryo Vivo	\N	239235	Geral	Kit Ekos Ryo Chuva e Ekos Ryo Vivo\nRef: 239235	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwf207caee/produto-joia/background/desktop/239235.jpg	5	0.00	0.00	2026-03-08 07:43:18.795223-03	2026-02-27 20:08:31.194514-03
1731	Kit Creme Desodorante Hidratante para o Corpo Ekos Maracujá (2 unidades)	\N	252088	Corpo e Banho	Kit Creme Desodorante Hidratante para o Corpo Ekos Maracujá (2 unidades)\nRef: 252088	https://production.na01.natura.com/on/demandware.static/-/Sites-natura-br-storefront-catalog/default/dwa309c572/Produtos/NATBRA-252088_1.jpg	5	0.00	0.00	2026-03-08 07:43:52.01547-03	2026-02-27 20:08:31.201616-03
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
-- Data for Name: inventory_stocktransaction; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_stocktransaction (id, transaction_type, quantity, unit_cost, unit_price, description, created_at, batch_id, product_id, store_id) FROM stdin;
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

SELECT pg_catalog.setval('public.auth_permission_id_seq', 64, true);


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

SELECT pg_catalog.setval('public.django_content_type_id_seq', 16, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 20, true);


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

SELECT pg_catalog.setval('public.inventory_pricehistory_id_seq', 602, true);


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
-- Name: inventory_stocktransaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_stocktransaction_id_seq', 1, false);


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
-- Name: inventory_stocktransaction inventory_stocktransaction_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_stocktransaction
    ADD CONSTRAINT inventory_stocktransaction_pkey PRIMARY KEY (id);


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
-- Name: inventory_stocktransaction_batch_id_f0154012; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_stocktransaction_batch_id_f0154012 ON public.inventory_stocktransaction USING btree (batch_id);


--
-- Name: inventory_stocktransaction_product_id_6432f3fb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_stocktransaction_product_id_6432f3fb ON public.inventory_stocktransaction USING btree (product_id);


--
-- Name: inventory_stocktransaction_store_id_a0327880; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_stocktransaction_store_id_a0327880 ON public.inventory_stocktransaction USING btree (store_id);


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
-- Name: inventory_stocktransaction inventory_stocktrans_batch_id_f0154012_fk_inventory; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_stocktransaction
    ADD CONSTRAINT inventory_stocktrans_batch_id_f0154012_fk_inventory FOREIGN KEY (batch_id) REFERENCES public.inventory_inventorybatch(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: inventory_stocktransaction inventory_stocktrans_product_id_6432f3fb_fk_inventory; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_stocktransaction
    ADD CONSTRAINT inventory_stocktrans_product_id_6432f3fb_fk_inventory FOREIGN KEY (product_id) REFERENCES public.inventory_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: inventory_stocktransaction inventory_stocktrans_store_id_a0327880_fk_inventory; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_stocktransaction
    ADD CONSTRAINT inventory_stocktrans_store_id_a0327880_fk_inventory FOREIGN KEY (store_id) REFERENCES public.inventory_store(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: inventory_store inventory_store_user_id_854ba86a_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_store
    ADD CONSTRAINT inventory_store_user_id_854ba86a_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

