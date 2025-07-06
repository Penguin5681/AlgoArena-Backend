--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Ubuntu 16.9-1.pgdg24.04+1)
-- Dumped by pg_dump version 17.5 (Ubuntu 17.5-1.pgdg24.04+1)

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

ALTER TABLE IF EXISTS ONLY public.user_xp_log DROP CONSTRAINT IF EXISTS user_xp_log_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_total_xp DROP CONSTRAINT IF EXISTS user_total_xp_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_topic_progress DROP CONSTRAINT IF EXISTS user_topic_progress_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_topic_progress DROP CONSTRAINT IF EXISTS user_topic_progress_topic_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_question_progress DROP CONSTRAINT IF EXISTS user_question_progress_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_question_progress DROP CONSTRAINT IF EXISTS user_question_progress_question_id_fkey;
ALTER TABLE IF EXISTS ONLY public.topic_code_examples DROP CONSTRAINT IF EXISTS topic_code_examples_topic_id_fkey;
ALTER TABLE IF EXISTS ONLY public.teams DROP CONSTRAINT IF EXISTS teams_created_by_fkey;
ALTER TABLE IF EXISTS ONLY public.team_members DROP CONSTRAINT IF EXISTS team_members_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.team_members DROP CONSTRAINT IF EXISTS team_members_team_id_fkey;
ALTER TABLE IF EXISTS ONLY public.questions DROP CONSTRAINT IF EXISTS questions_topic_id_fkey;
ALTER TABLE IF EXISTS ONLY public.mcqs DROP CONSTRAINT IF EXISTS mcqs_topic_id_fkey;
ALTER TABLE IF EXISTS ONLY public.submissions DROP CONSTRAINT IF EXISTS fk_submissions_problem;
ALTER TABLE IF EXISTS ONLY public.coding_problem_topics DROP CONSTRAINT IF EXISTS coding_problem_topics_topic_id_fkey;
ALTER TABLE IF EXISTS ONLY public.coding_problem_topics DROP CONSTRAINT IF EXISTS coding_problem_topics_problem_id_fkey;
ALTER TABLE IF EXISTS ONLY public.coding_problem_testcases DROP CONSTRAINT IF EXISTS coding_problem_testcases_problem_id_fkey;
DROP TRIGGER IF EXISTS trg_update_total_xp_on_log ON public.user_xp_log;
DROP TRIGGER IF EXISTS trg_insert_user_total_xp ON public.users;
DROP INDEX IF EXISTS public.idx_testcase_problem;
DROP INDEX IF EXISTS public.idx_submissions_user_id;
DROP INDEX IF EXISTS public.idx_submissions_status;
DROP INDEX IF EXISTS public.idx_submissions_problem_user;
DROP INDEX IF EXISTS public.idx_problem_topic_id;
DROP INDEX IF EXISTS public.idx_problem_difficulty;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_username_key;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_key;
ALTER TABLE IF EXISTS ONLY public.user_xp_log DROP CONSTRAINT IF EXISTS user_xp_log_pkey;
ALTER TABLE IF EXISTS ONLY public.user_total_xp DROP CONSTRAINT IF EXISTS user_total_xp_pkey;
ALTER TABLE IF EXISTS ONLY public.user_total_xp DROP CONSTRAINT IF EXISTS user_total_xp_email_key;
ALTER TABLE IF EXISTS ONLY public.user_topic_progress DROP CONSTRAINT IF EXISTS user_topic_progress_user_topic_unique;
ALTER TABLE IF EXISTS ONLY public.user_topic_progress DROP CONSTRAINT IF EXISTS user_topic_progress_pkey;
ALTER TABLE IF EXISTS ONLY public.user_question_progress DROP CONSTRAINT IF EXISTS user_question_progress_user_question_unique;
ALTER TABLE IF EXISTS ONLY public.user_question_progress DROP CONSTRAINT IF EXISTS user_question_progress_pkey;
ALTER TABLE IF EXISTS ONLY public.user_xp_log DROP CONSTRAINT IF EXISTS unique_user_xp_log_entry;
ALTER TABLE IF EXISTS ONLY public.topics DROP CONSTRAINT IF EXISTS topics_slug_key;
ALTER TABLE IF EXISTS ONLY public.topics DROP CONSTRAINT IF EXISTS topics_pkey;
ALTER TABLE IF EXISTS ONLY public.topic_code_examples DROP CONSTRAINT IF EXISTS topic_code_examples_pkey;
ALTER TABLE IF EXISTS ONLY public.teams DROP CONSTRAINT IF EXISTS teams_pkey;
ALTER TABLE IF EXISTS ONLY public.teams DROP CONSTRAINT IF EXISTS teams_join_code_key;
ALTER TABLE IF EXISTS ONLY public.team_members DROP CONSTRAINT IF EXISTS team_members_pkey;
ALTER TABLE IF EXISTS ONLY public.submissions DROP CONSTRAINT IF EXISTS submissions_pkey;
ALTER TABLE IF EXISTS ONLY public.questions DROP CONSTRAINT IF EXISTS questions_pkey;
ALTER TABLE IF EXISTS ONLY public.problem_topics DROP CONSTRAINT IF EXISTS problem_topics_pkey;
ALTER TABLE IF EXISTS ONLY public.problem_topics DROP CONSTRAINT IF EXISTS problem_topics_name_key;
ALTER TABLE IF EXISTS ONLY public.mcqs DROP CONSTRAINT IF EXISTS mcqs_pkey;
ALTER TABLE IF EXISTS ONLY public.coding_problems DROP CONSTRAINT IF EXISTS coding_problems_pkey;
ALTER TABLE IF EXISTS ONLY public.coding_problem_topics DROP CONSTRAINT IF EXISTS coding_problem_topics_pkey;
ALTER TABLE IF EXISTS ONLY public.coding_problem_testcases DROP CONSTRAINT IF EXISTS coding_problem_testcases_pkey;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.user_xp_log ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.user_topic_progress ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.user_question_progress ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.topic_code_examples ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.teams ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.submissions ALTER COLUMN submission_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.problem_topics ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.coding_problem_testcases ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.user_xp_log_id_seq;
DROP TABLE IF EXISTS public.user_xp_log;
DROP TABLE IF EXISTS public.user_total_xp;
DROP SEQUENCE IF EXISTS public.user_topic_progress_id_seq;
DROP TABLE IF EXISTS public.user_topic_progress;
DROP SEQUENCE IF EXISTS public.user_question_progress_id_seq;
DROP TABLE IF EXISTS public.user_question_progress;
DROP TABLE IF EXISTS public.topics;
DROP SEQUENCE IF EXISTS public.topic_code_examples_id_seq;
DROP TABLE IF EXISTS public.topic_code_examples;
DROP SEQUENCE IF EXISTS public.teams_id_seq;
DROP TABLE IF EXISTS public.teams;
DROP TABLE IF EXISTS public.team_members;
DROP SEQUENCE IF EXISTS public.submissions_submission_id_seq;
DROP TABLE IF EXISTS public.submissions;
DROP TABLE IF EXISTS public.questions;
DROP SEQUENCE IF EXISTS public.problem_topics_id_seq;
DROP TABLE IF EXISTS public.problem_topics;
DROP TABLE IF EXISTS public.mcqs;
DROP TABLE IF EXISTS public.coding_problems;
DROP TABLE IF EXISTS public.coding_problem_topics;
DROP SEQUENCE IF EXISTS public.coding_problem_testcases_id_seq;
DROP TABLE IF EXISTS public.coding_problem_testcases;
DROP FUNCTION IF EXISTS public.update_user_total_xp_on_log();
DROP FUNCTION IF EXISTS public.insert_user_total_xp();
DROP TYPE IF EXISTS public.submission_status;
--
-- Name: submission_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.submission_status AS ENUM (
    'PENDING',
    'PROCESSING',
    'SUCCESS',
    'ERROR'
);


