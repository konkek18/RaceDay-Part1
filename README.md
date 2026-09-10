## RaceDay – Event Management System (Part 1)

## System Overview
RaceDay is a full-stack web platform for the South African road running, walking, and cycling community. Organisers create and manage events, categories and results, while Participants browse events, enter races and track their personal performance.

## User Roles
- **Organiser** – Creates and manages events, adds categories, captures participant results, and views all event enrolments.
- **Participant** – Registers, browses events, enters a category, views own enrolments and tracks personal results.

## Part 1 Deliverables
- **ERD** – 6 entities with primary keys, foreign keys and cardinality.
- **API Endpoint Plan** – 18 RESTful endpoints including auth, users, events, categories, enrolments, results and venues.
- **SQL Script** – Full SQL Server schema with constraints and seeded sample data.

## Setup Instructions
1. Open `docs/RaceDay_Schema.sql` in SQL Server Management Studio (SSMS).
2. Execute the entire script.
3. Verify the tables and sample data were created.

## Database Design Notes
The ERD uses a single Users table with a Role column to distinguish Organisers from Participants. This simplifies authentication while still enforcing role-based access at the API level.

## Entity Relationships Explained
- Users → Events: One Organiser can create many Events (1:M).
- Venues → Events: One Venue can host many Events (1:M).
- Events → Categories: One Event has many Categories (1:M).
- Users → Enrolments: One Participant makes many Enrolments (1:M).
- Categories → Enrolments: One Category can have many Enrolments (1:M).
- Enrolments → Results: One Enrolment produces exactly one Result (1:1).

## YouTube Walkthrough
[Watch the Part 1 walkthrough](PASTE_YOUR_YOUTUBE_LINK_HERE)
