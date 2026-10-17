# BizChat

### Professional Communication, Powered by Real-Time Messaging and AI

BizChat is a professional messaging application designed to help business professionals, teams, and entrepreneurs communicate efficiently.

The platform combines real-time messaging, secure authentication, file sharing, user presence, and AI-assisted communication in a single application.

BizChat is being developed with Flutter for mobile applications and Django REST Framework for its backend.

---

## Table of Contents

1. Project Overview
2. Project Objectives
3. Features
4. Technology Stack
5. System Architecture
6. Project Structure
7. Database Design
8. Authentication and Security
9. Real-Time Messaging
10. AI Integration
11. Development Setup
12. Environment Variables
13. API Documentation
14. Testing
15. Branching Strategy
16. Development Roadmap
17. Deployment
18. Contributing
19. License

---

## 1. Project Overview

**Project Name:** BizChat

**Project Type:** Professional Messaging and Collaboration Platform

**Target Users:**

- Business professionals
- Entrepreneurs
- Freelancers
- Small and medium-sized businesses
- Professional teams

### Project Description

BizChat is a mobile-first communication platform designed to provide reliable, secure, and intelligent messaging for professional users.

The application enables users to communicate through private conversations, share files, manage their profiles, and maintain an active professional presence.

AI-powered features will assist users in composing messages, generating suggested replies, and improving communication.

The platform is designed with a modular architecture that supports future integrations, additional communication features, and scalable deployment.

### Project Vision

To build a reliable professional communication platform that combines the simplicity of messaging applications with the productivity tools required by modern businesses.

---

## 2. Project Objectives

The primary objectives of BizChat are:

1. Provide fast and reliable real-time messaging.
2. Enable users to securely register, authenticate, and manage their accounts.
3. Support private conversations and persistent chat history.
4. Allow users to share documents, images, and other supported files.
5. Provide AI-assisted message composition and reply suggestions.
6. Display user availability and online presence.
7. Maintain a modular, maintainable, and scalable backend architecture.
8. Establish a foundation for future team collaboration and business integrations.

---

## 3. Features

Features are organized according to their development priority.

### 3.1 Core Features

#### User Authentication

- User registration using first & last name, email and password.
- Secure login and logout.
- Token-based authentication.
- Account profile management.
- OAuth authentication integration, such as Google Sign-In.
- Password reset and account recovery.

#### Real-Time Messaging

- Private conversations between users.
- Real-time message delivery.
- Persistent message history.
- Message timestamps.
- Conversation previews.
- Message delivery and read status, where supported.

#### User Profiles

- Display name and profile picture.
- User information and professional details.
- Online and offline presence.
- Last-seen information, subject to user privacy settings.

#### File Sharing

- Upload and share supported files.
- Share images and documents within conversations.
- Store file metadata and access permissions.
- Validate file types and sizes.

### 3.2 AI-Assisted Features

#### Smart Reply Suggestions

Generate suggested responses based on recent conversation context.

Users can review, edit, and send suggested replies.

#### AI Message Composition

Help users draft professional messages, improve wording, and adjust tone.

#### AI Communication Assistance

Provide optional writing assistance, including:

- Grammar and clarity suggestions.
- Professional tone adjustments.
- Message summarization.

AI functionality will be introduced incrementally and will depend on the selected AI provider or model.

### 3.3 Advanced Features

The following features are planned for later development:

- Group conversations.
- Team workspaces.
- AI-assisted professional networking recommendations.
- Administrative analytics dashboard.
- Message search and filtering.
- Push notifications.
- Message editing and deletion.
- Organization-level account management.

These features are not considered complete until implemented and tested.

---

## 4. Technology Stack