--
-- Name: insert_user_total_xp(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.insert_user_total_xp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  INSERT INTO user_total_xp (user_id, email, total_xp)
  VALUES (NEW.id, NEW.email, 0);
  RETURN NEW;
END;$$;


--
-- Name: update_user_total_xp_on_log(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_user_total_xp_on_log() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE user_total_xp
  SET total_xp = total_xp + NEW.xp_earned
  WHERE user_id = NEW.user_id;
  RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: coding_problem_testcases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coding_problem_testcases (
    id integer NOT NULL,
    problem_id text NOT NULL,
    input text NOT NULL,
    expected_output text NOT NULL,
    is_sample boolean DEFAULT false
);


--
-- Name: coding_problem_testcases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.coding_problem_testcases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: coding_problem_testcases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.coding_problem_testcases_id_seq OWNED BY public.coding_problem_testcases.id;


--
-- Name: coding_problem_topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coding_problem_topics (
    problem_id text NOT NULL,
    topic_id integer NOT NULL
);


--
-- Name: coding_problems; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coding_problems (
    id text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    constraints text NOT NULL,
    difficulty text NOT NULL,
    time_complexity text NOT NULL,
    space_complexity text NOT NULL,
    hints text[],
    xp integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT coding_problems_difficulty_check CHECK ((difficulty = ANY (ARRAY['easy'::text, 'medium'::text, 'hard'::text])))
);


--
-- Name: mcqs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mcqs (
    id text NOT NULL,
    topic_id integer,
    question text NOT NULL,
    options text[] NOT NULL,
    correct_index integer NOT NULL
);


--
-- Name: problem_topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.problem_topics (
    id integer NOT NULL,
    name text NOT NULL
);


--
-- Name: problem_topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.problem_topics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.problem_topics_id_seq OWNED BY public.problem_topics.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questions (
    id text NOT NULL,
    topic_id integer,
    title text NOT NULL,
    description text NOT NULL,
    difficulty text,
    xp integer DEFAULT 0,
    index integer,
    CONSTRAINT questions_difficulty_check CHECK ((difficulty = ANY (ARRAY['easy'::text, 'medium'::text, 'hard'::text])))
);


--
-- Name: submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submissions (
    submission_id integer NOT NULL,
    user_id integer NOT NULL,
    language character varying(50) NOT NULL,
    code text NOT NULL,
    stdin text,
    status character varying(20) DEFAULT 'queued'::character varying,
    result text,
    execution_time integer,
    memory_usage integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    stdout text,
    stderr text,
    test_results jsonb,
    tests_passed integer DEFAULT 0,
    total_tests integer DEFAULT 0,
    problem_id text
);


--
-- Name: submissions_submission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.submissions_submission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submissions_submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.submissions_submission_id_seq OWNED BY public.submissions.submission_id;


--
-- Name: team_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_members (
    user_id integer NOT NULL,
    team_id integer,
    is_admin boolean DEFAULT false
);


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teams (
    id integer NOT NULL,
    name text NOT NULL,
    join_code character(8) NOT NULL,
    created_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: topic_code_examples; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.topic_code_examples (
    id integer NOT NULL,
    topic_id integer,
    language text,
    code text NOT NULL,
    CONSTRAINT topic_code_examples_language_check CHECK ((language = ANY (ARRAY['cpp'::text, 'java'::text, 'javascript'::text, 'python'::text])))
);


--
-- Name: topic_code_examples_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.topic_code_examples_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topic_code_examples_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.topic_code_examples_id_seq OWNED BY public.topic_code_examples.id;


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.topics (
    id integer NOT NULL,
    title text NOT NULL,
    slug text NOT NULL,
    section text,
    difficulty text,
    markdown text NOT NULL,
    diagrams text[],
    xp integer DEFAULT 0,
    CONSTRAINT topics_difficulty_check CHECK ((difficulty = ANY (ARRAY['easy'::text, 'medium'::text, 'hard'::text])))
);


--
-- Name: user_question_progress; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_question_progress (
    id integer NOT NULL,
    user_id integer,
    question_id text,
    is_passed boolean DEFAULT false,
    duration_sec integer,
    status text,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: user_question_progress_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_question_progress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_question_progress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_question_progress_id_seq OWNED BY public.user_question_progress.id;


--
-- Name: user_topic_progress; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_topic_progress (
    id integer NOT NULL,
    user_id integer,
    topic_id integer,
    status text NOT NULL,
    completed_at timestamp without time zone
);


--
-- Name: user_topic_progress_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_topic_progress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_topic_progress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_topic_progress_id_seq OWNED BY public.user_topic_progress.id;


--
-- Name: user_total_xp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_total_xp (
    user_id integer NOT NULL,
    email text NOT NULL,
    total_xp integer DEFAULT 0
);


--
-- Name: user_xp_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_xp_log (
    id integer NOT NULL,
    user_id integer,
    source_type text,
    source_key text NOT NULL,
    xp_earned integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: user_xp_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_xp_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_xp_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_xp_log_id_seq OWNED BY public.user_xp_log.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    firebase_uid text,
    profile_picture text
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: coding_problem_testcases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coding_problem_testcases ALTER COLUMN id SET DEFAULT nextval('public.coding_problem_testcases_id_seq'::regclass);


--
-- Name: problem_topics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problem_topics ALTER COLUMN id SET DEFAULT nextval('public.problem_topics_id_seq'::regclass);


--
-- Name: submissions submission_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions ALTER COLUMN submission_id SET DEFAULT nextval('public.submissions_submission_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: topic_code_examples id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topic_code_examples ALTER COLUMN id SET DEFAULT nextval('public.topic_code_examples_id_seq'::regclass);


--
-- Name: user_question_progress id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_question_progress ALTER COLUMN id SET DEFAULT nextval('public.user_question_progress_id_seq'::regclass);


--
-- Name: user_topic_progress id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_topic_progress ALTER COLUMN id SET DEFAULT nextval('public.user_topic_progress_id_seq'::regclass);


--
-- Name: user_xp_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_xp_log ALTER COLUMN id SET DEFAULT nextval('public.user_xp_log_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: coding_problem_testcases; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.coding_problem_testcases (id, problem_id, input, expected_output, is_sample) FROM stdin;
1	two-sum	nums = [2,7,11,15], target = 9	[0,1]	t
2	two-sum	nums = [3,2,4], target = 6	[1,2]	t
3	two-sum	nums = [3,3], target = 6	[0,1]	t
4	valid-parentheses	s = "()"	true	t
5	valid-parentheses	s = "()[]{}"	true	t
6	valid-parentheses	s = "(]"	false	t
7	merge-two-sorted-lists	list1 = [1,2,4], list2 = [1,3,4]	[1,1,2,3,4,4]	t
8	merge-two-sorted-lists	list1 = [], list2 = []	[]	t
9	merge-two-sorted-lists	list1 = [], list2 = [0]	[0]	t
10	maximum-subarray	nums = [-2,1,-3,4,-1,2,1,-5,4]	6	t
11	maximum-subarray	nums = [1]	1	t
12	maximum-subarray	nums = [5,4,-1,7,8]	23	t
13	binary-tree-level-order-traversal	root = [3,9,20,null,null,15,7]	[[3],[9,20],[15,7]]	t
14	binary-tree-level-order-traversal	root = [1]	[[1]]	t
15	binary-tree-level-order-traversal	root = []	[]	t
16	longest-increasing-subsequence	nums = [10,9,2,5,3,7,101,18]	4	t
17	longest-increasing-subsequence	nums = [0,1,0,3,2,3]	4	t
18	longest-increasing-subsequence	nums = [7,7,7,7,7,7,7]	1	t
19	regular-expression-matching	s = "aa", p = "a"	false	t
20	regular-expression-matching	s = "aa", p = "a*"	true	t
21	regular-expression-matching	s = "ab", p = ".*"	true	t
22	median-of-two-sorted-arrays	nums1 = [1,3], nums2 = [2]	2.00000	t
23	median-of-two-sorted-arrays	nums1 = [1,2], nums2 = [3,4]	2.50000	t
24	climbing-stairs	n = 2	2	t
25	climbing-stairs	n = 3	3	t
26	best-time-to-buy-and-sell-stock	prices = [7,1,5,3,6,4]	5	t
27	best-time-to-buy-and-sell-stock	prices = [7,6,4,3,1]	0	t
\.


--
-- Data for Name: coding_problem_topics; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.coding_problem_topics (problem_id, topic_id) FROM stdin;
two-sum	1
valid-parentheses	2
merge-two-sorted-lists	3
maximum-subarray	4
binary-tree-level-order-traversal	5
longest-increasing-subsequence	4
regular-expression-matching	4
median-of-two-sorted-arrays	6
climbing-stairs	4
best-time-to-buy-and-sell-stock	1
\.


--
-- Data for Name: coding_problems; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.coding_problems (id, title, description, constraints, difficulty, time_complexity, space_complexity, hints, xp, created_at) FROM stdin;
two-sum	Two Sum	Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.\n\nYou may assume that each input would have exactly one solution, and you may not use the same element twice.\n\nYou can return the answer in any order.	2 <= nums.length <= 10^4\n-10^9 <= nums[i] <= 10^9\n-10^9 <= target <= 10^9\nOnly one valid answer exists	easy	O(n)	O(n)	{"A really brute force way would be to search for all possible pairs of numbers but that would be too slow. Again, it's best to try out brute force solutions for just for completeness. It is from these brute force solutions that you can come up with optimizations.","So, if we fix one of the numbers, say x, we have to scan the entire array to find the next number y which is value - x where value is the input parameter. Can we change our array somehow so that this search becomes faster?","The second train of thought is, without changing the array, can we use additional space somehow? Like maybe a hash map to speed up the search?"}	10	2025-07-05 16:29:06.712774
valid-parentheses	Valid Parentheses	Given a string s containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.\n\nAn input string is valid if:\n1. Open brackets must be closed by the same type of brackets.\n2. Open brackets must be closed in the correct order.\n3. Every close bracket has a corresponding open bracket of the same type.	1 <= s.length <= 10^4\ns consists of parentheses only '()[]{}'.	easy	O(n)	O(n)	{"Use a stack of characters.","When you encounter an opening bracket, push it to the top of the stack.","When you encounter a closing bracket, check if the top of the stack was the opening for it. If yes, pop it from the stack. Otherwise, return false."}	10	2025-07-05 16:29:06.712774
merge-two-sorted-lists	Merge Two Sorted Lists	You are given the heads of two sorted linked lists list1 and list2.\n\nMerge the two lists in a one sorted list. The list should be made by splicing together the nodes of the first two lists.\n\nReturn the head of the merged linked list.	The number of nodes in both lists is in the range [0, 50].\n-100 <= Node.val <= 100\nBoth list1 and list2 are sorted in non-decreasing order.	easy	O(n + m)	O(1)	{"Maintain a head pointer to the merged list.","Compare values of the current nodes of both lists and attach the smaller one to the result.","Don't forget to handle the remaining nodes when one list is exhausted."}	10	2025-07-05 16:29:06.712774
maximum-subarray	Maximum Subarray	Given an integer array nums, find the contiguous subarray (containing at least one number) which has the largest sum and return its sum.\n\nA subarray is a contiguous part of an array.	1 <= nums.length <= 10^5\n-10^4 <= nums[i] <= 10^4	medium	O(n)	O(1)	{"Try using Kadane's algorithm.","At each position, you can either start a new subarray or extend the existing one.","Keep track of the maximum sum seen so far."}	25	2025-07-05 16:29:06.712774
binary-tree-level-order-traversal	Binary Tree Level Order Traversal	Given the root of a binary tree, return the level order traversal of its nodes' values. (i.e., from left to right, level by level).	The number of nodes in the tree is in the range [0, 2000].\n-1000 <= Node.val <= 1000	medium	O(n)	O(w)	{"Use BFS (Breadth-First Search) with a queue.","Process nodes level by level by keeping track of the current level size.","Add all nodes of the current level to the result before moving to the next level."}	25	2025-07-05 16:29:06.712774
longest-increasing-subsequence	Longest Increasing Subsequence	Given an integer array nums, return the length of the longest strictly increasing subsequence.\n\nA subsequence is a sequence that can be derived from an array by deleting some or no elements without changing the order of the remaining elements.	1 <= nums.length <= 2500\n-10^4 <= nums[i] <= 10^4	medium	O(n^2)	O(n)	{"Think about the brute force approach first. Can you optimize it using dynamic programming?","For each element, what's the longest increasing subsequence ending at that element?","Can you use binary search to optimize further?"}	25	2025-07-05 16:29:06.712774
regular-expression-matching	Regular Expression Matching	Given an input string s and a pattern p, implement regular expression matching with support for '.' and '*' where:\n\n'.' Matches any single character.\n'*' Matches zero or more of the preceding element.\n\nThe matching should cover the entire input string (not partial).	1 <= s.length <= 20\n1 <= p.length <= 30\ns contains only lowercase English letters.\np contains only lowercase English letters, '.', and '*'.\nIt is guaranteed for each appearance of the character '*', there will be a previous valid character to match.	hard	O(n*m)	O(n*m)	{"This problem has a typical solution using dynamic programming. We define the state P(i,j) to be true if s[0..i) matches p[0..j) and false otherwise.","The state transitions have two cases: the general case and the special case with the '*' character.","For the general case, we just check if the current characters match, and if they do, we move to the next state P(i+1, j+1)."}	50	2025-07-05 16:29:06.712774
median-of-two-sorted-arrays	Median of Two Sorted Arrays	Given two sorted arrays nums1 and nums2 of size m and n respectively, return the median of the two sorted arrays.\n\nThe overall run time complexity should be O(log (m+n)).	nums1.length == m\nnums2.length == n\n0 <= m <= 1000\n0 <= n <= 1000\n1 <= m + n <= 2000\n-10^6 <= nums1[i], nums2[i] <= 10^6	hard	O(log(min(m,n)))	O(1)	{"To solve this problem, we need to understand \\"What is the use of median\\". In statistics, the median is used for dividing a set into two equal length subsets, that one subset is always greater than the other.","If we understand the use of median for dividing, we are very close to the answer.","First let's cut A into two parts at a random position i: left_A[0, i-1] | right_A[i, m-1]. Since A has m elements, so there are m+1 kinds of cutting (i = 0 ~ m)."}	50	2025-07-05 16:29:06.712774
climbing-stairs	Climbing Stairs	You are climbing a staircase. It takes n steps to reach the top.\n\nEach time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?	1 <= n <= 45	easy	O(n)	O(1)	{"To reach nth step, what could have been your previous steps? (Think about the step sizes)","You are climbing either from (n-1)th step or (n-2)th step.","So the number of ways to get to the nth step is equal to the sum of ways of getting to the (n-1)th step and ways of getting to the (n-2)th step."}	10	2025-07-05 16:29:06.712774
best-time-to-buy-and-sell-stock	Best Time to Buy and Sell Stock	You are given an array prices where prices[i] is the price of a given stock on the ith day.\n\nYou want to maximize your profit by choosing a single day to buy one stock and choosing a different day in the future to sell that stock.\n\nReturn the maximum profit you can achieve from this transaction. If you cannot achieve any profit, return 0.	1 <= prices.length <= 10^5\n0 <= prices[i] <= 10^4	easy	O(n)	O(1)	{"Say the given array is [7, 1, 5, 3, 6, 4]. If we plot the numbers of the given array on a graph, we get: The points of interest are the peaks and valleys in the given graph. We need to find the largest peak following the smallest valley.","We can maintain two variables - minprice and maxprofit corresponding to the smallest valley and maximum profit (maximum difference between selling price and minprice) obtained so far respectively."}	10	2025-07-05 16:29:06.712774
\.


--
-- Data for Name: mcqs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mcqs (id, topic_id, question, options, correct_index) FROM stdin;
M4.1	4	Which OOP principle involves bundling data and methods that operate on that data within a single unit?	{Inheritance,Polymorphism,Encapsulation,Abstraction}	2
M4.2	4	What is the main benefit of inheritance in object-oriented programming?	{"It makes programs run faster","It allows code reuse and creates hierarchical relationships","It reduces memory usage","It prevents errors in code"}	1
M4.3	4	Which concept allows different classes to have methods with the same name but different implementations?	{Encapsulation,Abstraction,Inheritance,Polymorphism}	3
M1.1	1	Which loop is best when you know the number of iterations?	{"while loop","for loop","do-while loop",recursion}	1
M1.2	1	What is the main difference between a while loop and a do-while loop?	{"while loop runs faster than do-while loop","do-while loop executes at least once, while loop may not execute at all","while loop can use break statement, do-while cannot","There is no difference between them"}	1
M1.3	1	What will happen if you forget to update the loop counter in a while loop?	{"The program will compile but run slowly","The program will throw a syntax error","The loop will create an infinite loop","The loop will execute only once"}	2
M2.1	2	Which operator is used to check equality in most programming languages?	{=,==,===,!=}	1
M2.2	2	What happens if you forget to include 'break' statements in a switch case?	{"The program will throw an error","Only the matching case will execute","All cases after the matching case will execute (fall-through)","The switch statement will not work"}	2
M2.3	2	Which conditional statement is best when you need to check multiple specific values of a single variable?	{if-else,"if-else if-else","switch statement","nested if statements"}	2
M3.1	3	What is the main benefit of using functions in programming?	{"Functions make programs run faster","Functions reduce code duplication and improve organization","Functions use less memory","Functions are required in all programs"}	1
M3.2	3	What happens when a function reaches a return statement?	{"The function continues executing the remaining code","The function exits and returns the specified value","The function throws an error","The function restarts from the beginning"}	1
M3.3	3	What is a recursive function?	{"A function that takes multiple parameters","A function that returns multiple values","A function that calls itself","A function that has no return statement"}	2
M5.1	5	What is the time complexity of linear search in the worst case?	{O(1),"O(log n)",O(n),O(n²)}	2
M5.2	5	Which algorithm is used to find the maximum sum of a contiguous subarray?	{"Binary Search","Bubble Sort","Kadane's Algorithm","Linear Search"}	2
M5.3	5	Binary search can only be applied to:	{"Any array","Arrays with unique elements","Sorted arrays","Arrays with even number of elements"}	2
M6.1	6	What is the time complexity of the KMP string searching algorithm?	{"O(n × m)","O(n + m)",O(n²),O(m²)}	1
M6.2	6	Which string searching algorithm uses rolling hash technique?	{"Naive Search","KMP Algorithm","Rabin-Karp Algorithm","Binary Search"}	2
M6.3	6	What is the space complexity of checking if two strings are anagrams using character frequency counting?	{O(1),O(n),"O(k) where k is the number of unique characters",O(n²)}	2
M7.1	7	What is the time complexity of inserting a new node at the beginning of a singly linked list?	{O(1),"O(log n)",O(n),O(n²)}	0
M7.2	7	Which algorithm is commonly used to detect a cycle in a linked list?	{"Binary search algorithm","Floyd's Cycle-Finding algorithm (Tortoise and Hare)","Quicksort algorithm","Dijkstra's algorithm"}	1
M7.3	7	What is the key difference between a singly linked list and a doubly linked list?	{"A singly linked list can only be traversed forward, while a doubly linked list can be traversed in both directions","A singly linked list takes less memory than a doubly linked list","A singly linked list can only store integers, while a doubly linked list can store any data type","A singly linked list has better time complexity for all operations"}	0
M8.1	8	What principle does a stack data structure follow?	{"First-In-First-Out (FIFO)","Last-In-First-Out (LIFO)","First-In-Last-Out (FILO)","Random Access"}	1
M8.2	8	Which of the following applications is NOT typically solved using stacks?	{"Balanced parentheses checking","Infix to postfix conversion","Breadth-first search traversal","Function call management (call stack)"}	2
M9.1	9	What principle does a queue data structure follow?	{"Last-In-First-Out (LIFO)","First-In-First-Out (FIFO)","Highest-Priority-First-Out (HPFO)","Random Access"}	1
M9.2	9	What is the time complexity of the dequeue operation in a simple array-based queue implementation?	{O(1),"O(log n)",O(n),O(n²)}	2
M9.3	9	Which type of queue allows elements to be inserted and removed from both ends?	{"Circular Queue","Priority Queue","Simple Queue","Deque (Double-ended Queue)"}	3
\.


--
-- Data for Name: problem_topics; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.problem_topics (id, name) FROM stdin;
1	Arrays
2	Stack
3	Linked List
4	Dynamic Programming
5	Tree
6	Binary Search
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.questions (id, topic_id, title, description, difficulty, xp, index) FROM stdin;
C4.1	4	Create a Student Class	Design a Student class with private attributes (name, student_id, grades) and public methods to add grades, calculate average, and display student information. Demonstrate encapsulation principles.	easy	20	\N
C4.2	4	Vehicle Inheritance System	Create a base Vehicle class and inherit from it to create Car and Motorcycle classes. Each should have specific properties and methods. Demonstrate inheritance and method overriding with a start_engine() method.	medium	30	\N
C4.3	4	Shape Polymorphism Challenge	Create an abstract Shape class and implement Circle, Rectangle, and Triangle classes. Each should calculate area differently. Create a function that takes any shape and displays its area, demonstrating polymorphism.	hard	40	\N
C1.1	1	Print Numbers from 1 to N	Write a loop that prints numbers from 1 to N.	easy	10	\N
C1.2	1	Sum of First N Natural Numbers	Write a loop to calculate and print the sum of first N natural numbers (1 + 2 + 3 + ... + N).	easy	15	\N
C1.3	1	Multiplication Table	Write nested loops to print the multiplication table for numbers 1 to 5 in a formatted way (e.g., 1x1=1, 1x2=2, etc.).	medium	25	\N
C2.1	2	Check Maximum of Three Numbers	Write a program using conditional statements to find and print the maximum of three given numbers.	easy	15	\N
C2.2	2	Simple Calculator	Create a simple calculator using switch statements that can perform basic operations (+, -, *, /) on two numbers based on user input.	medium	25	\N
C2.3	2	Student Grade Classification	Write a program that takes a student's score and classifies it into letter grades (A: 90-100, B: 80-89, C: 70-79, D: 60-69, F: below 60) using if-else if-else statements.	easy	20	\N
C3.1	3	Temperature Converter Function	Write a function that converts temperature from Celsius to Fahrenheit. The function should take a Celsius value as parameter and return the equivalent Fahrenheit value.	easy	15	\N
C3.2	3	Prime Number Checker	Create a function that checks if a given number is prime. The function should return true if the number is prime, false otherwise. Test it with various numbers.	medium	25	\N
C3.3	3	String Manipulation Functions	Write multiple functions: one to reverse a string, one to count vowels in a string, and one to check if a string is a palindrome. Demonstrate calling all three functions with sample strings.	medium	30	\N
C5.1	5	Find Two Sum	Given an array of integers and a target sum, find two numbers in the array that add up to the target. Return their indices. You may assume that each input has exactly one solution.	easy	20	\N
C5.2	5	Rotate Array	Given an array and a number k, rotate the array to the right by k steps. For example, given [1,2,3,4,5,6,7] and k=3, return [5,6,7,1,2,3,4]. Implement both left and right rotation functions.	medium	30	\N
C5.3	5	Maximum Subarray Problem	Implement Kadane's algorithm to find the maximum sum of a contiguous subarray. Also return the actual subarray (start and end indices) that produces this maximum sum. Test with arrays containing both positive and negative numbers.	medium	35	\N
C6.1	6	String Manipulation Challenge	Create functions to: 1) Check if a string is a valid palindrome (ignoring spaces and case), 2) Find the longest palindromic substring, and 3) Count the frequency of each character in a string. Test with various inputs.	easy	25	\N
C6.2	6	Pattern Matching Implementation	Implement both naive string search and KMP algorithm to find all occurrences of a pattern in a text. Compare their performance on large strings and analyze the difference in time complexity.	medium	35	\N
C6.3	6	Advanced String Algorithms	Implement the Rabin-Karp algorithm for string matching and create a function to find all anagrams of a given string within a text. Handle edge cases like hash collisions and optimize for multiple pattern searches.	hard	45	\N
C7.1	7	Implement a Basic Singly Linked List	Create a singly linked list implementation with the following methods: insert at beginning, insert at end, delete a node with a given value, and print all elements. Your implementation should include a Node class and a LinkedList class.	easy	20	\N
C7.2	7	Reverse a Linked List	Implement a function to reverse a singly linked list. You should modify the list in-place and return the new head of the reversed list. For example, if the original list is 1->2->3->4->null, the reversed list should be 4->3->2->1->null. Include both iterative and recursive solutions if possible.	medium	30	\N
C7.3	7	Detect and Remove a Cycle in a Linked List	Implement a solution to detect if a linked list contains a cycle. If a cycle exists, find the node where the cycle begins and remove the cycle to make it a proper linked list. Use Floyd's Cycle-Finding Algorithm (also known as the 'tortoise and hare' algorithm) for detection. Your solution should include functions for cycle detection, finding the cycle start node, and cycle removal.	hard	50	\N
C8.1	8	Implement a Stack with Min Function	Design a stack that supports push, pop, top, and retrieving the minimum element in constant time. Implement a MinStack class with the following methods: push(x) — Push element x onto stack, pop() — Removes the element on top of the stack, top() — Get the top element, and getMin() — Retrieve the minimum element in the stack. All operations must have O(1) time complexity.	easy	20	\N
C8.2	8	Validate Parentheses, Brackets, and Braces	Write a function that takes a string containing just the characters '(', ')', '{', '}', '[' and ']', and determines if the input string is valid. An input string is valid if: 1) Open brackets must be closed by the same type of brackets, 2) Open brackets must be closed in the correct order, and 3) Every close bracket has a corresponding open bracket of the same type. For example, '()' and '()[]{}'are valid but '(]' and '([)]' are not.	medium	30	\N
C8.3	8	Evaluate Reverse Polish Notation	Implement a function to evaluate the value of an arithmetic expression in Reverse Polish Notation (RPN). Valid operators are +, -, *, and /. Each operand may be an integer or another expression. Note that division between two integers should truncate toward zero. The expression is guaranteed to be valid and evaluate to a 32-bit signed integer. For example, input ['2', '1', '+', '3', '*'] represents the expression (2 + 1) * 3 and should evaluate to 9.	hard	50	\N
C9.1	9	Implement a Basic Queue	Create a queue implementation with the following methods: enqueue (add an element to the rear), dequeue (remove an element from the front), front (get the front element without removing it), isEmpty (check if the queue is empty), and size (return the number of elements in the queue). You can use an array or linked list as the underlying data structure.	easy	20	\N
C9.2	9	Implement a Circular Queue	Design a circular queue implementation that efficiently utilizes memory. A circular queue connects the last position back to the first position to form a circle. Your implementation should include methods for enqueue, dequeue, peek, isFull, and isEmpty. Define a fixed capacity for the queue and handle the cases when the queue is full or empty properly.	medium	30	\N
C9.3	9	Level Order Traversal of Binary Tree	Implement a function that performs a level order traversal of a binary tree (also known as breadth-first traversal). Your function should take the root of a binary tree as input and return an array of arrays, where each inner array contains the values of nodes at the same level from left to right. For example, given a tree [3,9,20,null,null,15,7], your function should return [[3],[9,20],[15,7]]. Use a queue data structure to solve this problem efficiently.	hard	50	\N
\.


--
-- Data for Name: submissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.submissions (submission_id, user_id, language, code, stdin, status, result, execution_time, memory_usage, created_at, updated_at, stdout, stderr, test_results, tests_passed, total_tests, problem_id) FROM stdin;
32	9	python	# Find Two Sum\n# Given an array of integers and a target sum, find two numbers in the array that add up to the target. Return their indices. You may assume that each input has exactly one solution.\n\ndef solve():\n    # Your code goes here\n    print("Hello World")\n\nsolve()	\N	success	\N	42	\N	2025-07-05 13:54:40.056831	2025-07-05 13:54:40.345843	Hello World\n		\N	0	0	\N
33	9	javascript	// Find Two Sum\n// Given an array of integers and a target sum, find two numbers in the array that add up to the target. Return their indices. You may assume that each input has exactly one solution.\n\nfunction solve() {\n  // Your code goes here\n  console.log("Hello World");\n}\n\nsolve();	\N	success	\N	60	\N	2025-07-05 13:54:56.12465	2025-07-05 13:54:56.197752	Hello World\n		\N	0	0	\N
34	9	javascript	// Find Two Sum\n// Given an array of integers and a target sum, find two numbers in the array that add up to the target. Return their indices. You may assume that each input has exactly one solution.\n\nfunction solve() {\n  // Your code goes here\n  console.log("Hello Jija ji");\n}\n\nsolve();	\N	success	\N	47	\N	2025-07-05 13:56:51.107071	2025-07-05 13:56:51.169037	Hello Jija ji\n		\N	0	0	\N
\.


--
-- Data for Name: team_members; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.team_members (user_id, team_id, is_admin) FROM stdin;
8	2	t
9	2	f
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.teams (id, name, join_code, created_by, created_at) FROM stdin;
2	Club Penguin	TWH16II1	8	2025-07-04 20:38:12.661181
\.


--
-- Data for Name: topic_code_examples; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.topic_code_examples (id, topic_id, language, code) FROM stdin;
5	4	cpp	#include <iostream>\n#include <string>\nusing namespace std;\n\n// BASE CLASS - Encapsulation example\nclass Animal {\nprivate:\n    string name;\n    int age;\n\npublic:\n    // Constructor\n    Animal(string n, int a) : name(n), age(a) {}\n    \n    // Getter methods (Encapsulation)\n    string getName() { return name; }\n    int getAge() { return age; }\n    \n    // Virtual method for polymorphism\n    virtual void makeSound() {\n        cout << name << " makes a generic animal sound" << endl;\n    }\n    \n    virtual void displayInfo() {\n        cout << "Name: " << name << ", Age: " << age << endl;\n    }\n};\n\n// INHERITANCE - Dog inherits from Animal\nclass Dog : public Animal {\nprivate:\n    string breed;\n\npublic:\n    Dog(string n, int a, string b) : Animal(n, a), breed(b) {}\n    \n    // Method overriding (Polymorphism)\n    void makeSound() override {\n        cout << getName() << " barks!" << endl;\n    }\n    \n    void displayInfo() override {\n        Animal::displayInfo();\n        cout << "Breed: " << breed << endl;\n    }\n    \n    // Dog-specific method\n    void wagTail() {\n        cout << getName() << " wags tail happily!" << endl;\n    }\n};\n\n// INHERITANCE - Cat inherits from Animal\nclass Cat : public Animal {\npublic:\n    Cat(string n, int a) : Animal(n, a) {}\n    \n    // Method overriding (Polymorphism)\n    void makeSound() override {\n        cout << getName() << " meows!" << endl;\n    }\n    \n    // Cat-specific method\n    void purr() {\n        cout << getName() << " purrs contentedly" << endl;\n    }\n};\n\n// ABSTRACTION - Rectangle class\nclass Rectangle {\nprivate:\n    double length, width;\n\npublic:\n    Rectangle(double l, double w) : length(l), width(w) {}\n    \n    // Public interface (hiding implementation details)\n    double getArea() {\n        return calculateArea();\n    }\n    \n    double getPerimeter() {\n        return calculatePerimeter();\n    }\n\nprivate:\n    // Private methods (implementation hidden)\n    double calculateArea() {\n        return length * width;\n    }\n    \n    double calculatePerimeter() {\n        return 2 * (length + width);\n    }\n};\n\nint main() {\n    // Creating objects\n    Dog dog("Buddy", 3, "Golden Retriever");\n    Cat cat("Whiskers", 2);\n    Rectangle rect(10.5, 8.2);\n    \n    // Encapsulation - accessing data through methods\n    cout << "=== Encapsulation Example ===" << endl;\n    dog.displayInfo();\n    cout << endl;\n    \n    // Inheritance - using inherited methods\n    cout << "=== Inheritance Example ===" << endl;\n    cout << "Dog's name: " << dog.getName() << endl;\n    cout << "Cat's age: " << cat.getAge() << endl;\n    cout << endl;\n    \n    // Polymorphism - same method, different behavior\n    cout << "=== Polymorphism Example ===" << endl;\n    Animal* animals[] = {&dog, &cat};\n    for (int i = 0; i < 2; i++) {\n        animals[i]->makeSound();\n    }\n    cout << endl;\n    \n    // Specific methods\n    dog.wagTail();\n    cat.purr();\n    cout << endl;\n    \n    // Abstraction - using simple interface\n    cout << "=== Abstraction Example ===" << endl;\n    cout << "Rectangle Area: " << rect.getArea() << endl;\n    cout << "Rectangle Perimeter: " << rect.getPerimeter() << endl;\n    \n    return 0;\n}\n
6	4	java	// BASE CLASS - Encapsulation example\nclass Animal {\n    private String name;\n    private int age;\n    \n    // Constructor\n    public Animal(String name, int age) {\n        this.name = name;\n        this.age = age;\n    }\n    \n    // Getter methods (Encapsulation)\n    public String getName() {\n        return name;\n    }\n    \n    public int getAge() {\n        return age;\n    }\n    \n    // Method for polymorphism\n    public void makeSound() {\n        System.out.println(name + " makes a generic animal sound");\n    }\n    \n    public void displayInfo() {\n        System.out.println("Name: " + name + ", Age: " + age);\n    }\n}\n\n// INHERITANCE - Dog inherits from Animal\nclass Dog extends Animal {\n    private String breed;\n    \n    public Dog(String name, int age, String breed) {\n        super(name, age); // Call parent constructor\n        this.breed = breed;\n    }\n    \n    // Method overriding (Polymorphism)\n    @Override\n    public void makeSound() {\n        System.out.println(getName() + " barks!");\n    }\n    \n    @Override\n    public void displayInfo() {\n        super.displayInfo();\n        System.out.println("Breed: " + breed);\n    }\n    \n    // Dog-specific method\n    public void wagTail() {\n        System.out.println(getName() + " wags tail happily!");\n    }\n}\n\n// INHERITANCE - Cat inherits from Animal\nclass Cat extends Animal {\n    public Cat(String name, int age) {\n        super(name, age);\n    }\n    \n    // Method overriding (Polymorphism)\n    @Override\n    public void makeSound() {\n        System.out.println(getName() + " meows!");\n    }\n    \n    // Cat-specific method\n    public void purr() {\n        System.out.println(getName() + " purrs contentedly");\n    }\n}\n\n// ABSTRACTION - Rectangle class\nclass Rectangle {\n    private double length, width;\n    \n    public Rectangle(double length, double width) {\n        this.length = length;\n        this.width = width;\n    }\n    \n    // Public interface (hiding implementation details)\n    public double getArea() {\n        return calculateArea();\n    }\n    \n    public double getPerimeter() {\n        return calculatePerimeter();\n    }\n    \n    // Private methods (implementation hidden)\n    private double calculateArea() {\n        return length * width;\n    }\n    \n    private double calculatePerimeter() {\n        return 2 * (length + width);\n    }\n}\n\npublic class OOPDemo {\n    public static void main(String[] args) {\n        // Creating objects\n        Dog dog = new Dog("Buddy", 3, "Golden Retriever");\n        Cat cat = new Cat("Whiskers", 2);\n        Rectangle rect = new Rectangle(10.5, 8.2);\n        \n        // Encapsulation - accessing data through methods\n        System.out.println("=== Encapsulation Example ===");\n        dog.displayInfo();\n        System.out.println();\n        \n        // Inheritance - using inherited methods\n        System.out.println("=== Inheritance Example ===");\n        System.out.println("Dog's name: " + dog.getName());\n        System.out.println("Cat's age: " + cat.getAge());\n        System.out.println();\n        \n        // Polymorphism - same method, different behavior\n        System.out.println("=== Polymorphism Example ===");\n        Animal[] animals = {dog, cat};\n        for (Animal animal : animals) {\n            animal.makeSound();\n        }\n        System.out.println();\n        \n        // Specific methods\n        dog.wagTail();\n        cat.purr();\n        System.out.println();\n        \n        // Abstraction - using simple interface\n        System.out.println("=== Abstraction Example ===");\n        System.out.println("Rectangle Area: " + rect.getArea());\n        System.out.println("Rectangle Perimeter: " + rect.getPerimeter());\n    }\n}\n
7	4	javascript	// BASE CLASS - Encapsulation example\nclass Animal {\n    constructor(name, age) {\n        this.name = name;\n        this.age = age;\n    }\n    \n    // Getter methods (Encapsulation)\n    getName() {\n        return this.name;\n    }\n    \n    getAge() {\n        return this.age;\n    }\n    \n    // Method for polymorphism\n    makeSound() {\n        console.log(`${this.name} makes a generic animal sound`);\n    }\n    \n    displayInfo() {\n        console.log(`Name: ${this.name}, Age: ${this.age}`);\n    }\n}\n\n// INHERITANCE - Dog inherits from Animal\nclass Dog extends Animal {\n    constructor(name, age, breed) {\n        super(name, age); // Call parent constructor\n        this.breed = breed;\n    }\n    \n    // Method overriding (Polymorphism)\n    makeSound() {\n        console.log(`${this.getName()} barks!`);\n    }\n    \n    displayInfo() {\n        super.displayInfo();\n        console.log(`Breed: ${this.breed}`);\n    }\n    \n    // Dog-specific method\n    wagTail() {\n        console.log(`${this.getName()} wags tail happily!`);\n    }\n}\n\n// INHERITANCE - Cat inherits from Animal\nclass Cat extends Animal {\n    constructor(name, age) {\n        super(name, age);\n    }\n    \n    // Method overriding (Polymorphism)\n    makeSound() {\n        console.log(`${this.getName()} meows!`);\n    }\n    \n    // Cat-specific method\n    purr() {\n        console.log(`${this.getName()} purrs contentedly`);\n    }\n}\n\n// ABSTRACTION - Rectangle class\nclass Rectangle {\n    constructor(length, width) {\n        this.length = length;\n        this.width = width;\n    }\n    \n    // Public interface (hiding implementation details)\n    getArea() {\n        return this.#calculateArea();\n    }\n    \n    getPerimeter() {\n        return this.#calculatePerimeter();\n    }\n    \n    // Private methods (implementation hidden)\n    #calculateArea() {\n        return this.length * this.width;\n    }\n    \n    #calculatePerimeter() {\n        return 2 * (this.length + this.width);\n    }\n}\n\n// Creating objects\nconst dog = new Dog("Buddy", 3, "Golden Retriever");\nconst cat = new Cat("Whiskers", 2);\nconst rect = new Rectangle(10.5, 8.2);\n\n// Encapsulation - accessing data through methods\nconsole.log("=== Encapsulation Example ===");\ndog.displayInfo();\nconsole.log();\n\n// Inheritance - using inherited methods\nconsole.log("=== Inheritance Example ===");\nconsole.log("Dog's name:", dog.getName());\nconsole.log("Cat's age:", cat.getAge());\nconsole.log();\n\n// Polymorphism - same method, different behavior\nconsole.log("=== Polymorphism Example ===");\nconst animals = [dog, cat];\nanimals.forEach(animal => {\n    animal.makeSound();\n});\nconsole.log();\n\n// Specific methods\ndog.wagTail();\ncat.purr();\nconsole.log();\n\n// Abstraction - using simple interface\nconsole.log("=== Abstraction Example ===");\nconsole.log("Rectangle Area:", rect.getArea());\nconsole.log("Rectangle Perimeter:", rect.getPerimeter());\n
8	4	python	# BASE CLASS - Encapsulation example\nclass Animal:\n    def __init__(self, name, age):\n        self._name = name  # Protected attribute\n        self._age = age\n    \n    # Getter methods (Encapsulation)\n    def get_name(self):\n        return self._name\n    \n    def get_age(self):\n        return self._age\n    \n    # Method for polymorphism\n    def make_sound(self):\n        print(f"{self._name} makes a generic animal sound")\n    \n    def display_info(self):\n        print(f"Name: {self._name}, Age: {self._age}")\n\n# INHERITANCE - Dog inherits from Animal\nclass Dog(Animal):\n    def __init__(self, name, age, breed):\n        super().__init__(name, age)  # Call parent constructor\n        self._breed = breed\n    \n    # Method overriding (Polymorphism)\n    def make_sound(self):\n        print(f"{self.get_name()} barks!")\n    \n    def display_info(self):\n        super().display_info()\n        print(f"Breed: {self._breed}")\n    \n    # Dog-specific method\n    def wag_tail(self):\n        print(f"{self.get_name()} wags tail happily!")\n\n# INHERITANCE - Cat inherits from Animal\nclass Cat(Animal):\n    def __init__(self, name, age):\n        super().__init__(name, age)\n    \n    # Method overriding (Polymorphism)\n    def make_sound(self):\n        print(f"{self.get_name()} meows!")\n    \n    # Cat-specific method\n    def purr(self):\n        print(f"{self.get_name()} purrs contentedly")\n\n# ABSTRACTION - Rectangle class\nclass Rectangle:\n    def __init__(self, length, width):\n        self.__length = length  # Private attribute\n        self.__width = width\n    \n    # Public interface (hiding implementation details)\n    def get_area(self):\n        return self.__calculate_area()\n    \n    def get_perimeter(self):\n        return self.__calculate_perimeter()\n    \n    # Private methods (implementation hidden)\n    def __calculate_area(self):\n        return self.__length * self.__width\n    \n    def __calculate_perimeter(self):\n        return 2 * (self.__length + self.__width)\n\n# Creating objects\ndog = Dog("Buddy", 3, "Golden Retriever")\ncat = Cat("Whiskers", 2)\nrect = Rectangle(10.5, 8.2)\n\n# Encapsulation - accessing data through methods\nprint("=== Encapsulation Example ===")\ndog.display_info()\nprint()\n\n# Inheritance - using inherited methods\nprint("=== Inheritance Example ===")\nprint("Dog's name:", dog.get_name())\nprint("Cat's age:", cat.get_age())\nprint()\n\n# Polymorphism - same method, different behavior\nprint("=== Polymorphism Example ===")\nanimals = [dog, cat]\nfor animal in animals:\n    animal.make_sound()\nprint()\n\n# Specific methods\ndog.wag_tail()\ncat.purr()\nprint()\n\n# Abstraction - using simple interface\nprint("=== Abstraction Example ===")\nprint("Rectangle Area:", rect.get_area())\nprint("Rectangle Perimeter:", rect.get_perimeter())\n
9	1	cpp	#include <iostream>\nusing namespace std;\n\nint main() {\n    // FOR LOOP - Print numbers 1 to 10\n    cout << "For Loop: ";\n    for (int i = 1; i <= 10; i++) {\n        cout << i << " ";\n    }\n    cout << endl;\n    \n    // WHILE LOOP - Count down from 5\n    cout << "While Loop: ";\n    int count = 5;\n    while (count > 0) {\n        cout << count << " ";\n        count--;\n    }\n    cout << endl;\n    \n    // DO-WHILE LOOP - Run at least once\n    cout << "Do-While Loop: ";\n    int num = 0;\n    do {\n        cout << num + 1 << " ";\n        num++;\n    } while (num < 3);\n    cout << endl;\n    \n    // NESTED LOOPS - Simple pattern\n    cout << "Nested Loops:" << endl;\n    for (int i = 1; i <= 3; i++) {\n        for (int j = 1; j <= i; j++) {\n            cout << "* ";\n        }\n        cout << endl;\n    }\n    \n    // LOOP WITH BREAK\n    cout << "Loop with Break: ";\n    for (int i = 1; i <= 10; i++) {\n        if (i == 6) break; // Stop at 6\n        cout << i << " ";\n    }\n    cout << endl;\n    \n    // LOOP WITH CONTINUE\n    cout << "Loop with Continue: ";\n    for (int i = 1; i <= 5; i++) {\n        if (i == 3) continue; // Skip 3\n        cout << i << " ";\n    }\n    cout << endl;\n    \n    return 0;
10	1	java	public class Loops {\n    public static void main(String[] args) {\n        // FOR LOOP - Print numbers 1 to 10\n        System.out.print("For Loop: ");\n        for (int i = 1; i <= 10; i++) {\n            System.out.print(i + " ");\n        }\n        System.out.println();\n        \n        // WHILE LOOP - Count down from 5\n        System.out.print("While Loop: ");\n        int count = 5;\n        while (count > 0) {\n            System.out.print(count + " ");\n            count--;\n        }\n        System.out.println();\n        \n        // DO-WHILE LOOP - Run at least once\n        System.out.print("Do-While Loop: ");\n        int num = 0;\n        do {\n            System.out.print((num + 1) + " ");\n            num++;\n        } while (num < 3);\n        System.out.println();\n        \n        // NESTED LOOPS - Simple pattern\n        System.out.println("Nested Loops:");\n        for (int i = 1; i <= 3; i++) {\n            for (int j = 1; j <= i; j++) {\n                System.out.print("* ");\n            }\n            System.out.println();\n        }\n        \n        // LOOP WITH BREAK\n        System.out.print("Loop with Break: ");\n        for (int i = 1; i <= 10; i++) {\n            if (i == 6) break; // Stop at 6\n            System.out.print(i + " ");\n        }\n        System.out.println();\n        \n        // LOOP WITH CONTINUE\n        System.out.print("Loop with Continue: ");\n        for (int i = 1; i <= 5; i++) {\n            if (i == 3) continue; // Skip 3\n            System.out.print(i + " ");\n        }\n        System.out.println();
11	1	javascript	// FOR LOOP - Print numbers 1 to 10\nprocess.stdout.write("For Loop: ");\nfor (let i = 1; i <= 10; i++) {\n    process.stdout.write(i + " ");\n}\nconsole.log();\n\n// WHILE LOOP - Count down from 5\nprocess.stdout.write("While Loop: ");\nlet count = 5;\nwhile (count > 0) {\n    process.stdout.write(count + " ");\n    count--;\n}\nconsole.log();\n\n// DO-WHILE LOOP - Run at least once\nprocess.stdout.write("Do-While Loop: ");\nlet num = 0;\ndo {\n    process.stdout.write((num + 1) + " ");\n    num++;\n} while (num < 3);\nconsole.log();\n\n// NESTED LOOPS - Simple pattern\nconsole.log("Nested Loops:");\nfor (let i = 1; i <= 3; i++) {\n    let line = "";\n    for (let j = 1; j <= i; j++) {\n        line += "* ";\n    }\n    console.log(line);\n}\n\n// LOOP WITH BREAK\nprocess.stdout.write("Loop with Break: ");\nfor (let i = 1; i <= 10; i++) {\n    if (i === 6) break; // Stop at 6\n    process.stdout.write(i + " ");\n}\nconsole.log();\n\n// LOOP WITH CONTINUE\nprocess.stdout.write("Loop with Continue: ");\nfor (let i = 1; i <= 5; i++) {\n    if (i === 3) continue; // Skip 3\n    process.stdout.write(i + " ");\n}
12	1	python	# FOR LOOP - Print numbers 1 to 10\nprint("For Loop: ", end="")\nfor i in range(1, 11):\n    print(i, end=" ")\nprint()\n\n# WHILE LOOP - Count down from 5\nprint("While Loop: ", end="")\ncount = 5\nwhile count > 0:\n    print(count, end=" ")\n    count -= 1\nprint()\n\n# NOTE: Python doesn't have a built-in do-while loop\n# But we can simulate it using while True with break\n\nprint("Simulated Do-While: ", end="")\nnum = 0\nwhile True:\n    print(num + 1, end=" ")\n    num += 1\n    if num >= 3:  # Exit condition\n        break\nprint()\n\n# NESTED LOOPS - Simple pattern\nprint("Nested Loops:")\nfor i in range(1, 4):\n    for j in range(i):\n        print("* ", end="")\n    print()\n\n# LOOP WITH BREAK\nprint("Loop with Break: ", end="")\nfor i in range(1, 11):\n    if i == 6:\n        break  # Stop at 6\n    print(i, end=" ")\nprint()\n\n# LOOP WITH CONTINUE\nprint("Loop with Continue: ", end="")\nfor i in range(1, 6):\n    if i == 3:\n        continue  # Skip 3\n    print(i, end="
13	2	cpp	#include <iostream>\nusing namespace std;\n\nint main() {\n    // IF STATEMENT - Check if number is positive\n    int number = 10;\n    if (number > 0) {\n        cout << number << " is positive" << endl;\n    }\n    \n    // IF-ELSE STATEMENT - Check even or odd\n    int num = 7;\n    if (num % 2 == 0) {\n        cout << num << " is even" << endl;\n    } else {\n        cout << num << " is odd" << endl;\n    }\n    \n    // IF-ELSE IF-ELSE - Grade system\n    int score = 85;\n    if (score >= 90) {\n        cout << "Grade: A" << endl;\n    } else if (score >= 80) {\n        cout << "Grade: B" << endl;\n    } else if (score >= 70) {\n        cout << "Grade: C" << endl;\n    } else {\n        cout << "Grade: F" << endl;\n    }\n    \n    // SWITCH STATEMENT - Day of week\n    int day = 3;\n    switch (day) {\n        case 1:\n            cout << "Monday" << endl;\n            break;\n        case 2:\n            cout << "Tuesday" << endl;\n            break;\n        case 3:\n            cout << "Wednesday" << endl;\n            break;\n        case 4:\n            cout << "Thursday" << endl;\n            break;\n        case 5:\n            cout << "Friday" << endl;\n            break;\n        default:\n            cout << "Weekend" << endl;\n    }\n    \n    // NESTED CONDITIONALS - Age and license check\n    int age = 20;\n    bool hasLicense = true;\n    \n    if (age >= 18) {\n        if (hasLicense) {\n            cout << "Can drive" << endl;\n        } else {\n            cout << "Need license to drive" << endl;\n        }\n    } else {\n        cout << "Too young to drive" << endl;\n    }\n    \n    return 0;\n}\n
14	2	java	public class Conditionals {\n    public static void main(String[] args) {\n        // IF STATEMENT - Check if number is positive\n        int number = 10;\n        if (number > 0) {\n            System.out.println(number + " is positive");\n        }\n        \n        // IF-ELSE STATEMENT - Check even or odd\n        int num = 7;\n        if (num % 2 == 0) {\n            System.out.println(num + " is even");\n        } else {\n            System.out.println(num + " is odd");\n        }\n        \n        // IF-ELSE IF-ELSE - Grade system\n        int score = 85;\n        if (score >= 90) {\n            System.out.println("Grade: A");\n        } else if (score >= 80) {\n            System.out.println("Grade: B");\n        } else if (score >= 70) {\n            System.out.println("Grade: C");\n        } else {\n            System.out.println("Grade: F");\n        }\n        \n        // SWITCH STATEMENT - Day of week\n        int day = 3;\n        switch (day) {\n            case 1:\n                System.out.println("Monday");\n                break;\n            case 2:\n                System.out.println("Tuesday");\n                break;\n            case 3:\n                System.out.println("Wednesday");\n                break;\n            case 4:\n                System.out.println("Thursday");\n                break;\n            case 5:\n                System.out.println("Friday");\n                break;\n            default:\n                System.out.println("Weekend");\n        }\n        \n        // NESTED CONDITIONALS - Age and license check\n        int age = 20;\n        boolean hasLicense = true;\n        \n        if (age >= 18) {\n            if (hasLicense) {\n                System.out.println("Can drive");\n            } else {\n                System.out.println("Need license to drive");\n            }\n        } else {\n            System.out.println("Too young to drive");\n        }\n    }\n}\n
15	2	javascript	// IF STATEMENT - Check if number is positive\nlet number = 10;\nif (number > 0) {\n    console.log(number + " is positive");\n}\n\n// IF-ELSE STATEMENT - Check even or odd\nlet num = 7;\nif (num % 2 === 0) {\n    console.log(num + " is even");\n} else {\n    console.log(num + " is odd");\n}\n\n// IF-ELSE IF-ELSE - Grade system\nlet score = 85;\nif (score >= 90) {\n    console.log("Grade: A");\n} else if (score >= 80) {\n    console.log("Grade: B");\n} else if (score >= 70) {\n    console.log("Grade: C");\n} else {\n    console.log("Grade: F");\n}\n\n// SWITCH STATEMENT - Day of week\nlet day = 3;\nswitch (day) {\n    case 1:\n        console.log("Monday");\n        break;\n    case 2:\n        console.log("Tuesday");\n        break;\n    case 3:\n        console.log("Wednesday");\n        break;\n    case 4:\n        console.log("Thursday");\n        break;\n    case 5:\n        console.log("Friday");\n        break;\n    default:\n        console.log("Weekend");\n}\n\n// NESTED CONDITIONALS - Age and license check\nlet age = 20;\nlet hasLicense = true;\n\nif (age >= 18) {\n    if (hasLicense) {\n        console.log("Can drive");\n    } else {\n        console.log("Need license to drive");\n    }\n} else {\n    console.log("Too young to drive");\n}\n
16	2	python	# IF STATEMENT - Check if number is positive\nnumber = 10\nif number > 0:\n    print(f"{number} is positive")\n\n# IF-ELSE STATEMENT - Check even or odd\nnum = 7\nif num % 2 == 0:\n    print(f"{num} is even")\nelse:\n    print(f"{num} is odd")\n\n# IF-ELIF-ELSE - Grade system\nscore = 85\nif score >= 90:\n    print("Grade: A")\nelif score >= 80:\n    print("Grade: B")\nelif score >= 70:\n    print("Grade: C")\nelse:\n    print("Grade: F")\n\n# MATCH STATEMENT (Python 3.10+) - Day of week\nday = 3\nmatch day:\n    case 1:\n        print("Monday")\n    case 2:\n        print("Tuesday")\n    case 3:\n        print("Wednesday")\n    case 4:\n        print("Thursday")\n    case 5:\n        print("Friday")\n    case _:\n        print("Weekend")\n\n# NESTED CONDITIONALS - Age and license check\nage = 20\nhas_license = True\n\nif age >= 18:\n    if has_license:\n        print("Can drive")\n    else:\n        print("Need license to drive")\nelse:\n    print("Too young to drive")\n
17	3	cpp	#include <iostream>\nusing namespace std;\n\n// BASIC FUNCTION - No parameters, no return\nvoid greetUser() {\n    cout << "Hello, welcome to our program!" << endl;\n}\n\n// FUNCTION WITH PARAMETERS - Takes input\nvoid greetUserByName(string name) {\n    cout << "Hello, " << name << "! Welcome!" << endl;\n}\n\n// FUNCTION WITH RETURN VALUE - Returns result\nint addNumbers(int a, int b) {\n    return a + b;\n}\n\n// FUNCTION WITH MULTIPLE PARAMETERS AND RETURN\ndouble calculateArea(double length, double width) {\n    return length * width;\n}\n\n// FUNCTION WITH DEFAULT PARAMETERS\nvoid displayInfo(string name, int age = 18) {\n    cout << "Name: " << name << ", Age: " << age << endl;\n}\n\n// RECURSIVE FUNCTION - Calls itself\nint factorial(int n) {\n    if (n <= 1) {\n        return 1;\n    }\n    return n * factorial(n - 1);\n}\n\nint main() {\n    // Call basic function\n    greetUser();\n    \n    // Call function with parameters\n    greetUserByName("Alice");\n    \n    // Call function with return value\n    int sum = addNumbers(5, 3);\n    cout << "Sum: " << sum << endl;\n    \n    // Call function with multiple parameters\n    double area = calculateArea(10.5, 8.2);\n    cout << "Area: " << area << endl;\n    \n    // Call function with default parameters\n    displayInfo("Bob");      // Uses default age\n    displayInfo("Carol", 25); // Uses provided age\n    \n    // Call recursive function\n    int fact = factorial(5);\n    cout << "Factorial of 5: " << fact << endl;\n    \n    return 0;\n}\n
18	3	java	public class Functions {\n    \n    // BASIC FUNCTION - No parameters, no return\n    public static void greetUser() {\n        System.out.println("Hello, welcome to our program!");\n    }\n    \n    // FUNCTION WITH PARAMETERS - Takes input\n    public static void greetUserByName(String name) {\n        System.out.println("Hello, " + name + "! Welcome!");\n    }\n    \n    // FUNCTION WITH RETURN VALUE - Returns result\n    public static int addNumbers(int a, int b) {\n        return a + b;\n    }\n    \n    // FUNCTION WITH MULTIPLE PARAMETERS AND RETURN\n    public static double calculateArea(double length, double width) {\n        return length * width;\n    }\n    \n    // FUNCTION WITH METHOD OVERLOADING (similar to default parameters)\n    public static void displayInfo(String name) {\n        displayInfo(name, 18); // Call overloaded method with default age\n    }\n    \n    public static void displayInfo(String name, int age) {\n        System.out.println("Name: " + name + ", Age: " + age);\n    }\n    \n    // RECURSIVE FUNCTION - Calls itself\n    public static int factorial(int n) {\n        if (n <= 1) {\n            return 1;\n        }\n        return n * factorial(n - 1);\n    }\n    \n    public static void main(String[] args) {\n        // Call basic function\n        greetUser();\n        \n        // Call function with parameters\n        greetUserByName("Alice");\n        \n        // Call function with return value\n        int sum = addNumbers(5, 3);\n        System.out.println("Sum: " + sum);\n        \n        // Call function with multiple parameters\n        double area = calculateArea(10.5, 8.2);\n        System.out.println("Area: " + area);\n        \n        // Call overloaded functions\n        displayInfo("Bob");      // Uses default age\n        displayInfo("Carol", 25); // Uses provided age\n        \n        // Call recursive function\n        int fact = factorial(5);\n        System.out.println("Factorial of 5: " + fact);\n    }\n}\n
19	3	javascript	// BASIC FUNCTION - No parameters, no return\nfunction greetUser() {\n    console.log("Hello, welcome to our program!");\n}\n\n// FUNCTION WITH PARAMETERS - Takes input\nfunction greetUserByName(name) {\n    console.log(`Hello, ${name}! Welcome!`);\n}\n\n// FUNCTION WITH RETURN VALUE - Returns result\nfunction addNumbers(a, b) {\n    return a + b;\n}\n\n// FUNCTION WITH MULTIPLE PARAMETERS AND RETURN\nfunction calculateArea(length, width) {\n    return length * width;\n}\n\n// FUNCTION WITH DEFAULT PARAMETERS\nfunction displayInfo(name, age = 18) {\n    console.log(`Name: ${name}, Age: ${age}`);\n}\n\n// ARROW FUNCTION - Modern syntax\nconst multiplyNumbers = (a, b) => {\n    return a * b;\n};\n\n// ARROW FUNCTION - Shorter syntax\nconst squareNumber = x => x * x;\n\n// RECURSIVE FUNCTION - Calls itself\nfunction factorial(n) {\n    if (n <= 1) {\n        return 1;\n    }\n    return n * factorial(n - 1);\n}\n\n// FUNCTION CALLS\ngreetUser();\n\ngreetUserByName("Alice");\n\nlet sum = addNumbers(5, 3);\nconsole.log("Sum:", sum);\n\nlet area = calculateArea(10.5, 8.2);\nconsole.log("Area:", area);\n\ndisplayInfo("Bob");      // Uses default age\ndisplayInfo("Carol", 25); // Uses provided age\n\nlet product = multiplyNumbers(4, 7);\nconsole.log("Product:", product);\n\nlet square = squareNumber(6);\nconsole.log("Square:", square);\n\nlet fact = factorial(5);\nconsole.log("Factorial of 5:", fact);\n
20	3	python	# BASIC FUNCTION - No parameters, no return\ndef greet_user():\n    print("Hello, welcome to our program!")\n\n# FUNCTION WITH PARAMETERS - Takes input\ndef greet_user_by_name(name):\n    print(f"Hello, {name}! Welcome!")\n\n# FUNCTION WITH RETURN VALUE - Returns result\ndef add_numbers(a, b):\n    return a + b\n\n# FUNCTION WITH MULTIPLE PARAMETERS AND RETURN\ndef calculate_area(length, width):\n    return length * width\n\n# FUNCTION WITH DEFAULT PARAMETERS\ndef display_info(name, age=18):\n    print(f"Name: {name}, Age: {age}")\n\n# FUNCTION WITH MULTIPLE RETURN VALUES\ndef get_name_and_age():\n    return "Alice", 25\n\n# LAMBDA FUNCTION - Anonymous function\nsquare_number = lambda x: x * x\nmultiply_numbers = lambda a, b: a * b\n\n# RECURSIVE FUNCTION - Calls itself\ndef factorial(n):\n    if n <= 1:\n        return 1\n    return n * factorial(n - 1)\n\n# FUNCTION CALLS\ngreet_user()\n\ngreet_user_by_name("Alice")\n\nsum_result = add_numbers(5, 3)\nprint("Sum:", sum_result)\n\narea = calculate_area(10.5, 8.2)\nprint("Area:", area)\n\ndisplay_info("Bob")      # Uses default age\ndisplay_info("Carol", 25) # Uses provided age\n\nname, age = get_name_and_age()\nprint(f"Returned values: {name}, {age}")\n\nsquare = square_number(6)\nprint("Square:", square)\n\nproduct = multiply_numbers(4, 7)\nprint("Product:", product)\n\nfact = factorial(5)\nprint("Factorial of 5:", fact)\n
21	5	cpp	#include <iostream>\n#include <vector>\n#include <algorithm>\nusing namespace std;\n\n// LINEAR SEARCH\nint linearSearch(vector<int>& arr, int target) {\n    for (int i = 0; i < arr.size(); i++) {\n        if (arr[i] == target) {\n            return i;\n        }\n    }\n    return -1;\n}\n\n// BINARY SEARCH\nint binarySearch(vector<int>& arr, int target) {\n    int left = 0, right = arr.size() - 1;\n    \n    while (left <= right) {\n        int mid = left + (right - left) / 2;\n        \n        if (arr[mid] == target) {\n            return mid;\n        } else if (arr[mid] < target) {\n            left = mid + 1;\n        } else {\n            right = mid - 1;\n        }\n    }\n    return -1;\n}\n\n// BUBBLE SORT\nvoid bubbleSort(vector<int>& arr) {\n    int n = arr.size();\n    for (int i = 0; i < n - 1; i++) {\n        for (int j = 0; j < n - i - 1; j++) {\n            if (arr[j] > arr[j + 1]) {\n                swap(arr[j], arr[j + 1]);\n            }\n        }\n    }\n}\n\n// ARRAY ROTATION\nvoid rotateLeft(vector<int>& arr, int positions) {\n    int n = arr.size();\n    positions = positions % n;\n    \n    reverse(arr.begin(), arr.begin() + positions);\n    reverse(arr.begin() + positions, arr.end());\n    reverse(arr.begin(), arr.end());\n}\n\n// KADANE'S ALGORITHM\nint kadane(vector<int>& arr) {\n    int maxSoFar = arr[0];\n    int maxEndingHere = arr[0];\n    \n    for (int i = 1; i < arr.size(); i++) {\n        maxEndingHere = max(arr[i], maxEndingHere + arr[i]);\n        maxSoFar = max(maxSoFar, maxEndingHere);\n    }\n    \n    return maxSoFar;\n}\n\nvoid printArray(vector<int>& arr) {\n    for (int x : arr) {\n        cout << x << " ";\n    }\n    cout << endl;\n}\n\nint main() {\n    // Array operations\n    vector<int> numbers = {5, 2, 8, 1, 9};\n    \n    cout << "Original array: ";\n    printArray(numbers);\n    \n    // Linear Search\n    int target = 8;\n    int index = linearSearch(numbers, target);\n    cout << "Linear Search for " << target << ": " << index << endl;\n    \n    // Bubble Sort\n    vector<int> sortedArr = numbers;\n    bubbleSort(sortedArr);\n    cout << "After Bubble Sort: ";\n    printArray(sortedArr);\n    \n    // Binary Search (on sorted array)\n    target = 8;\n    index = binarySearch(sortedArr, target);\n    cout << "Binary Search for " << target << ": " << index << endl;\n    \n    // Array Rotation\n    vector<int> rotateArr = {1, 2, 3, 4, 5};\n    cout << "Before rotation: ";\n    printArray(rotateArr);\n    rotateLeft(rotateArr, 2);\n    cout << "After left rotation by 2: ";\n    printArray(rotateArr);\n    \n    // Kadane's Algorithm\n    vector<int> kadaneArr = {-2, -3, 4, -1, -2, 1, 5, -3};\n    int maxSum = kadane(kadaneArr);\n    cout << "Maximum subarray sum: " << maxSum << endl;\n    \n    return 0;\n}\n
22	5	java	import java.util.Arrays;\n\npublic class ArrayOperations {\n    \n    // LINEAR SEARCH\n    public static int linearSearch(int[] arr, int target) {\n        for (int i = 0; i < arr.length; i++) {\n            if (arr[i] == target) {\n                return i;\n            }\n        }\n        return -1;\n    }\n    \n    // BINARY SEARCH\n    public static int binarySearch(int[] arr, int target) {\n        int left = 0, right = arr.length - 1;\n        \n        while (left <= right) {\n            int mid = left + (right - left) / 2;\n            \n            if (arr[mid] == target) {\n                return mid;\n            } else if (arr[mid] < target) {\n                left = mid + 1;\n            } else {\n                right = mid - 1;\n            }\n        }\n        return -1;\n    }\n    \n    // BUBBLE SORT\n    public static void bubbleSort(int[] arr) {\n        int n = arr.length;\n        for (int i = 0; i < n - 1; i++) {\n            for (int j = 0; j < n - i - 1; j++) {\n                if (arr[j] > arr[j + 1]) {\n                    // Swap elements\n                    int temp = arr[j];\n                    arr[j] = arr[j + 1];\n                    arr[j + 1] = temp;\n                }\n            }\n        }\n    }\n    \n    // ARRAY ROTATION\n    public static void rotateLeft(int[] arr, int positions) {\n        int n = arr.length;\n        positions = positions % n;\n        \n        reverse(arr, 0, positions - 1);\n        reverse(arr, positions, n - 1);\n        reverse(arr, 0, n - 1);\n    }\n    \n    private static void reverse(int[] arr, int start, int end) {\n        while (start < end) {\n            int temp = arr[start];\n            arr[start] = arr[end];\n            arr[end] = temp;\n            start++;\n            end--;\n        }\n    }\n    \n    // KADANE'S ALGORITHM\n    public static int kadane(int[] arr) {\n        int maxSoFar = arr[0];\n        int maxEndingHere = arr[0];\n        \n        for (int i = 1; i < arr.length; i++) {\n            maxEndingHere = Math.max(arr[i], maxEndingHere + arr[i]);\n            maxSoFar = Math.max(maxSoFar, maxEndingHere);\n        }\n        \n        return maxSoFar;\n    }\n    \n    public static void printArray(int[] arr) {\n        System.out.println(Arrays.toString(arr));\n    }\n    \n    public static void main(String[] args) {\n        // Array operations\n        int[] numbers = {5, 2, 8, 1, 9};\n        \n        System.out.println("Original array: " + Arrays.toString(numbers));\n        \n        // Linear Search\n        int target = 8;\n        int index = linearSearch(numbers, target);\n        System.out.println("Linear Search for " + target + ": " + index);\n        \n        // Bubble Sort\n        int[] sortedArr = numbers.clone();\n        bubbleSort(sortedArr);\n        System.out.println("After Bubble Sort: " + Arrays.toString(sortedArr));\n        \n        // Binary Search (on sorted array)\n        target = 8;\n        index = binarySearch(sortedArr, target);\n        System.out.println("Binary Search for " + target + ": " + index);\n        \n        // Array Rotation\n        int[] rotateArr = {1, 2, 3, 4, 5};\n        System.out.println("Before rotation: " + Arrays.toString(rotateArr));\n        rotateLeft(rotateArr, 2);\n        System.out.println("After left rotation by 2: " + Arrays.toString(rotateArr));\n        \n        // Kadane's Algorithm\n        int[] kadaneArr = {-2, -3, 4, -1, -2, 1, 5, -3};\n        int maxSum = kadane(kadaneArr);\n        System.out.println("Maximum subarray sum: " + maxSum);\n    }\n}\n
32	7	python	class Node:\n    def __init__(self, data):\n        self.data = data\n        self.next = None\n\nclass SinglyLinkedList:\n    def __init__(self):\n        self.head = None\n        self.size = 0\n    \n    def insert_at_beginning(self, data):\n        """Add a node at the beginning of the list"""\n        new_node = Node(data)\n        new_node.next = self.head\n        self.head = new_node\n        self.size += 1\n    \n    def insert_at_end(self, data):\n        """Add a node at the end of the list"""\n        new_node = Node(data)\n        \n        # If the list is empty\n        if not self.head:\n            self.head = new_node\n        else:\n            current = self.head\n            while current.next:\n                current = current.next\n            current.next = new_node\n        \n        self.size += 1\n    \n    def remove_from_beginning(self):\n        """Remove a node from the beginning of the list"""\n        if not self.head:\n            return None\n        \n        removed_node = self.head\n        self.head = self.head.next\n        self.size -= 1\n        \n        return removed_node.data\n    \n    def print_list(self):\n        """Print all elements in the list"""\n        current = self.head\n        result = ""\n        \n        while current:\n            result += str(current.data) + " -> "\n            current = current.next\n        \n        print(result + "None")\n    \n    def reverse(self):\n        """Reverse the linked list"""\n        prev = None\n        current = self.head\n        \n        while current:\n            # Store next\n            next_node = current.next\n            \n            # Reverse current node's pointer\n            current.next = prev\n            \n            # Move pointers one position ahead\n            prev = current\n            current = next_node\n        \n        # Update head\n        self.head = prev\n\n\n# Example usage\nif __name__ == "__main__":\n    linked_list = SinglyLinkedList()\n    linked_list.insert_at_end(1)\n    linked_list.insert_at_end(2)\n    linked_list.insert_at_end(3)\n    linked_list.insert_at_beginning(0)\n    \n    print("Original list:")\n    linked_list.print_list()  # Output: 0 -> 1 -> 2 -> 3 -> None\n    \n    linked_list.reverse()\n    print("Reversed list:")\n    linked_list.print_list()  # Output: 3 -> 2 -> 1 -> 0 -> None\n    \n    print(f"Removed: {linked_list.remove_from_beginning()}")  # Output: Removed: 3\n    linked_list.print_list()  # Output: 2 -> 1 -> 0 -> None
23	5	javascript	// LINEAR SEARCH\nfunction linearSearch(arr, target) {\n    for (let i = 0; i < arr.length; i++) {\n        if (arr[i] === target) {\n            return i;\n        }\n    }\n    return -1;\n}\n\n// BINARY SEARCH\nfunction binarySearch(arr, target) {\n    let left = 0;\n    let right = arr.length - 1;\n    \n    while (left <= right) {\n        let mid = Math.floor((left + right) / 2);\n        \n        if (arr[mid] === target) {\n            return mid;\n        } else if (arr[mid] < target) {\n            left = mid + 1;\n        } else {\n            right = mid - 1;\n        }\n    }\n    return -1;\n}\n\n// BUBBLE SORT\nfunction bubbleSort(arr) {\n    let n = arr.length;\n    let sortedArr = [...arr]; // Create a copy\n    \n    for (let i = 0; i < n - 1; i++) {\n        for (let j = 0; j < n - i - 1; j++) {\n            if (sortedArr[j] > sortedArr[j + 1]) {\n                // Swap elements\n                let temp = sortedArr[j];\n                sortedArr[j] = sortedArr[j + 1];\n                sortedArr[j + 1] = temp;\n            }\n        }\n    }\n    return sortedArr;\n}\n\n// ARRAY ROTATION\nfunction rotateLeft(arr, positions) {\n    let n = arr.length;\n    positions = positions % n;\n    \n    return arr.slice(positions).concat(arr.slice(0, positions));\n}\n\n// KADANE'S ALGORITHM\nfunction kadane(arr) {\n    let maxSoFar = arr[0];\n    let maxEndingHere = arr[0];\n    \n    for (let i = 1; i < arr.length; i++) {\n        maxEndingHere = Math.max(arr[i], maxEndingHere + arr[i]);\n        maxSoFar = Math.max(maxSoFar, maxEndingHere);\n    }\n    \n    return maxSoFar;\n}\n\n// DEMONSTRATION\nconsole.log("=== Array Operations Demo ===");\n\n// Array operations\nlet numbers = [5, 2, 8, 1, 9];\nconsole.log("Original array:", numbers);\n\n// Linear Search\nlet target = 8;\nlet index = linearSearch(numbers, target);\nconsole.log(`Linear Search for ${target}: ${index}`);\n\n// Bubble Sort\nlet sortedArr = bubbleSort(numbers);\nconsole.log("After Bubble Sort:", sortedArr);\n\n// Binary Search (on sorted array)\ntarget = 8;\nindex = binarySearch(sortedArr, target);\nconsole.log(`Binary Search for ${target}: ${index}`);\n\n// Array Rotation\nlet rotateArr = [1, 2, 3, 4, 5];\nconsole.log("Before rotation:", rotateArr);\nlet rotated = rotateLeft(rotateArr, 2);\nconsole.log("After left rotation by 2:", rotated);\n\n// Kadane's Algorithm\nlet kadaneArr = [-2, -3, 4, -1, -2, 1, 5, -3];\nlet maxSum = kadane(kadaneArr);\nconsole.log("Maximum subarray sum:", maxSum);\n\n// Additional array operations\nconsole.log("\\n=== Additional Examples ===");\n\n// Finding second largest element\nfunction findSecondLargest(arr) {\n    let largest = -Infinity;\n    let secondLargest = -Infinity;\n    \n    for (let num of arr) {\n        if (num > largest) {\n            secondLargest = largest;\n            largest = num;\n        } else if (num > secondLargest && num !== largest) {\n            secondLargest = num;\n        }\n    }\n    \n    return secondLargest;\n}\n\nlet testArr = [3, 1, 4, 1, 5, 9, 2, 6];\nconsole.log("Array:", testArr);\nconsole.log("Second largest:", findSecondLargest(testArr));\n\n// Reverse array\nfunction reverseArray(arr) {\n    return arr.slice().reverse();\n}\n\nconsole.log("Reversed array:", reverseArray(testArr));\n
24	5	python	# LINEAR SEARCH\ndef linear_search(arr, target):\n    for i in range(len(arr)):\n        if arr[i] == target:\n            return i\n    return -1\n\n# BINARY SEARCH\ndef binary_search(arr, target):\n    left, right = 0, len(arr) - 1\n    \n    while left <= right:\n        mid = (left + right) // 2\n        \n        if arr[mid] == target:\n            return mid\n        elif arr[mid] < target:\n            left = mid + 1\n        else:\n            right = mid - 1\n    \n    return -1\n\n# BUBBLE SORT\ndef bubble_sort(arr):\n    n = len(arr)\n    sorted_arr = arr.copy()  # Create a copy\n    \n    for i in range(n - 1):\n        for j in range(n - i - 1):\n            if sorted_arr[j] > sorted_arr[j + 1]:\n                # Swap elements\n                sorted_arr[j], sorted_arr[j + 1] = sorted_arr[j + 1], sorted_arr[j]\n    \n    return sorted_arr\n\n# ARRAY ROTATION\ndef rotate_left(arr, positions):\n    n = len(arr)\n    positions = positions % n\n    \n    return arr[positions:] + arr[:positions]\n\n# KADANE'S ALGORITHM\ndef kadane(arr):\n    max_so_far = arr[0]\n    max_ending_here = arr[0]\n    \n    for i in range(1, len(arr)):\n        max_ending_here = max(arr[i], max_ending_here + arr[i])\n        max_so_far = max(max_so_far, max_ending_here)\n    \n    return max_so_far\n\n# DEMONSTRATION\nprint("=== Array Operations Demo ===")\n\n# Array operations\nnumbers = [5, 2, 8, 1, 9]\nprint("Original array:", numbers)\n\n# Linear Search\ntarget = 8\nindex = linear_search(numbers, target)\nprint(f"Linear Search for {target}: {index}")\n\n# Bubble Sort\nsorted_arr = bubble_sort(numbers)\nprint("After Bubble Sort:", sorted_arr)\n\n# Binary Search (on sorted array)\ntarget = 8\nindex = binary_search(sorted_arr, target)\nprint(f"Binary Search for {target}: {index}")\n\n# Array Rotation\nrotate_arr = [1, 2, 3, 4, 5]\nprint("Before rotation:", rotate_arr)\nrotated = rotate_left(rotate_arr, 2)\nprint("After left rotation by 2:", rotated)\n\n# Kadane's Algorithm\nkadane_arr = [-2, -3, 4, -1, -2, 1, 5, -3]\nmax_sum = kadane(kadane_arr)\nprint("Maximum subarray sum:", max_sum)\n\n# Additional array operations\nprint("\\n=== Additional Examples ===")\n\n# Finding second largest element\ndef find_second_largest(arr):\n    largest = float('-inf')\n    second_largest = float('-inf')\n    \n    for num in arr:\n        if num > largest:\n            second_largest = largest\n            largest = num\n        elif num > second_largest and num != largest:\n            second_largest = num\n    \n    return second_largest\n\ntest_arr = [3, 1, 4, 1, 5, 9, 2, 6]\nprint("Array:", test_arr)\nprint("Second largest:", find_second_largest(test_arr))\n\n# Reverse array\ndef reverse_array(arr):\n    return arr[::-1]\n\nprint("Reversed array:", reverse_array(test_arr))\n\n# Remove duplicates\ndef remove_duplicates(arr):\n    return list(set(arr))\n\nprint("Remove duplicates:", remove_duplicates(test_arr))\n\n# Find missing number (1 to n)\ndef find_missing_number(arr, n):\n    expected_sum = n * (n + 1) // 2\n    actual_sum = sum(arr)\n    return expected_sum - actual_sum\n\nincomplete_arr = [1, 2, 4, 5, 6]  # Missing 3\nprint("Missing number:", find_missing_number(incomplete_arr, 6))\n
25	6	cpp	#include <iostream>\n#include <string>\n#include <vector>\n#include <unordered_map>\n#include <algorithm>\nusing namespace std;\n\n// STRING REVERSAL\nstring reverseString(string str) {\n    string reversed = "";\n    for (int i = str.length() - 1; i >= 0; i--) {\n        reversed += str[i];\n    }\n    return reversed;\n}\n\n// PALINDROME CHECK\nbool isPalindrome(string str) {\n    // Convert to lowercase and remove non-alphanumeric\n    string cleaned = "";\n    for (char c : str) {\n        if (isalnum(c)) {\n            cleaned += tolower(c);\n        }\n    }\n    \n    int left = 0, right = cleaned.length() - 1;\n    while (left < right) {\n        if (cleaned[left] != cleaned[right]) {\n            return false;\n        }\n        left++;\n        right--;\n    }\n    return true;\n}\n\n// ANAGRAM CHECK\nbool areAnagrams(string str1, string str2) {\n    if (str1.length() != str2.length()) {\n        return false;\n    }\n    \n    unordered_map<char, int> charCount;\n    \n    // Count characters in first string\n    for (char c : str1) {\n        charCount[tolower(c)]++;\n    }\n    \n    // Subtract characters from second string\n    for (char c : str2) {\n        char lowerC = tolower(c);\n        if (charCount[lowerC] == 0) {\n            return false;\n        }\n        charCount[lowerC]--;\n    }\n    \n    return true;\n}\n\n// NAIVE STRING SEARCH\nvector<int> naiveSearch(string text, string pattern) {\n    vector<int> positions;\n    \n    for (int i = 0; i <= (int)text.length() - (int)pattern.length(); i++) {\n        bool match = true;\n        for (int j = 0; j < pattern.length(); j++) {\n            if (text[i + j] != pattern[j]) {\n                match = false;\n                break;\n            }\n        }\n        if (match) {\n            positions.push_back(i);\n        }\n    }\n    \n    return positions;\n}\n\n// KMP ALGORITHM - Build LPS array\nvector<int> buildLPS(string pattern) {\n    vector<int> lps(pattern.length(), 0);\n    int len = 0;\n    int i = 1;\n    \n    while (i < pattern.length()) {\n        if (pattern[i] == pattern[len]) {\n            len++;\n            lps[i] = len;\n            i++;\n        } else {\n            if (len != 0) {\n                len = lps[len - 1];\n            } else {\n                lps[i] = 0;\n                i++;\n            }\n        }\n    }\n    \n    return lps;\n}\n\n// KMP SEARCH\nvector<int> kmpSearch(string text, string pattern) {\n    vector<int> lps = buildLPS(pattern);\n    vector<int> positions;\n    int i = 0; // text index\n    int j = 0; // pattern index\n    \n    while (i < text.length()) {\n        if (text[i] == pattern[j]) {\n            i++;\n            j++;\n        }\n        \n        if (j == pattern.length()) {\n            positions.push_back(i - j);\n            j = lps[j - 1];\n        } else if (i < text.length() && text[i] != pattern[j]) {\n            if (j != 0) {\n                j = lps[j - 1];\n            } else {\n                i++;\n            }\n        }\n    }\n    \n    return positions;\n}\n\nvoid printVector(vector<int>& vec) {\n    cout << "[";\n    for (int i = 0; i < vec.size(); i++) {\n        cout << vec[i];\n        if (i < vec.size() - 1) cout << ", ";\n    }\n    cout << "]" << endl;\n}\n\nint main() {\n    cout << "=== String Operations Demo ===" << endl;\n    \n    // String Reversal\n    string text = "hello";\n    cout << "Original: " << text << endl;\n    cout << "Reversed: " << reverseString(text) << endl << endl;\n    \n    // Palindrome Check\n    string palindrome1 = "A man a plan a canal Panama";\n    string palindrome2 = "race a car";\n    cout << "'" << palindrome1 << "' is palindrome: " << (isPalindrome(palindrome1) ? "true" : "false") << endl;\n    cout << "'" << palindrome2 << "' is palindrome: " << (isPalindrome(palindrome2) ? "true" : "false") << endl << endl;\n    \n    // Anagram Check\n    string str1 = "listen", str2 = "silent";\n    string str3 = "hello", str4 = "world";\n    cout << "'" << str1 << "' and '" << str2 << "' are anagrams: " << (areAnagrams(str1, str2) ? "true" : "false") << endl;\n    cout << "'" << str3 << "' and '" << str4 << "' are anagrams: " << (areAnagrams(str3, str4) ? "true" : "false") << endl << endl;\n    \n    // String Searching\n    string searchText = "ababcababa";\n    string pattern = "aba";\n    \n    cout << "Searching for '" << pattern << "' in '" << searchText << "'" << endl;\n    \n    vector<int> naiveResult = naiveSearch(searchText, pattern);\n    cout << "Naive Search positions: ";\n    printVector(naiveResult);\n    \n    vector<int> kmpResult = kmpSearch(searchText, pattern);\n    cout << "KMP Search positions: ";\n    printVector(kmpResult);\n    \n    return 0;\n}\n
26	6	java	import java.util.*;\n\npublic class StringOperations {\n    \n    // STRING REVERSAL\n    public static String reverseString(String str) {\n        StringBuilder reversed = new StringBuilder();\n        for (int i = str.length() - 1; i >= 0; i--) {\n            reversed.append(str.charAt(i));\n        }\n        return reversed.toString();\n    }\n    \n    // PALINDROME CHECK\n    public static boolean isPalindrome(String str) {\n        // Clean string - remove non-alphanumeric and convert to lowercase\n        String cleaned = str.replaceAll("[^a-zA-Z0-9]", "").toLowerCase();\n        \n        int left = 0, right = cleaned.length() - 1;\n        while (left < right) {\n            if (cleaned.charAt(left) != cleaned.charAt(right)) {\n                return false;\n            }\n            left++;\n            right--;\n        }\n        return true;\n    }\n    \n    // ANAGRAM CHECK\n    public static boolean areAnagrams(String str1, String str2) {\n        if (str1.length() != str2.length()) {\n            return false;\n        }\n        \n        Map<Character, Integer> charCount = new HashMap<>();\n        \n        // Count characters in first string\n        for (char c : str1.toLowerCase().toCharArray()) {\n            charCount.put(c, charCount.getOrDefault(c, 0) + 1);\n        }\n        \n        // Subtract characters from second string\n        for (char c : str2.toLowerCase().toCharArray()) {\n            if (!charCount.containsKey(c) || charCount.get(c) == 0) {\n                return false;\n            }\n            charCount.put(c, charCount.get(c) - 1);\n        }\n        \n        return true;\n    }\n    \n    // NAIVE STRING SEARCH\n    public static List<Integer> naiveSearch(String text, String pattern) {\n        List<Integer> positions = new ArrayList<>();\n        \n        for (int i = 0; i <= text.length() - pattern.length(); i++) {\n            boolean match = true;\n            for (int j = 0; j < pattern.length(); j++) {\n                if (text.charAt(i + j) != pattern.charAt(j)) {\n                    match = false;\n                    break;\n                }\n            }\n            if (match) {\n                positions.add(i);\n            }\n        }\n        \n        return positions;\n    }\n    \n    // KMP ALGORITHM - Build LPS array\n    public static int[] buildLPS(String pattern) {\n        int[] lps = new int[pattern.length()];\n        int len = 0;\n        int i = 1;\n        \n        while (i < pattern.length()) {\n            if (pattern.charAt(i) == pattern.charAt(len)) {\n                len++;\n                lps[i] = len;\n                i++;\n            } else {\n                if (len != 0) {\n                    len = lps[len - 1];\n                } else {\n                    lps[i] = 0;\n                    i++;\n                }\n            }\n        }\n        \n        return lps;\n    }\n    \n    // KMP SEARCH\n    public static List<Integer> kmpSearch(String text, String pattern) {\n        int[] lps = buildLPS(pattern);\n        List<Integer> positions = new ArrayList<>();\n        int i = 0; // text index\n        int j = 0; // pattern index\n        \n        while (i < text.length()) {\n            if (text.charAt(i) == pattern.charAt(j)) {\n                i++;\n                j++;\n            }\n            \n            if (j == pattern.length()) {\n                positions.add(i - j);\n                j = lps[j - 1];\n            } else if (i < text.length() && text.charAt(i) != pattern.charAt(j)) {\n                if (j != 0) {\n                    j = lps[j - 1];\n                } else {\n                    i++;\n                }\n            }\n        }\n        \n        return positions;\n    }\n    \n    // RABIN-KARP ALGORITHM\n    public static List<Integer> rabinKarp(String text, String pattern) {\n        final int prime = 101;\n        final int base = 256;\n        List<Integer> positions = new ArrayList<>();\n        int patternHash = 0;\n        int textHash = 0;\n        int h = 1;\n        \n        // Calculate h = base^(pattern.length-1) % prime\n        for (int i = 0; i < pattern.length() - 1; i++) {\n            h = (h * base) % prime;\n        }\n        \n        // Calculate initial hash values\n        for (int i = 0; i < pattern.length(); i++) {\n            patternHash = (base * patternHash + pattern.charAt(i)) % prime;\n            textHash = (base * textHash + text.charAt(i)) % prime;\n        }\n        \n        // Slide the pattern over text\n        for (int i = 0; i <= text.length() - pattern.length(); i++) {\n            // Check if hash values match\n            if (patternHash == textHash) {\n                // Verify character by character\n                boolean match = true;\n                for (int j = 0; j < pattern.length(); j++) {\n                    if (text.charAt(i + j) != pattern.charAt(j)) {\n                        match = false;\n                        break;\n                    }\n                }\n                if (match) {\n                    positions.add(i);\n                }\n            }\n            \n            // Calculate next hash value\n            if (i < text.length() - pattern.length()) {\n                textHash = (base * (textHash - text.charAt(i) * h) + text.charAt(i + pattern.length())) % prime;\n                if (textHash < 0) {\n                    textHash += prime;\n                }\n            }\n        }\n        \n        return positions;\n    }\n    \n    public static void main(String[] args) {\n        System.out.println("=== String Operations Demo ===");\n        \n        // String Reversal\n        String text = "hello";\n        System.out.println("Original: " + text);\n        System.out.println("Reversed: " + reverseString(text));\n        System.out.println();\n        \n        // Palindrome Check\n        String palindrome1 = "A man a plan a canal Panama";\n        String palindrome2 = "race a car";\n        System.out.println("'" + palindrome1 + "' is palindrome: " + isPalindrome(palindrome1));\n        System.out.println("'" + palindrome2 + "' is palindrome: " + isPalindrome(palindrome2));\n        System.out.println();\n        \n        // Anagram Check\n        String str1 = "listen", str2 = "silent";\n        String str3 = "hello", str4 = "world";\n        System.out.println("'" + str1 + "' and '" + str2 + "' are anagrams: " + areAnagrams(str1, str2));\n        System.out.println("'" + str3 + "' and '" + str4 + "' are anagrams: " + areAnagrams(str3, str4));\n        System.out.println();\n        \n        // String Searching\n        String searchText = "ababcababa";\n        String pattern = "aba";\n        \n        System.out.println("Searching for '" + pattern + "' in '" + searchText + "'");\n        \n        List<Integer> naiveResult = naiveSearch(searchText, pattern);\n        System.out.println("Naive Search positions: " + naiveResult);\n        \n        List<Integer> kmpResult = kmpSearch(searchText, pattern);\n        System.out.println("KMP Search positions: " + kmpResult);\n        \n        List<Integer> rabinKarpResult = rabinKarp(searchText, pattern);\n        System.out.println("Rabin-Karp positions: " + rabinKarpResult);\n    }\n}\n
27	6	javascript	// STRING REVERSAL\nfunction reverseString(str) {\n    let reversed = "";\n    for (let i = str.length - 1; i >= 0; i--) {\n        reversed += str[i];\n    }\n    return reversed;\n}\n\n// PALINDROME CHECK\nfunction isPalindrome(str) {\n    // Clean string - remove non-alphanumeric and convert to lowercase\n    let cleaned = str.toLowerCase().replace(/[^a-z0-9]/g, '');\n    \n    let left = 0, right = cleaned.length - 1;\n    while (left < right) {\n        if (cleaned[left] !== cleaned[right]) {\n            return false;\n        }\n        left++;\n        right--;\n    }\n    return true;\n}\n\n// ANAGRAM CHECK\nfunction areAnagrams(str1, str2) {\n    if (str1.length !== str2.length) {\n        return false;\n    }\n    \n    let charCount = {};\n    \n    // Count characters in first string\n    for (let char of str1.toLowerCase()) {\n        charCount[char] = (charCount[char] || 0) + 1;\n    }\n    \n    // Subtract characters from second string\n    for (let char of str2.toLowerCase()) {\n        if (!charCount[char]) {\n            return false;\n        }\n        charCount[char]--;\n    }\n    \n    return true;\n}\n\n// NAIVE STRING SEARCH\nfunction naiveSearch(text, pattern) {\n    let positions = [];\n    \n    for (let i = 0; i <= text.length - pattern.length; i++) {\n        let match = true;\n        for (let j = 0; j < pattern.length; j++) {\n            if (text[i + j] !== pattern[j]) {\n                match = false;\n                break;\n            }\n        }\n        if (match) {\n            positions.push(i);\n        }\n    }\n    \n    return positions;\n}\n\n// KMP ALGORITHM - Build LPS array\nfunction buildLPS(pattern) {\n    let lps = new Array(pattern.length).fill(0);\n    let len = 0;\n    let i = 1;\n    \n    while (i < pattern.length) {\n        if (pattern[i] === pattern[len]) {\n            len++;\n            lps[i] = len;\n            i++;\n        } else {\n            if (len !== 0) {\n                len = lps[len - 1];\n            } else {\n                lps[i] = 0;\n                i++;\n            }\n        }\n    }\n    \n    return lps;\n}\n\n// KMP SEARCH\nfunction kmpSearch(text, pattern) {\n    let lps = buildLPS(pattern);\n    let positions = [];\n    let i = 0; // text index\n    let j = 0; // pattern index\n    \n    while (i < text.length) {\n        if (text[i] === pattern[j]) {\n            i++;\n            j++;\n        }\n        \n        if (j === pattern.length) {\n            positions.push(i - j);\n            j = lps[j - 1];\n        } else if (i < text.length && text[i] !== pattern[j]) {\n            if (j !== 0) {\n                j = lps[j - 1];\n            } else {\n                i++;\n            }\n        }\n    }\n    \n    return positions;\n}\n\n// RABIN-KARP ALGORITHM\nfunction rabinKarp(text, pattern) {\n    const prime = 101;\n    const base = 256;\n    let positions = [];\n    let patternHash = 0;\n    let textHash = 0;\n    let h = 1;\n    \n    // Calculate h = base^(pattern.length-1) % prime\n    for (let i = 0; i < pattern.length - 1; i++) {\n        h = (h * base) % prime;\n    }\n    \n    // Calculate initial hash values\n    for (let i = 0; i < pattern.length; i++) {\n        patternHash = (base * patternHash + pattern.charCodeAt(i)) % prime;\n        textHash = (base * textHash + text.charCodeAt(i)) % prime;\n    }\n    \n    // Slide the pattern over text\n    for (let i = 0; i <= text.length - pattern.length; i++) {\n        // Check if hash values match\n        if (patternHash === textHash) {\n            // Verify character by character\n            let match = true;\n            for (let j = 0; j < pattern.length; j++) {\n                if (text[i + j] !== pattern[j]) {\n                    match = false;\n                    break;\n                }\n            }\n            if (match) {\n                positions.push(i);\n            }\n        }\n        \n        // Calculate next hash value\n        if (i < text.length - pattern.length) {\n            textHash = (base * (textHash - text.charCodeAt(i) * h) + text.charCodeAt(i + pattern.length)) % prime;\n            if (textHash < 0) {\n                textHash += prime;\n            }\n        }\n    }\n    \n    return positions;\n}\n\n// DEMONSTRATION\nconsole.log("=== String Operations Demo ===");\n\n// String Reversal\nlet text = "hello";\nconsole.log("Original:", text);\nconsole.log("Reversed:", reverseString(text));\nconsole.log();\n\n// Palindrome Check\nlet palindrome1 = "A man a plan a canal Panama";\nlet palindrome2 = "race a car";\nconsole.log(`'${palindrome1}' is palindrome:`, isPalindrome(palindrome1));\nconsole.log(`'${palindrome2}' is palindrome:`, isPalindrome(palindrome2));\nconsole.log();\n\n// Anagram Check\nlet str1 = "listen", str2 = "silent";\nlet str3 = "hello", str4 = "world";\nconsole.log(`'${str1}' and '${str2}' are anagrams:`, areAnagrams(str1, str2));\nconsole.log(`'${str3}' and '${str4}' are anagrams:`, areAnagrams(str3, str4));\nconsole.log();\n\n// String Searching\nlet searchText = "ababcababa";\nlet pattern = "aba";\n\nconsole.log(`Searching for '${pattern}' in '${searchText}'`);\n\nlet naiveResult = naiveSearch(searchText, pattern);\nconsole.log("Naive Search positions:", naiveResult);\n\nlet kmpResult = kmpSearch(searchText, pattern);\nconsole.log("KMP Search positions:", kmpResult);\n\nlet rabinKarpResult = rabinKarp(searchText, pattern);\nconsole.log("Rabin-Karp positions:", rabinKarpResult);\n\n// Additional string operations\nconsole.log("\\n=== Additional Examples ===");\n\n// Count vowels\nfunction countVowels(str) {\n    let vowels = 'aeiouAEIOU';\n    let count = 0;\n    for (let char of str) {\n        if (vowels.includes(char)) {\n            count++;\n        }\n    }\n    return count;\n}\n\nlet testStr = "Hello World";\nconsole.log(`Vowels in '${testStr}':`, countVowels(testStr));\n\n// Remove duplicates\nfunction removeDuplicates(str) {\n    return [...new Set(str)].join('');\n}\n\nconsole.log(`Remove duplicates from '${testStr}':`, removeDuplicates(testStr));\n
28	6	python	# STRING REVERSAL\ndef reverse_string(s):\n    reversed_str = ""\n    for i in range(len(s) - 1, -1, -1):\n        reversed_str += s[i]\n    return reversed_str\n\n# PALINDROME CHECK\ndef is_palindrome(s):\n    # Clean string - remove non-alphanumeric and convert to lowercase\n    cleaned = ''.join(char.lower() for char in s if char.isalnum())\n    \n    left, right = 0, len(cleaned) - 1\n    while left < right:\n        if cleaned[left] != cleaned[right]:\n            return False\n        left += 1\n        right -= 1\n    return True\n\n# ANAGRAM CHECK\ndef are_anagrams(str1, str2):\n    if len(str1) != len(str2):\n        return False\n    \n    char_count = {}\n    \n    # Count characters in first string\n    for char in str1.lower():\n        char_count[char] = char_count.get(char, 0) + 1\n    \n    # Subtract characters from second string\n    for char in str2.lower():\n        if char not in char_count or char_count[char] == 0:\n            return False\n        char_count[char] -= 1\n    \n    return True\n\n# NAIVE STRING SEARCH\ndef naive_search(text, pattern):\n    positions = []\n    \n    for i in range(len(text) - len(pattern) + 1):\n        match = True\n        for j in range(len(pattern)):\n            if text[i + j] != pattern[j]:\n                match = False\n                break\n        if match:\n            positions.append(i)\n    \n    return positions\n\n# KMP ALGORITHM - Build LPS array\ndef build_lps(pattern):\n    lps = [0] * len(pattern)\n    length = 0\n    i = 1\n    \n    while i < len(pattern):\n        if pattern[i] == pattern[length]:\n            length += 1\n            lps[i] = length\n            i += 1\n        else:\n            if length != 0:\n                length = lps[length - 1]\n            else:\n                lps[i] = 0\n                i += 1\n    \n    return lps\n\n# KMP SEARCH\ndef kmp_search(text, pattern):\n    lps = build_lps(pattern)\n    positions = []\n    i = 0  # text index\n    j = 0  # pattern index\n    \n    while i < len(text):\n        if text[i] == pattern[j]:\n            i += 1\n            j += 1\n        \n        if j == len(pattern):\n            positions.append(i - j)\n            j = lps[j - 1]\n        elif i < len(text) and text[i] != pattern[j]:\n            if j != 0:\n                j = lps[j - 1]\n            else:\n                i += 1\n    \n    return positions\n\n# RABIN-KARP ALGORITHM\ndef rabin_karp(text, pattern):\n    prime = 101\n    base = 256\n    positions = []\n    pattern_hash = 0\n    text_hash = 0\n    h = 1\n    \n    # Calculate h = base^(len(pattern)-1) % prime\n    for i in range(len(pattern) - 1):\n        h = (h * base) % prime\n    \n    # Calculate initial hash values\n    for i in range(len(pattern)):\n        pattern_hash = (base * pattern_hash + ord(pattern[i])) % prime\n        text_hash = (base * text_hash + ord(text[i])) % prime\n    \n    # Slide the pattern over text\n    for i in range(len(text) - len(pattern) + 1):\n        # Check if hash values match\n        if pattern_hash == text_hash:\n            # Verify character by character\n            match = True\n            for j in range(len(pattern)):\n                if text[i + j] != pattern[j]:\n                    match = False\n                    break\n            if match:\n                positions.append(i)\n        \n        # Calculate next hash value\n        if i < len(text) - len(pattern):\n            text_hash = (base * (text_hash - ord(text[i]) * h) + ord(text[i + len(pattern)])) % prime\n            if text_hash < 0:\n                text_hash += prime\n    \n    return positions\n\n# DEMONSTRATION\nprint("=== String Operations Demo ===")\n\n# String Reversal\ntext = "hello"\nprint(f"Original: {text}")\nprint(f"Reversed: {reverse_string(text)}")\nprint()\n\n# Palindrome Check\npalindrome1 = "A man a plan a canal Panama"\npalindrome2 = "race a car"\nprint(f"'{palindrome1}' is palindrome: {is_palindrome(palindrome1)}")\nprint(f"'{palindrome2}' is palindrome: {is_palindrome(palindrome2)}")\nprint()\n\n# Anagram Check\nstr1, str2 = "listen", "silent"\nstr3, str4 = "hello", "world"\nprint(f"'{str1}' and '{str2}' are anagrams: {are_anagrams(str1, str2)}")\nprint(f"'{str3}' and '{str4}' are anagrams: {are_anagrams(str3, str4)}")\nprint()\n\n# String Searching\nsearch_text = "ababcababa"\npattern = "aba"\n\nprint(f"Searching for '{pattern}' in '{search_text}'")\n\nnaive_result = naive_search(search_text, pattern)\nprint(f"Naive Search positions: {naive_result}")\n\nkmp_result = kmp_search(search_text, pattern)\nprint(f"KMP Search positions: {kmp_result}")\n\nrabin_karp_result = rabin_karp(search_text, pattern)\nprint(f"Rabin-Karp positions: {rabin_karp_result}")\n\n# Additional string operations\nprint("\\n=== Additional Examples ===")\n\n# Count vowels\ndef count_vowels(s):\n    vowels = 'aeiouAEIOU'\n    return sum(1 for char in s if char in vowels)\n\ntest_str = "Hello World"\nprint(f"Vowels in '{test_str}': {count_vowels(test_str)}")\n\n# Remove duplicates while preserving order\ndef remove_duplicates(s):\n    seen = set()\n    result = ""\n    for char in s:\n        if char not in seen:\n            seen.add(char)\n            result += char\n    return result\n\nprint(f"Remove duplicates from '{test_str}': {remove_duplicates(test_str)}")\n\n# Find longest common prefix\ndef longest_common_prefix(strs):\n    if not strs:\n        return ""\n    \n    prefix = strs[0]\n    for s in strs[1:]:\n        while not s.startswith(prefix):\n            prefix = prefix[:-1]\n            if not prefix:\n                return ""\n    return prefix\n\nwords = ["flower", "flow", "flight"]\nprint(f"Longest common prefix of {words}: '{longest_common_prefix(words)}'")\n\n# Check if string is subsequence\ndef is_subsequence(s, t):\n    i = 0\n    for char in t:\n        if i < len(s) and s[i] == char:\n            i += 1\n    return i == len(s)\n\nprint(f"Is 'ace' a subsequence of 'abcde': {is_subsequence('ace', 'abcde')}")\nprint(f"Is 'aec' a subsequence of 'abcde': {is_subsequence('aec', 'abcde')}")\n
29	7	cpp	#include <iostream>\n#include <string>\n\n// Node class for Singly Linked List\nclass Node {\npublic:\n    int data;\n    Node* next;\n    \n    // Constructor\n    Node(int data) {\n        this->data = data;\n        this->next = nullptr;\n    }\n};\n\n// Singly Linked List implementation\nclass SinglyLinkedList {\nprivate:\n    Node* head;\n    int size;\n    \npublic:\n    // Constructor\n    SinglyLinkedList() {\n        head = nullptr;\n        size = 0;\n    }\n    \n    // Destructor to free memory\n    ~SinglyLinkedList() {\n        Node* current = head;\n        while (current != nullptr) {\n            Node* temp = current;\n            current = current->next;\n            delete temp;\n        }\n        head = nullptr;\n    }\n    \n    // Add a node to the beginning of the list\n    void insertAtBeginning(int data) {\n        Node* newNode = new Node(data);\n        newNode->next = head;\n        head = newNode;\n        size++;\n    }\n    \n    // Add a node to the end of the list\n    void insertAtEnd(int data) {\n        Node* newNode = new Node(data);\n        \n        // If list is empty\n        if (head == nullptr) {\n            head = newNode;\n        } else {\n            Node* current = head;\n            while (current->next != nullptr) {\n                current = current->next;\n            }\n            current->next = newNode;\n        }\n        \n        size++;\n    }\n    \n    // Remove a node from the beginning\n    int removeFromBeginning() {\n        if (head == nullptr) {\n            return -1; // Indicate empty list\n        }\n        \n        Node* temp = head;\n        int removedData = temp->data;\n        head = head->next;\n        delete temp;\n        size--;\n        \n        return removedData;\n    }\n    \n    // Print all elements of the list\n    void printList() {\n        Node* current = head;\n        std::string result = "";\n        \n        while (current != nullptr) {\n            result += std::to_string(current->data) + " -> ";\n            current = current->next;\n        }\n        \n        std::cout << result << "nullptr" << std::endl;\n    }\n    \n    // Reverse the linked list\n    void reverse() {\n        Node* prev = nullptr;\n        Node* current = head;\n        Node* next = nullptr;\n        \n        while (current != nullptr) {\n            // Store next\n            next = current->next;\n            \n            // Reverse current node's pointer\n            current->next = prev;\n            \n            // Move pointers one position ahead\n            prev = current;\n            current = next;\n        }\n        \n        // Update head\n        head = prev;\n    }\n};\n\nint main() {\n    SinglyLinkedList list;\n    list.insertAtEnd(1);\n    list.insertAtEnd(2);\n    list.insertAtEnd(3);\n    list.insertAtBeginning(0);\n    \n    std::cout << "Original list:" << std::endl;\n    list.printList();  // Output: 0 -> 1 -> 2 -> 3 -> nullptr\n    \n    list.reverse();\n    std::cout << "Reversed list:" << std::endl;\n    list.printList();  // Output: 3 -> 2 -> 1 -> 0 -> nullptr\n    \n    std::cout << "Removed: " << list.removeFromBeginning() << std::endl;  // Output: Removed: 3\n    list.printList();  // Output: 2 -> 1 -> 0 -> nullptr\n    \n    return 0;\n}
30	7	java	public class LinkedListDemo {\n    // Node class for Singly Linked List\n    static class Node {\n        int data;\n        Node next;\n        \n        Node(int data) {\n            this.data = data;\n            this.next = null;\n        }\n    }\n    \n    // Singly Linked List implementation\n    static class SinglyLinkedList {\n        Node head;\n        int size;\n        \n        public SinglyLinkedList() {\n            this.head = null;\n            this.size = 0;\n        }\n        \n        // Add a node to the beginning of the list\n        public void insertAtBeginning(int data) {\n            Node newNode = new Node(data);\n            newNode.next = head;\n            head = newNode;\n            size++;\n        }\n        \n        // Add a node to the end of the list\n        public void insertAtEnd(int data) {\n            Node newNode = new Node(data);\n            \n            // If list is empty\n            if (head == null) {\n                head = newNode;\n            } else {\n                Node current = head;\n                while (current.next != null) {\n                    current = current.next;\n                }\n                current.next = newNode;\n            }\n            \n            size++;\n        }\n        \n        // Remove a node from the beginning\n        public Integer removeFromBeginning() {\n            if (head == null) {\n                return null;\n            }\n            \n            int removedData = head.data;\n            head = head.next;\n            size--;\n            \n            return removedData;\n        }\n        \n        // Print all elements of the list\n        public void printList() {\n            Node current = head;\n            StringBuilder result = new StringBuilder();\n            \n            while (current != null) {\n                result.append(current.data).append(" -> ");\n                current = current.next;\n            }\n            \n            System.out.println(result.append("null"));\n        }\n        \n        // Reverse the linked list\n        public void reverse() {\n            Node prev = null;\n            Node current = head;\n            Node next = null;\n            \n            while (current != null) {\n                // Store next\n                next = current.next;\n                \n                // Reverse current node's pointer\n                current.next = prev;\n                \n                // Move pointers one position ahead\n                prev = current;\n                current = next;\n            }\n            \n            // Update head\n            head = prev;\n        }\n    }\n    \n    public static void main(String[] args) {\n        SinglyLinkedList list = new SinglyLinkedList();\n        list.insertAtEnd(1);\n        list.insertAtEnd(2);\n        list.insertAtEnd(3);\n        list.insertAtBeginning(0);\n        \n        System.out.println("Original list:");\n        list.printList();  // Output: 0 -> 1 -> 2 -> 3 -> null\n        \n        list.reverse();\n        System.out.println("Reversed list:");\n        list.printList();  // Output: 3 -> 2 -> 1 -> 0 -> null\n        \n        System.out.println("Removed: " + list.removeFromBeginning());  // Output: Removed: 3\n        list.printList();  // Output: 2 -> 1 -> 0 -> null\n    }\n}
31	7	javascript	// Node class for Singly Linked List\nclass Node {\n    constructor(data) {\n        this.data = data;\n        this.next = null;\n    }\n}\n\n// Singly Linked List implementation\nclass SinglyLinkedList {\n    constructor() {\n        this.head = null;\n        this.size = 0;\n    }\n    \n    // Add a node to the beginning of the list\n    insertAtBeginning(data) {\n        const newNode = new Node(data);\n        newNode.next = this.head;\n        this.head = newNode;\n        this.size++;\n    }\n    \n    // Add a node to the end of the list\n    insertAtEnd(data) {\n        const newNode = new Node(data);\n        \n        // If list is empty\n        if (!this.head) {\n            this.head = newNode;\n        } else {\n            let current = this.head;\n            while (current.next) {\n                current = current.next;\n            }\n            current.next = newNode;\n        }\n        \n        this.size++;\n    }\n    \n    // Remove a node from the beginning\n    removeFromBeginning() {\n        if (!this.head) {\n            return null;\n        }\n        \n        const removedNode = this.head;\n        this.head = this.head.next;\n        this.size--;\n        \n        return removedNode.data;\n    }\n    \n    // Print all elements of the list\n    printList() {\n        let current = this.head;\n        let result = '';\n        \n        while (current) {\n            result += current.data + ' -> ';\n            current = current.next;\n        }\n        \n        console.log(result + 'null');\n    }\n    \n    // Reverse the linked list\n    reverse() {\n        let prev = null;\n        let current = this.head;\n        let next = null;\n        \n        while (current) {\n            // Store next\n            next = current.next;\n            \n            // Reverse current node's pointer\n            current.next = prev;\n            \n            // Move pointers one position ahead\n            prev = current;\n            current = next;\n        }\n        \n        // Update head\n        this.head = prev;\n    }\n}\n\n// Example usage\nconst list = new SinglyLinkedList();\nlist.insertAtEnd(1);\nlist.insertAtEnd(2);\nlist.insertAtEnd(3);\nlist.insertAtBeginning(0);\nconsole.log("Original list:");\nlist.printList();  // Output: 0 -> 1 -> 2 -> 3 -> null\n\nlist.reverse();\nconsole.log("Reversed list:");\nlist.printList();  // Output: 3 -> 2 -> 1 -> 0 -> null\n\nconsole.log("Removed:", list.removeFromBeginning());  // Output: Removed: 3\nlist.printList();  // Output: 2 -> 1 -> 0 -> null
33	8	cpp	#include <iostream>\n#include <vector>\n#include <string>\n\nclass Stack {\nprivate:\n    std::vector<int> items;\n    \npublic:\n    // Add element to the top of the stack\n    void push(int item) {\n        items.push_back(item);\n    }\n    \n    // Remove and return the top element\n    std::string pop() {\n        if (isEmpty()) {\n            return "Stack is empty";\n        }\n        \n        int topItem = items.back();\n        items.pop_back();\n        return std::to_string(topItem);\n    }\n    \n    // Return the top element without removing it\n    std::string peek() {\n        if (isEmpty()) {\n            return "Stack is empty";\n        }\n        return std::to_string(items.back());\n    }\n    \n    // Check if stack is empty\n    bool isEmpty() {\n        return items.empty();\n    }\n    \n    // Return the size of the stack\n    int size() {\n        return items.size();\n    }\n    \n    // Print the stack elements\n    void printStack() {\n        for (int item : items) {\n            std::cout << item << " ";\n        }\n        std::cout << std::endl;\n    }\n};\n\nint main() {\n    Stack stack;\n    \n    std::cout << "Is stack empty? " << (stack.isEmpty() ? "true" : "false") << std::endl;  // true\n    \n    stack.push(10);\n    stack.push(20);\n    stack.push(30);\n    \n    std::cout << "Stack after pushing elements:" << std::endl;\n    stack.printStack();  // 10 20 30\n    \n    std::cout << "Top element: " << stack.peek() << std::endl;  // 30\n    std::cout << "Stack size: " << stack.size() << std::endl;  // 3\n    \n    std::cout << "Popped element: " << stack.pop() << std::endl;  // 30\n    \n    std::cout << "Stack after popping:" << std::endl;\n    stack.printStack();  // 10 20\n    \n    return 0;\n}
34	8	java	import java.util.ArrayList;\n\npublic class StackDemo {\n    static class Stack {\n        private ArrayList<Integer> items;\n        \n        public Stack() {\n            this.items = new ArrayList<>();\n        }\n        \n        // Add element to the top of the stack\n        public void push(int item) {\n            items.add(item);\n        }\n        \n        // Remove and return the top element\n        public String pop() {\n            if (isEmpty()) {\n                return "Stack is empty";\n            }\n            return String.valueOf(items.remove(items.size() - 1));\n        }\n        \n        // Return the top element without removing it\n        public String peek() {\n            if (isEmpty()) {\n                return "Stack is empty";\n            }\n            return String.valueOf(items.get(items.size() - 1));\n        }\n        \n        // Check if stack is empty\n        public boolean isEmpty() {\n            return items.size() == 0;\n        }\n        \n        // Return the size of the stack\n        public int size() {\n            return items.size();\n        }\n        \n        // Print the stack elements\n        public void printStack() {\n            StringBuilder sb = new StringBuilder();\n            for (int item : items) {\n                sb.append(item).append(" ");\n            }\n            System.out.println(sb.toString());\n        }\n    }\n    \n    public static void main(String[] args) {\n        Stack stack = new Stack();\n        \n        System.out.println("Is stack empty? " + stack.isEmpty());  // true\n        \n        stack.push(10);\n        stack.push(20);\n        stack.push(30);\n        \n        System.out.println("Stack after pushing elements:");\n        stack.printStack();  // 10 20 30\n        \n        System.out.println("Top element: " + stack.peek());  // 30\n        System.out.println("Stack size: " + stack.size());  // 3\n        \n        System.out.println("Popped element: " + stack.pop());  // 30\n        \n        System.out.println("Stack after popping:");\n        stack.printStack();  // 10 20\n    }\n}
35	8	javascript	class Stack {\n    constructor() {\n        this.items = [];\n    }\n    \n    // Add element to the top of the stack\n    push(element) {\n        this.items.push(element);\n    }\n    \n    // Remove and return the top element\n    pop() {\n        if (this.isEmpty()) {\n            return "Stack is empty";\n        }\n        return this.items.pop();\n    }\n    \n    // Return the top element without removing it\n    peek() {\n        if (this.isEmpty()) {\n            return "Stack is empty";\n        }\n        return this.items[this.items.length - 1];\n    }\n    \n    // Check if stack is empty\n    isEmpty() {\n        return this.items.length === 0;\n    }\n    \n    // Return the size of the stack\n    size() {\n        return this.items.length;\n    }\n    \n    // Print the stack elements\n    printStack() {\n        let str = "";\n        for (let i = 0; i < this.items.length; i++) {\n            str += this.items[i] + " ";\n        }\n        console.log(str);\n    }\n}\n\n// Example usage\nconst stack = new Stack();\n\nconsole.log("Is stack empty? " + stack.isEmpty()); // true\n\nstack.push(10);\nstack.push(20);\nstack.push(30);\n\nconsole.log("Stack after pushing elements:");\nstack.printStack(); // 10 20 30\n\nconsole.log("Top element: " + stack.peek()); // 30\nconsole.log("Stack size: " + stack.size()); // 3\n\nconsole.log("Popped element: " + stack.pop()); // 30\n\nconsole.log("Stack after popping:");\nstack.printStack(); // 10 20
36	8	python	class Stack:\n    def __init__(self):\n        self.items = []\n    \n    # Add element to the top of the stack\n    def push(self, item):\n        self.items.append(item)\n    \n    # Remove and return the top element\n    def pop(self):\n        if self.is_empty():\n            return "Stack is empty"\n        return self.items.pop()\n    \n    # Return the top element without removing it\n    def peek(self):\n        if self.is_empty():\n            return "Stack is empty"\n        return self.items[-1]\n    \n    # Check if stack is empty\n    def is_empty(self):\n        return len(self.items) == 0\n    \n    # Return the size of the stack\n    def size(self):\n        return len(self.items)\n    \n    # Print the stack elements\n    def print_stack(self):\n        print(' '.join(str(item) for item in self.items))\n\n\n# Example usage\nif __name__ == "__main__":\n    stack = Stack()\n    \n    print("Is stack empty?", stack.is_empty())  # True\n    \n    stack.push(10)\n    stack.push(20)\n    stack.push(30)\n    \n    print("Stack after pushing elements:")\n    stack.print_stack()  # 10 20 30\n    \n    print("Top element:", stack.peek())  # 30\n    print("Stack size:", stack.size())  # 3\n    \n    print("Popped element:", stack.pop())  # 30\n    \n    print("Stack after popping:")\n    stack.print_stack()  # 10 20
37	9	cpp	#include <iostream>\n#include <vector>\n#include <string>\n\nclass Queue {\nprivate:\n    std::vector<int> items;\n    \npublic:\n    // Add element to the rear of the queue\n    void enqueue(int item) {\n        items.push_back(item);\n    }\n    \n    // Remove and return the front element\n    std::string dequeue() {\n        if (isEmpty()) {\n            return "Queue is empty";\n        }\n        \n        int frontItem = items[0];\n        items.erase(items.begin());\n        return std::to_string(frontItem);\n    }\n    \n    // Return the front element without removing it\n    std::string front() {\n        if (isEmpty()) {\n            return "Queue is empty";\n        }\n        return std::to_string(items[0]);\n    }\n    \n    // Check if queue is empty\n    bool isEmpty() {\n        return items.empty();\n    }\n    \n    // Return the size of the queue\n    int size() {\n        return items.size();\n    }\n    \n    // Print the queue elements\n    void printQueue() {\n        for (int item : items) {\n            std::cout << item << " ";\n        }\n        std::cout << std::endl;\n    }\n};\n\nint main() {\n    Queue queue;\n    \n    std::cout << "Is queue empty? " << (queue.isEmpty() ? "true" : "false") << std::endl;  // true\n    \n    queue.enqueue(10);\n    queue.enqueue(20);\n    queue.enqueue(30);\n    \n    std::cout << "Queue after enqueueing elements:" << std::endl;\n    queue.printQueue();  // 10 20 30\n    \n    std::cout << "Front element: " << queue.front() << std::endl;  // 10\n    std::cout << "Queue size: " << queue.size() << std::endl;  // 3\n    \n    std::cout << "Dequeued element: " << queue.dequeue() << std::endl;  // 10\n    \n    std::cout << "Queue after dequeueing:" << std::endl;\n    queue.printQueue();  // 20 30\n    \n    return 0;\n}
38	9	java	import java.util.ArrayList;\n\npublic class QueueDemo {\n    static class Queue {\n        private ArrayList<Integer> items;\n        \n        public Queue() {\n            this.items = new ArrayList<>();\n        }\n        \n        // Add element to the rear of the queue\n        public void enqueue(int item) {\n            items.add(item);\n        }\n        \n        // Remove and return the front element\n        public String dequeue() {\n            if (isEmpty()) {\n                return "Queue is empty";\n            }\n            return String.valueOf(items.remove(0));\n        }\n        \n        // Return the front element without removing it\n        public String front() {\n            if (isEmpty()) {\n                return "Queue is empty";\n            }\n            return String.valueOf(items.get(0));\n        }\n        \n        // Check if queue is empty\n        public boolean isEmpty() {\n            return items.size() == 0;\n        }\n        \n        // Return the size of the queue\n        public int size() {\n            return items.size();\n        }\n        \n        // Print the queue elements\n        public void printQueue() {\n            StringBuilder sb = new StringBuilder();\n            for (int item : items) {\n                sb.append(item).append(" ");\n            }\n            System.out.println(sb.toString());\n        }\n    }\n    \n    public static void main(String[] args) {\n        Queue queue = new Queue();\n        \n        System.out.println("Is queue empty? " + queue.isEmpty());  // true\n        \n        queue.enqueue(10);\n        queue.enqueue(20);\n        queue.enqueue(30);\n        \n        System.out.println("Queue after enqueueing elements:");\n        queue.printQueue();  // 10 20 30\n        \n        System.out.println("Front element: " + queue.front());  // 10\n        System.out.println("Queue size: " + queue.size());  // 3\n        \n        System.out.println("Dequeued element: " + queue.dequeue());  // 10\n        \n        System.out.println("Queue after dequeueing:");\n        queue.printQueue();  // 20 30\n    }\n}
39	9	javascript	class Queue {\n    constructor() {\n        this.items = [];\n    }\n    \n    // Add element to the rear of the queue\n    enqueue(element) {\n        this.items.push(element);\n    }\n    \n    // Remove and return the front element\n    dequeue() {\n        if (this.isEmpty()) {\n            return "Queue is empty";\n        }\n        return this.items.shift();\n    }\n    \n    // Return the front element without removing it\n    front() {\n        if (this.isEmpty()) {\n            return "Queue is empty";\n        }\n        return this.items[0];\n    }\n    \n    // Check if queue is empty\n    isEmpty() {\n        return this.items.length === 0;\n    }\n    \n    // Return the size of the queue\n    size() {\n        return this.items.length;\n    }\n    \n    // Print the queue elements\n    printQueue() {\n        let str = "";\n        for (let i = 0; i < this.items.length; i++) {\n            str += this.items[i] + " ";\n        }\n        console.log(str);\n    }\n}\n\n// Example usage\nconst queue = new Queue();\n\nconsole.log("Is queue empty? " + queue.isEmpty()); // true\n\nqueue.enqueue(10);\nqueue.enqueue(20);\nqueue.enqueue(30);\n\nconsole.log("Queue after enqueueing elements:");\nqueue.printQueue(); // 10 20 30\n\nconsole.log("Front element: " + queue.front()); // 10\nconsole.log("Queue size: " + queue.size()); // 3\n\nconsole.log("Dequeued element: " + queue.dequeue()); // 10\n\nconsole.log("Queue after dequeueing:");\nqueue.printQueue(); // 20 30
40	9	python	class Queue:\n    def __init__(self):\n        self.items = []\n    \n    # Add element to the rear of the queue\n    def enqueue(self, item):\n        self.items.append(item)\n    \n    # Remove and return the front element\n    def dequeue(self):\n        if self.is_empty():\n            return "Queue is empty"\n        return self.items.pop(0)\n    \n    # Return the front element without removing it\n    def front(self):\n        if self.is_empty():\n            return "Queue is empty"\n        return self.items[0]\n    \n    # Check if queue is empty\n    def is_empty(self):\n        return len(self.items) == 0\n    \n    # Return the size of the queue\n    def size(self):\n        return len(self.items)\n    \n    # Print the queue elements\n    def print_queue(self):\n        print(' '.join(str(item) for item in self.items))\n\n\n# Example usage\nif __name__ == "__main__":\n    queue = Queue()\n    \n    print("Is queue empty?", queue.is_empty())  # True\n    \n    queue.enqueue(10)\n    queue.enqueue(20)\n    queue.enqueue(30)\n    \n    print("Queue after enqueueing elements:")\n    queue.print_queue()  # 10 20 30\n    \n    print("Front element:", queue.front())  # 10\n    print("Queue size:", queue.size())  # 3\n    \n    print("Dequeued element:", queue.dequeue())  # 10\n    \n    print("Queue after dequeueing:")\n    queue.print_queue()  # 20 30
\.


--
-- Data for Name: topics; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.topics (id, title, slug, section, difficulty, markdown, diagrams, xp) FROM stdin;
4	Object-Oriented Programming	object-oriented-programming	core	medium	# Object-Oriented Programming: Modeling Real-World Solutions\n\n## What is Object-Oriented Programming?\n\nObject-Oriented Programming (OOP) is a programming paradigm that organizes code around objects and classes rather than functions and logic. It models real-world entities as objects that have properties (attributes) and behaviors (methods), making code more intuitive, reusable, and maintainable.\n\n## Core Principles of OOP\n\n### Encapsulation\nBundling data and methods that operate on that data within a single unit (class), and controlling access to them.\n\n```javascript\nclass BankAccount {\n    constructor(accountNumber, balance) {\n        this.accountNumber = accountNumber;\n        this.balance = balance; // Private data\n    }\n    \n    deposit(amount) {\n        this.balance += amount;\n    }\n    \n    getBalance() {\n        return this.balance; // Controlled access\n    }\n}\n```\n\n### Inheritance\nCreating new classes based on existing classes, inheriting their properties and methods.\n\n```javascript\nclass Animal {\n    constructor(name) {\n        this.name = name;\n    }\n    \n    speak() {\n        console.log(`${this.name} makes a sound`);\n    }\n}\n\nclass Dog extends Animal {\n    speak() {\n        console.log(`${this.name} barks`);\n    }\n}\n```\n\n### Polymorphism\nThe ability of different classes to be treated as instances of the same type through a common interface.\n\n```javascript\nfunction makeAnimalSpeak(animal) {\n    animal.speak(); // Same method, different behavior\n}\n\nlet dog = new Dog("Buddy");\nlet cat = new Cat("Whiskers");\nmakeAnimalSpeak(dog); // "Buddy barks"\nmakeAnimalSpeak(cat); // "Whiskers meows"\n```\n\n### Abstraction\nHiding complex implementation details and showing only essential features of an object.\n\n```javascript\nclass Car {\n    start() {\n        this.igniteEngine();\n        this.engageTransmission();\n        // Complex internal processes hidden\n    }\n    \n    // Private methods (implementation details)\n    igniteEngine() { /* complex logic */ }\n    engageTransmission() { /* complex logic */ }\n}\n```\n\n## Real-Life Applications\n\n- **Software Architecture**: Building large applications with modular, maintainable code structures where each class represents a specific component or service with clear responsibilities.\n\n- **Game Development**: Creating game entities like players, enemies, and items as objects with their own properties and behaviors, enabling complex interactions and easy content expansion.\n\n- **Database Systems**: Modeling real-world entities like customers, orders, and products as objects that map directly to database tables, simplifying data management and relationships.\n\n- **User Interface Development**: Creating reusable UI components like buttons, forms, and menus as objects that can be easily customized and instantiated throughout an application.\n\n## Best Practices\n\n### Class Design\nDesign classes to represent real-world entities with clear responsibilities.\n\n```javascript\n// Good: Clear, single responsibility\nclass User {\n    constructor(name, email) {\n        this.name = name;\n        this.email = email;\n    }\n    \n    updateProfile(newName, newEmail) {\n        this.name = newName;\n        this.email = newEmail;\n    }\n}\n\n// Good: Separate concerns\nclass EmailService {\n    sendEmail(user, message) {\n        // Email sending logic\n    }\n}\n```\n\n### Favor Composition over Deep Inheritance\nUse composition to build complex objects from simpler ones.\n\n```javascript\nclass Engine {\n    start() { console.log("Engine started"); }\n}\n\nclass Car {\n    constructor() {\n        this.engine = new Engine(); // Composition\n    }\n    \n    start() {\n        this.engine.start();\n    }\n}\n```\n\n## The Power of Object-Oriented Design\n\nOOP transforms the way we think about programming by encouraging us to model software after real-world concepts. This approach leads to more intuitive, scalable, and maintainable applications. By organizing code into objects that interact with each other, we create systems that are easier to understand, debug, and extend over time.\n	\N	80
1	Loops	loops	core	easy	# Loops: The Power of Repetition in Programming\n\n## What are Loops?\n\nLoops are programming constructs that execute a block of code repeatedly until a specific condition is met. They eliminate repetitive code and make programs more efficient.\n\n## Types of Loops\n\n### For Loops\nUsed when you know exactly how many times to repeat something.\n\n```javascript\nfor (let i = 1; i <= 10; i++) {\n    console.log(i);\n}\n```\n\n### While Loops  \nUsed when you need to repeat until a condition changes.\n\n```javascript\nlet userInput = "";\nwhile (userInput !== "quit") {\n    userInput = prompt("Enter command (or 'quit' to exit): ");\n    if (userInput !== "quit") {\n        console.log(`Processing: ${userInput}`);\n    }\n}\n```\n\n### Do-While Loops\nSimilar to while loops, but runs at least once before checking the condition.\n\n```javascript\nlet userChoice;\ndo {\n    console.log("Menu:");\n    console.log("1. Option A");\n    console.log("2. Exit");\n    userChoice = prompt("Enter choice: ");\n    \n    if (userChoice === "1") {\n        console.log("You selected Option A");\n    }\n} while (userChoice !== "2");\n```\n\n## Real-Life Applications\n\n- **Gaming**: Continuously checking player input for character movement, updating game physics, and cycling through animation frames to create smooth gameplay experiences.\n\n- **Web Development**: Monitoring user interactions like clicks and form submissions, processing database queries to display search results, and handling real-time features like chat messages.\n\n- **Data Science**: Processing thousands of records for data cleaning, training machine learning algorithms through multiple iterations, and running statistical calculations across large datasets.\n\n- **Financial Technology**: Handling continuous transaction processing, monitoring real-time stock prices and market data, and executing automated trading orders based on specific conditions.\n\n## Best Practices\n\n### Avoiding Infinite Loops\nAlways ensure your loops have proper exit conditions.\n\n```javascript\nlet counter = 0;\nwhile (condition) {\n    // Do something\n    counter++;\n    if (counter > 1000) {\n        break; // Safety exit\n    }\n}\n```\n\n### Performance Optimization\nConsider the computational cost, especially with nested loops.\n\n```javascript\n// This runs n² times - be careful with large datasets!\nfor (let i = 0; i < n; i++) {\n    for (let j = 0; j < n; j++) {\n        // Processing here\n    }\n}\n```\n\n## The Power of Iteration\n\nLoops transform repetitive tasks into automated solutions. They're essential for processing data, creating interactive programs, and building scalable applications. Master loops, and you'll solve complex problems with elegant, efficient	{{loop-flowchart.png,"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMMAAAGKCAYAAACxX/W6AAAAAXNSR0IArs4c6QAAF0J0RVh0bXhmaWxlACUzQ214ZmlsZSUyMGhvc3QlM0QlMjJFbGVjdHJvbiUyMiUyMGFnZW50JTNEJTIyTW96aWxsYSUyRjUuMCUyMChYMTElM0IlMjBMaW51eCUyMHg4Nl82NCklMjBBcHBsZVdlYktpdCUyRjUzNy4zNiUyMChLSFRNTCUyQyUyMGxpa2UlMjBHZWNrbyklMjBkcmF3LmlvJTJGMjcuMC45JTIwQ2hyb21lJTJGMTM0LjAuNjk5OC4yMDUlMjBFbGVjdHJvbiUyRjM1LjQuMCUyMFNhZmFyaSUyRjUzNy4zNiUyMiUyMHZlcnNpb24lM0QlMjIyNy4wLjklMjIlMjBzY2FsZSUzRCUyMjElMjIlMjBib3JkZXIlM0QlMjIwJTIyJTNFJTBBJTIwJTIwJTNDZGlhZ3JhbSUyMG5hbWUlM0QlMjJQYWdlLTElMjIlMjBpZCUzRCUyMk14ZmVsV0owOS04SnpHaUtBQkVZJTIyJTNFJTBBJTIwJTIwJTIwJTIwJTNDbXhHcmFwaE1vZGVsJTIwZHglM0QlMjI4MTUlMjIlMjBkeSUzRCUyMjQ4MiUyMiUyMGdyaWQlM0QlMjIwJTIyJTIwZ3JpZFNpemUlM0QlMjIxMCUyMiUyMGd1aWRlcyUzRCUyMjElMjIlMjB0b29sdGlwcyUzRCUyMjElMjIlMjBjb25uZWN0JTNEJTIyMSUyMiUyMGFycm93cyUzRCUyMjElMjIlMjBmb2xkJTNEJTIyMSUyMiUyMHBhZ2UlM0QlMjIxJTIyJTIwcGFnZVNjYWxlJTNEJTIyMSUyMiUyMHBhZ2VXaWR0aCUzRCUyMjg1MCUyMiUyMHBhZ2VIZWlnaHQlM0QlMjIxMTAwJTIyJTIwbWF0aCUzRCUyMjAlMjIlMjBzaGFkb3clM0QlMjIwJTIyJTNFJTBBJTIwJTIwJTIwJTIwJTIwJTIwJTNDcm9vdCUzRSUwQSUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUzQ214Q2VsbCUyMGlkJTNEJTIyMCUyMiUyMCUyRiUzRSUwQSUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUzQ214Q2VsbCUyMGlkJTNEJTIyMSUyMiUyMHBhcmVudCUzRCUyMjAlMjIlMjAlMkYlM0UlMEElMjAlMjAlMjAlMjAlMjAlMjAlMjAlMjAlM0NteENlbGwlMjBpZCUzRCUyMmtGZHBMNGljcGE5dDR5VzdSdlNpLTUlMjIlMjB2YWx1ZSUzRCUyMiUyMiUyMHN0eWxlJTNEJTIyZWRnZVN0eWxlJTNEb3J0aG9nb25hbEVkZ2VTdHlsZSUzQnJvdW5kZWQlM0QwJTNCb3J0aG9nb25hbExvb3AlM0QxJTNCamV0dHlTaXplJTNEYXV0byUzQmh0bWwlM0QxJTNCJTIyJTIwZWRnZSUzRCUyMjElMjIlMjBwYXJlbnQlM0QlMjIxJTIyJTIwc291cmNlJTNEJTIya0ZkcEw0aWNwYTl0NHlXN1J2U2ktMSUyMiUyMHRhcmdldCUzRCUyMmtGZHBMNGljcGE5dDR5VzdSdlNpLTIlMjIlM0UlMEElMjAlMjAlMjAlMjAlMjAlMjAlMjAlMjAlMjAlMjAlM0NteEdlb21ldHJ5JTIwcmVsYXRpdmUlM0QlMjIxJTIyJTIwYXMlM0QlMjJnZW9tZXRyeSUyMiUyMCUyRiUzRSUwQSUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUzQyUyRm14Q2VsbCUzRSUwQSUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUzQ214Q2VsbCUyMGlkJTNEJTIya0ZkcEw0aWNwYTl0NHlXN1J2U2ktMSUyMiUyMHZhbHVlJTNEJTIyU3RhcnQlMjBMb29wJTIyJTIwc3R5bGUlM0QlMjJyb3VuZGVkJTNEMSUzQndoaXRlU3BhY2UlM0R3cmFwJTNCaHRtbCUzRDElM0IlMjIlMjB2ZXJ0ZXglM0QlMjIxJTIyJTIwcGFyZW50JTNEJTIyMSUyMiUzRSUwQSUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUzQ214R2VvbWV0cnklMjB4JTNEJTIyMzM5JTIyJTIweSUzRCUyMjExMSUyMiUyMHdpZHRoJTNEJTIyMTUyJTIyJTIwaGVpZ2h0JTNEJTIyMjklMjIlMjBhcyUzRCUyMmdlb21ldHJ5JTIyJTIwJTJGJTNFJTBBJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTNDJTJGbXhDZWxsJTNFJTBBJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTNDbXhDZWxsJTIwaWQlM0QlMjJrRmRwTDRpY3BhOXQ0eVc3UnZTaS02JTIyJTIwdmFsdWUlM0QlMjIlMjIlMjBzdHlsZSUzRCUyMmVkZ2VTdHlsZSUzRG9ydGhvZ29uYWxFZGdlU3R5bGUlM0Jyb3VuZGVkJTNEMCUzQm9ydGhvZ29uYWxMb29wJTNEMSUzQmpldHR5U2l6ZSUzRGF1dG8lM0JodG1sJTNEMSUzQiUyMiUyMGVkZ2UlM0QlMjIxJTIyJTIwcGFyZW50JTNEJTIyMSUyMiUyMHNvdXJjZSUzRCUyMmtGZHBMNGljcGE5dDR5VzdSdlNpLTIlMjIlMjB0YXJnZXQlM0QlMjJrRmRwTDRpY3BhOXQ0eVc3UnZTaS00JTIyJTNFJTBBJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTNDbXhHZW9tZXRyeSUyMHJlbGF0aXZlJTNEJTIyMSUyMiUyMGFzJTNEJTIyZ2VvbWV0cnklMjIlMjAlMkYlM0UlMEElMjAlMjAlMjAlMjAlMjAlMjAlMjAlMjAlM0MlMkZteENlbGwlM0UlMEElMjAlMjAlMjAlMjAlMjAlMjAlMjAlMjAlM0NteENlbGwlMjBpZCUzRCUyMmtGZHBMNGljcGE5dDR5VzdSdlNpLTIlMjIlMjB2YWx1ZSUzRCUyMkV4ZWN1dGUlMjBDb2RlJTIyJTIwc3R5bGUlM0QlMjJyb3VuZGVkJTNEMSUzQndoaXRlU3BhY2UlM0R3cmFwJTNCaHRtbCUzRDElM0IlMjIlMjB2ZXJ0ZXglM0QlMjIxJTIyJTIwcGFyZW50JTNEJTIyMSUyMiUzRSUwQSUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUzQ214R2VvbWV0cnklMjB4JTNEJTIyMzM5JTIyJTIweSUzRCUyMjE5MiUyMiUyMHdpZHRoJTNEJTIyMTUyJTIyJTIwaGVpZ2h0JTNEJTIyMjklMjIlMjBhcyUzRCUyMmdlb21ldHJ5JTIyJTIwJTJGJTNFJTBBJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTNDJTJGbXhDZWxsJTNFJTBBJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTNDbXhDZWxsJTIwaWQlM0QlMjJrRmRwTDRpY3BhOXQ0eVc3UnZTaS0zJTIyJTIwdmFsdWUlM0QlMjJFbmQlMjBMb29wJTIyJTIwc3R5bGUlM0QlMjJyb3VuZGVkJTNEMSUzQndoaXRlU3BhY2UlM0R3cmFwJTNCaHRtbCUzRDElM0IlMjIlMjB2ZXJ0ZXglM0QlMjIxJTIyJTIwcGFyZW50JTNEJTIyMSUyMiUzRSUwQSUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUzQ214R2VvbWV0cnklMjB4JTNEJTIyMzM5JTIyJTIweSUzRCUyMjQ3NSUyMiUyMHdpZHRoJTNEJTIyMTUyJTIyJTIwaGVpZ2h0JTNEJTIyMjklMjIlMjBhcyUzRCUyMmdlb21ldHJ5JTIyJTIwJTJGJTNFJTBBJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTNDJTJGbXhDZWxsJTNFJTBBJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTNDbXhDZWxsJTIwaWQlM0QlMjJrRmRwTDRpY3BhOXQ0eVc3UnZTaS03JTIyJTIwc3R5bGUlM0QlMjJlZGdlU3R5bGUlM0RvcnRob2dvbmFsRWRnZVN0eWxlJTNCcm91bmRlZCUzRDAlM0JvcnRob2dvbmFsTG9vcCUzRDElM0JqZXR0eVNpemUlM0RhdXRvJTNCaHRtbCUzRDElM0JlbnRyeVglM0QxJTNCZW50cnlZJTNEMC41JTNCZW50cnlEeCUzRDAlM0JlbnRyeUR5JTNEMCUzQmV4aXRYJTNEMSUzQmV4aXRZJTNEMC41JTNCZXhpdER4JTNEMCUzQmV4aXREeSUzRDAlM0IlMjIlMjBlZGdlJTNEJTIyMSUyMiUyMHBhcmVudCUzRCUyMjElMjIlMjBzb3VyY2UlM0QlMjJrRmRwTDRpY3BhOXQ0eVc3UnZTaS00JTIyJTIwdGFyZ2V0JTNEJTIya0ZkcEw0aWNwYTl0NHlXN1J2U2ktMiUyMiUzRSUwQSUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUzQ214R2VvbWV0cnklMjByZWxhdGl2ZSUzRCUyMjElMjIlMjBhcyUzRCUyMmdlb21ldHJ5JTIyJTNFJTBBJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTNDQXJyYXklMjBhcyUzRCUyMnBvaW50cyUyMiUzRSUwQSUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUzQ214UG9pbnQlMjB4JTNEJTIyNTI0JTIyJTIweSUzRCUyMjM1MSUyMiUyMCUyRiUzRSUwQSUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUzQ214UG9pbnQlMjB4JTNEJTIyNTI0JTIyJTIweSUzRCUyMjIwNyUyMiUyMCUyRiUzRSUwQSUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUzQyUyRkFycmF5JTNFJTBBJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTNDJTJGbXhHZW9tZXRyeSUzRSUwQSUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUzQyUyRm14Q2VsbCUzRSUwQSUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUzQ214Q2VsbCUyMGlkJTNEJTIya0ZkcEw0aWNwYTl0NHlXN1J2U2ktOCUyMiUyMHZhbHVlJTNEJTIyJTIyJTIwc3R5bGUlM0QlMjJlZGdlU3R5bGUlM0RvcnRob2dvbmFsRWRnZVN0eWxlJTNCcm91bmRlZCUzRDAlM0JvcnRob2dvbmFsTG9vcCUzRDElM0JqZXR0eVNpemUlM0RhdXRvJTNCaHRtbCUzRDElM0IlMjIlMjBlZGdlJTNEJTIyMSUyMiUyMHBhcmVudCUzRCUyMjElMjIlMjBzb3VyY2UlM0QlMjJrRmRwTDRpY3BhOXQ0eVc3UnZTaS00JTIyJTIwdGFyZ2V0JTNEJTIya0ZkcEw0aWNwYTl0NHlXN1J2U2ktMyUyMiUzRSUwQSUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUyMCUzQ214R2VvbWV0cnklMjByZWxhdGl2ZSUzRCUyMjElMjIlMjBhcyUzRCUyMmdlb21ldHJ5JTIyJTIwJTJGJTNFJTBBJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTNDJTJGbXhDZWxsJTNFJTBBJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTNDbXhDZWxsJTIwaWQlM0QlMjJrRmRwTDRpY3BhOXQ0eVc3UnZTaS00JTIyJTIwdmFsdWUlM0QlMjJMb29wJTI2YW1wJTNCbmJzcCUzQiUyNmx0JTNCZGl2JTI2Z3QlM0JDb25kaXRpb24lMjZsdCUzQiUyRmRpdiUyNmd0JTNCJTI2bHQlM0JkaXYlMjZndCUzQlRydWUlMjZsdCUzQiUyRmRpdiUyNmd0JTNCJTIyJTIwc3R5bGUlM0QlMjJyaG9tYnVzJTNCd2hpdGVTcGFjZSUzRHdyYXAlM0JodG1sJTNEMSUzQiUyMiUyMHZlcnRleCUzRCUyMjElMjIlMjBwYXJlbnQlM0QlMjIxJTIyJTNFJTBBJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTNDbXhHZW9tZXRyeSUyMHglM0QlMjIzNTglMjIlMjB5JTNEJTIyMjk4JTIyJTIwd2lkdGglM0QlMjIxMTQlMjIlMjBoZWlnaHQlM0QlMjIxMDYlMjIlMjBhcyUzRCUyMmdlb21ldHJ5JTIyJTIwJTJGJTNFJTBBJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTNDJTJGbXhDZWxsJTNFJTBBJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTNDbXhDZWxsJTIwaWQlM0QlMjJrRmRwTDRpY3BhOXQ0eVc3UnZTaS05JTIyJTIwdmFsdWUlM0QlMjJZZXMlMjIlMjBzdHlsZSUzRCUyMnRleHQlM0JodG1sJTNEMSUzQmFsaWduJTNEY2VudGVyJTNCdmVydGljYWxBbGlnbiUzRG1pZGRsZSUzQnJlc2l6YWJsZSUzRDAlM0Jwb2ludHMlM0QlNUIlNUQlM0JhdXRvc2l6ZSUzRDElM0JzdHJva2VDb2xvciUzRG5vbmUlM0JmaWxsQ29sb3IlM0Rub25lJTNCJTIyJTIwdmVydGV4JTNEJTIyMSUyMiUyMHBhcmVudCUzRCUyMjElMjIlM0UlMEElMjAlMjAlMjAlMjAlMjAlMjAlMjAlMjAlMjAlMjAlM0NteEdlb21ldHJ5JTIweCUzRCUyMjQ3MiUyMiUyMHklM0QlMjIzMjclMjIlMjB3aWR0aCUzRCUyMjM4JTIyJTIwaGVpZ2h0JTNEJTIyMjYlMjIlMjBhcyUzRCUyMmdlb21ldHJ5JTIyJTIwJTJGJTNFJTBBJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTIwJTNDJTJGbXhDZWxs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"}}	50
2	Conditional Statements	conditional-statements	core	easy	# Conditional Statements: Making Decisions in Programming\n\n## What are Conditional Statements?\n\nConditional statements are programming constructs that allow your program to make decisions and execute different code blocks based on specific conditions. They enable programs to respond dynamically to different situations and user inputs.\n\n## Types of Conditional Statements\n\n### If Statements\nUsed when you want to execute code only if a condition is true.\n\n```javascript\nif (age >= 18) {\n    console.log("You are eligible to vote");\n}\n```\n\n### If-Else Statements\nUsed when you want to execute one block of code if a condition is true, and another if it's false.\n\n```javascript\nif (temperature > 30) {\n    console.log("It's hot outside");\n} else {\n    console.log("It's not too hot");\n}\n```\n\n### If-Else If-Else Statements\nUsed when you need to check multiple conditions in sequence.\n\n```javascript\nif (score >= 90) {\n    console.log("Grade: A");\n} else if (score >= 80) {\n    console.log("Grade: B");\n} else if (score >= 70) {\n    console.log("Grade: C");\n} else {\n    console.log("Grade: F");\n}\n```\n\n### Switch Statements\nUsed when you need to compare a variable against multiple possible values.\n\n```javascript\nswitch (day) {\n    case 1:\n        console.log("Monday");\n        break;\n    case 2:\n        console.log("Tuesday");\n        break;\n    case 3:\n        console.log("Wednesday");\n        break;\n    default:\n        console.log("Other day");\n}\n```\n\n## Real-Life Applications\n\n- **User Authentication**: Checking if entered credentials are correct to grant or deny access to applications, determining user permissions based on their role or subscription level.\n\n- **E-commerce Systems**: Applying different discounts based on purchase amount or customer loyalty status, calculating shipping costs based on location and product weight.\n\n- **Gaming Logic**: Determining character actions based on player input, checking win/lose conditions, managing different game states like menu, playing, or game over.\n\n- **Form Validation**: Ensuring user inputs meet specific criteria before submission, displaying appropriate error messages for invalid data, guiding users through multi-step processes.\n\n## Best Practices\n\n### Using Comparison Operators\nAlways use appropriate comparison operators for your conditions.\n\n```javascript\n// Equality vs Assignment\nif (x === 5) {  // Correct: comparison\n    // Do something\n}\n\n// Avoid accidental assignment\nif (x = 5) {  // Wrong: assignment instead of comparison\n    // This assigns 5 to x and always evaluates to true\n}\n```\n\n### Avoiding Deep Nesting\nKeep your conditional statements readable by avoiding too many nested levels.\n\n```javascript\n// Instead of deep nesting\nif (user.isLoggedIn) {\n    if (user.hasPermission) {\n        if (user.isActive) {\n            // Do something\n        }\n    }\n}\n\n// Use logical operators\nif (user.isLoggedIn && user.hasPermission && user.isActive) {\n    // Do something\n}\n```\n\n## The Power of Decision Making\n\nConditional statements are the foundation of program logic and decision-making. They transform static code into dynamic, interactive applications that can respond intelligently to different scenarios. Master conditionals, and you'll build programs that can adapt, validate, and guide users through complex workflows with ease.\n	{{decision-making-flowchart.png,"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAXIAAAJLCAYAAAD6uR3xAAAAAXNSR0IArs4c6QAAIABJREFUeF7tvQmYJEW5tn1nz7CJAwJ6WFxYBVEEURQUfkFFweWwCKL4KYLCdA8IAi6IgMOAiCKIIDDdMywCHgXUgzvgBihHQUXAFZTVBVxBGGQZmK4/n+yooaip7q7uyszK5Ynr6muypzNjuSPyqbfeeCMiwmlqBE5nFZZjFgPMosFTiZiV/Oia5N9ZwFOAh4hYBCwi4kEaLEp+dD3KIh5jEYfwwNQK990mYAImsCyByFDaCJzBGizPBoyyAREb0kj+3QDYgAbPJmIgRWZLgD/T4DYibqeR/Ixdz+R29ufeFMtyViZgAhUlUG8hv4CVeYgdiXgt8HLguYlVPXF6KLGy9SMLe8zibv/9PxAs9Ces9DHL/cm/rzRJWSrj90RcS4MreAo/YB+Ut5MJmIAJLCVQPyEf4YXAzjTYmYjtgOWfNB4aPErEHcBty/ysxu3sxeLUxs8lLM99ibW/4dKfBhuF6/WIWKGtrMU0+BERlxFxObP5TWp1cUYmYAKlJVB9IR9hVeB1NNiJiNcD67QJ902JMMKVzOAW9ueuwvTm2azLEjYBXpN8+MDmbXX7M3B5IuqP8F373AvTc66ICeRKoLpCPszzgQ8S8fY2q/tvwHdo8B0e5zLey79yJd5LYefyDBYnH0g7QeIOWnNpdvomAZ9nlE9xILf0UoyfNQETKBeB6gn5AnaMo0LeH/uVZcHCmMBdQ5SI9xUMcVO5umic2jaIWMgWNJZ+22i6iRo0EtfLyQxyZSXa6kaYgAlMSKAaQj6XmTyTvYOAbxEE/O9EnA6cwSD3V34cyIXU4GAiDgGeERjckAj63VzCPB6vPAM30ARqSqD8Qj7MnkR8IkwQqhtvjWO5T2Ex53FIYo3XK53OCizPfnG8+gdamCik8Qhm85V6wXBrTaAeBMor5MNsBZxOlIQNKt1IxMcsVi0DdwF70OCjLZOkP2aAQziA6+sxvN1KE6gHgfIJ+TnM4nE+BcwGVH8tmjma2QwT0ahHt02hlfKlL0hYfTz+4Fs9mTWAs1iJIxyTPgWOvtUECkygXEI+zGuJOB9YO7Y0R4FzmMmHvQKyixGmFaszOZGI/cMHoFaUvpshvtvF077FBEygwATKIeSyKkc4Kfh9ZVPexAz24QB+WWC2xazafLZkgLOBFycVbHAigxzlbzPF7C7XygS6IVB8IR9bRn8JEW8IwrOQQQYtPN107zj3jLlbzgTmBKbf5iH25HAe7iFXP2oCJtAnAsUW8jERv5qIlySuFEViDHJqn1hVr9hhDk/CEzXX0OBaHuLVFvPqdbNbVH0CxRXysTC6q+Ll59sAjwB7Msi3qt8lObdwAbswmnzjWYEGP2Qxr6tl2GbO2F2cCaRJoLhCPszFROwF/BPYiUF+kWbDnVcLgYVsw2jyIamolosYZG/zMQETKA+BYgr5fA5ggAXJVFyDlzHEz8uDtKQ1nc+2DHBN8JkrmuW8krbE1TaB2hEonpAvZFNGE+t7xWTBzyDvq12v9KvBI5wBHJS4smbwQvbn1n5VxeWagAl0T6B4Qj7M94l4NXAXj7JJzv7a7YHDINk58dlxVId2SpSYLQS+BEnsenWTJpcfTvY4XzfZIXIw2WXRyQRMoOAEiiXkC3gBDX6dMIvYltn8OEd+x8aunLnxKlFtLnU18JewTay2AFgl2fcb3gToeDYlXX8jPnzincn2semnrPPvXONWF4v2Px/kV+k3zTmagAmkSaBYQj6c7J1ycCyg8xnkwDQbOkle2rflZ8Dt4RCHO1vufxrwOWBX4HBYGv6YtdBmnf/4SEYYCVsgnMpg0mYnEzCBAhMolpCPJEK6PhGb5XyM2Qfjk+9PAt4DnNuhvxTNoeiZ74cDHaprkatlw2xBxI3A7xlMTihyMgETKDCB4gj5CM8Dfpcs/BlkZs4rN7UJl7Z93S9Y35267L3BrTI/uFna/cfaA1xir6RzOI+PXS8vifNbL/y/LP4TYpdMawSOLH1Z3v8VH8p8CiT7oBwZ/m+i/LMdUmNnieqQ6RksYUMOTD5gnUzABApKoDhCvoC30eCLwG8YZLOceb0Zkr26NbkpP/mFkAjZeEnHrL0RkogaTYTKl39RWLikw51/Gov2csmEIfw97GuiNi2CpG1/Chk3hfyz8e/y0f8xzuPDQfjHyz8fNMPcTMQmNHgLQ3w5n0JdigmYwHQIFEfIh5PTbU6nwSUM8dbpNKaHZ8RBLpV9Qx7/Dm4UuVL084ew/WtrEeP5sHUqkfz8+nC4tOUBif5n2qx+CbkmS/8TXDbXtdzfPx+5KjGSiPce8QfRgQyibyFOJmACBSVQHCEf4SjgY4mvepAj+sBLLLQdgA5r1qn1m7bUQSGIspoVZ90MQRxPaBXCqNBFWeitx6vpDNHLQnijBF1JQv4u4FDgtLY291vItQfL+2nwEYY4sQ/94SJNwAS6JFAkIddOfGcBX2WQ3busf5a3rQXsECzo14WCtBd602rvRmjXiK1ynSGqD4h9IJk4VJx6u5Araqb91J5u8s+u/cN8lYhdaTCHIYazK8g5m4AJ9EqgOEI+dizZl2lwJ0Os32vDpvC8GKwQLO3F4zwnMf42sE6YwNTK0/GEVpOeOkNUfnRZ5nKbSKTlf3/LOELeOlHarEJ/hXyEu2J303OA3Rnkq1Pg6VtNwARyJlAkId+YBreE9q/M4ISTjWliGoBkH24tfJFlPF46Lo5aOSZY5LLMOwmteP4Q2C6JhYeLIdm/RIuIZJX/ZBwhXy12r8gv35r6J+SnsworcH+ozEYMcluawJ2XCZhAugSKI+Rq1zD3ELEWETswO1ldmVfSatLnhqX544mWVm/+v9jPvXWISukktGvHC2nuDpOcmuxsTTtCcqxaJ9dKsYR8Ia9mNJnk/SODyXJ9JxMwgQITKJqQn0+U+JIvZDD5N680FCzo3wVfdmustyx2TYDKCld44MbAYy0WuWK/zwkVlSDrMOjvxSGJ8qs3D4PW//9v8LkrXl0x40rNyc6JhLw1/3x4DPMFomQr2/MY5N35FOpSTMAEpkugWEI+nx0Y4MqkMaNszZwkHjuPNCOIsSJIJL53xGGBsswl4pqgfFbwdW8b+4xvChVSZIsEW+eGai9vnVL/IHBFEHH5leVK0bMKp5Sf/PXJoqcxF43i1icS8vHyz5bHMFsRJdsVaL+blzE7XGdbqnM3ARPogUCxhFwNGeH/4oU0rwBuZJAte2jbVB8VC7lLZIHKffL0eMHPfckujGMuEcWHa8KymbTNrnzgWoEpAZelLmtckSoSdS3o0WZbN4RFQ/8T9mlR1ItEXNsBTCTk4+U/1XZN7f6R5INqcxp8l6HkW4WTCZhAwQkUT8gXsjlLuJ6ImYwymznJykmnPAiMJIcxKwR0MUvYnAOXTj7nUbrLMAETmCaB4gm5GjLMkUR8nAb3sYTncFBi8TplSWCEVeOIHO36+DQafJCh5FBmJxMwgRIQKKaQN4hYgJarvzT2K1/H8uzMfsuE55UAb0mqeAZrMJMriHgJDa5naMIwzJI0ytU0gfoQKKaQi/9C1mQ0icHeiAa3M4MdOSCZhHRKk8AwzyVKJm21+OdWBtiOA540F5Bmac7LBEwgAwLFFfJlxfw+GuycYyRLBrgLluXYaUCKuJFbxSJesO5xdUygWwLFFnK14mxWZ0lypJoiWRbH1vk+DCXRIk69EBjmrUTJdr3L0eBHzGQ39k+ibpxMwARKRqD4Qi6glzCD+5LoFR38oHQxMziC/ZPQQKepEDibdXmck4nYM3mswTCr8172WnoW6VRy870mYAIFIFAOIW+Cms9eRJxFlMRqP0KDk3kKn2CfZGMqp4kIXMDKPJRsFXw4UbJJ2L3xBmX7MpR823EyARMoMYFyCblAjyQLdbQkfpfA/W4aHMkgF+Z8PFw5ul0RQAvZj1FOSPaxGUtfTxYkDS49mq4cbXEtTcAEOhIon5A3mzHMG4iSA5NfEP7rl0ScxuyOhyfXs/sX8O44Fl8nE22eAGhwEwMcwexkGwEnEzCBihAor5CPCVPESLIj4fFEySHH+r9/EXEuMzizlj70s9iAGRwY5hNWD+P0NhocwyAX+VtLRd5cN8MEWgiUW8ibDZnLTNZmN+CgZAvcsdSgkRytdiaDXFZpAZvLAM/kTYwyhyjZ+2WsXxtclcwp3M2lzHvSsXN+CUzABCpEoBpC3tohZ7EJM5LDj7UN7qwgaDrJ/nIGuIwBvlOJMLuxsEydA6odFSXeOmVIaRFwAUv4rPdKqdCb6qaYwAQEqifkzcaORWm8iyhxMzT96LJSdXiytseVqF/GAfy8FNa6rO612IqBRLhfT4OXEiXb7Da/f/w6sb5X4gJH8fidN4F6EaiukLf24zDPB3YObodXxmdqaovYZvpH2EP8MmZweaGsdUXoaDVrlIi3tpRVxE4zPRKOlbucBlcwxG/rNXTdWhMwgSaBegh5a3+fx4o8mvjR5ZaQSOrgiCfs2kayz4h2AdS+LnfS4A4i7mQmd7AKf2Qvxjugeeqj6hKW597kKDVN1OrA6fWIWJ9G+BfWbMv05sRFJOFegavYD4m5kwmYQM0J1E/I2zt8bKXjG4mSU+91Ks+YX3389FDwQy+iwSIiHggHS4z9PuajfpAoyWfsp8EsIlYOe5qM/a7/j1hpwpIaSd46O/N7RHwzPnZNR805mYAJmMCTCFjIW3EonPFsnplYx0tYP7GOdd0I/8Izn+SX7jSYbolP+Px9OC+o1dbvdK/89RF/Tqx/Wf76dyBcj3IHQ9xdCv+9XyoTMIG+ErCQTxX/6azCcsxiILG0n5r8zGAVliT/91TOYg9u4rVswXc5MDnSTVb7gyzhgeRf/YyyiMdYxCGJxe1kAiZgAj0RsJD3hK/jwx8GTgQ+Ge8Ho2snEzABE8iUgIU8fbyHhkOWTwN07WQCJmACmRKwkKeP10KePlPnaAImMAEBC3n6w8NCnj5T52gCJmAhz3UMWMhzxe3CTMAEbJGnPwaGgPnJzumgaycTMAETyJSAhTx9vPsC58Xx5+fHK0N17WQCJmACmRKwkKeP10KePlPnaAImYB95rmPAQp4rbhdmAiZgizz9MWAhT5+pczQBE7BFnusYeBvwReBiQNdOJmACJpApAVvk6ePVkXOXAl+D5Pg5JxMwARPIlICFPH28FvL0mTpHEzABu1ZyHQMW8lxxuzATMAFb5OmPAZ08dFk4Pk7XTiZgAiaQKQELefp4dYzclcDVkBwp52QCJmACmRKwkKeP10KePlPnaAImYB95rmPAQp4rbhdmAiZgizz9MWAhT5+pczQBE7BFnusY2Ab4CXAdoGsnEzABE8iUgC3y9PG+CLgBuAnQtZMJmIAJZErAQp4+Xgt5+kydowmYgF0ruY4BC3muuF2YCZiALfL0x8DzgN8BtwC6djIBEzCBTAlYyNPHux5wB3AXoGsnEzABE8iUgIU8fbwW8vSZOkcTMAH7yHMdAxbyXHG7MBMwAVvk6Y8BC3n6TJ2jCZiALfJcx8BawD3A3wBdO5mACZhApgRskaeP92nAfcD9gK6dTMAETCBTAhby9PFayNNn6hxNwATsWsl1DFjIc8XtwkzABGyRpz8GLOTpM3WOJmACtshzHQMrAg8DjwK6djIBEzCBTAnYIs8GbyNka77Z8HWuJmACLQQsNNkMBwt5NlydqwmYQAcCFvJshoWFPBuuztUETMBCntsYeARYAVgJ0LWTCZiACWRGwBZ5Nmj/DawKrAbo2skETMAEMiNgIc8GrYU8G67O1QRMwK6V3MaAhTw31C7IBEzAFnk2Y8BCng1X52oCJmCLPLcx8FdgTWBtQNdOJmACJpAZAVvk2aC9E1gXWB/QtZMJmIAJZEbAQp4NWgt5NlydqwmYgF0ruY0BC3luqF2QCZiALfJsxoCFPBuuztUETMAWeW5j4GZgE2BTQNdOJmACJpAZAVvk2aC9EdgC2BLQtZMJmIAJZEbAQp4NWgt5NlydqwmYgF0ruY0BC3luqF2QCZiALfLex8CxwOfa4sWvBbYGXg7oWklHwM2NN9I6zbHlvUN3DiZgAk8QsJD3Php2i/3hlwYxnxdE+ipge+BVwUf+vngXxEPj36+Of9f9TiZgAiaQGgELeToom8Kt3HSt7Ws12SlLXcIta1xJwq6/O5mACZhAagQs5Omg3CG2wK+cJCtZ47rPyQRMwARSJWAhTw9nq1XeKVdb4+mxdk4mYAItBCzk6Q2HiaxyW+PpcXZOJmACbQQs5OkOifGsclvj6XJ2biZgArbIMxsDnaxyW+OZ4XbGJmACImCLPP1x8FVg15Zsdwf0f04mYAImkAkBC3n6WNcD7gjZ3hWHIOp3JxMwARPIjICFPBu0ih9/F7BfiCXPphTnagImYAJ2rWQ0BvZmN77BhZzMqxji5xmV4mxNwARMICFgizzNgbCQTRnl48lqzn8CT08y/wpLOIoDuSXNopyXCZiACTQJWMjTGAtn8mxmcBwR+7ZkJ/+4DmBupnPjD855DPLHNIp0HiZgAiZgIU9jDJzBGizH0TSYQ8QKIctfEPERZnMFC9iJRmKhv3hpcQ1OYybHsT/3plEF52ECJmACtsinMwYuYGUe4v1EfACYFbL4PaMcwxBfIqLRItwRw7yFAY4HNg7/vwj4NI9zMgfx4HSq4GdMwARMwBb5dMbACMsBc4CjgWckWTT4Cw3msQbnshdLxs32EmbwL94di/xcIp4Z7pMn/QRW4yz2YvF0quRnTMAETMAWeTdjYC4DrM07Eh93FOLCG/wL+ASL+SyH8Gg32ST3nM4KLM/BwIeJWCM890dGmctfuYB5jHadl280ARMwAUetdDEGFrALo5xAxGbh7v/Q4FQW8ykO4YEucuh8y+mswvJ8kIjDgJWDdf9bBjia2clBFU4mYAIm0BUBW+TjYZrPtgxwSjiyTXctpsEIEccxmAQXppNGeDoNPkrEILB8EPQbiDiEQa5JpxDnYgImUGUCFvL23p3PZkR8kog3BFGVq+PzRByTaejgCM+hkUyIviP+sBgI1foO8AEG+VWVB6HbZgIm0BsBC3mT33zWY4ATgL2XupwafI1Rjsh1Mc9ZbMJA8kHS3HirQYMvMYMPc8DSPVx663U/bQImUCkCFvKFrMmSxLVxQBxBoqgUpWtocFhfl9cPsxURpwLbhW8GjxOhRUXHMsg9lRqFbowJmEBPBOor5JpsXIEPhdPtxyYb4YnFPD1hTfHh9kVFDR4m4gyW5+Psx79TLMlZmYAJlJRA/YT8PFbkUd5LxJFxMODqod86L+YpSqc26LSo6H7gJP7DqRzOw0WpquthAiaQP4H6CLkW5NyXbCs7F3hWcFd0t5gn/37pXGKnRUUN/gocHy8yWsggjxWlqq6HCZhAfgTqIeQL2CPEgm8SBHx6i3ny65eJS+q0qKjB7UlkzWy++KQtAopSZ9fDBEwgMwLVFvIFbM8oJxOxVSCYzmKezLpjihl3XlR0Uxzz/hGG+PYUc/PtJmACJSVQTSEfi/g4MY4+2TH0SzaLeYrS6Z0XFV0LHNzXyJui8HE9TKDiBKol5AvYOLhQ9khiwRvJviXZL+YpyiDptKiowTeBIxjit0WpputhAiaQLoFqCPk5rMPjzAtnZM4IfvD8F/Ok2zfTz619UZE+0CK+AByV6erU6dfYT5qACfRAoNxCfharMSMJI9RugisGDv1fzNNDh6T6aPuiIpKolpFwUlF6+8WkWmlnZgImMFUC5RTyT7MSKye7BmpBz6qh0cVbzDPV3sjq/mVPKqrWpG9W3JyvCZSEQLmEfC4zWZvZwDHxEpm1AuNiL+YpykDotKhounuqF6VNrocJmEBCoBxCLhEa4W1Eye6AGwYfeLkW8xRlwHU+qejPibtlNc6b8JSjorTB9TABE3gSgeIL+QJezygnErFFEPByL+YpygDsvKjoluQYuyG+XJRquh4mYAKTEyiukI+wNQ1OIWLb0Az7dSfvz6nf0XlR0c8Z4Ehm872pZ+gnTMAE8iZQPCFfyKaM8ol4J8JdAoxqL+bJu8fHK6/ToiJt5zvKIczhhqJU0/UwARNYlkBxhPxMns1MjqfBO5MTcuq2mKcoo7PzoqL/ZSZHsD+3FqWarocJmMATBPov5GewBjOTKJQ5LWdW1ncxT1FG57InFS0BzmeUjzKHvxSlmq6HCZhAP6NWzmEWj/N+4HBgVugML+Yp2qhc9qSiR4EzmckJ7M+9Rauu62MCdSSQv0V+CctzHwcmO/TBMwJ0L+Yp+uhb9qSiB4g4Of4QPoVBHip69V0/E6gygfyEfC4DrMM7k3hlWDdA9WKeMo2uzouK/g58LDnDyAdblKk3XdcKEchHyIfZlSg5of4FCbsGXsxT5kHU+aSiO5PTl+6Jd5ucl+w66WQCJpATgWyFfD7bMsApwNZBwL2YJ6eOzaWYzouKfs0ARzGbr+dSBxdiAiaQ0RL9BbworMbcOTD2Yp4qD7bxFhXN4GAOQAdcOJmACWRIIF2LfIQNaSQHAb8t7OPixTwZdl7hsu68qOiy5GCLQX5VuPq6QiZQEQLpCPlC1mQ0OZ1+f2A5L+apyOiYbjOWXVTUoMFFzOAoDuCO6Wbr50zABDoT6E3Ix75Sf5iI9wFPCX5wL+bxaBsjsOyiosdocA4N5jIHRbs4mYAJpEBgekJ+HiuymENoJCK+WqiHF/Ok0CGVzGLZk4oUd346j3Iih/BAJdvsRplAjgSmJuSd97LOajFPIz6D8y5gvTYe70nC3ODpwObQ1f4fauebgL1CCOQmgI46+32yShG+lgRF9jddEx8UvREsPTDjq8CuXewZ3+19/W2dSl92UdF9wCd5iNM5nIf7X0HXwATKSaA7IddCkAXsmSz8gI1DU7NezNNJyHUqkA5B0NLwL4b6/GMS9MvFHwafi0X77eE+xTtr3+3nAM8LQqm8/l+fxXwyIdcH0TcgWVT1+ZY2l0fIVelOi4rgbuA47uYc5vF4OV8l19oE+kdgciEf5rWQHOzwkqSa+S3m6STk2ptcgqfl/Sd2ie2T4WzP3wFvBm5ueU4LlM4FXhYOcD6jyzyzuK1dyNcGVm75xjGekLffl0Xd0s+z87e7W2lwNINcQtT3b0jpt9k5mkBGBMYX8jG/pvbS2D4IeN6LeToJ+XbAj6YgunJVyPr+K7BpvEFXJ3/sMwFZ6dqi9fl9tMrbhby9y8cT8oyGRk7Zdl5UpP3PP8IQl+dUCxdjAqUmsKyQL2BjGnwc2CO0rF+LedqFXO4EuT9ak8S51cJu7wx9EGmHxUOAz07QU58KQv9uWBpNsWocSqltBV4JbBA+EHRizrFxXHSrP3c4roPi5uWzPwpQHv8VPhhODRZ/a9Fy5yjfsdWu8H/h97PafOQXAW8Nrh8J2k5t9deGY/Lzt97XvCWrumc32DstKtK3rwaHMcTPsyvYOZtA+Qk8IeTnsA6PcRwR+wIzYouo34t52oVcgqqVokcC/wPJMWSXAvdP0A03hQlRCetkvvTWbOSL/0mYaP1FPEn623hCdMswUfob4BUt1n1TyP8XeF2YOBW/dwTXiD4Q9TclfaOQKMtlohWPfwr/p9//HbuLVmiZ7GwVaLm33ghJmOfCuJwfBwF/pIOQZ1X3fEZ7p0VFDRzSmg99l1JSAhFnsRozEnH8YEsb5DeexyB/7GO7enWt6ENKYW6aPFtlii6T+bE7Zgj4cBwff1J4diBcy8LXDo6yzJUk5IMhAkZC3fzAkEvqqiC0e8eTeXpelqU+EDTxqglWJe3Frn1JdgD+No6Q677xXCvtFnkWdc9/GGhR0Vh0kr7hjKV/cBkj3MyfHLKYf4eUqkS9d/qpTYoYSfzDzW1l7yFiqCAbHvUq5CsGF4hCDBVu2G1aPv5Q+08Q5hfCk3byU57ipQ+JNduE/F2xC+aClkJ0z6Jgee8YJlSvCxb7bm2VUTm/TEHIs6p7t+zSv28Bu9BIPiw1qavviSQzNwpMdTKBzgRaDa1aMIo4m9VZklierRb5+bGAfbQCFrlOs5H7QT7jbuPEnxtEXBEsB3cYBXKT7B7y1ORp0yLXRKkiY1qTfNg3xpE2EnK5Wi4M1vuCDvlqQlZJrhGldku7G4s8q7rn/zKMWeTHAfqAHEv/4Ducy++4PXFDOZlAk4DWmuhHRpZ+amiRN1EU30eumk41akUTobLGZT1PtCT8LWEiVR9gWqRyJXBMiFNvf120gEgnHG0GyF/eFPJOfvhWIf9A7BvXpOouIR68Pd/rY/+3Imh6EXK5Z7Koe36S0dlH/g1G+SAHJhFITibQTkBuTrnhameJN0F0H7WyhE9yEA/mOIZ6da2oqk3RPQz4zAR1/wHwquCn1uIUuWPGs8i/HCJ61ggLk5pC3owiaS2mVcgVgSIrW/70Tha5DjTWJGkvQj6ZRT7dumff7Z23wtWE8MGOWskef8lLsJCP24HViCNv+p41Aamwv06HBWt+4LY4GkZumNWDC0Y+clnzW3Twkd8OyBetcEOlboVck5yKgNFKTLlmWpPcMrLue53sbPrI0657du95pzhyuaMiPsJstAWukwlMRsBCPhkhirWyc6quFTVPlvVBgARYe63IhdFMG8YuElmpL4rDCQ+P/d6K+1YaAWYDcofohCMlRZ3INaL7FAd+9BSFXN9+FNKo+PHWqJWnhgnQV3cp5Noq+JyWNrT70rOo+6TDZMo3dF7ZeRsNjmGQi7yyc8pE6/yAhbyr3i/OXivTEXJZqXKxSACV5MLQIQdyjWwVIlAk5nJ9NM+aVISERFfWukIGNYkpi1p+ccWUv7wtjlzukslcKypbz10RQg7lNlB4p9qk8EiVowVO47lWXhNi5xXd8q34W4EWbcnV1S7kWdW9q6Ey6U2d91q5J3YrHc/dLPReK5MS9A3LErCQT2lU9H/3w+kIebOJEkJNUkos1w+CLl+44q6/2SGq5WltKzt173fjzDRoFJ+eta+qAAAgAElEQVTeTN26Vpr3a/JVIqz9XWaGvWNk4euDRhuTjSfkCn28OKzwlIBr8zK5ijqt7Myq7lMaLsvc3L774dgiqE/yH07z7oe9oa350xbyaQ0A70c+LWy1fah9P/JGssWBvOOfYD+HEtZ2XKTXcAt5Tyx9QlBP+Cr/cPsJQQ0eJ+IcRvmoTwiqfO/n2UALeSq0fWZnKhgrk0mnMzvhEgY40md2VqaXi9QQC3mqvTHChjQ4nijZDVBRGv3eeCvV5jmzSQh0XsxzOREfYjCZYHYygSwIWMizoMoCXsRochiFditUGtsKN/9FRZk0z5m2Eei8mOfnRBzGYHIQiJMJZEnAQp4lXeazLQNJHPbY3tsN8j6cItPm1T7zzot5fkODoxhKzkF1MoE8CFjI86DMMLsSJYtodLRansfF5dK82hXSOQxV+xHO5W4uZN6TdoysHR43OHcCFvLckM9lgHWSg4O1sU1z29ysD3DOrXm1KKjzYp5/0OAEVmc+eyWbzDqZQN4ELOR5E+cSlue+ZGGODlDWakilX4S9NbTq0amIBJZdzLOIBicn57oOPmmBVBFr7zpVm4CFvG/9ew6zeDw5T1N7l+iUHCWf0di3Dhmn4GUX8zyKzpWawcfYv+MmZEVrgetTfQIW8r738bk8g8UcRcScsKugfOg+o7HfHdO+mAeWJCcgjXIMc5L9apxMoCgELORF6QnO5NnM5HgavJOIARrJhNnniZLd8Pp5dmhhEOVSkWUX8+iD9VJm8iH259Zc6uBCTGBqBCzkU+OVw90L2ZRRPhFO0lGBXlSUA3Y6LeaRq2uUQ5jDDXlUwWWYwDQJWMinCS77x0bYmganELFtKMyLirKgfiZPZQZHJIt3YOWkiEayZ/uRDCW7PTqZQNEJWMiL3kMs4PVhlahO6/GiorQ6rPNiHm3VezSz+bIPdkgLtPPJgYCFPAfIvReh+OUR3kbE8fFJ9DrVx4uKpku102KeBn+hwTzW4Fz2SiY1nUygTAQs5GXqLeYyk7WTI9iOIVp6AIMXFXXTiZ0X89xLgxNZzGc5JDmz1MkEykjAQl7GXuPTrMTKiU/3Q/E5m6uGNnhR0XiduexiHh0u/Rke5SQO4YFSjgFX2gSeIGAhL/VoOIvVmMGRwMGAjkJT8qKiZqe2L+aBx4AF8Z+PZZB/lrrvXXkTsJAvJaA9w8ufzmGd+OwZ7eGyX3yI74ykQXVeVLTsyTyKyf9isg2CY/LLP97dgnYCtsgrNSYWsDGjnEDEHsnBFnVbVNR5MY8Olj6CIX5bqb52Y0zAFnnFLPL2IT3mUjgxdrPsGP5U7UVFnU/muZYZHMYBXOs33gQqTsAWeaU7eAHbM5rs0LdVaGe1FhV1WswDv0x2lhzkW5XuWzfOBGyRV9wibx/iC9gjuFw2Cf7zcp9U1GkxT4PbY1fSRxniC17MY42rGQFb5LXpcC2EuS+ZDJ0LPCsIerkWwnRezPPXeIJXB14vZDCJSnEygboR0N5MRyTbSpDs01S7VI2olal023msyKO8lyjp9NXDo8VeVNR5Mc/9wEn8h1M5nIengsD3mkDFCHwGeB8ka0t0XbtUPyFvdrFOfl8hWVB06NLNoop4UlH7Yp4GDxNxBsvzcfbj37UbsW6wCSxLwEJe+1GxkDVZwkeJOABYLvDo/6KiZU/meTw+6/S82P89l0HuqX2/GYAJPEHAQu7REAjMZz0GOAHYO4lBV+rHoqJlT+Zp0OBLzOQoH+zg0WoCHQlYyD0w2gjMZzMiPknEG4KY53NSUafFPPAd4AMM8iv3kwmYwLgELOQeHOMQmM+2DHAKsHW4I5tFRZ0X89xAxCEMco37xwRMYFICFvJJEdX9hgXsEmLQNwso0llU1Hkxz++IOIrZXFp37G6/CUyBgIV8CrDqe+tcBlibd8S+83lErBdcLtNbVNT5ZJ4/0oh3JLyH85mXHDrtZAIm0D0BC3n3rHwnl7A89zGUHIcGzwiC3t2iok6LeUi2kj2B1TiLvVhswiZgAtMiYCGfFra6P3QBK/MQ7yfiA8CsgKPzoqLOi3kWAZ/mcU7mIB6sO0633wR6JGAh7xFgvR8/gzVYjqNpMCfebXGFBMav+D3f4qfcwTksYAUafBx48VJQDU5jJsexP/fWG55bbwKpEbCQp4ayzhmdybOZwXFE7Ms3AO0A/ibgv58E5dzEx+6DHeo8Utz2bAhYyLPhWtNcF7IpX+RL/IAXsBPw5oTDVxjgGA7gdzWl4mabQNYELORZE65h/tq75VS25LcM8W4Gua6GDNxkE8iTgIU8T9o1KWtMyOG0sCFXTZrtZppA3whYyPuGvroFW8ir27duWTEJWMiL2S+lrpWFvNTd58qXkICFvISdVvQqa8HQfGAEksVDTiZgAtkSsJBny7eWue+b7BsO5wO6djIBE8iWgIU8W761zN1CXstud6P7SMBC3kf4VS3aQl7VnnW7ikrAQl7UnilxvSzkJe48V72UBCzkpey2Ylf6bcAXgYsBXTuZgAlkS8BCni3fWua+GyQHQ3wN0LWTCZhAtgQs5NnyrWXuFvJadrsb3UcCFvI+wf8c8K4uyv4KsGcX9xXpFgt5kXrDdakDgSyEvDnXNRG/g4EzpgD42vgwdZ0/sOMUnunq1qiru9K/aY/Y9bBlS7bPBfYKG8De1PL/vwn+5vRrkF2OO8cHNl8GXAHo2skETCBbAlkK+SXAH8apvjasljh3myon5O0N1+7d2sl7P0DWepnTDsCVwNWArp1MwASyJZClkOtUAQl2GslCngbFnPKwkOcE2sWYQCBgIS/IUJjMIr8GuDVsD6tOWzF2Xbw89p//Ovy0h/ndGO5v9a9vGD/3CWCb+LzMVYCfAh8LlnOaGCzkadJ0XiYwOYF+C7lc1G8J21Y/D5gB/D4+z/cU4KKW6rdb5KsDHwV2ifdmWhv4C3AhJMdDPtby3KTa1S8f+VRdKxLyfwObhX/lgz5yCkL+wniCQXn8C/hCfOSa2v124NkhRDCtr05ql4V88hfPd5hAmgT6LeQHAmcCN4S5sacAb4xFWQK8LfDj0Nh2If8+sF0IVdZ8oLRDP3OB48IzXWlXmYRcQE6MP6mOihvaCI3s1iK/PN7Eav3YD/+SMGusx2fFp2peHz49N2rJs9cBJov/J5CcDKRrJxMwgWwJZCnkipyTN6A9/V+Y19P/a07sWcDzWyxpWdh3Ax8JuqX7WoX8GcDfgROAo0Pm0mPltTgW/9eF/+tKu8ok5DqJftW2rxzdCLmekTV/TIdQocPCV5vnAH9Kaay9KHwyK/pG104mYALZEshSyMereesJYHLVjrYYiXpmc0AaMC/+5dgOFrmeuS8+pv3nIWLvrg4Fda1dZRJyWdBbtDW2GyHfKv6a87NJxpEs9V+kNNYs5CmBdDYm0CWBLIW826gVGZqvCBolzZFWSV/HE3I17b3Bj75cmLO7KnYffzmIu/7etXaVScgf7xDON56Q68R6+Zw02dl0dcjv9MNxBoZ8W/d3OWgmu81CPhkh/90E0iXQbyGXtsjqvi1sz6H5OLlW75lEyEVBLhhNdmqR0Gvis35XAxaEQ2m2Dm7aSbWrCkL+2/DVpDk09On2APCtIORPB/4RJkcVtdKaXhYmJDSz3PS79zrENGutD5Jb4hlrXTuZgAlkS6CfQv602LL+J3BW7Cp5X4uOzAxu4PEscunSekEnFgU8KwURfwfwguBD70q7yi7k8i8pFFH+KPmolAaBYaC5vF9t1Kyx/OCaML0z3KdPQn0IaMIzzSWz6pw74sVN8nnp2skETCBbAv0Ucq1Ql1tWxzrqeMdm0kp17YCq6BNZ1Eqtk52yvr8HHAGc1PLcIbFVLv+7IvSkT11pV9mF/FPxBMMHwteZb8firVCd3cMn5O0t+7Qo5vwHYdJTcO+Nvwa9M4j7K8PXoLSGmoU8LZLOxwS6I9BPIZchKZfKQDirV7qjEEJtz6F5vZuDL1zzdK1CvjLwqxDtckHIQ352+eTl6pXRKeO0K+0qu5ArXlNirr1b9FVGn14SdgXUK7UuCJLIy7WiiU25X2TNKxhfvqw0k4U8TZrOywQmJ9BPIVftNLH56did+9KwVkXx4bK03xNcujrD9/A2Iddz2mNK4YeKJdfioD+HmHLpl9a8NNOk2lUUIZ+8q8pzh4W8PH3lmlaDQBZCXioyFvL0u2utMFv9t9hXr2snEzCBbAlYyLPlW8vcNYutQH+FM+rayQRMIFsCFvJs+dYydwt5Lbvdje4jAQt5H+FXtWgLeVV71u0qKgELeVF7psT1spCXuPNc9VISsJCXstuKXWnFlT4chx09GhYrFbu2rp0JlJ+Ahbz8fVjIFjSX+zsqqJDd40pVjICFvGIdWpTmWMiL0hOuRx0IWMjr0Mt9aKOFvA/QXWRtCVjIa9v12Tb8kfhUkBUA7WamaycTMIHsCFjIs2Nb65x1IpFO99Dewrp2MgETyI6AhTw7trXO2UJe6+5343MmYCHPGXhdirOQ16Wn3c4iELCQF6EXKlgHC3kFO9VNKiwBC3lhu6bcFftrvMn8muE8Pl07mYAJZEfAQp4d21rnrOPk1gXWbzlartZA3HgTyJCAhTxDuHXO2kJe59532/MmYCHPm3hNyrOQ16Sj3cxCELCQF6IbqlcJC3n1+tQtKi4BC3lx+6bUNdPJ2ZsAm4ZTtEvdGFfeBApOwEJe8A4qa/VuDCdrbwno2skETCA7AsPxObmDwJz4nFxd1y55m9VsutxCng1X52oCnQh8DngXsB+g69olC3k2XW4hz4arczUBC3kHAhby3l+MY4MVoAnOZroW2Bp4OaBrJR0BNzfeSOs0x5b3Dt05mEALAVvkHg49E9gt9odfGsR8XhDpq4DtgVcFH/n74l0QD41/vzr+Xfc7mYAJpEfAQp4ey1rn1BRuQdC1tq/dIoi7hFvWuJKEXX93MgETSI+AhTw9lrXOaYfYAr9yEgKyxnWfkwmYQLoELOTp8qx1bq1WeScQtsZrPTzc+AwJWMgzhFu3rCeyym2N1200uL15ErCQ50m7BmWNZ5XbGq9B57uJfSNgIe8b+moW3MkqtzVezb52q4pDwEJenL6oTE2+Cuza0prdAf2fkwmYQO8E9m0J8W3mNp6Qd7q39xoUMAcvCEq/U9aLlwvfEbK9Kw5B1O9OJmAC6RBovl9yY2rdhv5tF3IJuBbfSd9q8f5ZyNMZXO251P6rXjZYnasJJASa75euJeSPAjsB5wCvaRHv2uy9YiHP5s2QFaABVgtrIBuEztUExiXQ+q13vJtq9W3YQp7d26LB1rr/SnYlOWcTqB+BVqu8U+trY42r8Rby+r0AbrEJVIHARFZ5raxxC3kVhrPbYAL1JTCeVV4ra9xCXt8XwC03gSoQ6GSV184at5BXYSi7DSZQbwLtVnntrPH8hHw+OzDgnf8q/76NchVzvE1vofq56u/e7TyNT6L9/uEp3M+p6CDm2qV8JjtH0Ck6CtB3qjaBefERuOprp6IQqMO7J5v8J+HUzlcUBXy+9chbyLXviA9WyLePsy+twfZEyTcuC3n2tKdWwhNCXt13T1b5Z9m3ltZ4ePfyFnK/6FN7Dctx90jybUuWuPu3aD32hJBXvW/quW4jvHsW8qK9eGWsj4W8uL1WHyEvbh9kWTMLeZZ0a5a3hby4HW4hL27fpFEzC3kaFJ1HQsBCXtyBYCEvbt+kUTMLeRoUnYeFvOBjwEJe8A7qsXoW8h4B+vEnCNgiL+5osJAXt2/SqJmFPA2KzsMWecHHgIW84B3UY/Us5D0C9OO2yMswBizkZeil6dfRQj59dn6yjYBdK8UdEhby4vZNGjWzkKdB0XnYtVLwMWAhL3gH9Vg9C3mPAP24XStlGAMW8jL00vTraCGfPjs/addKacaAhbw0XTWtilrIp4XND3UiYB95cceFhby4fZNGzSzkaVB0HvaRF3wMWMgL3kE9Vs9C3iNAP24feRnGgIW8DL00/TpayKfPzk/aR16aMWAhL01XTauiFvJpYfND9pGXawxYyMvVX1OtrYV8qsR8/7gEPNlZ3MFhIS9u36RRMwt5GhSdhyc7Cz4GLOQF76Aeq2ch7xGgH/dkZxnGgIW8DL00/TpayKfPzk96srM0Y8BCXpqumlZFayrkWwE/A44BPhbADQDzgb2Bi4EDxgF6BnBQh7/9Gfgh8AHgnml1RueHVN6ewFop5plNVvaRZ8M1jVyzE/J9gfMmqeK3gDeFe66N35EHgR3TaFYXedTjfbWQLxXynYHLgC8D6vyrJxHy08KA1G0rAC8AXg/cBrwQeLiLQdbNLRbybij5nokJZC/klwB/GKcStwAX9lnIq/2+WsiXCrmsbInmswFZ1+Ol5if82sBf2276CHBC/P9DyQmW6SQLeToc651L9kL+38A3u4DcL4u82u+rhXypkL8X+CzwDOCf0xRyfQj8MbhoDuxiUHdzi4W8G0q+p98WeRmFvDrvq4U8EXK5U/ZoeRP+B3jHJK6VTp/wzwHuAj4DHNby/CuAecCLgf8APwU+BNzeVob8jXNiH/2msV/814C+Dv5/LT7yo4JPf33gzpZnXwTcABwanumPrNlH3h/u3ZRaXIt8deCjwC7xt1i9U38JbpiPA4+1NG1D4BPANsAq4R3SuzueC7T56ETfoKvzvlrIEyHfHJgdJjE1sSifnoS0U5poYBwNHB9Per4auDI8/Ebga0F4LwKeEgv4PsDysU9+a+B34b4Px772E4HfxoL/deBZ8d/eGgb2SmGyUwKvv7cLtp7TB4OeSXOitRuJeOIeC/nUeOV5d3GF/PvAduEd+Q2wQ/iZCxwXEGnO6RrgX8AXYqMoAt4e3KC7TeLSqcf7aiGftmvlzJbJTomyJjtfGwbfsWEAzgwfCJoMlTV+X/j/58bfAH4VBqA+OP4rWOf6v9fEovxQuO8tgCaR/tYStSLhl2/+VeEeDepbw/Mqv3/JQt4/9pOVnL2QfyWMw041ke9cQqzU6iOXG/PvYV5JRpCSxrOMoMXA68L/XQ7oW+hLWt65WcD1seE0A9gIaExieFX7fbWQT1vIO42b0XjAnR8s5geA5wWL+4PAyW0P6D5Z3LLQ5daRYMt6/3bLfRrUEventwi5JlNlvUv8ZaE0Qynf3UUY2GSve29/t5D3xi/Lp7MX8olqLzej3I3tQi4XiYybn8ffNPcKbsn2fFaN36d/h1BhWdetSfnKLSMXyZ8mEfJqv68W8mkLebuPXBaC/HyfC347xclKmGWNKCxRVkVrkivkk+Hr4TtjV4t8gut0cI3oq6RcNc04clklGvjyp+vD4FOxoB8c/q4B379kIe8f+8lKzl7IpzvZqSCDU2KrfLng974qzFlpjCs1DZWJWqh34heTCHm131cLeWpC3hxH58aWxX6xoK8XD8jNJhByLRySCOsro1woJ40j5Jp4lbulKeSy0jXRqYH75nCtQd86WTvZa53N3y3k2XBNI9fiCrlaJ5GVESTjR2N9tfhdWBDCeDWP9JPYdSKfuRbcdUqa6L9/ikJerffVQp66kGuyU/4++czlapFP+/3xTPun2waaLHetIpVrRRM2ipx5Q1iU1LxVon1TcKO0ruw8NbbcB8NqOU0Wyc8uH2V/k4W8v/wnKr2YQi6XoQweBRcsCtXXxL5EXFFjeofkQ/8HcGSIWmlt5cviCBdFsyiIYDIfeacoM+VVjffVQp6qkK8YJmDWDVaFBpdm4vW1UZOdTdfHxrE1/UvgijhscNc4fn0N4I7gD5dV0lwVunscUfO/bZOdGnwKSZR1cjPwzDhufc0UV5JOX4ws5NNnl/WTxRRyWd/fi8fuEeEbaZPCISGMVt9oFaX14+AH37Yl7FbCrL9pwnOi5f4TRa1U5321kE9byFuX/GoAykeuZf4S6dbJTX1lvDRElTTDD+V6UURLa/ihnpF7RZObClfUQJXvXHvCaFa+1SLXTP3dwVKXZa/8+p8s5P3vg/FqkL2QT7REX7XSOgrFhbdGrawcxrvCZi8I21vI4JG/Xe4SCbe+1b4c+EEwhLQP0r3h3dAk5yvjOajrJgDfFPJqv68W8mkLefvYeTRYyKeH6JHWr3qKk9VA1sIdWdsaeJrs1L4srUnCra0C9JVS1oZm+mWty1XTvmmWtgBQ7LtCtL5bCAWxkBeiGzpWInshn6ztcpk80ibkekahuIrE0juixUHaHkOGjCb/FZXVTIol14IgTWzqG67mhRSxMpGI69nxNs2q1vtaUyGfbNCV4e+yTLR4Qq6VxwtRYQt5IbohZyEvbpuLVbNs31cLebF6u8vayCeurQAWhtDDLh/L+DYLecaAe8g+O4u8h0rV5tHs31cLeakGk1aQKvpFX0O1rUBzMqgYjbCQF6MfOtXCQt6PvsnvfbWQ96N/p12mlvprz2fFzMpfqBjz4iQLeXH6or0mFvJ+9E1+76uFvB/9W9EyLeTF7VgLeXH7Jo2aWcjToOg8EgIW8uIOBAt5cfsmjZpZyNOg6Dws5AUfAxbygndQj9WzkPcI0I8/QcAWeXFHg4W8uH2TRs0s5GlQdB62yAs+BizkBe+gHqtnIe8RoB+3RV6GMWAhL0MvTb+OFvLps/OTbQTsWinukLCQF7dv0qiZhTwNis7DrpWCjwELecE7qMfqWch7BOjH7VopwxiwkJehl6ZfRwv59Nn5SbtWSjMGLOSl6appVdRCPi1sfqgTAfvIizsuLOTF7Zs0amYhT4Oi87CPvOBjwEJe8A7qsXoW8h4B+nH7yMswBizkZeil6dfRQj59dn7SPvLSjAELeWm6aloVtZBPC5sfso+8XGPAQl6u/ppqbS3kUyXm+8cl4MnO4g4OC3lx+yaNmlnI06DoPDzZWfAxYCEveAf1WD0LeY8A/bgnO8swBizkZeil6dexL0Le4Coirpp+rUvw5A9Zj5tZj+dxJ6/kzhLUuPcqNtgh7tcdgHkMcmzvGTqH1Ag0hbwO715q0EqUUXj3olyq/IRVkEtxfS3kG8A3gTcB/93XmvSjcAt5P6hPVGad3j1xuAX4PbAxsEnROiO7+uQj5PPZgYHEYqt+Ooft+CmvYQv+jwP5XvUb3NLCUa5iTsW/cZWtQ+v07qlvRtiBX7A9L+ZqBuszFvMR8rIN/t7qeyhwKnAaoGsnEzCB/AjItTc3cfNRHzefhTz9AWYhT5+pczSBbglYyLsl5fsmJGAh9wAxgf4RsJD3j32lSraQV6o73ZiSEbCQl6zDilrdIWB+Mu0CunYyARPIj4CFPD/WlS5pX+A84HxA104mYAL5EbCQ58e60iVZyCvdvW5cwQlYyAveQWWpnoW8LD3lelaRgIW8ir3ahzZZyPsA3UWaQCBgIfdQSIXA2+LFwV8ELgZ07WQCJpAfAQt5fqwrXdJuwKXA1wBdO5mACeRHwEKeH+tKl2Qhr3T3unEFJ2AhL3gHlaV6FvKy9JTrWUUCFvIq9mof2rQzcBlwBaBrJxMwgfwIWMjzY13pkrRd75XA1VCTrXsr3Z1uXMkIWMhL1mFFra6FvKg943rVgYCFvA69nEMbLeQ5QHYRJjAOAQu5h0YqBCzkqWB0JiYwLQIW8mlh80PtBLYBfgJcB+jayQRMID8CFvL8WFe6pBcBNwA3Abp2MgETyI+AhTw/1pUuyUJe6e514wpOwEJe8A4qS/Us5GXpKdezigQs5FXs1T606XnA74BbAF07mYAJ5EfAQp4f60qXtB5wB3AXoGsnEzCB/AhYyPNjXemSLOSV7l43ruAELOQF76CyVM9CXpaecj2rSMBCXsVe7UObLOR9gO4iTSAQsJB7KKRCYC3gHuBvgK6dTMAE8iNgIc+PdaVLehpwH3A/oGsnEzCB/AhYyPNjXemSLOSV7l43ruAELOQF76CyVM9CXpaecj2rSMBCXsVe7UObLOR9gO4iTSAQsJB7KKRCYEXgYeBRQNdOJmAC+RGwkOfHuvIlNUILoym0VJa8Dm7+3BSe8a0mYAJPJmAh94hIjcBUhFwC/j7g0DjS5TALeWp94IzqScBCXs9+z6TV3Qh5q4Dr2nuzZNIVzrRmBCzkNevwLJv7CLACsBKg69bULuDNv+1nazzLLnHeNSFgIa9JR+fRzH8DqwKrxS4TXSuNJ+D6m63xPHrFZdSBgIW8Dr2cUxtbhVxFNn3g4630/Fo80XljTnVzMSZQRQJXAfqxkFexd/vUpqaQbwF8HVi3T/VwsSZQFwLzgojvEAu6fprCXov2TyU8rhZAUmpku0WuiBT9yN3SKdkiTwm8s6ktgVoJd3svW8izGfd/BdYE1gZ0rSS3yniCfiewfjZVca4mYAJVJ2Ahz6aHJcxyp0icdd2axhN0R61k0xfO1QQqT8BCnk0XTyTkzRLbBd1WeTZ94VxNoPIELOTZdHE3Qt5J0OV68RL9bPrEuZpAZQlYyLPp2qkIeauge6+VbPrDuZpApQlYyLPp3puBTYBNAV07mYAJmEBmBCzk2aDV4h7FkG/phT7ZAHauJmACTxCwkGczGizk2XB1riZgAh0IWMizGRYW8my4OlcTMAELeSZjQHs7KNKkNV78WmBr4OWArpUUbjg33kjrtA6x5ZlUzJmagAnUg4At8t77WZEmlwYx134PEnQtF94eeFXwkTc3zbo6nALUe6nOwQRMwAQCAQt5OkOhKdzKTdfavlaTnbLUJfTNXQ8l7Pq7kwmYgAmkRsBCng5K7bZ25SRZyRrXfU4mYAImkCoBC3l6OFut8k652hpPj7VzMgETaCFgIU9vOExkldsaT4+zczIBE2gjYCFPd0iMZ5XbGk+Xs3MzAROwRZ7ZGOhkldsazwy3MzYBExABW+Tpj4OvAru2ZLs7oP9zMgETMIFMCFjI08e6HnBHyPauOARRvzuZgAmYQGYELOTZoFX8+LsAn/qTDV/nagImYB955mNAVrgmPm2NZ47aBZiACdgiz24MSMTbz+vMrs/15ZMAAB4KSURBVDTnbAImUFsCFvLadr0bbgImUBUCFvKq9KTbYQImUFsCFvLadr0bbgImUBUCFvKq9KTbYQImUFsCFvLadr0bbgImUBUC+Qj5fHZgwFu4VmXQjNuOUa5ijvdbr3w/u4GFI5CPkI+g49B0zJlTtQnMYzDpaycTMIEcCeQt5NpAyifk5NjBuRTVYHui5BuXhTwX4C7EBJ5MIG8h94texRE4knzbkiXu/q1i/7pNhSdgIS98F5WgghbyEnSSq1hlAhbyKvduXm2zkOdF2uWYQEcCFnIPjN4JWMh7Z+gcTKAHAhbyHuD50UDAQu6hYAJ9JWAh7yv+ihRuIa9IR7oZZSVgIS9rzxWp3hbyIvWG61JDAhbyGnZ66k22kKeO1BmawFQIWMinQsv3diZgIffIMIG+ErCQ9xV/RQq3kFekI92MshLot5A/BTgE2BN4LrAYuA24EFgYfi8r237W+3vAzHg7BC2bzz5ZyLNn7BJMYAIC/RTyFYBrgK2A7wDXASsC2wEvB74PvA4YDfX/MHAisBLwyBR7tZdnp1hUprd3246vATOAN2VQm2XrYCHPALOzNIHuCfRTyN8HfAbi/fJgQUuVVaePxBblx+LDi/cFzreQL6XTrZB3PwKmfqeFfOrM/IQJZEqgn0L+xeBSWbmDC2U54EHgAuAAC7mFPNO3wJmbQMkJ9FPILwLeCmwB/LIDxw2DwP8pbH27fcs9ZwLvjXfbU/3fAhwKPC+4E34PnBL/rvyVtG1up2f1N5XxCWAbYBXgp+GbgLbbbSb5m/8KjADHAS+Oy/wN8MHw7xnAq4Hl47ZcChzc5vqZShnzgLOBl8Xt+2c8b/A/wNHxz+OTtKMdX7uP/Nfxh6Z+3tZ2443AreEDVX9aPXZlfRTYJW7v2vGH6F/CfMXHgcfGrYNdKyWXAVe/7AT6KeRvBr4CPBrcJ+cBPwOWdID6EuBA4N3xPW8Ebo9F6ebwfxL1G2K/+hWAJk/1d4nntrGP/cfAeM++MPjo/wV8IXwovB14NrBb7Lv/ZqiHRHEt4KnBBdQAPhQflKF/JfC/C/78XYNPX3/7VHh2KmUMxCL+rPhD5fLQtj3CB0Qzv/Ha0WkMTlfINS+hOQr52PVhpclS/WibWn2Ida6DhbzsOuD6l5xAP4Vc6OQ2kUg8M3C8LxYSidA3gC+1Wbad/MNXBvF7frAYlY0sybuDn12To0qdnpVgrh/ESW4cpVnA9cGy3yiIteoji1uTsr8I9ynS5rRQR32rkKhrElblqk76kFKaShmvAd4V3El6VpPBdwRLWpO+47UjLSF/RvzB+HfghPAtQPlqfKg9iiYavw4W8pLLgKtfdgL9FnLxU3SFRHJH4LXBItT/yaUi6/pXE4iY3CGKamkKsW7dHLgpOeRg7LCDTgK4auyO+Xds/R8DyDXSmg4L7oXnhDpIyNcB9GHRTBI1fQOQYMud0kwSeonhzsBUy9gS+K+2byQ/CC4bWclZC7lY6oP058BewF3jDG5Pdpb9rXf9K0egCELeDnXd4H8+KPjOXxQs3vEiNuSzfkXwtesDQT53tWsiIdd9cuNMlORGkDBLyJthkc379aHzXeBVbUfXSQTl25aQT7UMCf9L2yrUXna3USvTda1o3kHzC5ps1nyB5he+HMS9WTULeeVkwA0qO4F+Cbkm1RRyeEn46cRRUS2anJPbRS6LTiLWPGJMi4hkGSsuXfHo90wi5Jrc/Elw6/xwnE6U3/3+HoS81zJUrayFXP59+cK1IKuZ5JrSZKc+rOTuWS301dC4H6h2rZRdB1z/khPol5Br1eHDcQTI12PXiSb1OqVzQhy5hOSBDkL+tGD9nhW7BBSTLj+1kvJWhMVEFvnTgX/EE61HhqiV1vIVMaLJUkW9KM/pWuS9lpG2kP82uEyabZXVLa7fCkKu+q4H3AIsCjfJ768P3HfE8wEviJ9XHrbIS/7Su/rVI9AvIRfJpsWtSJTPtQix/qZQwmtDRIhWeSo1BURx5w/FkRXyKcv1IUtRoYHNJP/uxSHKQhZ7p2fVbkW0yA+u6JY7w32yRiVWmvCURdpJTPV/3bhWei1jIiFvMhhvRLa7VuTykXtI8wfNlbJaiDUcIodkkcv61nNHxNE/J7Vk3JzY3SxY7+39IPo+fLl62uAWlYhAP4VcLhO5QmQFSjg1QSlXhiJJ3hCsavmM9fVf6f1xCODJ8eTo8SEaRCIul4rC9uaHkESFysk/regThSfK5ytfePuzEnF9QGgyUZOeEv574/zeGcT9lcFF04uQ69leyuhUdqd2dBpu7UKucMgPBPfTt2PxVljk7uEbjUI5JeT6cNDEskIgtRBLbDX/8N8hvFMfePoQWLYOFvISvfKuahUJ9FPIxVPuEQmM4rYl6BIKRUtokk2i3Ro5IXeHLHdNIp4awgs1sfnpMEmoeHDFQcuifE9wmyg2/fDgKml/VuVL0LQgSBObcjXIctWCGPnZm2m6rpXm89Mto5OQd2LQjZArvl5iLjeWXE/6IBN3LfRRavrItXGZwg8VJaN5jD+HmHLdJ75Ky9bBQl5FbXCbSkSg30JeIlSlqqp3PyxVd7myJtAbAQt5b/yK+rS+WSi23tvYFrWHXC8TSJGAhTxFmAXISjH4+4WFTppMVrRJ9smulewZuwQTmICAhbxaw0MTmNpoSxa5BF0TltknC3n2jF2CCVjIPQYyJWAhzxSvMzeByQjYIp+MkP8+OQEL+eSMfIcJZEjAQp4h3NpkbSGvTVe7ocUkUAch14pGbQfQaTn+dHtFq04VFdJc/TndfKb7nA6EUIx380zO5qKovcPipuapStPNf2rPWcinxst3m0DKBCzk0wPabyH/UdhITHuhK2k162Vhp0Jty9t6wtH0WjiVpyzkU6Hle00gdQIW8ukh7beQt9daW/5KwHW6kSz1fJOFPF/eLs0E2ghYyKc3JIom5NpT5rOATvnRfuj5Jgt5vrxdmgnUXMi1de2c+IzOjcMGUdrPpfWEH+Hp5rDkTkKuwy20da42mvpPOJhB521qUyoluTuUt6zm5pa72pxKG3Vp3xMd6KDUPHJN2/juP86IVZy4zguVj1wHP7RuBaw48nwWAjUrZyG3sJhAXwnUySLXKfIbAJ8PE5VvCaKqbXS1uZZSt4cltwu5jqTTgcXaDlf7mGuTqn3CMW1bhx0cj4o3rPpYXL7OAm0u1JHIa7dHPauNw5S0qOd/w97hOre0U2oVcm1NOzveX13uFW1+pf3E1db8koU8P9YuyQQ6EKiTkMsK1lasOhlISQcp6DgzRbXIUlZkS7eHJbcKuXYTlHDqsGRZ4zr3Ukk7CWpb2G8GgdWWvCpPOzOe23JItPY/XzNY4qqjdnPUQRmqXzOv9q5rFXL9za4Vv94mUGMCdRJyRXVon/PWdHC8XevpgE4F+v0UDmRuFXIdgqE90z8Ytt5tzf/8+G+KLJGFLtY6mFnC/q4g7toHXcKubwTNE3i0f/rjYS/z8YamhbzGL62bbgLtBOok5J8Mpwy1MtC+2wrlezvwhykcyNwq5HKrSJxfHyz61vzlI1e5zWgSCbdcLdp7XXuq6/Dm1waB10lH8m/roAu5YI6dYLhayP0um4AJLCVQdyHXCT46ZEGThTrgudsDmbsVck1i6kAH+cHlP5f1fXb4XQdPy9Uit4gOQNZhz7LgvxOscZVhi9wvqwmYwKQE6iTkOuJM1nNrOjD2TZ8JvAj4yxQOZO7kWtERaPJvtyadSqTVlnKtLAnHyOnUI5Url44iVjQ5qgOkFYEiIdekpSJXdL+FfNIh7BtMwATqJOSaSNwmWMHq+TXCtfzR8k9LOLs9kLl9slMWtY6K02SnXCNKCnH8ZWxdXxFb27u2DDX50zVBqugVHf78p/h80beFw6hvDZa5DpCeKNm14nfXBExgKYE6CbnETxOTspIV561JSAnpm0P4n6B0e1hye/jhLiEeXeGEzfBD7QcuwW6GHzahnxYf9KyT6f8YT3LqIAglHUTdXJGp2HHFkFvI/aKagAl0RaBOQi4rV8Itd4Z81vJJHwf8oI1UN4cld1oQpIlTLQiSm0ahjDrAWZOd7Yc7NCdHdYKPJlmbSda4wiCbVrqFvKsh7JtMwATqIOTu5awJeEFQ1oSdvwlMSMBC7gHSOwELee8MnYMJ9EDAQt4DPD8aCFjIPRRMoK8ELOR9xV+Rwi3kFelIN6OsBCzkZe25ItXbQl6k3nBdakjAQl7DTk+9yRby1JE6QxOYCgEL+VRo+d7OBCzkHhkm0FcCFvK+4q9I4RbyinSkm1FWAhbysvZckeptIS9Sb7guNSRgIa9hp6feZAt56kidoQlMhYCFfCq0fK995B4DJlBAAhby9DtlB0A/V4Wf9EsoWo62yIvWI65PzQjkK+QNriJKBK66aQE7cD078BKuYnbF29rsxQY7xP2qD695DE54slF1+90tM4E+EshXyPvY0NyK1vHNl8ZnDe0UNsjNreBCFGQhL0Q3uBJ1I5CPkM9nBwYSi6366UK24Rp24vlcx/uQrNcnjXIVc2ryLaQ+veqWloBAPkJeAhApVvHQcLCyDpDQtZMJmIAJZErAQp4+Xgt5+kydowmYwAQELOTpDw8LefpMnaMJmICFPNcxMATMB0YAXTuZgAmYQKYEbJGnj3ff+FDl8+JzQc8HdO1kAiZgApkSsJCnj9dCnj5T52gCJmDXSq5jwEKeK24XZgImYIs8/TFgIU+fqXM0AROwRZ7rGHgb8EXgYkDXTiZgAiaQKQFb5Onj3S0s0v8aoGsnEzABE8iUgIU8fbwW8vSZOkcTMAG7VnIdAxbyXHG7MBMwAVvk6Y+BnYHLgCsAXTuZgAmYQKYELOTp49Uuj1cCV4cDJtIvwTmagAmYQAsBC3n6w8FCnj5T52gCJmAfea5jwEKeK24XZgImYIs8/TFgIU+fqXM0AROwRZ7rGNgmPujtJ8B1gK6dTMAETCBTArbI08f7IuAG4CZA104mYAImkCkBC3n6eC3k6TN1jiZgAnat5DoGLOS54nZhJmACtsjTHwPPA34H3ALo2skETMAEMiVgIU8f73rAHcBdgK6dTMAETCBTAhby9PFayNNn6hxNwATsI891DFjIc8XtwkzABGyRpz8GLOTpM3WOJmACtshzHQNrAfcAfwN07WQCJmACmRKwRZ4+3qcB9wH3A7p2MgETMIFMCVjI08drIU+fqXM0AROwayXXMWAhzxW3CzMBE7BFnv4YsJCnz9Q5moAJ2CLPdQysCDwMPAro2skETMAEMiVgizwbvI2Qrflmw9e5moAJtBCw0GQzHCzk2XB1riZgAh0IWMizGRYW8my4OlcTMAELeW5j4BFgBWAlQNdOJmACJpAZAVvk2aD9N7AqsBqgaycTMAETyIyAhTwbtBbybLg6VxMwAbtWchsDFvLcULsgEzABW+TZjAELeTZcnasJmIAt8tzGwF+BNYG1AV07mYAJmEBmBGyRZ4P2TmBdYH1A104mYAImkBkBC3k2aC3k2XB1riZgAnat5DYGLOS5oXZBJmACtsizGQMW8my4OlcTMAFb5LmNgZuBTYBNAV07mYAJmEBmBGyRZ4P2RmALYEtA104mYAImkBkBC3k2aC3k2XB1riZgAnat5DYGLOS5oXZBJmACtsh7HwPHAp9rixe/FtgaeDmgayUdATc33kjrNMeW9w7dOZiACTxBwELe+2jYLfaHXxrEfF4Q6auA7YFXBR/5++JdEA+Nf786/l33O5mACZhAagQs5OmgbAq3ctO1tq/VZKcsdQm3rHElCbv+7mQCJmACqRGwkKeDcofYAr9ykqxkjes+JxMwARNIlYCFPD2crVZ5p1xtjafH2jmZgAm0ELCQpzccJrLKbY2nx9k5mYAJtBGwkKc7JMazym2Np8vZuZmACdgiz2wMdLLKbY1nhtsZm4AJiIAt8vTHwVeBXVuy3R3Q/zmZgAmYQCYELOTpY10PuCNke1ccgqjfnUzABEwgMwIW8mzQKn78XcB+IZY8m1KcqwmYgAnYtZLZGJAVrolPW+OZIXbGJmACTQK2yLMbCxJxn9eZHV/nbAImEAhYyD0UTMAETKDkBCzkJe9AV98ETMAELOQeAyZgAiZQcgIW8pJ3oKtvAiZgAhZyjwETMAETKDkBC/l0OvB0VmE5ZjHALBo8lYhZyY+uSf6dBTwFeIiIRcAiIh6kwaLkR9ejLOIxFnEID0ynCn7GBEzABJoELOSdxsIZrMHybMAoGxCxIY3k3w2ADWjwbCIGUhxCS4A/0+A2Im6nkfyMXc/kdvbn3hTLclYmYAIVJGAhv4CVeYgdiXhtOGPzuYlVPXF6KLGy9SMLe8zibv/9PxAs9Ces9DHL/cm/rzRJWSrj90RcS4MreAo/YB+Ut5MJmIAJJATqKeQjvDA+FHlnGuxMxHbA8k8aDw0eJUr2S7ltmZ/VuJ29WJza+LmE5bkvsfY3XPrTYKNwvR4RK7SVtZgGPyLiMiIuZza/Sa0uzsgETKCUBOoh5COsCryOBjsR8XpgnTbhvikRRh3XNoNb2B9tdlWMdDbrsoRNgNckHz6weVvF/gxcnoj6I3zXPvdidJtrYQJ5Eqi2kA/zfOCDRLy9zer+G/AdGnyHx7mM9/KvPKH3VNa5PIPFyQfSTpC4g9Zcmp++ScDnGeVTHMgtPZXjh03ABEpDoJpCvoAd46iQ98d+ZVmwMCZw1xAl4n0FQ9xUmh6aqKINIhayBY2l3zaabqIGjcT1cjKDkx4KXQkUboQJ1JlAdYR8LjN5JnsHAd8iCPjfiTgdOINB7q98R8uF1OBgIg4BnhEY3JAI+t1cwjwerzwDN9AEakigGkI+zJ5EfCJMEKobb41juU9hMedxSGKN1yudzgosz35xvPoHWpgopPEIZvOVesFwa02g+gTKLeTDbAWcTsTLQ1fdSMTHLFYtA3cBe9Dgoy2TpD9mgEM4gOurP7zdQhOoB4FyCvk5zOJxPgXMDiGUWjRzNLMZJqJRj66bQivlS1+QsPp4/MG3ejJrAGexEkc4Jn0KHH2rCRSUQPmEfJjXEnE+sHZsaY4C5zCTD3sFZBcjTCtWZ3IiEfuHD0CtKH03Q3y3i6d9iwmYQEEJlEfIZVWOcFLw+8qmvIkZ7MMB/LKgbItbrflsyQBnAy9OKtngRAY5yt9mittlrpkJTESgHEI+toz+EiLeEIRnIYMMWnh6GNxj7pYzgTmB6bd5iD05nId7yNWPmoAJ9IFA8YV8TMSvJuIliStFkRiDnNoHVtUscpjDk/BEbdfQ4Foe4tUW82p2tVtVXQLFFvKxMLqr4uXn2wCPAHsyyLeq2x19atkCdmE0+cazAg1+yGJeV8uwzT7hd7Em0CuBYgv5MBcTsRfwT2AnBvlFrw328+MQWMg2jCYfkopquYhB9jYrEzCBchAorpDP5wAGWJBMxTV4GUP8vBxIS1zL+WzLANcEn7miWc4rcWtcdROoDYFiCvlCNmU0sb5XTBb8DPK+2vRIvxs6whnAQYkrawYvZH9u7XeVXL4JmMDEBIop5MN8n4hXA3fxKJv00V+rlaM/62IQaTfFtbq4r/WWrwK7Fm5PeE0uP5zscb5uskPkYLLLopMJmECBCRRPyBfwAhr8OmEWsS2z+XEf+TWF/C/xXuDXTlCPf8fHtWmRzVRSu5C/CfhGfJDFO5OtaPuZWl0s2v98kF/1szou2wRMoGwW+QifjSc33xvvsz2fQQ7scwc2hfxi4G0p12VtYOVkg6+xVBwhV21GGAlbIHwm3jnysJTb7uxMwARSJFA8i3wEWb/rELFZAY4xy1LI27uxWEI+zBZE3JgcdTeYHD3nZAImUFACxRLysUnO3yYLfwaZWYCVm1MV8k0hEb+fAK8Km1Op65eLLW5F3TwHklOL7klC/OCtwUd+eRJe+eSk/cQVdtmfNHaWqA6ZnkGDjRniD/2piEs1AROYjECxhHyYvYn4AvAbBtlsssrn8PepCrmqdBTwMeA9sXCfG+p4ZNh58F3ABeH/WoVcR7a9EZLonIXx+aKaF9DftQiqf2mYm4mS80L3YpAv9a8iLtkETGAiAsUS8pHkZJvTaHAJQ4m12u/U7WSndg+UT1mpaX0/Oxbj5wGrQDJZ+H3gv1us9FYh13PFcq2oRiN8Oa679jM/iCHO6ndnuHwTMIHOBIol5MMcTcTxwEkMckQBOq3b8EOJ+FBLffXcdYAmSXU48kuAF0Di/2+mMgi59mB5f/ItYzDZy9zJBEyggASKJeQjyU58svy+yiC7F4DXdFwrzWp/EvhQ+OXdcVx2+yrJ4gv5MF8lYlcazGGI4QL0h6tgAibQgUCxhHzsWLIv0+BOhli/AD3Wi5Cr/rcHP7dCDRVr3pqKL+Qj3BUmaHdnEMW9O5mACRSQQNGEfGMa3BI4rcxgEjXRzzRdIRfXS2P3yuvjSc7l43BK7RkzWCohP51VWIH7Q503YpDb+tkRLtsETGB8AsUSctVzmHuIWIuIHZjN1X3uvOkKuXYOVPSNTrFXHlpM9ErgRy3tKbZFvpBXM5pM0P6RwWS5vpMJmEBBCRRRyM8nYh/gQgaTf/uZpiPk/xWH6/02EUB4GaB48JvjVZJ3x77/FwGPhgaNJ+Ra6n9OPxudlD3MF4iSrWzPYxD5+J1MwAQKSqB4Qj6fHRjgyoTXKFszh5/2kV234Yeq4nGQnB+qeOs3BxG/PtRdWw3oWLV58e/HjiPkrwG+F/LQvuCKEnmwL20fZiuisFlYxMuY3dXGYX2pqgs1ARPQtlRFTCP8X7zz3iuSVZKDbNnHKnYbfqgqalHP04KQfzqE7TWrPiOs9pRFrh9Z7O0WubbsVbiiVnhKwDcG7u1L20e4CW2W1eC7DPG6vtTBhZqACXRNoJhCvpDNWcL1RMxklNnMSVY7OuVB4IkQ0MUsYXMOXDr5nEfpLsMETGAaBIop5GrIMEcS8XEa3McSnsNBfXIzTANqaR8ZYVXgzuSbRYMPMpQcyuxkAiZQcALFFfIGEQuS1ZEvTVZJLs/O7LdMLHbB8ZaoemewBjO5goiX0OB6hpJoGycTMIESECiukAveQtZkNDlDciMa3M4MduQA7igB13JVcZjnEiUTrdqd8VYG2I4D0KlHTiZgAiUgUGwhX1bM76PBzn2OZClBt06himOnASlKRm4Vi/gU0PlWEygKgeILuUidzeosSY5BUyTL4tg634ehJMLDqRcCw7yViAuTHRsb/IiZ7Mb+fYqU6aUdftYEak6gHEKuTrqEGdyXRK/sF/rsYmZwBPsn+4E4TYXA2azL45xMxJ7JYw2GWZ33shdLppKN7zUBEygGgfIIeZPXfPYi4iwi1kg2pGpwMk/hE+zDf4qBtMC1uICVeSg5+OJwIlZI4tQb7MtQ8m3HyQRMoKQEyifkAj3C08My9l0C97tpcCSDXFiA4+GKNxQUAbSQ/RjlhGQfm7H09eQUo8E+HidXPFKukQmUkkA5hbyJepg3EHFSOLRB//tLIk5j9tIj1krZKalWegHvjmPxdYTc5sGNchMDHMFsrki1HGdmAibQNwLlFnJhk7U5wv+LDwk+noj1glj9i4hzmcGZtfShn8UGzED7u2g+YfUwum6jwTEMcpG/tfTtfXPBJpAJgfILeRPLXGayNnsQcRiwdfjvBg0uSzasGuSySgvYXAZ4Jm9ilDlEyX4tzb69jgancQ9fYh6PZzKKnKkJmEBfCVRHyFsxzudlRBwKvCXZr2XMcv87cDkDXMYA36lEmN1YWObO4QALibe2zFV6LDlpaYCTmM2NfR1hLtwETCBzAtUU8iY2TYo2kigX7au97VIrtcEoJNvjStQv4wB+XgprXVb3WmzFQHLy0Otp8FIiBlq+ffyIKNlV8UuexMz83XEBJlAYAtUW8lbM57AOj7N3fJTc3sl+Ik9O/4Bk8u8yZnB5oaz1sQ+jnYkS8daWsorYaU0/o8FFLMdFvCc5vMLJBEygZgTqI+StHXs2G7GEt4bj114OzGrrd+0zol0A76CR7O1yJxF3JtdD/CH1MbIAnVWqidr1abAuERsA69Fg/ThmXicOPZEaPBD2Nr+aGVzkvWdS7w1naAKlI1BPIW/vpmG2iDeN2o4GEvVtl0a/jN+dOhR6UfLTYBFRIq46DGLs97G/PUiUfECM/TSYRcTKYU+Tsd/1/xErTThqtFlYxI9p8JN407BrOCA5hcjJBEzABJYSsJB3GgznMIvH2ASSXQE3Sv5t8Nzwu1aUpp3+SSOx9P9AxK1Eyb9/YDG3eB/2tFE7PxOoHoH/H6hK+y2yFuv/AAAAAElFTkSuQmCC"}}	60
3	Functions	functions	core	easy	# Functions: Building Blocks of Modular Programming\n\n## What are Functions?\n\nFunctions are reusable blocks of code that perform specific tasks. They allow you to organize your program into smaller, manageable pieces, making your code more readable, maintainable, and efficient. Functions take inputs (parameters), process them, and often return outputs.\n\n## Types of Functions\n\n### Basic Functions\nFunctions that perform a task without returning a value.\n\n```javascript\nfunction greetUser() {\n    console.log("Hello, welcome to our program!");\n}\ngreetUser(); // Call the function\n```\n\n### Functions with Parameters\nFunctions that accept input values to work with.\n\n```javascript\nfunction greetUser(name) {\n    console.log(`Hello, ${name}! Welcome to our program!`);\n}\ngreetUser("Alice"); // Pass argument to function\n```\n\n### Functions with Return Values\nFunctions that process data and return a result.\n\n```javascript\nfunction addNumbers(a, b) {\n    return a + b;\n}\nlet result = addNumbers(5, 3); // result = 8\n```\n\n### Functions with Default Parameters\nFunctions that have default values for parameters if no argument is provided.\n\n```javascript\nfunction greetUser(name = "Guest") {\n    console.log(`Hello, ${name}!`);\n}\ngreetUser(); // Uses default: "Hello, Guest!"\ngreetUser("Bob"); // Uses provided: "Hello, Bob!"\n```\n\n## Real-Life Applications\n\n- **Code Organization**: Breaking large programs into smaller, manageable functions that each handle specific tasks, making debugging and maintenance much easier for development teams.\n\n- **API Development**: Creating reusable functions for database operations, user authentication, data validation, and business logic that can be called from multiple endpoints.\n\n- **Mathematical Calculations**: Building libraries of mathematical functions for complex calculations, statistical analysis, financial computations, and scientific applications.\n\n- **User Interface Components**: Developing reusable UI functions for form validation, data formatting, event handling, and dynamic content updates across web applications.\n\n## Best Practices\n\n### Function Naming\nUse clear, descriptive names that explain what the function does.\n\n```javascript\n// Good naming\nfunction calculateTotalPrice(price, tax) {\n    return price + (price * tax);\n}\n\n// Poor naming\nfunction calc(p, t) {\n    return p + (p * t);\n}\n```\n\n### Keep Functions Small and Focused\nEach function should do one thing well (Single Responsibility Principle).\n\n```javascript\n// Good: Single responsibility\nfunction validateEmail(email) {\n    return email.includes('@') && email.includes('.');\n}\n\nfunction sendEmail(email, message) {\n    if (validateEmail(email)) {\n        // Send email logic\n    }\n}\n\n// Avoid: Multiple responsibilities in one function\nfunction validateAndSendEmail(email, message) {\n    // Email validation AND sending in same function\n}\n```\n\n## The Power of Modularity\n\nFunctions are the foundation of clean, maintainable code. They promote code reuse, reduce duplication, and make complex programs easier to understand and debug. By breaking your program into well-designed functions, you create a modular architecture that can grow and adapt to changing requirements while remaining organized and efficient.\n	\N	70
5	Arrays	arrays	Linear DS	easy	# Arrays: Foundation of Data Structures\n\n## What are Arrays?\n\nArrays are a collection of items stored at contiguous memory locations. They are one of the most fundamental data structures in computer science, allowing you to store multiple values of the same type under a single variable name. Each element in an array can be accessed using its index, starting from 0.\n\n## Basic Array Operations\n\n### Array Declaration and Initialization\nCreating arrays with initial values.\n\n```javascript\n// Creating an array with values\nlet numbers = [1, 2, 3, 4, 5];\nlet fruits = ["apple", "banana", "orange"];\n\n// Creating empty array\nlet emptyArray = [];\n```\n\n### Accessing Array Elements\nRetrieving values using index positions.\n\n```javascript\nlet arr = [10, 20, 30, 40, 50];\nconsole.log(arr[0]); // 10 (first element)\nconsole.log(arr[2]); // 30 (third element)\nconsole.log(arr[arr.length - 1]); // 50 (last element)\n```\n\n## Array Algorithms\n\n### Linear Search\nFinding an element by checking each item sequentially.\n\n```javascript\nfunction linearSearch(arr, target) {\n    for (let i = 0; i < arr.length; i++) {\n        if (arr[i] === target) {\n            return i; // Return index if found\n        }\n    }\n    return -1; // Return -1 if not found\n}\n\n// Usage\nlet numbers = [5, 2, 8, 1, 9];\nconsole.log(linearSearch(numbers, 8)); // Output: 2\n```\n\n### Binary Search\nEfficiently finding an element in a sorted array.\n\n```javascript\nfunction binarySearch(arr, target) {\n    let left = 0;\n    let right = arr.length - 1;\n    \n    while (left <= right) {\n        let mid = Math.floor((left + right) / 2);\n        \n        if (arr[mid] === target) {\n            return mid;\n        } else if (arr[mid] < target) {\n            left = mid + 1;\n        } else {\n            right = mid - 1;\n        }\n    }\n    return -1;\n}\n\n// Usage (array must be sorted)\nlet sortedNumbers = [1, 3, 5, 7, 9, 11, 13];\nconsole.log(binarySearch(sortedNumbers, 7)); // Output: 3\n```\n\n### Bubble Sort\nSimple sorting algorithm that repeatedly swaps adjacent elements.\n\n```javascript\nfunction bubbleSort(arr) {\n    let n = arr.length;\n    for (let i = 0; i < n - 1; i++) {\n        for (let j = 0; j < n - i - 1; j++) {\n            if (arr[j] > arr[j + 1]) {\n                // Swap elements\n                let temp = arr[j];\n                arr[j] = arr[j + 1];\n                arr[j + 1] = temp;\n            }\n        }\n    }\n    return arr;\n}\n\n// Usage\nlet unsorted = [64, 34, 25, 12, 22, 11, 90];\nconsole.log(bubbleSort(unsorted)); // Output: [11, 12, 22, 25, 34, 64, 90]\n```\n\n### Array Rotation\nMoving elements to the left or right by a given number of positions.\n\n```javascript\nfunction rotateLeft(arr, positions) {\n    let n = arr.length;\n    positions = positions % n; // Handle positions greater than array length\n    \n    return arr.slice(positions).concat(arr.slice(0, positions));\n}\n\n// Usage\nlet original = [1, 2, 3, 4, 5];\nconsole.log(rotateLeft(original, 2)); // Output: [3, 4, 5, 1, 2]\n```\n\n### Kadane's Algorithm\nFinding the maximum sum of a contiguous subarray.\n\n```javascript\nfunction kadane(arr) {\n    let maxSoFar = arr[0];\n    let maxEndingHere = arr[0];\n    \n    for (let i = 1; i < arr.length; i++) {\n        maxEndingHere = Math.max(arr[i], maxEndingHere + arr[i]);\n        maxSoFar = Math.max(maxSoFar, maxEndingHere);\n    }\n    \n    return maxSoFar;\n}\n\n// Usage\nlet numbers = [-2, -3, 4, -1, -2, 1, 5, -3];\nconsole.log(kadane(numbers)); // Output: 7 (subarray [4, -1, -2, 1, 5])\n```\n\n## Real-Life Applications\n\n- **Database Systems**: Storing and organizing records in tables where each row can be represented as an array of column values, enabling efficient data retrieval and manipulation.\n\n- **Image Processing**: Digital images are stored as 2D arrays of pixels, where each element represents color values, allowing for operations like filtering, resizing, and enhancement.\n\n- **Game Development**: Managing game elements like player inventories, level maps, high scores, and sprite animations using arrays for efficient access and updates.\n\n- **Scientific Computing**: Storing and processing large datasets in mathematical computations, statistical analysis, and scientific simulations where arrays provide fast numerical operations.\n\n## Best Practices\n\n### Choose the Right Algorithm\nSelect algorithms based on your data characteristics and performance needs.\n\n```javascript\n// For unsorted data: Linear Search\n// For sorted data: Binary Search\n// For small datasets: Simple sorts like Bubble Sort\n// For large datasets: Advanced sorts like Quick Sort or Merge Sort\n```\n\n### Consider Memory Usage\nBe mindful of array size and memory consumption.\n\n```javascript\n// Avoid creating unnecessary large arrays\nlet efficientArray = new Array(1000).fill(0); // Better than loop creation\n```\n\n## The Power of Arrays\n\nArrays form the foundation of most data structures and algorithms. They provide efficient random access to elements and serve as building blocks for more complex structures like stacks, queues, and hash tables. Understanding arrays and their associated algorithms is crucial for developing efficient programs and solving computational problems effectively.\n	\N	60
6	Strings	strings	Linear DS	easy	# Strings: Sequences of Characters\n\n## What are Strings?\n\nStrings are sequences of characters stored in contiguous memory locations. They are one of the most fundamental data types in programming, used to represent text, words, sentences, and any sequence of characters. Strings can be manipulated, searched, and transformed using various algorithms and operations.\n\n## Basic String Operations\n\n### String Creation and Access\nCreating strings and accessing individual characters.\n\n```javascript\n// Creating strings\nlet text = "Hello World";\nlet greeting = 'Welcome to programming';\n\n// Accessing characters\nconsole.log(text[0]); // 'H'\nconsole.log(text.charAt(1)); // 'e'\nconsole.log(text.length); // 11\n```\n\n**Time Complexity**: O(1) for access by index  \n**Space Complexity**: O(1) for single character access\n\n## String Manipulation Algorithms\n\n### String Reversal\nReversing the order of characters in a string.\n\n```javascript\nfunction reverseString(str) {\n    let reversed = "";\n    for (let i = str.length - 1; i >= 0; i--) {\n        reversed += str[i];\n    }\n    return reversed;\n}\n\n// Usage\nconsole.log(reverseString("hello")); // "olleh"\n```\n\n**Time Complexity**: O(n) where n is the length of the string  \n**Space Complexity**: O(n) for the new reversed string\n\n### Palindrome Check\nChecking if a string reads the same forwards and backwards.\n\n```javascript\nfunction isPalindrome(str) {\n    let cleanStr = str.toLowerCase().replace(/[^a-zA-Z0-9]/g, '');\n    let left = 0;\n    let right = cleanStr.length - 1;\n    \n    while (left < right) {\n        if (cleanStr[left] !== cleanStr[right]) {\n            return false;\n        }\n        left++;\n        right--;\n    }\n    return true;\n}\n\n// Usage\nconsole.log(isPalindrome("A man a plan a canal Panama")); // true\nconsole.log(isPalindrome("race a car")); // false\n```\n\n**Time Complexity**: O(n) for traversing the string  \n**Space Complexity**: O(n) for the cleaned string\n\n### Anagram Check\nChecking if two strings contain the same characters with the same frequencies.\n\n```javascript\nfunction areAnagrams(str1, str2) {\n    if (str1.length !== str2.length) {\n        return false;\n    }\n    \n    let charCount = {};\n    \n    // Count characters in first string\n    for (let char of str1.toLowerCase()) {\n        charCount[char] = (charCount[char] || 0) + 1;\n    }\n    \n    // Subtract characters from second string\n    for (let char of str2.toLowerCase()) {\n        if (!charCount[char]) {\n            return false;\n        }\n        charCount[char]--;\n    }\n    \n    return true;\n}\n\n// Usage\nconsole.log(areAnagrams("listen", "silent")); // true\nconsole.log(areAnagrams("hello", "world")); // false\n```\n\n**Time Complexity**: O(n) where n is the length of the strings  \n**Space Complexity**: O(k) where k is the number of unique characters\n\n## String Searching Algorithms\n\n### Naive String Search\nSimple pattern matching by checking every possible position.\n\n```javascript\nfunction naiveSearch(text, pattern) {\n    let positions = [];\n    \n    for (let i = 0; i <= text.length - pattern.length; i++) {\n        let match = true;\n        for (let j = 0; j < pattern.length; j++) {\n            if (text[i + j] !== pattern[j]) {\n                match = false;\n                break;\n            }\n        }\n        if (match) {\n            positions.push(i);\n        }\n    }\n    \n    return positions;\n}\n\n// Usage\nconsole.log(naiveSearch("ababcababa", "aba")); // [0, 5, 7]\n```\n\n**Time Complexity**: O(n × m) where n is text length, m is pattern length  \n**Space Complexity**: O(1) for the algorithm itself\n\n### KMP (Knuth-Morris-Pratt) Algorithm\nEfficient pattern matching using failure function to avoid redundant comparisons.\n\n```javascript\nfunction buildLPS(pattern) {\n    let lps = new Array(pattern.length).fill(0);\n    let len = 0;\n    let i = 1;\n    \n    while (i < pattern.length) {\n        if (pattern[i] === pattern[len]) {\n            len++;\n            lps[i] = len;\n            i++;\n        } else {\n            if (len !== 0) {\n                len = lps[len - 1];\n            } else {\n                lps[i] = 0;\n                i++;\n            }\n        }\n    }\n    \n    return lps;\n}\n\nfunction kmpSearch(text, pattern) {\n    let lps = buildLPS(pattern);\n    let positions = [];\n    let i = 0; // text index\n    let j = 0; // pattern index\n    \n    while (i < text.length) {\n        if (text[i] === pattern[j]) {\n            i++;\n            j++;\n        }\n        \n        if (j === pattern.length) {\n            positions.push(i - j);\n            j = lps[j - 1];\n        } else if (i < text.length && text[i] !== pattern[j]) {\n            if (j !== 0) {\n                j = lps[j - 1];\n            } else {\n                i++;\n            }\n        }\n    }\n    \n    return positions;\n}\n\n// Usage\nconsole.log(kmpSearch("ababcababa", "aba")); // [0, 5, 7]\n```\n\n**Time Complexity**: O(n + m) where n is text length, m is pattern length  \n**Space Complexity**: O(m) for the LPS array\n\n### Rabin-Karp Algorithm\nString matching using rolling hash for efficient comparisons.\n\n```javascript\nfunction rabinKarp(text, pattern) {\n    const prime = 101;\n    const base = 256;\n    let positions = [];\n    let patternHash = 0;\n    let textHash = 0;\n    let h = 1;\n    \n    // Calculate h = base^(pattern.length-1) % prime\n    for (let i = 0; i < pattern.length - 1; i++) {\n        h = (h * base) % prime;\n    }\n    \n    // Calculate initial hash values\n    for (let i = 0; i < pattern.length; i++) {\n        patternHash = (base * patternHash + pattern.charCodeAt(i)) % prime;\n        textHash = (base * textHash + text.charCodeAt(i)) % prime;\n    }\n    \n    // Slide the pattern over text\n    for (let i = 0; i <= text.length - pattern.length; i++) {\n        // Check if hash values match\n        if (patternHash === textHash) {\n            // Verify character by character\n            let match = true;\n            for (let j = 0; j < pattern.length; j++) {\n                if (text[i + j] !== pattern[j]) {\n                    match = false;\n                    break;\n                }\n            }\n            if (match) {\n                positions.push(i);\n            }\n        }\n        \n        // Calculate next hash value\n        if (i < text.length - pattern.length) {\n            textHash = (base * (textHash - text.charCodeAt(i) * h) + text.charCodeAt(i + pattern.length)) % prime;\n            if (textHash < 0) {\n                textHash += prime;\n            }\n        }\n    }\n    \n    return positions;\n}\n\n// Usage\nconsole.log(rabinKarp("ababcababa", "aba")); // [0, 5, 7]\n```\n\n**Time Complexity**: O(n + m) average case, O(n × m) worst case  \n**Space Complexity**: O(1) for the algorithm\n\n## Real-Life Applications\n\n- **Text Processing**: Document analysis, spell checkers, and text editors use string algorithms for find/replace operations, auto-completion, and content validation.\n\n- **Web Development**: URL parsing, input validation, template processing, and search functionality in web applications rely heavily on string manipulation and pattern matching.\n\n- **Data Mining**: Log analysis, data extraction from unstructured text, and pattern recognition in large datasets use advanced string searching algorithms for efficient processing.\n\n- **Bioinformatics**: DNA sequence analysis, protein structure prediction, and genetic pattern matching use string algorithms to find similarities and patterns in biological data.\n\n## Algorithm Comparison\n\n### Time Complexity Summary\n- **Naive Search**: O(n × m) - Simple but inefficient for large texts\n- **KMP Algorithm**: O(n + m) - Optimal for single pattern searches\n- **Rabin-Karp**: O(n + m) average - Good for multiple pattern searches\n\n### Space Complexity Summary\n- **Naive Search**: O(1) - Minimal memory usage\n- **KMP Algorithm**: O(m) - Requires LPS array\n- **Rabin-Karp**: O(1) - Constant space usage\n\n## Best Practices\n\n### Choose the Right Algorithm\nSelect algorithms based on your specific use case and constraints.\n\n```javascript\n// For simple, small-scale searches: Naive search\n// For single pattern, large text: KMP algorithm\n// For multiple patterns: Rabin-Karp with rolling hash\n// For built-in functionality: Use language-specific methods\n```\n\n### Memory Optimization\nConsider memory usage when working with large strings.\n\n```javascript\n// Efficient string building\nlet parts = [];\nfor (let i = 0; i < data.length; i++) {\n    parts.push(processData(data[i]));\n}\nlet result = parts.join(''); // Better than repeated concatenation\n```\n\n## The Power of String Algorithms\n\nString algorithms form the backbone of text processing, search engines, and data analysis systems. Understanding these algorithms and their complexity characteristics is crucial for building efficient text-processing applications. From simple manipulations to advanced pattern matching, strings algorithms enable us to extract meaningful information from textual data efficiently.\n	\N	70
7	Linked Lists	linked-lists	Linear DS	medium	# Linked Lists\n\n## Introduction\n\nA linked list is a linear data structure where elements are stored in nodes that are linked using pointers. Unlike arrays, linked list elements are not stored at contiguous memory locations. Each node contains data and a reference (or pointer) to the next node in the sequence.\n\n```\nVisual representation of a singly linked list:\n\n[Data|Next] → [Data|Next] → [Data|Next] → null\n    Node 1       Node 2       Node 3\n```\n\n## Types of Linked Lists\n\n### 1. Singly Linked List\n\nIn a singly linked list, each node points to the next node in the sequence. The last node points to `null`.\n\n```\nHead → [Data|Next] → [Data|Next] → [Data|Next] → null\n```\n\n```javascript\nclass Node {\n     constructor(data) {\n          this.data = data;\n          this.next = null;\n     }\n}\n\nclass SinglyLinkedList {\n     constructor() {\n          this.head = null;\n          this.size = 0;\n     }\n}\n```\n\n### 2. Doubly Linked List\n\nIn a doubly linked list, each node contains references to both the next and previous nodes.\n\n```\n         ┌─────────┐     ┌─────────┐     ┌─────────┐\nnull ← │Prev|Data|Next│⟷│Prev|Data|Next│⟷│Prev|Data|Next│→ null\n         └─────────┘     └─────────┘     └─────────┘\n            Head            Node 2          Tail\n```\n\n```javascript\nclass Node {\n     constructor(data) {\n          this.data = data;\n          this.next = null;\n          this.prev = null;\n     }\n}\n\nclass DoublyLinkedList {\n     constructor() {\n          this.head = null;\n          this.tail = null;\n          this.size = 0;\n     }\n}\n```\n\n### 3. Circular Linked List\n\nA circular linked list can be either singly or doubly linked. The key difference is that the last node points back to the first node, creating a circle.\n\n```\n     ┌───────────────────────────┐\n     ↓                           |\n[Data|Next] → [Data|Next] → [Data|Next]\n    Head        Node 2       Node 3\n```\n\n```javascript\nclass CircularLinkedList {\n     constructor() {\n          this.head = null;\n          this.size = 0;\n     }\n     \n     // In a circular list, the last node points to the head\n     append(data) {\n          const newNode = new Node(data);\n          \n          if (!this.head) {\n                this.head = newNode;\n                newNode.next = this.head; // Points to itself\n          } else {\n                let current = this.head;\n                while (current.next !== this.head) {\n                     current = current.next;\n                }\n                current.next = newNode;\n                newNode.next = this.head;\n          }\n          this.size++;\n     }\n}\n```\n\n## Linked List Operations and Algorithms\n\n### Traversal\n\nTraversing a linked list involves visiting each node, typically from head to tail.\n\n```\nTraversal:\n[Head] → [Node 1] → [Node 2] → [Node 3] → null\n    ↑        ↑          ↑          ↑\n    1        2          3          4       (Steps)\n```\n\n```javascript\ntraverseList() {\n     let current = this.head;\n     while (current) {\n          console.log(current.data);\n          current = current.next;\n     }\n}\n```\n\n**Time Complexity**: O(n) - We must visit each node once.  \n**Space Complexity**: O(1) - We only use a single pointer regardless of list size.\n\n### Insertion\n\n#### 1. Insertion at the Beginning\n\n```\nBefore: Head → [A] → [B] → [C]\nAfter:  Head → [X] → [A] → [B] → [C]\n```\n\n```javascript\ninsertAtBeginning(data) {\n     const newNode = new Node(data);\n     newNode.next = this.head;\n     this.head = newNode;\n     this.size++;\n}\n```\n\n**Time Complexity**: O(1) - Constant time operation.  \n**Space Complexity**: O(1) - Only creating one new node.\n\n#### 2. Insertion at the End\n\n```\nBefore: Head → [A] → [B] → [C] → null\nAfter:  Head → [A] → [B] → [C] → [X] → null\n```\n\n```javascript\ninsertAtEnd(data) {\n     const newNode = new Node(data);\n     \n     // If list is empty\n     if (!this.head) {\n          this.head = newNode;\n     } else {\n          let current = this.head;\n          while (current.next) {\n                current = current.next;\n          }\n          current.next = newNode;\n     }\n     \n     this.size++;\n}\n```\n\n**Time Complexity**: O(n) - Need to traverse to the end.  \n**Space Complexity**: O(1) - Only creating one new node.\n\n#### 3. Insertion at a Specific Position\n\n```\nInsert at position 2:\nBefore: Head → [A] → [B] → [C]\nAfter:  Head → [A] → [X] → [B] → [C]\n```\n\n```javascript\ninsertAt(data, index) {\n     if (index < 0 || index > this.size) {\n          return false; // Invalid position\n     }\n     \n     // Insert at beginning\n     if (index === 0) {\n          this.insertAtBeginning(data);\n          return true;\n     }\n     \n     const newNode = new Node(data);\n     let current = this.head;\n     let previous;\n     let count = 0;\n     \n     while (count < index) {\n          previous = current;\n          current = current.next;\n          count++;\n     }\n     \n     newNode.next = current;\n     previous.next = newNode;\n     this.size++;\n     \n     return true;\n}\n```\n\n**Time Complexity**: O(n) in worst case (inserting at the end).  \n**Space Complexity**: O(1) - Only creating one new node.\n\n### Deletion\n\n#### 1. Deletion from the Beginning\n\n```\nBefore: Head → [A] → [B] → [C]\nAfter:  Head → [B] → [C]\n```\n\n```javascript\nremoveFromBeginning() {\n     if (!this.head) {\n          return null;\n     }\n     \n     const removedNode = this.head;\n     this.head = this.head.next;\n     this.size--;\n     \n     return removedNode.data;\n}\n```\n\n**Time Complexity**: O(1) - Constant time operation.  \n**Space Complexity**: O(1) - No additional space needed.\n\n#### 2. Deletion from the End\n\n```\nBefore: Head → [A] → [B] → [C]\nAfter:  Head → [A] → [B]\n```\n\n```javascript\nremoveFromEnd() {\n     if (!this.head) {\n          return null;\n     }\n     \n     // If only one element exists\n     if (!this.head.next) {\n          const removedNode = this.head;\n          this.head = null;\n          this.size--;\n          return removedNode.data;\n     }\n     \n     let current = this.head;\n     let previous;\n     \n     while (current.next) {\n          previous = current;\n          current = current.next;\n     }\n     \n     previous.next = null;\n     this.size--;\n     \n     return current.data;\n}\n```\n\n**Time Complexity**: O(n) - Need to traverse to the end.  \n**Space Complexity**: O(1) - No additional space needed.\n\n### Reversing a Linked List\n\n```\nBefore: [A] → [B] → [C] → null\nAfter:  [C] → [B] → [A] → null\n\nReversal steps:\n1. [A] → [B] → [C] → null\n2. null ← [A]  [B] → [C] → null\n3. null ← [A] ← [B]  [C] → null\n4. null ← [A] ← [B] ← [C]\n```\n\n```javascript\nreverse() {\n     let prev = null;\n     let current = this.head;\n     let next = null;\n     \n     while (current) {\n          // Store next\n          next = current.next;\n          \n          // Reverse current node's pointer\n          current.next = prev;\n          \n          // Move pointers one position ahead\n          prev = current;\n          current = next;\n     }\n     \n     // Update head\n     this.head = prev;\n}\n```\n\n**Time Complexity**: O(n) - We must visit each node once.  \n**Space Complexity**: O(1) - Only using a constant amount of extra space.\n\n### Cycle Detection: Floyd's Cycle-Finding Algorithm\n\nAlso known as the "tortoise and hare" algorithm, it uses two pointers moving at different speeds to detect cycles.\n\n```\nCycle detection:\n        ┌───────────────┐\n        ↓               |\n[A] → [B] → [C] → [D] → [E]\n ↑     ↑\nslow  fast\n```\n\n```javascript\nhasCycle() {\n     if (!this.head || !this.head.next) {\n          return false;\n     }\n     \n     let slow = this.head;\n     let fast = this.head;\n     \n     while (fast && fast.next) {\n          slow = slow.next;         // Move slow pointer by 1\n          fast = fast.next.next;    // Move fast pointer by 2\n          \n          if (slow === fast) {\n                return true;  // Cycle detected\n          }\n     }\n     \n     return false;  // No cycle\n}\n```\n\n**Time Complexity**: O(n) - In the worst case, we might need to traverse the entire list.  \n**Space Complexity**: O(1) - Only using two pointers regardless of list size.\n\n### Merge Two Sorted Lists\n\n```\nList 1: [1] → [3] → [5]\nList 2: [2] → [4] → [6]\n\nMerged: [1] → [2] → [3] → [4] → [5] → [6]\n```\n\n```javascript\nmergeTwoLists(list1, list2) {\n     const dummy = new Node(0);\n     let tail = dummy;\n     \n     while (list1 && list2) {\n          if (list1.data <= list2.data) {\n                tail.next = list1;\n                list1 = list1.next;\n          } else {\n                tail.next = list2;\n                list2 = list2.next;\n          }\n          tail = tail.next;\n     }\n     \n     // Attach remaining nodes\n     tail.next = list1 || list2;\n     \n     return dummy.next;\n}\n```\n\n**Time Complexity**: O(n + m) where n and m are the lengths of the two lists.  \n**Space Complexity**: O(1) - We're reusing the existing nodes.\n\n## Real-World Applications\n\n### 1. Implementation of Stack and Queue\n\nLinked lists are often used to implement other data structures like stacks and queues due to their dynamic memory allocation capabilities.\n\n```\nStack implementation:\nPush: add to head\nPop: remove from head\n\nTop\n ↓\n[A] → [B] → [C]\n```\n\n```javascript\n// Simple stack implementation using linked list\nclass Stack {\n     constructor() {\n          this.list = new SinglyLinkedList();\n     }\n     \n     push(data) {\n          this.list.insertAtBeginning(data);\n     }\n     \n     pop() {\n          return this.list.removeFromBeginning();\n     }\n     \n     peek() {\n          return this.list.head ? this.list.head.data : null;\n     }\n     \n     isEmpty() {\n          return this.list.size === 0;\n     }\n}\n```\n\n### 2. Browser History\n\nDoubly linked lists can be used to implement browser history (forward and backward navigation).\n\n```\nBrowser History:\n[Google] ⟷ [Wikipedia] ⟷ [YouTube] ⟷ [GitHub]\n                                     ↑\n                                 Current\n```\n\n```javascript\nclass BrowserHistory {\n     constructor(homepage) {\n          this.current = new Node(homepage);\n     }\n     \n     visit(url) {\n          // Create new node\n          const newPage = new Node(url);\n          \n          // Link to current page\n          this.current.next = newPage;\n          newPage.prev = this.current;\n          \n          // Move to new page\n          this.current = newPage;\n     }\n     \n     back(steps) {\n          while (steps > 0 && this.current.prev) {\n                this.current = this.current.prev;\n                steps--;\n          }\n          return this.current.data;\n     }\n     \n     forward(steps) {\n          while (steps > 0 && this.current.next) {\n                this.current = this.current.next;\n                steps--;\n          }\n          return this.current.data;\n     }\n}\n```\n\n## Conclusion\n\nLinked lists provide efficient insertion and deletion operations compared to arrays, especially when dealing with large datasets that frequently change in size. The choice between the different types of linked lists depends on the specific requirements of your application. Understanding the time and space complexities of linked list operations helps in making informed decisions about when to use them.	\N	90
8	Stacks	stacks	Linear DS	medium	# Stacks\n\n## Introduction\n\nA stack is a linear data structure that follows the Last-In-First-Out (LIFO) principle. This means that the last element added to the stack will be the first one to be removed. Think of it like a stack of plates - you can only take the top plate, and you can only add a new plate to the top.\n\n```\nVisual representation of a stack:\n\n    ┌───┐\n    │ D │  ← Top (Last In, First Out)\n    ├───┤\n    │ C │\n    ├───┤\n    │ B │\n    ├───┤\n    │ A │  ← Bottom (First In, Last Out)\n    └───┘\n```\n\n## Basic Operations\n\nStacks have the following primary operations:\n\n1. **Push**: Add an element to the top of the stack\n2. **Pop**: Remove the top element from the stack\n3. **Peek/Top**: View the top element without removing it\n4. **isEmpty**: Check if the stack is empty\n\nAll of these operations typically have O(1) time complexity.\n\n## Implementations\n\n### Array-based Implementation\n\n```javascript\nclass ArrayStack {\n    constructor() {\n        this.items = [];\n    }\n    \n    // Add element to the top of the stack\n    push(element) {\n        this.items.push(element);\n    }\n    \n    // Remove and return the top element\n    pop() {\n        if (this.isEmpty()) {\n            return "Underflow - Stack is empty";\n        }\n        return this.items.pop();\n    }\n    \n    // Return the top element without removing it\n    peek() {\n        if (this.isEmpty()) {\n            return "Stack is empty";\n        }\n        return this.items[this.items.length - 1];\n    }\n    \n    // Check if stack is empty\n    isEmpty() {\n        return this.items.length === 0;\n    }\n    \n    // Return the size of the stack\n    size() {\n        return this.items.length;\n    }\n    \n    // Clear the stack\n    clear() {\n        this.items = [];\n    }\n}\n```\n\n### Linked List-based Implementation\n\n```javascript\nclass Node {\n    constructor(data) {\n        this.data = data;\n        this.next = null;\n    }\n}\n\nclass LinkedListStack {\n    constructor() {\n        this.top = null;\n        this.size = 0;\n    }\n    \n    // Add element to the top of the stack\n    push(element) {\n        const newNode = new Node(element);\n        newNode.next = this.top;\n        this.top = newNode;\n        this.size++;\n    }\n    \n    // Remove and return the top element\n    pop() {\n        if (this.isEmpty()) {\n            return "Underflow - Stack is empty";\n        }\n        \n        const removedNode = this.top;\n        this.top = this.top.next;\n        this.size--;\n        \n        return removedNode.data;\n    }\n    \n    // Return the top element without removing it\n    peek() {\n        if (this.isEmpty()) {\n            return "Stack is empty";\n        }\n        return this.top.data;\n    }\n    \n    // Check if stack is empty\n    isEmpty() {\n        return this.top === null;\n    }\n    \n    // Return the size of the stack\n    getSize() {\n        return this.size;\n    }\n    \n    // Clear the stack\n    clear() {\n        this.top = null;\n        this.size = 0;\n    }\n}\n```\n\n## Applications and Algorithms\n\n### 1. Parentheses Matching\n\nOne of the most common applications of stacks is checking whether a string of parentheses is balanced. The algorithm works as follows:\n\n1. Iterate through each character in the string\n2. If the character is an opening bracket (`(`, `{`, or `[`), push it onto the stack\n3. If the character is a closing bracket (`)`, `}`, or `]`), check if the stack is empty or if the top element matches the corresponding opening bracket\n4. At the end, the stack should be empty for a balanced expression\n\n```javascript\nfunction isBalanced(expression) {\n    const stack = [];\n    const brackets = {\n        ')': '(',\n        '}': '{',\n        ']': '['\n    };\n    \n    for (let char of expression) {\n        if (char === '(' || char === '{' || char === '[') {\n            stack.push(char);\n        } else if (char === ')' || char === '}' || char === ']') {\n            if (stack.length === 0 || stack.pop() !== brackets[char]) {\n                return false;\n            }\n        }\n    }\n    \n    return stack.length === 0;\n}\n\n// Examples\nconsole.log(isBalanced("({[]})")); // true\nconsole.log(isBalanced("({[})")); // false\n```\n\n### 2. Infix to Postfix/Prefix Conversion\n\nStacks are used to convert mathematical expressions from infix notation (e.g., `a + b`) to postfix notation (e.g., `a b +`) or prefix notation (e.g., `+ a b`).\n\n#### Infix to Postfix Algorithm:\n\n1. Initialize an empty stack and an empty result string\n2. Scan the infix expression from left to right\n3. If the scanned character is an operand, add it to the result\n4. If the scanned character is an operator:\n   - While the stack is not empty and the precedence of the scanned operator is less than or equal to the precedence of the operator at the top of the stack, pop the stack and add to the result\n   - Push the scanned operator onto the stack\n5. If the scanned character is an opening bracket, push it onto the stack\n6. If the scanned character is a closing bracket, pop the stack and add to the result until an opening bracket is encountered\n7. After scanning the entire expression, pop any remaining operators from the stack and add to the result\n\n```javascript\nfunction infixToPostfix(expression) {\n    const precedence = {\n        '+': 1,\n        '-': 1,\n        '*': 2,\n        '/': 2,\n        '^': 3\n    };\n    \n    const stack = [];\n    let result = '';\n    \n    for (let char of expression) {\n        // If character is operand, add to result\n        if (/[a-zA-Z0-9]/.test(char)) {\n            result += char;\n        }\n        // If character is opening bracket, push to stack\n        else if (char === '(') {\n            stack.push(char);\n        }\n        // If character is closing bracket, pop until opening bracket\n        else if (char === ')') {\n            while (stack.length > 0 && stack[stack.length - 1] !== '(') {\n                result += stack.pop();\n            }\n            if (stack.length > 0 && stack[stack.length - 1] === '(') {\n                stack.pop(); // Remove the '('\n            }\n        }\n        // If character is an operator\n        else if (char in precedence) {\n            while (\n                stack.length > 0 &&\n                stack[stack.length - 1] !== '(' &&\n                precedence[char] <= precedence[stack[stack.length - 1]]\n            ) {\n                result += stack.pop();\n            }\n            stack.push(char);\n        }\n    }\n    \n    // Pop all remaining operators\n    while (stack.length > 0) {\n        result += stack.pop();\n    }\n    \n    return result;\n}\n\n// Example\nconsole.log(infixToPostfix("a+b*(c^d-e)^(f+g*h)-i")); // abcd^e-fg*h+^*+i-\n```\n\n### 3. Next Greater Element\n\nThe "Next Greater Element" problem involves finding the next greater element for each element in an array. If there is no greater element, the result is -1. Stacks provide an efficient O(n) solution:\n\n```javascript\nfunction nextGreaterElements(arr) {\n    const stack = [];\n    const result = new Array(arr.length).fill(-1);\n    \n    for (let i = 0; i < arr.length; i++) {\n        // While stack is not empty and current element is greater than element at stack's top index\n        while (stack.length > 0 && arr[i] > arr[stack[stack.length - 1]]) {\n            const index = stack.pop();\n            result[index] = arr[i];\n        }\n        stack.push(i);\n    }\n    \n    return result;\n}\n\n// Example\nconsole.log(nextGreaterElements([4, 5, 2, 10, 8])); // [5, 10, 10, -1, -1]\n```\n\n## Time and Space Complexity\n\nFor a stack implemented using either an array or a linked list:\n\n| Operation | Time Complexity | Space Complexity |\n|-----------|-----------------|------------------|\n| Push      | O(1)            | O(1)             |\n| Pop       | O(1)            | O(1)             |\n| Peek      | O(1)            | O(1)             |\n| isEmpty   | O(1)            | O(1)             |\n\n## Advantages and Disadvantages\n\n### Array Implementation\n\n**Advantages:**\n- Simple implementation\n- Memory is saved as pointers are not involved\n\n**Disadvantages:**\n- In many languages, arrays have fixed size, limiting the stack size\n- If the array needs to be resized, it can be O(n) time complexity\n\n### Linked List Implementation\n\n**Advantages:**\n- Dynamic size\n- No need to define the size in advance\n\n**Disadvantages:**\n- Requires extra memory for pointer storage\n- Slightly more complex implementation\n\n## Conclusion\n\nStacks are fundamental data structures with numerous applications in algorithm design and programming. Their simplicity and efficiency make them ideal for solving problems like expression evaluation, backtracking, and syntax parsing. Understanding when and how to use stacks can significantly improve the efficiency of your algorithms and simplify complex tasks.	\N	100
9	Queue	queues	Linear DS	medium	# Queues\n\n## Introduction\n\nA queue is a linear data structure that follows the First-In-First-Out (FIFO) principle. This means that the first element added to the queue will be the first one to be removed. Think of it like a line of people waiting at a checkout counter - the first person to join the line is the first one to be served.\n\n```\nVisual representation of a queue:\n\n  Front                                 Rear\n  (Dequeue)                           (Enqueue)\n    ↓                                     ↓\n  ┌───┐      ┌───┐      ┌───┐      ┌───┐\n  │ A │ ──→  │ B │ ──→  │ C │ ──→  │ D │\n  └───┘      └───┘      └───┘      └───┘\n\n  First In                            Last In\n  First Out                          Last Out\n```\n\n## Types of Queues\n\n### 1. Simple Queue\nThe basic queue structure as described above, following the FIFO principle.\n\n### 2. Circular Queue\nA queue where the last position is connected back to the first position to form a circle. This helps in better memory utilization.\n\n```\nVisual representation of a circular queue:\n\n       ┌───────────────────┐\n       ↓                   │\n    ┌───┐     ┌───┐     ┌───┐\n    │ A │ ──→ │ B │ ──→ │ C │\n    └───┘     └───┘     └───┘\n      ↑                   │\n      └───────────────────┘\n```\n\n### 3. Priority Queue\nA queue where each element has a priority assigned to it. Elements with higher priority are served before elements with lower priority.\n\n```\nVisual representation of a priority queue:\n\n  Front                                 Rear\n    ↓                                     ↓\n  ┌─────┐    ┌─────┐    ┌─────┐    ┌─────┐\n  │A (5)│ ─→ │B (3)│ ─→ │C (3)│ ─→ │D (1)│\n  └─────┘    └─────┘    └─────┘    └─────┘\n  \n  (Numbers in parentheses indicate priority - higher number = higher priority)\n```\n\n### 4. Deque (Double-Ended Queue)\nA queue that allows insertion and removal of elements from both ends.\n\n```\nVisual representation of a deque:\n\n       Insertion/Removal         Insertion/Removal\n            ↓                         ↓\n  ┌───┐     ┌───┐     ┌───┐     ┌───┐\n  │ A │ ◄─► │ B │ ◄─► │ C │ ◄─► │ D │\n  └───┘     └───┘     └───┘     └───┘\n```\n\n## Basic Operations\n\nQueues have the following primary operations:\n\n1. **Enqueue**: Add an element to the rear of the queue\n2. **Dequeue**: Remove an element from the front of the queue\n3. **Front/Peek**: View the front element without removing it\n4. **isEmpty**: Check if the queue is empty\n\nAll of these operations typically have O(1) time complexity.\n\n## Implementations\n\n### Array-based Implementation (Simple Queue)\n\n```javascript\nclass ArrayQueue {\n    constructor() {\n        this.items = [];\n    }\n    \n    // Add element to the rear of the queue\n    enqueue(element) {\n        this.items.push(element);\n    }\n    \n    // Remove and return the front element\n    dequeue() {\n        if (this.isEmpty()) {\n            return "Underflow - Queue is empty";\n        }\n        return this.items.shift();\n    }\n    \n    // Return the front element without removing it\n    front() {\n        if (this.isEmpty()) {\n            return "Queue is empty";\n        }\n        return this.items[0];\n    }\n    \n    // Check if queue is empty\n    isEmpty() {\n        return this.items.length === 0;\n    }\n    \n    // Return the size of the queue\n    size() {\n        return this.items.length;\n    }\n    \n    // Clear the queue\n    clear() {\n        this.items = [];\n    }\n}\n```\n\n### Linked List-based Implementation (Simple Queue)\n\n```javascript\nclass Node {\n    constructor(data) {\n        this.data = data;\n        this.next = null;\n    }\n}\n\nclass LinkedListQueue {\n    constructor() {\n        this.front = null;\n        this.rear = null;\n        this.size = 0;\n    }\n    \n    // Add element to the rear of the queue\n    enqueue(element) {\n        const newNode = new Node(element);\n        \n        // If queue is empty, set both front and rear to the new node\n        if (this.isEmpty()) {\n            this.front = newNode;\n            this.rear = newNode;\n        } else {\n            // Add the new node at the end and update the rear reference\n            this.rear.next = newNode;\n            this.rear = newNode;\n        }\n        \n        this.size++;\n    }\n    \n    // Remove and return the front element\n    dequeue() {\n        if (this.isEmpty()) {\n            return "Underflow - Queue is empty";\n        }\n        \n        const removedNode = this.front;\n        this.front = this.front.next;\n        \n        // If front becomes null, set rear to null as well (queue is empty)\n        if (this.front === null) {\n            this.rear = null;\n        }\n        \n        this.size--;\n        \n        return removedNode.data;\n    }\n    \n    // Return the front element without removing it\n    front() {\n        if (this.isEmpty()) {\n            return "Queue is empty";\n        }\n        return this.front.data;\n    }\n    \n    // Check if queue is empty\n    isEmpty() {\n        return this.front === null;\n    }\n    \n    // Return the size of the queue\n    getSize() {\n        return this.size;\n    }\n    \n    // Clear the queue\n    clear() {\n        this.front = null;\n        this.rear = null;\n        this.size = 0;\n    }\n}\n```\n\n### Circular Queue Implementation\n\n```javascript\nclass CircularQueue {\n    constructor(capacity) {\n        this.items = new Array(capacity);\n        this.capacity = capacity;\n        this.currentLength = 0;\n        this.front = -1;\n        this.rear = -1;\n    }\n    \n    // Check if queue is full\n    isFull() {\n        return this.currentLength === this.capacity;\n    }\n    \n    // Check if queue is empty\n    isEmpty() {\n        return this.currentLength === 0;\n    }\n    \n    // Add element to the queue\n    enqueue(element) {\n        if (this.isFull()) {\n            return "Overflow - Queue is full";\n        }\n        \n        this.rear = (this.rear + 1) % this.capacity;\n        this.items[this.rear] = element;\n        \n        // If this is the first element, set front to 0\n        if (this.front === -1) {\n            this.front = 0;\n        }\n        \n        this.currentLength++;\n        return element;\n    }\n    \n    // Remove and return the front element\n    dequeue() {\n        if (this.isEmpty()) {\n            return "Underflow - Queue is empty";\n        }\n        \n        const item = this.items[this.front];\n        this.items[this.front] = null;\n        this.front = (this.front + 1) % this.capacity;\n        this.currentLength--;\n        \n        // Reset front and rear pointers when queue becomes empty\n        if (this.isEmpty()) {\n            this.front = -1;\n            this.rear = -1;\n        }\n        \n        return item;\n    }\n    \n    // Return the front element without removing it\n    peek() {\n        if (this.isEmpty()) {\n            return "Queue is empty";\n        }\n        return this.items[this.front];\n    }\n    \n    // Print the queue elements\n    print() {\n        if (this.isEmpty()) {\n            console.log("Queue is empty");\n            return;\n        }\n        \n        let i;\n        let str = "";\n        for (i = this.front; i !== this.rear; i = (i + 1) % this.capacity) {\n            str += this.items[i] + " ";\n        }\n        str += this.items[i];\n        console.log(str);\n    }\n}\n```\n\n## Applications and Algorithms\n\n### 1. Breadth-First Search (BFS)\n\nBFS is a graph traversal algorithm that explores all vertices at the current depth before moving to vertices at the next depth level. It uses a queue to keep track of the next vertices to visit.\n\n```javascript\nfunction bfs(graph, startNode) {\n    const visited = new Set();\n    const queue = [];\n    \n    // Add the starting node to the queue and mark it as visited\n    queue.push(startNode);\n    visited.add(startNode);\n    \n    while (queue.length > 0) {\n        // Dequeue a vertex from the queue\n        const currentNode = queue.shift();\n        console.log(currentNode); // Process the node\n        \n        // Get all adjacent vertices of the dequeued vertex\n        // If an adjacent vertex has not been visited, mark it as visited and enqueue it\n        const neighbors = graph[currentNode] || [];\n        for (const neighbor of neighbors) {\n            if (!visited.has(neighbor)) {\n                visited.add(neighbor);\n                queue.push(neighbor);\n            }\n        }\n    }\n}\n\n// Example usage\nconst graph = {\n    'A': ['B', 'C'],\n    'B': ['A', 'D', 'E'],\n    'C': ['A', 'F'],\n    'D': ['B'],\n    'E': ['B', 'F'],\n    'F': ['C', 'E']\n};\n\nconsole.log("BFS traversal starting from vertex 'A':");\nbfs(graph, 'A'); // Output: A B C D E F\n```\n\n### 2. Sliding Window Maximum\n\nThe sliding window maximum problem involves finding the maximum element in each fixed-size window as it slides through an array. A deque can be used to solve this problem efficiently.\n\n```javascript\nfunction maxSlidingWindow(nums, k) {\n    const result = [];\n    const deque = []; // Store indices\n    \n    for (let i = 0; i < nums.length; i++) {\n        // Remove elements outside the current window from the front\n        if (deque.length > 0 && deque[0] <= i - k) {\n            deque.shift();\n        }\n        \n        // Remove smaller elements from the back\n        while (deque.length > 0 && nums[deque[deque.length - 1]] < nums[i]) {\n            deque.pop();\n        }\n        \n        // Add current element's index\n        deque.push(i);\n        \n        // Add to result if we've reached window size\n        if (i >= k - 1) {\n            result.push(nums[deque[0]]);\n        }\n    }\n    \n    return result;\n}\n\n// Example\nconsole.log(maxSlidingWindow([1, 3, -1, -3, 5, 3, 6, 7], 3)); \n// Output: [3, 3, 5, 5, 6, 7]\n```\n\n## Time and Space Complexity\n\nFor a queue implemented using either an array or a linked list:\n\n| Operation | Time Complexity (Array) | Time Complexity (Linked List) | Space Complexity |\n|-----------|-------------------------|-------------------------------|------------------|\n| Enqueue   | O(1)                    | O(1)                          | O(1)             |\n| Dequeue   | O(n) [simple], O(1) [circular] | O(1)                   | O(1)             |\n| Front     | O(1)                    | O(1)                          | O(1)             |\n| isEmpty   | O(1)                    | O(1)                          | O(1)             |\n\nNote: In a simple array-based queue, the dequeue operation is O(n) because all elements need to be shifted after removing the front element. In a circular queue, this operation becomes O(1).\n\n## Advantages and Disadvantages\n\n### Array Implementation\n\n**Advantages:**\n- Simple implementation for basic queues\n- Memory efficient as no extra pointers are needed\n- Good cache locality\n\n**Disadvantages:**\n- Fixed size in many languages, limiting the queue capacity\n- Dequeue operation is O(n) in a simple queue (but O(1) in a circular queue)\n- May need resizing, which is expensive\n\n### Linked List Implementation\n\n**Advantages:**\n- Dynamic size that grows as needed\n- O(1) time complexity for all operations\n- No need to shift elements during dequeue\n\n**Disadvantages:**\n- Extra memory for storing pointers\n- Less cache-friendly due to non-contiguous memory allocation\n- Slightly more complex implementation\n\n## Conclusion\n\nQueues are versatile data structures with numerous applications in computing. From managing resources to implementing algorithms like BFS, queues provide an efficient way to handle data in a FIFO manner. Understanding the different types of queues and their implementations allows you to choose the most appropriate structure for your specific use case. Whether using a simple queue, circular queue, priority queue, or deque, the fundamental FIFO principle remains a powerful concept in algorithm design and problem-solving.	\N	150
\.


--
-- Data for Name: user_question_progress; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_question_progress (id, user_id, question_id, is_passed, duration_sec, status, updated_at) FROM stdin;
2	\N	C1.1	t	0	completed	2025-07-03 12:19:20.236457
3	\N	C1.2	t	0	completed	2025-07-03 12:19:24.04701
4	\N	C1.3	t	0	completed	2025-07-03 12:19:25.550536
5	\N	C1.1	t	0	completed	2025-07-03 12:19:50.950042
6	\N	C1.2	t	2	completed	2025-07-03 12:20:01.405685
7	\N	C1.3	t	3	completed	2025-07-03 12:20:06.171947
8	\N	C1.1	t	0	completed	2025-07-03 12:41:14.944435
9	\N	C1.2	t	0	completed	2025-07-03 12:41:18.834128
10	\N	C1.3	t	0	completed	2025-07-03 12:41:21.154256
11	\N	C1.1	t	0	completed	2025-07-03 12:43:42.968365
12	\N	C1.2	t	0	completed	2025-07-03 12:43:45.12999
13	\N	C1.3	t	0	completed	2025-07-03 12:43:46.419145
14	\N	C1.1	t	0	completed	2025-07-03 12:46:56.142239
15	\N	C1.2	t	0	completed	2025-07-03 12:47:05.226971
16	\N	C1.3	t	0	completed	2025-07-03 12:47:08.631225
17	\N	C1.1	t	0	completed	2025-07-03 12:51:59.685352
18	\N	C1.2	t	0	completed	2025-07-03 12:52:03.15009
19	\N	C1.3	t	0	completed	2025-07-03 12:52:04.921982
35	9	C1.1	t	5	completed	2025-07-05 13:58:34.634334
36	9	C1.2	t	0	completed	2025-07-05 13:58:45.241779
37	9	C1.3	t	0	completed	2025-07-05 13:58:48.843394
\.


--
-- Data for Name: user_topic_progress; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_topic_progress (id, user_id, topic_id, status, completed_at) FROM stdin;
12	9	1	completed	2025-07-05 13:59:09.93095
\.


--
-- Data for Name: user_total_xp; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_total_xp (user_id, email, total_xp) FROM stdin;
8	pranavsinha499@gmail.com	0
9	pranavsinha922@gmail.com	100
\.


--
-- Data for Name: user_xp_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_xp_log (id, user_id, source_type, source_key, xp_earned, created_at) FROM stdin;
15	9	question	C1.1	10	2025-07-05 13:58:34.641476
16	9	question	C1.2	15	2025-07-05 13:58:45.249187
17	9	question	C1.3	25	2025-07-05 13:58:48.849881
18	9	question	1	50	2025-07-05 13:59:09.939423
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, email, password, firebase_uid, profile_picture) FROM stdin;
8	Penguin5681	pranavsinha499@gmail.com	$2b$10$q1QCJh3sjxpQddE.ckT0MeybY2bLRf.d4ave0qADY91OOPuWO8rRq	\N	\N
9	thechillguy69	pranavsinha922@gmail.com	$2b$10$gYB.EMpY8vWAXAFZJE3Zsuc5FPU8nEGUPrlKGsZ6zwfg46NynAuo2	\N	\N
\.


--
-- Name: coding_problem_testcases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.coding_problem_testcases_id_seq', 27, true);


--
-- Name: problem_topics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.problem_topics_id_seq', 6, true);


--
-- Name: submissions_submission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.submissions_submission_id_seq', 34, true);


--
-- Name: teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.teams_id_seq', 2, true);


--
-- Name: topic_code_examples_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.topic_code_examples_id_seq', 40, true);


--
-- Name: user_question_progress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_question_progress_id_seq', 37, true);


--
-- Name: user_topic_progress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_topic_progress_id_seq', 12, true);


--
-- Name: user_xp_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_xp_log_id_seq', 18, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 9, true);


--
-- Name: coding_problem_testcases coding_problem_testcases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coding_problem_testcases
    ADD CONSTRAINT coding_problem_testcases_pkey PRIMARY KEY (id);


--
-- Name: coding_problem_topics coding_problem_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coding_problem_topics
    ADD CONSTRAINT coding_problem_topics_pkey PRIMARY KEY (problem_id, topic_id);


--
-- Name: coding_problems coding_problems_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coding_problems
    ADD CONSTRAINT coding_problems_pkey PRIMARY KEY (id);


--
-- Name: mcqs mcqs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mcqs
    ADD CONSTRAINT mcqs_pkey PRIMARY KEY (id);


--
-- Name: problem_topics problem_topics_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problem_topics
    ADD CONSTRAINT problem_topics_name_key UNIQUE (name);


--
-- Name: problem_topics problem_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problem_topics
    ADD CONSTRAINT problem_topics_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: submissions submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (submission_id);


--
-- Name: team_members team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (user_id);


--
-- Name: teams teams_join_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_join_code_key UNIQUE (join_code);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: topic_code_examples topic_code_examples_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topic_code_examples
    ADD CONSTRAINT topic_code_examples_pkey PRIMARY KEY (id);


--
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: topics topics_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_slug_key UNIQUE (slug);


--
-- Name: user_xp_log unique_user_xp_log_entry; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_xp_log
    ADD CONSTRAINT unique_user_xp_log_entry UNIQUE (user_id, source_type, source_key);


--
-- Name: user_question_progress user_question_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_question_progress
    ADD CONSTRAINT user_question_progress_pkey PRIMARY KEY (id);


--
-- Name: user_question_progress user_question_progress_user_question_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_question_progress
    ADD CONSTRAINT user_question_progress_user_question_unique UNIQUE (user_id, question_id);


--
-- Name: user_topic_progress user_topic_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_topic_progress
    ADD CONSTRAINT user_topic_progress_pkey PRIMARY KEY (id);


--
-- Name: user_topic_progress user_topic_progress_user_topic_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_topic_progress
    ADD CONSTRAINT user_topic_progress_user_topic_unique UNIQUE (user_id, topic_id);


--
-- Name: user_total_xp user_total_xp_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_total_xp
    ADD CONSTRAINT user_total_xp_email_key UNIQUE (email);


--
-- Name: user_total_xp user_total_xp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_total_xp
    ADD CONSTRAINT user_total_xp_pkey PRIMARY KEY (user_id);


--
-- Name: user_xp_log user_xp_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_xp_log
    ADD CONSTRAINT user_xp_log_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: idx_problem_difficulty; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_problem_difficulty ON public.coding_problems USING btree (difficulty);


--
-- Name: idx_problem_topic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_problem_topic_id ON public.coding_problem_topics USING btree (topic_id);


--
-- Name: idx_submissions_problem_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_submissions_problem_user ON public.submissions USING btree (problem_id, user_id);


--
-- Name: idx_submissions_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_submissions_status ON public.submissions USING btree (status);


--
-- Name: idx_submissions_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_submissions_user_id ON public.submissions USING btree (user_id);


--
-- Name: idx_testcase_problem; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_testcase_problem ON public.coding_problem_testcases USING btree (problem_id);


--
-- Name: users trg_insert_user_total_xp; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_insert_user_total_xp AFTER INSERT ON public.users FOR EACH ROW EXECUTE FUNCTION public.insert_user_total_xp();


--
-- Name: user_xp_log trg_update_total_xp_on_log; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_update_total_xp_on_log AFTER INSERT ON public.user_xp_log FOR EACH ROW EXECUTE FUNCTION public.update_user_total_xp_on_log();


--
-- Name: coding_problem_testcases coding_problem_testcases_problem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coding_problem_testcases
    ADD CONSTRAINT coding_problem_testcases_problem_id_fkey FOREIGN KEY (problem_id) REFERENCES public.coding_problems(id) ON DELETE CASCADE;


--
-- Name: coding_problem_topics coding_problem_topics_problem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coding_problem_topics
    ADD CONSTRAINT coding_problem_topics_problem_id_fkey FOREIGN KEY (problem_id) REFERENCES public.coding_problems(id) ON DELETE CASCADE;


--
-- Name: coding_problem_topics coding_problem_topics_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coding_problem_topics
    ADD CONSTRAINT coding_problem_topics_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES public.problem_topics(id) ON DELETE CASCADE;


--
-- Name: submissions fk_submissions_problem; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT fk_submissions_problem FOREIGN KEY (problem_id) REFERENCES public.coding_problems(id) ON DELETE CASCADE;


--
-- Name: mcqs mcqs_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mcqs
    ADD CONSTRAINT mcqs_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE CASCADE;


--
-- Name: questions questions_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE CASCADE;


--
-- Name: team_members team_members_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- Name: team_members team_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: teams teams_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: topic_code_examples topic_code_examples_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topic_code_examples
    ADD CONSTRAINT topic_code_examples_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE CASCADE;


--
-- Name: user_question_progress user_question_progress_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_question_progress
    ADD CONSTRAINT user_question_progress_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- Name: user_question_progress user_question_progress_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_question_progress
    ADD CONSTRAINT user_question_progress_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_topic_progress user_topic_progress_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_topic_progress
    ADD CONSTRAINT user_topic_progress_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES public.topics(id);


--
-- Name: user_topic_progress user_topic_progress_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_topic_progress
    ADD CONSTRAINT user_topic_progress_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_total_xp user_total_xp_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_total_xp
    ADD CONSTRAINT user_total_xp_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_xp_log user_xp_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_xp_log
    ADD CONSTRAINT user_xp_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

