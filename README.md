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

## YouTube Walkthrough
[Watch the Part 1 walkthrough](PASTE_YOUR_YOUTUBE_LINK_HERE)