| Component               | Technology                                            | Purpose                                            |
| ----------------------- | ----------------------------------------------------- | -------------------------------------------------- |
| Mobile frontend         | Flutter                                               | Cross-platform Android and iOS application         |
| Programming language    | Dart                                                  | Flutter application development                    |
| Backend framework       | Django                                                | Core backend and business logic                    |
| REST API                | Django REST Framework                                 | API endpoints and serialization                    |
| Real-time communication | Django Channels                                       | WebSocket connections and messaging                |
| Database                | PostgreSQL                                            | Persistent application data                        |
| Channel layer           | Redis                                                 | Real-time event distribution                       |
| Authentication          | Django authentication and JWT                         | User authentication and API authorization          |
| AI integration          | Python and an LLM API or model                        | AI-powered communication assistance                |
| Containerization        | Docker                                                | Consistent development and deployment environments |
| Orchestration           | Docker Compose                                        | Local multi-service development                    |
| Testing                 | Django TestCase, DRF APIClient, Flutter testing tools | Automated testing                                  |
| CI/CD                   | GitHub Actions or an equivalent service               | Automated testing and deployment                   |

### Technology Notes

- PostgreSQL is the primary persistent database.
- Redis is used for the Django Channels channel layer. It is not a replacement for PostgreSQL.
- Django REST Framework handles standard HTTP requests.
- Django Channels handles WebSocket connections and real-time events.
- Flutter communicates with the backend through REST APIs and WebSockets.
- AI functionality may be implemented in a dedicated backend module initially. A separate AI service can be introduced if the project later requires it.

---

## 5. System Architecture

BizChat follows a client-server architecture.

### Architecture Overview

```text
                    BIZCHAT MOBILE APPLICATION
                           Flutter / Dart
                                |
                 +--------------+--------------+
                 |                             |
             REST API                     WebSocket
                 |                             |
                 v                             v
       Django REST Framework            Django Channels
                 |                             |
                 +--------------+--------------+
                                |
                       Django Backend
                                |
                +---------------+---------------+
                |               |               |
                v               v               v
           PostgreSQL         Redis         AI Service
          Persistent DB    Channel Layer
```

### Component Responsibilities

**Flutter Application**

Provides the mobile interface, handles user interactions, and communicates with backend APIs.

**Django REST Framework**

Provides endpoints for authentication, profiles, conversations, message history, file uploads, and other application resources.

**Django Channels**

Maintains WebSocket connections and supports real-time message delivery.

**PostgreSQL**

Stores users, conversations, messages, file metadata, and other persistent application data.

**Redis**

Supports real-time communication through the Channels channel layer.

**AI Integration**

Processes permitted conversation context and returns suggestions or other AI-generated assistance.

### Message Flow

A typical messaging workflow:

1. A user opens a conversation in the Flutter application.
2. The application establishes an authenticated WebSocket connection.
3. The user sends a message.
4. The backend validates the user's identity and conversation permissions.
5. The message is stored in PostgreSQL.
6. Django Channels distributes the event to authorized connected participants.
7. The receiving user's application displays the message.
8. The message remains available through the conversation history API.

Messages must be persisted before the backend treats them as successfully accepted.

---

## 6. Project Structure

The repository is organized into separate frontend and backend applications.

