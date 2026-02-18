# Willy N' Gang - Discovering Early Hollywood

## Project Overview

Willy N' Gang - Discovering Early Hollywood...

This repository is a fork of a previous team's work, [Recovering Early Hollywood](https://github.com/gabrielfitzpatrickcs/CrashTestDummies-RecoveringEarlyHollywood). 

## Team Members

### Current Members
- Samuel Backer (Client/Project Lead)
- Xander Dufour (Developer, Client Liaison)
- Liam Hillery (Developer)
- Vincent Lin (Developer)
- Patrick Storer (Developer)
- Caleb Thurston (Developer)

### Previous Members
- Samuel Backer (Client/Project Lead)
- Gabriel Fitzpatrick (Developer)
- Aspyn Call (Developer)
- Chimezie Ugbuaja (Developer)
- Jimmy Ocaya (Developer)
- Michael Wilkinson (Developer)

## Tech Stack & Dependencies

### Primary Technologies

- **Python** (For OCR processing and backend operations)
- **Flask** (Python micro-framework to serve the backend API)
- **LLM (TBD)** (For labelling and transcribing documents)
- **PostgreSQL** (For database creation and management)

### Python Dependencies

Ensure you have Python installed along with the following dependencies:

```
pip install flask flask-cors pytesseract pillow firebase-admin werkzeug pdf2image
```

- **Flask** (For backend API development)
- **Flask-CORS** (To enable cross-origin requests from Electron)
- **Werkzeug** (For secure file handling)

#### Poppler Requirement (For PDF Support)

The `pdf2image` library requires Poppler to be installed on your system in order to process PDF files.

**Windows:**

1. Download the latest Poppler binary from:
   https://github.com/oschwartz10612/poppler-windows/releases/
2. Extract the ZIP file to a directory, for example:
   ```
   C:\Program Files\poppler-xx\
   ```
3. Add the `bin` folder to your system's `PATH` environment variable:
   ```
   C:\Program Files\poppler-xx\bin
   ```
4. If needed, specify the path explicitly in your Flask backend:
   ```python
   images = convert_from_path(pdf_path, poppler_path=r'C:\Program Files\poppler-xx\bin')
   ```

**macOS:**

```
brew install poppler
```

**Linux (Debian/Ubuntu):**

```
sudo apt-get install poppler-utils
```

## Installation & Setup

Follow these steps to set up the project:

### 1. Clone the Repository

```
git clone https://github.com/gabrielfitzpatrickcs/CrashTestDummies-RecoveringEarlyHollywood.git
cd CrashTestDummies-RecoveringEarlyHollywood
```

### 2. Set Up the Backend

Navigate install the required dependencies:

```
pip install -r requirements.txt
```

### 3. Start the Python Backend

```
python -m backend.app
```

The site will start running on `http://127.0.0.1:5000`.


## Testing

```bash
pip install -r requirements-dev.txt
pytest tests/ -v
```


## Features & Functionality

### Flask Backend

- Handles file uploads and OCR processing (`/process_image` route)
- Supports PDF file conversion to image pages for OCR using Poppler and pdf2image
- Stores and retrieves OCR results in Firestore (`/retrieve_image/<doc_id>` route)
- Provides document search functionality based on metadata (`/search` route)
- Manages user browsing history (`/history`, `/clear_history`, `/remove_from_history/<doc_id>` routes)

## Contributing

If you want to contribute:

1. Fork the repository
2. Create a new branch

```
git checkout -b feature-name
```

3. Make your changes and commit

```
git add .
git commit -m "Added new feature"
```

4. Push your branch

```
git push origin feature-name
```

5. Create a pull request

## License

This project is under the MIT License. See `LICENSE.txt` for details.

## Notes

- Ensure that `.env` contains correct paths and authentication information