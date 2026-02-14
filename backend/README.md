# Vintage Hollywood Document Archive - Flask Application

This is the Flask version of the Vintage Hollywood Document Archive website, converted from React to server-side rendering with Jinja2 templates.

## Project Structure

```
flask_app/
├── app.py                          # Main Flask application with routes
├── requirements.txt                # Python dependencies
├── templates/                      # Jinja2 templates
│   ├── base.html                  # Base template with header and auth modal
│   ├── index.html                 # Home page with search and document cards
│   ├── document_detail.html       # Detailed document view
│   ├── view_history.html          # Viewing history page
│   ├── flagged_documents.html     # Flagged documents page
│   └── documents_manager.html     # Documents manager page
└── uploads/                        # Uploaded files storage (created automatically)
```

## Features

### Pages
1. **Home Page** (`/`) - Search interface with filters and document cards
2. **Document Detail** (`/document/<id>`) - Comprehensive movie information view
3. **View History** (`/history`) - Previously viewed documents and search history
4. **Flagged Documents** (`/flagged`) - Documents with review flags and comments
5. **Documents Manager** (`/manager`) - Upload and manage documents

### Authentication
- Login and signup forms in modal dialog
- Session-based authentication
- Flash messages for user feedback

### Document Management
- Search and filter documents
- Upload documents (ZIP or individual files)
- Remove documents with confirmation
- Flag documents for review
- Download viewing history as CSV

## Installation

1. Create a virtual environment:
```bash
python -m venv venv
```

2. Activate the virtual environment:
```bash
# On Windows
venv\Scripts\activate

# On macOS/Linux
source venv/bin/activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

## Running the Application

1. Start the Flask development server:
```bash
python app.py
```

2. Open your browser and navigate to:
```
http://localhost:5000
```

## Configuration

### Secret Key
The application uses a secret key for session management. **Important:** Change the secret key in `app.py` for production use:

```python
app.secret_key = 'your-secret-key-here-change-in-production'
```

### Upload Settings
- Upload folder: `uploads/`
- Max file size: 50MB
- Allowed file types: ZIP, PDF, JSON, XML, TXT

## Routes

| Route | Method | Description |
|-------|--------|-------------|
| `/` | GET | Home page with document search |
| `/document/<id>` | GET | View document details |
| `/history` | GET | View browsing history |
| `/history/download` | GET | Download history as CSV |
| `/flagged` | GET | View flagged documents |
| `/manager` | GET | Documents manager interface |
| `/login` | POST | User login |
| `/signup` | POST | User registration |
| `/logout` | GET | User logout |
| `/upload` | POST | Upload documents |
| `/remove` | POST | Remove documents |
| `/flag/<id>` | POST | Flag a document |

## Data Storage

Currently, the application uses in-memory mock data defined in `app.py`:
- `DOCUMENTS` - List of document records
- `SEARCH_HISTORY` - User search history
- `VIEW_HISTORY` - Document viewing history

**For production**, replace these with database queries (SQLite, PostgreSQL, MySQL, etc.).

## Styling

The application uses Tailwind CSS loaded via CDN with a custom vintage Hollywood theme:
- Dark Red Header: `#8B0000`
- Cream Background: `#F5F5F0`
- Purple Titles: `#800080`
- Blue Accents: `#2B6CB0`

## Converting to Production

To prepare this application for production:

1. **Add a database**: Replace mock data with SQLAlchemy models
2. **Update secret key**: Use environment variables for sensitive data
3. **Add user authentication**: Implement proper password hashing (bcrypt)
4. **File storage**: Use cloud storage for uploaded files (AWS S3, etc.)
5. **Error handling**: Add proper error pages (404, 500)
6. **WSGI server**: Use Gunicorn or uWSGI instead of Flask dev server
7. **Environment variables**: Use python-dotenv for configuration

### Example production setup:
```bash
pip install gunicorn python-dotenv Flask-SQLAlchemy bcrypt
gunicorn -w 4 -b 0.0.0.0:8000 app:app
```

## Key Differences from React Version

1. **State Management**: Moved from React useState to Flask sessions and URL parameters
2. **Routing**: Server-side routing instead of client-side
3. **Forms**: Traditional HTML forms with POST/GET instead of controlled components
4. **Modals**: JavaScript-based modals instead of React component state
5. **Interactivity**: Vanilla JavaScript for UI interactions instead of React hooks

## Browser Compatibility

The application uses modern CSS and JavaScript features. Recommended browsers:
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## License

This is a converted version of a React application for educational purposes.