```text
BizChat/
│
├── chat/                           # Messaging and chat functionality
│   ├── migrations/                 # Database migrations
│   ├── admin.py                    # Django admin configuration
│   ├── apps.py                     # Chat application configuration
│   ├── consumers.py                # WebSocket message consumers
│   ├── middleware.py               # Chat-related middleware
│   ├── models.py                   # Chat data models
│   ├── permissions.py              # Chat access permissions
│   ├── routing.py                  # WebSocket URL routing
│   ├── serializers.py              # API data serialization
│   ├── signals.py                  # Django model signals
│   ├── tests.py                    # Chat application tests
│   ├── urls.py                     # REST API URL routes
│   └── views.py                    # Chat API views
│
├── config/                         # Django project configuration
│   ├── cache/                      # Cache utilities
│   │   ├── cache_keys.py            # Cache key definitions
│   │   └── cache_mixins.py          # Cache-related mixins
│   │
│   ├── settings/                   # Environment-specific settings
│   │   ├── base.py                 # Shared settings
│   │   ├── dev.py                  # Development configuration
│   │   ├── loadtest.py              # Load-testing configuration
│   │   └── prod.py                 # Production configuration
│   │
│   ├── asgi.py                     # ASGI entry point
│   ├── urls.py                     # Main URL configuration
│   └── wsgi.py                     # WSGI entry point
│
├── user/                           # User accounts and profiles
│   ├── migrations/                 # User database migrations
│   ├── tests/                      # User application tests
│   │   ├── test_auth.py             # Authentication tests
│   │   └── tests_profile.py         # Profile tests
│   │
│   ├── views/                      # User API views
│   │   ├── auth_views.py            # Authentication endpoints
│   │   └── profile_view.py           # Profile endpoints
│   │
│   ├── admin.py                    # User admin configuration
│   ├── apps.py                     # User application configuration
│   ├── models.py                   # User and profile models
│   ├── permissions.py              # User access permissions
│   ├── serializer.py               # User data serialization
│   ├── signals.py                  # User-related signals
│   ├── task.py                     # User-related background tasks
│   ├── urls.py                     # User API routes
│   └── utils.py                    # User utility functions
│
├── media/                          # Locally stored uploaded media
│   └── avatar/                     # User profile images
│
├── .dockerignore                   # Files excluded from Docker builds
├── .env                            # Local environment configuration
├── .gitignore                      # Git exclusion rules
├── build.sh                        # Build script
├── db.sqlite3                      # Local SQLite development database
├── docker-compose.yml              # Development Docker configuration
├── docker-compose.prod.yml         # Production Docker configuration
├── Dockerfile                      # Backend container definition
├── folder_map.txt                  # Repository structure reference
├── manage.py                       # Django management utility
└── requirements.txt                # Python dependencies
```

The structure is a recommended starting point. Directories should be added as their corresponding features are implemented.

---

## 7. Database Design

The database will use PostgreSQL and Django's ORM.

The following entities represent the proposed initial data model.

### User

Represents a registered BizChat user.

Suggested fields:

- `id`
- `email`
- `password`
- `display_name`
- `profile_picture`
- `bio`
- `created_at`
- `updated_at`

Django's authentication model will handle password hashing and account authentication.

A custom user model should be configured before the first production database migration.

### Conversation

Represents a private or group conversation.

Suggested fields:

- `id`
- `conversation_type`
- `created_at`
- `updated_at`

Conversation participants should be represented through a membership model.

### ConversationMembership

Connects users to conversations.

Suggested fields:

- `id`
- `conversation`
- `user`
- `joined_at`
- `last_read_at`

A uniqueness constraint should prevent duplicate memberships for the same user and conversation.

### Message

Represents a message sent within a conversation.

Suggested fields:

- `id`
- `conversation`
- `sender`
- `content`
- `created_at`
- `updated_at`
- `edited_at`
- `is_deleted`

Additional fields may be introduced for delivery status, message types, and reply references.

### Attachment

Represents a file shared within a conversation.

Suggested fields:

- `id`
- `message`
- `file`
- `original_filename`
- `content_type`
- `file_size`
- `created_at`

Uploaded files should be stored in a suitable file-storage service rather than directly in PostgreSQL.

### Important Data Rules

- Only conversation participants may access its messages.
- A message sender must be an authorized participant.
- Attachments must be associated with authorized messages.
- Message history should be paginated.
- Database indexes should be added for frequently queried fields, including conversation IDs and message timestamps.

The exact model definitions will be finalized during backend implementation.

---

## 8. Authentication and Security

Security is a core requirement of BizChat.

### Authentication

The backend will support:

- Email-based registration and login.
- Secure password hashing through Django.
- Token-based API authentication.
- Authentication for protected REST endpoints.
- Authentication and authorization for WebSocket connections.
- OAuth integration where required.

The authentication implementation must define how access tokens are issued, refreshed, expired, and revoked.

### Authorization

Authentication confirms a user's identity. Authorization determines what the user is allowed to access.

BizChat must enforce authorization at the backend level.

For example:

