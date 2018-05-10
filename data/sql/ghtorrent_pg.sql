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
-- Name: ghtorrent; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ghtorrent;


ALTER SCHEMA ghtorrent OWNER TO postgres;

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
-- Name: commit_comments; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE commit_comments (
    id bigint NOT NULL,
    commit_id bigint NOT NULL,
    user_id bigint NOT NULL,
    body character varying(256),
    line bigint,
    "position" bigint,
    comment_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE commit_comments OWNER TO postgres;

--
-- Name: commit_comments_id_seq; Type: SEQUENCE; Schema: ghtorrent; Owner: postgres
--

CREATE SEQUENCE commit_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE commit_comments_id_seq OWNER TO postgres;

--
-- Name: commit_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: ghtorrent; Owner: postgres
--

ALTER SEQUENCE commit_comments_id_seq OWNED BY commit_comments.id;


--
-- Name: commit_parents; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE commit_parents (
    commit_id bigint NOT NULL,
    parent_id bigint NOT NULL
);


ALTER TABLE commit_parents OWNER TO postgres;

--
-- Name: commits; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE commits (
    id bigint NOT NULL,
    sha character varying(40),
    author_id bigint,
    committer_id bigint,
    project_id bigint,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE commits OWNER TO postgres;

--
-- Name: commits_id_seq; Type: SEQUENCE; Schema: ghtorrent; Owner: postgres
--

CREATE SEQUENCE commits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE commits_id_seq OWNER TO postgres;

--
-- Name: commits_id_seq; Type: SEQUENCE OWNED BY; Schema: ghtorrent; Owner: postgres
--

ALTER SEQUENCE commits_id_seq OWNED BY commits.id;


--
-- Name: followers; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE followers (
    follower_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE followers OWNER TO postgres;

--
-- Name: issue_comments; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE issue_comments (
    issue_id bigint NOT NULL,
    user_id bigint NOT NULL,
    comment_id text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE issue_comments OWNER TO postgres;

--
-- Name: issue_events; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE issue_events (
    event_id text NOT NULL,
    issue_id bigint NOT NULL,
    actor_id bigint NOT NULL,
    action character varying(255) NOT NULL,
    action_specific character varying(50),
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE issue_events OWNER TO postgres;

--
-- Name: issue_labels; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE issue_labels (
    label_id bigint NOT NULL,
    issue_id bigint NOT NULL
);


ALTER TABLE issue_labels OWNER TO postgres;

--
-- Name: issues; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE issues (
    id bigint NOT NULL,
    repo_id bigint,
    reporter_id bigint,
    assignee_id bigint,
    pull_request boolean NOT NULL,
    pull_request_id bigint,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    issue_id bigint NOT NULL
);


ALTER TABLE issues OWNER TO postgres;

--
-- Name: issues_id_seq; Type: SEQUENCE; Schema: ghtorrent; Owner: postgres
--

CREATE SEQUENCE issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE issues_id_seq OWNER TO postgres;

--
-- Name: issues_id_seq; Type: SEQUENCE OWNED BY; Schema: ghtorrent; Owner: postgres
--

ALTER SEQUENCE issues_id_seq OWNED BY issues.id;


--
-- Name: organization_members; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE organization_members (
    org_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE organization_members OWNER TO postgres;

--
-- Name: project_commits; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE project_commits (
    project_id bigint DEFAULT '0'::bigint NOT NULL,
    commit_id bigint DEFAULT '0'::bigint NOT NULL
);


ALTER TABLE project_commits OWNER TO postgres;

--
-- Name: project_languages; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE project_languages (
    project_id bigint NOT NULL,
    language character varying(255),
    bytes bigint,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE project_languages OWNER TO postgres;

--
-- Name: project_members; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE project_members (
    repo_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    ext_ref_id character varying(24) DEFAULT '0'::character varying NOT NULL
);


ALTER TABLE project_members OWNER TO postgres;

--
-- Name: project_topics; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE project_topics (
    project_id bigint NOT NULL,
    topic_name character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE project_topics OWNER TO postgres;

--
-- Name: projects; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE projects (
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


ALTER TABLE projects OWNER TO postgres;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: ghtorrent; Owner: postgres
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE projects_id_seq OWNER TO postgres;

--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: ghtorrent; Owner: postgres
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


--
-- Name: pull_request_comments; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE pull_request_comments (
    pull_request_id bigint NOT NULL,
    user_id bigint NOT NULL,
    comment_id text NOT NULL,
    "position" bigint,
    body character varying(256),
    commit_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE pull_request_comments OWNER TO postgres;

--
-- Name: pull_request_commits; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE pull_request_commits (
    pull_request_id bigint NOT NULL,
    commit_id bigint NOT NULL
);


ALTER TABLE pull_request_commits OWNER TO postgres;

--
-- Name: pull_request_history; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE pull_request_history (
    id bigint NOT NULL,
    pull_request_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    action character varying(255) NOT NULL,
    actor_id bigint
);


ALTER TABLE pull_request_history OWNER TO postgres;

--
-- Name: pull_request_history_id_seq; Type: SEQUENCE; Schema: ghtorrent; Owner: postgres
--

CREATE SEQUENCE pull_request_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pull_request_history_id_seq OWNER TO postgres;

--
-- Name: pull_request_history_id_seq; Type: SEQUENCE OWNED BY; Schema: ghtorrent; Owner: postgres
--

ALTER SEQUENCE pull_request_history_id_seq OWNED BY pull_request_history.id;


--
-- Name: pull_requests; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE pull_requests (
    id bigint NOT NULL,
    head_repo_id bigint,
    base_repo_id bigint NOT NULL,
    head_commit_id bigint,
    base_commit_id bigint NOT NULL,
    pullreq_id bigint NOT NULL,
    intra_branch boolean NOT NULL
);


ALTER TABLE pull_requests OWNER TO postgres;

--
-- Name: pull_requests_id_seq; Type: SEQUENCE; Schema: ghtorrent; Owner: postgres
--

CREATE SEQUENCE pull_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pull_requests_id_seq OWNER TO postgres;

--
-- Name: pull_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: ghtorrent; Owner: postgres
--

ALTER SEQUENCE pull_requests_id_seq OWNED BY pull_requests.id;


--
-- Name: repo_labels; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE repo_labels (
    id bigint NOT NULL,
    repo_id bigint,
    name character varying(24) NOT NULL
);


ALTER TABLE repo_labels OWNER TO postgres;

--
-- Name: repo_labels_id_seq; Type: SEQUENCE; Schema: ghtorrent; Owner: postgres
--

CREATE SEQUENCE repo_labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE repo_labels_id_seq OWNER TO postgres;

--
-- Name: repo_labels_id_seq; Type: SEQUENCE OWNED BY; Schema: ghtorrent; Owner: postgres
--

ALTER SEQUENCE repo_labels_id_seq OWNED BY repo_labels.id;


--
-- Name: repo_milestones; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE repo_milestones (
    id bigint NOT NULL,
    repo_id bigint,
    name character varying(24) NOT NULL
);


ALTER TABLE repo_milestones OWNER TO postgres;

--
-- Name: repo_milestones_id_seq; Type: SEQUENCE; Schema: ghtorrent; Owner: postgres
--

CREATE SEQUENCE repo_milestones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE repo_milestones_id_seq OWNER TO postgres;

--
-- Name: repo_milestones_id_seq; Type: SEQUENCE OWNED BY; Schema: ghtorrent; Owner: postgres
--

ALTER SEQUENCE repo_milestones_id_seq OWNED BY repo_milestones.id;


--
-- Name: users; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE users (
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


ALTER TABLE users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: ghtorrent; Owner: postgres
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: ghtorrent; Owner: postgres
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: watchers; Type: TABLE; Schema: ghtorrent; Owner: postgres
--

CREATE TABLE watchers (
    repo_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE watchers OWNER TO postgres;

--
-- Name: commit_comments id; Type: DEFAULT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY commit_comments ALTER COLUMN id SET DEFAULT nextval('commit_comments_id_seq'::regclass);


--
-- Name: commits id; Type: DEFAULT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY commits ALTER COLUMN id SET DEFAULT nextval('commits_id_seq'::regclass);


--
-- Name: issues id; Type: DEFAULT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY issues ALTER COLUMN id SET DEFAULT nextval('issues_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: pull_request_history id; Type: DEFAULT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY pull_request_history ALTER COLUMN id SET DEFAULT nextval('pull_request_history_id_seq'::regclass);


--
-- Name: pull_requests id; Type: DEFAULT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY pull_requests ALTER COLUMN id SET DEFAULT nextval('pull_requests_id_seq'::regclass);


--
-- Name: repo_labels id; Type: DEFAULT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY repo_labels ALTER COLUMN id SET DEFAULT nextval('repo_labels_id_seq'::regclass);


--
-- Name: repo_milestones id; Type: DEFAULT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY repo_milestones ALTER COLUMN id SET DEFAULT nextval('repo_milestones_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: commit_comments; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY commit_comments (id, commit_id, user_id, body, line, "position", comment_id, created_at) FROM stdin;
\.


--
-- Name: commit_comments_id_seq; Type: SEQUENCE SET; Schema: ghtorrent; Owner: postgres
--

SELECT pg_catalog.setval('commit_comments_id_seq', 1, false);


--
-- Data for Name: commit_parents; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY commit_parents (commit_id, parent_id) FROM stdin;
\.


--
-- Data for Name: commits; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY commits (id, sha, author_id, committer_id, project_id, created_at) FROM stdin;
\.


--
-- Name: commits_id_seq; Type: SEQUENCE SET; Schema: ghtorrent; Owner: postgres
--

SELECT pg_catalog.setval('commits_id_seq', 1, false);


--
-- Data for Name: followers; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY followers (follower_id, user_id, created_at) FROM stdin;
\.


--
-- Data for Name: issue_comments; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY issue_comments (issue_id, user_id, comment_id, created_at) FROM stdin;
\.


--
-- Data for Name: issue_events; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY issue_events (event_id, issue_id, actor_id, action, action_specific, created_at) FROM stdin;
\.


--
-- Data for Name: issue_labels; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY issue_labels (label_id, issue_id) FROM stdin;
\.


--
-- Data for Name: issues; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY issues (id, repo_id, reporter_id, assignee_id, pull_request, pull_request_id, created_at, issue_id) FROM stdin;
\.


--
-- Name: issues_id_seq; Type: SEQUENCE SET; Schema: ghtorrent; Owner: postgres
--

SELECT pg_catalog.setval('issues_id_seq', 1, false);


--
-- Data for Name: organization_members; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY organization_members (org_id, user_id, created_at) FROM stdin;
\.


--
-- Data for Name: project_commits; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY project_commits (project_id, commit_id) FROM stdin;
\.


--
-- Data for Name: project_languages; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY project_languages (project_id, language, bytes, created_at) FROM stdin;
\.


--
-- Data for Name: project_members; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY project_members (repo_id, user_id, created_at, ext_ref_id) FROM stdin;
\.


--
-- Data for Name: project_topics; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY project_topics (project_id, topic_name, created_at, deleted) FROM stdin;
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY projects (id, url, owner_id, name, description, language, created_at, forked_from, deleted, updated_at) FROM stdin;
\.


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: ghtorrent; Owner: postgres
--

SELECT pg_catalog.setval('projects_id_seq', 1, false);


--
-- Data for Name: pull_request_comments; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY pull_request_comments (pull_request_id, user_id, comment_id, "position", body, commit_id, created_at) FROM stdin;
\.


--
-- Data for Name: pull_request_commits; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY pull_request_commits (pull_request_id, commit_id) FROM stdin;
\.


--
-- Data for Name: pull_request_history; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY pull_request_history (id, pull_request_id, created_at, action, actor_id) FROM stdin;
\.


--
-- Name: pull_request_history_id_seq; Type: SEQUENCE SET; Schema: ghtorrent; Owner: postgres
--

SELECT pg_catalog.setval('pull_request_history_id_seq', 1, false);


--
-- Data for Name: pull_requests; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY pull_requests (id, head_repo_id, base_repo_id, head_commit_id, base_commit_id, pullreq_id, intra_branch) FROM stdin;
\.


--
-- Name: pull_requests_id_seq; Type: SEQUENCE SET; Schema: ghtorrent; Owner: postgres
--

SELECT pg_catalog.setval('pull_requests_id_seq', 1, false);


--
-- Data for Name: repo_labels; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY repo_labels (id, repo_id, name) FROM stdin;
\.


--
-- Name: repo_labels_id_seq; Type: SEQUENCE SET; Schema: ghtorrent; Owner: postgres
--

SELECT pg_catalog.setval('repo_labels_id_seq', 1, false);


--
-- Data for Name: repo_milestones; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY repo_milestones (id, repo_id, name) FROM stdin;
\.


--
-- Name: repo_milestones_id_seq; Type: SEQUENCE SET; Schema: ghtorrent; Owner: postgres
--

SELECT pg_catalog.setval('repo_milestones_id_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY users (id, login, company, created_at, type, fake, deleted, long, lat, country_code, state, city, location) FROM stdin;
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: ghtorrent; Owner: postgres
--

SELECT pg_catalog.setval('users_id_seq', 1, false);


--
-- Data for Name: watchers; Type: TABLE DATA; Schema: ghtorrent; Owner: postgres
--

COPY watchers (repo_id, user_id, created_at) FROM stdin;
\.


--
-- Name: commits idx_50850_primary; Type: CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY commits
    ADD CONSTRAINT idx_50850_primary PRIMARY KEY (id);


--
-- Name: commit_comments idx_50857_primary; Type: CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY commit_comments
    ADD CONSTRAINT idx_50857_primary PRIMARY KEY (id);


--
-- Name: followers idx_50865_primary; Type: CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY followers
    ADD CONSTRAINT idx_50865_primary PRIMARY KEY (follower_id, user_id);


--
-- Name: issues idx_50871_primary; Type: CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY issues
    ADD CONSTRAINT idx_50871_primary PRIMARY KEY (id);


--
-- Name: issue_labels idx_50890_primary; Type: CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY issue_labels
    ADD CONSTRAINT idx_50890_primary PRIMARY KEY (issue_id, label_id);


--
-- Name: organization_members idx_50893_primary; Type: CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY organization_members
    ADD CONSTRAINT idx_50893_primary PRIMARY KEY (org_id, user_id);


--
-- Name: projects idx_50899_primary; Type: CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT idx_50899_primary PRIMARY KEY (id);


--
-- Name: project_members idx_50918_primary; Type: CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY project_members
    ADD CONSTRAINT idx_50918_primary PRIMARY KEY (repo_id, user_id);


--
-- Name: project_topics idx_50923_primary; Type: CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY project_topics
    ADD CONSTRAINT idx_50923_primary PRIMARY KEY (project_id, topic_name);


--
-- Name: pull_requests idx_50930_primary; Type: CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY pull_requests
    ADD CONSTRAINT idx_50930_primary PRIMARY KEY (id);


--
-- Name: pull_request_commits idx_50941_primary; Type: CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY pull_request_commits
    ADD CONSTRAINT idx_50941_primary PRIMARY KEY (pull_request_id, commit_id);


--
-- Name: pull_request_history idx_50946_primary; Type: CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY pull_request_history
    ADD CONSTRAINT idx_50946_primary PRIMARY KEY (id);


--
-- Name: repo_labels idx_50953_primary; Type: CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY repo_labels
    ADD CONSTRAINT idx_50953_primary PRIMARY KEY (id);


--
-- Name: repo_milestones idx_50959_primary; Type: CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY repo_milestones
    ADD CONSTRAINT idx_50959_primary PRIMARY KEY (id);


--
-- Name: users idx_50969_primary; Type: CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT idx_50969_primary PRIMARY KEY (id);


--
-- Name: watchers idx_50980_primary; Type: CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY watchers
    ADD CONSTRAINT idx_50980_primary PRIMARY KEY (repo_id, user_id);


--
-- Name: idx_50850_commits_ibfk_1; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50850_commits_ibfk_1 ON commits USING btree (author_id);


--
-- Name: idx_50850_commits_ibfk_2; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50850_commits_ibfk_2 ON commits USING btree (committer_id);


--
-- Name: idx_50850_commits_ibfk_3; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50850_commits_ibfk_3 ON commits USING btree (project_id);


--
-- Name: idx_50850_sha; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE UNIQUE INDEX idx_50850_sha ON commits USING btree (sha);


--
-- Name: idx_50857_comment_id; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE UNIQUE INDEX idx_50857_comment_id ON commit_comments USING btree (comment_id);


--
-- Name: idx_50857_commit_comments_ibfk_1; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50857_commit_comments_ibfk_1 ON commit_comments USING btree (commit_id);


--
-- Name: idx_50857_commit_comments_ibfk_2; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50857_commit_comments_ibfk_2 ON commit_comments USING btree (user_id);


--
-- Name: idx_50862_commit_parents_ibfk_1; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50862_commit_parents_ibfk_1 ON commit_parents USING btree (commit_id);


--
-- Name: idx_50862_commit_parents_ibfk_2; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50862_commit_parents_ibfk_2 ON commit_parents USING btree (parent_id);


--
-- Name: idx_50865_follower_fk2; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50865_follower_fk2 ON followers USING btree (user_id);


--
-- Name: idx_50865_follower_id; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50865_follower_id ON followers USING btree (follower_id);


--
-- Name: idx_50871_issues_ibfk_1; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50871_issues_ibfk_1 ON issues USING btree (repo_id);


--
-- Name: idx_50871_issues_ibfk_2; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50871_issues_ibfk_2 ON issues USING btree (reporter_id);


--
-- Name: idx_50871_issues_ibfk_3; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50871_issues_ibfk_3 ON issues USING btree (assignee_id);


--
-- Name: idx_50871_issues_ibfk_4; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50871_issues_ibfk_4 ON issues USING btree (pull_request_id);


--
-- Name: idx_50876_issue_comments_ibfk_1; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50876_issue_comments_ibfk_1 ON issue_comments USING btree (issue_id);


--
-- Name: idx_50876_issue_comments_ibfk_2; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50876_issue_comments_ibfk_2 ON issue_comments USING btree (user_id);


--
-- Name: idx_50883_issue_events_ibfk_1; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50883_issue_events_ibfk_1 ON issue_events USING btree (issue_id);


--
-- Name: idx_50883_issue_events_ibfk_2; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50883_issue_events_ibfk_2 ON issue_events USING btree (actor_id);


--
-- Name: idx_50890_issue_labels_ibfk_1; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50890_issue_labels_ibfk_1 ON issue_labels USING btree (label_id);


--
-- Name: idx_50893_organization_members_ibfk_2; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50893_organization_members_ibfk_2 ON organization_members USING btree (user_id);


--
-- Name: idx_50899_name; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50899_name ON projects USING btree (name);


--
-- Name: idx_50899_projects_ibfk_1; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50899_projects_ibfk_1 ON projects USING btree (owner_id);


--
-- Name: idx_50899_projects_ibfk_2; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50899_projects_ibfk_2 ON projects USING btree (forked_from);


--
-- Name: idx_50909_commit_id; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50909_commit_id ON project_commits USING btree (commit_id);


--
-- Name: idx_50909_project_commits_ibfk_1; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50909_project_commits_ibfk_1 ON project_commits USING btree (project_id);


--
-- Name: idx_50914_project_id; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50914_project_id ON project_languages USING btree (project_id);


--
-- Name: idx_50918_project_members_ibfk_2; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50918_project_members_ibfk_2 ON project_members USING btree (user_id);


--
-- Name: idx_50930_pull_requests_ibfk_1; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50930_pull_requests_ibfk_1 ON pull_requests USING btree (head_repo_id);


--
-- Name: idx_50930_pull_requests_ibfk_2; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50930_pull_requests_ibfk_2 ON pull_requests USING btree (base_repo_id);


--
-- Name: idx_50930_pull_requests_ibfk_3; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50930_pull_requests_ibfk_3 ON pull_requests USING btree (head_commit_id);


--
-- Name: idx_50930_pull_requests_ibfk_4; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50930_pull_requests_ibfk_4 ON pull_requests USING btree (base_commit_id);


--
-- Name: idx_50930_pullreq_id; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE UNIQUE INDEX idx_50930_pullreq_id ON pull_requests USING btree (pullreq_id, base_repo_id);


--
-- Name: idx_50934_pull_request_comments_ibfk_1; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50934_pull_request_comments_ibfk_1 ON pull_request_comments USING btree (pull_request_id);


--
-- Name: idx_50934_pull_request_comments_ibfk_2; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50934_pull_request_comments_ibfk_2 ON pull_request_comments USING btree (user_id);


--
-- Name: idx_50934_pull_request_comments_ibfk_3; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50934_pull_request_comments_ibfk_3 ON pull_request_comments USING btree (commit_id);


--
-- Name: idx_50941_pull_request_commits_ibfk_2; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50941_pull_request_commits_ibfk_2 ON pull_request_commits USING btree (commit_id);


--
-- Name: idx_50946_pull_request_history_ibfk_1; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50946_pull_request_history_ibfk_1 ON pull_request_history USING btree (pull_request_id);


--
-- Name: idx_50946_pull_request_history_ibfk_2; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50946_pull_request_history_ibfk_2 ON pull_request_history USING btree (actor_id);


--
-- Name: idx_50953_repo_labels_ibfk_1; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50953_repo_labels_ibfk_1 ON repo_labels USING btree (repo_id);


--
-- Name: idx_50959_repo_milestones_ibfk_1; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50959_repo_milestones_ibfk_1 ON repo_milestones USING btree (repo_id);


--
-- Name: idx_50969_login; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE UNIQUE INDEX idx_50969_login ON users USING btree (login);


--
-- Name: idx_50980_watchers_ibfk_2; Type: INDEX; Schema: ghtorrent; Owner: postgres
--

CREATE INDEX idx_50980_watchers_ibfk_2 ON watchers USING btree (user_id);


--
-- Name: commit_comments commit_comments_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY commit_comments
    ADD CONSTRAINT commit_comments_ibfk_1 FOREIGN KEY (commit_id) REFERENCES commits(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: commit_comments commit_comments_ibfk_2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY commit_comments
    ADD CONSTRAINT commit_comments_ibfk_2 FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: commit_parents commit_parents_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY commit_parents
    ADD CONSTRAINT commit_parents_ibfk_1 FOREIGN KEY (commit_id) REFERENCES commits(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: commit_parents commit_parents_ibfk_2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY commit_parents
    ADD CONSTRAINT commit_parents_ibfk_2 FOREIGN KEY (parent_id) REFERENCES commits(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: commits commits_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY commits
    ADD CONSTRAINT commits_ibfk_1 FOREIGN KEY (author_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: commits commits_ibfk_2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY commits
    ADD CONSTRAINT commits_ibfk_2 FOREIGN KEY (committer_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: commits commits_ibfk_3; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY commits
    ADD CONSTRAINT commits_ibfk_3 FOREIGN KEY (project_id) REFERENCES projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: followers follower_fk1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY followers
    ADD CONSTRAINT follower_fk1 FOREIGN KEY (follower_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: followers follower_fk2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY followers
    ADD CONSTRAINT follower_fk2 FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issue_comments issue_comments_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY issue_comments
    ADD CONSTRAINT issue_comments_ibfk_1 FOREIGN KEY (issue_id) REFERENCES issues(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issue_comments issue_comments_ibfk_2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY issue_comments
    ADD CONSTRAINT issue_comments_ibfk_2 FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issue_events issue_events_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY issue_events
    ADD CONSTRAINT issue_events_ibfk_1 FOREIGN KEY (issue_id) REFERENCES issues(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issue_events issue_events_ibfk_2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY issue_events
    ADD CONSTRAINT issue_events_ibfk_2 FOREIGN KEY (actor_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issue_labels issue_labels_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY issue_labels
    ADD CONSTRAINT issue_labels_ibfk_1 FOREIGN KEY (label_id) REFERENCES repo_labels(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issue_labels issue_labels_ibfk_2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY issue_labels
    ADD CONSTRAINT issue_labels_ibfk_2 FOREIGN KEY (issue_id) REFERENCES issues(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issues issues_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY issues
    ADD CONSTRAINT issues_ibfk_1 FOREIGN KEY (repo_id) REFERENCES projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issues issues_ibfk_2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY issues
    ADD CONSTRAINT issues_ibfk_2 FOREIGN KEY (reporter_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issues issues_ibfk_3; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY issues
    ADD CONSTRAINT issues_ibfk_3 FOREIGN KEY (assignee_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: issues issues_ibfk_4; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY issues
    ADD CONSTRAINT issues_ibfk_4 FOREIGN KEY (pull_request_id) REFERENCES pull_requests(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: organization_members organization_members_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY organization_members
    ADD CONSTRAINT organization_members_ibfk_1 FOREIGN KEY (org_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: organization_members organization_members_ibfk_2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY organization_members
    ADD CONSTRAINT organization_members_ibfk_2 FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: project_commits project_commits_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY project_commits
    ADD CONSTRAINT project_commits_ibfk_1 FOREIGN KEY (project_id) REFERENCES projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: project_commits project_commits_ibfk_2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY project_commits
    ADD CONSTRAINT project_commits_ibfk_2 FOREIGN KEY (commit_id) REFERENCES commits(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: project_languages project_languages_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY project_languages
    ADD CONSTRAINT project_languages_ibfk_1 FOREIGN KEY (project_id) REFERENCES projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: project_members project_members_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY project_members
    ADD CONSTRAINT project_members_ibfk_1 FOREIGN KEY (repo_id) REFERENCES projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: project_members project_members_ibfk_2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY project_members
    ADD CONSTRAINT project_members_ibfk_2 FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: project_topics project_topics_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY project_topics
    ADD CONSTRAINT project_topics_ibfk_1 FOREIGN KEY (project_id) REFERENCES projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: projects projects_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_ibfk_1 FOREIGN KEY (owner_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: projects projects_ibfk_2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_ibfk_2 FOREIGN KEY (forked_from) REFERENCES projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_request_comments pull_request_comments_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY pull_request_comments
    ADD CONSTRAINT pull_request_comments_ibfk_1 FOREIGN KEY (pull_request_id) REFERENCES pull_requests(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_request_comments pull_request_comments_ibfk_2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY pull_request_comments
    ADD CONSTRAINT pull_request_comments_ibfk_2 FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_request_comments pull_request_comments_ibfk_3; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY pull_request_comments
    ADD CONSTRAINT pull_request_comments_ibfk_3 FOREIGN KEY (commit_id) REFERENCES commits(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_request_commits pull_request_commits_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY pull_request_commits
    ADD CONSTRAINT pull_request_commits_ibfk_1 FOREIGN KEY (pull_request_id) REFERENCES pull_requests(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_request_commits pull_request_commits_ibfk_2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY pull_request_commits
    ADD CONSTRAINT pull_request_commits_ibfk_2 FOREIGN KEY (commit_id) REFERENCES commits(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_request_history pull_request_history_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY pull_request_history
    ADD CONSTRAINT pull_request_history_ibfk_1 FOREIGN KEY (pull_request_id) REFERENCES pull_requests(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_request_history pull_request_history_ibfk_2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY pull_request_history
    ADD CONSTRAINT pull_request_history_ibfk_2 FOREIGN KEY (actor_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_requests pull_requests_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY pull_requests
    ADD CONSTRAINT pull_requests_ibfk_1 FOREIGN KEY (head_repo_id) REFERENCES projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_requests pull_requests_ibfk_2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY pull_requests
    ADD CONSTRAINT pull_requests_ibfk_2 FOREIGN KEY (base_repo_id) REFERENCES projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_requests pull_requests_ibfk_3; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY pull_requests
    ADD CONSTRAINT pull_requests_ibfk_3 FOREIGN KEY (head_commit_id) REFERENCES commits(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pull_requests pull_requests_ibfk_4; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY pull_requests
    ADD CONSTRAINT pull_requests_ibfk_4 FOREIGN KEY (base_commit_id) REFERENCES commits(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: repo_labels repo_labels_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY repo_labels
    ADD CONSTRAINT repo_labels_ibfk_1 FOREIGN KEY (repo_id) REFERENCES projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: repo_milestones repo_milestones_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY repo_milestones
    ADD CONSTRAINT repo_milestones_ibfk_1 FOREIGN KEY (repo_id) REFERENCES projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: watchers watchers_ibfk_1; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY watchers
    ADD CONSTRAINT watchers_ibfk_1 FOREIGN KEY (repo_id) REFERENCES projects(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: watchers watchers_ibfk_2; Type: FK CONSTRAINT; Schema: ghtorrent; Owner: postgres
--

ALTER TABLE ONLY watchers
    ADD CONSTRAINT watchers_ibfk_2 FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

