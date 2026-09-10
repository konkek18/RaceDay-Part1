HTTP Method	Route	Description	Role Required	Request Body	Expected Response
POST	/api/auth/register	Registers a new user.	None	{ email, password, fullName, role }	201 Created / 400 Bad Request
POST	/api/auth/login	Logs in and returns JWT token.	None	{ email, password }	200 OK { token } / 401 Unauthorized
GET	/api/users/profile	Gets logged-in user profile.	Any logged in	None	200 OK / 404 Not Found
PUT	/api/users/profile	Updates user profile.	Any logged in	{ fullName, email }	200 OK / 400 Bad Request
GET	/api/events	Lists all events.	Any logged in	None	200 OK array
GET	/api/events/{id}	Gets one event with categories.	Any logged in	None	200 OK / 404 Not Found
POST	/api/events	Creates an event.	Organiser	{ eventName, venueId, eventDate, description, status }	201 Created / 400 Bad Request
PUT	/api/events/{id}	Updates an event.	Organiser (owner)	{ eventName, venueId, eventDate, description, status }	200 OK / 403 Forbidden / 404
DELETE	/api/events/{id}	Cancels an event (soft delete).	Organiser (owner)	None	204 No Content / 403 / 404
GET	/api/categories	Lists categories (filter by event).	Any logged in	None	200 OK array
POST	/api/categories	Adds a category to an event.	Organiser (owner)	{ eventId, categoryName, distanceKm, ageGroup, entryFee }	201 Created / 403 Forbidden
GET	/api/enrolments	Gets enrolments for participant (or all for organiser).	Any logged in	None	200 OK array
POST	/api/enrolments	Enters an event category.	Participant	{ categoryId }	201 Created / 409 Conflict
PUT	/api/enrolments/{id}/cancel	Cancels an enrolment.	Participant or Organiser	None	200 OK / 403 / 404
GET	/api/results	Gets results (filter by event or participant).	Any logged in	None	200 OK array
POST	/api/results	Captures a result for an enrolment.	Organiser (owner)	{ enrolmentId, finishTime, overallPosition, categoryPosition, status }	201 Created / 403 / 404
GET	/api/venues	Lists all venues.	Any logged in	None	200 OK array
POST	/api/venues	Adds a new venue.	Organiser	{ venueName, address, city, province, capacity }	201 Created / 400 Bad Request