- Users may access only conversations they belong to.
- Users may not impersonate another message sender.
- Users may not download attachments without permission.
- Administrative operations must require appropriate privileges.

### Encryption

BizChat will use HTTPS and secure WebSocket connections (WSS) in production.

Passwords will be hashed using Django's supported password-hashing mechanisms.

Sensitive credentials, API keys, and database passwords must not be committed to Git.

### End-to-End Encryption

End-to-end encryption is a potential future enhancement.

Transport encryption alone does not mean that messages are end-to-end encrypted.

If end-to-end encryption is introduced, the project will need a dedicated cryptographic design covering key management, device identity, message encryption, recovery, and the implications for server-side AI processing.

---

## 9. Real-Time Messaging

Real-time communication will be implemented using Django Channels.

### WebSocket Responsibilities

- Establish authenticated connections.
- Join authorized conversation groups.
- Receive message events.
- Deliver messages to connected participants.
- Handle connection and disconnection events.
- Support presence updates.

### Proposed WebSocket Events

| Event              | Purpose                                 |
| ------------------ | --------------------------------------- |
| `message.send`     | Client submits a message                |
| `message.created`  | Server confirms a newly created message |
| `message.updated`  | Server reports an edited message        |
| `message.deleted`  | Server reports a deleted message        |
| `message.read`     | Client reports a read event             |
| `presence.updated` | Server reports a presence change        |

These are proposed event names. The final WebSocket protocol should be documented in `docs/api.md`.

### Reliability Requirements

The implementation should consider:

- Reconnection after network interruptions.
- Message history synchronization.
- Duplicate-message prevention.
- Message ordering.
- Authorization of every conversation event.
- Delivery to users who are temporarily offline.

WebSocket delivery alone does not guarantee that a message was received or read. These states should be tracked separately where the application requires them.

---

## 10. AI Integration

AI features will be implemented as backend services.

### Initial AI Workflow

1. The user requests an AI-assisted reply.
2. The backend verifies that the user can access the conversation.
3. The backend selects the relevant conversation context.
4. The AI service generates suggested text.
5. The backend returns the suggestions to the client.
6. The user reviews, edits, and sends the selected suggestion.

### AI Service Responsibilities

The AI integration should:

- Keep provider credentials on the backend.
- Limit the amount of conversation context sent to the model.
- Avoid sending unrelated private conversations.
- Handle provider errors and rate limits.
- Validate and safely display generated content.
- Allow users to choose whether to use a suggestion.

### Privacy Considerations

AI providers may process information sent to their services.

Before enabling AI features, BizChat must establish:

- What conversation data is transmitted.
- Which AI provider receives it.
- How data is retained or processed by the provider.
- Whether users can disable AI assistance.
- Whether organizational administrators can control AI access.

AI-generated content should not be represented as guaranteed accurate or safe.

---

## 11. Development Setup

### Prerequisites

Install the following tools before starting development:

- Git
- Docker Desktop
- Flutter SDK
- Dart SDK (included with Flutter)
- Android Studio or another supported Flutter development environment
- A code editor, such as Visual Studio Code

Docker Desktop should be running before executing Docker Compose commands.

### Step 1: Clone the Repository

```bash
git clone <YOUR_BIZCHAT_REPOSITORY_URL>
cd BizChat
```

Replace the placeholder with the actual repository URL.

### Step 2: Configure Environment Variables

Create a local environment file from the provided example.

```bash
cp .env.example .env
```

On Windows PowerShell, you can also run:

```powershell
Copy-Item .env.example .env
```

Update the values in `.env` for your local environment.

Do not commit the populated `.env` file.

### Step 3: Start the Backend Services

From the repository root, run:

```bash
docker compose up --build
```

This command builds and starts the services defined in `compose.yaml`.

The Compose configuration should include the Django backend, PostgreSQL, and Redis.

### Step 4: Apply Database Migrations

If migrations are not applied automatically by the development configuration, run:

```bash
docker compose exec backend python manage.py migrate
```

The service name `backend` must match the name defined in `compose.yaml`.

### Step 5: Create a Development Administrator

