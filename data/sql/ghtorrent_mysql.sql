-- MySQL dump 10.13  Distrib 5.7.21, for osx10.13 (x86_64)
--
-- Host: localhost    Database: ghtorrent
-- ------------------------------------------------------
-- Server version	5.7.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `commit_comments`
--

DROP TABLE IF EXISTS `commit_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `commit_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `commit_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `body` varchar(256) DEFAULT NULL,
  `line` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `comment_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `comment_id` (`comment_id`),
  KEY `commit_comments_ibfk_1` (`commit_id`),
  KEY `commit_comments_ibfk_2` (`user_id`),
  CONSTRAINT `commit_comments_ibfk_1` FOREIGN KEY (`commit_id`) REFERENCES `commits` (`id`),
  CONSTRAINT `commit_comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commit_comments`
--

LOCK TABLES `commit_comments` WRITE;
/*!40000 ALTER TABLE `commit_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `commit_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commit_parents`
--

DROP TABLE IF EXISTS `commit_parents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `commit_parents` (
  `commit_id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  KEY `commit_parents_ibfk_1` (`commit_id`),
  KEY `commit_parents_ibfk_2` (`parent_id`),
  CONSTRAINT `commit_parents_ibfk_1` FOREIGN KEY (`commit_id`) REFERENCES `commits` (`id`),
  CONSTRAINT `commit_parents_ibfk_2` FOREIGN KEY (`parent_id`) REFERENCES `commits` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commit_parents`
--

LOCK TABLES `commit_parents` WRITE;
/*!40000 ALTER TABLE `commit_parents` DISABLE KEYS */;
/*!40000 ALTER TABLE `commit_parents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commits`
--

DROP TABLE IF EXISTS `commits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `commits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sha` varchar(40) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `committer_id` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sha` (`sha`),
  KEY `commits_ibfk_1` (`author_id`),
  KEY `commits_ibfk_2` (`committer_id`),
  KEY `commits_ibfk_3` (`project_id`),
  CONSTRAINT `commits_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`),
  CONSTRAINT `commits_ibfk_2` FOREIGN KEY (`committer_id`) REFERENCES `users` (`id`),
  CONSTRAINT `commits_ibfk_3` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commits`
--

LOCK TABLES `commits` WRITE;
/*!40000 ALTER TABLE `commits` DISABLE KEYS */;
/*!40000 ALTER TABLE `commits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `followers`
--

DROP TABLE IF EXISTS `followers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `followers` (
  `follower_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`follower_id`,`user_id`),
  KEY `follower_fk2` (`user_id`),
  KEY `follower_id` (`follower_id`),
  CONSTRAINT `follower_fk1` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`),
  CONSTRAINT `follower_fk2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `followers`
--

LOCK TABLES `followers` WRITE;
/*!40000 ALTER TABLE `followers` DISABLE KEYS */;
/*!40000 ALTER TABLE `followers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue_comments`
--

DROP TABLE IF EXISTS `issue_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issue_comments` (
  `issue_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `comment_id` mediumtext NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `issue_comments_ibfk_1` (`issue_id`),
  KEY `issue_comments_ibfk_2` (`user_id`),
  CONSTRAINT `issue_comments_ibfk_1` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`id`),
  CONSTRAINT `issue_comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_comments`
--

LOCK TABLES `issue_comments` WRITE;
/*!40000 ALTER TABLE `issue_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `issue_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue_events`
--

DROP TABLE IF EXISTS `issue_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issue_events` (
  `event_id` mediumtext NOT NULL,
  `issue_id` int(11) NOT NULL,
  `actor_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `action_specific` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `issue_events_ibfk_1` (`issue_id`),
  KEY `issue_events_ibfk_2` (`actor_id`),
  CONSTRAINT `issue_events_ibfk_1` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`id`),
  CONSTRAINT `issue_events_ibfk_2` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_events`
--

LOCK TABLES `issue_events` WRITE;
/*!40000 ALTER TABLE `issue_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `issue_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue_labels`
--

DROP TABLE IF EXISTS `issue_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issue_labels` (
  `label_id` int(11) NOT NULL,
  `issue_id` int(11) NOT NULL,
  PRIMARY KEY (`issue_id`,`label_id`),
  KEY `issue_labels_ibfk_1` (`label_id`),
  CONSTRAINT `issue_labels_ibfk_1` FOREIGN KEY (`label_id`) REFERENCES `repo_labels` (`id`),
  CONSTRAINT `issue_labels_ibfk_2` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_labels`
--

LOCK TABLES `issue_labels` WRITE;
/*!40000 ALTER TABLE `issue_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `issue_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issues`
--

DROP TABLE IF EXISTS `issues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `repo_id` int(11) DEFAULT NULL,
  `reporter_id` int(11) DEFAULT NULL,
  `assignee_id` int(11) DEFAULT NULL,
  `pull_request` tinyint(1) NOT NULL,
  `pull_request_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `issue_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `issues_ibfk_1` (`repo_id`),
  KEY `issues_ibfk_2` (`reporter_id`),
  KEY `issues_ibfk_3` (`assignee_id`),
  KEY `issues_ibfk_4` (`pull_request_id`),
  CONSTRAINT `issues_ibfk_1` FOREIGN KEY (`repo_id`) REFERENCES `projects` (`id`),
  CONSTRAINT `issues_ibfk_2` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`id`),
  CONSTRAINT `issues_ibfk_3` FOREIGN KEY (`assignee_id`) REFERENCES `users` (`id`),
  CONSTRAINT `issues_ibfk_4` FOREIGN KEY (`pull_request_id`) REFERENCES `pull_requests` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issues`
--

LOCK TABLES `issues` WRITE;
/*!40000 ALTER TABLE `issues` DISABLE KEYS */;
/*!40000 ALTER TABLE `issues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organization_members`
--

DROP TABLE IF EXISTS `organization_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_members` (
  `org_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`org_id`,`user_id`),
  KEY `organization_members_ibfk_2` (`user_id`),
  CONSTRAINT `organization_members_ibfk_1` FOREIGN KEY (`org_id`) REFERENCES `users` (`id`),
  CONSTRAINT `organization_members_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organization_members`
--

LOCK TABLES `organization_members` WRITE;
/*!40000 ALTER TABLE `organization_members` DISABLE KEYS */;
/*!40000 ALTER TABLE `organization_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_commits`
--

DROP TABLE IF EXISTS `project_commits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_commits` (
  `project_id` int(11) NOT NULL DEFAULT '0',
  `commit_id` int(11) NOT NULL DEFAULT '0',
  KEY `project_commits_ibfk_1` (`project_id`),
  KEY `commit_id` (`commit_id`),
  CONSTRAINT `project_commits_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`),
  CONSTRAINT `project_commits_ibfk_2` FOREIGN KEY (`commit_id`) REFERENCES `commits` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_commits`
--

LOCK TABLES `project_commits` WRITE;
/*!40000 ALTER TABLE `project_commits` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_commits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_languages`
--

DROP TABLE IF EXISTS `project_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_languages` (
  `project_id` int(11) NOT NULL,
  `language` varchar(255) DEFAULT NULL,
  `bytes` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `project_id` (`project_id`),
  CONSTRAINT `project_languages_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_languages`
--

LOCK TABLES `project_languages` WRITE;
/*!40000 ALTER TABLE `project_languages` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_members`
--

DROP TABLE IF EXISTS `project_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_members` (
  `repo_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ext_ref_id` varchar(24) NOT NULL DEFAULT '0',
  PRIMARY KEY (`repo_id`,`user_id`),
  KEY `project_members_ibfk_2` (`user_id`),
  CONSTRAINT `project_members_ibfk_1` FOREIGN KEY (`repo_id`) REFERENCES `projects` (`id`),
  CONSTRAINT `project_members_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_members`
--

LOCK TABLES `project_members` WRITE;
/*!40000 ALTER TABLE `project_members` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_topics`
--

DROP TABLE IF EXISTS `project_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_topics` (
  `project_id` int(11) NOT NULL,
  `topic_name` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`project_id`,`topic_name`),
  CONSTRAINT `project_topics_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_topics`
--

LOCK TABLES `project_topics` WRITE;
/*!40000 ALTER TABLE `project_topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `forked_from` int(11) DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT '1970-01-01 00:00:01',
  PRIMARY KEY (`id`),
  KEY `projects_ibfk_1` (`owner_id`),
  KEY `projects_ibfk_2` (`forked_from`),
  KEY `name` (`name`),
  CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`),
  CONSTRAINT `projects_ibfk_2` FOREIGN KEY (`forked_from`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pull_request_comments`
--

DROP TABLE IF EXISTS `pull_request_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pull_request_comments` (
  `pull_request_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `comment_id` mediumtext NOT NULL,
  `position` int(11) DEFAULT NULL,
  `body` varchar(256) DEFAULT NULL,
  `commit_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `pull_request_comments_ibfk_1` (`pull_request_id`),
  KEY `pull_request_comments_ibfk_2` (`user_id`),
  KEY `pull_request_comments_ibfk_3` (`commit_id`),
  CONSTRAINT `pull_request_comments_ibfk_1` FOREIGN KEY (`pull_request_id`) REFERENCES `pull_requests` (`id`),
  CONSTRAINT `pull_request_comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `pull_request_comments_ibfk_3` FOREIGN KEY (`commit_id`) REFERENCES `commits` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pull_request_comments`
--

LOCK TABLES `pull_request_comments` WRITE;
/*!40000 ALTER TABLE `pull_request_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `pull_request_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pull_request_commits`
--

DROP TABLE IF EXISTS `pull_request_commits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pull_request_commits` (
  `pull_request_id` int(11) NOT NULL,
  `commit_id` int(11) NOT NULL,
  PRIMARY KEY (`pull_request_id`,`commit_id`),
  KEY `pull_request_commits_ibfk_2` (`commit_id`),
  CONSTRAINT `pull_request_commits_ibfk_1` FOREIGN KEY (`pull_request_id`) REFERENCES `pull_requests` (`id`),
  CONSTRAINT `pull_request_commits_ibfk_2` FOREIGN KEY (`commit_id`) REFERENCES `commits` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pull_request_commits`
--

LOCK TABLES `pull_request_commits` WRITE;
/*!40000 ALTER TABLE `pull_request_commits` DISABLE KEYS */;
/*!40000 ALTER TABLE `pull_request_commits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pull_request_history`
--

DROP TABLE IF EXISTS `pull_request_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pull_request_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pull_request_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `action` varchar(255) NOT NULL,
  `actor_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pull_request_history_ibfk_1` (`pull_request_id`),
  KEY `pull_request_history_ibfk_2` (`actor_id`),
  CONSTRAINT `pull_request_history_ibfk_1` FOREIGN KEY (`pull_request_id`) REFERENCES `pull_requests` (`id`),
  CONSTRAINT `pull_request_history_ibfk_2` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pull_request_history`
--

LOCK TABLES `pull_request_history` WRITE;
/*!40000 ALTER TABLE `pull_request_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `pull_request_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pull_requests`
--

DROP TABLE IF EXISTS `pull_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pull_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `head_repo_id` int(11) DEFAULT NULL,
  `base_repo_id` int(11) NOT NULL,
  `head_commit_id` int(11) DEFAULT NULL,
  `base_commit_id` int(11) NOT NULL,
  `pullreq_id` int(11) NOT NULL,
  `intra_branch` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pullreq_id` (`pullreq_id`,`base_repo_id`),
  KEY `pull_requests_ibfk_1` (`head_repo_id`),
  KEY `pull_requests_ibfk_2` (`base_repo_id`),
  KEY `pull_requests_ibfk_3` (`head_commit_id`),
  KEY `pull_requests_ibfk_4` (`base_commit_id`),
  CONSTRAINT `pull_requests_ibfk_1` FOREIGN KEY (`head_repo_id`) REFERENCES `projects` (`id`),
  CONSTRAINT `pull_requests_ibfk_2` FOREIGN KEY (`base_repo_id`) REFERENCES `projects` (`id`),
  CONSTRAINT `pull_requests_ibfk_3` FOREIGN KEY (`head_commit_id`) REFERENCES `commits` (`id`),
  CONSTRAINT `pull_requests_ibfk_4` FOREIGN KEY (`base_commit_id`) REFERENCES `commits` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pull_requests`
--

LOCK TABLES `pull_requests` WRITE;
/*!40000 ALTER TABLE `pull_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `pull_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repo_labels`
--

DROP TABLE IF EXISTS `repo_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `repo_labels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `repo_id` int(11) DEFAULT NULL,
  `name` varchar(24) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `repo_labels_ibfk_1` (`repo_id`),
  CONSTRAINT `repo_labels_ibfk_1` FOREIGN KEY (`repo_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repo_labels`
--

LOCK TABLES `repo_labels` WRITE;
/*!40000 ALTER TABLE `repo_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `repo_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repo_milestones`
--

DROP TABLE IF EXISTS `repo_milestones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `repo_milestones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `repo_id` int(11) DEFAULT NULL,
  `name` varchar(24) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `repo_milestones_ibfk_1` (`repo_id`),
  CONSTRAINT `repo_milestones_ibfk_1` FOREIGN KEY (`repo_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repo_milestones`
--

LOCK TABLES `repo_milestones` WRITE;
/*!40000 ALTER TABLE `repo_milestones` DISABLE KEYS */;
/*!40000 ALTER TABLE `repo_milestones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) NOT NULL,
  `company` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` varchar(255) NOT NULL DEFAULT 'USR',
  `fake` tinyint(1) NOT NULL DEFAULT '0',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `long` decimal(11,8) DEFAULT NULL,
  `lat` decimal(10,8) DEFAULT NULL,
  `country_code` char(3) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login` (`login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `watchers`
--

DROP TABLE IF EXISTS `watchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `watchers` (
  `repo_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`repo_id`,`user_id`),
  KEY `watchers_ibfk_2` (`user_id`),
  CONSTRAINT `watchers_ibfk_1` FOREIGN KEY (`repo_id`) REFERENCES `projects` (`id`),
  CONSTRAINT `watchers_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `watchers`
--

LOCK TABLES `watchers` WRITE;
/*!40000 ALTER TABLE `watchers` DISABLE KEYS */;
/*!40000 ALTER TABLE `watchers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-05-10 13:28:36
