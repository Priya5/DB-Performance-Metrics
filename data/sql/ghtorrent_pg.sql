--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.8
-- Dumped by pg_dump version 9.6.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: commit_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.commit_comments (
    id bigint NOT NULL,
    commit_id bigint NOT NULL,
    user_id bigint NOT NULL,
    body character varying(256),
    line bigint,
    "position" bigint,
    comment_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.commit_comments OWNER TO postgres;

--
-- Name: commit_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.commit_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.commit_comments_id_seq OWNER TO postgres;

--
-- Name: commit_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.commit_comments_id_seq OWNED BY public.commit_comments.id;


--
-- Name: commit_parents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.commit_parents (
    commit_id bigint NOT NULL,
    parent_id bigint NOT NULL
);


ALTER TABLE public.commit_parents OWNER TO postgres;

--
-- Name: commits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.commits (
    id bigint NOT NULL,
    sha character varying(40),
    author_id bigint,
    committer_id bigint,
    project_id bigint,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.commits OWNER TO postgres;

--
-- Name: commits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.commits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.commits_id_seq OWNER TO postgres;

--
-- Name: commits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.commits_id_seq OWNED BY public.commits.id;


--
-- Name: followers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.followers (
    follower_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.followers OWNER TO postgres;

--
-- Name: issue_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issue_comments (
    issue_id bigint NOT NULL,
    user_id bigint NOT NULL,
    comment_id text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.issue_comments OWNER TO postgres;

--
-- Name: issue_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issue_events (
    event_id text NOT NULL,
    issue_id bigint NOT NULL,
    actor_id bigint NOT NULL,
    action character varying(255) NOT NULL,
    action_specific character varying(50),
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.issue_events OWNER TO postgres;

--
-- Name: issue_labels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issue_labels (
    label_id bigint NOT NULL,
    issue_id bigint NOT NULL
);


ALTER TABLE public.issue_labels OWNER TO postgres;

--
-- Name: issues; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issues (
    id bigint NOT NULL,
    repo_id bigint,
    reporter_id bigint,
    assignee_id bigint,
    pull_request boolean NOT NULL,
    pull_request_id bigint,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    issue_id bigint NOT NULL
);


ALTER TABLE public.issues OWNER TO postgres;

--
-- Name: issues_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.issues_id_seq OWNER TO postgres;

--
-- Name: issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.issues_id_seq OWNED BY public.issues.id;


--
-- Name: organization_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_members (
    org_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.organization_members OWNER TO postgres;

--
-- Name: project_commits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_commits (
    project_id bigint DEFAULT '0'::bigint NOT NULL,
    commit_id bigint DEFAULT '0'::bigint NOT NULL
);


ALTER TABLE public.project_commits OWNER TO postgres;

--
-- Name: project_languages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_languages (
    project_id bigint NOT NULL,
    language character varying(255),
    bytes bigint,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.project_languages OWNER TO postgres;

--
-- Name: project_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_members (
    repo_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    ext_ref_id character varying(24) DEFAULT '0'::character varying NOT NULL
);


ALTER TABLE public.project_members OWNER TO postgres;

--
-- Name: project_topics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_topics (
    project_id bigint NOT NULL,
    topic_name character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.project_topics OWNER TO postgres;

--
-- Name: projects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projects (
    id bigint NOT NULL,
    url character varying(255),
    owner_id bigint,
    name character varying(255) NOT NULL,
    description character varying(255),
    language character varying(255),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    forked_from bigint,
    deleted boolean DEFAULT false NOT NULL,
    updated_at timestamp without time zone DEFAULT '1970-01-01 05:30:01'::timestamp without time zone NOT NULL
);


ALTER TABLE public.projects OWNER TO postgres;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projects_id_seq OWNER TO postgres;

--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: pull_request_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pull_request_comments (
    pull_request_id bigint NOT NULL,
    user_id bigint NOT NULL,
    comment_id text NOT NULL,
    "position" bigint,
    body character varying(256),
    commit_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.pull_request_comments OWNER TO postgres;

--
-- Name: pull_request_commits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pull_request_commits (
    pull_request_id bigint NOT NULL,
    commit_id bigint NOT NULL
);


ALTER TABLE public.pull_request_commits OWNER TO postgres;

--
-- Name: pull_request_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pull_request_history (
    id bigint NOT NULL,
    pull_request_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    action character varying(255) NOT NULL,
    actor_id bigint
);


ALTER TABLE public.pull_request_history OWNER TO postgres;

--
-- Name: pull_request_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pull_request_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pull_request_history_id_seq OWNER TO postgres;

--
-- Name: pull_request_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pull_request_history_id_seq OWNED BY public.pull_request_history.id;


--
-- Name: pull_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pull_requests (
    id bigint NOT NULL,
    head_repo_id bigint,
    base_repo_id bigint NOT NULL,
    head_commit_id bigint,
    base_commit_id bigint NOT NULL,
    pullreq_id bigint NOT NULL,
    intra_branch boolean NOT NULL
);


ALTER TABLE public.pull_requests OWNER TO postgres;

--
-- Name: pull_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pull_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pull_requests_id_seq OWNER TO postgres;

--
-- Name: pull_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pull_requests_id_seq OWNED BY public.pull_requests.id;


--
-- Name: repo_labels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.repo_labels (
    id bigint NOT NULL,
    repo_id bigint,
    name character varying(24) NOT NULL
);


ALTER TABLE public.repo_labels OWNER TO postgres;

--
-- Name: repo_labels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.repo_labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.repo_labels_id_seq OWNER TO postgres;

--
-- Name: repo_labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.repo_labels_id_seq OWNED BY public.repo_labels.id;


--
-- Name: repo_milestones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.repo_milestones (
    id bigint NOT NULL,
    repo_id bigint,
    name character varying(24) NOT NULL
);


ALTER TABLE public.repo_milestones OWNER TO postgres;

--
-- Name: repo_milestones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.repo_milestones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.repo_milestones_id_seq OWNER TO postgres;

--
-- Name: repo_milestones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.repo_milestones_id_seq OWNED BY public.repo_milestones.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    login character varying(255) NOT NULL,
    company character varying(255),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    type character varying(255) DEFAULT 'USR'::character varying NOT NULL,
    fake boolean DEFAULT false NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    long numeric(11,8),
    lat numeric(10,8),
    country_code character(3),
    state character varying(255),
    city character varying(255),
    location character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: watchers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.watchers (
    repo_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.watchers OWNER TO postgres;

--
-- Name: commit_comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commit_comments ALTER COLUMN id SET DEFAULT nextval('public.commit_comments_id_seq'::regclass);


--
-- Name: commits id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commits ALTER COLUMN id SET DEFAULT nextval('public.commits_id_seq'::regclass);


--
-- Name: issues id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issues ALTER COLUMN id SET DEFAULT nextval('public.issues_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: pull_request_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_request_history ALTER COLUMN id SET DEFAULT nextval('public.pull_request_history_id_seq'::regclass);


--
-- Name: pull_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_requests ALTER COLUMN id SET DEFAULT nextval('public.pull_requests_id_seq'::regclass);


--
-- Name: repo_labels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repo_labels ALTER COLUMN id SET DEFAULT nextval('public.repo_labels_id_seq'::regclass);


--
-- Name: repo_milestones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repo_milestones ALTER COLUMN id SET DEFAULT nextval('public.repo_milestones_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: commit_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.commit_comments (id, commit_id, user_id, body, line, "position", comment_id, created_at) FROM stdin;
\.


--
-- Name: commit_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.commit_comments_id_seq', 1, true);


--
-- Data for Name: commit_parents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.commit_parents (commit_id, parent_id) FROM stdin;
\.


--
-- Data for Name: commits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.commits (id, sha, author_id, committer_id, project_id, created_at) FROM stdin;
\.


--
-- Name: commits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.commits_id_seq', 1, true);


--
-- Data for Name: followers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.followers (follower_id, user_id, created_at) FROM stdin;
\.


--
-- Data for Name: issue_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issue_comments (issue_id, user_id, comment_id, created_at) FROM stdin;
\.


--
-- Data for Name: issue_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issue_events (event_id, issue_id, actor_id, action, action_specific, created_at) FROM stdin;
\.


--
-- Data for Name: issue_labels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issue_labels (label_id, issue_id) FROM stdin;
\.


--
-- Data for Name: issues; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issues (id, repo_id, reporter_id, assignee_id, pull_request, pull_request_id, created_at, issue_id) FROM stdin;
\.


--
-- Name: issues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.issues_id_seq', 1, true);


--
-- Data for Name: organization_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_members (org_id, user_id, created_at) FROM stdin;
\.


--
-- Data for Name: project_commits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_commits (project_id, commit_id) FROM stdin;
\.


--
-- Data for Name: project_languages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_languages (project_id, language, bytes, created_at) FROM stdin;
\.


--
-- Data for Name: project_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_members (repo_id, user_id, created_at, ext_ref_id) FROM stdin;
\.


--
-- Data for Name: project_topics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_topics (project_id, topic_name, created_at, deleted) FROM stdin;
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.projects (id, url, owner_id, name, description, language, created_at, forked_from, deleted, updated_at) FROM stdin;
\.


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.projects_id_seq', 1, true);


--
-- Data for Name: pull_request_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pull_request_comments (pull_request_id, user_id, comment_id, "position", body, commit_id, created_at) FROM stdin;
\.


--
-- Data for Name: pull_request_commits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pull_request_commits (pull_request_id, commit_id) FROM stdin;
\.


--
-- Data for Name: pull_request_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pull_request_history (id, pull_request_id, created_at, action, actor_id) FROM stdin;
\.


--
-- Name: pull_request_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pull_request_history_id_seq', 1, true);


--
-- Data for Name: pull_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pull_requests (id, head_repo_id, base_repo_id, head_commit_id, base_commit_id, pullreq_id, intra_branch) FROM stdin;
\.


--
-- Name: pull_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pull_requests_id_seq', 1, true);


--
-- Data for Name: repo_labels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.repo_labels (id, repo_id, name) FROM stdin;
\.


--
-- Name: repo_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.repo_labels_id_seq', 1, true);


--
-- Data for Name: repo_milestones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.repo_milestones (id, repo_id, name) FROM stdin;
\.


--
-- Name: repo_milestones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.repo_milestones_id_seq', 1, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, login, company, created_at, type, fake, deleted, long, lat, country_code, state, city, location) FROM stdin;
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Data for Name: watchers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.watchers (repo_id, user_id, created_at) FROM stdin;
\.


--
-- Name: commits idx_186827_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commits
    ADD CONSTRAINT idx_186827_primary PRIMARY KEY (id);


--
-- Name: commit_comments idx_186834_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commit_comments
    ADD CONSTRAINT idx_186834_primary PRIMARY KEY (id);


--
-- Name: followers idx_186842_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.followers
    ADD CONSTRAINT idx_186842_primary PRIMARY KEY (follower_id, user_id);


--
-- Name: issues idx_186848_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT idx_186848_primary PRIMARY KEY (id);


--
-- Name: issue_labels idx_186867_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issue_labels
    ADD CONSTRAINT idx_186867_primary PRIMARY KEY (issue_id, label_id);


--
-- Name: organization_members idx_186870_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_members
    ADD CONSTRAINT idx_186870_primary PRIMARY KEY (org_id, user_id);


--
-- Name: projects idx_186876_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT idx_186876_primary PRIMARY KEY (id);


--
-- Name: project_members idx_186895_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT idx_186895_primary PRIMARY KEY (repo_id, user_id);


--
-- Name: project_topics idx_186900_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_topics
    ADD CONSTRAINT idx_186900_primary PRIMARY KEY (project_id, topic_name);


--
-- Name: pull_requests idx_186907_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_requests
    ADD CONSTRAINT idx_186907_primary PRIMARY KEY (id);


--
-- Name: pull_request_commits idx_186918_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_request_commits
    ADD CONSTRAINT idx_186918_primary PRIMARY KEY (pull_request_id, commit_id);


--
-- Name: pull_request_history idx_186923_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_request_history
    ADD CONSTRAINT idx_186923_primary PRIMARY KEY (id);


--
-- Name: repo_labels idx_186930_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repo_labels
    ADD CONSTRAINT idx_186930_primary PRIMARY KEY (id);


--
-- Name: repo_milestones idx_186936_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repo_milestones
    ADD CONSTRAINT idx_186936_primary PRIMARY KEY (id);


--
-- Name: users idx_186946_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT idx_186946_primary PRIMARY KEY (id);


--
-- Name: watchers idx_186957_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watchers
    ADD CONSTRAINT idx_186957_primary PRIMARY KEY (repo_id, user_id);


--
-- Name: idx_186827_commits_ibfk_1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186827_commits_ibfk_1 ON public.commits USING btree (author_id);


--
-- Name: idx_186827_commits_ibfk_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186827_commits_ibfk_2 ON public.commits USING btree (committer_id);


--
-- Name: idx_186827_commits_ibfk_3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186827_commits_ibfk_3 ON public.commits USING btree (project_id);


--
-- Name: idx_186827_sha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_186827_sha ON public.commits USING btree (sha);


--
-- Name: idx_186834_comment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_186834_comment_id ON public.commit_comments USING btree (comment_id);


--
-- Name: idx_186834_commit_comments_ibfk_1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186834_commit_comments_ibfk_1 ON public.commit_comments USING btree (commit_id);


--
-- Name: idx_186834_commit_comments_ibfk_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186834_commit_comments_ibfk_2 ON public.commit_comments USING btree (user_id);


--
-- Name: idx_186839_commit_parents_ibfk_1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186839_commit_parents_ibfk_1 ON public.commit_parents USING btree (commit_id);


--
-- Name: idx_186839_commit_parents_ibfk_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186839_commit_parents_ibfk_2 ON public.commit_parents USING btree (parent_id);


--
-- Name: idx_186842_follower_fk2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186842_follower_fk2 ON public.followers USING btree (user_id);


--
-- Name: idx_186842_follower_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186842_follower_id ON public.followers USING btree (follower_id);


--
-- Name: idx_186848_issues_ibfk_1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186848_issues_ibfk_1 ON public.issues USING btree (repo_id);


--
-- Name: idx_186848_issues_ibfk_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186848_issues_ibfk_2 ON public.issues USING btree (reporter_id);


--
-- Name: idx_186848_issues_ibfk_3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186848_issues_ibfk_3 ON public.issues USING btree (assignee_id);


--
-- Name: idx_186848_issues_ibfk_4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186848_issues_ibfk_4 ON public.issues USING btree (pull_request_id);


--
-- Name: idx_186853_issue_comments_ibfk_1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186853_issue_comments_ibfk_1 ON public.issue_comments USING btree (issue_id);


--
-- Name: idx_186853_issue_comments_ibfk_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186853_issue_comments_ibfk_2 ON public.issue_comments USING btree (user_id);


--
-- Name: idx_186860_issue_events_ibfk_1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186860_issue_events_ibfk_1 ON public.issue_events USING btree (issue_id);


--
-- Name: idx_186860_issue_events_ibfk_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186860_issue_events_ibfk_2 ON public.issue_events USING btree (actor_id);


--
-- Name: idx_186867_issue_labels_ibfk_1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186867_issue_labels_ibfk_1 ON public.issue_labels USING btree (label_id);


--
-- Name: idx_186870_organization_members_ibfk_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186870_organization_members_ibfk_2 ON public.organization_members USING btree (user_id);


--
-- Name: idx_186876_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186876_name ON public.projects USING btree (name);


--
-- Name: idx_186876_projects_ibfk_1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186876_projects_ibfk_1 ON public.projects USING btree (owner_id);


--
-- Name: idx_186876_projects_ibfk_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186876_projects_ibfk_2 ON public.projects USING btree (forked_from);


--
-- Name: idx_186886_commit_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186886_commit_id ON public.project_commits USING btree (commit_id);


--
-- Name: idx_186886_project_commits_ibfk_1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186886_project_commits_ibfk_1 ON public.project_commits USING btree (project_id);


--
-- Name: idx_186891_project_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186891_project_id ON public.project_languages USING btree (project_id);


--
-- Name: idx_186895_project_members_ibfk_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186895_project_members_ibfk_2 ON public.project_members USING btree (user_id);


--
-- Name: idx_186907_pull_requests_ibfk_1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186907_pull_requests_ibfk_1 ON public.pull_requests USING btree (head_repo_id);


--
-- Name: idx_186907_pull_requests_ibfk_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186907_pull_requests_ibfk_2 ON public.pull_requests USING btree (base_repo_id);


--
-- Name: idx_186907_pull_requests_ibfk_3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186907_pull_requests_ibfk_3 ON public.pull_requests USING btree (head_commit_id);


--
-- Name: idx_186907_pull_requests_ibfk_4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186907_pull_requests_ibfk_4 ON public.pull_requests USING btree (base_commit_id);


--
-- Name: idx_186907_pullreq_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_186907_pullreq_id ON public.pull_requests USING btree (pullreq_id, base_repo_id);


--
-- Name: idx_186911_pull_request_comments_ibfk_1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186911_pull_request_comments_ibfk_1 ON public.pull_request_comments USING btree (pull_request_id);


--
-- Name: idx_186911_pull_request_comments_ibfk_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186911_pull_request_comments_ibfk_2 ON public.pull_request_comments USING btree (user_id);


--
-- Name: idx_186911_pull_request_comments_ibfk_3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186911_pull_request_comments_ibfk_3 ON public.pull_request_comments USING btree (commit_id);


--
-- Name: idx_186918_pull_request_commits_ibfk_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186918_pull_request_commits_ibfk_2 ON public.pull_request_commits USING btree (commit_id);


--
-- Name: idx_186923_pull_request_history_ibfk_1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186923_pull_request_history_ibfk_1 ON public.pull_request_history USING btree (pull_request_id);


--
-- Name: idx_186923_pull_request_history_ibfk_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186923_pull_request_history_ibfk_2 ON public.pull_request_history USING btree (actor_id);


--
-- Name: idx_186930_repo_labels_ibfk_1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186930_repo_labels_ibfk_1 ON public.repo_labels USING btree (repo_id);


--
-- Name: idx_186936_repo_milestones_ibfk_1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186936_repo_milestones_ibfk_1 ON public.repo_milestones USING btree (repo_id);


--
-- Name: idx_186946_login; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_186946_login ON public.users USING btree (login);


--
-- Name: idx_186957_watchers_ibfk_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_186957_watchers_ibfk_2 ON public.watchers USING btree (user_id);


--
-- Name: commit_comments commit_comments_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commit_comments
    ADD CONSTRAINT commit_comments_ibfk_1 FOREIGN KEY (commit_id) REFERENCES public.commits(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: commit_comments commit_comments_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commit_comments
    ADD CONSTRAINT commit_comments_ibfk_2 FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: commit_parents commit_parents_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commit_parents
    ADD CONSTRAINT commit_parents_ibfk_1 FOREIGN KEY (commit_id) REFERENCES public.commits(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: commit_parents commit_parents_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commit_parents
    ADD CONSTRAINT commit_parents_ibfk_2 FOREIGN KEY (parent_id) REFERENCES public.commits(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: commits commits_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commits
    ADD CONSTRAINT commits_ibfk_1 FOREIGN KEY (author_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: commits commits_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commits
    ADD CONSTRAINT commits_ibfk_2 FOREIGN KEY (committer_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: commits commits_ibfk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commits
    ADD CONSTRAINT commits_ibfk_3 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: followers follower_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.followers
    ADD CONSTRAINT follower_fk1 FOREIGN KEY (follower_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: followers follower_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.followers
    ADD CONSTRAINT follower_fk2 FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issue_comments issue_comments_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issue_comments
    ADD CONSTRAINT issue_comments_ibfk_1 FOREIGN KEY (issue_id) REFERENCES public.issues(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issue_comments issue_comments_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issue_comments
    ADD CONSTRAINT issue_comments_ibfk_2 FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issue_events issue_events_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issue_events
    ADD CONSTRAINT issue_events_ibfk_1 FOREIGN KEY (issue_id) REFERENCES public.issues(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issue_events issue_events_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issue_events
    ADD CONSTRAINT issue_events_ibfk_2 FOREIGN KEY (actor_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issue_labels issue_labels_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issue_labels
    ADD CONSTRAINT issue_labels_ibfk_1 FOREIGN KEY (label_id) REFERENCES public.repo_labels(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issue_labels issue_labels_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issue_labels
    ADD CONSTRAINT issue_labels_ibfk_2 FOREIGN KEY (issue_id) REFERENCES public.issues(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issues issues_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_ibfk_1 FOREIGN KEY (repo_id) REFERENCES public.projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issues issues_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_ibfk_2 FOREIGN KEY (reporter_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issues issues_ibfk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_ibfk_3 FOREIGN KEY (assignee_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issues issues_ibfk_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_ibfk_4 FOREIGN KEY (pull_request_id) REFERENCES public.pull_requests(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: organization_members organization_members_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_members
    ADD CONSTRAINT organization_members_ibfk_1 FOREIGN KEY (org_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: organization_members organization_members_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_members
    ADD CONSTRAINT organization_members_ibfk_2 FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: project_commits project_commits_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_commits
    ADD CONSTRAINT project_commits_ibfk_1 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: project_commits project_commits_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_commits
    ADD CONSTRAINT project_commits_ibfk_2 FOREIGN KEY (commit_id) REFERENCES public.commits(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: project_languages project_languages_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_languages
    ADD CONSTRAINT project_languages_ibfk_1 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: project_members project_members_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_ibfk_1 FOREIGN KEY (repo_id) REFERENCES public.projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: project_members project_members_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_ibfk_2 FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: project_topics project_topics_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_topics
    ADD CONSTRAINT project_topics_ibfk_1 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: projects projects_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_ibfk_1 FOREIGN KEY (owner_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: projects projects_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_ibfk_2 FOREIGN KEY (forked_from) REFERENCES public.projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_request_comments pull_request_comments_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_request_comments
    ADD CONSTRAINT pull_request_comments_ibfk_1 FOREIGN KEY (pull_request_id) REFERENCES public.pull_requests(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_request_comments pull_request_comments_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_request_comments
    ADD CONSTRAINT pull_request_comments_ibfk_2 FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_request_comments pull_request_comments_ibfk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_request_comments
    ADD CONSTRAINT pull_request_comments_ibfk_3 FOREIGN KEY (commit_id) REFERENCES public.commits(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_request_commits pull_request_commits_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_request_commits
    ADD CONSTRAINT pull_request_commits_ibfk_1 FOREIGN KEY (pull_request_id) REFERENCES public.pull_requests(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_request_commits pull_request_commits_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_request_commits
    ADD CONSTRAINT pull_request_commits_ibfk_2 FOREIGN KEY (commit_id) REFERENCES public.commits(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_request_history pull_request_history_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_request_history
    ADD CONSTRAINT pull_request_history_ibfk_1 FOREIGN KEY (pull_request_id) REFERENCES public.pull_requests(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_request_history pull_request_history_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_request_history
    ADD CONSTRAINT pull_request_history_ibfk_2 FOREIGN KEY (actor_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_requests pull_requests_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_requests
    ADD CONSTRAINT pull_requests_ibfk_1 FOREIGN KEY (head_repo_id) REFERENCES public.projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_requests pull_requests_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_requests
    ADD CONSTRAINT pull_requests_ibfk_2 FOREIGN KEY (base_repo_id) REFERENCES public.projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_requests pull_requests_ibfk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_requests
    ADD CONSTRAINT pull_requests_ibfk_3 FOREIGN KEY (head_commit_id) REFERENCES public.commits(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_requests pull_requests_ibfk_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pull_requests
    ADD CONSTRAINT pull_requests_ibfk_4 FOREIGN KEY (base_commit_id) REFERENCES public.commits(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: repo_labels repo_labels_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repo_labels
    ADD CONSTRAINT repo_labels_ibfk_1 FOREIGN KEY (repo_id) REFERENCES public.projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: repo_milestones repo_milestones_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repo_milestones
    ADD CONSTRAINT repo_milestones_ibfk_1 FOREIGN KEY (repo_id) REFERENCES public.projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: watchers watchers_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watchers
    ADD CONSTRAINT watchers_ibfk_1 FOREIGN KEY (repo_id) REFERENCES public.projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: watchers watchers_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watchers
    ADD CONSTRAINT watchers_ibfk_2 FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