```bash
docker compose exec backend python manage.py createsuperuser
```

Follow the prompts to create an administrator account.

### Step 6: Open the Backend

Visit:

http://127.0.0.1:8000/

The root URL may display a landing page, API response, or documentation page depending on the backend's URL configuration.

For API testing, use the documented API endpoints or the configured API documentation interface.

### Step 7: Run the Flutter Application

Open a separate terminal:

```bash
cd bizchat_frontend
flutter pub get
flutter run
```

Select an available emulator, simulator, or connected device.

### Connecting Flutter to Django

The correct backend URL depends on where Flutter is running.

Examples:

- Android emulator: `http://10.0.2.2:8000`
- Flutter Web running on the same development computer: `http://127.0.0.1:8000`
- Physical mobile device: use the development computer's reachable local network address.

Production applications must use HTTPS and WSS.

---

## 12. Environment Variables

The project should provide an `.env.example` file containing the required configuration.

Example:

```dotenv
# Django
DJANGO_SECRET_KEY=replace-with-a-development-secret
DJANGO_DEBUG=True
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1

# PostgreSQL
POSTGRES_DB=bizchat
POSTGRES_USER=bizchat_user
POSTGRES_PASSWORD=replace-with-a-local-password
POSTGRES_HOST=db
POSTGRES_PORT=5432

# Redis
REDIS_URL=redis://redis:6379/0

# AI integration
AI_API_KEY=
AI_MODEL=

# Optional OAuth configuration
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
```

The actual variable names must match the backend settings.

### Environment Security

- Never commit production secrets.
- Use a strong production Django secret key.
- Disable Django debug mode in production.
- Restrict allowed hosts.
- Use appropriate database credentials.
- Store AI and OAuth credentials securely.

---

## 13. API Documentation

BizChat will expose REST APIs for application resources.

The initial API categories are:

| Category       | Responsibility                                |
| -------------- | --------------------------------------------- |
| Authentication | Registration, login, logout, token management |
| Users          | Profiles and account management               |
| Conversations  | Create and retrieve conversations             |
| Messages       | Message history and message operations        |
| Attachments    | File uploads and access                       |
| AI             | Suggested replies and message assistance      |

### Proposed API Routes

```text
/api/user/register/
/api/user/login/
/api/user/logout/

/api/users/me/
/api/users/<user_id>/

/api/chat_list/
/api/conversations/<conversation_id>/

/api/chat_list/messages/

/api/attachments/

/api/ai/suggest-replies/
```

The project should document:

- HTTP methods.
- Request and response formats.
- Authentication requirements.
- Permission rules.
- Validation errors.
- Pagination.
- WebSocket connection details.

API documentation may be provided through OpenAPI and Swagger UI using a compatible Django REST Framework documentation package.

---

## 14. Testing

Testing is required before features are merged into the integration branch.

### Backend Testing

Use Django's testing framework and Django REST Framework's API testing tools.

Test:

- User registration and authentication.
- API validation.
- Conversation creation.
- Conversation membership permissions.
- Message persistence.
- Message retrieval and pagination.
- WebSocket authentication and authorization.
- File upload restrictions.
- AI service error handling.

Run backend tests with:

```bash
docker compose exec backend python manage.py test
```

### Flutter Testing

Flutter tests should cover:

- Widget behavior.
- Authentication flows.
- API service behavior.
- Message display.
- WebSocket connection states.
- Error and loading states.

Run Flutter tests with:

```bash
cd bizchat_frontend
flutter test
```

### Integration Testing

Integration tests should verify that the frontend and backend work together.

Important scenarios include:

1. Register a user and log in.
2. Create or open a conversation.
3. Send a message.
4. Receive the message through WebSocket.
5. Retrieve the message from the REST API.
6. Verify that unauthorized users cannot access the conversation.

---

## 15. Branching Strategy

BizChat follows a feature-branch workflow.

### Main Branches

