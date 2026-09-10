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

  ## API Design Principles
The API follows RESTful conventions with consistent naming:
- All routes start with /api/
- Nouns are plural (events, categories, enrolments)
- HTTP methods indicate the action (GET reads, POST creates, PUT updates, DELETE removes)
- Role enforcement happens at the controller level, not just the UI

  ## SQL Script Highlights
- Uses IDENTITY(1,1) for all primary keys.
- CHECK constraints enforce valid Role, Status, Capacity, Distance and EntryFee values.
- UNIQUE constraints on Email and BibNumber prevent duplicates.
- DEFAULT GETDATE() automatically timestamps registrations and enrolments.
- Foreign keys enforce referential integrity across all relationships.
- Seed data includes 2 Organisers, 2 Participants, 3 Events, 8 Categories, 3 Enrolments and 2 Results.

  ## Role-Based Access Summary
Organisers can register, log in, browse events, and also create, edit and delete their own events. They manage the categories inside those events and capture participant results. They can view all enrolments on their events.

Participants can register, log in, and browse events. They can enrol in an event by selecting a category, view only their own enrolments, and view their own results. They cannot create or edit events, and they cannot see other participants' enrolments.

## CI/CD Pipeline
The GitHub Actions workflow lives in `.github/workflows/ci.yml`. On every push to main or master, it checks that the `/docs` folder exists and that it contains the ERD image, the endpoint plan, and the SQL script. If any of these files are missing, the build fails and turns red. When all files are present, the build passes with a green checkmark.

## Future Enhancements (Parts 2 and 3)
Part 2 will implement the API endpoints listed in the endpoint plan, with JWT authentication and role-based access enforced at the controller level.

Part 3 will build the MVC interface so Organisers and Participants can interact with the system through the browser, with the API remaining the single source of truth.

## Testing the SQL Script
1. Open SQL Server Management Studio and connect to your local instance.
2. Open the file `docs/RaceDay_Schema.sql`.
3. Press F5 to execute the entire script.
4. The Messages tab should display "Command(s) completed successfully" with no errors.
5. Run `SELECT * FROM Users;` and `SELECT * FROM Events;` to confirm the seeded data is present.

## Why a Single Users Table
Instead of separate Organiser and Participant tables, the schema uses one Users table with a Role column. This decision was made for three reasons: it simplifies login (one authentication endpoint), it avoids duplicated profile fields, and it makes role-based access a simple check on one column rather than a join across two tables.   

## Data Integrity Rules
The schema enforces data integrity at the database level: Email must be unique, BibNumber must be unique when assigned, Capacity must be greater than zero, DistanceKm and EntryFee must be non-negative, and every Status column has a CHECK constraint limiting it to a defined set of values. This prevents bad data from ever reaching the application layer.

## Naming Conventions
All tables use PascalCase singular names (Users, Events, Categories). All primary keys follow the TableNameID pattern (UserID, EventID). All foreign keys use the same name as the referenced primary key. This makes joins intuitive and reduces the chance of ambiguous column names in queries.

## Sample Event Walkthrough
A Participant named Siya Mthembu logs in, browses events, and sees the Durban City Marathon. He opens it, sees three categories, and enrols in the Full Marathon 42.2km Senior category. His enrolment is confirmed and he is assigned bib number A1234. After the race, the Organiser captures his finishing time of 03:45:22 and his positions. Siya then logs in and views his personal result.

## Why Venues Is a Separate Table
Venues are stored separately from Events because the same venue can host multiple events over time (for example, FNB Stadium could host several runs in one year). Keeping venue data in its own table avoids repeating address and capacity information and allows venue-level reporting in future versions of the system.

## One-to-One Result Relationship
Each Enrolment has at most one Result, which is why the ResultID column in the Results table references EnrolmentID with a UNIQUE constraint. This prevents duplicate results for the same race entry and mirrors how official race timing works: one runner, one bib, one final time.

## Commit History Approach
This repository was built in stages: the initial commit uploaded the finished files, the second commit added the CI/CD workflow, and subsequent commits layered in documentation directly on GitHub. Each commit represents a specific decision or explanation, not a random text change.

## Endpoint Count Justification
The endpoint plan lists 18 endpoints, covering authentication, user profile, events, categories, enrolments, results and venues. Each endpoint was chosen because it maps directly to a function that either an Organiser or a Participant needs to perform, as described in the RaceDay brief.

## Tools Used
The ERD was created using the Mermaid Live Editor and exported as PNG. The SQL script was written for SQL Server and tested in SQL Server Management Studio. The repository is hosted on GitHub with a GitHub Actions workflow for continuous validation of the docs folder.

## Author's Note
This project was completed as part of the Programming Part 1 Portfolio of Evidence for 2026. All planning documents, the ERD, the API endpoint plan and the SQL script were designed before any application code was written, in line with the brief.


## YouTube Walkthrough
[Watch the Part 1 walkthrough](PASTE_YOUR_YOUTUBE_LINK_HERE)