| Branch                   | Purpose                                   |
| ------------------------ | ----------------------------------------- |
| `main`                   | Stable, production-ready code             |
| `develop`                | Integration branch for completed features |
| `feature/<feature-name>` | Development of individual features        |
| `fix/<issue-name>`       | Bug fixes                                 |
| `release/<version>`      | Release preparation, when required        |

### Workflow

1. Start from the latest `develop` branch.
2. Create a feature branch.
3. Implement the feature.
4. Add appropriate tests.
5. Run the relevant test suite.
6. Open a pull request into `develop`.
7. Review and resolve feedback.
8. Merge after the feature passes the project's checks.
9. Merge tested release code into `main` when ready.

### Example

```bash
git checkout develop
git pull origin develop

git checkout -b feature/real-time-messaging
```

After implementation:

```bash
git add .
git commit -m "feat: implement real-time messaging"

git push -u origin feature/real-time-messaging
```

Open a pull request targeting `develop`.

### Commit Guidelines

Use clear, descriptive commit messages.

Examples:

```text
feat: add user registration
feat: implement WebSocket messaging
feat: add AI reply suggestions
fix: prevent unauthorized conversation access
test: add message permission tests
docs: update development setup
```

---

## 16. Development Roadmap

BizChat will be developed incrementally.

### Phase 1 — Project Foundation

- Initialize Django backend.
- Initialize Flutter frontend.
- Configure PostgreSQL.
- Configure Docker Compose.
- Establish environment configuration.
- Set up Git branches and repository documentation.

### Phase 2 — Authentication and Profiles

- Implement the custom user model.
- Implement registration and login.
- Configure token authentication.
- Implement account management.
- Build Flutter authentication screens.
- Implement profile management.

### Phase 3 — Core Messaging

- Create conversation and membership models.
- Implement REST APIs for conversations.
- Implement message persistence.
- Configure Django Channels and Redis.
- Implement WebSocket authentication.
- Build Flutter conversation screens.
- Implement real-time message delivery.

### Phase 4 — File Sharing and Presence

- Implement attachment uploads.
- Add file access permissions.
- Implement online presence.
- Add message delivery and read states.
- Improve reconnection and synchronization.

### Phase 5 — AI Assistance

- Integrate an AI provider.
- Implement suggested replies.
- Add AI-assisted message composition.
- Add privacy controls and error handling.
- Test AI service integration.

### Phase 6 — Quality and Deployment

- Expand automated test coverage.
- Review security and permissions.
- Improve performance.
- Configure production deployment.
- Set up CI/CD.
- Prepare a stable release.

The roadmap may change as technical requirements and user feedback evolve.

---

## 17. Deployment

The production environment should be separated from the local development environment.

### Production Requirements

- A production-ready Django ASGI deployment.
- PostgreSQL database hosting.
- Redis hosting.
- HTTPS and secure WebSocket support.
- Secure file storage.
- Environment-based configuration.
- Database backups.
- Error monitoring and logging.
- Automated testing and deployment.

### Deployment Options

Potential hosting platforms include:

- AWS
- Google Cloud Platform
- Microsoft Azure
- Other providers supporting Django, PostgreSQL, Redis, and WebSockets.

The final hosting platform will be selected based on reliability, cost, operational complexity, and expected traffic.

### Deployment Checklist

Before a production release:

- Disable Django debug mode.
- Configure allowed hosts.
- Configure HTTPS.
- Configure secure WebSocket connections.
- Verify authentication and authorization.
- Apply database migrations.
- Configure persistent file storage.
- Set up backups and monitoring.
- Run automated tests.
- Verify production environment variables.

---

## 18. Contributing

Contributions are welcome.

Before contributing:

1. Review the project documentation.
2. Create a feature branch.
3. Follow the existing code style.
4. Add tests for new functionality.
5. Update documentation when necessary.
6. Submit a pull request into `develop`.

All contributions should prioritize maintainability, security, and a reliable user experience.

---

## 19. License

---

## Project Status

BizChat is under development.

The features and architecture described in this document represent the project's intended direction. Individual features should be considered complete only after implementation, testing, and documentation.
